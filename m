Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab2KZOzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 09:55:18 -0500
Date: Mon, 26 Nov 2012 08:55:11 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Subject: Re: [PATCH v3.7] brcmsmac: handle packet drop on enqueuing correctly
Message-ID: <20121126145511.GD4556@thinkpad-t410> (sfid-20121126_155526_319989_2777091C)
References: <1353671082-7775-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1353671082-7775-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 23, 2012 at 12:44:42PM +0100, Arend van Spriel wrote:
> From: Piotr Haber <phaber@broadcom.com>
> 
> In the event that tx packet can not be queued by the driver
> the packet is dropped. Propagate that information to the .tx()
> callback to make sure the freed packet is not accessed after
> that.
> 
> This has happened causing slab corruptions as reported by
> Stanislaw Gruszka.
> 
> Bug #47721: https://bugzilla.kernel.org/show_bug.cgi?id=47721
> 
> Reported-by: Stanislaw Gruszka <stf_xl@wp.pl>
> Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Piotr Haber <phaber@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Fixing a kernel bug so based on the wireless repository. The
> fix for wireless-next will be posted separately as the patches
> differ. So this patch does not need to be merged to the
> wireless-next tree.

Let me know if I can be of help in resolving the conflicts. Fwiw the fix
looks like it ought to be easy to make on top of wireless-next, but I do
have a couple of comments.

> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> index be5bcfb..a6605b1 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> @@ -901,7 +901,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
>  	struct ieee80211_hdr *h;
>  	u16 seq, start_seq = 0, bindex, index, mcl;
>  	u8 mcs = 0;
> -	bool ba_recd = false, ack_recd = false;
> +	bool ba_recd = false, ack_recd = false, last_packet = false;
>  	u8 suc_mpdu = 0, tot_mpdu = 0;
>  	uint supr_status;
>  	bool update_rate = true, retry = true, tx_error = false;
> @@ -1010,6 +1010,8 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
>  
>  		index = TX_SEQ_TO_INDEX(seq);
>  		ack_recd = false;
> +		last_packet = (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
> +			TXC_AMPDU_LAST);
>  		if (ba_recd) {
>  			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
>  			BCMMSG(wiphy,
> @@ -1074,8 +1076,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
>  		tot_mpdu++;
>  
>  		/* break out if last packet of ampdu */
> -		if (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
> -		    TXC_AMPDU_LAST)
> +		if (last_packet)
>  			break;
>  
>  		p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);

These changes are effectively a no-op and don't really seem to have
anything to do with fixing the bug.

> @@ -7288,10 +7290,12 @@ void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
>  	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
>  		MAXPRIO;
>  	fifo = prio2fifo[prio];
> -	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
> -		return;
> -	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
> +	brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0);

Maybe brcms_c_d11hdrs_mac80211() should return void? I've never
understood what its return value was supposed to represent.

Cheers,
Seth

