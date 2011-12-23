Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64593 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1LWBLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 20:11:30 -0500
Received: by vcbfk14 with SMTP id fk14so7000287vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 17:11:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF8O4-zh25pd7T937tbmRcFgmTVpZPtJbFP8OJKhgcaeSSqaSw@mail.gmail.com>
References: <1324469186-18507-1-git-send-email-eyal@wizery.com>
 <CAB3XZEdMS-_=qz+DTjtEsM8CGa0wvyqKdtWNF5+aCjV+=+326g@mail.gmail.com> <CAF8O4-zh25pd7T937tbmRcFgmTVpZPtJbFP8OJKhgcaeSSqaSw@mail.gmail.com>
From: Eyal Shapira <eyal@wizery.com>
Date: Fri, 23 Dec 2011 03:11:08 +0200
Message-ID: <CAF8O4-zGsxeRGPBQc-mKTNF_UiRh2JACm793MKGPKdEt9wKecg@mail.gmail.com> (sfid-20111223_021133_820042_FD9CCEE2)
Subject: Re: [PATCH] wl12xx: trigger recovery for failures in sched scan stop
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 23, 2011 at 3:07 AM, Eyal Shapira <eyal@wizery.com> wrote:
>
>
>
> On Thu, Dec 22, 2011 at 10:59 AM, Eliad Peller <eliad@wizery.com> wrote:
>>
>> On Wed, Dec 21, 2011 at 2:06 PM, Eyal Shapira <eyal@wizery.com> wrote:
>> > mac80211 requires that drv_sched_scan_stop
>> > will always succeed. We have a few possible errors
>> > such as OOM, failure to ELP wakeup, fail in the FW command.
>> > Instead of no-op , trigger a recovery which would
>> > mark sched scan as stopped and clear up any bad FW state.
>> >
>> > Signed-off-by: Eyal Shapira <eyal@wizery.com>
>> > ---
>> this patch seems a bit redundant.
>>
>> >        ret = wl1271_ps_elp_wakeup(wl);
>> > -       if (ret < 0)
>> > +       if (ret < 0) {
>> > +               wl12xx_queue_recovery_work(wl);
>> >                goto out;
>> > +       }
>> >
>> we enqueue recovery in wl1271_ps_elp_wakeup() in most error paths.
>>
ok. agreed. what about the path of completion error in wl1271_ps_elp_wakeup() ?
Why not trigger recovery in that case as well ?
>
>>
>> > -       /* FIXME: what to do if alloc'ing to stop fails? */
>> >        stop = kzalloc(sizeof(*stop), GFP_KERNEL);
>> >        if (!stop) {
>> >                wl1271_error("failed to alloc memory to send sched scan stop");
>> > -               return;
>> > +               goto recovery;
>> >        }
>> not sure if initiating recovery here will really help. it'll probably
>> fail as well, and good chances we are going to panic soon anyway :)
>>
Luca pointed out the same thing so I'm dropping this.
The question is what should we do with failing alloc as
op_sched_scan_stop  should be void.
Due to other changes in the sched_scan_stop path in mac/cfg80211 it's
more important to
call ieee80211_sched_scan_stoppeD() as otherwise allocs done in
mac80211 won't be freed as well as the userspace
won't be notified of sched scan stop.
Options:
1. Call ieee80211_sched_scan_stopped() for any failure (OOM,
elp_wakeup, ...). This would free up the allocs in mac80211 and notify
userspace
but would leave the FW out of sync with the upper layers. The next
sched scan initiated would trigger a recovery given that the previous
sched
scan wasn't stopped.

2. No op - Just ignore kzalloc failure. Sched scan can't be stopped in
this case and the userspace won't get any completion event and alloc
in
mac80211 will remain.

3. Variation of 1 - Call stopped() but propagate to userspace through
the NL event that we couldn't really stop.
I don't think that would fly as it's more of an API change to userspace.

I understand that option #2 is what we're going for lacking a better
alternative.
Any other ideas / opinions ?

>> >        ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
>> >                              sizeof(*stop), 0);
>> > +
>> > +       kfree(stop);
>> > +
>> >        if (ret < 0) {
>> >                wl1271_error("failed to send sched scan stop command");
>> > -               goto out_free;
>> > +               goto recovery;
>> >        }
>> >
>> wl1271_cmd_send enqueues recovery work on error as well.
>>

got it. will be dropped.

>>
>> anyway, the major thing i don't like here is handling the sched_stop
>> in a different manner than the rest of the commands.
>>
>> Eliad.
>
>
