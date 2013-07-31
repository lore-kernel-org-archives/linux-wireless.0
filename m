Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3GaT0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:26:54 -0400
Message-ID: <1375298810.8289.26.camel@jlt4.sipsolutions.net> (sfid-20130731_212657_431139_E48D4E2D)
Subject: Re: [PATCH 3.11] cfg80211: fix P2P GO interface teardown
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 31 Jul 2013 21:26:50 +0200
In-Reply-To: <51F9632B.8090105@broadcom.com>
References: <1375297347-1380-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130731_210237_569724_A4F81D1E) <1375298245.8289.19.camel@jlt4.sipsolutions.net>
	 <51F9632B.8090105@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 21:19 +0200, Arend van Spriel wrote:
> On 07/31/2013 09:17 PM, Johannes Berg wrote:
> > On Wed, 2013-07-31 at 21:02 +0200, Johannes Berg wrote:
> >> From: Johannes Berg <johannes.berg@intel.com>
> >>
> >> When a P2P GO interface goes down, cfg80211 doesn't properly
> >> tear it down, leading to warnings later. Add the GO interface
> >> type to the enumeration to tear it down like AP interfaces.
> >> Otherwise, we leave it pending and mac80211's state can get
> >> very confused, leading to warnings later.
> >
> > Applied
> >
> > (it's obvious and we've tested it for a while)
> 
> We'll see what happens when I test it with brcmfmac :-p

Do you even know how to test it? ;-)
Normally we don't go into this code path because wpa_supplicant will
properly clean up before removing the GO interface - we only saw it with
rfkill and/or doing 'ip link set wlan0-p2p-0 down' or so.

johannes

