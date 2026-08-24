Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0083203B6
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 03:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787540898; cv=none; b=qaB9HgWBDPSxtQjbG5ebTvs8nP8vkhi9DkSendj4bvD0VeTzYTxRC6b+sRW/K62htTYB2KjgEHoT9pnL6eDui0WnvaeCbLmtmUxA7s7VqDvmugwcCu9lTwsK1LNBV+puCs11PEaEoi0pqicETrNrImUqN0ZHXqhei95E3JCdcSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787540898; c=relaxed/simple;
	bh=zIpB/ziGfYpaNxe+UG2uxIPeSyF98BSNG031UUOFp+o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UOWgqOxRGYoaTzEaWFUwjiw4DmXnVjwpcS7C1ZevmVIqUtSLoU6tpEXhCn5gE5mOoZbZok8JuVRWD811Gvxbwk2Rc4x39B8NiWo2GkI9NtXkHGZc0wSBhOz69XcEX9hDykX21lVWoVDFMyQOMyZjWjA4ZFA+MRZJbL8SxwgB9tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MEwXooEP; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MEwXooEP"
X-UUID: 0462424c9f6911f18dc8c9802ae25ab1-20260824
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=QzTh5/rnv8TVDQKc1DATMF5xG1GWDIqf9oSbLx6qg0Q=;
	b=MEwXooEP6t3AGWsk32E3M3kE05m3h3LC/qkJ8MPAHHtnSrL2Swtz+6vz1SVa9UEDS7oh8KjzvPPZQy7worKN7YlJw+8yHzW/hDFEZhuEtDvezKfgxsNxs0OsxqtgYftU4NCkInlZY0ko/2AEfrFsrDDaZnIAM9BG7UjVEo70F6U=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:7625d712-6e75-40f6-a583-1421f55192c4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:cc6bc8e2-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:1,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0462424c9f6911f18dc8c9802ae25ab1-20260824
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2107624931; Mon, 24 Aug 2026 11:08:01 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Aug 2026 11:08:00 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 24 Aug 2026 11:08:00 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	<michael.shih@mediatek.com>, <eason.lai@mediatek.com>
Subject: [PATCH v1] wifi: mt76: mt7928: Add debugfs for stats to provide debug purpose
Date: Mon, 24 Aug 2026 11:07:46 +0800
Message-ID: <20260824030746.60706-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Michael Shih <michael.shih@mediatek.com>

Usage:
(1) Connect STA to AP  (You can use dhclient CMD to ask for DHCP IP, to use ping to AP)
    DHCP IP CMD:  dhclient ${WLAN_IF} -v

   Example: dhclient wlan0 -v

   ## (To simulate traffic) Ping 10 packets for every second to AP
   ping 192.168.0.XXX  -i0.1

(2) (Get stats) Use command, phyX is your WiFi interface:
     cat /sys/kernel/debug/ieee80211/phyX/mt76/stats

(3) You will see below stats info:
(STA) connected AP MAC Address = a8:42:a1:46:c4:6b
                        BssIdx = [0]
                        StaRecIdx = [1],
                        RSSI = -25
                        Link_Speed = 2402000 (kbit/s)
                        temperature = 40
                        Tx success = 716
                        Tx fail to Rcv ACK after retry = 0
                        Rx Mpdu = 23
                        Rx Fcs Error = 1 (MPDU)
                        Rx FIFO full = 0 (MPDU)
                        TRX_AGG_RANGE[0] = 0 (PPDU)
                        TRX_AGG_RANGE[1] = 0 (PPDU)
                        TRX_AGG_RANGE[2] = 0 (PPDU)
                        TRX_AGG_RANGE[3] = 0 (PPDU)
                        TRX_AGG_RANGE[4] = 0 (PPDU)
                        TRX_AGG_RANGE[5] = 0 (PPDU)
                        TRX_AGG_RANGE[6] = 0 (PPDU)
                        TRX_AGG_RANGE[7] = 0 (PPDU)
                        MPDUs in AMPDUs transmitted = 0 (MPDU)
                        MPDUs in AMPDUs transmitted with ACK reply = 0 (MPDU)
                        rate1_tx_cnt = 714
                        rate1_fail_cnt = 223
                        train_up = 2310
                        train_down = 3080
                        is_force_tx_stream = 0
                        is_force_se_off = 0
                        max_ampdu_factor = 9
                        tx_rate_up_penalty = 0
                        low_traffic_mode = 2
                        low_traffic_count = 0
                        low_traffic_dashboard = 3
                        dynamic_sgi_state = 0
                        dynamic_sgi_score = 2
                        dynamic_bw_state = 0
                        dynamic_gband_256qam_state = 3
                        vht_non_sp_rate_state = 0
                        Last TX Rate = 24M, BW20, OFDM, BCC, SPE24
                        Chip Out TX Power = +16.5 dBm
                        Cur Rate Index = 0
Rate index[0]    --> NSS2_MCS11, BW160/BW8080, SGI, HE_SU, LDPC
Rate index[1]        NSS2_MCS9, BW160/BW8080, SGI, HE_SU, LDPC
Rate index[2]        NSS2_MCS7, BW160/BW8080, SGI, HE_SU, LDPC
Rate index[3]        NSS2_MCS4, BW160/BW8080, SGI, HE_SU, LDPC
Rate index[4]        NSS2_MCS3, BW160/BW8080, SGI, HE_SU, LDPC
Rate index[5]        NSS1_MCS2, BW160/BW8080, SGI, HE_SU, LDPC
Rate index[6]        NSS1_MCS1, BW80, SGI, HE_SU, LDPC
Rate index[7]        NSS1_MCS0, BW80, SGI, HE_SU, LDPC

mib state:
=== Rx Related Counters ===
                        Rx with CRC = 24020 (MPDU)
                        Rx drop due to out of resource = 0 (MPDU)
                        Rx Mpdu = 93223 (MPDU)
                        Rx AMpdu = 668 (PPDU)
                        Rx PF Drop = 0 (MPDU)
                        Rx Len Mismatch = 5853 (PPDU)

=== Phy/Timing Related Counters ===
                        ChannelIdleCnt = 1040434
                        CCA_NAV_Tx_Time = 18510036
                        Rx_MDRDY_CNT = 166580 (PPDU)
                        CCK_MDRDY = 7782
                        OFDM_MDRDY = 11912731
                        OFDM_GREEN_MDRDY = 0
                        Prim CCA Time = 17917650
                        Sec CCA Time = 14922034
                        Prim ED Time = 5677528

=== Tx Related Counters(Generic) ===
                        BeaconTxCnt = 0
                        Tx 40MHz Cnt = 279  (MPDU)
                        Tx 80MHz Cnt = 44  (MPDU)
                        Tx 160MHz Cnt = 712  (MPDU)

=== BSSID[0] Related Counters ===
                        BA Miss Cnt = 210  (PPDU)
                        RTS Tx Cnt = 1003  (MPDU)
                        Frame Retry Cnt = 239 (MPDU)
                        Frame Retry 2 Cnt = 71 (MPDU)
                        RTS Retry Cnt = 152 (MPDU)
                        Ack Failed Cnt = 319 (PPDU)

=== AMPDU Related Counters ===
                        Tx AMPDU_Pkt_Cnt = 705  (PPDU)
                        Tx AMPDU_MPDU_Pkt_Cnt = 713  (MPDU)
                        AMPDU Tx success = 503 (MPDU)
                        AMPDU Tx fail count   = 210  (MPDU), PER=29.4%

Signed-off-by: Michael Shih <michael.shih@mediatek.com>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  177 +++
 .../wireless/mediatek/mt76/mt7925/Makefile    |    2 +-
 .../wireless/mediatek/mt76/mt7925/debugfs.c   | 1054 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/stats.c |  585 +++++++++
 .../net/wireless/mediatek/mt76/mt7925/stats.h |  305 +++++
 5 files changed, 2122 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/stats.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/stats.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 0ededa569e9a..72cc69750f47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1483,6 +1483,183 @@ enum {
 	MT_NIC_CAP_EML_CAP = 0x22,
 };
 
