Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:34976 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3FKUcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 16:32:51 -0400
Received: by mail-bk0-f45.google.com with SMTP id je9so2690090bkc.18
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 13:32:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370950216.8356.10.camel@jlt4.sipsolutions.net>
References: <1370895442-21784-1-git-send-email-thomas@cozybit.com>
 <1370895442-21784-2-git-send-email-thomas@cozybit.com> <1370950216.8356.10.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 11 Jun 2013 13:32:30 -0700
Message-ID: <CAG6hwVMYyDc29hYAfD6niMS-Ckx91xs0_K-nyaUCE4xZ8nDzYQ@mail.gmail.com> (sfid-20130611_223412_355838_765F90B9)
Subject: Re: [PATCH v2 2/2] mac80211: update mesh beacon on workqueue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 11, 2013 at 4:30 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-06-10 at 13:17 -0700, Thomas Pedersen wrote:
>
>> +     struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>> +     u32 bit;
>> +
>> +     /* if we race with running work, worst case this work becomes a noop */
>> +     for_each_set_bit(bit, (unsigned long *)&changed,
>> +                      sizeof(changed) * BITS_PER_BYTE)
>
> This isn't valid, it happens to work on little endian platforms but will
> fail on big endian 64-bit ones, because you have this in memory (0 is
> the lowest order nibble):
>
> 76 54 32 10 -- -- -- --

> and now you point an unsigned long pointer to it, so you interpret the
> "--" as the lowest bits.

OK I was just trying to make the compiler happy, but that makes sense.
Assigning changed (u32) to an unsigned long then getting the address
of that should move the u32 into the lower half of an unsigned long on
a 64-bit BE system?
Thanks for explaining this.

> More generally, I'd argue that mesh is being a bit odd here, flushing
> stations turing mesh stop can and will actually cause a BSS info update
> after the mesh interface has already been stopped (beaconing has been
> disabled in the driver.) This seems rather odd. Maybe it would be better
> to move the beacon update out of mesh_sta_cleanup() and into
> ieee80211_mesh_housekeeping() in some way? Although it'd also have to be
> done in the station handling in cfg.c but that shouldn't be a problem?

Yes it is odd to queue a bss info update but never do so. I don't know
if it really matters though. The problem is mesh_sta_cleanup() is
called from several paths: mac80211 mesh runtime, stop_mesh(), and
cfg80211. I think this is a fairly clean way of satisfying all the
users (mesh work queued from stop_mesh() is a noop if we check
ifmsh->mesh_id_len instead of the wdev->mesh_id_len).

It sounds like you'd like beacon updates to be asynchronous, which
this patch already accomplishes :)

> Note also that the way you did this is rather odd, ieee80211_stop_mesh()
> could cause to schedule out to the workqueue for the update, but then
> the update won't happen. It's a bit racy though, because you could stop
> and restart the mesh and then the workqueue runs or something? Overall
> this approach seems a bit brittle?

I guess if you clear the ifmsh->wrkq_flags at the end of stop_mesh()
this wouldn't happen. Also as long as the check to ensure no mesh work
is performed while not joined is in place, we should be ok.

--
Thomas
