Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36970 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbdESIAM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 04:00:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: check ah->curchan when updating tx power
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1494406494-13719-1-git-send-email-sgruszka@redhat.com>
References: <1494406494-13719-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: <ath9k-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-ID: <9c6ede70b6e64d7e8bff10081c5bf8d0@euamsexm01a.eu.qualcomm.com> (sfid-20170519_100016_709009_366BCBC0)
Date: Fri, 19 May 2017 09:59:58 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> When driver fail to reset card ah->curchan value stay NULL. When
> later driver try to update tx power it oops by using ah->curchan
> (calltrace is shown below).
> 
> This problem were reported at various places and for some it was
> fixed by making ath9k_hw_chip_reset() do not fail. I have this bug
> report on some oldish RHEL kernel with AR9285, however it's hard to
> debug where reset fail when kernel OOPS, so I think this patch
> should be applied. Hopefully ah->curchan is not used unconditionally
> on other places until is initialized on ath9k_config().
> 
> ath: phy0: Chip reset failed
> ath: phy0: Unable to reset hardware; reset status -22 (freq 2412 MHz)
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<f8a35585>] ath9k_hw_set_txpowerlimit+0x25/0x80 [ath9k_hw]
> Oops: 0000 [#1] SMP
> <snip>
> Call Trace:
>  [<f8aac1aa>] ? ath9k_cmn_update_txpow+0x1a/0x30 [ath9k_common]
>  [<f8cf4f4e>] ? ath_complete_reset+0x4e/0x130 [ath9k]
>  [<f8cf54d7>] ? ath9k_start+0x127/0x1e0 [ath9k]
>  [<f8c2e52f>] ? ieee80211_do_open+0x30f/0x910 [mac80211]
>  [<c07bd96d>] ? dev_open+0x8d/0xf0
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to ath-next branch of ath.git, thanks.

b01c9e327249 ath9k: check ah->curchan when updating tx power

-- 
https://patchwork.kernel.org/patch/9719543/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
