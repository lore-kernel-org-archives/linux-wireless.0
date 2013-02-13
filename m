Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30167 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062Ab3BMU45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 15:56:57 -0500
Date: Wed, 13 Feb 2013 23:56:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: Add ath6kl cleaned up driver
Message-ID: <20130213205646.GA23798@elgon.mountain> (sfid-20130213_215702_099990_D7FB6B0E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle Valo,

The patch bdcd81707973: "Add ath6kl cleaned up driver" from Jul 18, 
2011, leads to the following static checker warning:
"drivers/net/wireless/ath/ath6kl/txrx.c:1327 ath6kl_rx()
	 warn: what are we testing here?"

[ This is from a failed experiment with Smatch that I won't release. ]

  1301  void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
  1302  {
  1303          struct ath6kl *ar = target->dev->ar;
  1304          struct sk_buff *skb = packet->pkt_cntxt;
  1305          struct wmi_rx_meta_v2 *meta;
  1306          struct wmi_data_hdr *dhdr;
  1307          int min_hdr_len;
  1308          u8 meta_type, dot11_hdr = 0;
  1309          u8 pad_before_data_start;
  1310          int status = packet->status;
  1311          enum htc_endpoint_id ept = packet->endpoint;
  1312          bool is_amsdu, prev_ps, ps_state = false;
  1313          bool trig_state = false;
  1314          struct ath6kl_sta *conn = NULL;
  1315          struct sk_buff *skb1 = NULL;
  1316          struct ethhdr *datap = NULL;
  1317          struct ath6kl_vif *vif;
  1318          struct aggr_info_conn *aggr_conn;
  1319          u16 seq_no, offset;
  1320          u8 tid, if_idx;
  1321  
  1322          ath6kl_dbg(ATH6KL_DBG_WLAN_RX,
  1323                     "%s: ar=0x%p eid=%d, skb=0x%p, data=0x%p, len=0x%x status:%d",
  1324                     __func__, ar, ept, skb, packet->buf,
  1325                     packet->act_len, status);
  1326  
  1327          if (status || !(skb->data + HTC_HDR_LENGTH)) {
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^
skb->data is a pointer.  This pointer math is always going to be false.
Should it be testing "packet->act_len < HTC_HDR_LENGTH" or something?

  1328                  dev_kfree_skb(skb);
  1329                  return;
  1330          }
  1331  
  1332          skb_put(skb, packet->act_len + HTC_HDR_LENGTH);

regards,
dan carpenter

