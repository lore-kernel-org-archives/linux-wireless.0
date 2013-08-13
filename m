Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2127 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758973Ab3HMUEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:04:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	"Jonas Gorski" <jogo@openwrt.org>,
	"David Herrmann" <dh.herrmann@gmail.com>,
	"Maximilian Engelhardt" <maxi@daemonizer.de>,
	"David Costa" <david@zarel.net>
Subject: [RFT V2 03/13] brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
Date: Tue, 13 Aug 2013 22:03:30 +0200
Message-ID: <1376424220-10765-4-git-send-email-arend@broadcom.com> (sfid-20130813_220440_557813_6BFC91C7)
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch converts all sizeof(x)/sizeof(x[0]) instances to
ARRAY_SIZE macro in phytbl_lcn.c. The patch was made using
spatch with ARRAY_SIZE.cocci (see [1]).

[1] https://github.com/coccinelle/coccinelle/tree/master/demos/janitorings

Cc: Jonas Gorski <jogo@openwrt.org>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: David Costa <david@zarel.net>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  117 ++++++++------------
 1 file changed, 44 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 622c01c..deae3a7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -1507,117 +1507,103 @@ static const u32 dot11lcn_gain_tbl_5G[] = {
 
 const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[] = {
 	{&dot11lcn_gain_tbl_rev0,
-	 sizeof(dot11lcn_gain_tbl_rev0) / sizeof(dot11lcn_gain_tbl_rev0[0]), 18,
+	 ARRAY_SIZE(dot11lcn_gain_tbl_rev0), 18,
 	 0, 32}
 	,
 	{&dot11lcn_aux_gain_idx_tbl_rev0,
-	 sizeof(dot11lcn_aux_gain_idx_tbl_rev0) /
-	 sizeof(dot11lcn_aux_gain_idx_tbl_rev0[0]), 14, 0, 16}
+	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_rev0), 14, 0, 16}
 	,
 	{&dot11lcn_gain_idx_tbl_rev0,
-	 sizeof(dot11lcn_gain_idx_tbl_rev0) /
-	 sizeof(dot11lcn_gain_idx_tbl_rev0[0]), 13, 0, 32}
+	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_rev0), 13, 0, 32}
 	,
 };
 
 static const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev1[] = {
 	{&dot11lcn_gain_tbl_rev1,
-	 sizeof(dot11lcn_gain_tbl_rev1) / sizeof(dot11lcn_gain_tbl_rev1[0]), 18,
+	 ARRAY_SIZE(dot11lcn_gain_tbl_rev1), 18,
 	 0, 32}
 	,
 	{&dot11lcn_aux_gain_idx_tbl_rev0,
-	 sizeof(dot11lcn_aux_gain_idx_tbl_rev0) /
-	 sizeof(dot11lcn_aux_gain_idx_tbl_rev0[0]), 14, 0, 16}
+	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_rev0), 14, 0, 16}
 	,
 	{&dot11lcn_gain_idx_tbl_rev0,
-	 sizeof(dot11lcn_gain_idx_tbl_rev0) /
-	 sizeof(dot11lcn_gain_idx_tbl_rev0[0]), 13, 0, 32}
+	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_rev0), 13, 0, 32}
 	,
 };
 
 const struct phytbl_info dot11lcnphytbl_rx_gain_info_2G_rev2[] = {
 	{&dot11lcn_gain_tbl_2G,
-	 sizeof(dot11lcn_gain_tbl_2G) / sizeof(dot11lcn_gain_tbl_2G[0]), 18, 0,
+	 ARRAY_SIZE(dot11lcn_gain_tbl_2G), 18, 0,
 	 32}
 	,
 	{&dot11lcn_aux_gain_idx_tbl_2G,
-	 sizeof(dot11lcn_aux_gain_idx_tbl_2G) /
-	 sizeof(dot11lcn_aux_gain_idx_tbl_2G[0]), 14, 0, 16}
+	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_2G), 14, 0, 16}
 	,
 	{&dot11lcn_gain_idx_tbl_2G,
-	 sizeof(dot11lcn_gain_idx_tbl_2G) / sizeof(dot11lcn_gain_idx_tbl_2G[0]),
+	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_2G),
 	 13, 0, 32}
 	,
 	{&dot11lcn_gain_val_tbl_2G,
-	 sizeof(dot11lcn_gain_val_tbl_2G) / sizeof(dot11lcn_gain_val_tbl_2G[0]),
+	 ARRAY_SIZE(dot11lcn_gain_val_tbl_2G),
 	 17, 0, 8}
 };
 
 const struct phytbl_info dot11lcnphytbl_rx_gain_info_5G_rev2[] = {
 	{&dot11lcn_gain_tbl_5G,
-	 sizeof(dot11lcn_gain_tbl_5G) / sizeof(dot11lcn_gain_tbl_5G[0]), 18, 0,
+	 ARRAY_SIZE(dot11lcn_gain_tbl_5G), 18, 0,
 	 32}
 	,
 	{&dot11lcn_aux_gain_idx_tbl_5G,
-	 sizeof(dot11lcn_aux_gain_idx_tbl_5G) /
-	 sizeof(dot11lcn_aux_gain_idx_tbl_5G[0]), 14, 0, 16}
+	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_5G), 14, 0, 16}
 	,
 	{&dot11lcn_gain_idx_tbl_5G,
-	 sizeof(dot11lcn_gain_idx_tbl_5G) / sizeof(dot11lcn_gain_idx_tbl_5G[0]),
+	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_5G),
 	 13, 0, 32}
 	,
 	{&dot11lcn_gain_val_tbl_5G,
-	 sizeof(dot11lcn_gain_val_tbl_5G) / sizeof(dot11lcn_gain_val_tbl_5G[0]),
+	 ARRAY_SIZE(dot11lcn_gain_val_tbl_5G),
 	 17, 0, 8}
 };
 
 const struct phytbl_info dot11lcnphytbl_rx_gain_info_extlna_2G_rev2[] = {
 	{&dot11lcn_gain_tbl_extlna_2G,
-	 sizeof(dot11lcn_gain_tbl_extlna_2G) /
-	 sizeof(dot11lcn_gain_tbl_extlna_2G[0]), 18, 0, 32}
+	 ARRAY_SIZE(dot11lcn_gain_tbl_extlna_2G), 18, 0, 32}
 	,
 	{&dot11lcn_aux_gain_idx_tbl_extlna_2G,
-	 sizeof(dot11lcn_aux_gain_idx_tbl_extlna_2G) /
-	 sizeof(dot11lcn_aux_gain_idx_tbl_extlna_2G[0]), 14, 0, 16}
+	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_extlna_2G), 14, 0, 16}
 	,
 	{&dot11lcn_gain_idx_tbl_extlna_2G,
-	 sizeof(dot11lcn_gain_idx_tbl_extlna_2G) /
-	 sizeof(dot11lcn_gain_idx_tbl_extlna_2G[0]), 13, 0, 32}
+	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_extlna_2G), 13, 0, 32}
 	,
 	{&dot11lcn_gain_val_tbl_extlna_2G,
-	 sizeof(dot11lcn_gain_val_tbl_extlna_2G) /
-	 sizeof(dot11lcn_gain_val_tbl_extlna_2G[0]), 17, 0, 8}
+	 ARRAY_SIZE(dot11lcn_gain_val_tbl_extlna_2G), 17, 0, 8}
 };
 
 const struct phytbl_info dot11lcnphytbl_rx_gain_info_extlna_5G_rev2[] = {
 	{&dot11lcn_gain_tbl_5G,
-	 sizeof(dot11lcn_gain_tbl_5G) / sizeof(dot11lcn_gain_tbl_5G[0]), 18, 0,
+	 ARRAY_SIZE(dot11lcn_gain_tbl_5G), 18, 0,
 	 32}
 	,
 	{&dot11lcn_aux_gain_idx_tbl_5G,
-	 sizeof(dot11lcn_aux_gain_idx_tbl_5G) /
-	 sizeof(dot11lcn_aux_gain_idx_tbl_5G[0]), 14, 0, 16}
+	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_5G), 14, 0, 16}
 	,
 	{&dot11lcn_gain_idx_tbl_5G,
-	 sizeof(dot11lcn_gain_idx_tbl_5G) / sizeof(dot11lcn_gain_idx_tbl_5G[0]),
+	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_5G),
 	 13, 0, 32}
 	,
 	{&dot11lcn_gain_val_tbl_5G,
-	 sizeof(dot11lcn_gain_val_tbl_5G) / sizeof(dot11lcn_gain_val_tbl_5G[0]),
+	 ARRAY_SIZE(dot11lcn_gain_val_tbl_5G),
 	 17, 0, 8}
 };
 
 const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
