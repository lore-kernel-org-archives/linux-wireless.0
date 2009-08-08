Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58807 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZHHIt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 04:49:28 -0400
Received: by bwz19 with SMTP id 19so1825452bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 01:49:27 -0700 (PDT)
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v4] cfg80211: validate channel settings across interfaces
References: <1249649261.4215.7.camel@johannes.local>
	<1249649433.7194.0.camel@johannes.local>
	<1249652951.7194.2.camel@johannes.local>
	<1249658555.7194.8.camel@johannes.local>
	<1249712383.30019.5561.camel@rc-desk>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 08 Aug 2009 11:49:25 +0300
In-Reply-To: <1249712383.30019.5561.camel@rc-desk> (reinette chatre's message of "Fri\, 07 Aug 2009 23\:19\:43 -0700")
Message-ID: <874osin10q.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> Hi Johannes,

Hi,

> This patch is now in wireless-testing and it is causing a problem for
> me. This was determined using bisect.
>
> I am able to bring the interface up and scan, but when I try to
> associate I get a hang.
>
> For example, when I run:
> $ iwconfig wlan0 channel <ch> essid <essid>
>
> then the command prompt never returns and system becomes progressively
> unresponsive. The logs do not contain any details of the problem.

I see the same problem with my iwl3945. I do 'sudo ifup wlan0' (which
starts wpa_supplicant), command prompt is printed once and then laptop
just hangs. 

Reverting this commit fixes the issue:

commit e66cda2a15bede6fc3fa74482337a00ba768983a
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Fri Aug 7 17:22:35 2009 +0200

    cfg80211: validate channel settings across interfaces


-- 
Kalle Valo
