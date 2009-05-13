Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40473 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbZEMOgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 10:36:10 -0400
Received: by bwz22 with SMTP id 22so686097bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 07:36:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242211796.29288.7.camel@johannes.local>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	 <1242211796.29288.7.camel@johannes.local>
Date: Wed, 13 May 2009 15:36:09 +0100
Message-ID: <9b2b86520905130736j6cde99cak6fad414531b0168c@mail.gmail.com>
Subject: Re: [RFT v9] rfkill: rewrite
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/13/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-05-12 at 15:09 +0100, Alan Jenkins wrote:
>
>> I tested on todays wireless-testing, aka v2.6.30-rc5-23297-gbf2c6a3.
>> Somehow, it triggers an OOPS
>>
>> Function: req_reg_info_regd
>> Process: modprobe
>>
>> Call trace:
>> wiphy_apply_custom_regulatory
>> ath5k_regd_init
>> ath5k_reg_notifier
>> ath5k_pci_probe
>> ...
>>
>> Photo:
>> <http://picasaweb.google.com/sourcejedi.lkml/Screenshots#5334936857267342674>
>>
>> The kernel then hangs later on in the boot process.  It responds to
>> SysRq, but does not echo normal keypresses.  SysRq+P shows that the
>> kernel is in the idle task.  I left it for three minutes, but I didn't
>> get any trace from the hung task detector or soft lockup detector.
>>
>> At first I thought it must be a problem with wireless-testing.
>> However, it went away when I eventually tried un-applying the rfkill
>> rewrite patch.
>
> Confusing, but I think the stacktrace is just bogus. Can you recompile
> your kernel with CONFIG_FRAME_POINTER please?

Nope, cos it's already enabled :-).
