Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33053 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbcDKHwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 03:52:36 -0400
Received: by mail-wm0-f51.google.com with SMTP id f198so133844449wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 00:52:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160411074438.GA15227@mwanda>
References: <20160411074438.GA15227@mwanda>
Date: Mon, 11 Apr 2016 09:52:34 +0200
Message-ID: <CA+BoTQmpYtGoYk4M-NaFduO8iX0KYgoLz6Mj_40i0um8MqDdww@mail.gmail.com> (sfid-20160411_095240_086059_CFD1B0BD)
Subject: Re: [patch] ath10k: add some sanity checks
From: Michal Kazior <michal.kazior@tieto.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2016 at 09:44, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Smatch complains that since "ev->peer_id" comes from skb->data that
> means we can't trust it and have to do a bounds check on it to prevent
> an array overflow.
>
> Fixes: 6942726f7f7b ('ath10k: add fast peer_map lookup')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
> index 9369411..fd6ba69 100644
> --- a/drivers/net/wireless/ath/ath10k/txrx.c
> +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> @@ -190,6 +190,9 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
>         struct ath10k *ar = htt->ar;
>         struct ath10k_peer *peer;
>
> +       if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS)
> +               return;
> +

This will lead to a timeout in the other part of the code so printing
a warning here will make it easier to understand the failure, e.g.

  ath10k_warn(ar, "received htt peer map event with idx out of bounds:
%hu\n", ev->peer_id);


>         spin_lock_bh(&ar->data_lock);
>         peer = ath10k_peer_find(ar, ev->vdev_id, ev->addr);
>         if (!peer) {
> @@ -218,6 +221,9 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
>         struct ath10k *ar = htt->ar;
>         struct ath10k_peer *peer;
>
> +       if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS)
> +               return;

Ditto but s/map/unmap.

Anyway, good catch, thanks!


Michał
