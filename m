Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38697 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbcCIFqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 00:46:07 -0500
Received: by mail-wm0-f49.google.com with SMTP id l68so55746441wml.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 21:46:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457457934-8563-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1457457934-8563-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Wed, 9 Mar 2016 06:46:05 +0100
Message-ID: <CA+BoTQmxg7vK6KBENrx+P3vK_nYV4-h_yiavEBQi1oFTAANR=w@mail.gmail.com> (sfid-20160309_064612_197491_1750E2F8)
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
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2326,7 +2326,12 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
>                         break;
>                 }
>
> -               ath10k_txrx_tx_unref(htt, &tx_done);
> +               status = ath10k_txrx_tx_unref(htt, &tx_done);
> +               if (!status) {
> +                       spin_lock_bh(&htt->tx_lock);
> +                       ath10k_htt_tx_mgmt_dec_pending(htt);
> +                       spin_unlock_bh(&htt->tx_lock);
> +               }
[...]
> @@ -3978,14 +3976,13 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
>         txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
>         is_htt = (txpath == ATH10K_MAC_TX_HTT ||
>                   txpath == ATH10K_MAC_TX_HTT_MGMT);
> +       is_mgmt = (txpath == ATH10K_MAC_TX_HTT_MGMT);

Are you sure you want to be counting nullfuncs here in as well (and
possibly other frames that end up, for whatever reason, on htt-mgmt
tx-path?)


Michał
