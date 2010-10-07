Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab0JGUT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 16:19:27 -0400
Subject: Re: 2.6.36-rc7 warning in __cfg80211_auth_remove
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101007151844.GB3183@sig21.net>
References: <20101007151844.GB3183@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 22:19:26 +0200
Message-ID: <1286482766.20974.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 17:18 +0200, Johannes Stezenbach wrote:
> Hi,
> 
> just got the following while testing with rt73usb on
> kernel 2.6.36-rc7 with wpa_supplicant v0.6.10:
> 
> wlan0: authentication with 00:22:b0:xx:xx:xx timed out
> ------------[ cut here ]------------
> WARNING: at net/wireless/mlme.c:284 __cfg80211_auth_remove+0xc3/0xd0 [cfg80211]()

>  [<ffffffffa002d980>] __cfg80211_auth_remove+0xc3/0xd0 [cfg80211]
>  [<ffffffffa002e27c>] cfg80211_send_auth_timeout+0x93/0xaa [cfg80211]
>  [<ffffffffa004c3eb>] ieee80211_probe_auth_done+0x2a/0x97 [mac80211]
>  [<ffffffffa004e551>] ieee80211_work_work+0xecd/0xf3e [mac80211]

Oh *crap*. I thought we'd fixed these :-(

But then I really don't see how it might have happened. Was there
anything in the log before this?

johannes

