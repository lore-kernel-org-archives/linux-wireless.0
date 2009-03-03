Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35483 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbZCCRZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:47 -0500
Message-Id: <20090303172540.186281667@atheros.com> (sfid-20090303_182550_793057_8B8A8F7F)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:40 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 15/15] ath9k: Add a debugfs interface for controlling virtual wiphys
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

debugfs ath9k/phy#/wiphy can be used to show the current list of
virtual wiphys and to add/remove virtual wiphys. Eventually, this
interface could be replaced with a cfg80211/nl80211 command that is
passed through mac80211.

For example:
# cat /debug/ath9k/phy0/wiphy 
primary: phy0
# echo add > /debug/ath9k/phy0/wiphy 
# cat /debug/ath9k/phy0/wiphy 
primary: phy0
secondary: phy1
# echo del=phy1 > /debug/ath9k/phy0/wiphy 
# cat /debug/ath9k/phy0/wiphy 
primary: phy0

In addition, following commands can be used to test pausing and
unpausing of the virtual wiphys:
pause=phy1
unpause=phy1
select=phy1
(select pauses and unpauses wiphys automatically based on channel)
schedule=500
(set wiphy scheduling interval in msec; 0 = disable; default value: 500)

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/debug.c |  164 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/debug.h |    1 
 2 files changed, 165 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/debug.c	2009-02-27 10:52:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/debug.c	2009-03-03 18:33:02.000000000 +0200
@@ -330,6 +330,163 @@ static const struct file_operations fops
 	.owner = THIS_MODULE
 };
 
