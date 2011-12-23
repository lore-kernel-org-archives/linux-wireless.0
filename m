Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:39884 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab1LWJNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 04:13:14 -0500
Received: by lagu2 with SMTP id u2so3627142lag.9
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 01:13:11 -0800 (PST)
Subject: Re: [PATCH] wl12xx: trigger recovery for failures in sched scan
 stop
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
In-Reply-To: <CAF8O4-zGsxeRGPBQc-mKTNF_UiRh2JACm793MKGPKdEt9wKecg@mail.gmail.com>
References: <1324469186-18507-1-git-send-email-eyal@wizery.com>
	 <CAB3XZEdMS-_=qz+DTjtEsM8CGa0wvyqKdtWNF5+aCjV+=+326g@mail.gmail.com>
	 <CAF8O4-zh25pd7T937tbmRcFgmTVpZPtJbFP8OJKhgcaeSSqaSw@mail.gmail.com>
	 <CAF8O4-zGsxeRGPBQc-mKTNF_UiRh2JACm793MKGPKdEt9wKecg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 11:13:08 +0200
Message-ID: <1324631588.2182.338.camel@cumari> (sfid-20111223_101319_505773_8CEB5E08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-23 at 03:11 +0200, Eyal Shapira wrote: 
> On Fri, Dec 23, 2011 at 3:07 AM, Eyal Shapira <eyal@wizery.com> wrote:
> > On Thu, Dec 22, 2011 at 10:59 AM, Eliad Peller <eliad@wizery.com> wrote:
> >> On Wed, Dec 21, 2011 at 2:06 PM, Eyal Shapira <eyal@wizery.com> wrote:
> >> > mac80211 requires that drv_sched_scan_stop
> >> > will always succeed. We have a few possible errors
> >> > such as OOM, failure to ELP wakeup, fail in the FW command.
> >> > Instead of no-op , trigger a recovery which would
> >> > mark sched scan as stopped and clear up any bad FW state.
> >> >
> >> > Signed-off-by: Eyal Shapira <eyal@wizery.com>
> >> > ---
> >> this patch seems a bit redundant.
> >>
> >> >        ret = wl1271_ps_elp_wakeup(wl);
> >> > -       if (ret < 0)
> >> > +       if (ret < 0) {
> >> > +               wl12xx_queue_recovery_work(wl);
> >> >                goto out;
> >> > +       }
> >> >
> >> we enqueue recovery in wl1271_ps_elp_wakeup() in most error paths.
> >>
> ok. agreed. what about the path of completion error in wl1271_ps_elp_wakeup() ?
> Why not trigger recovery in that case as well ?

If the wake up times out, the firmware has very likely crashed or is
stuck, so recovery is needed.

If the wake up _fails_, on the other hand, things are probably not too
bad.  We could probably recover without recovery. :P In most cases this
will generate a cascade of failures and things may go wrong, but in
other cases, such as debugfs, a failure is not bad.


> >>
> >> > -       /* FIXME: what to do if alloc'ing to stop fails? */
> >> >        stop = kzalloc(sizeof(*stop), GFP_KERNEL);
> >> >        if (!stop) {
> >> >                wl1271_error("failed to alloc memory to send sched scan stop");
> >> > -               return;
> >> > +               goto recovery;
> >> >        }
> >> not sure if initiating recovery here will really help. it'll probably
> >> fail as well, and good chances we are going to panic soon anyway :)
> >>
> Luca pointed out the same thing so I'm dropping this.

Okay, I will drop it for now and wait for v2 or a different solution.


> The question is what should we do with failing alloc as
> op_sched_scan_stop  should be void.

We could change the op_sched_scan_stop to return int instead.  At least
in this case there's a good reason for doing it.  We don't need to
return the error to the userspace (as it happens now in case of
failure), but we can at least use that to trigger the deallocation in
mac80211.


> Due to other changes in the sched_scan_stop path in mac/cfg80211 it's
> more important to
> call ieee80211_sched_scan_stoppeD() as otherwise allocs done in
> mac80211 won't be freed as well as the userspace
> won't be notified of sched scan stop.

Let's see what comes out of our discussion in the other thread. ;)


> Options:
> 1. Call ieee80211_sched_scan_stopped() for any failure (OOM,
> elp_wakeup, ...). This would free up the allocs in mac80211 and notify
> userspace
> but would leave the FW out of sync with the upper layers. The next
> sched scan initiated would trigger a recovery given that the previous
> sched
> scan wasn't stopped.

This also depends on what happens to the changes in cfg/mac80211.


> 2. No op - Just ignore kzalloc failure. Sched scan can't be stopped in
> this case and the userspace won't get any completion event and alloc
> in
> mac80211 will remain.

I don't think this is an option.  It will leak memory, so the OOM will
just get worse.  The userspace might have a timeout and retry the stop
after sometime, which would make things even worse.


> 3. Variation of 1 - Call stopped() but propagate to userspace through
> the NL event that we couldn't really stop.
> I don't think that would fly as it's more of an API change to userspace.

Not so good.  As I mentioned in the other thread, maybe we could delay
the stop command completion?


> I understand that option #2 is what we're going for lacking a better
> alternative.
> Any other ideas / opinions ?

Let's wait and see what comes out of the cfg/mac80211 discussion.


> >> anyway, the major thing i don't like here is handling the sched_stop
> >> in a different manner than the rest of the commands.

This was exactly one of my concerns when I mentioned privately to Eyal
that this looked a bit weird.  I don't see a good reason why
sched_scan_stop would have more dramatic failure consequences than other
commands.

-- 
Cheers,
Luca.

