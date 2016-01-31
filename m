Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34798 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298AbcAaLne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:43:34 -0500
Received: by mail-io0-f171.google.com with SMTP id 9so51397949iom.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2016 03:43:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56ADDA44.90707@gmail.com>
References: <1454198830-13971-1-git-send-email-zajec5@gmail.com>
	<56ADDA44.90707@gmail.com>
Date: Sun, 31 Jan 2016 12:43:33 +0100
Message-ID: <CACna6rzMQ2St4HUiccp37Ki3-K5_f_cLddi-m4dk0iyzq-_rYA@mail.gmail.com> (sfid-20160131_124337_462722_126B7941)
Subject: Re: [PATCH FIX?] brcmfmac: fix possible overflows in flowrings code
 by bumping u8 to u16
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <aspriel@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 January 2016 at 10:56, Arend van Spriel <aspriel@gmail.com> wrote:
> On 31-01-16 01:07, Rafał Miłecki wrote:
>> Some devices may use more than 255 flowings, below is log from BCM4366:
>> [  194.606245] brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 264
>>
>> At various places we were using u8 which could lead to storing wrong
>> number or infinite loops when indexing incorrectly. Initially this
>> issue was spotted as infinite loop in brcmf_flowring_detach.
>
> There has already been a patch submitted for this [1]. However, because
> you reported issues with it on your device (not sure which one). Did you
> test this patch on that particular device.

I wasn't aware Hante's patch contained changes from this patch. Anyway
the main difference is that my patch doesn't touch
BRCMF_FLOWRING_HASHSIZE.

So my patch:
1) Fixes possible overflows in flowrings

Hante's patch:
1) Fixes possible overflows in flowrings
2) Bumps BRCMF_FLOWRING_HASHSIZE

It was bumping BRCMF_FLOWRING_HASHSIZE that caused problems on my
BCM43602 device back then. Please note BCM43602 wasn't affected by
flowings overflows because it wasn't using more than 255 of them:
brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 132

The story is different with my BCM4366. I didn't try it with bumping
BRCMF_FLOWRING_HASHSIZE but it suffers from overflows in flowrings as
it seems to be independent issue. It's crucial that BCM4366 uses more
than 255 flowrings:
brcmfmac: brcmf_pcie_init_ringbuffers Nr of flowrings is 264


> I want Hante to review your patch, but indeed this would be 4.5 material
> and probably stable.

I just realized BCM4366 support went into 4.4 not 4.5, so Cc-ing
stable for 4.4+ is probably a good idea.
