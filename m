Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41125 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbbBXUIb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 15:08:31 -0500
Message-ID: <1424808508.2192.38.camel@sipsolutions.net> (sfid-20150224_210835_770679_D762C232)
Subject: Re: [PATCH v5] mac80211: Allow 0 for NL80211_MESHCONF_PLINK_TIMEOUT
 to disable STA expiration
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com
Date: Tue, 24 Feb 2015 21:08:28 +0100
In-Reply-To: <1424785336-3268-1-git-send-email-masashi.honma@gmail.com> (sfid-20150224_144229_413961_1475FA92)
References: <CAFk-A4=OJyzuQ04i=c5F2HpX+n8JK6RSbZrNKGU7M6J8EteH8w@mail.gmail.com>
	 <1424785336-3268-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20150224_144229_413961_1475FA92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-24 at 22:42 +0900, Masashi Honma wrote:
> Both wpa_supplicant and mac80211 has inactivity timer. By default
> wpa_supplicant will be timed out in 5 minutes and mac80211's it is 30 minutes.
> If wpa_supplicant uses more long timer than mac80211, wpa_supplicant will get
> unexpected disconnection by mac80211. This patch adds functionality of disabling
> mac80211 inactivity timer to avoid to prevent wpa_supplicant inactivity timer.
> 
> I have thought setting 0xffffffff to NL80211_MESHCONF_PLINK_TIMEOUT will solve
> this problem without this patch. But the approach does not work on 32 bit
> system. To explain the reason, I will show STA expiration rule in kernel. This
> is the expression.
> 
> (current jiffies) > (frame Rx jiffies + NL80211_MESHCONF_PLINK_TIMEOUT * 250)
> 
> On 32bit system, right side could be over flow and be unexpected small value if
> NL80211_MESHCONF_PLINK_TIMEOUT is sufficiently large. STA expiration occurs by
> this reason. So I made this patch.

Applied, I've reworded and rewrapped the commit log - in the future
please send commit logs with at most 72 characters per line.

johannes

