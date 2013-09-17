Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59373 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3IQLa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 07:30:58 -0400
Received: by mail-ie0-f170.google.com with SMTP id x13so10004464ief.15
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 04:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DB0B1C@HASMSX103.ger.corp.intel.com>
References: <1379396919-11983-1-git-send-email-emmanuel.grumbach@intel.com>
	<CAB3XZEc-h=mS-etjvm_zeJ2czsLj9yseq+jpsXOR=smy5+7Rdg@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301DB0B1C@HASMSX103.ger.corp.intel.com>
Date: Tue, 17 Sep 2013 13:30:57 +0200
Message-ID: <CAB3XZEfuOmiotA5GtprJNm_XqFK20=8JJAbv9TAD6qaZkX80Tw@mail.gmail.com> (sfid-20130917_133101_201541_89A897EC)
Subject: Re: [RFC] mac80211: correctly close cancelled scans
From: Eliad Peller <eliad@wizery.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 17, 2013 at 2:28 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>> On Tue, Sep 17, 2013 at 8:48 AM, Emmanuel Grumbach
>> <emmanuel.grumbach@intel.com> wrote:
>> > __ieee80211_scan_completed is called from a worker. This means that
>> > the following flow is possible.
>> >
>> >  * driver calls ieee80211_scan_completed
>> >  * mac80211 cancels the scan (that is already complete)
>> >  * __ieee80211_scan_complete runs
>> >
>> > When scan_work will finally run, it will see that the scan hasn't been
>> > aborted and might even trigger another scan on another band. This
>> > leads to a situation where cfg80211's scan is not done and no further
>> > scan can be issued.
>> >
>> > Fix this by setting a new flag when a HW scan is being cancelled so
>> > that no other scan will be triggered.
>> >
>> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> > ---
>> [...]
>>
>> >         if (test_bit(SCAN_HW_SCANNING, &local->scanning)) {
>> > -               if (local->ops->cancel_hw_scan)
>> > +               /*
>> > +                * Make sure that __ieee80211_scan_completed doesn't trigger a
>> > +                * scan on another band.
>> > +                */
>> > +               set_bit(SCAN_HW_CANCELLED, &local->scanning);
>> > +               if (local->ops->cancel_hw_scan) {
>> >                         drv_cancel_hw_scan(local,
>> >                                 rcu_dereference_protected(local->scan_sdata,
>> >
>> > lockdep_is_held(&local->mtx)));
>> > +               }
>> >                 goto out;
>> >         }
>>
>> you don't seem to clear this flag anywhere...
>>
>
> Yeah - just like SCAN_HW_SCANNING isn't cleared anywhere... but... in __ieee80211_scan_completed:
>
>         local->scanning = 0;
>         local->scan_chandef.chan = NULL;
>
> yes I know. Don't ask.

oh, right, i overlooked it :)

Eliad.
