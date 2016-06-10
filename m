Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35334 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbcFJHtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 03:49:53 -0400
Received: by mail-wm0-f53.google.com with SMTP id v199so137251376wmv.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2016 00:49:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5759FFAF.4040609@candelatech.com>
References: <5759FFAF.4040609@candelatech.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 10 Jun 2016 09:49:50 +0200
Message-ID: <CA+BoTQkSE5c=v08r=XsHgX27+pLMPSt2daP3Rh6tEw6fdtj6wg@mail.gmail.com> (sfid-20160610_094957_150639_2B75E45C)
Subject: Re: Any reason to allow MGT TID to be paused by power-save?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 June 2016 at 01:45, Ben Greear <greearb@candelatech.com> wrote:
> I'm trying to track down a tricky problem with a Mac book and power save
> with my ath10k firmware.
>
> At least part of the issue is that when the Mac sleeps, it goes into
> power-save
> state as far as AP is concerned, and then it simply turns itself off.  When
> it wakes
> up a short time later, it then tries to scan and re-associate.  But, if
> hostapd
> hasn't timed out the station (due to longer idle timer), then STA still is
> treated
> as being in power-save in the firmware.  It appears that this causes
> mgt-frames (probe responses)
> not be sent back out of the firmware, so Mac gives up fairly quickly.
>
> I fixed at least some of this by forcing a power-save wake on
> receipt of probe requests and auth requests, but some issues remain
> for one reason or another.
>
> One thing that came to mind:  Is it *ever* a good idea to pause a mgt-tid
> due to
> power-save?

The spec defines some mgmt frames as bufferable (IEEE 802.11-2012
8.2.4.1.7). See ieee80211_is_bufferable_mmpdu() in
include/linux/ieee80211.h.

Action, deauth and disassoc are bufferable. It makes sense anyway.

E.g. On DFS channel you may opt for CSA action frame (instead of CSA
IE in beacons) in which case you do want to buffer frames to clients
that are asleep to give them a chance to notice it, wake up and get
it.


Michał
