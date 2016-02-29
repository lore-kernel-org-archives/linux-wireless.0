Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 048/113] rtl8xxxu: Add rtl8723bu (nextgen) rx descriptor definition
Date: Mon, 29 Feb 2016 17:04:46 -0500
Message-Id: <1456783551-28315-49-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231000_673248_0D7B8BC7)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The nextgen chips use a slightly different RX descriptor format. This
adds support for the new format.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 125 +++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 5a6b223..a8a4f2b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -197,6 +197,131 @@ struct rtl8xxxu_rx_desc {
 #endif
 };
 
+struct rtl8723bu_rx_desc {
+#ifdef __LITTLE_ENDIAN
+	u32 pktlen:14;
+	u32 crc32:1;
+	u32 icverr:1;
+	u32 drvinfo_sz:4;
+	u32 security:3;
+	u32 qos:1;
+	u32 shift:2;
+	u32 phy_stats:1;
+	u32 swdec:1;
+	u32 ls:1;
+	u32 fs:1;
+	u32 eor:1;
+	u32 own:1;
+
+	u32 macid:7;
+	u32 dummy1_0:1;
+	u32 tid:4;
+	u32 dummy1_1:1;
+	u32 amsdu:1;
+	u32 rxid_match:1;
+	u32 paggr:1;
+	u32 a1fit:4;	/* 16 */
+	u32 chkerr:1;
+	u32 ipver:1;
+	u32 tcpudp:1;
+	u32 chkvld:1;
+	u32 pam:1;
+	u32 pwr:1;
+	u32 more_data:1;
+	u32 more_frag:1;
+	u32 type:2;
+	u32 mc:1;
+	u32 bc:1;
+
+	u32 seq:12;
+	u32 frag:4;
+	u32 rx_is_qos:1;	/* 16 */
+	u32 dummy2_0:1;
+	u32 wlanhd_iv_len:6;
+	u32 dummy2_1:4;
+	u32 rpt_sel:1;
+	u32 dummy2_2:3;
+
+	u32 rxmcs:7;
+	u32 dummy3_0:3;
+	u32 htc:1;
+	u32 eosp:1;
+	u32 bssidfit:2;
+	u32 dummy3_1:2;
+	u32 usb_agg_pktnum:8;	/* 16 */
+	u32 dummy3_2:5;
+	u32 pattern_match:1;
+	u32 unicast_match:1;
+	u32 magic_match:1;
+
+	u32 splcp:1;
+	u32 ldcp:1;
+	u32 stbc:1;
+	u32 dummy4_0:1;
+	u32 bw:2;
+	u32 dummy4_1:26;
+#else
+	u32 own:1;
+	u32 eor:1;
+	u32 fs:1;
+	u32 ls:1;
+	u32 swdec:1;
+	u32 phy_stats:1;
+	u32 shift:2;
+	u32 qos:1;
+	u32 security:3;
+	u32 drvinfo_sz:4;
+	u32 icverr:1;
+	u32 crc32:1;
+	u32 pktlen:14;
+
+	u32 bc:1;
+	u32 mc:1;
+	u32 type:2;
+	u32 mf:1;
+	u32 md:1;
+	u32 pwr:1;
+	u32 pam:1;
+	u32 a2fit:4;
+	u32 a1fit:4;
+	u32 faggr:1;
+	u32 paggr:1;
+	u32 amsdu:1;
+	u32 hwrsvd:4;
+	u32 tid:4;
+	u32 macid:5;
+
+	u32 dummy2_2:3;
+	u32 rpt_sel:1;
+	u32 dummy2_1:4;
+	u32 wlanhd_iv_len:6;
+	u32 dummy2_0:1;
+	u32 rx_is_qos:1;
+	u32 frag:4;		/* 16 */
+	u32 seq:12;
+
+	u32 magic_match:1;
+	u32 unicast_match:1;
+	u32 pattern_match:1;
+	u32 dummy3_2:5;
+	u32 usb_agg_pktnum:8;
+	u32 dummy3_1:2;		/* 16 */
+	u32 bssidfit:2;
+	u32 eosp:1;
+	u32 htc:1;
+	u32 dummy3_0:3;
+	u32 rxmcs:7;
+
+	u32 dumm4_1:26;
+	u32 bw:2;
+	u32 dummy4_0:1;
+	u32 stbc:1;
+	u32 ldcp:1;
+	u32 splcp:1;
+#endif
+	__le32 tsfl;
+};
+
 struct rtl8xxxu_tx_desc {
 	__le16 pkt_size;
 	u8 pkt_offset;
-- 
2.5.0

