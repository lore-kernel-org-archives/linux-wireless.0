Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2E2GsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 02:48:21 -0400
Message-ID: <1338274104.4342.5.camel@jlt3.sipsolutions.net> (sfid-20120529_084825_256740_BA3A9F56)
Subject: Re: Kernel splats in 3.3.7+, mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 29 May 2012 08:48:24 +0200
In-Reply-To: <4FBD0DB0.5000406@candelatech.com> (sfid-20120523_181757_752991_9056DD24)
References: <4FBD0DB0.5000406@candelatech.com>
	 (sfid-20120523_181757_752991_9056DD24)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-23 at 09:17 -0700, Ben Greear wrote:
> We ran a torture test where we try to associate 130 stations against an AP
> that can only do 128.  The end result is constant resetting of many of the
> virtual station interfaces.
> 
> It ran overnight w/out crashing, but spewed quite a few warnings.
> 
> I will be happy to test patches or attempt fixes if anyone has suggestions
> for what the cause might be....
> 
> 
> ------------[ cut here ]------------
> ADDRCONF(NETDEV_UP): sta128: link is not ready
> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/wireless/mlme.c:310 __cfg80211_auth_remove+0x9b/0xaa [cfg80211]()

This was kinda a known race condition but nobody could ever figure out
what exactly is going on ... the code is gone in 3.4 though :)

johannes

