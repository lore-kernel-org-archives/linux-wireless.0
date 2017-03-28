Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35635 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752407AbdC1OIb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 10:08:31 -0400
Received: by mail-wr0-f169.google.com with SMTP id u1so107208683wra.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 07:08:30 -0700 (PDT)
Subject: Re: [PATCH for-4.11 0/2] brcmfmac: fixing use-after-free reports
To: Kalle Valo <kvalo@codeaurora.org>
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
 <87o9wl7gt4.fsf@purkki.adurom.net>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7e8b6c65-e051-f86b-8b21-dfb0d5b966d3@broadcom.com> (sfid-20170328_160905_311284_C47195D6)
Date: Tue, 28 Mar 2017 16:08:22 +0200
MIME-Version: 1.0
In-Reply-To: <87o9wl7gt4.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-3-2017 13:59, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> Two use-after-free issues were found using KASAN and reported by
>> Daniel J Blueman. One of them was submitted as patch. However, no
>> response came upon my comments. So decided to push the fixes myself.
>>
>> These patches are intended for v4.11 and apply to the master branch of
>> the wireless-drivers repository.
>>
>> Arend van Spriel (2):
>>   brcmfmac: use local iftype avoiding use-after-free of virtual
>>     interface
>>   cfg80211: check rdev resume callback only for registered wiphy
>>
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  8 +++++---
>>  net/wireless/sysfs.c                                   | 10 ++++------
>>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> Why are these in the same patchset, are there any dependencies etc? Or
> is it safe that Johannes applies the cfg80211 patch to mac80211.git and
> I apply brcmfmac to wireless-drivers.git?

Yeah. My bad. I just realized while driving to pick up my son from
school :-p Anyway, these are in the same patchset just because of their
context and independent so you both can apply them in their respective
repository.

Regards,
Arend
