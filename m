Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59295 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbbAFMZ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 07:25:56 -0500
Message-ID: <1420547148.1966.27.camel@sipsolutions.net> (sfid-20150106_132559_855218_C251C325)
Subject: Re: [PATCH} mac80211: correction of IFTYPE_AP and IFTYPE_AP_VLAN in
 ieee80211_do_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: wim torfs <wtorfs@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 06 Jan 2015 13:25:48 +0100
In-Reply-To: <54ABD389.8030409@gmail.com> (sfid-20150106_132236_971222_15D2909D)
References: <54ABD389.8030409@gmail.com>
	 (sfid-20150106_132236_971222_15D2909D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-06 at 13:22 +0100, wim torfs wrote:
> While doing a code review, I noticed that in the latest stable version 
> of the kernel (3.18.1) the functionality of IFTYPE_AP and IFTYPE_AP_VLAN 
> is switched in ieee80211_do_stop. In the case of IEEE80211_IFTYPE_AP, 
> the list of devices in sdata->u.ap.vlans are closed, while in the case 
> of IEEE80211_IFTYPE_AP_VLAN the skbs in sdata->bss->ps->bc_buf are 
> freed. I believe this should be the other way around.

Well, you're wrong :)

johannes

