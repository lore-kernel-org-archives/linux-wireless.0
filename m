Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:23724 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZAVICt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 03:02:49 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: porting open source mac to linux 2.6.13.0
Date: Thu, 22 Jan 2009 09:02:14 +0100
Cc: Bharat Bhushan <bharat.b.bhushan@gmail.com>
References: <d9360e520901212124j7bf196c3sf4e29d8fd3650f9b@mail.gmail.com>
In-Reply-To: <d9360e520901212124j7bf196c3sf4e29d8fd3650f9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901220902.14160.hs4233@mail.mn-solutions.de> (sfid-20090122_090257_864154_A12C2D4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> hi all,
>          Is there any possible way to port open source mac
> stck on linux kernel 2.6.13.0 . Problem is, i am using a
> embedded platform which is supporting only 2.6.13. 0 and now
> assigned job is to make it working for open source mac stack
> without porting any other changes of linux kernel .
>
> Any help is much appreciated.

I think you won't get much help (at least not free help), because 
the managers of this embedded product made same grave design 
decision errors some years ago.

They developed (or let develop) against what was current at that 
time, 2.6.13.0. But they never tried to get their changes 
upstream, into the main kernel. So the put themselves onto an 
island. Hey, they even didn't update their kernel to get the 
security updates of 2.6.13.5. Looks like a "fire-and-forget" 
approach, which might in some cases save money, but often 
backfires.

If their work would have been included upstream, it would had got

a) a cost-free peer-review at the time of submission
   (good for code quality)
b) cost-free updates to newer kernel versions, at least in the
   area of infrastructure changes and compile-tests. This might
   not guarantee that it still runs, but it's better than doing
   it all by yourself :-)

It would then be trivial to use a modern kernel on this embedded 
target, with mac80211 on this device. Now it's almost 
impossible, because so much of the in-kernel infrastructure has 
changed in the meantime, see 
http://lwn.net/Articles/2.6-kernel-api/
