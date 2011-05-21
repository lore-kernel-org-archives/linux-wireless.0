Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1EUImP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2011 04:42:15 -0400
To: Javier Cardona <javier@cozybit.com>
Subject: Re: netlink reverts
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Sat, 21 May 2011 10:42:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTikjDhdYMssyivgRxAyB5-_FctQbSg@mail.gmail.com>
 (sfid-20110521_020555_443340_BC05C9C9)
References: <1305917869.4640.15.camel@jlt3.sipsolutions.net>
 <1305917949.4640.16.camel@jlt3.sipsolutions.net>
 <BANLkTikjDhdYMssyivgRxAyB5-_FctQbSg@mail.gmail.com>
 (sfid-20110521_020555_443340_BC05C9C9)
Message-ID: <2eafee5b7a180c891df4a9ca53e90d7d@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 20 May 2011 17:05:12 -0700, Javier Cardona wrote:
> Don't shoot me, please, it really _was_ a merge issue.  My patch did
> not insert anything in the middle:
> https://patchwork.kernel.org/patch/752292  and it was sent a day
> before you sent the patch adding WoWLAN support:
> https://patchwork.kernel.org/patch/753772/

Yeah, my mistake, sorry :( I spent half an hour trying to figure out 
why wowlan was just not doing anything and got really confused...

I wonder what we can do to fix it. Reverting it doesn't really help 
anyone either. I have WoWLAN committed in iw and it suddenly fails 
working in mysterious ways because of the added attribute. I suppose you 
have the same problem somewhere with the mesh tools though? Maybe we can 
just move the plink attribute? iw's master branch already has the wowlan 
code ... But I could just as well update nl80211.h in iw I suppose since 
it's all not released anyway, thoughts?

johannes