+enum {
+	UNI_CMD_ID_STATISTICS_BASIC = 0,
+	UNI_CMD_ID_STATISTICS_LINK_QUALITY = 1,
+	UNI_CMD_ID_STATISTICS_STA = 2,
+	UNI_CMD_ID_STATISTICS_BUG_REPORT = 3,
+	UNI_CMD_ID_STATISTICS_TX_STATS = 4,
+	UNI_CMD_ID_STATISTICS_ALL_STATS = 5,
+	UNI_CMD_ID_STATISTICS_EML_STATS = 6,
+	UNI_CMD_ID_STATISTICS_REGULAR_STATS = 7,
+	UNI_CMD_ID_STATISTICS_BSS_LINK_QUALITY = 8,
+	UNI_CMD_ID_STATISTICS_ML_CHNL_COND = 9,
+	UNI_CMD_ID_STATISTICS_WTBL = 10,
+	UNI_CMD_ID_STATISTICS_LINK_LAYER_STATS = 128,
+	UNI_CMD_ID_STATISTICS_PPDU_LATENCY = 129,
+	UNI_CMD_ID_STATISTICS_CURRENT_TX_RATE = 130,
+	UNI_CMD_ID_STATISTICS_SET_TX_BITRATE_MONITOR = 131,
+	UNI_CMD_ID_STATISTICS_GET_PREDICT_TX_BITRATE = 132,
+	UNI_CMD_ID_STATISTICS_SET_ATPS_TYPE_RATE_MODE = 133,
+	UNI_CMD_ID_STATISTICS_SET_BEACON_REPORT = 134,
+	UNI_CMD_ID_STATISTICS_BSS_CURRENT_TX_RATE = 135,
+	UNI_CMD_ID_STATISTICS_GET_BSS_PREDICT_TX_BITRATE = 136,
+	UNI_CMD_ID_STATISTICS_MAX_NUM
+};
+
+enum {
+	UNI_CMD_MIB_DATA,
+};
+
+enum mt7925_mib_counter {
+	UNI_CMD_MIB_CNT_RX_FCS_ERR = 0,
+	UNI_CMD_MIB_CNT_RX_FIFO_OVERFLOW = 1,
+	UNI_CMD_MIB_CNT_RX_MPDU = 2,
+	UNI_CMD_MIB_CNT_AMPDU_RX_COUNT = 3,
+	UNI_CMD_MIB_CNT_RX_TOTAL_BYTE = 4,
+	UNI_CMD_MIB_CNT_RX_VALID_AMPDU_SF = 5,
+	UNI_CMD_MIB_CNT_RX_VALID_BYTE = 6,
+	UNI_CMD_MIB_CNT_CHANNEL_IDLE = 7,
+	UNI_CMD_MIB_CNT_VEC_DROP = 8,
+	UNI_CMD_MIB_CNT_DELIMITER_FAIL = 9,
+	UNI_CMD_MIB_CNT_VEC_MISMATCH = 10,
+	UNI_CMD_MIB_CNT_MDRDY = 11,
+	UNI_CMD_MIB_CNT_RX_CCK_MDRDY_TIME = 12,
+	UNI_CMD_MIB_CNT_RX_OFDM_LG_MIXED_MDRDY_TIME = 13,
+	UNI_CMD_MIB_CNT_RX_OFDM_GREEN_MDRDY_TIME = 14,
+	UNI_CMD_MIB_CNT_PF_DROP = 15,
+	UNI_CMD_MIB_CNT_LEN_MISMATCH = 16,
+	UNI_CMD_MIB_CNT_P_CCA_TIME = 17,
+	UNI_CMD_MIB_CNT_S_CCA_TIME = 18,
+	UNI_CMD_MIB_CNT_CCA_NAV_TX_TIME = 19,
+	UNI_CMD_MIB_CNT_P_ED_TIME = 20,
+	UNI_CMD_MIB_CNT_BCN_TX = 21,
+	UNI_CMD_MIB_CNT_TX_BW_20MHZ = 22,
+	UNI_CMD_MIB_CNT_TX_BW_40MHZ = 23,
+	UNI_CMD_MIB_CNT_TX_BW_80MHZ = 24,
+	UNI_CMD_MIB_CNT_TX_BW_160MHZ = 25,
+	UNI_CMD_RMAC_CNT_OBSS_AIRTIME = 26,
+	UNI_CMD_RMAC_CNT_NONWIFI_AIRTIME = 27,
+	UNI_CMD_MIB_CNT_TX_DUR_CNT = 28,
+	UNI_CMD_MIB_CNT_RX_DUR_CNT = 29,
+	UNI_CMD_MIB_CNT_BA_CNT = 30,
+	UNI_CMD_MIB_CNT_MAC2PHY_TX_TIME = 31,
+	UNI_CMD_MIB_CNT_RX_OUT_OF_RANGE_COUNT = 32,
+	UNI_CMD_MIB_CNT_IBF_TX = 33,
+	UNI_CMD_MIB_CNT_EBF_TX = 34,
+	UNI_CMD_MIB_CNT_MUBF_TX = 35,
+	UNI_CMD_MIB_CNT_RX_BF_VHTFBK = 36,
+	UNI_CMD_MIB_CNT_RX_BF_HTFBK = 37,
+	UNI_CMD_MIB_CNT_RX_BF_HEFBK = 38,
+	UNI_CMD_MIB_CNT_BFEE_TXFBK_BFPOLL_TRI = 39,
+	UNI_CMD_MIB_CNT_BFEE_TXFBK_TRI = 40,
+	UNI_CMD_MIB_CNT_BFEE_RX_FBKCQI = 41,
+	UNI_CMD_MIB_CNT_BFEE_RX_NDP = 42,
+	UNI_CMD_MIB_CNT_RX_BF_IBF_UPT = 43,
+	UNI_CMD_MIB_CNT_RX_BF_EBF_UPT = 44,
+	UNI_CMD_MIB_CNT_BFEE_SP_ABORT = 45,
+	UNI_CMD_MIB_CNT_BFEE_TB_LEN_ERR = 46,
+	UNI_CMD_MIB_CNT_BFEE_TXFBK_MUTE = 47,
+	UNI_CMD_MIB_CNT_BFEE_TMAC_ABORT = 48,
+	UNI_CMD_MIB_CNT_BFEE_TXFBK_CPL = 49,
+	UNI_CMD_MIB_CNT_BFEE_COANT_BLKTX = 50,
+	UNI_CMD_MIB_CNT_BFEE_FBK_SEG = 51,
+	UNI_CMD_MIB_CNT_NAV_TIME = 52,
+	UNI_CMD_MIB_CNT_TX_ABORT_CNT1 = 53,
+	UNI_CMD_MIB_CNT_TX_ABORT_CNT0 = 54,
+	UNI_CMD_MIB_CNT_TX_ABORT_CNT3 = 55,
+	UNI_CMD_MIB_CNT_TX_ABORT_CNT2 = 56,
+	UNI_CMD_MIB_CNT_BSS0_RTS_TX_CNT = 57,
+	UNI_CMD_MIB_CNT_BSS1_RTS_TX_CNT = 58,
+	UNI_CMD_MIB_CNT_BSS2_RTS_TX_CNT = 59,
+	UNI_CMD_MIB_CNT_BSS3_RTS_TX_CNT = 60,
+	UNI_CMD_MIB_CNT_BSS0_RTS_RETRY = 61,
+	UNI_CMD_MIB_CNT_BSS1_RTS_RETRY = 62,
+	UNI_CMD_MIB_CNT_BSS2_RTS_RETRY = 63,
+	UNI_CMD_MIB_CNT_BSS3_RTS_RETRY = 64,
+	UNI_CMD_MIB_CNT_BSS0_BA_MISS = 65,
+	UNI_CMD_MIB_CNT_BSS1_BA_MISS = 66,
+	UNI_CMD_MIB_CNT_BSS2_BA_MISS = 67,
+	UNI_CMD_MIB_CNT_BSS3_BA_MISS = 68,
+	UNI_CMD_MIB_CNT_BSS0_ACK_FAIL = 69,
+	UNI_CMD_MIB_CNT_BSS1_ACK_FAIL = 70,
+	UNI_CMD_MIB_CNT_BSS2_ACK_FAIL = 71,
+	UNI_CMD_MIB_CNT_BSS3_ACK_FAIL = 72,
+	UNI_CMD_MIB_CNT_BSS0_FRAME_RETRY = 73,
+	UNI_CMD_MIB_CNT_BSS1_FRAME_RETRY = 74,
+	UNI_CMD_MIB_CNT_BSS2_FRAME_RETRY = 75,
+	UNI_CMD_MIB_CNT_BSS3_FRAME_RETRY = 76,
+	UNI_CMD_MIB_CNT_BSS0_FRAME_RETRY_2 = 77,
+	UNI_CMD_MIB_CNT_BSS1_FRAME_RETRY_2 = 78,
+	UNI_CMD_MIB_CNT_BSS2_FRAME_RETRY_2 = 79,
+	UNI_CMD_MIB_CNT_BSS3_FRAME_RETRY_2 = 80,
+	UNI_CMD_MIB_CNT_RX_A1_SEARCH = 81,
+	UNI_CMD_MIB_CNT_RX_DROP_MPDU = 82,
+	UNI_CMD_MIB_CNT_RX_UNWANTED = 83,
+	UNI_CMD_MIB_CNT_RX_FCS_OK = 84,
+	UNI_CMD_MIB_CNT_SU_TX_OK = 85,
+	UNI_CMD_MIB_CNT_TX_FULL_BW = 86,
+	UNI_CMD_MIB_CNT_TX_AUTO_BW = 87,
+	UNI_CMD_MIB_CNT_CCA_SAMPLE_IDLE = 88,
+	UNI_CMD_MIB_CNT_CCA_SAMPLE_ACTIVE = 89,
+	UNI_CMD_MIB_CNT_CCA_TIME = 90,
+	UNI_CMD_MIB_CNT_S_20BW_CCA_TIME = 91,
+	UNI_CMD_MIB_CNT_S_40BW_CCA_TIME = 92,
+	UNI_CMD_MIB_CNT_S_80BW_CCA_TIME = 93,
+	UNI_CMD_MIB_CNT_S_160BW_CCA_TIME = 94,
+	UNI_CMD_MIB_CNT_S_P20BW_0_ED_TIME = 95,
+	UNI_CMD_MIB_CNT_S_P20BW_1_ED_TIME = 96,
+	UNI_CMD_MIB_CNT_S_P20BW_2_ED_TIME = 97,
+	UNI_CMD_MIB_CNT_S_P20BW_3_ED_TIME = 98,
+	UNI_CMD_MIB_CNT_S_P20BW_4_ED_TIME = 99,
+	UNI_CMD_MIB_CNT_S_P20BW_5_ED_TIME = 100,
+	UNI_CMD_MIB_CNT_S_P20BW_6_ED_TIME = 101,
+	UNI_CMD_MIB_CNT_S_P20BW_7_ED_TIME = 102,
+	UNI_CMD_MIB_CNT_S_P20BW_8_ED_TIME = 103,
+	UNI_CMD_MIB_CNT_S_P20BW_9_ED_TIME = 104,
+	UNI_CMD_MIB_CNT_S_P20BW_10_ED_TIME = 105,
+	UNI_CMD_MIB_CNT_S_P20BW_11_ED_TIME = 106,
+	UNI_CMD_MIB_CNT_S_P20BW_12_ED_TIME = 107,
+	UNI_CMD_MIB_CNT_S_P20BW_13_ED_TIME = 108,
+	UNI_CMD_MIB_CNT_S_P20BW_14_ED_TIME = 109,
+	UNI_CMD_MIB_CNT_S_P20BW_15_ED_TIME = 110,
+	UNI_CMD_MIB_CNT_TX_BW_320MHZ = 111,
+	UNI_CMD_MIB_CNT_TX_DDLMT_RNG0 = 112, /* Rng0~Rng4 112~116 */
+	UNI_CMD_MIB_CNT_BSS0_FRAME_RETRY_3 = 117, /* 117~120 */
+	UNI_CMD_MIB_CNT_BSS0_TX = 121, /* 121~124 */
+	UNI_CMD_MIB_CNT_BSS0_TX_DATA = 125, /* 125~128 */
+	UNI_CMD_MIB_CNT_BSS0_TX_BYTE = 129, /* 129~132 */
+	UNI_CMD_MIB_CNT_RX_OK_BSS0 = 133, /* 133~136 */
+	UNI_CMD_MIB_CNT_RX_BYTE_BSS0 = 137, /* 137~140 */
+	UNI_CMD_MIB_CNT_RX_DATA_BSS0 = 141, /* 141~144 */
+	UNI_CMD_MIB_CNT_MBSS0_TX_OK = 145, /* 145~160 */
+	UNI_CMD_MIB_CNT_MBSS0_TX_BYTE = 161, /* 161~176 */
+	UNI_CMD_MIB_CNT_RX_OK_MBSS0 = 177, /* 177~192 */
+	UNI_CMD_MIB_CNT_RX_BYTE_MBSS0 = 193, /* 193~208 */
+	UNI_CMD_MIB_CNT_AMPDU = 209,
+	UNI_CMD_MIB_CNT_AMPDU_MPDU = 210,
+	UNI_CMD_MIB_CNT_AMPDU_ACKED = 211,
+	UNI_CMD_MIB_CNT_MAX_NUM
+};
+
+enum ENUM_UNI_CMD_GET_STATISTICS_TAG {
+	UNI_CMD_GET_STATISTICS_TAG_BASIC = 0,
+	UNI_CMD_GET_STATISTICS_TAG_LINK_QUALITY = 1,
+	UNI_CMD_GET_STATISTICS_TAG_STA = 2,
+	UNI_CMD_GET_STATISTICS_TAG_BUG_REPORT = 3,
+	UNI_CMD_GET_STATISTICS_TAG_EML_STATS = 6,
+	UNI_CMD_GET_STATISTICS_TAG_REGULAR_STATS = 7,
+	UNI_CMD_GET_STATISTICS_TAG_BSS_LINK_QUALITY = 8,
+	UNI_CMD_GET_STATISTICS_TAG_GET_ML_CHNL_COND = 9,
+	UNI_CMD_GET_STATISTICS_TAG_STAT_WTBL = 10,
+	UNI_CMD_GET_STATISTICS_TAG_LINK_LAYER_STATS = 0x80,
+	UNI_CMD_GET_STATISTICS_TAG_PPDU_LATENCY,
+	UNI_CMD_GET_STATISTICS_TAG_CURRENT_TX_RATE,
+	UNI_CMD_GET_STATISTICS_TAG_BEACON_REPORT = 0x86,
+	UNI_CMD_GET_STATISTICS_TAG_BSS_CURRENT_TX_RATE = 0x87,
+	UNI_CMD_GET_STATISTICS_TAG_BSS_PRED_TX_BITRATE = 0x88,
+};
+
 #define UNI_WOW_DETECT_TYPE_MAGIC		BIT(0)
 #define UNI_WOW_DETECT_TYPE_ANY			BIT(1)
 #define UNI_WOW_DETECT_TYPE_DISCONNECT		BIT(2)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
index f9dcc0bba393..3863a89b8974 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_MT7925_COMMON) += mt7925-common.o
 obj-$(CONFIG_MT7925E) += mt7925e.o
 obj-$(CONFIG_MT7925U) += mt7925u.o
 
-mt7925-common-y := mac.o mcu.o regd.o main.o init.o debugfs.o nan.o
+mt7925-common-y := mac.o mcu.o regd.o main.o init.o debugfs.o nan.o stats.o
 mt7925-common-$(CONFIG_NL80211_TESTMODE) += testmode.o
 mt7925e-y := pci.o pci_mac.o pci_mcu.o
 mt7925u-y := usb.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
index d01ff49de47a..e3d2d9ef20fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c
@@ -3,6 +3,7 @@
 
 #include "mt7925.h"
 #include "mcu.h"
+#include "stats.h"
 
 static int
 mt7925_reg_set(void *data, u64 val)
@@ -286,6 +287,1057 @@ static int mt7925_chip_reset(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_reset, NULL, mt7925_chip_reset, "%lld\n");
 