+static const char * ath_wiphy_state_str(enum ath_wiphy_state state)
+{
+	switch (state) {
+	case ATH_WIPHY_INACTIVE:
+		return "INACTIVE";
+	case ATH_WIPHY_ACTIVE:
+		return "ACTIVE";
+	case ATH_WIPHY_PAUSING:
+		return "PAUSING";
+	case ATH_WIPHY_PAUSED:
+		return "PAUSED";
+	case ATH_WIPHY_SCAN:
+		return "SCAN";
+	}
+	return "?";
+}
+
+static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[512];
+	unsigned int len = 0;
+	int i;
+	u8 addr[ETH_ALEN];
+
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"primary: %s (%s chan=%d ht=%d)\n",
+			wiphy_name(sc->pri_wiphy->hw->wiphy),
+			ath_wiphy_state_str(sc->pri_wiphy->state),
+			sc->pri_wiphy->chan_idx, sc->pri_wiphy->chan_is_ht);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		struct ath_wiphy *aphy = sc->sec_wiphy[i];
+		if (aphy == NULL)
+			continue;
+		len += snprintf(buf + len, sizeof(buf) - len,
+				"secondary: %s (%s chan=%d ht=%d)\n",
+				wiphy_name(aphy->hw->wiphy),
+				ath_wiphy_state_str(aphy->state),
+				aphy->chan_idx, aphy->chan_is_ht);
+	}
+
+	put_unaligned_le32(REG_READ(sc->sc_ah, AR_STA_ID0), addr);
+	put_unaligned_le16(REG_READ(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"addr: %pM\n", addr);
+	put_unaligned_le32(REG_READ(sc->sc_ah, AR_BSSMSKL), addr);
+	put_unaligned_le16(REG_READ(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"addrmask: %pM\n", addr);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static struct ath_wiphy * get_wiphy(struct ath_softc *sc, const char *name)
+{
+	int i;
+	if (strcmp(name, wiphy_name(sc->pri_wiphy->hw->wiphy)) == 0)
+		return sc->pri_wiphy;
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		struct ath_wiphy *aphy = sc->sec_wiphy[i];
+		if (aphy && strcmp(name, wiphy_name(aphy->hw->wiphy)) == 0)
+			return aphy;
+	}
+	return NULL;
+}
+
+static int del_wiphy(struct ath_softc *sc, const char *name)
+{
+	struct ath_wiphy *aphy = get_wiphy(sc, name);
+	if (!aphy)
+		return -ENOENT;
+	return ath9k_wiphy_del(aphy);
+}
+
+static int pause_wiphy(struct ath_softc *sc, const char *name)
+{
+	struct ath_wiphy *aphy = get_wiphy(sc, name);
+	if (!aphy)
+		return -ENOENT;
+	return ath9k_wiphy_pause(aphy);
+}
+
+static int unpause_wiphy(struct ath_softc *sc, const char *name)
+{
+	struct ath_wiphy *aphy = get_wiphy(sc, name);
+	if (!aphy)
+		return -ENOENT;
+	return ath9k_wiphy_unpause(aphy);
+}
+
+static int select_wiphy(struct ath_softc *sc, const char *name)
+{
+	struct ath_wiphy *aphy = get_wiphy(sc, name);
+	if (!aphy)
+		return -ENOENT;
+	return ath9k_wiphy_select(aphy);
+}
+
+static int schedule_wiphy(struct ath_softc *sc, const char *msec)
+{
+	ath9k_wiphy_set_scheduler(sc, simple_strtoul(msec, NULL, 0));
+	return 0;
+}
+
+static ssize_t write_file_wiphy(struct file *file, const char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[50];
+	size_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+	if (len > 0 && buf[len - 1] == '\n')
+		buf[len - 1] = '\0';
+
+	if (strncmp(buf, "add", 3) == 0) {
+		int res = ath9k_wiphy_add(sc);
+		if (res < 0)
+			return res;
+	} else if (strncmp(buf, "del=", 4) == 0) {
+		int res = del_wiphy(sc, buf + 4);
+		if (res < 0)
+			return res;
+	} else if (strncmp(buf, "pause=", 6) == 0) {
+		int res = pause_wiphy(sc, buf + 6);
+		if (res < 0)
+			return res;
+	} else if (strncmp(buf, "unpause=", 8) == 0) {
+		int res = unpause_wiphy(sc, buf + 8);
+		if (res < 0)
+			return res;
+	} else if (strncmp(buf, "select=", 7) == 0) {
+		int res = select_wiphy(sc, buf + 7);
+		if (res < 0)
+			return res;
+	} else if (strncmp(buf, "schedule=", 9) == 0) {
+		int res = schedule_wiphy(sc, buf + 9);
+		if (res < 0)
+			return res;
+	} else
+		return -EOPNOTSUPP;
+
+	return count;
+}
+
+static const struct file_operations fops_wiphy = {
+	.read = read_file_wiphy,
+	.write = write_file_wiphy,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
+
+
 int ath9k_init_debug(struct ath_softc *sc)
 {
 	sc->debug.debug_mask = ath9k_debug;
@@ -362,6 +519,12 @@ int ath9k_init_debug(struct ath_softc *s
 	if (!sc->debug.debugfs_rcstat)
 		goto err;
 
+	sc->debug.debugfs_wiphy = debugfs_create_file(
+		"wiphy", S_IRUGO | S_IWUSR, sc->debug.debugfs_phy, sc,
+		&fops_wiphy);
+	if (!sc->debug.debugfs_wiphy)
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(sc);
@@ -370,6 +533,7 @@ err:
 
 void ath9k_exit_debug(struct ath_softc *sc)
 {
+	debugfs_remove(sc->debug.debugfs_wiphy);
 	debugfs_remove(sc->debug.debugfs_rcstat);
 	debugfs_remove(sc->debug.debugfs_interrupt);
 	debugfs_remove(sc->debug.debugfs_dma);
--- wireless-testing.orig/drivers/net/wireless/ath9k/debug.h	2009-02-27 10:52:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/debug.h	2009-03-03 18:33:02.000000000 +0200
@@ -107,6 +107,7 @@ struct ath9k_debug {
 	struct dentry *debugfs_dma;
 	struct dentry *debugfs_interrupt;
 	struct dentry *debugfs_rcstat;
+	struct dentry *debugfs_wiphy;
 	struct ath_stats stats;
 };
 

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
