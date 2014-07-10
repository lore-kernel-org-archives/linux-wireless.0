Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34148 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaGJRrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 13:47:42 -0400
Received: by mail-ie0-f180.google.com with SMTP id at20so1283307iec.39
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 10:47:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53BEB909.3030802@imgtec.com>
References: <82A67CC48AF04D43A69EB66645975134218BA7EE@hbmail01.hb.imgtec.org>
	<53BEB909.3030802@imgtec.com>
Date: Thu, 10 Jul 2014 20:47:41 +0300
Message-ID: <CAB3XZEeNjnsHoXCfvnMxUgXB3cFKuAAy-CXzdOvT4hDjzmrwuA@mail.gmail.com> (sfid-20140710_194745_215446_2D4D08C7)
Subject: Re: [PATCH] mac80211: Requeue work for all iftypes after scan completion
From: Eliad Peller <eliad@wizery.com>
To: Sachin Kulkarni <Sachin.Kulkarni@imgtec.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2014 at 7:02 PM, Sachin Kulkarni
<Sachin.Kulkarni@imgtec.com> wrote:
>
> From: Sachin Kulkarni<sachin.kulkarni@imgtec.com>
>
> During a hw scan ieee80211_iface_work ignores work items for all vifs.
> However
> after the scan complete work is requeued only for STA, ADHOC and MESH
> iftypes.
> This occasionally results in event processing getting delayed for iftype AP
> when
> it coexists with a STA, and when the scan durations are very long.
>
> Signed-off-by: Sachin Kulkarni<sachin.kulkarni@imgtec.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: johannes@sipsolutions.net
> ---
> We have a test scenario where there are 2 VIFs: one STA and one AP. The STA
> is
> not connected to anyone while the AP has a station connected to it. The
> hardware
> we are using currently has scan durations of ~8 sec and a new scan request
> is
> generated every 10 s. This results in a window of only 2 s when work items
> can
> be processed by ieee80211_iface_work. We came across scenarios where the AP
> is
> trying to tear down a AMPDU session, and the IEEE80211_SDATA_QUEUE_AGG_STOP
> event gets queued. However the work item for this gets ignored by the
> ieee80211_iface_work
> since a hw scan is in progress most of the time. When the scan completes
> however
> the work item for the AP does not get requeued, and by the time the
> IEEE80211_SDATA_QUEUE_AGG_STOP gets processed in some other work items
> context,
> the TX frames just keep getting queued up, since the tid has not been
> destroyed.
> This results in disconnections since things like ARP timeouts etc start
> happening.
> ---
afaict, there doesn't seem to be any good reason to exit
ieee80211_iface_work in case of hw scan (rather than sw_scan).
we had a patch for it (one-liner), but it probably got forgotten in
some internal tree :)

Eliad.
