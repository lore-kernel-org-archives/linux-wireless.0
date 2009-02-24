Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50759 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbZBXJBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 04:01:52 -0500
Date: Tue, 24 Feb 2009 11:01:37 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
Message-ID: <20090224090137.GB10851@jm.kir.nu> (sfid-20090224_100155_328970_74E925EF)
References: <20090223163626.20939.4879.stgit@tikku> <20090223163738.20939.25890.stgit@tikku> <1235442058.4455.71.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235442058.4455.71.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 06:20:58PM -0800, Johannes Berg wrote:

> We used to go through a probe request cycle once to make sure, but I'm
> not sure there's a point in that. Just pointing out the change here.

Having seen some hardware implementations of Beacon miss getting out of
sync with the AP timing and causing way too frequent disconnections, I
would think that there may well be good reasons to check in software
that report was indeed correct, e.g., by sending the probe request
before giving up on the AP.

> The code looks pretty good, but this will lead to an interesting
> situation where "iwlist wlan1 scan last" ("iw dev wlan1 scan dump") will
> not show _any_ BSS, which will probably trip up NM; this happens because
> the BSS will not be updated and expire after 10 seconds. I think we need
> a way to "hold on" to the BSS.

Dropping the BSS is not good.. The scan results should always include
the current BSS so that information from it is available for things like
4-way handshake (WPA/RSN IE is needed from Beacon/ProbeResp).

-- 
Jouni Malinen                                            PGP id EFC895FA