+/* fixedrate input format (12 hex digits):
+ * 0x[WCID(2)][Mode][BW][MCS][Nss][SGI][Preamble][STBC][LDPC][SPE_EN][HeLtf]
+ * The RA tag is fixed to SET_FIXED_RATE internally.
+ * WCID is 2 nibbles, all others are 1 nibble.
+ *
+ * [WCID]    Wireless Client ID
+ * [Mode]    CCK=0, OFDM=1, HT=2, GF=3, VHT=4, PLR=5, HE_SU=8, HE_ER_SU=9,
+ *           HE_TRIG=10, HE_MU=11, EHT_ER=13, EHT_TB=14, EHT_SU and EHT_MU=15
+ * [BW]      BW20=0, BW40=1, BW80=2, BW160=3, BW320=4
+ * [MCS]     CCK=0~3, OFDM=0~7, HT=0~32, VHT=0~9, HE=0~11, EHT=0~13, EHT_ER=14~15
+ * [Nss]     1~8
+ * [GI]      HT/VHT: 0=Long, 1=Short; HE/EHT: 0=0.8us, 1=1.6us, 2=3.2us
+ * [Preamble] Long=0, Short=other
+ * [STBC]    Enable=1, Disable=0
+ * [LDPC]    BCC=0, LDPC=1 (driver sends the FW's "on" value 7)
+ * [SPE_EN]  spatial extension index
+ * [HeLtf]   1X=0, 2X=1, 4X=2 (NOTE: EHT modes require HeLtf=1)
+ */
+static int
+mt7925_fixedrate_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+	struct mt7925_ra_fixed_rate_v1 rate = {};
+
+	dev->fixed_rate = val;
+
+	rate.wlan_idx       = cpu_to_le16((val >> 40) & 0xff);
+	rate.phy_mode       = (val >> 36) & 0xf;
+	rate.bw             = (val >> 32) & 0xf;
+	rate.mcs            = (val >> 28) & 0xf;
+	rate.nss            = (val >> 24) & 0xf;
+	rate.short_gi       = cpu_to_le16((val >> 20) & 0xf);
+	rate.short_preamble = (val >> 16) & 0xf;
+	rate.stbc           = (val >> 12) & 0xf;
+	rate.ecc            = ((val >> 8) & 0xf) ? 7 : 0;
+	rate.spe            = (val >> 4) & 0xf;
+	rate.he_ltf         = cpu_to_le16((val >> 0) & 0xf);
+
+	mt792x_mutex_acquire(dev);
+	mt7925_mcu_set_fixed_rate(dev, &rate);
+	mt792x_mutex_release(dev);
+
+	return 0;
+}
+
+static int
+mt7925_fixedrate_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->fixed_rate;
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_fixedrate, mt7925_fixedrate_get,
+			 mt7925_fixedrate_set, "0x%llx\n");
+
+/* autorate input format (6 hex digits):
+ * 0x[Tag(2)][WCID(2)][En][Mode]
+ * The RA tag is fixed to SET_AUTO_RATE internally.
+ * WCID is 2 nibbles, En and Mode are 1 nibble each.
+ *
+ * [WCID] Wireless Client ID
+ * [En]   Auto rate: Enable=1, Disable=0
+ * [Mode] don't care (RA picks the rate)
+ */
+static int
+mt7925_autorate_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+	u16 wlan_idx = (val >> 8) & 0xff;
+	bool enable = (val >> 4) & 0xf;
+	u8 mode = val & 0xf;
+
+	dev->auto_rate = val;
+
+	mt792x_mutex_acquire(dev);
+	mt7925_mcu_set_auto_rate(dev, wlan_idx, enable, mode);
+	mt792x_mutex_release(dev);
+
+	return 0;
+}
+
+static int
+mt7925_autorate_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->auto_rate;
+
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_autorate, mt7925_autorate_get,
+			 mt7925_autorate_set, "0x%llx\n");
+
+/* WTBL dump
+ *
+ * Usage:
+ *   echo <idx> > /sys/kernel/debug/ieee80211/phy1/mt76/wtbl_idx
+ *   cat  /sys/kernel/debug/ieee80211/phy1/mt76/get_wtbl
+ *
+ * LMAC WTBL has 36 dwords per entry (connac3x).
+ */
+#define MT792x_WTBL_LMAC_DWORDS	36
+
+static int
+mt7925_wtbl_idx_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	dev->wtbl_dump_idx = (u32)val;
+
+	return 0;
+}
+
+static int
+mt7925_wtbl_idx_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->wtbl_dump_idx;
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_wtbl_idx, mt7925_wtbl_idx_get,
+			 mt7925_wtbl_idx_set, "%llu\n");
+
+static int
+mt7925_wtbl_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 idx = dev->wtbl_dump_idx;
+	u32 wdu_cr, wducr_val, base;
+	u32 dw0, dw1;
+	int i;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "WTBL direct dump not supported on this interface\n");
+		return 0;
+	}
+
+	if (idx >= MT792x_WTBL_SIZE) {
+		seq_printf(s, "Invalid WTBL idx %u (max %u)\n",
+			   idx, MT792x_WTBL_SIZE - 1);
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	/* mt7925_mac_wtbl_lmac_addr() writes WDUCR group selection and
+	 * returns the mapped register address for DW 0 of this WCID.
+	 */
+	base = mt7925_mac_wtbl_lmac_addr(dev, idx, 0);
+	wdu_cr = is_mt7928(&dev->mt76) ? MT7928_WTBLON_TOP_WDUCR :
+					  MT7925_WTBLON_TOP_WDUCR;
+	wducr_val = mt76_rr(dev, wdu_cr);
+
+	/* DW0[15:0] + DW1[31:0] encode the link address */
+	dw0 = mt76_rr(dev, base);
+	dw1 = mt76_rr(dev, base + 4);
+
+	seq_printf(s, "Dump WTBL info of WLAN_IDX: %u\n", idx);
+	seq_printf(s, "LMAC WTBL Addr: group:0x%08x=0x%08x addr: 0x%08x\n",
+		   wdu_cr, wducr_val, base);
+	seq_printf(s, "LinkAddr: %02x:%02x:%02x:%02x:%02x:%02x\n",
+		   dw1 & 0xff, (dw1 >> 8) & 0xff,
+		   (dw1 >> 16) & 0xff, (dw1 >> 24) & 0xff,
+		   dw0 & 0xff, (dw0 >> 8) & 0xff);
+
+	seq_puts(s, "\nLMAC WTBL raw data:\n");
+	for (i = 0; i < MT792x_WTBL_LMAC_DWORDS; i++)
+		seq_printf(s, "DW%02d: 0x%08x\n", i,
+			   mt76_rr(dev, base + i * 4));
+
+	mt792x_mutex_release(dev);
+
+	return 0;
+}
+
+static int
+mt7925_vefuse_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u16 size = dev->vefuse_cap.size;
+	int off = 0;
+	u8 *buf;
+	int ret = 0;
+
+	if (!dev->vefuse_cap.present || !size) {
+		seq_puts(s, "vefuse: no region in FW image\n");
+		return 0;
+	}
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mt792x_mutex_acquire(dev);
+	while (off < (int)size) {
+		u16 chunk = min_t(u16, 512, size - off);
+
+		ret = mt7925_mcu_read_vefuse(dev, off, chunk, buf + off);
+		if (ret)
+			break;
+		off += chunk;
+	}
+	mt792x_mutex_release(dev);
+
+	if (ret) {
+		seq_printf(s, "vefuse: read failed at 0x%04x (%d)\n", off, ret);
+		kfree(buf);
+		return 0;
+	}
+
+	seq_printf(s, "vefuse content: %u bytes\n", size);
+	for (off = 0; off < (int)size; off += 16)
+		seq_printf(s, "%04x: %*ph\n", off,
+			   (int)min_t(u16, 16, size - off), buf + off);
+
+	kfree(buf);
+
+	return 0;
+}
+
+/* send one perf_ind carrying the written value in every tx/rx byte field */
+static int mt7925_perf_ind_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	return mt792x_perf_ind_trigger(dev, val);
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_perf_ind, NULL, mt7925_perf_ind_set, "%lld\n");
+
+static int mt7925_perf_ind_enable_get(void *data, u64 *val)
+{
+	struct mt792x_dev *dev = data;
+
+	*val = dev->perf.enabled;
+
+	return 0;
+}
+
+static int mt7925_perf_ind_enable_set(void *data, u64 val)
+{
+	struct mt792x_dev *dev = data;
+
+	dev->perf.enabled = !!val;
+
+	return 0;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(fops_perf_ind_enable, mt7925_perf_ind_enable_get,
+			 mt7925_perf_ind_enable_set, "%lld\n");
+
+static int
+mt7925_coex_info(struct seq_file *s, void *data)
+{
+#define MT7925_CHIP_CONFIG_RESP_SIZE	320
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u8 resp[MT7925_CHIP_CONFIG_RESP_SIZE], resp_type;
+	int i, ret;
+
+	mt792x_mutex_acquire(dev);
+	ret = mt7925_mcu_chip_config_query(dev, "coexBwcGetModeInfo 0",
+					   &resp_type, resp, sizeof(resp));
+	mt792x_mutex_release(dev);
+
+	if (ret < 0)
+		return ret;
+
+	if (!ret)
+		seq_puts(s, "no reply\n");
+	else if (resp_type == CHIP_CONFIG_TYPE_ASCII)
+		seq_printf(s, "%.*s\n", ret, resp);
+	else
+		for (i = 0; i < ret; i += 16)
+			seq_printf(s, "%04x: %*ph\n", i,
+				   min_t(int, 16, ret - i), resp + i);
+
+	return 0;
+}
+
+/* mt7925_dmashdl_read: standard DMASHDL (MT7925/MT7927 only).
+ * MT7928 uses DMASHDL Lite; see mt7928_dmashdl_lite_read below.
+ */
+static int
+mt7925_dmashdl_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 total_src = 0, total_rsv = 0;
+	u32 ffa_cnt, free_pg_cnt;
+	u32 ple_rsv, ple_src;
+	u32 val;
+	int i;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "DMASHDL dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	seq_puts(s, "DMASHDL Info:\n");
+
+	val = mt76_rr(dev, MT_DMASHDL_REFILL);
+	seq_printf(s, "\tRefill control(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_REFILL, val);
+
+	val = mt76_rr(dev, MT_DMASHDL_PKT_MAX_SIZE);
+	seq_printf(s, "\tPkt max size(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_PKT_MAX_SIZE, val);
+	seq_printf(s, "\t\tPLE pkt max=0x%03x, PSE pkt max=0x%03x\n",
+		   FIELD_GET(MT_DMASHDL_PKT_MAX_SIZE_PLE, val),
+		   FIELD_GET(MT_DMASHDL_PKT_MAX_SIZE_PSE, val));
+
+	val = mt76_rr(dev, MT_DMASHDL_ERROR_FLAG_CTRL);
+	seq_printf(s, "\tError flag ctrl(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_ERROR_FLAG_CTRL, val);
+
+	for (i = 0; i < 15; i++) {
+		u32 quota = mt76_rr(dev, MT_DMASHDL_GROUP_QUOTA(i));
+		u32 status = mt76_rr(dev, MT_DMASHDL_STATUS_RD_GP(i));
+		u32 rsv = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_RSV, status);
+		u32 src = FIELD_GET(MT_DMASHDL_STATUS_RD_GP_SRC, status);
+
+		seq_printf(s, "\tGroup %2d: quota(min/max)=0x%03x/0x%03x, used/rsv=0x%03x/0x%03x\n",
+			   i,
+			   FIELD_GET(MT_DMASHDL_GROUP_QUOTA_MIN, quota),
+			   FIELD_GET(MT_DMASHDL_GROUP_QUOTA_MAX, quota),
+			   src, rsv);
+		total_src += src;
+		total_rsv += rsv;
+	}
+
+	val = mt76_rr(dev, MT_DMASHDL_STATUS_RD);
+	free_pg_cnt = FIELD_GET(MT_DMASHDL_STATUS_RD_FREE_PG, val);
+	ffa_cnt = FIELD_GET(MT_DMASHDL_STATUS_RD_FFA, val);
+	seq_printf(s, "\tStatus_RD(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_STATUS_RD, val);
+	seq_printf(s, "\t\tfree page cnt=0x%03x, ffa cnt=0x%03x\n",
+		   free_pg_cnt, ffa_cnt);
+
+	/* Counter mismatch check against PLE HIF page counters */
+	seq_puts(s, "\nDMASHDL Counter Check:\n");
+	val = mt76_rr(dev, MT_PLE_HIF_PG_INFO);
+	ple_rsv = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	ple_src = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	seq_printf(s, "\tPLE: used/rsv pages of HIF group=0x%03x/0x%03x\n",
+		   ple_src, ple_rsv);
+	seq_printf(s, "\tDMASHDL: total used pages of group0~14=0x%03x\n",
+		   total_src);
+	if (ple_src != total_src)
+		seq_puts(s, "\t[MISMATCH] PLE used pages != DMASHDL total used\n");
+	seq_printf(s, "\tDMASHDL: total rsv pages of group0~14=0x%03x\n",
+		   total_rsv);
+	seq_printf(s, "\tDMASHDL: total ffa pages=0x%03x, total free pages=0x%03x\n",
+		   ffa_cnt, free_pg_cnt);
+	if (free_pg_cnt != total_rsv + ffa_cnt)
+		seq_puts(s, "\t[MISMATCH] free pages != rsv + ffa\n");
+	if (free_pg_cnt != ple_rsv)
+		seq_puts(s, "\t[MISMATCH] free pages != PLE rsv pages\n");
+	if (ple_src == total_src && free_pg_cnt == total_rsv + ffa_cnt &&
+	    free_pg_cnt == ple_rsv)
+		seq_puts(s, "\tDMASHDL: no counter mismatch\n");
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
+/* mt7928_dmashdl_lite_read: DMASHDL Lite (MT7928 only, base 0x20026200).
+ * Unlike full DMASHDL, Lite splits runtime state into separate registers:
+ *   GROUP_CONTROL (+0x100): min/max quota (config)
+ *   GROUP_SRC_CNT (+0x200): pages sourced (in-use) per group (runtime)
+ *   GROUP_ACK_CNT (+0x300): pages acknowledged (returned) per group (runtime)
+ *   GROUP_VALID   (+0x400): bitmap of groups with active page allocations
+ */
+static int
+mt7928_dmashdl_lite_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 disable0, disable1, valid0, valid1;
+	u32 total_src = 0, total_ack = 0;
+	u32 ple_rsv, ple_src;
+	u32 val;
+	int i;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "DMASHDL Lite dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	seq_puts(s, "DMASHDL Lite Info (MT7928):\n");
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_MAIN_CONTROL);
+	seq_printf(s, "\tMain control(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_MAIN_CONTROL, val);
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_PAGE_SIZE);
+	seq_printf(s, "\tPage size(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_PAGE_SIZE, val);
+	seq_printf(s, "\t\tPSE page size=0x%04x, PLE page size=0x%04x\n",
+		   FIELD_GET(MT_DMASHDL_LITE_PSE_PAGE_SIZE_MASK, val),
+		   FIELD_GET(MT_DMASHDL_LITE_PLE_PAGE_SIZE_MASK, val));
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_PKT_MAX_SIZE);
+	seq_printf(s, "\tPkt max size(0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_PKT_MAX_SIZE, val);
+	seq_printf(s, "\t\tPSE pkt max=0x%04x, PLE pkt max=0x%04x\n",
+		   FIELD_GET(MT_DMASHDL_LITE_PSE_PKT_MAX_SIZE_MASK, val),
+		   FIELD_GET(MT_DMASHDL_LITE_PLE_PKT_MAX_SIZE_MASK, val));
+
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_SN_CHK0);
+	seq_printf(s, "\tGroup SN check[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_SN_CHK0, val);
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_SN_CHK1);
+	seq_printf(s, "\tGroup SN check[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_SN_CHK1, val);
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_UDF_CHK0);
+	seq_printf(s, "\tGroup UDF check[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_UDF_CHK0, val);
+	val = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_UDF_CHK1);
+	seq_printf(s, "\tGroup UDF check[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_UDF_CHK1, val);
+
+	disable0 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_DISABLE0);
+	seq_printf(s, "\tGroup disable[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_DISABLE0, disable0);
+	disable1 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_DISABLE1);
+	seq_printf(s, "\tGroup disable[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_DISABLE1, disable1);
+
+	valid0 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_VALID_0_31);
+	seq_printf(s, "\tGroup valid[31:0](0x%08x):  0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_VALID_0_31, valid0);
+	valid1 = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_VALID_32_63);
+	seq_printf(s, "\tGroup valid[63:32](0x%08x): 0x%08x\n",
+		   MT_DMASHDL_LITE_GROUP_VALID_32_63, valid1);
+
+	seq_puts(s, "\tQ mapping (q2group):\n");
+	for (i = 0; i < 8; i++) {
+		val = mt76_rr(dev, MT_DMASHDL_LITE_Q_MAP(i));
+		seq_printf(s, "\t\tQ_MAP[%d](0x%08x): 0x%08x\n",
+			   i, MT_DMASHDL_LITE_Q_MAP(i), val);
+	}
+
+	seq_puts(s, "\tGroup status (skipping disabled+zero quota):\n");
+	for (i = 0; i < DMASHDL_LITE_GROUP_NUM; i++) {
+		bool enabled = !((i < 32 ? disable0 : disable1) >> (i % 32) & 1);
+		u32 quota, src, ack_reg;
+		u32 pktin, add_ret, ret;
+
+		quota = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_QUOTA(i));
+		if (!enabled && !quota)
+			continue;
+
+		src     = FIELD_GET(MT_DMASHDL_LITE_GROUP_SRC_CNT_MASK,
+				    mt76_rr(dev, MT_DMASHDL_LITE_GROUP_SRC_CNT(i)));
+		ack_reg = mt76_rr(dev, MT_DMASHDL_LITE_GROUP_ACK_CNT(i));
+		pktin   = FIELD_GET(MT_DMASHDL_LITE_ACK_PKTIN_CNT,   ack_reg);
+		add_ret = FIELD_GET(MT_DMASHDL_LITE_ACK_ADD_RET_CNT, ack_reg);
+		ret     = FIELD_GET(MT_DMASHDL_LITE_ACK_RET_CNT,     ack_reg);
+
+		seq_printf(s, "\tGroup %2d: quota(min/max)=0x%03x/0x%03x, src=0x%02x, ack(add_ret/pktin/ret)=0x%02x/0x%02x/0x%02x%s\n",
+			   i,
+			   FIELD_GET(MT_DMASHDL_LITE_GROUP_MIN_QUOTA_MASK, quota),
+			   FIELD_GET(MT_DMASHDL_LITE_GROUP_MAX_QUOTA_MASK, quota),
+			   src, add_ret, pktin, ret,
+			   enabled ? "" : " [disabled]");
+		if (enabled) {
+			total_src += src;
+			total_ack += ret;
+		}
+	}
+	seq_printf(s, "\tTotal (enabled groups): src=0x%03x, ack_ret=0x%03x\n",
+		   total_src, total_ack);
+
+	/* Counter mismatch check against PLE HIF page counters */
+	seq_puts(s, "\nDMASHDL Lite Counter Check:\n");
+	val = mt76_rr(dev, MT_PLE_HIF_PG_INFO);
+	ple_rsv = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	ple_src = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	seq_printf(s, "\tPLE: used/rsv pages of HIF group=0x%03x/0x%03x\n",
+		   ple_src, ple_rsv);
+	seq_printf(s, "\tDMASHDL Lite: total src=0x%03x, total ack_ret=0x%03x\n",
+		   total_src, total_ack);
+	if (ple_src != total_src)
+		seq_puts(s, "\t[MISMATCH] PLE used pages != DMASHDL Lite total src\n");
+	else
+		seq_puts(s, "\tDMASHDL Lite: no counter mismatch\n");
+
+	seq_puts(s, "\nPLE Page Counters:\n");
+
+	val = mt76_rr(dev, MT_PLE_FREEPG_CNT);
+	seq_printf(s, "\tPLE free pages(0x%08x): total=0x%03x, ffa=0x%03x\n",
+		   MT_PLE_FREEPG_CNT,
+		   FIELD_GET(MT_WF_FREEPG_FREE_CNT, val),
+		   FIELD_GET(MT_WF_FREEPG_FFA_CNT, val));
+
+	val = mt76_rr(dev, MT_PLE_HIF_WMTXD_PG_INFO);
+	seq_printf(s, "\tPLE WMTXD group(0x%08x):     used/rsv=0x%03x/0x%03x\n",
+		   MT_PLE_HIF_WMTXD_PG_INFO,
+		   FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val),
+		   FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val));
+
+	val = mt76_rr(dev, MT_PLE_HIF_TXCMD_PG_INFO);
+	seq_printf(s, "\tPLE HIF_TXCMD group(0x%08x): used/rsv=0x%03x/0x%03x\n",
+		   MT_PLE_HIF_TXCMD_PG_INFO,
+		   FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val),
+		   FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val));
+
+	val = mt76_rr(dev, MT_PLE_CPU_PG_INFO);
+	seq_printf(s, "\tPLE CPU group(0x%08x):       used/rsv=0x%03x/0x%03x\n",
+		   MT_PLE_CPU_PG_INFO,
+		   FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val),
+		   FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val));
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
+static int
+mt7925_ple_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 pbuf_ctrl, val;
+	u32 fpg_cnt, ffa_cnt, fpg_head, fpg_tail;
+	u32 max_q, min_q, rsv_pg, used_pg;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "PLE dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	pbuf_ctrl = mt76_rr(dev, MT_PLE_PBUF_CTRL);
+	seq_puts(s, "PLE Configuration Info:\n");
+	seq_printf(s, "\tPacket Buffer Control(0x%08x): 0x%08x\n",
+		   MT_PLE_PBUF_CTRL, pbuf_ctrl);
+	seq_printf(s, "\t\tPage Size=%d(%d bytes/page), Offset=%d, Total=%d pages\n",
+		   (int)FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl),
+		   FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl) ? 128 : 64,
+		   (int)FIELD_GET(MT_WF_PBUF_PBUF_OFFSET, pbuf_ctrl),
+		   (int)FIELD_GET(MT_WF_PBUF_TOTAL_PAGES, pbuf_ctrl));
+
+	val = mt76_rr(dev, MT_PLE_INT_N9_ERR_STS);
+	seq_printf(s, "\tINT_N9_ERR_STS(0x%08x): 0x%08x\n",
+		   MT_PLE_INT_N9_ERR_STS, val);
+	val = mt76_rr(dev, MT_PLE_INT_N9_ERR_STS_1);
+	seq_printf(s, "\tINT_N9_ERR_STS_1(0x%08x): 0x%08x\n",
+		   MT_PLE_INT_N9_ERR_STS_1, val);
+
+	seq_puts(s, "PLE Page Flow Control:\n");
+
+	val = mt76_rr(dev, MT_PLE_FREEPG_CNT);
+	fpg_cnt = FIELD_GET(MT_WF_FREEPG_FREE_CNT, val);
+	ffa_cnt = FIELD_GET(MT_WF_FREEPG_FFA_CNT, val);
+	seq_printf(s, "\tFree page counter(0x%08x): 0x%08x\n",
+		   MT_PLE_FREEPG_CNT, val);
+	seq_printf(s, "\t\ttotal free=0x%03x, ffa=0x%03x\n", fpg_cnt, ffa_cnt);
+
+	val = mt76_rr(dev, MT_PLE_FREEPG_HEAD_TAIL);
+	fpg_head = FIELD_GET(MT_WF_FREEPG_HEAD, val);
+	fpg_tail = FIELD_GET(MT_WF_FREEPG_TAIL, val);
+	seq_printf(s, "\tFree page head/tail(0x%08x): 0x%08x\n",
+		   MT_PLE_FREEPG_HEAD_TAIL, val);
+	seq_printf(s, "\t\ttail/head=0x%03x/0x%03x\n", fpg_tail, fpg_head);
+
+	/* HIF group */
+	val = mt76_rr(dev, MT_PLE_PG_HIF_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tHIF group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_HIF_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_HIF_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tHIF group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_HIF_PG_INFO, val, used_pg, rsv_pg);
+
+	/* WMTXD group */
+	val = mt76_rr(dev, MT_PLE_PG_HIF_WMTXD_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tWMTXD group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_HIF_WMTXD_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_HIF_WMTXD_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tWMTXD group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_HIF_WMTXD_PG_INFO, val, used_pg, rsv_pg);
+
+	/* HIF_TXCMD group */
+	val = mt76_rr(dev, MT_PLE_PG_HIF_TXCMD_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tHIF_TXCMD group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_HIF_TXCMD_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_HIF_TXCMD_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tHIF_TXCMD group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_HIF_TXCMD_PG_INFO, val, used_pg, rsv_pg);
+
+	/* CPU group */
+	val = mt76_rr(dev, MT_PLE_PG_CPU_GROUP);
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);
+	seq_printf(s, "\tCPU group quota(0x%08x): 0x%08x (max/min=0x%03x/0x%03x)\n",
+		   MT_PLE_PG_CPU_GROUP, val, max_q, min_q);
+	val = mt76_rr(dev, MT_PLE_CPU_PG_INFO);
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);
+	seq_printf(s, "\tCPU group status(0x%08x): 0x%08x (used/rsv=0x%03x/0x%03x)\n",
+		   MT_PLE_CPU_PG_INFO, val, used_pg, rsv_pg);
+
+	val = mt76_rr(dev, MT_PLE_QUEUE_EMPTY);
+	seq_printf(s, "\tQueue empty(0x%08x): 0x%08x%s\n",
+		   MT_PLE_QUEUE_EMPTY, val,
+		   (val & MT_PLE_QUEUE_EMPTY_ALL_AC) ? " [ALL AC EMPTY]" : "");
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
+static int
+mt7925_pse_read(struct seq_file *s, void *data)
+{
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	u32 pbuf_ctrl, val;
+	u32 fpg_cnt, ffa_cnt, fpg_head, fpg_tail;
+	u32 max_q, min_q, rsv_pg, used_pg;
+
+	if (!mt76_is_mmio(&dev->mt76)) {
+		seq_puts(s, "PSE dump not supported on this interface\n");
+		return 0;
+	}
+
+	mt792x_mutex_acquire(dev);
+
+	pbuf_ctrl = mt76_rr(dev, MT_PSE_PBUF_CTRL);
+	seq_puts(s, "PSE Configuration Info:\n");
+	seq_printf(s, "\tPacket Buffer Control(0x%08x): 0x%08x\n",
+		   MT_PSE_PBUF_CTRL, pbuf_ctrl);
+	seq_printf(s, "\t\tPage Size=%d(%d bytes/page), Offset=%d, Total=%d pages\n",
+		   (int)FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl),
+		   FIELD_GET(MT_WF_PBUF_PAGE_SIZE, pbuf_ctrl) ? 256 : 128,
+		   (int)FIELD_GET(MT_WF_PBUF_PBUF_OFFSET, pbuf_ctrl),
+		   (int)FIELD_GET(MT_WF_PBUF_TOTAL_PAGES, pbuf_ctrl));
+
+	val = mt76_rr(dev, MT_PSE_INT_N9_ERR_STS);
+	seq_printf(s, "\tINT_N9_ERR_STS(0x%08x): 0x%08x\n",
+		   MT_PSE_INT_N9_ERR_STS, val);
+	val = mt76_rr(dev, MT_PSE_INT_N9_ERR1_STS);
+	seq_printf(s, "\tINT_N9_ERR1_STS(0x%08x): 0x%08x\n",
+		   MT_PSE_INT_N9_ERR1_STS, val);
+
+	val = mt76_rr(dev, MT_PSE_QUEUE_EMPTY);
+	seq_printf(s, "\tQueue empty(0x%08x): 0x%08x\n",
+		   MT_PSE_QUEUE_EMPTY, val);
+
+	seq_puts(s, "PSE Page Flow Control:\n");
+
+	val = mt76_rr(dev, MT_PSE_FREEPG_CNT);
+	fpg_cnt = FIELD_GET(MT_WF_FREEPG_FREE_CNT, val);
+	ffa_cnt = FIELD_GET(MT_WF_FREEPG_FFA_CNT, val);
+	seq_printf(s, "\tFree page counter(0x%08x): 0x%08x\n",
+		   MT_PSE_FREEPG_CNT, val);
+	seq_printf(s, "\t\ttotal free=0x%03x, ffa=0x%03x\n", fpg_cnt, ffa_cnt);
+
+	val = mt76_rr(dev, MT_PSE_FREEPG_HEAD_TAIL);
+	fpg_head = FIELD_GET(MT_WF_FREEPG_HEAD, val);
+	fpg_tail = FIELD_GET(MT_WF_FREEPG_TAIL, val);
+	seq_printf(s, "\tFree page head/tail(0x%08x): 0x%08x\n",
+		   MT_PSE_FREEPG_HEAD_TAIL, val);
+	seq_printf(s, "\t\ttail/head=0x%03x/0x%03x\n", fpg_tail, fpg_head);
+
+#define MT7925_PSE_GROUP(_name, _qreg, _ireg)					\
+do {										\
+	val = mt76_rr(dev, _qreg);						\
+	max_q = FIELD_GET(MT_WF_GROUP_QUOTA_MAX, val);				\
+	min_q = FIELD_GET(MT_WF_GROUP_QUOTA_MIN, val);				\
+	seq_printf(s, "\t" _name " group quota(0x%08x): 0x%08x"		\
+		   " (max/min=0x%03x/0x%03x)\n", _qreg, val, max_q, min_q);	\
+	val = mt76_rr(dev, _ireg);						\
+	used_pg = FIELD_GET(MT_WF_PG_INFO_SRC_CNT, val);			\
+	rsv_pg  = FIELD_GET(MT_WF_PG_INFO_RSV_CNT, val);			\
+	seq_printf(s, "\t" _name " group status(0x%08x): 0x%08x"		\
+		   " (used/rsv=0x%03x/0x%03x)\n", _ireg, val, used_pg, rsv_pg);\
+} while (0)
+
+	MT7925_PSE_GROUP("HIF0",  MT_PSE_PG_HIF0_GROUP,  MT_PSE_HIF0_PG_INFO);
+	MT7925_PSE_GROUP("HIF1",  MT_PSE_PG_HIF1_GROUP,  MT_PSE_HIF1_PG_INFO);
+	MT7925_PSE_GROUP("HIF2",  MT_PSE_PG_HIF2_GROUP,  MT_PSE_HIF2_PG_INFO);
+	MT7925_PSE_GROUP("CPU",   MT_PSE_PG_CPU_GROUP,   MT_PSE_CPU_PG_INFO);
+	MT7925_PSE_GROUP("PLE",   MT_PSE_PG_PLE_GROUP,   MT_PSE_PLE_PG_INFO);
+	MT7925_PSE_GROUP("LMAC0", MT_PSE_PG_LMAC0_GROUP, MT_PSE_LMAC0_PG_INFO);
+	MT7925_PSE_GROUP("LMAC1", MT_PSE_PG_LMAC1_GROUP, MT_PSE_LMAC1_PG_INFO);
+	MT7925_PSE_GROUP("LMAC2", MT_PSE_PG_LMAC2_GROUP, MT_PSE_LMAC2_PG_INFO);
+	MT7925_PSE_GROUP("LMAC3", MT_PSE_PG_LMAC3_GROUP, MT_PSE_LMAC3_PG_INFO);
+	MT7925_PSE_GROUP("MDP",   MT_PSE_PG_MDP_GROUP,   MT_PSE_MDP_PG_INFO);
+
+#undef MT7925_PSE_GROUP
+
+	mt792x_mutex_release(dev);
+	return 0;
+}
+
+static const u32 stats_query_mib_counters[] = {
+	UNI_CMD_MIB_CNT_RX_FCS_ERR,
+	UNI_CMD_MIB_CNT_RX_FIFO_OVERFLOW,
+	UNI_CMD_MIB_CNT_RX_MPDU,
+	UNI_CMD_MIB_CNT_AMPDU_RX_COUNT,
+	UNI_CMD_MIB_CNT_PF_DROP,
+	UNI_CMD_MIB_CNT_LEN_MISMATCH,
+	UNI_CMD_MIB_CNT_CHANNEL_IDLE,
+	UNI_CMD_MIB_CNT_CCA_NAV_TX_TIME,
+	UNI_CMD_MIB_CNT_MDRDY,
+	UNI_CMD_MIB_CNT_RX_CCK_MDRDY_TIME,
+	UNI_CMD_MIB_CNT_RX_OFDM_LG_MIXED_MDRDY_TIME,
+	UNI_CMD_MIB_CNT_RX_OFDM_GREEN_MDRDY_TIME,
+	UNI_CMD_MIB_CNT_P_CCA_TIME,
+	UNI_CMD_MIB_CNT_S_CCA_TIME,
+	UNI_CMD_MIB_CNT_P_ED_TIME,
+	UNI_CMD_MIB_CNT_BCN_TX,
+	UNI_CMD_MIB_CNT_TX_BW_40MHZ,
+	UNI_CMD_MIB_CNT_TX_BW_80MHZ,
+	UNI_CMD_MIB_CNT_TX_BW_160MHZ,
+	UNI_CMD_MIB_CNT_BSS0_BA_MISS,
+	UNI_CMD_MIB_CNT_BSS0_RTS_TX_CNT,
+	UNI_CMD_MIB_CNT_BSS0_FRAME_RETRY,
+	UNI_CMD_MIB_CNT_BSS0_FRAME_RETRY_2,
+	UNI_CMD_MIB_CNT_BSS0_RTS_RETRY,
+	UNI_CMD_MIB_CNT_BSS0_ACK_FAIL,
+	UNI_CMD_MIB_CNT_AMPDU,
+	UNI_CMD_MIB_CNT_AMPDU_MPDU,
+	UNI_CMD_MIB_CNT_AMPDU_ACKED,
+};
+
+/* Dump the whole firmware auto-rate table and mark the entry currently in use
+ * with "-->"
+ */
+static void
+mt7925_dump_auto_rate_table(struct seq_file *s,
+			    const struct mt7925_wtbl_rate *wr)
+{
+	u8 fcap = wr->fcap;
+	u8 rate_idx = wr->rate_idx;
+	u8 cbrn = wr->cbrn;
+	int i;
+
+	seq_printf(s, "%-22s  Cur Rate Index = %u\n", " ", rate_idx);
+
+	for (i = 0; i < MT7925_AUTO_RATE_NUM; i++) {
+		u16 rate_code = le16_to_cpu(wr->rate_code[i]);
+		u8 txmode = MT7925_HW_RATE_TO_MODE(rate_code);
+		u8 rate = MT7925_HW_RATE_TO_MCS(rate_code);
+		u8 nsts = MT7925_HW_RATE_TO_NSS(rate_code) + 1;
+		u8 stbc = MT7925_HW_RATE_TO_STBC(rate_code);
+		u8 dcm = MT7925_HW_RATE_TO_DCM(rate_code);
+		u8 ersu106t = MT7925_HW_RATE_TO_106T(rate_code);
+		u8 sgi = mt7925_wtbl_get_sgi(wr, txmode, fcap);
+		u8 ldpc = mt7925_wtbl_get_ldpc(wr, txmode);
+		const char *mode_str = "N/A";
+
+		if (dcm)
+			rate = MT7925_HW_RATE_UNMASK_DCM(rate);
+		if (ersu106t)
+			rate = MT7925_HW_RATE_UNMASK_106T(rate);
+
+		if (txmode < ARRAY_SIZE(mt7925_tx_mode_str))
+			mode_str = mt7925_tx_mode_str[txmode];
+
+		seq_printf(s, "Rate index[%d]    %s", i,
+			   rate_idx == i ? "--> " : "    ");
+
+		/* rate/MCS field */
+		if (txmode == MT7925_TX_RATE_MODE_CCK)
+			seq_printf(s, "%s, ",
+				   mt7925_tx_rate_cck_str[rate & 0x3]);
+		else if (txmode == MT7925_TX_RATE_MODE_OFDM)
+			seq_printf(s, "%s, ", mt7925_hw_rate_ofdm_str(rate));
+		else if (txmode == MT7925_TX_RATE_MODE_HTMIX ||
+			 txmode == MT7925_TX_RATE_MODE_HTGF)
+			seq_printf(s, "MCS%d, ", rate);
+		else
+			seq_printf(s, "%s%d_MCS%d, ",
+				   stbc ? "NSTS" : "NSS", nsts, rate);
+
+		/* bandwidth: mirror the CCK/OFDM -> BW20 and cbrn handling */
+		if (txmode == MT7925_TX_RATE_MODE_CCK ||
+		    txmode == MT7925_TX_RATE_MODE_OFDM)
+			seq_printf(s, "%s, ", mt7925_tx_rate_bw_str[0]);
+		else if (i > cbrn)
+			seq_printf(s, "%s, ",
+				   fcap < 5 ?
+				   (fcap > MT7925_BW_20 ?
+				    mt7925_tx_rate_bw_str[fcap - 1] :
+				    mt7925_tx_rate_bw_str[fcap]) :
+				   mt7925_tx_rate_bw_str[5]);
+		else
+			seq_printf(s, "%s, ",
+				   fcap < 5 ? mt7925_tx_rate_bw_str[fcap] :
+				   mt7925_tx_rate_bw_str[5]);
+
+		/* GI / preamble */
+		if (txmode == MT7925_TX_RATE_MODE_CCK)
+			seq_printf(s, "%s, ", rate < 4 ? "LP" : "SP");
+		else if (txmode == MT7925_TX_RATE_MODE_OFDM)
+			; /* OFDM has no GI/preamble to print */
+		else if (txmode == MT7925_TX_RATE_MODE_HTMIX ||
+			 txmode == MT7925_TX_RATE_MODE_HTGF ||
+			 txmode == MT7925_TX_RATE_MODE_VHT ||
+			 txmode == MT7925_TX_RATE_MODE_PLR)
+			seq_printf(s, "%s, ", sgi == 0 ? "LGI" : "SGI");
+		else
+			seq_printf(s, "%s, ",
+				   sgi == 0 ? "SGI" :
+				   (sgi == 1 ? "MGI" : "LGI"));
+
+		/* mode, DCM, 106t, STBC, coding */
+		seq_printf(s, "%s%s%s%s%s\n",
+			   mode_str,
+			   dcm ? ", DCM" : "", ersu106t ? ", 106t" : "",
+			   stbc ? ", STBC, " : ", ",
+			   (ldpc == 0 ||
+			    txmode == MT7925_TX_RATE_MODE_CCK ||
+			    txmode == MT7925_TX_RATE_MODE_OFDM) ?
+			   "BCC" : "LDPC");
+	}
+}
+
+static int mt792x_stats(struct seq_file *s, void *data)
+{
+	s8 rssi = 0;
+	u8 band_idx = 0;
+	bool wtbl_rate_valid = false;
+	int ret = 0;
+	int i = 0;
+	u32 stats_value = 0;
+	u32 tx_link_speed_kbps = 0;
+	u64 tx_total = 0;
+	u64 tx_fail = 0;
+	u64 tx_per = 0;
+	/* UNI_CMD_MIB_DATA */
+	u64 mib_values[ARRAY_SIZE(stats_query_mib_counters)];
+	struct mt792x_dev *dev = dev_get_drvdata(s->private);
+	struct mt7925_wtbl_rate wtbl_rate;
+	struct mt7925_sta_stats *stats = NULL;
+
+	band_idx = dev->mphy.band_idx;
+
+	 stats = kzalloc(sizeof(*stats), GFP_KERNEL);
+	if (!stats)
+		return -ENOMEM;
+
+	/* Get STA_STATS */
+	mt792x_mutex_acquire(dev);
+	ret = mt792x_mcu_get_stat(dev, stats);
+	mt792x_mutex_release(dev);
+	if (ret)
+		goto out;
+
+	/* Get MIB_STATS */
+	mt792x_mutex_acquire(dev);
+	ret = mt7925_mcu_get_mib_info(dev, band_idx, stats_query_mib_counters,
+				      ARRAY_SIZE(stats_query_mib_counters), mib_values);
+	mt792x_mutex_release(dev);
+	if (ret)
+		goto out;
+
+	/* Get Link_Speed and RSSI */
+	mt792x_mutex_acquire(dev);
+	ret = mt7925_mcu_get_link_quality(dev, stats->bss_idx, &rssi, &tx_link_speed_kbps);
+	mt792x_mutex_release(dev);
+	if (ret)
+		goto out;
+
+	/* Get the firmware auto-rate table (best effort; do not abort the
+	 * whole stats dump if the WTBL query is not available).
+	 */
+	mt792x_mutex_acquire(dev);
+	if (!mt792x_mcu_get_wtbl_rate(dev, stats->wtbl_idx, &wtbl_rate))
+		wtbl_rate_valid = true;
+	mt792x_mutex_release(dev);
+
+	/* Print STA_STATS info */
+	seq_printf(s, "(STA) connected AP MAC Address = %pM\n", stats->mac_addr);
+	seq_printf(s, "%-22s  BssIdx = [%u]\n", " ", stats->bss_idx);
+	seq_printf(s, "%-22s  StaRecIdx = [%u]\n",
+		   " ", stats->sta_idx);
+	seq_printf(s, "%-22s  RSSI = %d\n", " ", rssi);
+	seq_printf(s, "%-22s  Link_Speed = %u (kbit/s)\n", " ", tx_link_speed_kbps);
+
+	seq_printf(s, "%-22s  temperature = %u\n",
+		   " ", stats->temperature);
+
+	stats_value = le32_to_cpu(stats->transmit_count) - le32_to_cpu(stats->transmit_fail_count);
+	seq_printf(s, "%-22s  Tx success = %u\n",
+		   " ", stats_value);
+
+	stats_value = le32_to_cpu(stats->tx_fail_count) - le32_to_cpu(stats->tx_life_timeout_count);
+	seq_printf(s, "%-22s  Tx fail to Rcv ACK after retry = %u\n",
+		   " ", stats_value);
+
+	seq_printf(s, "%-22s  Rx Mpdu = %u\n",
+		   " ", le32_to_cpu(stats->mib[band_idx].rx_mpdu_cnt));
+
+	seq_printf(s, "%-22s  Rx Fcs Error = %u (MPDU)\n",
+		   " ", le32_to_cpu(stats->mib[band_idx].fcs_error));
+	seq_printf(s, "%-22s  Rx FIFO full = %u (MPDU)\n",
+		   " ", le32_to_cpu(stats->mib[band_idx].rx_fifo_full));
+
+	for (i = 0; i < STAT_MIB_CNT_TRX_AGG_RANGE_MAX_NUM; i++)
+		seq_printf(s, "%-22s  TRX_AGG_RANGE[%d] = %u (PPDU)\n",
+			   " ", i, le32_to_cpu(stats->mib[band_idx].tx_range_ampdu_cnt[i]));
+
+	seq_printf(s, "%-22s  MPDUs in AMPDUs transmitted = %u (MPDU)\n",
+		   " ", le32_to_cpu(stats->mib[band_idx].ampdu_tx_sf_cnt));
+	seq_printf(s, "%-22s  MPDUs in AMPDUs transmitted with ACK reply = %u (MPDU)\n",
+		   " ", le32_to_cpu(stats->mib[band_idx].ampdu_tx_ack_sf_cnt));
+	seq_printf(s, "%-22s  rate1_tx_cnt = %u\n",
+		   " ", le32_to_cpu(stats->rate1_tx_cnt));
+	seq_printf(s, "%-22s  rate1_fail_cnt = %u\n",
+		   " ", le32_to_cpu(stats->rate1_fail_cnt));
+	seq_printf(s, "%-22s  train_up = %u\n",
+		   " ", le16_to_cpu(stats->train_up));
+	seq_printf(s, "%-22s  train_down = %u\n",
+		   " ", le16_to_cpu(stats->train_down));
+	seq_printf(s, "%-22s  is_force_tx_stream = %u\n",
+		   " ", stats->is_force_tx_stream);
+	seq_printf(s, "%-22s  is_force_se_off = %u\n",
+		   " ", stats->is_force_se_off);
+	seq_printf(s, "%-22s  max_ampdu_factor = %u\n",
+		   " ", stats->max_ampdu_factor);
+	seq_printf(s, "%-22s  tx_rate_up_penalty = %u\n",
+		   " ", stats->tx_rate_up_penalty);
+	seq_printf(s, "%-22s  low_traffic_mode = %u\n",
+		   " ", stats->low_traffic_mode);
+	seq_printf(s, "%-22s  low_traffic_count = %u\n",
+		   " ", stats->low_traffic_count);
+	seq_printf(s, "%-22s  low_traffic_dashboard = %u\n",
+		   " ", stats->low_traffic_dashboard);
+	seq_printf(s, "%-22s  dynamic_sgi_state = %u\n",
+		   " ", stats->dynamic_sgi_state);
+	seq_printf(s, "%-22s  dynamic_sgi_score = %u\n",
+		   " ", stats->dynamic_sgi_score);
+	seq_printf(s, "%-22s  dynamic_bw_state = %u\n",
+		   " ", stats->dynamic_bw_state);
+	seq_printf(s, "%-22s  dynamic_gband_256qam_state = %u\n",
+		   " ", stats->dynamic_gband_256qam_state);
+	seq_printf(s, "%-22s  vht_non_sp_rate_state = %u\n",
+		   " ", stats->vht_non_sp_rate_state);
+
+	/* Decode the TX Vector BBP latch to show the current TX MCS rate */
+	if (band_idx < MT7925_STA_STATS_BAND_NUM)
+		mt7925_print_last_tx_rate(s, stats->tx_vector[band_idx].txv);
+
+	/* Dump the whole firmware auto-rate table and mark the entry currently */
+	if (wtbl_rate_valid)
+		mt7925_dump_auto_rate_table(s, &wtbl_rate);
+
+	seq_puts(s, "\nmib state:\n");
+	/* ===Rx Related Counters=== */
+	seq_puts(s, "=== Rx Related Counters ===\n");
+	seq_printf(s, "%-22s  Rx with CRC = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_RX_FCS_ERR]);
+	seq_printf(s, "%-22s  Rx drop due to out of resource = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_RX_FIFO_OVERFLOW]);
+	seq_printf(s, "%-22s  Rx Mpdu = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_RX_MPDU]);
+	seq_printf(s, "%-22s  Rx AMpdu = %llu (PPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_AMPDU_RX_COUNT]);
+	seq_printf(s, "%-22s  Rx PF Drop = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_PF_DROP]);
+	seq_printf(s, "%-22s  Rx Len Mismatch = %llu (PPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_LEN_MISMATCH]);
+
+	/* ===Phy/Timing Related Counters=== */
+	seq_puts(s, "\n=== Phy/Timing Related Counters ===\n");
+	seq_printf(s, "%-22s  ChannelIdleCnt = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_CHANNEL_IDLE]);
+	seq_printf(s, "%-22s  CCA_NAV_Tx_Time = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_CCA_NAV_TX_TIME]);
+	seq_printf(s, "%-22s  Rx_MDRDY_CNT = %llu (PPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_MDRDY]);
+	seq_printf(s, "%-22s  CCK_MDRDY = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_RX_CCK_MDRDY_TIME]);
+	seq_printf(s, "%-22s  OFDM_MDRDY = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_RX_OFDM_LG_MIXED_MDRDY_TIME]);
+	seq_printf(s, "%-22s  OFDM_GREEN_MDRDY = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_RX_OFDM_GREEN_MDRDY_TIME]);
+	seq_printf(s, "%-22s  Prim CCA Time = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_P_CCA_TIME]);
+	seq_printf(s, "%-22s  Sec CCA Time = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_S_CCA_TIME]);
+	seq_printf(s, "%-22s  Prim ED Time = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_P_ED_TIME]);
+
+	/* ===Tx Related Counters(Generic)=== */
+	seq_puts(s, "\n=== Tx Related Counters(Generic) ===\n");
+	seq_printf(s, "%-22s  BeaconTxCnt = %llu\n",
+		   " ", mib_values[QUERY_MIB_CNT_BCN_TX]);
+	seq_printf(s, "%-22s  Tx 40MHz Cnt = %llu  (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_TX_BW_40MHZ]);
+	seq_printf(s, "%-22s  Tx 80MHz Cnt = %llu  (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_TX_BW_80MHZ]);
+	seq_printf(s, "%-22s  Tx 160MHz Cnt = %llu  (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_TX_BW_160MHZ]);
+
+	/* ===BSSID[0] Related Counters=== */
+	seq_puts(s, "\n=== BSSID[0] Related Counters ===\n");
+	seq_printf(s, "%-22s  BA Miss Cnt = %llu  (PPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_BSS0_BA_MISS]);
+	seq_printf(s, "%-22s  RTS Tx Cnt = %llu  (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_BSS0_RTS_TX_CNT]);
+	seq_printf(s, "%-22s  Frame Retry Cnt = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_BSS0_FRAME_RETRY]);
+	seq_printf(s, "%-22s  Frame Retry 2 Cnt = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_BSS0_FRAME_RETRY_2]);
+	seq_printf(s, "%-22s  RTS Retry Cnt = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_BSS0_RTS_RETRY]);
+	seq_printf(s, "%-22s  Ack Failed Cnt = %llu (PPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_BSS0_ACK_FAIL]);
+
+	/* ===AMPDU Related Counters=== */
+	seq_puts(s, "\n=== AMPDU Related Counters ===\n");
+	seq_printf(s, "%-22s  Tx AMPDU_Pkt_Cnt = %llu  (PPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_AMPDU]);
+	seq_printf(s, "%-22s  Tx AMPDU_MPDU_Pkt_Cnt = %llu  (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_AMPDU_MPDU]);
+	seq_printf(s, "%-22s  AMPDU Tx success = %llu (MPDU)\n",
+		   " ", mib_values[QUERY_MIB_CNT_AMPDU_ACKED]);
+
+	tx_total = mib_values[QUERY_MIB_CNT_AMPDU_MPDU];
+	tx_fail =  mib_values[QUERY_MIB_CNT_AMPDU_MPDU] - mib_values[QUERY_MIB_CNT_AMPDU_ACKED];
+	tx_per = tx_total == 0 ? 0 : (1000 * (tx_fail)) / tx_total;
+	seq_printf(s, "%-22s  AMPDU Tx fail count   = %llu  (MPDU), PER=%llu.%1llu%%\n",
+		   " ",
+		   tx_fail,
+		   tx_per / 10, tx_per % 10);
+
+out:
+	kfree(stats);
+	return ret;
+}
+
 int mt7925_init_debugfs(struct mt792x_dev *dev)
 {
 	struct dentry *dir;
@@ -313,5 +1365,7 @@ int mt7925_init_debugfs(struct mt792x_dev *dev)
 				    mt792x_pm_stats);
 	debugfs_create_file("deep-sleep", 0600, dir, dev, &fops_ds);
 
+	debugfs_create_devm_seqfile(dev->mt76.dev, "stats", dir,
+				    mt792x_stats);
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/stats.c b/drivers/net/wireless/mediatek/mt76/mt7925/stats.c
new file mode 100644
index 000000000000..9a47953062bc
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/stats.c
@@ -0,0 +1,585 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#include <linux/firmware.h>
+#include <linux/fs.h>
+#include "mt7925.h"
+#include "mcu.h"
+#include "mac.h"
+#include "stats.h"
+
+#define MT7925_STA_STATS_VERSION 1
+#define MT7925_STA_STATS_VALID 1U
+
+#define MT7925_MIB_MAX_CNT			32
+#define MT7925_MIB_CNT_MAX_NUM		512  /* firmware UNI_CMD_MIB_CNT_MAX_NUM upper bound */
+
+#define MT7925_LQ_BAND_NUM	4			/* Link quality band */
+
+const char * const mt7925_tx_mode_str[] = {
+	"CCK", "OFDM", "MM", "GF", "VHT", "PLR",
+	"PLRP", "ALR", "HE_SU", "HE_ER", "HE_TRIG", "HE_MU",
+	"EHT_ER", "TOF", "EHT_TRIG", "EHT_MU"
+};
+
+const char * const mt7925_tx_rate_cck_str[] = {
+	"1M", "2M", "5.5M", "11M", "N/A"
+};
+
+const char * const mt7925_tx_rate_bw_str[] = {
+	"BW20", "BW40", "BW80", "BW160/BW8080", "BW320", "N/A"
+};
+
+struct mt7925_sta_stats_req {
+	u8 rsv[4];
+	__le16 tag;
+	__le16 len;
+	u8 sta_rec_idx;
+	u8 rsv1;
+	u8 lls_read_clear;
+	u8 reset_counter;
+} __packed;
+
+struct mt7925_sta_stats_event {
+	u8 rsv[4];
+	__le16 tag;
+	__le16 len;
+	struct mt7925_sta_stats stats;
+} __packed;
+
+/* WTBL auto-rate request TLV, mirror Gen4m struct UNI_CMD_STAT_WTBL.
+ * The RA tag reuses UNI_CMD_ID_STATISTICS_WTBL (10).
+ */
+struct mt7925_wtbl_rate_req {
+	u8 rsv[4];
+	__le16 tag;
+	__le16 len;
+	__le16 wlan_idx;
+	__le16 rsv1;
+} __packed;
+
+/* WTBL auto-rate event TLV. Firmware answers cmd tag 10 with event tag 12. */
+struct mt7925_wtbl_rate_event {
+	u8 rsv[4];
+	struct mt7925_wtbl_rate rate;
+} __packed;
+
+/* fixed field, mirror UNI_(CMD|EVENT)_MIB_INFO */
+struct mt7925_mib_hdr {
+	u8 band_idx;
+	u8 rsv[3];
+} __packed;
+
+/* One requested/returned MIB counter, mirror UNI_(CMD|EVENT)_MIB_DATA_T. */
+struct mt7925_mib_data {
+	__le16 tag;	/* UNI_(CMD|EVENT)_MIB_DATA = 0 */
+	__le16 len;
+	__le32 counter;	/* MIB counter ID (enum mt7925_mib_counter) */
+	__le64 data;	/* only valid on event; ignored on cmd */
+} __packed;
+
+/* per-band link quality entry, mirror UNI_LINK_QUALITY */
+struct mt7925_link_quality {
+	s8 rssi;		/* moving-average beacon RSSI of connected AP */
+	s8 link_quality;	/* always 0 */
+	__le16 link_speed;	/* TX rate1, unit 500 Kb/s */
+	u8 medium_busy_pct;	/* always 0 */
+	u8 is_ready;		/* 0: fields invalid, 1: valid */
+	u8 rsv[2];
+} __packed;
+
+/* request TLV, mirror UNI_CMD_LINK_QUALITY (header + tag/len only) */
+struct mt7925_lq_req {
+	u8 rsv[4];		/* UNI_CMD_GET_STATISTICS fixed field */
+	__le16 tag;		/* UNI_CMD_GET_STATISTICS_TAG_LINK_QUALITY = 1 */
+	__le16 len;
+} __packed;
+
+/* event TLV, mirror UNI_EVENT_LINK_QUALITY */
+struct mt7925_lq_event {
+	u8 rsv[4];		/* UNI_EVENT_STATISTICS fixed field */
+	__le16 tag;		/* UNI_EVENT_ID_STATISTICS_LINK_QUALITY = 1 */
+	__le16 len;
+	struct mt7925_link_quality lq[MT7925_LQ_BAND_NUM];
+} __packed;
+
+static void
+mt7925_get_ap_sta_rec_idx_iter(void *data, u8 *mac,
+			       struct ieee80211_vif *vif)
+{
+	struct mt7925_sta_rec_lookup *lookup = data;
+	struct mt792x_vif *mvif;
+	struct mt792x_sta *msta;
+
+	if (lookup->sta_rec_idx >= 0)
+		return;
+
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->cfg.assoc)
+		return;
+
+	mvif = (struct mt792x_vif *)vif->drv_priv;
+	msta = mvif->wep_sta;
+	if (!msta)
+		return;
+
+	if (!msta->deflink.wcid.sta)
+		return;
+
+	lookup->sta_rec_idx = msta->deflink.wcid.idx;
+}
+
+int
+mt7925_get_ap_sta_rec_idx(struct mt792x_dev *dev, u8 *sta_rec_idx)
+{
+	struct mt7925_sta_rec_lookup lookup = {
+		.sta_rec_idx = -1,
+	};
+
+	lockdep_assert_held(&dev->mt76.mutex);
+
+	ieee80211_iterate_active_interfaces(dev->mphy.hw,
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
+					    mt7925_get_ap_sta_rec_idx_iter,
+					    &lookup);
+
+	if (lookup.sta_rec_idx < 0)
+		return -ENOTCONN;
+
+	if (lookup.sta_rec_idx > U8_MAX)
+		return -ERANGE;
+
+	*sta_rec_idx = lookup.sta_rec_idx;
+
+	return 0;
+}
+
+/* Decode the TX Vector BBP latch and print the last TX rate */
+void
+mt7925_print_last_tx_rate(struct seq_file *s, const __le32 le_txv[3])
+{
+	const char *mode_str = "N/A";
+	u8 rate, txmode, frmode, sgi, ldpc, nsts, stbc, spe, dcm, ersu106t;
+	s8 txpwr, pos_txpwr;
+	u32 txv[3];
+
+	txv[0] = le32_to_cpu(le_txv[0]);
+	txv[1] = le32_to_cpu(le_txv[1]);
+	txv[2] = le32_to_cpu(le_txv[2]);
+
+	if (txv[0] == 0xffffffff) {
+		seq_printf(s, "%-22s  %s = %s\n", " ", "Last TX Rate", "N/A");
+		seq_printf(s, "%-22s  %s = %s\n",
+			   " ", "Chip Out TX Power", "N/A");
+		return;
+	}
+
+	rate = MT7925_TXV_GET_TX_RATE(txv);
+	txmode = MT7925_TXV_GET_TX_MODE(txv);
+	frmode = MT7925_TXV_GET_TX_FRMODE(txv);
+	nsts = MT7925_TXV_GET_TX_NSTS(txv) + 1;
+	sgi = MT7925_TXV_GET_TX_SGI(txv);
+	ldpc = MT7925_TXV_GET_TX_LDPC(txv);
+	stbc = MT7925_TXV_GET_TX_STBC(txv);
+	txpwr = MT7925_TXV_GET_TX_PWR(txv);
+	spe = MT7925_TXV_GET_TX_SPE_IDX(txv);
+	dcm = MT7925_TXV_GET_TX_DCM(txv);
+	ersu106t = MT7925_TXV_GET_TX_106T(txv);
+
+	if (dcm)
+		rate = MT7925_TXV_RATE_UNMASK_DCM(rate);
+	if (ersu106t)
+		rate = MT7925_TXV_RATE_UNMASK_106T(rate);
+
+	if (txmode < ARRAY_SIZE(mt7925_tx_mode_str))
+		mode_str = mt7925_tx_mode_str[txmode];
+
+	seq_printf(s, "%-22s  %s = ", " ", "Last TX Rate");
+
+	/* rate/MCS field */
+	if (txmode == MT7925_TX_RATE_MODE_CCK)
+		seq_printf(s, "%s, ",
+			   rate < 4 ? mt7925_tx_rate_cck_str[rate] :
+			   (((rate >= 5) && (rate <= 7)) ?
+			    mt7925_tx_rate_cck_str[rate - 4] :
+			    mt7925_tx_rate_cck_str[4]));
+	else if (txmode == MT7925_TX_RATE_MODE_OFDM)
+		seq_printf(s, "%s, ", mt7925_hw_rate_ofdm_str(rate));
+	else if (txmode == MT7925_TX_RATE_MODE_HTMIX ||
+		 txmode == MT7925_TX_RATE_MODE_HTGF)
+		seq_printf(s, "MCS%d, ", rate);
+	else
+		seq_printf(s, "%s%d_MCS%d, ",
+			   stbc ? "NSTS" : "NSS", nsts, rate);
+
+	/* bandwidth */
+	seq_printf(s, "%s, ",
+		   frmode < 5 ? mt7925_tx_rate_bw_str[frmode] :
+		   mt7925_tx_rate_bw_str[5]);
+
+	/* GI / preamble */
+	if (txmode == MT7925_TX_RATE_MODE_CCK)
+		seq_printf(s, "%s, ", rate < 4 ? "LP" : "SP");
+	else if (txmode == MT7925_TX_RATE_MODE_OFDM)
+		; /* OFDM has no GI/preamble to print */
+	else if (txmode == MT7925_TX_RATE_MODE_HTMIX ||
+		 txmode == MT7925_TX_RATE_MODE_HTGF ||
+		 txmode == MT7925_TX_RATE_MODE_VHT ||
+		 txmode == MT7925_TX_RATE_MODE_PLR)
+		seq_printf(s, "%s, ", sgi == 0 ? "LGI" : "SGI");
+	else
+		seq_printf(s, "%s, ",
+			   sgi == 0 ? "SGI" : (sgi == 1 ? "MGI" : "LGI"));
+
+	/* mode, DCM, 106t, STBC, coding, SPE */
+	seq_printf(s, "%s%s%s%s%s%s%d\n",
+		   mode_str,
+		   dcm ? ", DCM" : "", ersu106t ? ", 106t" : "",
+		   stbc ? ", STBC, " : ", ", ldpc == 0 ? "BCC" : "LDPC",
+		   ", SPE", spe);
+
+	/* chip out TX power (unit: 0.5 dBm) */
+	pos_txpwr = (txpwr < 0) ? (~txpwr + 1) : txpwr;
+	seq_printf(s, "%-22s  %s = %c%d.%1d dBm\n",
+		   " ", "Chip Out TX Power",
+		   (txpwr < 0) ? '-' : '+',
+		   (pos_txpwr / 2), 5 * (pos_txpwr % 2));
+}
+
+/* Guard interval used for the auto-rate entries, mirror Gen4m
+ * connac3x_get_sgi_info_from_fw(): pick the per-mode/per-BW flag.
+ */
+u8
+mt7925_wtbl_get_sgi(const struct mt7925_wtbl_rate *wr, u8 txmode, u8 fcap)
+{
+	bool he = (txmode == MT7925_TX_RATE_MODE_HE_SU ||
+		   txmode == MT7925_TX_RATE_MODE_HE_ER ||
+		   txmode == MT7925_TX_RATE_MODE_HE_TRIG ||
+		   txmode == MT7925_TX_RATE_MODE_HE_MU);
+	bool eht = (txmode == MT7925_TX_RATE_MODE_EHT_ER ||
+		    txmode == MT7925_TX_RATE_MODE_EHT_TRIG ||
+		    txmode == MT7925_TX_RATE_MODE_EHT_MU);
+
+	if (eht)
+		return wr->gi_eht;
+
+	switch (fcap) {
+	case MT7925_BW_20:
+		return he ? wr->g2_he : wr->g2;
+	case MT7925_BW_40:
+		return he ? wr->g4_he : wr->g4;
+	case MT7925_BW_80:
+		return he ? wr->g8_he : wr->g8;
+	case MT7925_BW_160:
+		return he ? wr->g16_he : wr->g16;
+	default:
+		return 0;
+	}
+}
+
+/* Coding used for the auto-rate entries, mirror Gen4m
+ * connac3x_wtbl_get_ldpc_info_from_fw(): 0 = BCC, 1 = LDPC.
+ */
+u8
+mt7925_wtbl_get_ldpc(const struct mt7925_wtbl_rate *wr, u8 txmode)
+{
+	switch (txmode) {
+	case MT7925_TX_RATE_MODE_HTMIX:
+	case MT7925_TX_RATE_MODE_HTGF:
+		return wr->ht_ldpc;
+	case MT7925_TX_RATE_MODE_VHT:
+		return wr->vht_ldpc;
+	case MT7925_TX_RATE_MODE_HE_SU:
+	case MT7925_TX_RATE_MODE_HE_ER:
+	case MT7925_TX_RATE_MODE_HE_TRIG:
+	case MT7925_TX_RATE_MODE_HE_MU:
+		return wr->he_ldpc;
+	case MT7925_TX_RATE_MODE_EHT_ER:
+	case MT7925_TX_RATE_MODE_EHT_TRIG:
+	case MT7925_TX_RATE_MODE_EHT_MU:
+		return wr->eht_ldpc;
+	default:
+		return 0;
+	}
+}
+
+int mt792x_mcu_get_stat(struct mt792x_dev *dev,
+			struct mt7925_sta_stats *stats)
+{
+	u16 len = 0;
+	int ret = 0;
+	struct mt7925_sta_stats_event *event = NULL;
+	struct sk_buff *skb = NULL;
+	struct mt7925_sta_stats_req req = {
+		.tag = cpu_to_le16(UNI_CMD_ID_STATISTICS_STA),
+		.len = cpu_to_le16(sizeof(req) - sizeof(req.rsv)),
+		.lls_read_clear = false,
+		.reset_counter = false,
+	};
+
+	ret = mt7925_get_ap_sta_rec_idx(dev, &req.sta_rec_idx);
+	if (ret)
+		return ret;
+
+	if (!stats)
+		return -EINVAL;
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_UNI_QUERY(GET_STAT_INFO),
+					&req, sizeof(req), true, &skb);
+
+	if (ret)
+		return ret;
+
+	event = (struct mt7925_sta_stats_event *)skb->data;
+
+	if (le16_to_cpu(event->tag) != UNI_CMD_ID_STATISTICS_STA) {
+		ret = -EPROTO;
+		goto out;
+	}
+
+	len = le16_to_cpu(event->len);
+	if (len < sizeof(*event) - sizeof(event->rsv) ||
+	    len > skb->len - sizeof(event->rsv) || !IS_ALIGNED(len, 4)) {
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	if (event->stats.version != MT7925_STA_STATS_VERSION) {
+		ret = -EPROTO;
+		goto out;
+	}
+
+	if (!(le32_to_cpu(event->stats.flags) & MT7925_STA_STATS_VALID)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	memcpy(stats, &event->stats, sizeof(*stats));
+
+out:
+	dev_kfree_skb(skb);
+	return ret;
+}
+
+int mt7925_mcu_get_mib_info(struct mt792x_dev *dev, u8 band_idx,
+			    const u32 *counters, u8 counter_num,
+			    u64 *values)
+{
+	u8 *req;
+	u8 *tlv, *tlv_end;
+	u16 req_len;
+	int i, ret;
+	struct mt7925_mib_hdr *req_hdr;
+	struct mt7925_mib_data *req_tlv;
+	struct sk_buff *skb;
+
+	if (!counters || !values || !counter_num ||
+	    counter_num > MT7925_MIB_MAX_CNT)
+		return -EINVAL;
+
+	/* clear output; counters not returned by firmware stay 0 */
+	memset(values, 0, counter_num * sizeof(*values));
+
+	req_len = sizeof(struct mt7925_mib_hdr) +
+		  counter_num * sizeof(struct mt7925_mib_data);
+
+	req = kzalloc(req_len, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req_hdr = (struct mt7925_mib_hdr *)req;
+	req_hdr->band_idx = band_idx;
+
+	req_tlv = (struct mt7925_mib_data *)(req + sizeof(*req_hdr));
+	for (i = 0; i < counter_num; i++) {
+		req_tlv[i].tag = cpu_to_le16(UNI_CMD_MIB_DATA);
+		req_tlv[i].len = cpu_to_le16(sizeof(struct mt7925_mib_data));
+		req_tlv[i].counter = cpu_to_le32(counters[i]);
+	}
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_UNI_QUERY(GET_MIB_INFO), req,
+					req_len, true, &skb);
+	kfree(req);
+	if (ret)
+		return ret;
+
+	if (skb->len < sizeof(struct mt7925_mib_hdr)) {
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	/* walk the returned TLVs, match each counter ID to the request */
+	tlv = skb->data + sizeof(struct mt7925_mib_hdr);
+	tlv_end = skb->data + skb->len;
+
+	while (tlv + sizeof(struct mt7925_mib_data) <= tlv_end) {
+		struct mt7925_mib_data *evt_tlv =
+			(struct mt7925_mib_data *)tlv;
+		u16 tag = le16_to_cpu(evt_tlv->tag);
+		u16 len = le16_to_cpu(evt_tlv->len);
+		u32 counter;
+
+		if (len < sizeof(struct mt7925_mib_data) ||
+		    tlv + len > tlv_end)
+			break;
+
+		if (tag == UNI_CMD_MIB_DATA) {
+			counter = le32_to_cpu(evt_tlv->counter);
+
+			if (counter < MT7925_MIB_CNT_MAX_NUM) {
+				for (i = 0; i < counter_num; i++) {
+					if (counters[i] == counter) {
+						values[i] =
+						  le64_to_cpu(evt_tlv->data);
+						break;
+					}
+				}
+			}
+		}
+
+		tlv += len;
+	}
+
+	ret = 0;
+
+out:
+	dev_kfree_skb(skb);
+
+	return ret;
+}
+
+char *mt7925_hw_rate_ofdm_str(u8 ofdm_idx)
+{
+	char * const ofdm_str[] = {
+		"6M", "9M", "12M", "18M", "24M", "36M", "48M", "54M", "N/A"
+	};
+
+	switch (ofdm_idx) {
+	case 11: return ofdm_str[0];	/* 6M */
+	case 15: return ofdm_str[1];	/* 9M */
+	case 10: return ofdm_str[2];	/* 12M */
+	case 14: return ofdm_str[3];	/* 18M */
+	case 9:  return ofdm_str[4];	/* 24M */
+	case 13: return ofdm_str[5];	/* 36M */
+	case 8:  return ofdm_str[6];	/* 48M */
+	case 12: return ofdm_str[7];	/* 54M */
+	default: return ofdm_str[8];
+	}
+}
+
+/* mt792x_mcu_get_wtbl_rate - fetch the firmware auto-rate table for a WCID
+ * @dev:	device
+ * @wlan_idx:	HW WTBL / WCID index (see mt7925_sta_stats.wtbl_idx)
+ * @rate:	out, filled with the auto-rate table snapshot
+ *
+ * Mirror of Gen4m wlanoidGetStatWtbl(): send UNI_CMD_GET_STAT_INFO with the
+ * WTBL rate TLV (cmd tag 10) and parse the reply (event tag 12) into @rate.
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int mt792x_mcu_get_wtbl_rate(struct mt792x_dev *dev, u16 wlan_idx,
+			     struct mt7925_wtbl_rate *rate)
+{
+	int ret;
+	struct mt7925_wtbl_rate_event *event = NULL;
+	struct sk_buff *skb = NULL;
+	struct mt7925_wtbl_rate_req req = {
+		.tag = cpu_to_le16(UNI_CMD_ID_STATISTICS_WTBL),
+		.len = cpu_to_le16(sizeof(req) - sizeof(req.rsv)),
+		.wlan_idx = cpu_to_le16(wlan_idx),
+	};
+
+	if (!rate)
+		return -EINVAL;
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_UNI_QUERY(GET_STAT_INFO),
+					&req, sizeof(req), true, &skb);
+	if (ret)
+		return ret;
+
+	if (skb->len < sizeof(*event)) {
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	event = (struct mt7925_wtbl_rate_event *)skb->data;
+
+	if (le16_to_cpu(event->rate.tag) != MT7925_UNI_EVENT_STATISTICS_WTBL) {
+		ret = -EPROTO;
+		goto out;
+	}
+
+	memcpy(rate, &event->rate, sizeof(*rate));
+	ret = 0;
+
+out:
+	dev_kfree_skb(skb);
+	return ret;
+}
+
+/**
+ * mt7925_mcu_get_link_quality - query RSSI and TX link speed for a band
+ * @dev:	device
+ * @band_idx:	band/BSS index (0..3)
+ * @rssi:	out, moving-average beacon RSSI in dBm (may be NULL)
+ * @tx_link_speed_kbps: out, TX rate in kbit/s (may be NULL)
+ *
+ * Return: 0 on success, -ENOENT if the band's link quality is not ready.
+ *
+ * Only RSSI and TX rate come from firmware here; for RX rate read wcid->rate.
+ */
+int mt7925_mcu_get_link_quality(struct mt792x_dev *dev, u8 band_idx,
+				s8 *rssi, u32 *tx_link_speed_kbps)
+{
+	int ret;
+	struct mt7925_lq_event *event;
+	struct mt7925_link_quality *lq;
+	struct sk_buff *skb;
+	struct mt7925_lq_req req = {
+		.tag = cpu_to_le16(UNI_CMD_ID_STATISTICS_LINK_QUALITY),
+		.len = cpu_to_le16(sizeof(req) - sizeof(req.rsv)),
+	};
+
+	if (band_idx >= MT7925_LQ_BAND_NUM)
+		return -EINVAL;
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_UNI_QUERY(GET_STAT_INFO), &req,
+					sizeof(req), true, &skb);
+	if (ret)
+		return ret;
+
+	if (skb->len < sizeof(*event)) {
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	event = (struct mt7925_lq_event *)skb->data;
+
+	if (le16_to_cpu(event->tag) != UNI_CMD_ID_STATISTICS_LINK_QUALITY) {
+		ret = -EPROTO;
+		goto out;
+	}
+
+	lq = &event->lq[band_idx];
+	if (!lq->is_ready) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (rssi)
+		*rssi = lq->rssi;
+
+	/* firmware reports TX rate in 500 Kb/s units -> kbit/s */
+	if (tx_link_speed_kbps)
+		*tx_link_speed_kbps = le16_to_cpu(lq->link_speed) * 500;
+
+	ret = 0;
+
+out:
+	dev_kfree_skb(skb);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/stats.h b/drivers/net/wireless/mediatek/mt76/mt7925/stats.h
new file mode 100644
index 000000000000..2e29b20cf27b
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/stats.h
@@ -0,0 +1,305 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear */
+/* Copyright (C) 2026 MediaTek Inc. */
+
+#ifndef __MT7925_STATS_H
+#define __MT7925_STATS_H
+
+#include <linux/if_ether.h>
+#include <linux/types.h>
+#include "../mt76_connac_mcu.h"
+
+#define MT7925_STA_STATS_AC_NUM 4
+#define MT7925_STA_STATS_BAND_NUM 2
+#define MT7925_STA_STATS_AGG_RANGE_NUM 16
+#define MT7925_STA_STATS_TX_QUALITY_NUM 4
+#define MT7925_TX_MODE_NUM      16
+#define MT7925_TX_RATE_CCK_NUM  5
+#define MT7925_TX_RATE_BW_NUM   6
+
+/* HW rate code (16-bit) field extract, mirror Gen4m CONNAC3X_HW_TX_RATE_TO_*.
+ * The auto-rate table stores one rate code per entry.
+ */
+#define MT7925_HW_RATE_TO_MCS(_x)	(((_x) & GENMASK(5, 0)) >> 0)
+#define MT7925_HW_RATE_TO_MODE(_x)	(((_x) & GENMASK(9, 6)) >> 6)
+#define MT7925_HW_RATE_TO_NSS(_x)	(((_x) & GENMASK(13, 10)) >> 10)
+#define MT7925_HW_RATE_TO_STBC(_x)	(((_x) & BIT(14)) >> 14)
+#define MT7925_HW_RATE_TO_DCM(_x)	(((_x) & BIT(4)) >> 4)
+#define MT7925_HW_RATE_TO_106T(_x)	(((_x) & BIT(5)) >> 5)
+#define MT7925_HW_RATE_UNMASK_DCM(_r)	((u8)(_r) & 0xef)
+#define MT7925_HW_RATE_UNMASK_106T(_r)	((u8)(_r) & 0xdf)
+
+/* Number of entries in the firmware auto-rate table (mirror Gen4m
+ * AUTO_RATE_NUM). RA cycles through these and reports which one is in use
+ * via wtbl->rate_idx.
+ */
+#define MT7925_AUTO_RATE_NUM 8
+
+/* Firmware EVENT_STATISTICS sub-event tags. The WTBL rate request uses cmd tag
+ * UNI_CMD_ID_STATISTICS_WTBL (10) but the firmware replies with event tag 12.
+ */
+#define MT7925_UNI_EVENT_STATISTICS_WTBL 12
+
+/* CONNAC3X TX Vector BBP latch bit fields (mirror cmm_asic_connac3x.h).
+ * These operate on the 3-DWORD tx_vector[band].txv[3] array.
+ */
+#define MT7925_TXV_GET_TX_RATE(_txv)	((_txv)[2] & 0x7f)
+#define MT7925_TXV_GET_TX_LDPC(_txv)	(((_txv)[2] & (0x1 << 7)) >> 7)
+#define MT7925_TXV_GET_TX_STBC(_txv)	(((_txv)[0] & (0x3 << 6)) >> 6)
+#define MT7925_TXV_GET_TX_FRMODE(_txv)	(((_txv)[0] & (0x7 << 8)) >> 8)
+#define MT7925_TXV_GET_TX_MODE(_txv)	(((_txv)[0] & (0xf << 12)) >> 12)
+#define MT7925_TXV_GET_TX_NSTS(_txv)	(((_txv)[2] & (0xfU << 28)) >> 28)
+#define MT7925_TXV_GET_TX_PWR(_txv)	(((_txv)[0] & (0xff << 16)) >> 16)
+#define MT7925_TXV_GET_TX_SGI(_txv)	(((_txv)[1] & (0x3 << 26)) >> 26)
+#define MT7925_TXV_GET_TX_SPE_IDX(_txv)	(((_txv)[0] & (0x1f << 0)) >> 0)
+#define MT7925_TXV_GET_TX_DCM(_txv)	(((_txv)[2] & (0x1 << 4)) >> 4)
+#define MT7925_TXV_GET_TX_106T(_txv)	(((_txv)[2] & (0x1 << 5)) >> 5)
+#define MT7925_TXV_RATE_UNMASK_DCM(_r)	((u8)(_r) & 0xef)
+#define MT7925_TXV_RATE_UNMASK_106T(_r)	((u8)(_r) & 0xdf)
+
+extern const char * const mt7925_tx_mode_str[MT7925_TX_MODE_NUM];
+extern const char * const mt7925_tx_rate_cck_str[MT7925_TX_RATE_CCK_NUM];
+extern const char * const mt7925_tx_rate_bw_str[MT7925_TX_RATE_BW_NUM];
+
+/* TX rate mode, mirror Gen4m TX_RATE_MODE_* (see nic_rate.h). Used to decode
+ * both the TX Vector BBP latch and the firmware auto-rate table rate codes.
+ */
+enum mt7925_tx_rate_mode {
+	MT7925_TX_RATE_MODE_CCK = 0,
+	MT7925_TX_RATE_MODE_OFDM = 1,
+	MT7925_TX_RATE_MODE_HTMIX = 2,
+	MT7925_TX_RATE_MODE_HTGF = 3,
+	MT7925_TX_RATE_MODE_VHT = 4,
+	MT7925_TX_RATE_MODE_PLR = 5,
+	MT7925_TX_RATE_MODE_HE_SU = 8,
+	MT7925_TX_RATE_MODE_HE_ER = 9,
+	MT7925_TX_RATE_MODE_HE_TRIG = 10,
+	MT7925_TX_RATE_MODE_HE_MU = 11,
+	MT7925_TX_RATE_MODE_EHT_ER = 13,
+	MT7925_TX_RATE_MODE_EHT_TRIG = 14,
+	MT7925_TX_RATE_MODE_EHT_MU = 15,
+};
+
+enum stats_query_mib_array_index {
+	QUERY_MIB_CNT_RX_FCS_ERR = 0,
+	QUERY_MIB_CNT_RX_FIFO_OVERFLOW,
+	QUERY_MIB_CNT_RX_MPDU,
+	QUERY_MIB_CNT_AMPDU_RX_COUNT,
+	QUERY_MIB_CNT_PF_DROP,
+	QUERY_MIB_CNT_LEN_MISMATCH,
+	QUERY_MIB_CNT_CHANNEL_IDLE,
+	QUERY_MIB_CNT_CCA_NAV_TX_TIME,
+	QUERY_MIB_CNT_MDRDY,
+	QUERY_MIB_CNT_RX_CCK_MDRDY_TIME,
+	QUERY_MIB_CNT_RX_OFDM_LG_MIXED_MDRDY_TIME,
+	QUERY_MIB_CNT_RX_OFDM_GREEN_MDRDY_TIME,
+	QUERY_MIB_CNT_P_CCA_TIME,
+	QUERY_MIB_CNT_S_CCA_TIME,
+	QUERY_MIB_CNT_P_ED_TIME,
+	QUERY_MIB_CNT_BCN_TX,
+	QUERY_MIB_CNT_TX_BW_40MHZ,
+	QUERY_MIB_CNT_TX_BW_80MHZ,
+	QUERY_MIB_CNT_TX_BW_160MHZ,
+	QUERY_MIB_CNT_BSS0_BA_MISS,
+	QUERY_MIB_CNT_BSS0_RTS_TX_CNT,
+	QUERY_MIB_CNT_BSS0_FRAME_RETRY,
+	QUERY_MIB_CNT_BSS0_FRAME_RETRY_2,
+	QUERY_MIB_CNT_BSS0_RTS_RETRY,
+	QUERY_MIB_CNT_BSS0_ACK_FAIL,
+	QUERY_MIB_CNT_AMPDU,
+	QUERY_MIB_CNT_AMPDU_MPDU,
+	QUERY_MIB_CNT_AMPDU_ACKED,
+	QUERY_MIB_CNT_MAX_NUM,
+};
+
+enum stats_trx_agg_range {
+	STAT_MIB_CNT_TRX_AGG_RANGE0_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE1_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE2_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE3_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE4_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE5_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE6_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE7_IDX,
+	STAT_MIB_CNT_TRX_AGG_RANGE_MAX_NUM
+};
+
+enum {
+	MT7925_BW_20 = 0,
+	MT7925_BW_40,
+	MT7925_BW_80,
+	MT7925_BW_160,
+};
+
+struct mt7925_sta_stats_ac {
+	__le32 tx_fail;
+	__le32 tx_retry;
+} __packed;
+
+struct mt7925_sta_stats_tx_vector {
+	__le32 txv[3];
+} __packed;
+
+struct mt7925_sta_stats_mib {
+	__le32 rx_mpdu_cnt;
+	__le32 fcs_error;
+	__le32 rx_fifo_full;
+	__le32 ampdu_tx_sf_cnt;
+	__le32 ampdu_tx_ack_sf_cnt;
+	__le32 tx_range_ampdu_cnt[MT7925_STA_STATS_AGG_RANGE_NUM];
+} __packed;
+
+/* Firmware EVENT_STA_STATISTICS body. */
+struct mt7925_sta_stats {
+	u8 version;
+	u8 rsv[3];
+	__le32 flags;
+
+	u8 sta_idx;
+	u8 bss_idx;
+	u8 wtbl_idx;
+	u8 rsv1;
+
+	u8 mac_addr[ETH_ALEN];
+	u8 per;
+	u8 rcpi;
+
+	__le32 phy_mode;
+	__le16 link_speed; /* 0.5 Mbit/s units */
+	u8 link_quality;
+	u8 link_reserved;
+
+	__le32 tx_count;
+	__le32 tx_fail_count;
+	__le32 tx_life_timeout_count;
+	__le32 tx_done_air_time;
+	__le32 transmit_count;
+	__le32 transmit_fail_count;
+
+	struct mt7925_sta_stats_ac ac[MT7925_STA_STATS_AC_NUM];
+
+	u8 temperature;
+	u8 skip_ar;
+	u8 ar_table_idx;
+	u8 rate_entry_idx;
+	u8 rate_entry_idx_prev;
+	u8 tx_sgi_detect_pass_cnt;
+	u8 ave_per;
+	u8 rsv2;
+
+	__le32 agg_range_ctrl[2];
+	u8 range_mode;
+	u8 rsv3[3];
+	__le32 agg_range_ctrl_ext[6];
+
+	u8 ar_state_curr;
+	u8 ar_state_prev;
+	u8 ar_action_type;
+	u8 highest_rate_cnt;
+	u8 lowest_rate_cnt;
+	u8 rsv4;
+	__le16 train_up;
+	__le16 train_down;
+	u8 rsv5[2];
+	__le32 rate1_tx_cnt;
+	__le32 rate1_fail_cnt;
+
+	struct mt7925_sta_stats_tx_vector tx_vector[MT7925_STA_STATS_BAND_NUM];
+	struct mt7925_sta_stats_mib mib[MT7925_STA_STATS_BAND_NUM];
+
+	u8 is_force_tx_stream;
+	u8 is_force_se_off;
+	__le16 ra_running_cnt;
+	u8 ra_status;
+	u8 max_ampdu_factor;
+	u8 tx_quality[MT7925_STA_STATS_TX_QUALITY_NUM];
+	u8 tx_rate_up_penalty;
+	u8 low_traffic_mode;
+	u8 low_traffic_count;
+	u8 low_traffic_dashboard;
+	u8 dynamic_sgi_state;
+	u8 dynamic_sgi_score;
+	u8 dynamic_bw_state;
+	u8 dynamic_gband_256qam_state;
+	u8 vht_non_sp_rate_state;
+	u8 rsv6[3];
+	u8 rsv7[2];
+} __packed;
+
+struct mt7925_sta_rec_lookup {
+	int sta_rec_idx;
+};
+
+/* Firmware auto-rate table snapshot, mirror Gen4m struct UNI_EVENT_STAT_WTBL.
+ *
+ * The firmware RA maintains up to MT7925_AUTO_RATE_NUM candidate rates in
+ * rate_code[]. rate_idx tells which entry is currently in use, so a dump can
+ * point at it with "-->". fcap is the bandwidth capability and the ldpc/sgi
+ * flags describe the per-mode coding/guard-interval used for those rates.
+ */
+struct mt7925_wtbl_rate {
+	__le16 tag;
+	__le16 len;
+	u8 rx_rcpi0;
+	u8 rx_rcpi1;
+	u8 cbrn;
+	u8 fcap;
+	u8 spe_idx;
+	u8 g2;			/* SGI enabled, non-HE, BW20 */
+	u8 g4;			/* SGI enabled, non-HE, BW40 */
+	u8 g8;			/* SGI enabled, non-HE, BW80 */
+	u8 g16;			/* SGI enabled, non-HE, BW160 */
+	u8 g2_he;		/* GI, HE, BW20 */
+	u8 g4_he;		/* GI, HE, BW40 */
+	u8 g8_he;		/* GI, HE, BW80 */
+	u8 g16_he;		/* GI, HE, BW160 */
+	u8 gi_eht;		/* GI, EHT */
+	u8 ht_ldpc;
+	u8 vht_ldpc;
+	u8 he_ldpc;
+	u8 eht_ldpc;
+	u8 af;
+	u8 rate_idx;		/* index into rate_code[] currently in use */
+	__le16 rate_code[MT7925_AUTO_RATE_NUM];
+	__le32 rsv[4];
+} __packed;
+
+int
+mt7925_get_ap_sta_rec_idx(struct mt792x_dev *dev, u8 *sta_rec_idx);
+
+void
+mt7925_print_last_tx_rate(struct seq_file *s, const __le32 le_txv[3]);
+
+u8
+mt7925_wtbl_get_sgi(const struct mt7925_wtbl_rate *wr, u8 txmode, u8 fcap);
+
+u8
+mt7925_wtbl_get_ldpc(const struct mt7925_wtbl_rate *wr, u8 txmode);
+
+char *mt7925_hw_rate_ofdm_str(u8 ofdm_idx);
+
+int mt792x_mcu_get_wtbl_rate(struct mt792x_dev *dev, u16 wlan_idx,
+			     struct mt7925_wtbl_rate *rate);
+
+int mt792x_mcu_get_stat(struct mt792x_dev *dev,
+			struct mt7925_sta_stats *stats);
+
+int mt7925_mcu_get_mib_info(struct mt792x_dev *dev, u8 band_idx,
+			    const u32 *counters, u8 counter_num,
+			    u64 *values);
+
+/* GET_STAT_INFO (UNI_CMD_ID_GET_STATISTICS = 0x23),
+ * sub-command UNI_CMD_GET_STATISTICS_TAG_LINK_QUALITY = 1.
+ *
+ * @band_idx:            band/BSS index (0..3)
+ * @rssi:                out, moving-average beacon RSSI (dBm), may be NULL
+ * @tx_link_speed_kbps:  out, TX link speed in kbit/s, may be NULL
+ *
+ * Returns 0 on success, -ENOENT if the band's link quality is not ready.
+ *
+ * NOTE: firmware provides only RSSI and TX rate here. RX rate/bandwidth are
+ * not in this event; read wcid->rate for the RX rate.
+ */
+int mt7925_mcu_get_link_quality(struct mt792x_dev *dev, u8 band_idx,
+				s8 *rssi, u32 *tx_link_speed_kbps);
+
+#endif
-- 
2.45.2

