Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493AbZBYW7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 17:59:42 -0500
To: Alina Friedrichsen <x-alina@gmx.net>
Subject: Re: [PATCH] mac80211: Implement commit in wireless extensions
MIME-Version: 1.0
Date: Wed, 25 Feb 2009 23:59:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090225224428.289250@gmx.net> (sfid-20090225_234444_766012_F3C31EA5)
References: <20090225215631.289250@gmx.net> (sfid-20090225_225703_350502_23B11EFA) <d38edefd935f0aa5c8cca9aee1cf1d7b@localhost> <20090225224428.289250@gmx.net> (sfid-20090225_234444_766012_F3C31EA5)
Message-ID: <78c09d68a4bd733a5bdd0e30200f621d@localhost>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 25 Feb 2009 23:44:28 +0100, "Alina Friedrichsen" <x-alina@gmx.net>
wrote:

>> No, you won't. nl80211 shall not require such hacks.
> 
> I personally think something like a "reload button" could be useful for a
> wireless interface.

For nl80211 you'll just have to disassoc and assoc again or so. For wext
you can, currently, always set the bssid to the current one, I think, or
quickly to any and then the same, or so...

Besides, commit shouldn't be doing anything unless you have outstanding
changes, which we never do, so your patch isn't even correct afaict.

> The wext code can removed when the other wext code is removed and it is
not
> much code.

I don't see a good reason to add code just to kill it again. Please just
leave wext alone.

johannes
