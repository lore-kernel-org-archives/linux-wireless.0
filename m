Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:46764 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751851AbXLWKV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 05:21:29 -0500
Date: Sun, 23 Dec 2007 11:18:06 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 7/7] mac80211: fix sta_info locking
Message-ID: <20071223111806.663f3f4e@morte> (sfid-20071223_102132_485118_E4482322)
In-Reply-To: <1198395536.6630.13.camel@johannes.berg>
References: <20071223033633.710907923@polimi.it>
	<20071223050844.4e6b8c13@morte>
	<1198395536.6630.13.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 23 Dec 2007 08:38:56 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> > EIP at delay_tsc+0x22/0x50
> > [couldn't read the EBX and such, but I guess you won't care]
> 
> It'd be good to know actually, along with disassembly.
> 
> > So I guessed that locking was lacking somewhere. The following patch fixes
> > the issue for me, but I'm not sure at all that it's the right fix. Thanks.
> 
> Definitely not. If you look at the code in question, it has nothing at
> all that needs locking. It's not accessing any shared structures at all.

I now removed the lock, rebuilt my quilt tree, rebuilt mac80211 and I can't
reproduce it. I think that could have been my fault, I should have did
something wrong such as calling sta_info_put() twice or somesuch. Sorry for
the noise. Will poke you again if I happen to reproduce this.


--
Ciao
Stefano
