Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2LCVPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 16:15:12 -0500
Message-ID: <1354569336.9717.21.camel@jlt4.sipsolutions.net> (sfid-20121203_221521_941836_15B2CCB0)
Subject: brcmsmac HT40 regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Dec 2012 22:15:36 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,

While I was looking at uses of IEEE80211_CHAN_NO_HT40 I saw brcmsmac and
found that it uses that on channels 8 and 9 which doesn't really make
sense, here in Europe HT40 can be used on channel 9 where the entire 40
MHz channel will then extend all the way to channel 13. We just recently
fixed a bug in the regulatory code to allow this.

Is this intentional in your code? If not I'd suggest to remove all the
IEEE80211_CHAN_NO_HT40* flags in 2.4 GHz since the common regulatory
code will enforce that all secondary channels must exist & be allowed
anyway.

On 5 GHz you might also consider removing them since they are spec
restrictions, not regulatory restrictions.

Unless of course this matches some firmware checking, in which case
you'll want to keep it so the firmware isn't unhappy when somebody
connects to such APs :)

johannes

