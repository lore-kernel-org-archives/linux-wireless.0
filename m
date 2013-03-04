Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3CDPek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:34:40 -0500
Message-ID: <1362411276.21028.24.camel@jlt4.sipsolutions.net> (sfid-20130304_163444_035584_990CF11A)
Subject: Re: [PATCH] mac80211: defer tailroom counter manipulation when
 roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: yogeshp@marvell.com
Date: Mon, 04 Mar 2013 16:34:36 +0100
In-Reply-To: <1362089950-12142-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_231919_069651_BE886B2B)
References: <1362089950-12142-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130228_231919_069651_BE886B2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 23:19 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> During roaming, the crypto_tx_tailroom_needed_cnt counter
> will often take values 2,1,0,1,2 because first keys are
> removed and then new keys are added. This is inefficient
> because during the 0->1 transition, synchronize_net must
> be called to avoid packet races, although typically no
> packets would be flowing during that time.

[...]

applied.

johannes

