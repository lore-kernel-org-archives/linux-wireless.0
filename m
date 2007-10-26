Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:33410 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXJZUPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:15:24 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out0.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVRW-0000di-Il
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:06:06 +0200
Message-ID: <472248AC.7080201@tiscali.nl> (sfid-20071026_211525_934180_FBE8D1A0)
Date: Fri, 26 Oct 2007 22:06:04 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 0/8] fix 'and' typo's
References: <4722453E.2090801@tiscali.nl>
In-Reply-To: <4722453E.2090801@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roel Kluin wrote:
> A few patches with changes to net code. I have sent these to the lkml
> previously, but they were not yet merged. I am fairly new to kernel 
> programming, so it is possible that I make some mistakes. I'll explain my
> rationale, please nack if incorrect, an additional bit of explanation is
> appreciated even more.
> 
> The condition '!x & y,' does make little sense: the '!' has a higher
> priority than '&'. It behaves therefore like '!x && y'. In the case 
> bitanding flags, however, '!(x & y)' appears to be desired.
> 
> Warning: the change of '!x & y,' to '!(x & y)' may change behavior. if
> not desired, I propose changing this to '!x && y', to make it explicitly
> clear.
> 
> These '&' typo's can be spotted with:
> a="A-Za-z0-9_"
> git-grep "\![^$a()]*[$a]\+\([$a.]*\|->\)*\(\[[$a.]*\]\)\?[ \W]*&[^&]\+"

It was suggested to split this up, so here goes.
