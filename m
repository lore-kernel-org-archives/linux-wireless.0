Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57352 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab1ATWjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 17:39:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 1/4] ath9k: remove the virtual wiphy debugfs interface
Date: Thu, 20 Jan 2011 23:39:11 +0100
Message-Id: <1295563154-17556-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does not make much sense to keep the current virtual wiphy implementation
any longer - it adds significant complexity, has very few users and is still
very experimental. At some point in time, it will be replaced by a proper
implementation in mac80211.

By making the code easier to read and maintain, removing virtual wiphy support
helps with fixing the remaining driver issues and adding further improvements.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |  202 --------------------------------
 1 files changed, 0 insertions(+), 202 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 3586c43..73644c4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -381,204 +381,6 @@ static const struct file_operations fops_interrupt = {
 	.llseek = default_llseek,
 };
 
-static const char * ath_wiphy_state_str(enum ath_wiphy_state state)
-{
-	switch (state) {
-	case ATH_WIPHY_INACTIVE:
-		return "INACTIVE";
-	case ATH_WIPHY_ACTIVE:
-		return "ACTIVE";
-	case ATH_WIPHY_PAUSING:
-		return "PAUSING";
-	case ATH_WIPHY_PAUSED:
-		return "PAUSED";
-	case ATH_WIPHY_SCAN:
-		return "SCAN";
-	}
-	return "?";
-}
-
-static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
-			       size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_wiphy *aphy = sc->pri_wiphy;
-	struct ieee80211_channel *chan = aphy->hw->conf.channel;
-	char buf[512];
-	unsigned int len = 0;
-	int i;
-	u8 addr[ETH_ALEN];
-	u32 tmp;
-
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"primary: %s (%s chan=%d ht=%d)\n",
-			wiphy_name(sc->pri_wiphy->hw->wiphy),
-			ath_wiphy_state_str(sc->pri_wiphy->state),
-			ieee80211_frequency_to_channel(chan->center_freq),
-			aphy->chan_is_ht);
-
-	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
-	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"addr: %pM\n", addr);
-	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_BSSMSKL), addr);
-	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"addrmask: %pM\n", addr);
-	tmp = ath9k_hw_getrxfilter(sc->sc_ah);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"rfilt: 0x%x", tmp);
-	if (tmp & ATH9K_RX_FILTER_UCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " UCAST");
-	if (tmp & ATH9K_RX_FILTER_MCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " MCAST");
-	if (tmp & ATH9K_RX_FILTER_BCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " BCAST");
-	if (tmp & ATH9K_RX_FILTER_CONTROL)
-		len += snprintf(buf + len, sizeof(buf) - len, " CONTROL");
-	if (tmp & ATH9K_RX_FILTER_BEACON)
-		len += snprintf(buf + len, sizeof(buf) - len, " BEACON");
-	if (tmp & ATH9K_RX_FILTER_PROM)
-		len += snprintf(buf + len, sizeof(buf) - len, " PROM");
-	if (tmp & ATH9K_RX_FILTER_PROBEREQ)
-		len += snprintf(buf + len, sizeof(buf) - len, " PROBEREQ");
-	if (tmp & ATH9K_RX_FILTER_PHYERR)
-		len += snprintf(buf + len, sizeof(buf) - len, " PHYERR");
-	if (tmp & ATH9K_RX_FILTER_MYBEACON)
-		len += snprintf(buf + len, sizeof(buf) - len, " MYBEACON");
-	if (tmp & ATH9K_RX_FILTER_COMP_BAR)
-		len += snprintf(buf + len, sizeof(buf) - len, " COMP_BAR");
-	if (tmp & ATH9K_RX_FILTER_PSPOLL)
-		len += snprintf(buf + len, sizeof(buf) - len, " PSPOLL");
-	if (tmp & ATH9K_RX_FILTER_PHYRADAR)
-		len += snprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
-	if (tmp & ATH9K_RX_FILTER_MCAST_BCAST_ALL)
-		len += snprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL\n");
-	else
-		len += snprintf(buf + len, sizeof(buf) - len, "\n");
-
-	/* Put variable-length stuff down here, and check for overflows. */
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy_tmp = sc->sec_wiphy[i];
-		if (aphy_tmp == NULL)
-			continue;
-		chan = aphy_tmp->hw->conf.channel;
-		len += snprintf(buf + len, sizeof(buf) - len,
-			"secondary: %s (%s chan=%d ht=%d)\n",
-			wiphy_name(aphy_tmp->hw->wiphy),
-			ath_wiphy_state_str(aphy_tmp->state),
-			ieee80211_frequency_to_channel(chan->center_freq),
-						       aphy_tmp->chan_is_ht);
-	}
-	if (len > sizeof(buf))
-		len = sizeof(buf);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
-}
-
-static struct ath_wiphy * get_wiphy(struct ath_softc *sc, const char *name)
-{
-	int i;
-	if (strcmp(name, wiphy_name(sc->pri_wiphy->hw->wiphy)) == 0)
-		return sc->pri_wiphy;
-	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (aphy && strcmp(name, wiphy_name(aphy->hw->wiphy)) == 0)
-			return aphy;
-	}
-	return NULL;
-}
-
-static int del_wiphy(struct ath_softc *sc, const char *name)
-{
-	struct ath_wiphy *aphy = get_wiphy(sc, name);
-	if (!aphy)
-		return -ENOENT;
-	return ath9k_wiphy_del(aphy);
-}
-
-static int pause_wiphy(struct ath_softc *sc, const char *name)
-{
-	struct ath_wiphy *aphy = get_wiphy(sc, name);
-	if (!aphy)
-		return -ENOENT;
-	return ath9k_wiphy_pause(aphy);
-}
-
-static int unpause_wiphy(struct ath_softc *sc, const char *name)
-{
-	struct ath_wiphy *aphy = get_wiphy(sc, name);
-	if (!aphy)
-		return -ENOENT;
-	return ath9k_wiphy_unpause(aphy);
-}
-
-static int select_wiphy(struct ath_softc *sc, const char *name)
-{
-	struct ath_wiphy *aphy = get_wiphy(sc, name);
-	if (!aphy)
-		return -ENOENT;
-	return ath9k_wiphy_select(aphy);
-}
-
-static int schedule_wiphy(struct ath_softc *sc, const char *msec)
-{
-	ath9k_wiphy_set_scheduler(sc, simple_strtoul(msec, NULL, 0));
-	return 0;
-}
-
-static ssize_t write_file_wiphy(struct file *file, const char __user *user_buf,
-				size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	char buf[50];
-	size_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-	buf[len] = '\0';
-	if (len > 0 && buf[len - 1] == '\n')
-		buf[len - 1] = '\0';
-
-	if (strncmp(buf, "add", 3) == 0) {
-		int res = ath9k_wiphy_add(sc);
-		if (res < 0)
-			return res;
-	} else if (strncmp(buf, "del=", 4) == 0) {
-		int res = del_wiphy(sc, buf + 4);
-		if (res < 0)
-			return res;
-	} else if (strncmp(buf, "pause=", 6) == 0) {
-		int res = pause_wiphy(sc, buf + 6);
-		if (res < 0)
-			return res;
-	} else if (strncmp(buf, "unpause=", 8) == 0) {
-		int res = unpause_wiphy(sc, buf + 8);
-		if (res < 0)
-			return res;
-	} else if (strncmp(buf, "select=", 7) == 0) {
-		int res = select_wiphy(sc, buf + 7);
-		if (res < 0)
-			return res;
-	} else if (strncmp(buf, "schedule=", 9) == 0) {
-		int res = schedule_wiphy(sc, buf + 9);
-		if (res < 0)
-			return res;
-	} else
-		return -EOPNOTSUPP;
-
-	return count;
-}
-
-static const struct file_operations fops_wiphy = {
-	.read = read_file_wiphy,
-	.write = write_file_wiphy,
-	.open = ath9k_debugfs_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 #define PR(str, elem)							\
 	do {								\
 		len += snprintf(buf + len, size - len,			\
@@ -895,10 +697,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc, &fops_interrupt))
 		goto err;
 
-	if (!debugfs_create_file("wiphy", S_IRUSR | S_IWUSR,
-			sc->debug.debugfs_phy, sc, &fops_wiphy))
-		goto err;
-
 	if (!debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy,
 			sc, &fops_xmit))
 		goto err;
-- 
1.7.3.2

