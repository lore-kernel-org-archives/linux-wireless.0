Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34695 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbcCHMko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 07:40:44 -0500
Received: by mail-wm0-f47.google.com with SMTP id p65so147951185wmp.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 04:40:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457438096-20071-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1457438096-20071-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 8 Mar 2016 13:40:41 +0100
Message-ID: <CA+BoTQ=Huzf7WoXMXcyj8yrykrJOd5BMc1EnmccqZgt7M1M_uA@mail.gmail.com> (sfid-20160308_134152_906898_1D8443CB)
Subject: Re: [PATCH v3] ath10k: move mgmt descriptor limit handle under mgmt_tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 March 2016 at 12:54, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
[...]
> +int ath10k_htt_tx_mgmt_inc_pending(struct ath10k_htt *htt, bool is_mgmt,
> +                                  bool is_presp)
>  {
>         struct ath10k *ar = htt->ar;
>
>         lockdep_assert_held(&htt->tx_lock);
>
> +       if (!is_mgmt)
> +               return 0;
> +

>         if (htt->num_pending_tx >= htt->max_num_pending_tx)
>                 return -EBUSY;

This busy here will be hit when you use last tx slot because
tx_inc_pending() is called before tx_mgmt_inc_pending().


[...]
>         skb_cb = ATH10K_SKB_CB(msdu);
>         txq = skb_cb->txq;
>         artxq = (void *)txq->drv_priv;
>
> -       if (unlikely(skb_cb->flags & ATH10K_SKB_F_MGMT) &&
> -           ar->hw_params.max_probe_resp_desc_thres)
> -               limit_mgmt_desc = true;
> -

Oh wait.. I didn't pay attention before, but this looks rather ugly.
With this you will actually make the num_pending_mgmt_tx spin
endlessly upwards on firmware with HTT 3.0 (and uses TX_FRM for mgmt
tx and TX_COMPL_IND for completions), no?


Michał
