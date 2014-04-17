Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59304 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbaDQGMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 02:12:07 -0400
Received: by mail-wi0-f173.google.com with SMTP id z2so2427833wiv.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2014 23:12:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397695357-14028-1-git-send-email-greearb@candelatech.com>
References: <1397695357-14028-1-git-send-email-greearb@candelatech.com>
Date: Thu, 17 Apr 2014 08:12:06 +0200
Message-ID: <CA+BoTQ=Q3s6_9tXq02_3S0=q5qv4U4V1F_qHoN1X1pfWV9CKBA@mail.gmail.com> (sfid-20140417_081218_853197_243CEADC)
Subject: Re: [PATCH] ath10k: Hold tx-lock while detaching htt.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 April 2014 02:42,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> And check for null pool in the tx path (which would
> indicate we are detaching).

Shouldn't we just make sure tx is stopped before we try to detach htt?
Stoping mac80211 queues and synchronize_net() should be sufficient I
think.


> @@ -403,6 +412,13 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>                 goto err;
>
>         spin_lock_bh(&htt->tx_lock);
> +
> +       /* Check if we are detached... */
> +       if (! htt->tx_pool) {
> +               spin_unlock_bh(&htt->tx_lock);

Setting `res` would be nice to indicate an error. And there's a space after !.


Michał
