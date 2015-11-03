Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:35589 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbbKCQIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 11:08:40 -0500
Received: by ykek133 with SMTP id k133so23444623yke.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2015 08:08:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446477028-23118-1-git-send-email-chaitanya.mgit@gmail.com>
References: <1446477028-23118-1-git-send-email-chaitanya.mgit@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 Nov 2015 21:38:20 +0530
Message-ID: <CABPxzYJDfy7SFk9XhY64UXPt=9gkN0j7G0jh_rj7xsVUbJ2btg@mail.gmail.com> (sfid-20151103_170858_991732_00505D75)
Subject: Re: [PATCHv2] offchannel: Cancel the pending_action TX wait, before
 starting new one.
To: hostap@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Cc: tkc <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 2, 2015 at 8:40 PM, Chaitanya T K <chaitanya.mgit@gmail.com> wrote:
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
> ---
>  wpa_supplicant/offchannel.c |   12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/wpa_supplicant/offchannel.c b/wpa_supplicant/offchannel.c
> index 6b3f83c..581c5f6 100644
> --- a/wpa_supplicant/offchannel.c
> +++ b/wpa_supplicant/offchannel.c
> @@ -253,15 +253,9 @@ int offchannel_send_action(struct wpa_supplicant *wpa_s, unsigned int freq,
>
>         wpa_s->pending_action_tx_status_cb = tx_cb;
>
> -       if (wpa_s->pending_action_tx) {
> -               wpa_printf(MSG_DEBUG, "Off-channel: Dropped pending Action "
> -                          "frame TX to " MACSTR " (pending_action_tx=%p)",
> -                          MAC2STR(wpa_s->pending_action_dst),
> -                          wpa_s->pending_action_tx);

I think we should retain this print to identify if its a proper complete
or dropping pending. Anyways will wait for comments before sending V3.

.
