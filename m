Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34956 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbEUIoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 04:44:16 -0400
Received: by wgfl8 with SMTP id l8so78084501wgf.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 01:44:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432197058.2343.7.camel@sipsolutions.net>
References: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
	<1431508609-9841-1-git-send-email-michal.kazior@tieto.com>
	<1431508609-9841-2-git-send-email-michal.kazior@tieto.com>
	<1432127653.19214.12.camel@sipsolutions.net>
	<CA+BoTQkpjDodKNdSvj2ZdKemXU_2E39MVGZPob8+jkjBGESEfg@mail.gmail.com>
	<1432197058.2343.7.camel@sipsolutions.net>
Date: Thu, 21 May 2015 10:44:15 +0200
Message-ID: <CA+BoTQnSoZXz1nDVxnGxxKmO-dH57kCPKMfHj+j+HRNVPXRqxg@mail.gmail.com> (sfid-20150521_104422_110041_8AAC7E86)
Subject: Re: [PATCH v2 2/2] mac80211: prevent possible crypto tx tailroom corruption
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 May 2015 at 10:30, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2015-05-21 at 10:16 +0200, Michal Kazior wrote:
>
>> >>       rtnl_lock();
>> >> +     list_for_each_entry(sdata, &local->interfaces, list)
>> >> +             cancel_delayed_work_sync(&sdata->dec_tailroom_needed_wk);
>> >
>> > Would it make sense to just flush the work here? That way we don't have
>> > to do all the other things.
>>
>> Hmm.. dec_tailroom_needed_wk is queued on system workqueue now so
>> there's no feasible way of flushing it (restart_work is on a system
>> workqueue as well). It'd need to be moved to local->workqueue. I guess
>> that would work too.
>
> flush_work()?

Oh. I wasn't aware of this call.. Thanks for pointing out :-)


Michał
