Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:48945 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZENJCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 05:02:53 -0400
Received: by bwz22 with SMTP id 22so1145146bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 02:02:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905131445s5583481bgb556a925247368db@mail.gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	 <43e72e890905131445s5583481bgb556a925247368db@mail.gmail.com>
Date: Thu, 14 May 2009 10:02:53 +0100
Message-ID: <9b2b86520905140202y539f8b93m9669e2c8c7ffbdcd@mail.gmail.com>
Subject: Re: [RFT v9] rfkill: rewrite
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Easwar Krishnan <Easwar.Krishnan@atheros.com>,
	Nataraj Sadasivam <Nataraj.Sadasivam@atheros.com>,
	Kathir Ganapthy <Kathir.Ganapthy@atheros.com>,
	Ponmudi Ramachandran <Ponmudi.Ramachandran@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/13/09, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, May 12, 2009 at 7:09 AM, Alan Jenkins
> <sourcejedi.lkml@googlemail.com> wrote:
>> On 5/11/09, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> This patch completely rewrites the rfkill core to address
>>> the following deficiencies:
>>
>> Btw, git-apply nitpicks on your whitespace
>>
>>    rfkill-rewrite.patch:4335: space before tab in indent.
>>            mutex_unlock(&rfkill_global_mutex);
>>    warning: 1 line adds whitespace errors.
>>
>>
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
> I think my new 4 patches should address this and it'd be great to hear
> your tests as you can reproduce easily. We are able to see something
> like this but only after 3 hours of testing. Since it seems you might
> be able to reproduce quickly it would help.

Glad to be of service :-).

I applied your four patches on top of my current tree
(wireless-testing+rfkill rewrite), and it fixed the OOPS.

As a sanity check, I tried un-applying patch 4/4 (cfg80211: fix race
between core hint and driver's custom apply), since that looked like
the fix I was interested in.  Un-applying this fix caused the OOPS to
reappear.

Thanks!
Alan
