Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:36628 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbYCaS11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 14:27:27 -0400
Subject: Re: [PATCH] rt2x00: TO_DS filter depends on intf_ap_count
From: Bas Hulsken <bhulsken@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200803311524.53768.IvDoorn@gmail.com>
References: <200803311524.53768.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 20:23:39 +0200
Message-Id: <1206987819.3085.7.camel@Bas> (sfid-20080331_192731_518345_055DF10D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2008-03-31 at 15:24 +0200, Ivo van Doorn wrote:
> The TO_DS filter does not only depend on the FIF_PROMISC_IN_BSS flag
> provided by mac80211, but also on the intf_ap_count count.
> This makes sense, since when Master mode is active, we should all frames
> that are send to the active AP (the device itself).
> 
> This means that when an interface is added we should force the
> packet filter to be updated during the next mac80211 call of
> configure_filter() to make sure the intf_ap_count field is checked.

I can confirm that this solves the problem that causes hostapd (running
on rt2500pci) to fail to receive EAPOL key frames from a client that
tries to connect. So you can scratch this one from your todo list,
Johannes.

many thanks, Ivo and Johannes!

unfortunately I still don't have a working AP, since hostapd crashes
when receiving the EAPOL key from the client. I'm still trying to find
out what exactly happens, I'll post more info in a new thread. I'm
inclined to think that the problem lies on the driver side, since this
used to work at the 31st of January this year, with hostapd-0.6.2, which
is the version I've tested with now.

best regards,
Bas Hulsken

