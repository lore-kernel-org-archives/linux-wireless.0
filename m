Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1ASKLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 05:11:15 -0500
MIME-Version: 1.0
In-Reply-To: <1295430682.4685.1.camel@jlt3.sipsolutions.net>
References: <AANLkTi=DLpfpLYAftktUKa5grNyTeT0-reyjEsrr-NwR@mail.gmail.com>
	<1295430682.4685.1.camel@jlt3.sipsolutions.net>
Date: Wed, 19 Jan 2011 17:11:14 +0700
Message-ID: <AANLkTimdBRXebouUbnrXhUczqgeadAR=kHrrhB5MksP=@mail.gmail.com>
Subject: Re: [2.6.38-rc1] iwlagn lock misuse...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 19 January 2011 16:51, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2011-01-19 at 16:44 +0700, Daniel J Blueman wrote:
>> Booting an instrumented 2.6.38-rc1 kernel with an Intel WiFi Link 5300
>> card and associating with an access point, I see a lockdep warning
>> [attached].
>>
>> This is essentially (struct iwl_priv)->lock being taken with
>> interrupts disabled in iwl-agn-ict.c:152 [1] and the same lock taken
>> with interrupts enabled in rx.c:2476 [2] (confirmed via disassembly).
>>
>> It feels like this would have been introduced in this commit:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6e8cc38d5b05bb812f89a35bd9bf52405e67d0df
>
> I think you're running into a lockdep false positive, it's not actually
> the same lock and lockdep confuses a few skb queue locks. Please apply
> this patch
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=53c16b8e752e8e58f4313f1155f3afadf78311bb
> and see if the problem persists.

Good move; it addresses the false-positive. I hope it can hit 2.6.38-rc2.

Thanks,
  Daniel
-- 
Daniel J Blueman
