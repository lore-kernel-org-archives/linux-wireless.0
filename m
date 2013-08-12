Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3HLQBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 12:01:21 -0400
Message-ID: <1376323275.11514.26.camel@jlt4.sipsolutions.net> (sfid-20130812_180124_940216_495C2266)
Subject: Re: [RFC] mac80211: add support for split-MAC implementations
From: Johannes Berg <johannes@sipsolutions.net>
To: Johan Almbladh <ja@anyfi.net>,
	Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Aug 2013 18:01:15 +0200
In-Reply-To: <CAJWpbEjdHR0HJjPBwSPN0m4kabLWbfV5pWec+9cwbvyWD+AOgg@mail.gmail.com> (sfid-20130811_221953_352873_432329DF)
References: <1375968116-24331-1-git-send-email-ja@anyfi.net>
	 <1376053671.8355.4.camel@jlt4.sipsolutions.net>
	 <CAJWpbEg74C7DYbDkWCpNJRte7X7+40UHgNAL7uWLFHJ64CApKw@mail.gmail.com>
	 <CAJWpbEjdHR0HJjPBwSPN0m4kabLWbfV5pWec+9cwbvyWD+AOgg@mail.gmail.com>
	 (sfid-20130811_221953_352873_432329DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-08-11 at 22:19 +0200, Johan Almbladh wrote:
> I would prefer my original solution that puts the decryption handler
> after the sta_process handler. The code is cleaner since we avoid the
> extra flag and the coupling between decrypt and sta_process. My
> conclusion is that the change is correct, see below.

I actually agree and think that it makes our implementation of 802.11
more robust, but I think that should be said in the changelog and be
carefully analysed (as I guess you've done below)

> ieee80211_rx_h_check_more_data, ieee80211_rx_h_uapsd_and_pspoll:
> The MOREDATA and PM bits are not protected by the encryption MIC. It
> should be valid to process those bits regardless of the decryption
> outcome.

Agree, those seem pretty clear.

> ieee80211_rx_h_sta_process:
> The updating of last_rx for an IBSS STA is conditional on the STA
> being AUTHORIZED. That state is the same regardless of whether the
> updating is done before or after decryption.

That's true, but my concern here was about the reboot problem:
 * two stations join a secure mesh and communicate
 * one of them reboots, but quickly rejoins the mesh
In this case sometimes it gets hard to detect the situation and keeping
the other station alive. OTOH, it already happens for beacon frames
which aren't encrypted anyway, so I think it shouldn't matter. Antonio?

> The main argument that the MOREDATA and PM bits are not protected by
> the encryption and are therefore independent. You can always send a
> spoofed NULLFUNC frame to an RSN AP or STA and have the PM and
> MOREDATA bits processed accordingly. My change allows data frames that
> could not be decrypted to be processed similar to NULLFUNC frames.

Right, of course.

> I have run mac80211 in STA and AP mode with this change for quite some
> time now without any problems. I will run it in IBSS mode also as you
> suggest.
> 
> Provided that my IBSS tests pass, should I send you a final patch that
> changes the RX handler order and their locations in the file?

I think the IBSS test would be rather difficult, but yes, I think you've
convinced me that the patch is fine - please do resend it.

johannes

