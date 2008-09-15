Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYION6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 09:58:42 -0400
Subject: Re: More thoughts about roaming ...
From: Dan Williams <dcbw@redhat.com>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809151416.07552.hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 09:59:20 -0400
Message-Id: <1221487160.10177.14.camel@localhost.localdomain> (sfid-20080915_155847_116921_9A9B4FFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-15 at 14:16 +0200, Helmut Schaa wrote:
> Hi,
> 
> As a result of the thread "Pondering: how to improve mac80211 roaming ..."
> I thought a bit more about that topic. Here is a quick suggestion for a first
> version:
> 
> * Enhance mac80211 software scan to interrupt the current scan and switch
>   back to the operating channel every once in a while (only if at least one STA
>   interface is associated) => background scan.
> 
> * Enhance mac80211 to check the signal quality frequently (or any other
>   indicator like beacon misses) and decide when the signal quality is too low.
>   Indicate that to the user space.
> 
> * wpa_supplicant (or any other user space application) gets notified about
>   the low signal quality and triggers a scan in order to find a better AP.
>   wpa_supplicant already chooses the AP with the best signal strength.

I'm pretty sure it doesn't.  The code in wpa_supplicant_select_bss()
doesn't have any logic to detect signal strength, nor does any driver
report signal strength to the supplicant.  Drivers set the level (well,
only wext/nl80211, ndis, iphone/osx, and bsd) but I'm pretty sure
nothing in the supplicant uses it.

Maybe now is the time to switch that on.  That needs to be coupled with
some additions to cfg80211 to turn firmware/driver roaming on and off,
along with a capability bit somewhere to indicate that the
driver/firmware support turning roaming on/off.

Dan


> The reason behind not triggering the scan directly from mac80211 is that the
> supplicant (or any other user space application) might know more about the
> current environment and could for example trigger a scan restricted to specific
> channels (in the future) which should speed up the scan. Hence let the user
> space decide what to do with a low signal.
> 
> However the detection of when the signal quality is low should still be done in
> mac80211 or the driver as some cards seem to have the needed functionality
> implemented in firmware (e.g. missed beacon interrupt).
> 
> I'll send some proof-of-concept patches in a few minutes which implement
> background scanning in software and the user space indication. I've tested them
> a bit already and they work quite well with an iwl4965.
> 
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

