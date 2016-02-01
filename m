Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:38640 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbcBAJnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 04:43:46 -0500
Message-ID: <56AF28CD.90507@broadcom.com> (sfid-20160201_104349_299554_59643E07)
Date: Mon, 1 Feb 2016 10:43:41 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hante Meuleman <meuleman@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arend van Spriel <aspriel@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH FIX?] brcmfmac: fix possible overflows in flowrings code
 by bumping u8 to u16
References: <1454198830-13971-1-git-send-email-zajec5@gmail.com>	<56ADDA44.90707@gmail.com> <CACna6rzMQ2St4HUiccp37Ki3-K5_f_cLddi-m4dk0iyzq-_rYA@mail.gmail.com> <F51492713EF10846800D8C0ED37A7DCE019CC2D8@SJEXCHMB15.corp.ad.broadcom.com>
In-Reply-To: <F51492713EF10846800D8C0ED37A7DCE019CC2D8@SJEXCHMB15.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2016 09:46 AM, Hante Meuleman wrote:
> Hi,
>
> Didn’t know that that patch got reverted. Our internal repository still has that patch and we have had no problems whatsoever for the last 7 (june 26 this got submitted internally) months on any pcie target (also used it on r8000 openwrt). Rafal's patch is overdone. If you don’t up the hashsize space then there is really no use to switch to u16. You can simply limit the nr of flowrings to 255 in brcmf_proto_msgbuf_attach or apply the patch I originally submitted.

Ok. While no issues were seen I think we can not ignore the reported 
problem.

Rafal,

Can you try Hante's patch on your current branch, ie. incorporate hash 
size change and see if this shows any issues on 43602 target. If so full 
driver logging would be great so we can look at that.

Regards,
Arend

> Regards,
> Hante
>
> -----Original Message-----
> From: Rafał Miłecki [mailto:zajec5@gmail.com]
> Sent: Sunday, January 31, 2016 12:44 PM
> To: Arend van Spriel
> Cc: Kalle Valo; linux-wireless@vger.kernel.org; Brett Rudley; Arend Van Spriel; Franky (Zhenhui) Lin; Hante Meuleman; brcm80211-dev-list
> Subject: Re: [PATCH FIX?] brcmfmac: fix possible overflows in flowrings code by bumping u8 to u16
>
> On 31 January 2016 at 10:56, Arend van Spriel <aspriel@gmail.com> wrote:
>> On 31-01-16 01:07, Rafał Miłecki wrote:
>>> Some devices may use more than 255 flowings, below is log from BCM4366:
>>> [  194.606245] brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 264
>>>
>>> At various places we were using u8 which could lead to storing wrong
>>> number or infinite loops when indexing incorrectly. Initially this
>>> issue was spotted as infinite loop in brcmf_flowring_detach.
>>
>> There has already been a patch submitted for this [1]. However, because
>> you reported issues with it on your device (not sure which one). Did you
>> test this patch on that particular device.
>
> I wasn't aware Hante's patch contained changes from this patch. Anyway
> the main difference is that my patch doesn't touch
> BRCMF_FLOWRING_HASHSIZE.
>
> So my patch:
> 1) Fixes possible overflows in flowrings
>
> Hante's patch:
> 1) Fixes possible overflows in flowrings
> 2) Bumps BRCMF_FLOWRING_HASHSIZE
>
> It was bumping BRCMF_FLOWRING_HASHSIZE that caused problems on my
> BCM43602 device back then. Please note BCM43602 wasn't affected by
> flowings overflows because it wasn't using more than 255 of them:
> brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 132
>
> The story is different with my BCM4366. I didn't try it with bumping
> BRCMF_FLOWRING_HASHSIZE but it suffers from overflows in flowrings as
> it seems to be independent issue. It's crucial that BCM4366 uses more
> than 255 flowrings:
> brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 264
>
>
>> I want Hante to review your patch, but indeed this would be 4.5 material
>> and probably stable.
>
> I just realized BCM4366 support went into 4.4 not 4.5, so Cc-ing
> stable for 4.4+ is probably a good idea.
>

