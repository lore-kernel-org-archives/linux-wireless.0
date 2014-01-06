Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAFOJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 09:09:30 -0500
Message-ID: <1389017367.5891.13.camel@jlt4.sipsolutions.net> (sfid-20140106_150946_523453_B71385B4)
Subject: Re: BUG: build fail due to dependency issue (LIB80211_CRYPT_*
 failed to depend on LIB80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 15:09:27 +0100
In-Reply-To: <20140106140103.GA24241@rhlx01.hs-esslingen.de> (sfid-20140106_150647_318044_741BFBBB)
References: <20140106140103.GA24241@rhlx01.hs-esslingen.de>
	 (sfid-20140106_150647_318044_741BFBBB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 15:01 +0100, Andreas Mohr wrote:

> config LIB80211
>         tristate

> config LIB80211_CRYPT_WEP
>         tristate
> 
> config LIB80211_CRYPT_CCMP
>         tristate
> 
> config LIB80211_CRYPT_TKIP
>         tristate

>     make menuconfig
> showed these three crypt options rather very prominently,

Well, then your 'make menuconfig' is somehow broken - on mainline
options that have no prompt are not shown, and indeed 'make menuconfig'
on the current mainline kernel confirms that those options are not
possible to select manually.

johannes


