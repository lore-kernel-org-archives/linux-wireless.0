Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:64499 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFKyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 05:54:24 -0500
Received: by mail-la0-f42.google.com with SMTP id gq15so2389108lab.29
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 02:54:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415271133-6588-1-git-send-email-ronald.wahl@raritan.com>
References: <1415271133-6588-1-git-send-email-ronald.wahl@raritan.com>
Date: Thu, 6 Nov 2014 11:54:23 +0100
Message-ID: <CAKv+Gu-NHnMsT4NDQvqbjwiV1gJ5Qe1gd3evsFCA8j0yKc9DZw@mail.gmail.com> (sfid-20141106_115428_437652_A8A23A3A)
Subject: Re: [PATCH v2] mac80211: Fix regression that triggers a kernel BUG
 with CCMP
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 November 2014 11:52, Ronald Wahl <ronald.wahl@raritan.com> wrote:
> Commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (mac80211: port CCMP to
> cryptoapi's CCM driver) introduced a regression when decrypting empty
> packets (data_len == 0). This will lead to backtraces like:
>
> (scatterwalk_start) from [<c01312f4>] (scatterwalk_map_and_copy+0x2c/0xa8)
> (scatterwalk_map_and_copy) from [<c013a5a0>] (crypto_ccm_decrypt+0x7c/0x25c)
> (crypto_ccm_decrypt) from [<c032886c>] (ieee80211_aes_ccm_decrypt+0x160/0x170)
> (ieee80211_aes_ccm_decrypt) from [<c031c628>] (ieee80211_crypto_ccmp_decrypt+0x1ac/0x238)
> (ieee80211_crypto_ccmp_decrypt) from [<c032ef28>] (ieee80211_rx_handlers+0x870/0x1d24)
> (ieee80211_rx_handlers) from [<c0330c7c>] (ieee80211_prepare_and_rx_handle+0x8a0/0x91c)
> (ieee80211_prepare_and_rx_handle) from [<c0331260>] (ieee80211_rx+0x568/0x730)
> (ieee80211_rx) from [<c01d3054>] (__carl9170_rx+0x94c/0xa20)
> (__carl9170_rx) from [<c01d3324>] (carl9170_rx_stream+0x1fc/0x320)
> (carl9170_rx_stream) from [<c01cbccc>] (carl9170_usb_tasklet+0x80/0xc8)
> (carl9170_usb_tasklet) from [<c00199dc>] (tasklet_hi_action+0x88/0xcc)
> (tasklet_hi_action) from [<c00193c8>] (__do_softirq+0xcc/0x200)
> (__do_softirq) from [<c0019734>] (irq_exit+0x80/0xe0)
> (irq_exit) from [<c0009c10>] (handle_IRQ+0x64/0x80)
> (handle_IRQ) from [<c000c3a0>] (__irq_svc+0x40/0x4c)
> (__irq_svc) from [<c0009d44>] (arch_cpu_idle+0x2c/0x34)
>
> Such packets can appear for example when using the carl9170 wireless driver
> because hardware sometimes generates garbage when the internal FIFO overruns.
>
> This patch adds an additional length check.
>
> Cc: stable@vger.kernel.org
> Fixes: 7ec7c4a9a686 ("mac80211: port CCMP to cryptoapi's CCM driver")
> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
> v1 -> v2:
>     - return negative error value
>
>  net/mac80211/aes_ccm.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
> index ec24378..09d9caa 100644
> --- a/net/mac80211/aes_ccm.c
> +++ b/net/mac80211/aes_ccm.c
> @@ -53,6 +53,9 @@ int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
>                 __aligned(__alignof__(struct aead_request));
>         struct aead_request *aead_req = (void *) aead_req_data;
>
> +       if (data_len == 0)
> +               return -EINVAL;
> +
>         memset(aead_req, 0, sizeof(aead_req_data));
>
>         sg_init_one(&pt, data, data_len);
> --
> 1.9.3
>
