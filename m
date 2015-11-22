Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:37392 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736AbbKVTPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 14:15:12 -0500
Date: Sun, 22 Nov 2015 21:15:08 +0200
From: Jouni Malinen <j@w1.fi>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: hostap@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] offchannel: Cancel the pending_action TX wait, before
 starting new one.
Message-ID: <20151122191508.GB31884@w1.fi> (sfid-20151122_201545_723255_24843428)
References: <1446477028-23118-1-git-send-email-chaitanya.mgit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446477028-23118-1-git-send-email-chaitanya.mgit@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2015 at 08:40:28PM +0530, Chaitanya T K wrote:
> From: tkc <chaitanya.mgit@gmail.com>
> 
> Before the tx_status is received for the action frame, if we
> get another request, we respond to that by freeing the memory
> for pending_action_tx, but we don't cancel the TX wait, so
> in the kernel the ROC will not be cancelled.
> 
> Due to above issue, wpa_supplicant assumes that all pending
> RoC's are cancelled and proceeds with interface creation and
> connection, where as state in mac80211/driver will be roc_in_progress.
> 
> This is leading to issues at driver level.
> 
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> ---
> V2: Fix 2 from's.
>     Remove the unnecessary braces.

I'm not sure I'd call that "From:" in the message body fixed (i.e., it
should have been the second one, not the first one; alternatively, it
would be fine to remove that From: line from the message body since the
one in the message header has a value matching that SOB).

> diff --git a/wpa_supplicant/offchannel.c b/wpa_supplicant/offchannel.c
> @@ -253,15 +253,9 @@ int offchannel_send_action(struct wpa_supplicant *wpa_s, unsigned int freq,
>  
>  	wpa_s->pending_action_tx_status_cb = tx_cb;
>  
> -	if (wpa_s->pending_action_tx) {
> -		wpa_printf(MSG_DEBUG, "Off-channel: Dropped pending Action "
> -			   "frame TX to " MACSTR " (pending_action_tx=%p)",
> -			   MAC2STR(wpa_s->pending_action_dst),
> -			   wpa_s->pending_action_tx);
> -		wpa_hexdump_buf(MSG_MSGDUMP, "Pending TX frame",
> -				wpa_s->pending_action_tx);
> -		wpabuf_free(wpa_s->pending_action_tx);
> -	}
> +	if (wpa_s->pending_action_tx)
> +		offchannel_send_action_done(wpa_s);

As noted in your reply to this, those debug prints should not be
removed.

As far as the change to offchannel_send_action_done() is concerned, I'm
not sure it is the correct thing to do in all cases. Why would we cancel
Action frame TX wait or remain-on-channel if the new frame is for the
same channel?

-- 
Jouni Malinen                                            PGP id EFC895FA
