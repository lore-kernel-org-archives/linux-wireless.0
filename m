Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40054 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbXH0PKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 11:10:16 -0400
Message-ID: <46D2E953.6050202@lwfinger.net>
Date: Mon, 27 Aug 2007 10:10:11 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/15] mac80211: remove HW_KEY_IDX_INVALID
References: <20070824122705.549190000@sipsolutions.net>	 <20070824122905.350213000@sipsolutions.net> <46CF327F.4050002@lwfinger.net> <1188212460.7837.1.camel@johannes.berg>
In-Reply-To: <1188212460.7837.1.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-08-24 at 14:33 -0500, Larry Finger wrote:
> 
>> This patch breaks software encryption in my tests - WPA for b43, WPA and WEP for b43legacy. I 
>> haven't looked for the cause yet. That is my next step.
> 
> The patch below appears necessary for b43 when I enable sw crypto, but
> you shouldn't be having such problems in b43legacy since you don't
> support crypto at all; or have you not removed the crypto related code
> from xmit.c?

This fixes b43. It is a bit more difficult to test legacy, but it should be the same.

The code in xmit.c for legacy is essentially the same as for b43. It certainly could be trimmed a 
bit since no keys are ever set - routine set_key returns "no support".

Thanks,

Larry

