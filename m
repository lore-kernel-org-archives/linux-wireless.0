Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57181 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164AbcBYJ77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 04:59:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com, <stable@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: Increase nr of supported flowrings.
References: <1454886030-16406-1-git-send-email-zajec5@gmail.com>
Date: Thu, 25 Feb 2016 11:59:53 +0200
In-Reply-To: <1454886030-16406-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Mon, 8 Feb 2016
 00:00:30 +0100")
Message-ID: <871t81f6ue.fsf@kamboji.qca.qualcomm.com> (sfid-20160225_110006_740890_2FBD6031)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>
> New generation devices have firmware which has more than 256 flowrings.
> E.g. following debugging message comes from 14e4:4365 BCM4366:
> [  194.606245] brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 264
>
> At various code places (related to flowrings) we were using u8 which
> could lead to storing wrong number or infinite loops when indexing with
> this type. This issue was quite easy to spot in brcmf_flowring_detach
> where it led to infinite loop e.g. on failed initialization.
>
> This patch switches code to proper types and increases the maximum
> number of supported flowrings to 512.
>
> Originally this change was sent in September 2015, but back it was
> causing a regression on BCM43602 resulting in:
> Unable to handle kernel NULL pointer dereference at virtual address ...
>
> The reason for this regression was missing update (s/u8/u16) of struct
> brcmf_flowring_ring. This problem was handled in 9f64df9 ("brcmfmac: Fix
> bug in flowring management."). Starting with that it's safe to apply
> this original patch as it doesn't cause a regression anymore.
>
> This patch fixes an infinite loop on BCM4366 which is supported since
> 4.4 so it makes sense to apply it to stable 4.4+.
>
> Cc: <stable@vger.kernel.org> # 4.4+
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Applied manually, thanks.

-- 
Kalle Valo
