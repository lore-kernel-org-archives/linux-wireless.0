Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49339 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757905Ab1ELQUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 12:20:08 -0400
Received: by ewy6 with SMTP id 6so548860ewy.10
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 09:20:05 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] cfg80211/nl80211: add support for scheduled
 scans
From: Luciano Coelho <coelho@ti.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, eliad@wizery.com
In-Reply-To: <20110512150530.GB2171@redhat.com>
References: <1305122977-6740-1-git-send-email-coelho@ti.com>
	 <1305122977-6740-2-git-send-email-coelho@ti.com>
	 <20110512150530.GB2171@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 19:20:01 +0300
Message-ID: <1305217201.12586.949.camel@cumari> (sfid-20110512_182013_081562_1FFA4A2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-12 at 17:05 +0200, Stanislaw Gruszka wrote:
> On Wed, May 11, 2011 at 05:09:35PM +0300, Luciano Coelho wrote:
> > Implement new functionality for scheduled scan offload.  With this feature we
> > can scan automatically at certain intervals.
> > 
> > The idea is that the hardware can perform scan automatically and filter on
> > desired results without waking up the host unnecessarily.
> 
> Can you elaborate more about this?

Some devices require very low power consumption, like mobile phones and
other mobile devices, as you know. ;)

With this feature, we can offload the scanning entirely to the wireless
chip, when we're not connected but looking for APs to connect to, so the
host can keep sleeping and consuming very low power.

Let's say you're looking for an AP with SSID "myap".  You can keep your
device scanning for it, so that it's able to connect automatically when
it shows up without having to keep your device's main CPU awake and
consuming power.  When "myap" shows in the scan results, the main CPU is
awoken and the device can connect to it.

This is also useful when connected and scanning for better access points
to roam to.

This patchset is just the first step, so not much is supported, but I'm
already working on more features that will allow you to choose a list of
SSIDs to scan for, so you can keep scanning for all SSIDs your device
already knows and automatically wake up when one (or more) of them is
(or are) found.


> > Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> > commands to the nl80211 interface.  When results are available they are
> > reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
> > informed when the scheduled scan has stopped with a
> > NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
> > the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.
> > 
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> >  include/linux/nl80211.h |   25 +++++
> >  include/net/cfg80211.h  |   57 +++++++++++
> >  net/wireless/core.c     |   12 ++-
> >  net/wireless/core.h     |    7 ++
> >  net/wireless/nl80211.c  |  250 +++++++++++++++++++++++++++++++++++++++++++++++
> >  net/wireless/nl80211.h  |    4 +
> >  net/wireless/scan.c     |   70 +++++++++++++
> >  7 files changed, 424 insertions(+), 1 deletions(-)
> 
> And explain, why all of this is needed, instead of modify existing scan
> code and reuse existing infrastructure. This sched_scan does not seems to
> be something different than normal hardware scan we have already, or I'm
> wrong.

It is something different.  At first, I was thinking about modifying the
existing scan mechanism.  But it turned out to be too complicated,
because the scheduled scan is a long-term operation and the normal scan
is done for a very short time (and the rest of the stack assumes it will
complete quickly enough as not to interfere with the connection.

-- 
Cheers,
Luca.

