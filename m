Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57848 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1AWJlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 04:41:09 -0500
Received: by ewy5 with SMTP id 5so1507252ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 01:41:08 -0800 (PST)
Date: Sun, 23 Jan 2011 12:41:01 +0300
From: Paul Fertser <fercerpav@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Thomas d'Otreppe" <tdotreppe@gmail.com>,
	Richard Farina <sidhayn@gmail.com>
Subject: Re: [RFC][PATCH] cfg80211: report monitor interface channel via
	wext when possible
Message-ID: <20110123094101.GB25136@home.lan>
References: <1295655098-17534-1-git-send-email-fercerpav@gmail.com> <1295773599.3639.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295773599.3639.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 23, 2011 at 10:06:39AM +0100, Johannes Berg wrote:
> On Sat, 2011-01-22 at 03:11 +0300, Paul Fertser wrote:
> > This makes it possible to retrieve the channel for the monitor interface
> > in cases when it can be determined unambigously. Tested with ath5k.
> 
> NAK.
> 
> http://article.gmane.org/gmane.linux.kernel.wireless.general/61860

If i understood your correctly, "somehow query oper_channel" means one
needs to extend cfg80211 API a little and add necessary code to
mac80211. And the result would be higher-level API depending on
mac80211 implementation details (which are going to be soon changed
anyway after introduction of the real multi-channel feature).

What i propose should work with any cfg80211 driver where
set_channel() is properly implemented for monitor interfaces, and
mac80211 is certainly one of them. When in the first place one
requests set_channel() for a monitor that's not compatible with the
current configuration, it'll return an error, and so wdev->channel
would not be set at all. If it succeeded and then someone later wants
to verify the monitor channel, set_channel() is still the best
opportunity because it is this function that has all the checks to
verify the channel is still valid.

To sum up, i see no drawbacks in using set_channel() for that, it
doesn't add any implicit requirements, doesn't change semantics,
non-intrusive, doesn't break anything and works correctly every time.

-- 
Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
mailto:fercerpav@gmail.com
