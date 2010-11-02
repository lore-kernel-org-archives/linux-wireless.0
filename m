Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43381 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0KBQzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 12:55:23 -0400
Received: by gxk23 with SMTP id 23so4206315gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 09:55:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8762whrqvm.fsf@gmail.com>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
	<8762whrqvm.fsf@gmail.com>
Date: Tue, 2 Nov 2010 17:55:22 +0100
Message-ID: <AANLkTik+dFEAqGdk9NJpbr8tGKc_NagO8nXSBF4sDtTt@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Gamari <bgamari@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 1, 2010 at 4:43 PM, Ben Gamari <bgamari@gmail.com> wrote:
> On Mon, 1 Nov 2010 16:17:23 +0100, Björn Smedman <bjorn.smedman@venatech.se> wrote:
>> Hi all,
>>
>> I have an application that creates and destroys a lot of ap vifs and
>> does a lot of monitor frame injection. The recent ath9k rx locking
>> fixes have helped with stability in this use-case but there still
>> seems to be some tx/beacon related race condition(s). These manifests
>> themselves as follows on an AR913x based router running
>> compat-wireless-2010-10-19 (with locking fixes etc from openwrt):
>>
>> 1. TX DMA hangs under simultaneous high RX and TX load
>> 2. TX is completely hung but chip is never reset
>
> I have also observed both of these behaviors with just a standard
> hostapd single VIF configuration. Quite annoying. It seems to be better
> with recent wireless-testing trees.
>
> - Ben

I just posted "[RFC] ath9k: fix tx queue selection" with a patch that
fixes (or at least reduces) these two for me. I'm not sure it is the
whole story but at least in theory 1 could be caused by locking one tx
queue and actually transmitting on another. 2 is probably caused by
stopping one mac80211 queue and then starting another.

Ben, if you can easily trigger these problems on wireless-testing,
could you test with my patch and see if it helps? I'm especially
interested to see if it really fixes problem 1.

/Björn
