Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaA3IKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 03:10:51 -0500
Message-ID: <1391069448.4134.0.camel@jlt4.sipsolutions.net> (sfid-20140130_091054_825718_E5F708FB)
Subject: Re: [PATCH] mac80211: Fix IBSS join
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	linux-wireless@vger.kernel.org
Date: Thu, 30 Jan 2014 09:10:48 +0100
In-Reply-To: <21226.184.85287.849137@gargle.gargle.HOWL>
References: <1390874095-28008-1-git-send-email-sujith@msujith.org>
	 <1390997315.4143.4.camel@jlt4.sipsolutions.net>
	 <201401291319.03802.sw@simonwunderlich.de>
	 <21226.184.85287.849137@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 13:05 +0530, Sujith Manoharan wrote:
> Simon Wunderlich wrote:
> > In the CSA case the BSS is still used, we modify the BSS entry in 
> > ieee80211_ibss_finish_csa()  (which is not really clean, but done by all the 
> > current CSA code).
> > 
> > Since the BSS is changed and the node continues to beacon, I think that's ok 
> > to do it like Sujith proposed.
> 
> I think Johannes is right. If a station receives a CSA and is unable to switch
> to the new channel, it leaves the IBSS network. In this case we don't need to
> keep the BSS entry around, since we proceed to scan again.

Hah, I wasn't paying attention ... yeah I think you're right, it's the
*failure* case, in which we shouldn't care any more. Simon, you were
thinking of the successful case, but that doesn't call disconnect ...

johannes

