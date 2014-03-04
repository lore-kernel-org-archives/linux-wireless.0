Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41216 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbaCDOGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 09:06:00 -0500
Received: by mail-bk0-f49.google.com with SMTP id my13so223138bkb.22
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 06:05:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393937548-7482-14-git-send-email-janusz.dziedzic@tieto.com>
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
	<1393937548-7482-14-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 4 Mar 2014 15:05:58 +0100
Message-ID: <CA+BoTQ=+LajufXev1x6ZVDxzdc0v0Kf98gow-_ZzHoditwOtFA@mail.gmail.com> (sfid-20140304_150606_467838_124DE691)
Subject: Re: [RFC 13/14] ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
From: Michal Kazior <michal.kazior@tieto.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 March 2014 13:52, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c |   22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 555aecf..e300a74 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -310,7 +310,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
>
>         if (htt->rx_confused) {
>                 ath10k_warn("htt is confused. refusing rx\n");
> -               return 0;
> +               return -1;
>         }

Add a comment before function definition, please:

/* return: <0 fatal error, >=0 success, >0 number of chained msdus */

(this includes return-value logic Ben's unchaining patch added..)


>
>         msdu = *head_msdu = ath10k_htt_rx_netbuf_pop(htt);
> @@ -442,6 +442,9 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
>         }
>         *tail_msdu = msdu;
>
> +       if (*head_msdu == NULL)
> +               msdu_chaining = -1;
> +
>         /*
>          * Don't refill the ring yet.
>          *
> @@ -1089,11 +1092,6 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
>                                         enum htt_rx_mpdu_status status,
>                                         bool channel_set)
>  {
> -       if (!head) {
> -               ath10k_warn("htt rx no data!\n");
> -               return false;
> -       }
> -
>         if (head->len == 0) {
>                 ath10k_dbg(ATH10K_DBG_HTT,
>                            "htt rx dropping due to zero-len\n");
> @@ -1209,8 +1207,14 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>                                                          &msdu_head,
>                                                          &msdu_tail);
>
> +                       if (msdu_chaining == -1) {

if (msdu_chaining < 0)

I think having `ret` makes more sense here now.


> +                               ath10k_warn("htt rx no data!\n");

"failed to pop amsdu from htt rx ring: %d", ret


> +                               ath10k_htt_rx_free_msdu_chain(msdu_head);
> +                               continue;
> +                       }
> +
>                         if (!ath10k_htt_rx_amsdu_allowed(htt, msdu_head,
> -                                                        !!msdu_chaining,
> +                                                        msdu_chaining > 0,
>                                                          status,
>                                                          channel_set)) {
>                                 ath10k_htt_rx_free_msdu_chain(msdu_head);
> @@ -1280,12 +1284,12 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
>
>         ath10k_dbg(ATH10K_DBG_HTT_DUMP, "htt rx frag ahead\n");
>
> -       if (!msdu_head) {
> +       if (msdu_chaining == -1) {

ret < 0


>                 ath10k_warn("htt rx frag no data\n");

"failed to .. : %d", ret


>                 return;
>         }
>
> -       if (msdu_chaining || msdu_head != msdu_tail) {
> +       if (msdu_chaining > 0 || msdu_head != msdu_tail) {
>                 ath10k_warn("aggregation with fragmentation?!\n");
>                 ath10k_htt_rx_free_msdu_chain(msdu_head);
>                 return;

Actually the 2 checks above can be squashed:

if (ret) {
  ath10k_warn("failed to pop amsdu from htt rx for fragmented rx: %d", ret)



Michał
