Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64476 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaCaHiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 03:38:51 -0400
Message-ID: <53391B89.7010304@broadcom.com> (sfid-20140331_093952_713641_29AC2BB4)
Date: Mon, 31 Mar 2014 09:38:49 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] brcm80211: deinline brcmf_chip_cr4_enterdl, save
 440 bytes
References: <1396215079-7541-1-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1396215079-7541-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30/03/14 23:31, Denys Vlasenko wrote:
> Automated script discovered that without forced inlining,
> gcc-4.7 generates smaller code for this function.
>
> There is no need to declare static functions inline anyway:
> nowadays gcc detects single-callsite static functions
> which benefit from inlining.

These patches look awfully familiar. I tend to object, but I don't know 
the details of this automated script. Does it only look for code size. 
How about execution time or is this only compile tested? The other thing 
is that you seem to rely on a specific gcc version. What about pre-4.7? 
How about different architectures. Was this determined on x86, arm, 
sparc, mips. All these questions make me say 'nay'.

Regards,
Arend

> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/chip.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
> index df130ef..d020b0b 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
> @@ -933,7 +933,7 @@ static bool brcmf_chip_cm3_exitdl(struct brcmf_chip_priv *chip)
>   	return true;
>   }
>
> -static inline void
> +static void
>   brcmf_chip_cr4_enterdl(struct brcmf_chip_priv *chip)
>   {
>   	struct brcmf_core *core;
>

