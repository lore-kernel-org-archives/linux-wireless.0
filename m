Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42584 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0KCQlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 12:41:06 -0400
Received: by iwn10 with SMTP id 10so960164iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 09:41:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik+dFEAqGdk9NJpbr8tGKc_NagO8nXSBF4sDtTt@mail.gmail.com>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
	<8762whrqvm.fsf@gmail.com>
	<AANLkTik+dFEAqGdk9NJpbr8tGKc_NagO8nXSBF4sDtTt@mail.gmail.com>
Date: Wed, 3 Nov 2010 17:41:06 +0100
Message-ID: <AANLkTiniUxJbshyJa_3Qfxq-wNiFK+KfRbg7Vi8PudSx@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Björn Smedman <bjorn.smedman@venatech.se>:
> On Mon, Nov 1, 2010 at 4:43 PM, Ben Gamari <bgamari@gmail.com> wrote:
>> On Mon, 1 Nov 2010 16:17:23 +0100, Björn Smedman <bjorn.smedman@venatech.se> wrote:
>>> Hi all,
>>>
>>> I have an application that creates and destroys a lot of ap vifs and
>>> does a lot of monitor frame injection. The recent ath9k rx locking
>>> fixes have helped with stability in this use-case but there still
>>> seems to be some tx/beacon related race condition(s). These manifests
>>> themselves as follows on an AR913x based router running
>>> compat-wireless-2010-10-19 (with locking fixes etc from openwrt):
>>>
>>> 1. TX DMA hangs under simultaneous high RX and TX load
>>> 2. TX is completely hung but chip is never reset
>>
>> I have also observed both of these behaviors with just a standard
>> hostapd single VIF configuration. Quite annoying. It seems to be better
>> with recent wireless-testing trees.
>>
>> - Ben
>
> I just posted "[RFC] ath9k: fix tx queue selection" with a patch that
> fixes (or at least reduces) these two for me. I'm not sure it is the
> whole story but at least in theory 1 could be caused by locking one tx
> queue and actually transmitting on another. 2 is probably caused by
> stopping one mac80211 queue and then starting another.

Problem 1 is still there. After 5-15 hours of varying rx/tx frame
injection load something like this happens and the chip goes
deaf/mute:

      Jan  1 00:18:33 user.debug kernel: ath: DMA failed to stop in 10
ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
      Jan  1 00:18:33 user.debug kernel: ath: DMA failed to stop in 10
ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
      Jan  1 00:18:33 user.debug kernel: ath: ah->misc_mode 0xc
      Jan  1 00:18:33 user.debug kernel: ath: Setting CFG 0x10a
      Jan  1 00:18:43 user.debug kernel: ath: Timeout while waiting
for nf to load: AR_PHY_AGC_CONTROL=0x40d22
      Jan  1 00:18:44 user.debug kernel: ath: DMA failed to stop in 10
ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
      Jan  1 00:18:44 user.debug kernel: ath: DMA failed to stop in 10
ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
      Jan  1 00:18:44 user.debug kernel: ath: ah->misc_mode 0xc
      Jan  1 00:18:44 user.debug kernel: ath: Setting CFG 0x10a

Problem 2 seems gone though.

/Björn
