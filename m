Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0I1HYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 03:24:35 -0400
Subject: Re: memory leak in scan with 9170?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Chuck Crisler <ccrisler@vgocom.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=Sm_L+G9JXCuHJhzZm255EtHupkQ1YGy3wpuy3@mail.gmail.com>
References: <58E3CFACA7054DC48245C67E9D4AE07B@ChuckPC>
	 <AANLkTim=hHPMS9kUn11BnWDED1DeUVdJmu3u0Ajr3MPa@mail.gmail.com>
	 <F2D55DC7DDE6443EA6E69CBBE698A335@ChuckPC>
	 <AANLkTi=Sm_L+G9JXCuHJhzZm255EtHupkQ1YGy3wpuy3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:24:32 +0200
Message-ID: <1285658672.3885.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 16:01 -0700, Luis R. Rodriguez wrote:
> On Mon, Sep 27, 2010 at 3:40 PM, Chuck Crisler <ccrisler@vgocom.com> wrote:
> > Well, (as usual) I was wrong. It isn't a memory problem. It seems that after
> > some indeterminant time, the USB interface locks up. When we try to take it
> > down (ifconfig wlan0 down) we get a message about outstanding urbs. By
> > powering down the 9170 we can re-set the device and get it to re-associate
> > and resume work. So, the problem is a USB problem. The question is if it is
> > a module problem or a system problem. We are typically seeing this after
> > 50-200 reassociations. If we don't reassociate, it doesn't seem to occur.
> > Does anyone else have experience or insight into this?
> 
> Upgrade.

Won't help. I've seen that issue as recently as 2.6.35 (I think) with
ar9170, and eventually figured I wouldn't bother and started using
carl9170.

johannes

