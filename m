Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3E0JB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:01:26 -0400
Message-ID: <1369645281.8229.14.camel@jlt4.sipsolutions.net> (sfid-20130527_110130_123918_81F51378)
Subject: Re: [RFC 2/2] cfg80211: separate internal SME implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kondratiev, Vladimir" <vkondrat@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	qca_vkondrat <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 27 May 2013 11:01:21 +0200
In-Reply-To: <A5CA08B46412E243958C77F3825F439519553850@NASANEXD02E.na.qualcomm.com>
References: <1368800743-29877-1-git-send-email-johannes@sipsolutions.net>
	 <1368800743-29877-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130517_162600_437051_A11D5D07),<1369433975.13623.19.camel@johannes>
	 <A5CA08B46412E243958C77F3825F439519553850@NASANEXD02E.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-05-25 at 15:33 +0000, Kondratiev, Vladimir wrote:

> I prepared the patch, need few days to test it and I'll submit.

Thanks.

> I have conceptual question regarding wdev private data.
> Currently, drivers end up duplicating wdev's data internally. I'd say it is better to track, for example,
> SME connection state once. Maybe, it is worth to provide functions to access wdev's data?

Well, with my changes cfg80211 is no longer tracking the state at all,
unless you're using the cfg80211 SME, which your driver can't even use
since it doesn't implement auth/assoc but connect(). So in that sense,
there's no duplication.

I suppose you could argue that cfg80211 could track whether it was
already connected or not and call cfg80211_connect_result() is you
disconnect while never even connected, and it actually does still track
this (wdev->current_bss). OTOH, you could also argue that a firmware API
that requires tracking this on the host is broken ;-)

johannes

