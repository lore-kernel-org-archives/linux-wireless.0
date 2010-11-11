Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54337 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0KKPbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 10:31:24 -0500
Message-ID: <4CDC0C44.6070107@ti.com>
Date: Thu, 11 Nov 2010 17:31:16 +0200
From: Gery Kahn <geryk@ti.com>
Reply-To: geryk@ti.com
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/15] Implementation of periodic scan
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

On 11/01/2010 01:52 PM, Luciano Coelho wrote:
> Hi,
>
> This patcheset implements initial support for hardware offloaded periodic
> scan support.  When this is used, the hardware is able to perform scans
> automatically at certain intervals without waking up the host, which can
> potentially save power.
>
> The hardware can also automatically filter results and only report desired
> results to the host.  Currently, this patchset supports only filtering on
> SSIDs.  In the future, support for filtering on RSSI and SNR thresholds can
> be added.  This set doesn't support variable intervals, and the intervals
> need to be configure in the hw driver.
>
> This functionality is based on the periodic scan feature supported by the
> wl1271 firmware.
>
> This is an initial implementation and I'd like to get some comments before
> submitting the final version.
>
> I've split the implementation in many small patches, just to keep it clear
> and due to the zillions of times I've had to task switch while implementing
> this.  I can merge some of them, if that makes things cleaner.
>
> Cheers,
> Luca.
>
>
> Luciano Coelho (15):
>    nl80211: add periodic scan commands
>    cfg80211: add periodic scan request structure
>    nl80211: alloc and free the periodic_req data
>    cfg80211: add periodic scan start and stop ops
>    nl80211: call periodic_start and periodic_stop
>    mac80211: add support for HW periodic scan
>    cfg80211: add periodic scan results handler
>    nl80211: report periodic scan results
>    cfg80211: add channel support to periodic scan
>    nl80211: add channel support to the periodic scan
>    mac80211: pass cfg80211 periodic scan request structure down to the
>      driver
>    cfg80211: add ssid support to periodic scan
>    nl80211: add ssid filtering support to the periodic scan
>    cfg80211: add ie support for periodic scans
>    mac80211: create and pass the ies for each band in periodic scans
>
>   include/linux/nl80211.h     |    8 ++
>   include/net/cfg80211.h      |   44 +++++++
>   include/net/mac80211.h      |   15 +++
>   net/mac80211/cfg.c          |   26 ++++
>   net/mac80211/driver-ops.h   |   27 ++++
>   net/mac80211/driver-trace.h |   63 ++++++++++
>   net/mac80211/ieee80211_i.h  |    8 ++
>   net/mac80211/rx.c           |    4 +-
>   net/mac80211/scan.c         |   82 +++++++++++++
>   net/wireless/core.c         |    1 +
>   net/wireless/core.h         |    3 +
>   net/wireless/nl80211.c      |  278 +++++++++++++++++++++++++++++++++++++++++++
>   net/wireless/nl80211.h      |    4 +
>   net/wireless/scan.c         |   20 +++
>   14 files changed, 582 insertions(+), 1 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The main idea is to have hw offloaded periodic scan while connected or not?
