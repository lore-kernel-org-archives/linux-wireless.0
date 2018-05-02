Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbeEBMtN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 08:49:13 -0400
Date: Wed, 2 May 2018 15:49:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: akarwar@marvell.com
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: [bug report] mwifiex: do le_to_cpu conversion for Rx packet header
 elements
Message-ID: <20180502124903.GA24880@mwanda> (sfid-20180502_145142_017652_0861200F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Amitkumar Karwar,

The patch ed1ea6f42ece: "mwifiex: do le_to_cpu conversion for Rx
packet header elements" from Aug 3, 2012, leads to the following
static checker warning:

	drivers/net/wireless/marvell/mwifiex/sta_rx.c:251 mwifiex_process_sta_rx_packet()
	error: buffer overflow 'priv->rx_seq' 8 <= 255 user_rl='0-255'

drivers/net/wireless/marvell/mwifiex/sta_rx.c
   187  int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
   188                                    struct sk_buff *skb)
   189  {
   190          struct mwifiex_adapter *adapter = priv->adapter;
   191          int ret = 0;
   192          struct rxpd *local_rx_pd;
   193          struct rx_packet_hdr *rx_pkt_hdr;
   194          u8 ta[ETH_ALEN];
   195          u16 rx_pkt_type, rx_pkt_offset, rx_pkt_length, seq_num;
   196          struct mwifiex_sta_node *sta_ptr;
   197  
   198          local_rx_pd = (struct rxpd *) (skb->data);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Smatch distructs skb->data like the plague.

   199          rx_pkt_type = le16_to_cpu(local_rx_pd->rx_pkt_type);
   200          rx_pkt_offset = le16_to_cpu(local_rx_pd->rx_pkt_offset);
   201          rx_pkt_length = le16_to_cpu(local_rx_pd->rx_pkt_length);
   202          seq_num = le16_to_cpu(local_rx_pd->seq_num);
   203  
   204          rx_pkt_hdr = (void *)local_rx_pd + rx_pkt_offset;
   205  
   206          if ((rx_pkt_offset + rx_pkt_length) > (u16) skb->len) {
   207                  mwifiex_dbg(adapter, ERROR,
   208                              "wrong rx packet: len=%d, rx_pkt_offset=%d, rx_pkt_length=%d\n",
   209                              skb->len, rx_pkt_offset, rx_pkt_length);
   210                  priv->stats.rx_dropped++;
   211                  dev_kfree_skb_any(skb);
   212                  return ret;
   213          }
   214  
   215          if (rx_pkt_type == PKT_TYPE_MGMT) {
   216                  ret = mwifiex_process_mgmt_packet(priv, skb);
   217                  if (ret)
   218                          mwifiex_dbg(adapter, DATA, "Rx of mgmt packet failed");
   219                  dev_kfree_skb_any(skb);
   220                  return ret;
   221          }
   222  
   223          /*
   224           * If the packet is not an unicast packet then send the packet
   225           * directly to os. Don't pass thru rx reordering
   226           */
   227          if ((!IS_11N_ENABLED(priv) &&
   228               !(ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
   229                 !(local_rx_pd->flags & MWIFIEX_RXPD_FLAGS_TDLS_PACKET))) ||
   230              !ether_addr_equal_unaligned(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest)) {
   231                  mwifiex_process_rx_packet(priv, skb);
   232                  return ret;
   233          }
   234  
   235          if (mwifiex_queuing_ra_based(priv) ||
   236              (ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info) &&
   237               local_rx_pd->flags & MWIFIEX_RXPD_FLAGS_TDLS_PACKET)) {
   238                  memcpy(ta, rx_pkt_hdr->eth803_hdr.h_source, ETH_ALEN);
   239                  if (local_rx_pd->flags & MWIFIEX_RXPD_FLAGS_TDLS_PACKET &&
   240                      local_rx_pd->priority < MAX_NUM_TID) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We check ->priority here.

   241                          sta_ptr = mwifiex_get_sta_entry(priv, ta);
   242                          if (sta_ptr)
   243                                  sta_ptr->rx_seq[local_rx_pd->priority] =
   244                                                le16_to_cpu(local_rx_pd->seq_num);
   245                          mwifiex_auto_tdls_update_peer_signal(priv, ta,
   246                                                               local_rx_pd->snr,
   247                                                               local_rx_pd->nf);
   248                  }
   249          } else {
   250                  if (rx_pkt_type != PKT_TYPE_BAR)
   251                          priv->rx_seq[local_rx_pd->priority] = seq_num;
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
But not on this path.

   252                  memcpy(ta, priv->curr_bss_params.bss_descriptor.mac_address,
   253                         ETH_ALEN);
   254          }
   255  
   256          /* Reorder and send to OS */
   257          ret = mwifiex_11n_rx_reorder_pkt(priv, seq_num, local_rx_pd->priority,
   258                                           ta, (u8) rx_pkt_type, skb);
   259  

regards,
dan carpenter
