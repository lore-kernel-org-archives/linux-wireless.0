Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:38695 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbaHHJOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 05:14:31 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so5357726wes.31
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 02:14:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407402308-29899-3-git-send-email-michal.kazior@tieto.com>
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
	<1407402308-29899-3-git-send-email-michal.kazior@tieto.com>
Date: Fri, 8 Aug 2014 11:14:29 +0200
Message-ID: <CA+BoTQkDcp3Aqp2=s_1NJsG1a+RhBkmpAmy-4Ov0NFFtS_sraQ@mail.gmail.com> (sfid-20140808_111438_959728_710B15AA)
Subject: Re: [PATCH 2/5] ath10k: dont reset the chip on hif_stop
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 August 2014 11:05, Michal Kazior <michal.kazior@tieto.com> wrote:
> The copy engine structures are never changed until
> driver unregisters the device so it is not
> necessary to reset the device chip anymore when
> stopping.
>
> This reduces driver register time approx. by 200ms.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 7efcf8e..6a5ca9e 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1192,13 +1192,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
>
>         ath10k_pci_buffer_cleanup(ar);
>
> -       /* Make the sure the device won't access any structures on the host by
> -        * resetting it. The device was fed with PCI CE ringbuffer
> -        * configuration during init. If ringbuffers are freed and the device
> -        * were to access them this could lead to memory corruption on the
> -        * host. */
> -       ath10k_pci_warm_reset(ar);
> -
>         ar_pci->started = 0;

If firmware crashes it doesn't necessarily mean hardware has crashed
as well. Since htt rx ring dma buffer is fed directly to hardware it
can still be accessed even after firmware has crashed (e.g. receive
beacons in station mode). This means calling hif_stop must guarantee
to stop hardware completely or else it might corrupt host memory
(notably sk_buffs; pretty badly - I've been hitting general protection
faults randomly and was puzzled at first).

Thus this patch has to be dropped (I'll probably replace it with a
patch to update the comment only).


Michał
