Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51636 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbcEBVXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 17:23:23 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211:  add vht cap decode to debugfs.
Date: Mon,  2 May 2016 14:23:18 -0700
Message-Id: <1462224198-24154-1-git-send-email-greearb@candelatech.com> (sfid-20160502_232327_373056_D35C73E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This makes it a lot easier to understand the capabilities used
by the station:

VHT supported
cap: 0x300819b2
		MAX-MPDU-11454
		RXLDPC
		SHORT-GI-80
		TXSTBC
		RXSTBC_1
		RXSTBC_3
		SU-BEAMFORMER-CAPABLE
		SU-BEAMFORMEE-CAPABLE
		BEAMFORMEE-STS: 0x0
		SOUNDING-DIMENSIONS: 0x0
		MU-BEAMFORMER-CAPABLE
		MPDU-LENGTH-EXPONENT: 0x0
		LINK-ADAPTATION-VHT-MRQ-MFB: 0x0
		RX-ANTENNA-PATTERN
		TX-ANTENNA-PATTERN
RX MCS: fffe
TX MCS: fffe

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v2:  Fix 'RX' typo in the second antenna pattern.

 net/mac80211/debugfs_sta.c | 50 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 5d3d2ab..7e54b5b 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -292,14 +292,60 @@ STA_OPS(ht_capa);
 static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	char buf[128], *p = buf;
+	char buf[512], *p = buf;
 	struct sta_info *sta = file->private_data;
 	struct ieee80211_sta_vht_cap *vhtc = &sta->sta.vht_cap;
 
 	p += scnprintf(p, sizeof(buf) + buf - p, "VHT %ssupported\n",
 			vhtc->vht_supported ? "" : "not ");
 	if (vhtc->vht_supported) {
-		p += scnprintf(p, sizeof(buf)+buf-p, "cap: %#.8x\n", vhtc->cap);
+		p += scnprintf(p, sizeof(buf) + buf - p, "cap: %#.8x\n",
+			       vhtc->cap);
+#define PFLAG(a, b)							\
+		do {							\
+			if (vhtc->cap & IEEE80211_VHT_CAP_ ## a)	\
+				p += scnprintf(p, sizeof(buf) + buf - p, \
+					       "\t\t%s\n", b);		\
+		} while (0)
+
+		PFLAG(MAX_MPDU_LENGTH_3895, "MAX-MPDU-3895");
+		PFLAG(MAX_MPDU_LENGTH_7991, "MAX-MPDU-7991");
+		PFLAG(MAX_MPDU_LENGTH_11454, "MAX-MPDU-11454");
+		PFLAG(SUPP_CHAN_WIDTH_160MHZ, "160Mhz");
+		PFLAG(SUPP_CHAN_WIDTH_160_80PLUS80MHZ, "160-80+80Mhz");
+		PFLAG(RXLDPC, "RXLDPC");
+		PFLAG(SHORT_GI_80, "SHORT-GI-80");
+		PFLAG(SHORT_GI_160, "SHORT-GI-160");
+		PFLAG(TXSTBC, "TXSTBC");
+		PFLAG(RXSTBC_1, "RXSTBC_1");
+		PFLAG(RXSTBC_2, "RXSTBC_2");
+		PFLAG(RXSTBC_3, "RXSTBC_3");
+		PFLAG(RXSTBC_4, "RXSTBC_4");
+		PFLAG(SU_BEAMFORMER_CAPABLE, "SU-BEAMFORMER-CAPABLE");
+		PFLAG(SU_BEAMFORMEE_CAPABLE, "SU-BEAMFORMEE-CAPABLE");
+		p += scnprintf(p, sizeof(buf) + buf - p,
+			"\t\tBEAMFORMEE-STS: 0x%x\n",
+			(vhtc->cap & IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK) >>
+			IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT);
+		p += scnprintf(p, sizeof(buf) + buf - p,
+			"\t\tSOUNDING-DIMENSIONS: 0x%x\n",
+			(vhtc->cap & IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK)
+			>> IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT);
+		PFLAG(MU_BEAMFORMER_CAPABLE, "MU-BEAMFORMER-CAPABLE");
+		PFLAG(MU_BEAMFORMEE_CAPABLE, "MU-BEAMFORMEE-CAPABLE");
+		PFLAG(VHT_TXOP_PS, "TXOP-PS");
+		PFLAG(HTC_VHT, "HTC-VHT");
+		p += scnprintf(p, sizeof(buf) + buf - p,
+			"\t\tMPDU-LENGTH-EXPONENT: 0x%x\n",
+			(vhtc->cap & IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK) >>
+			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT);
+		PFLAG(VHT_LINK_ADAPTATION_VHT_UNSOL_MFB,
+		      "LINK-ADAPTATION-VHT-UNSOL-MFB");
+		p += scnprintf(p, sizeof(buf) + buf - p,
+			"\t\tLINK-ADAPTATION-VHT-MRQ-MFB: 0x%x\n",
+			(vhtc->cap & IEEE80211_VHT_CAP_VHT_LINK_ADAPTATION_VHT_MRQ_MFB) >> 26);
+		PFLAG(RX_ANTENNA_PATTERN, "RX-ANTENNA-PATTERN");
+		PFLAG(TX_ANTENNA_PATTERN, "TX-ANTENNA-PATTERN");
 
 		p += scnprintf(p, sizeof(buf)+buf-p, "RX MCS: %.4x\n",
 			       le16_to_cpu(vhtc->vht_mcs.rx_mcs_map));
-- 
2.4.3

