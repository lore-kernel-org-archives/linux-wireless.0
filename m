Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49398 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeFDLKq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 07:10:46 -0400
Date: Mon, 4 Jun 2018 14:10:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: huxm@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] mwifiex: process rxba_sync event
Message-ID: <20180604111033.5sqt6wtfkennxv3v@kili.mountain> (sfid-20180604_131050_520469_1410B854)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Xinming Hu,

The patch 99ffe72cdae4: "mwifiex: process rxba_sync event" from Jul
25, 2016, leads to the following static checker warning:

	drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:941 mwifiex_11n_rxba_sync_event()
	warn: 'tlv_buf_left' can be negative (type promoted to high)

drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
   927  void mwifiex_11n_rxba_sync_event(struct mwifiex_private *priv,
   928                                   u8 *event_buf, u16 len)
   929  {
   930          struct mwifiex_ie_types_rxba_sync *tlv_rxba = (void *)event_buf;
   931          u16 tlv_type, tlv_len;
   932          struct mwifiex_rx_reorder_tbl *rx_reor_tbl_ptr;
   933          u8 i, j;
   934          u16 seq_num, tlv_seq_num, tlv_bitmap_len;
   935          int tlv_buf_left = len;
   936          int ret;
   937          u8 *tmp;
   938  
   939          mwifiex_dbg_dump(priv->adapter, EVT_D, "RXBA_SYNC event:",
   940                           event_buf, len);
   941          while (tlv_buf_left >= sizeof(*tlv_rxba)) {
   942                  tlv_type = le16_to_cpu(tlv_rxba->header.type);
   943                  tlv_len  = le16_to_cpu(tlv_rxba->header.len);
   944                  if (tlv_type != TLV_TYPE_RXBA_SYNC) {
   945                          mwifiex_dbg(priv->adapter, ERROR,
   946                                      "Wrong TLV id=0x%x\n", tlv_type);
   947                          return;
   948                  }
   949  
   950                  tlv_seq_num = le16_to_cpu(tlv_rxba->seq_num);
   951                  tlv_bitmap_len = le16_to_cpu(tlv_rxba->bitmap_len);
   952                  mwifiex_dbg(priv->adapter, INFO,
   953                              "%pM tid=%d seq_num=%d bitmap_len=%d\n",
   954                              tlv_rxba->mac, tlv_rxba->tid, tlv_seq_num,
   955                              tlv_bitmap_len);
   956  
   957                  rx_reor_tbl_ptr =
   958                          mwifiex_11n_get_rx_reorder_tbl(priv, tlv_rxba->tid,
   959                                                         tlv_rxba->mac);
   960                  if (!rx_reor_tbl_ptr) {
   961                          mwifiex_dbg(priv->adapter, ERROR,
   962                                      "Can not find rx_reorder_tbl!");
   963                          return;
   964                  }
   965  
   966                  for (i = 0; i < tlv_bitmap_len; i++) {
   967                          for (j = 0 ; j < 8; j++) {
   968                                  if (tlv_rxba->bitmap[i] & (1 << j)) {
   969                                          seq_num = (MAX_TID_VALUE - 1) &
   970                                                  (tlv_seq_num + i * 8 + j);
   971  
   972                                          mwifiex_dbg(priv->adapter, ERROR,
   973                                                      "drop packet,seq=%d\n",
   974                                                      seq_num);
   975  
   976                                          ret = mwifiex_11n_rx_reorder_pkt
   977                                          (priv, seq_num, tlv_rxba->tid,
   978                                           tlv_rxba->mac, 0, NULL);
   979  
   980                                          if (ret)
   981                                                  mwifiex_dbg(priv->adapter,
   982                                                              ERROR,
   983                                                              "Fail to drop packet");
   984                                  }
   985                          }
   986                  }
   987  
   988                  tlv_buf_left -= (sizeof(*tlv_rxba) + tlv_len);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This could theoretically underflow to negative.  We should probably
check "sizeof(*tlv_rxba) + tlv_len" at the start of the loop and
tlv_bitmap_len as well to avoid a theoretical read beyond the end of
the array.

   989                  tmp = (u8 *)tlv_rxba + tlv_len + sizeof(*tlv_rxba);
   990                  tlv_rxba = (struct mwifiex_ie_types_rxba_sync *)tmp;
   991          }
   992  }

regards,
dan carpenter
