Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:58695 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab1EIIRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 04:17:19 -0400
Received: by eydd26 with SMTP id d26so1965300eyd.2
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 01:17:16 -0700 (PDT)
Subject: Re: [PATCH 1/3] cfg80211/nl80211: add support for scheduled scans
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1304928720.3475.0.camel@jlt3.sipsolutions.net>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-2-git-send-email-coelho@ti.com>
	 <1304928720.3475.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 11:17:13 +0300
Message-ID: <1304929033.12586.447.camel@cumari> (sfid-20110509_101727_964105_17634CE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 10:12 +0200, Johannes Berg wrote:
> On Thu, 2011-05-05 at 16:00 +0300, Luciano Coelho wrote:
> > Implement new functionality for scheduled scan offload.  With this feature we
> > can scan automatically at certain intervals.
> > 
> > The idea is that the hardware can perform scan automatically and filter on
> > desired results without waking up the host unnecessarily.
> > 
> > Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> > commands to the nl80211 interface.  When results are available they are
> > reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
> > informed when the scheduled scan has stopped with a
> > NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
> > the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.
> 
> Didn't you initially want to differentiate between SCAN_SSIDS and
> SSIDS_FILTER?

Yes, I'll add SSID filtering soon, as separate patches, if that's okay.
For now, the SSIDs that you can pass via nl80211 are used in the
probe_reqs.

We can also filter on RSSI, SNR and/or group results into one event.
This are other features that our firmware supports.  For now I have not
exposed this, but it could also be added to nl80211 in the future.

-- 
Cheers,
Luca.

