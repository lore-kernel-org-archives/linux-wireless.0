Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34646 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LIICm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 03:02:42 -0500
Received: by ghbz2 with SMTP id z2so2286151ghb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 00:02:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323402221-9869-1-git-send-email-mar.kolya@gmail.com>
References: <1323162576.4696.4.camel@jlt3.sipsolutions.net>
	<1323402221-9869-1-git-send-email-mar.kolya@gmail.com>
Date: Fri, 9 Dec 2011 09:02:41 +0100
Message-ID: <CAGXE3d8YkkJiuTyZJ=y4j0b5BhZtm1tjO=QxauR15_b=SewTVQ@mail.gmail.com> (sfid-20111209_090246_672976_3A599D50)
Subject: Re: [PATCH v2] mac80211: split addba retries in time
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 9, 2011 at 4:43 AM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
>  Currently code allows three (HT_AGG_MAX_RETRIES) unanswered addba
> requests. When this limit is reached aggregation is turned off for
> given TID permanently. This doesn't seem right: three requests is
> not that much, some 'blackout' can happen, but effect of it affects
> whole connection indefinitely.
>  This patch increases number of retries to 15. Also, when there have
> been 3 or more retries it splits further retries apart by 15 seconds
> instead of sending them in very short period of time.

This is not 100% related to your patch but would it also make sense to
disallow BA session setup when it was just torn down a second ago?

Helmut
