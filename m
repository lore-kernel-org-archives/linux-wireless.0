Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab1BXOSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 09:18:30 -0500
Subject: Re: IBSS and 802.11i (RSN) with mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: jpo234 <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110224T145652-996@post.gmane.org>
References: <loom.20110224T145652-996@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 15:18:28 +0100
Message-ID: <1298557108.4775.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-24 at 14:01 +0000, jpo234 wrote:

> Can somebody please either point me to some existing documentation on the topic 
> or write a small HOWTO?

1) Check that iw reports that you can do it (I just now committed code
   to iw to report it since you asked, so use git version, which will
   become 0.9.23 at some point in the future)

2) get git version of wpa_supplicant, compile with CONFIG_IBSS_RSN and
   use a config file like this:

ap_scan=2
network={
	ssid="your SSID"
	mode=1
	frequency=2412
	proto=RSN
	key_mgmt=WPA-PSK
	psk="your secret key!! :-)"
}


If you find a good place, maybe you can add it to the wiki?

Note that wpa_supplicant currently doesn't reject the config if the
driver doesn't support it, but it won't work.

If you want to make your driver support it, the easiest way is to
implement something like I did for iwlwifi:

commit 274102a8a2a4a0b67c401b75a96694db76cfc701
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Jan 18 04:44:03 2011 -0800

    iwlwifi: support RSN IBSS


johannes

