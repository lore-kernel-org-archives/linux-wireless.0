Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab3AINlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 08:41:02 -0500
Date: Wed, 9 Jan 2013 07:40:59 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Fixes for problems with off-channel powersave
Message-ID: <20130109134059.GC18778@thinkpad-t410> (sfid-20130109_144108_001846_33CB21D5)
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 08, 2013 at 12:10:42PM -0600, Seth Forshee wrote:
> Hi Johannes,
> 
> When testing with iperf I've been observing very significant problems
> with throughput and packet loss during software scans. Throughput often
> drops to the point where iperf is reporting 0 bits/sec for several
> seconds, and packet loss commonly gets over 20%. I started investigating
> and discovered the following problems:
> 
>  1. It seems that drivers are responsible for ensuring that PM is set in
>     frame control when powersave is enabled. However drivers are unaware
>     of off-channel powersave, so when the scan is suspended frames may
>     be transmitted that cause the AP to think we've exited powersave. As
>     a result the AP may attempt to deliver frames while we are
>     off-channel.
> 
>  2. There's no flushing of the hardware queues after queueing the
>     nullfunc frame to enable off-channel powersave before going
>     off-channel, so it's possible to go off-channel before the frame is
>     transmitted.
> 
>  3. There's no flush of pending frames prior to queueing the nullfunc
>     frame to enable powersave. That frame is sent at a high priority,
>     and drivers supporting QoS may have lower-priority frames queued
>     with PM cleared. Those frames will be sent after the nullfunc, and
>     the AP may try to deliver frames while we are off-channel.
> 
>  4. During a scan we won't process beacon frames from our associated AP,
>     which prevents PS-Poll from starting when the scan is suspended.
>     Even if we process the beacons we won't start PS-Poll unless
>     powersave is actually enabled, which isn't the case during a scan.
> 
>  5. The SCAN_SUSPEND state uses a fixed timeout, so if we do start
>     PS-Poll there's no guarantee that it will receive all buffered
>     frames from the AP before going back off-channel.
> 
> The following RFC patches contain fixes for problems 1, 2, and 3. I
> toyed around with fixing 4 and 5, but the results really aren't much
> better than before. Even with PS-Poll working properly during scans I
> was seeing poor throughput and high packet loss with iperf. So instead I
> tried disabling off-channel powersave when the scan is suspended, and
> the results were fantastic. The implementation is trivial, packet loss
> is completely eliminated, and the performance drops during scans are
> modest. Therefore I've included a patch which does this rather than
> fixing PS-Poll during scans.
> 
> These changes aren't quite complete, although they currently work very
> well with ath9k and brcmsmac. I'm hoping to get some feedback on the
> changes and answers to some questions before I proceed.
> 
> It turns out that fixing problem #1 (i.e. patch 2) probably isn't
> necessary with the other changes, as no frames should be sent while
> off-channel PS is enabled. Does this still seem like a problem worth
> fixing?

This is incorrect. We actually do need patch 2 for some hardware. I
forgot that when I was testing with BCM43224 I found that PM gets
actively set or cleared based on the device configuration. It's
impossible to enable PS at the AP without informing the driver.

> If so, there's one other change I had considered making. Currently patch
> 2 will require all drivers to have some amount of powersave support for
> off-channel PS to make sure PM is set. Would it make sense to set PM in
> mac80211 when IEEE80211_HW_PS_NULLFUNC_STACK is set?
> 
> Thanks,
> Seth
> 
> 
> Seth Forshee (3):
>   mac80211: Add flushes to ensure off-channel PS is enabled during sw
>     scans
>   mac80211: Convey information about off-channel powersave to drivers
>   mac80211: Disable off-channel powersave when software scans are
>     suspended
> 
>  drivers/net/wireless/ath/ath9k/main.c              |    2 +-
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   16 +++++--
>  drivers/net/wireless/brcm80211/brcmsmac/main.c     |   10 ++++
>  drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    3 ++
>  include/net/mac80211.h                             |   23 ++++++++++
>  net/mac80211/mlme.c                                |   19 +++++---
>  net/mac80211/offchannel.c                          |   48 +++++++++++++++-----
>  net/mac80211/scan.c                                |   20 +++++---
>  net/mac80211/util.c                                |    2 +-
>  9 files changed, 113 insertions(+), 30 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
