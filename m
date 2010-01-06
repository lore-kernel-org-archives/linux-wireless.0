Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63820 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab0AFFax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 00:30:53 -0500
Received: by ywh6 with SMTP id 6so17165694ywh.4
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 21:30:52 -0800 (PST)
Message-ID: <4B442008.2040207@lwfinger.net>
Date: Tue, 05 Jan 2010 23:30:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local>
In-Reply-To: <1262710858.28653.5.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2010 11:00 AM, Johannes Berg wrote:
> Since I removed the master netdev, we've been
> keeping internal queues only, and even before
--snip--

> Reported-by: Lennert Buytenhek <buytenh@marvell.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: stable@kernel.org [2.6.32]
> ---
> I know it's late, and large, but still would be good to have in .33
> since the issue is fairly serious.

I'm not sure this is ready for prime time. After I installed it, my b43 was
never able to reconnect after any kind of disconnect. The log is uninformative:

===========================================
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
wlan0: direct probe to 00:14:bf:85:49:fa (try 1)
wlan0: direct probe responded
wlan0: authenticate with 00:14:bf:85:49:fa (try 1)
wlan0: authenticated
wlan0: associate with 00:14:bf:85:49:fa (try 1)
wlan0: RX AssocResp from 00:14:bf:85:49:fa (capab=0x411 status=0 aid=1)
wlan0: associated
b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac:
00:14:bf:85:49:fa
b43-phy0 debug: Disabling hardware based encryption for keyidx: 0, mac:
00:14:bf:85:49:fa
wlan0: deauthenticating from 00:14:bf:85:49:fa by local choice (reason=3)
===========================================

Reauthentication fails with a pop-up to reenter the WPA2 secret as I'm using
NetworkManager. I can only reconnect if b43 (and mac80211) are unloaded and
reloaded. I pulled the patch and confirmed that proper behavior is returned.

Larry
