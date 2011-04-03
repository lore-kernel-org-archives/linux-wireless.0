Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab1DCIhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2011 04:37:11 -0400
Subject: Re: [PATCH 1/2] mwifiex: return success in set_default_key for
 WPA/WPA2
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1301817775.3984.3.camel@jlt3.sipsolutions.net>
References: <1301708207-16265-1-git-send-email-bzhao@marvell.com>
	 <1301817775.3984.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Apr 2011 10:37:06 +0200
Message-ID: <1301819826.3984.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-03 at 10:02 +0200, Johannes Berg wrote:
> On Fri, 2011-04-01 at 18:36 -0700, Bing Zhao wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> > 
> > When testing wpa_supplicant with 'nl80211' driver to connect
> > to an AP with WPA/WPA2 security, we notice the followings:
> > 
> > 1) add_key is called firstly with the key from cfg80211
> > 2) set_defaut_key is called next
> > 
> > set_default_key() is specific to WEP keys and should not be
> > called in case of WPA/WPA2 security. The set_default_key()
> > won't be called if wpa_supplicant uses "-Dwext" option,
> > but it's been called if "-Dnl80211" option is specified.
> > 
> > We can fix this issue by adding a check to return from
> > set_default_key() if WEP key is not configured.
> 
> Hmmm. Yeah this seems like it shouldn't be happening, but maybe checking
> should be in cfg80211 and it should reject the supplicant's call?

Ok Jouni and I just discussed this briefly, and it looks like there is
indeed a special case where the GTK is also set as the default TX key:
this case is when the station requested "no pairwise" or when the AP did
the same thing in the configuration.

Is it possible that this just happens to be the case in your tests? It
looks like that would be rather strange, but that's a corner case where
the supplicant would possibly set the GTK as the default key.

In any case, this patch seems wrong in that you should never return
success if the operation actually failed.

johannes

