Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2386 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab1IWAIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:15 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 02/19] staging: brcm80211: various fulmac sparse
 endianness fixes
Date: Thu, 22 Sep 2011 17:07:39 -0700
Message-ID: <1316736476-23725-3-git-send-email-frankyl@broadcom.com> (sfid-20110923_020828_579589_E9EDEB56)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    6 +++-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   23 +++++++++++---------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   19 ++++++++++-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   12 +++++-----
 4 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 443e3a8..1cbdb80 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -401,7 +401,9 @@ static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 	/* read 24 bits and return valid 17 bit addr */
 	int i;
 	u32 scratch, regdata;
-	u8 *ptr = (u8 *)&scratch;
+	__le32 scratch_le;
+	u8 *ptr = (u8 *)&scratch_le;
+
 	for (i = 0; i < 3; i++) {
 		if ((brcmf_sdioh_card_regread(sdiodev, 0, regaddr, 1,
 				&regdata)) != SUCCESS)
@@ -412,7 +414,7 @@ static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 	}
 
 	/* Only the lower 17-bits are valid */
-	scratch = le32_to_cpu(scratch);
+	scratch = le32_to_cpu(scratch_le);
 	scratch &= 0x0001FFFF;
 	return scratch;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 9919fa5..e1d7456 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -138,6 +138,8 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	struct net_device *dev;
 	struct netdev_hw_addr *ha;
 	u32 allmulti, cnt;
+	__le32 cnt_le;
+	__le32 allmulti_le;
 
 	struct brcmf_ioctl ioc;
 	char *buf, *bufp;
@@ -166,9 +168,9 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	strcpy(bufp, "mcast_list");
 	bufp += strlen("mcast_list") + 1;
 
-	cnt = cpu_to_le32(cnt);
-	memcpy(bufp, &cnt, sizeof(cnt));
-	bufp += sizeof(cnt);
+	cnt_le = cpu_to_le32(cnt);
+	memcpy(bufp, &cnt_le, sizeof(cnt));
+	bufp += sizeof(cnt_le);
 
 	netdev_for_each_mc_addr(ha, dev) {
 		if (!cnt)
@@ -205,10 +207,11 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 			  brcmf_ifname(&drvr_priv->pub, 0));
 		return;
 	}
-	allmulti = cpu_to_le32(allmulti);
+	allmulti_le = cpu_to_le32(allmulti);
 
 	if (!brcmu_mkiovar
-	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
+	    ("allmulti", (void *)&allmulti_le,
+	    sizeof(allmulti_le), buf, buflen)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
 			  (int)sizeof(allmulti), buflen);
@@ -226,7 +229,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
-			  le32_to_cpu(allmulti));
+			  le32_to_cpu(allmulti_le));
 	}
 
 	kfree(buf);
@@ -235,19 +238,19 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 		 driver does */
 
 	allmulti = (dev->flags & IFF_PROMISC) ? true : false;
-	allmulti = cpu_to_le32(allmulti);
+	allmulti_le = cpu_to_le32(allmulti);
 
 	memset(&ioc, 0, sizeof(ioc));
 	ioc.cmd = BRCMF_C_SET_PROMISC;
-	ioc.buf = &allmulti;
-	ioc.len = sizeof(allmulti);
+	ioc.buf = &allmulti_le;
+	ioc.len = sizeof(allmulti_le);
 	ioc.set = true;
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
-			  le32_to_cpu(allmulti));
+			  le32_to_cpu(allmulti_le));
 	}
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index fb9b351..57001d4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2361,8 +2361,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
 	len = (u16) (pkt->len);
-	*(u16 *) frame = cpu_to_le16(len);
-	*(((u16 *) frame) + 1) = cpu_to_le16(~len);
+	*(__le16 *) frame = cpu_to_le16(len);
+	*(((__le16 *) frame) + 1) = cpu_to_le16(~len);
 
 	/* Software tag: channel, sequence number, data offset */
 	swheader =
@@ -2917,16 +2917,17 @@ static int
 brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 {
 	u32 addr;
+	__le32 addr_le;
 	int rv;
 
 	/* Read last word in memory to determine address of
 			 sdpcm_shared structure */
-	rv = brcmf_sdbrcm_membytes(bus, false, bus->ramsize - 4, (u8 *)&addr,
+	rv = brcmf_sdbrcm_membytes(bus, false, bus->ramsize - 4, (u8 *)&addr_le,
 				   4);
 	if (rv < 0)
 		return rv;
 
-	addr = le32_to_cpu(addr);
+	addr = le32_to_cpu(addr_le);
 
 	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
 
@@ -3273,8 +3274,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
-	*(u16 *) frame = cpu_to_le16((u16) msglen);
-	*(((u16 *) frame) + 1) = cpu_to_le16(~msglen);
+	*(__le16 *) frame = cpu_to_le16((u16) msglen);
+	*(((__le16 *) frame) + 1) = cpu_to_le16(~msglen);
 
 	/* Software tag: channel, sequence number, data offset */
 	swheader =
@@ -3466,6 +3467,7 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 	u32 varaddr;
 	u8 *vbuffer;
 	u32 varsizew;
+	__le32 varsizew_le;
 #ifdef BCMDBG
 	char *nvram_ularray;
 #endif				/* BCMDBG */
@@ -3529,10 +3531,11 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 	 */
 	if (bcmerror) {
 		varsizew = 0;
+		varsizew_le = cpu_to_le32(0);
 	} else {
 		varsizew = varsize / 4;
 		varsizew = (~varsizew << 16) | (varsizew & 0x0000FFFF);
-		varsizew = cpu_to_le32(varsizew);
+		varsizew_le = cpu_to_le32(varsizew);
 	}
 
 	brcmf_dbg(INFO, "New varsize is %d, length token=0x%08x\n",
@@ -3540,7 +3543,7 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 
 	/* Write the length token to the last word */
 	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->orig_ramsize - 4),
-				    (u8 *)&varsizew, 4);
+					 (u8 *)&varsizew_le, 4);
 
 	return bcmerror;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 9e07f77..b4befec 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -378,7 +378,7 @@ brcmf_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 {
 	union {
 		s8 buf[BRCMF_C_IOCTL_SMLEN];
-		s32 val;
+		__le32 val;
 	} var;
 	u32 len;
 	u32 data_null;
@@ -890,11 +890,11 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 	/* Configure Beacon Interval for starter */
 	if (params->beacon_interval)
-		bcnprd = cpu_to_le32(params->beacon_interval);
+		bcnprd = params->beacon_interval;
 	else
-		bcnprd = cpu_to_le32(100);
+		bcnprd = 100;
 
-	err = brcmf_dev_ioctl(dev, BRCM_SET_BCNPRD, &bcnprd, sizeof(bcnprd));
+	err = brcmf_dev_ioctl_u32(dev, BRCM_SET_BCNPRD, &bcnprd);
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -2029,7 +2029,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 		goto CleanUp;
 	}
 
-	*(u32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
+	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
 	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
 	if (unlikely(err)) {
@@ -2098,7 +2098,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 
 	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg_priv, WL_PROF_SSID);
 
-	*(u32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
+	*(__le32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
 	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
 			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
 	if (unlikely(err)) {
-- 
1.7.1


