Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118AbbFQOat (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 10:30:49 -0400
Message-ID: <1434551447.3952.6.camel@redhat.com> (sfid-20150617_163057_029841_ED848241)
Subject: Re: [PATCH v2] Add new mac80211 driver mwlwifi.
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lin <dlin@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Date: Wed, 17 Jun 2015 09:30:47 -0500
In-Reply-To: <1434526059.1884.7.camel@sipsolutions.net>
References: <2127ea28a2a74cd6a89d45b88caf06cb@SC-EXCH02.marvell.com>
	 <1434526059.1884.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-17 at 09:27 +0200, Johannes Berg wrote:
> On Wed, 2015-06-17 at 06:06 +0000, David Lin wrote:
> 
> (not really reading all of this right now, just two small comments)
> 
> > +struct mwl_tx_desc {
> > +	u8 data_rate;
> > +	u8 tx_priority;
> > +	__le16 qos_ctrl;
> > +	__le32 pkt_ptr;
> > +	__le16 pkt_len;
> > +	u8 dest_addr[ETH_ALEN];
> > +	__le32 pphys_next;
> > +	__le32 sap_pkt_info;
> > +	__le32 rate_info;
> > +	u8 type;
> > +	u8 xmit_control;     /* bit 0: use rateinfo, bit 1: disable ampdu */
> > +	__le16 reserved;
> > +	__le32 tcpack_sn;
> > +	__le32 tcpack_src_dst;
> > +	struct sk_buff *psk_buff;
> > +	struct mwl_tx_desc *pnext;
> > +	u8 reserved1[2];
> > +	u8 packet_info;
> > +	u8 packet_id;
> > +	__le16 packet_len_and_retry;
> > +	__le16 packet_rate_info;
> > +	u8 *sta_info;
> > +	__le32 status;
> > +} __packed;
> 
> This ... cannot be right. You can't have a pointer in a structure that's
> used by firmware, and the __leXX and __packed indicates that it's used
> by firmware. But pointer size is variable, so *clearly* this cannot be
> correct.

I can't see anywhere that mwl_tx_desc->sta_info actually gets read by
the driver; it only appears to be written by mwl_tx_skb().  So (even if
it was intended to be) it's clearly not a stashed pointer for later.

Like you say it's size also needs to be specified, since won't it be 64
bits or 32 depending on the architecture?  I can't imagine the firmware
would like that much.

At the very least, this member and its usage in mwl_tx_skb() deserves a
code comment about what's going on and why a host pointer is getting
stuffed into a field that the firmware is reading...

Dan

> > +struct mwl_rx_desc {
> > +	__le16 pkt_len;              /* total length of received data      */
> > +	__le16 rate;                 /* receive rate information           */
> > +	__le32 pphys_buff_data;      /* physical address of payload data   */
> > +	__le32 pphys_next;           /* physical address of next RX desc   */
> > +	__le16 qos_ctrl;             /* received QosCtrl field variable    */
> > +	__le16 ht_sig2;              /* like name states                   */
> > +	__le32 hw_rssi_info;
> > +	__le32 hw_noise_floor_info;
> > +	u8 noise_floor;
> > +	u8 reserved[3];
> > +	u8 rssi;                     /* received signal strengt indication */
> > +	u8 status;                   /* status field containing USED bit   */
> > +	u8 channel;                  /* channel this pkt was received on   */
> > +	u8 rx_control;               /* the control element of the desc    */
> > +	/* above are 32bits aligned and is same as FW, RxControl put at end
> > +	 * for sync
> > +	 */
> > +	struct sk_buff *psk_buff;    /* associated sk_buff for Linux       */
> > +	void *pbuff_data;            /* virtual address of payload data    */
> > +	struct mwl_rx_desc *pnext;   /* virtual address of next RX desc    */
> > +} __packed;
> 
> Same here. If you really need to have a firmware and driver struct as
> indicated by the comment, you should probably have
> 
> struct mwl_rx_info {
> 	/* firmware info */
> } __packed;
> 
> struct mwl_rx_desc {
> 	struct mwl_rx_info info;
> 	/* driver info */
> };
> 
> (note the lack of __packed also, __packed often makes accesses far less
> efficient)
> 
> > +struct mwl_desc_data {
> > +	dma_addr_t pphys_tx_ring;          /* ptr to first TX desc (phys.)    */
> > +	struct mwl_tx_desc *ptx_ring;      /* ptr to first TX desc (virt.)    */
> > +	struct mwl_tx_desc *pnext_tx_desc; /* next TX desc that can be used   */
> > +	struct mwl_tx_desc *pstale_tx_desc;/* the staled TX descriptor        */
> > +	dma_addr_t pphys_rx_ring;          /* ptr to first RX desc (phys.)    */
> > +	struct mwl_rx_desc *prx_ring;      /* ptr to first RX desc (virt.)    */
> > +	struct mwl_rx_desc *pnext_rx_desc; /* next RX desc that can be used   */
> > +	unsigned int wcb_base;             /* FW base offset for registers    */
> > +	unsigned int rx_desc_write;        /* FW descriptor write position    */
> > +	unsigned int rx_desc_read;         /* FW descriptor read position     */
> > +	unsigned int rx_buf_size;          /* length of the RX buffers        */
> > +} __packed;
> 
> ditto - don't pack driver structs
> 
> Also, you probably really should have two header files - one for the
> firmware structs and one for the driver structs - especially since you
> seem to be confusing the two!
> 
> > +++ b/drivers/net/wireless/mwlwifi/fwcmd.c
> 
> There are a lot of struct definitions here that you could move to the
> same header file.
> 
> > +#if SYSADPT_NUM_OF_DESC_DATA > 3
> 
> how does that get set?
> 
> > +/* Description:  This file implements main functions of this module.
> > + */
> 
> You still have a pretty strange comment style.
> 
> > +	hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
> 
> This was really what I was looking for :)
> 
> Note that I changed this entirely in the mac80211-next tree. I don't
> know how Kalle wants to handle this, but given that your driver isn't
> going to make the cut for 4.2 anyway, you should probably rebase it on
> mac80211-next, and then Kalle can pick it up after he merges that back
> from net-next, or perhaps after the merge window closes.
> 
> [snip rest]
> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


