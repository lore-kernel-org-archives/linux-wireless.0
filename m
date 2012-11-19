Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2023 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab2KSSmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:42:21 -0500
Message-ID: <50AA7D7C.8020208@broadcom.com> (sfid-20121119_194229_472627_A6A49AD6)
Date: Mon, 19 Nov 2012 19:42:04 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 05/22] brcmsmac: Use IEEE 802.11 AC levels for
 pktq precedence levels
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-6-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-6-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:07 PM, Seth Forshee wrote:
> The mac80211 tx queues and brcmsmac DMA fifos both map directly to AC
> levels. Therefore it's much more straightforward to queue tx frames and
> choose the tx fifo based on the mac80211 queue instead of mapping 802.1D
> priority tags to precedence levels then back to AC levels. mac80211
> already maps the 802.1D levels to the appropriate AC levels and queues
> management frames at the maximum priority, so the results should be
> identical.
>
> One functional change resulting from this patch is that AMPDU retries no
> longer get a priority boost to queue them ahead of packets with the same

True. I believe the statement actually applies to any retry include 
non-AMPDU.

> priority already in the tx queue. This behavior will be restored (in
> effect at least) in a later patch when the tx queue is removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |   13 +----
>   drivers/net/wireless/brcm80211/brcmsmac/main.c  |   67 ++++++++---------------
>   drivers/net/wireless/brcm80211/brcmsmac/main.h  |    6 +-
>   drivers/net/wireless/brcm80211/brcmsmac/pub.h   |   26 +--------
>   4 files changed, 26 insertions(+), 86 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 135af9a..8abf39d 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -365,6 +342,21 @@ static const char fifo_names[6][0];
>   static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
>   #endif
>
> +/* Mapping of ieee80211 AC numbers to tx fifos */
> +static const u8 ac_to_fifo_mapping[IEEE80211_NUM_ACS] = {
> +	[IEEE80211_AC_VO]	= TX_AC_VO_FIFO,
> +	[IEEE80211_AC_VI]	= TX_AC_VI_FIFO,
> +	[IEEE80211_AC_BE]	= TX_AC_BE_FIFO,
> +	[IEEE80211_AC_BK]	= TX_AC_BK_FIFO,

Minor comment: Can you get rid of the tab before the equal sign and use 
space instead?

> @@ -6068,14 +6054,13 @@ static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
>   }
>
>   void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
> -		     struct sk_buff *sdu, uint prec)
> +		     struct sk_buff *sdu)
>   {
>   	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
>   	struct pktq *q = &qi->q;
> -	int prio;
> -
> -	prio = sdu->priority;
> +	uint prec;

the term prec, short for precedence, may be confusing as the concept is 
removed.

> +	prec = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
>   	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
>   		/*
>   		 * we might hit this condtion in case


