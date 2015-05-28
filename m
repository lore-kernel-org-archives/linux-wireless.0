Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34191 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbE1Meq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 08:34:46 -0400
Received: by igbhj9 with SMTP id hj9so112790832igb.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 05:34:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556701E9.8090807@broadcom.com>
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>
	<556701E9.8090807@broadcom.com>
Date: Thu, 28 May 2015 14:34:45 +0200
Message-ID: <CACna6rwm5L1tSd7S=9PNKnju-sxHxhYPbA0EcdJ5K=MwJzJvUA@mail.gmail.com> (sfid-20150528_143450_550791_BEA4DCFB)
Subject: Re: [PATCH] brcmfmac: use direct data pointer in NVRAM parser struct
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 May 2015 at 13:54, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/28/15 13:37, Rafał Miłecki wrote:
>>
>> As we plan to add support for platform NVRAM we should store direct
>> data pointer without the extra struct firmware layer. This will allow
>> us to support other sources with the only requirement being u8 buffer.
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> Signed-off-by: Hante Meuleman<meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>> Tested on router with BCM43602-s using
>> /lib/firmware/brcm/brcmfmac43602-pcie.txt
>>
>> I've written this patch from scratch, it's inspired by the dropped:
>> [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
>
>
> Hi Rafał,
>
> So what is your goal here. The inspirational patch was dropped so it can be
> resubmitted when the mips change it relies on has made its way upstream. So
> I have to rebase the patch over here and your patch will just give me
> conflicts during that rebase. So can we please wait or do you need this
> change right now.

The dropped patch will require rebasing/rewriting anyway. There were
few changes to firmware.c already, I've few more planned, you'll have
to drop some code form your patch (parts that will go into MIPS tree)
and probably apply few changes as requested in comments.
I also don't think it makes much sense to pause any development
because of having some out-of-tree patch queued for later submitting.

And after all, hey, look at the bright side! :) With this patch you'll
have to maintain smaller amount of out-of-tree(-for-now) code :)

So my goals are:
1) Have all required cleanups pushed mainline early.
2) Make it easier to main out-of-tree changes.
The personal reason behind that is to add OpenWrt support for BCM43602
as early as possible. Having clean backports + tiny NVRAM patch make
it much easier to do now, maintain and update in the future.
