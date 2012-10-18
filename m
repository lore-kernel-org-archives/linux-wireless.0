Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:54523 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751654Ab2JRSrr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 14:47:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Thu, 18 Oct 2012 11:44:47 -0700
Subject: RE: [PATCH v6 3/6] cfg80211: add scan flag to indicate its priority
Message-ID: <477F20668A386D41ADCC57781B1F7043083B80E682@SC-VEXCH1.marvell.com> (sfid-20121018_204750_916196_A97D5BBB)
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
 <1350542071-26498-4-git-send-email-bzhao@marvell.com>
 <507FAF19.6030500@broadcom.com>
In-Reply-To: <507FAF19.6030500@broadcom.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> > From: Sam Leffler <sleffler@chromium.org>
> >
> > Add NL80211_SCAN_FLAG_LOW_PRIORITY flag support. It tells drivers
> > that this is a low priority scan request, so that they can take
> > necessary action.
> > Drivers need to advertise low priority scan capability during
> > registration.
> 
> I missed the previous versions of this patch series, but what 'necessary
> action' is needed for a low priority scan request. Patch #6 gives a clue
> so my assumption is that a low prio scan will be *aborted* when
> associated and data traffic is available. Is that correct? Could it also

It's up to the driver to decide and implement the 'low priority scan' feature.
The driver can defer or abort the low priority scan request depending on various conditions.
For example, when heavy data traffic is on going you may want to abort the scan.

> *suspend* the low prio scan? Just curious whether there is an explicit
> behavioral requirement here. I probably should dig in previous versions

If you support this feature, driver should advertise LOW_PRIORITY_SCAN bit in wiphy->features.

> of this patch series. Too bad the cover letter of this one does not have
> full change log.

v6: 
    move enum nl80211_scan_flags placeholder from 1/6 to 3/6,
    and merge with new flag in 3/6 to avoid breaking build in 1/6.
    This makes patch series friendly to bisect. (Fengguang Wu)

    Other 4 patches are not changed.

v5 (Johannes Berg):
I made two small changes (and inserted a patch in the middle to allow
for those changes).

One change is that I inverted the polarity of the "flush" feature flag
so that userspace can check if it's supported without having to worry
about the kernel version.

The other change is a fix in mac80211 to only set the "low prio" support
flag if *software* scan is used, not unconditionally.

Please make sure those still work for you, I haven't tested it.

It might be nice to also have a low-prio/flush flags patch for iw as
well if you find the time.

v4 (Amitkumar Karwar):
1) "wiphy->features" is used instead of "wiphy->flags" to advertise
   scan features. (Johannes Berg)
2) Added support to disable scan flush if driver requests for it
   explicitly. (Johannes Berg)
3) Used msecs_to_jiffies() to convert time interval into jiffies
   for comparison (Johannes Berg)

v3 (Amitkumar Karwar):
1/5: Remove unnecessary "enum cfg80211_scan_flags" (Johannes Berg)
     Add missing check for "nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS"
     (Johannes Berg)
2/5: Add WIPHY_FLAG_LOW_PRIORITY_SCAN flag so that device can advertise
     low priority scan capability. An error will be returned to the
     application if device doesn't support this feature.
     Flush scan table feature is by default enabled.
     (Johannes Berg)
3/5, 4/5: Rearrange the code to avoid static forward declarations.
     (Johannes Berg)
5/5: Removed use of unlikely() macro (Johannes Berg)
     Advertise low priority scan capability (Johannes Berg)

v2 (Amitkumar Karwar):
1) TX_ABORT flag is renamed to LOW_PRIORITY to have more generic
approach. Let the drivers decide behaviour for background scan.
2) An extra parameter is added to __cfg80211_bss_expire() to
avoid race condition pointed by Johannes.

v1 (Sam Leffler):
These add per-scan request controls for optional behaviours we've found
useful (they've been in Chrome OS for a long time).  A patch for iw will
follow separately and the mods for wpa_supplicant are in our repo and
I'll push them to Jouni if these are accepted.

Thanks,
Bing

> 
> Gr. AvS

