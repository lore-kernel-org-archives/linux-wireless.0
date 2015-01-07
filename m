Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36141 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbbAGNkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:40:03 -0500
Message-ID: <1420637996.3407.11.camel@sipsolutions.net> (sfid-20150107_144008_895608_58CB7230)
Subject: Re: [PATCH] mac80211: Re-fix accounting of the tailroom-needed
 counter
From: Johannes Berg <johannes@sipsolutions.net>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <idox.yariv@intel.com>,
	Christopher Chavez <chrischavez@gmx.us>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Solomon Peachy <pizza@shaftnet.org>
Date: Wed, 07 Jan 2015 14:39:56 +0100
In-Reply-To: <1420551542-21981-1-git-send-email-ido@wizery.com> (sfid-20150106_143921_495850_B1F9FB69)
References: <54AACA29.3060709@lwfinger.net>
	 <1420551542-21981-1-git-send-email-ido@wizery.com>
	 (sfid-20150106_143921_495850_B1F9FB69)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-06 at 08:39 -0500, Ido Yariv wrote:
> When hw acceleration is enabled, the GENERATE_IV or PUT_IV_SPACE flags
> only require headroom space. Therefore, the tailroom-needed counter can
> safely be decremented for most drivers.
> 
> The older incarnation of this patch (ca34e3b5) assumed that the above
> holds true for all drivers. As reported by Christopher Chavez and
> researched by Christian Lamparter and Larry Finger, this isn't a valid
> assumption for p54 and cw1200.
> 
> Drivers that still require tailroom for ICV/MIC even when HW encryption
> is enabled can use IEEE80211_KEY_FLAG_RESERVE_TAILROOM to indicate it.

Applied. Let's hope it sticks this time :)

johannes

