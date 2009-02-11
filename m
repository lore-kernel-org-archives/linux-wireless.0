Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58732 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZBKInU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 03:43:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 00:43:20 -0800
Date: Wed, 11 Feb 2009 14:13:10 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Free current bss information in few places
	where we don't need it any more
Message-ID: <20090211084310.GE6589@vasanth-laptop> (sfid-20090211_094331_066317_09FE696F)
References: <1233752328-6918-1-git-send-email-vasanth@atheros.com> <1234258903.18748.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234258903.18748.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 10, 2009 at 03:11:43PM +0530, Johannes Berg wrote:
> Just a question: was this needed for correctness somehow, or just to
> purge the BSS list a little?

This actually stops choosing the AP to which we were connected and
received deauth(reason=ap moving out)/probe/auth/assoc timeout. By
removing the bss information, scanning is triggered before selecting 
right AP to join upon connection request by setting ssid.

Vasanth