-	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
-	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
+	ARRAY_SIZE(dot11lcnphytbl_rx_gain_info_rev0);
 
 const u32 dot11lcnphytbl_rx_gain_info_2G_rev2_sz =
-	sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2) /
-	sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2[0]);
+	ARRAY_SIZE(dot11lcnphytbl_rx_gain_info_2G_rev2);
 
 const u32 dot11lcnphytbl_rx_gain_info_5G_rev2_sz =
-	sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2) /
-	sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2[0]);
+	ARRAY_SIZE(dot11lcnphytbl_rx_gain_info_5G_rev2);
 
 static const u16 dot11lcn_min_sig_sq_tbl_rev0[] = {
 	0x014d,
@@ -2771,89 +2757,74 @@ static const u32 dot11lcn_papd_compdelta_tbl_rev0[] = {
 
 const struct phytbl_info dot11lcnphytbl_info_rev0[] = {
 	{&dot11lcn_min_sig_sq_tbl_rev0,
-	 sizeof(dot11lcn_min_sig_sq_tbl_rev0) /
-	 sizeof(dot11lcn_min_sig_sq_tbl_rev0[0]), 2, 0, 16}
+	 ARRAY_SIZE(dot11lcn_min_sig_sq_tbl_rev0), 2, 0, 16}
 	,
 	{&dot11lcn_noise_scale_tbl_rev0,
-	 sizeof(dot11lcn_noise_scale_tbl_rev0) /
-	 sizeof(dot11lcn_noise_scale_tbl_rev0[0]), 1, 0, 16}
+	 ARRAY_SIZE(dot11lcn_noise_scale_tbl_rev0), 1, 0, 16}
 	,
 	{&dot11lcn_fltr_ctrl_tbl_rev0,
-	 sizeof(dot11lcn_fltr_ctrl_tbl_rev0) /
-	 sizeof(dot11lcn_fltr_ctrl_tbl_rev0[0]), 11, 0, 32}
+	 ARRAY_SIZE(dot11lcn_fltr_ctrl_tbl_rev0), 11, 0, 32}
 	,
 	{&dot11lcn_ps_ctrl_tbl_rev0,
-	 sizeof(dot11lcn_ps_ctrl_tbl_rev0) /
-	 sizeof(dot11lcn_ps_ctrl_tbl_rev0[0]), 12, 0, 32}
+	 ARRAY_SIZE(dot11lcn_ps_ctrl_tbl_rev0), 12, 0, 32}
 	,
 	{&dot11lcn_gain_idx_tbl_rev0,
-	 sizeof(dot11lcn_gain_idx_tbl_rev0) /
-	 sizeof(dot11lcn_gain_idx_tbl_rev0[0]), 13, 0, 32}
+	 ARRAY_SIZE(dot11lcn_gain_idx_tbl_rev0), 13, 0, 32}
 	,
 	{&dot11lcn_aux_gain_idx_tbl_rev0,
-	 sizeof(dot11lcn_aux_gain_idx_tbl_rev0) /
-	 sizeof(dot11lcn_aux_gain_idx_tbl_rev0[0]), 14, 0, 16}
+	 ARRAY_SIZE(dot11lcn_aux_gain_idx_tbl_rev0), 14, 0, 16}
 	,
 	{&dot11lcn_sw_ctrl_tbl_rev0,
-	 sizeof(dot11lcn_sw_ctrl_tbl_rev0) /
-	 sizeof(dot11lcn_sw_ctrl_tbl_rev0[0]), 15, 0, 16}
+	 ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_rev0), 15, 0, 16}
 	,
 	{&dot11lcn_nf_table_rev0,
-	 sizeof(dot11lcn_nf_table_rev0) / sizeof(dot11lcn_nf_table_rev0[0]), 16,
+	 ARRAY_SIZE(dot11lcn_nf_table_rev0), 16,
 	 0, 8}
 	,
 	{&dot11lcn_gain_val_tbl_rev0,
-	 sizeof(dot11lcn_gain_val_tbl_rev0) /
-	 sizeof(dot11lcn_gain_val_tbl_rev0[0]), 17, 0, 8}
+	 ARRAY_SIZE(dot11lcn_gain_val_tbl_rev0), 17, 0, 8}
 	,
 	{&dot11lcn_gain_tbl_rev0,
-	 sizeof(dot11lcn_gain_tbl_rev0) / sizeof(dot11lcn_gain_tbl_rev0[0]), 18,
+	 ARRAY_SIZE(dot11lcn_gain_tbl_rev0), 18,
 	 0, 32}
 	,
 	{&dot11lcn_spur_tbl_rev0,
-	 sizeof(dot11lcn_spur_tbl_rev0) / sizeof(dot11lcn_spur_tbl_rev0[0]), 20,
+	 ARRAY_SIZE(dot11lcn_spur_tbl_rev0), 20,
 	 0, 8}
 	,
 	{&dot11lcn_unsup_mcs_tbl_rev0,
-	 sizeof(dot11lcn_unsup_mcs_tbl_rev0) /
-	 sizeof(dot11lcn_unsup_mcs_tbl_rev0[0]), 23, 0, 16}
+	 ARRAY_SIZE(dot11lcn_unsup_mcs_tbl_rev0), 23, 0, 16}
 	,
 	{&dot11lcn_iq_local_tbl_rev0,
-	 sizeof(dot11lcn_iq_local_tbl_rev0) /
-	 sizeof(dot11lcn_iq_local_tbl_rev0[0]), 0, 0, 16}
+	 ARRAY_SIZE(dot11lcn_iq_local_tbl_rev0), 0, 0, 16}
 	,
 	{&dot11lcn_papd_compdelta_tbl_rev0,
-	 sizeof(dot11lcn_papd_compdelta_tbl_rev0) /
-	 sizeof(dot11lcn_papd_compdelta_tbl_rev0[0]), 24, 0, 32}
+	 ARRAY_SIZE(dot11lcn_papd_compdelta_tbl_rev0), 24, 0, 32}
 	,
 };
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313 = {
 	&dot11lcn_sw_ctrl_tbl_4313_rev0,
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0) /
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0[0]), 15, 0, 16
+	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_rev0), 15, 0, 16
 };
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0,
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0) /
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0[0]), 15, 0, 16
+	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_epa_rev0), 15, 0, 16
 };
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo,
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo) /
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo[0]), 15, 0, 16
+	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo), 15, 0, 16
 };
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250 = {
 	&dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0,
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0) /
-	sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0[0]), 15, 0, 16
+	ARRAY_SIZE(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0), 15, 0, 16
 };
 
 const u32 dot11lcnphytbl_info_sz_rev0 =
-	sizeof(dot11lcnphytbl_info_rev0) / sizeof(dot11lcnphytbl_info_rev0[0]);
+	ARRAY_SIZE(dot11lcnphytbl_info_rev0);
 
 const struct lcnphy_tx_gain_tbl_entry
 dot11lcnphy_2GHz_extPA_gaintable_rev0[128] = {
-- 
1.7.10.4


