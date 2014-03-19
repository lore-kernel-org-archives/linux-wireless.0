Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSOBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:01:52 -0400
Message-ID: <1395237709.4142.11.camel@jlt4.sipsolutions.net> (sfid-20140319_150156_178511_49185AF8)
Subject: Re: [PATCH] mac80211: Release sched_scan_sdata when stopping sched
 scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>
Date: Wed, 19 Mar 2014 15:01:49 +0100
In-Reply-To: <1394959794-19215-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1394959794-19215-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-16 at 10:49 +0200, Emmanuel Grumbach wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> 
> Assuming sched_scan_stop operation is synchronous the driver may not
> necessary call ieee80211_sched_scan_stopped_work. Since this work is
> the only place where sched_scan_sdata is released we can possibly run
> into situation when it is never released. Fix this by releasing it
> just after calling drv_sched_scan_stop.

Applied.

johannes

