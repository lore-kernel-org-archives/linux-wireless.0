Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38273 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbcDAGJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 02:09:40 -0400
Received: by mail-wm0-f52.google.com with SMTP id 20so9348159wmh.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2016 23:09:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459457986-29222-3-git-send-email-greearb@candelatech.com>
References: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
	<1459457986-29222-3-git-send-email-greearb@candelatech.com>
Date: Fri, 1 Apr 2016 08:09:39 +0200
Message-ID: <CA+BoTQkL5OM-QLVVe0RHEOoN-Vj4a0+U9EfaUf=2n+PO3mPDyQ@mail.gmail.com> (sfid-20160401_080944_021414_68976BA6)
Subject: Re: [PATCH 3/3] ath10k: Add BUG_ON if we over-write peer-map pointer.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2016 at 22:59,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Not sure this can happen, but seems like a reasonable sanity
> check.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/txrx.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
> index 94c27f6..172b1d6 100644
> --- a/drivers/net/wireless/ath/ath10k/txrx.c
> +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> @@ -309,6 +309,7 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
>         ath10k_warn(ar, /*ATH10K_DBG_HTT,*/ "htt peer map vdev %d peer %pM id %d\n",
>                    ev->vdev_id, ev->addr, ev->peer_id);
>
> +       BUG_ON(ar->peer_map[ev->peer_id] && (ar->peer_map[ev->peer_id] != peer));

Does this really need to be a BUG_ON?


Michał
