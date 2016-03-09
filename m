Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37355 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbcCIFu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 00:50:27 -0500
Received: by mail-wm0-f47.google.com with SMTP id p65so55850342wmp.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 21:50:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457457934-8563-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1457457934-8563-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Wed, 9 Mar 2016 06:50:25 +0100
Message-ID: <CA+BoTQk89ObhC2U8BiYENN1oF0B1Tnqmy=PtFqSfhrHodYM_KQ@mail.gmail.com> (sfid-20160309_065048_285639_BBC7F843)
Subject: Re: [PATCH v4] ath10k: move mgmt descriptor limit handle under mgmt_tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 March 2016 at 18:25, Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
[...]
> +int ath10k_htt_tx_mgmt_inc_pending(struct ath10k_htt *htt, bool is_mgmt,
> +                                  bool is_presp)
> +{
> +       struct ath10k *ar = htt->ar;
> +
> +       lockdep_assert_held(&htt->tx_lock);
> +
> +       if (!is_mgmt || !ar->hw_params.max_probe_resp_desc_thres)
> +               return 0;
> +
> +       if (is_presp &&
> +           ar->hw_params.max_probe_resp_desc_thres < htt->num_pending_mgmt_tx)
> +               return -EBUSY;
> +
> +       htt->num_pending_mgmt_tx++;
> +
> +       return 0;
> +}
> +
> +void ath10k_htt_tx_mgmt_dec_pending(struct ath10k_htt *htt)
> +{
> +       lockdep_assert_held(&htt->tx_lock);
> +
> +       htt->num_pending_mgmt_tx--;
> +}

Oh, and this looks unbalanced. You increment only when
`ar->hw_params.max_probe_resp_desc_thres` but always decrement.


Michał
