Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3FKLaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:30:21 -0400
Message-ID: <1370950216.8356.10.camel@jlt4.sipsolutions.net> (sfid-20130611_133100_935359_1F1F244D)
Subject: Re: [PATCH v2 2/2] mac80211: update mesh beacon on workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Bob Copeland <me@bobcopeland.com>
Date: Tue, 11 Jun 2013 13:30:16 +0200
In-Reply-To: <1370895442-21784-2-git-send-email-thomas@cozybit.com> (sfid-20130610_221954_141807_F12A5B9B)
References: <1370895442-21784-1-git-send-email-thomas@cozybit.com>
	 <1370895442-21784-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130610_221954_141807_F12A5B9B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-10 at 13:17 -0700, Thomas Pedersen wrote:

> +	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> +	u32 bit;
> +
> +	/* if we race with running work, worst case this work becomes a noop */
> +	for_each_set_bit(bit, (unsigned long *)&changed,
> +			 sizeof(changed) * BITS_PER_BYTE)

This isn't valid, it happens to work on little endian platforms but will
fail on big endian 64-bit ones, because you have this in memory (0 is
the lowest order nibble):

76 54 32 10 -- -- -- --

and now you point an unsigned long pointer to it, so you interpret the
"--" as the lowest bits.


More generally, I'd argue that mesh is being a bit odd here, flushing
stations turing mesh stop can and will actually cause a BSS info update
after the mesh interface has already been stopped (beaconing has been
disabled in the driver.) This seems rather odd. Maybe it would be better
to move the beacon update out of mesh_sta_cleanup() and into
ieee80211_mesh_housekeeping() in some way? Although it'd also have to be
done in the station handling in cfg.c but that shouldn't be a problem?

Note also that the way you did this is rather odd, ieee80211_stop_mesh()
could cause to schedule out to the workqueue for the update, but then
the update won't happen. It's a bit racy though, because you could stop
and restart the mesh and then the workqueue runs or something? Overall
this approach seems a bit brittle?

johannes

