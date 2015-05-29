Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37817 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbbE2LKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:10:14 -0400
Message-ID: <1432897812.2104.7.camel@sipsolutions.net> (sfid-20150529_131020_038811_62DFC2E4)
Subject: Re: [PATCH v2 2/2] mac80211: guard against invalid ptr deref
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 May 2015 13:10:12 +0200
In-Reply-To: <1432285043-8878-2-git-send-email-michal.kazior@tieto.com> (sfid-20150522_105743_928307_E51BD04A)
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	 <1432285043-8878-1-git-send-email-michal.kazior@tieto.com>
	 <1432285043-8878-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150522_105743_928307_E51BD04A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-22 at 10:57 +0200, Michal Kazior wrote:
> It was possible for mac80211 to be coerced into an
> unexpected flow causing sdata union to become
> corrupted. Station pointer was put into
> sdata->u.vlan.sta memory location while it was
> really master AP's sdata->u.ap.next_beacon. This
> led to station entry being later freed as
> next_beacon before __sta_info_flush() in
> ieee80211_stop_ap() and a subsequent invalid
> pointer dereference crash.
> 
> The problem was that ieee80211_ptr->use_4addr
> wasn't cleared on interface type changes.
> 
> This could be reproduced with the following steps:
> 
>  # host A and host B have just booted; no
>  # wpa_s/hostapd running; all vifs are down
>  host A> iw wlan0 set type station
>  host A> iw wlan0 set 4addr on
>  host A> printf 'interface=wlan0\nssid=4addrcrash\nchannel=1\nwds_sta=1' > /tmp/hconf
>  host A> hostapd -B /tmp/conf
>  host B> iw wlan0 set 4addr on
>  host B> ifconfig wlan0 up
>  host B> iw wlan0 connect -w hostAssid
>  host A> pkill hostapd
>  # host A crashed:
> 
>  [  127.928192] BUG: unable to handle kernel NULL pointer dereference at 00000000000006c8
>  [  127.929014] IP: [<ffffffff816f4f32>] __sta_info_flush+0xac/0x158
>  ...
>  [  127.934578]  [<ffffffff8170789e>] ieee80211_stop_ap+0x139/0x26c
>  [  127.934578]  [<ffffffff8100498f>] ? dump_trace+0x279/0x28a
>  [  127.934578]  [<ffffffff816dc661>] __cfg80211_stop_ap+0x84/0x191
>  [  127.934578]  [<ffffffff816dc7ad>] cfg80211_stop_ap+0x3f/0x58
>  [  127.934578]  [<ffffffff816c5ad6>] nl80211_stop_ap+0x1b/0x1d
>  [  127.934578]  [<ffffffff815e53f8>] genl_family_rcv_msg+0x259/0x2b5
> 
> Even though this can and should be fixed in
> cfg80211 it still makes sense to add a sanity
> check to mac80211 to prevent future problems.

I'm a bit undecided about this. Is this really the only place that
assumes use_4addr implies that it's a VLAN, in a context like this?

johannes

