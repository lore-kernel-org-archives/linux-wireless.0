Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:53291 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760336AbZEPW0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 18:26:00 -0400
Received: by pzk13 with SMTP id 13so1531973pzk.33
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 15:26:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905161507r664cafd2i8815f400a5158b04@mail.gmail.com>
References: <1242397016.5799.102.camel@johannes.local> <43e72e890905161507r664cafd2i8815f400a5158b04@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 16 May 2009 15:25:41 -0700
Message-ID: <43e72e890905161525n79c64fb4p16b901e7f8422cc7@mail.gmail.com>
Subject: Re: some wireless suspend thoughts
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 16, 2009 at 3:07 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, May 15, 2009 at 7:16 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>>  * kick pci driver suspend/resume out of ath9k and keep the device in
>>   low power while unused
>
> This is nice.
>
>>  * make mac80211 send nullfunc for suspend/resume
>>  * make cfg80211 always call suspend/resume
>>
>> This is quite hackish. It works for me, but my AP disassocs me anyway
>> because it probes every 5 seconds and if you don't respond ... however,
>> due to the nullfunc at resume time we notice very very quickly since it
>> sends a deauth as a response to that.
>>
>> The ->shutdown hook in cfg80211 is a little odd.
>>
>> To implement WoW on top of this, we need to refactor the cfg80211 hooks
>> and probably actually pass the information to ->stop after all, I think?
>> I can't think of a good way to do this.
>
> Well that's for sure with this patch. Let me take a crack at it.

I noticed you nuked pci_save_state() and pci_restore_state(), that
saves PCI config space so seems required, so we'll have to still
inform drv_stop of the suspend case -- and not sure that is worth it.
What we save here is more control in mac80211 / cfg80211 but the
things we need to added makes me wonder if its worth it in this case.

  Luis
