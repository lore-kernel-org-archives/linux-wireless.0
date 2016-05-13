Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60646 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbcEMS3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 14:29:42 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] mac80211:  add vht cap decode to debugfs.
Date: Fri, 13 May 2016 11:29:33 -0700
Message-Id: <1463164173-21804-1-git-send-email-greearb@candelatech.com> (sfid-20160513_202946_020494_FB4CD33A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This makes it a lot easier to understand the capabilities used
by the station:

VHT supported
cap: 0x300819b2
		MAX-MPDU-11454
		80Mhz
		RXLDPC
		SHORT-GI-80
		TXSTBC
		RXSTBC_1
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
v2:  Fix usage of the bitfields.
     Update comments to match new format.
 net/mac80211/debugfs_sta.c | 78 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 5d3d2ab..0b7a635 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -292,14 +292,88 @@ STA_OPS(ht_capa);
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
+		switch (vhtc->cap & 0x3) {
+		case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\tMAX-MPDU-3895\n");
+			break;
+		case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\tMAX-MPDU-7991\n");
+			break;
+		case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\tMAX-MPDU-11454\n");
+			break;
+		default:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\tMAX-MPDU-UNKNOWN\n");
+		};
+		switch (vhtc->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
+		case 0:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\t80Mhz\n");
+			break;
+		case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\t160Mhz\n");
+			break;
+		case IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\t80+80Mhz\n");
+			break;
+		default:
+			p += scnprintf(p, sizeof(buf) + buf - p,
+				       "\t\tUNKNOWN-MHZ: 0x%x\n",
+				       (vhtc->cap >> 2) & 0x3);
+		};
+		PFLAG(RXLDPC, "RXLDPC");
+		PFLAG(SHORT_GI_80, "SHORT-GI-80");
+		PFLAG(SHORT_GI_160, "SHORT-GI-160");
+		PFLAG(TXSTBC, "TXSTBC");
+		p += scnprintf(p, sizeof(buf) + buf - p,
+			       "\t\tRXSTBC_%d\n", (vhtc->cap >> 8) & 0x7);
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

