Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:59825 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbbAONBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 08:01:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Use put_unaligned_le32
References: <20150106035319.GA4082@vaishali-Ideapad-Z570>
Date: Thu, 15 Jan 2015 15:00:59 +0200
In-Reply-To: <20150106035319.GA4082@vaishali-Ideapad-Z570> (Vaishali Thakkar's
	message of "Tue, 6 Jan 2015 09:23:19 +0530")
Message-ID: <87iog8ryes.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_140113_956177_4808EC8F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vaishali Thakkar <vthakkar1994@gmail.com> writes:

> This patch introduces the use of function put_unaligned_le32.
>
> This is done using Coccinelle and semantic patch used is as follows:
>
> @a@
> typedef u32, __le32, uint32_t;
> {u32,__le32,uint32_t} e32;
> identifier tmp;
> expression ptr;
> expression y,e;
> type T;
> type T;
> @@
>
> - tmp = cpu_to_le32(y);
>
> <+... when != tmp
> (
> - memcpy(ptr, (T)&tmp, \(4\|sizeof(u32)\|sizeof(__le32)\|sizeof(uint32_t)\|s
> + put_unaligned_le32(y,ptr);
> |
> - memcpy(ptr, (T)&tmp, ...);
> + put_unaligned_le32(y,ptr);
> )
> ...+>
> ? tmp = e
>
> @@ type T; identifier a.tmp; @@
>
> - T tmp;
> ...when != tmp
>
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>

This failed to apply, please rebase:

Applying: brcmfmac: Use put_unaligned_le32
error: drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c: does not exist in index
Patch failed at 0001 brcmfmac: Use put_unaligned_le32


-- 
Kalle Valo
