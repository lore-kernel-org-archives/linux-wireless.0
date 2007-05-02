Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63508 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993293AbXEBO4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 10:56:17 -0400
Message-ID: <4638A68C.3000600@lwfinger.net>
Date: Wed, 02 May 2007 09:56:12 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: dragoran <drago01@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and signal strength reporting
References: <46384D34.9080505@gmail.com>
In-Reply-To: <46384D34.9080505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dragoran wrote:
> Hello,
> while testing iwlwifi (which works fine now btw) I noticed that the 
> signal strenght reporting when using mac80211 is broken:
> iwconfig only show dBm value....
> gnome-netstatus always shows 0%
> networkmanager always shows 100%
> whats going on? does some has any idea?
> is this a known bug or is iwlwifi the culprit?

A little of both. The wireless statistics code in mac80211 has some strange conventions. I worked 
for a while on improving it, but there are multiple opinions regarding the use of terms such as 
"level" and "signal". After a few tries, I dropped that part and made bcm43xx-mac80211 conform to 
the mac80211 conventions. Now there are lines like "Link Quality=77/100  Signal level=-49 dBm  Noise 
level=-73 dBm" in the iwconfig output. These values look reasonable.

Larry
