Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2KFTUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 14:20:00 -0500
Message-ID: <1352229634.8814.8.camel@jlt4.sipsolutions.net> (sfid-20121106_202014_464212_97421BEF)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: eddie@ehuk.net
Cc: stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 06 Nov 2012 20:20:34 +0100
In-Reply-To: <50995E25.6080601@ehuk.net>
References: <20121031173811.GA12970@kroah.com> <509575F4.5020109@ehuk.net>
	    <20121105081757.GA3730@kroah.com> <50979D38.6010002@ehuk.net>
	    (sfid-20121105_121423_464154_72561532) <1352116868.9466.2.camel@jlt4.sipsolutions.net>
	   <509838F4.4010301@ehuk.net>
	  <1352188621.9440.4.camel@jlt4.sipsolutions.net>
	 <50992E0E.3040606@ehuk.net>
	 <1352217244.9440.16.camel@jlt4.sipsolutions.net>
	 <50995E25.6080601@ehuk.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-06 at 18:59 +0000, Eddie Chapman wrote:
> On 06/11/12 15:54, Johannes Berg wrote:
> > The problem here is that some devices (notably iwlwifi) will not allow
> > (by firmware) to connect to such an AP as HT40- if that is not allowed.
> > So I prevented it generally, but we can make it device dependent. I
> > don't like it much, but I suppose we can do it. Try this patch:
> >
> > http://p.sipsolutions.net/0129f39c7d882289.txt
> >
> > It will still prohibit this configuration when the driver said it's not
> > allowed, but will allow it when there were other reasons to not allow
> > it.
> 
> Just to report, with the patch under discussion re-applied 
> (3a40414f826a8f1096d9b94c4a53ef91b25ba28d), plus the patch at your link 
> above, my throughput is back to normal again.

Ok, thanks.

> So I guess the above patch resolves the issue (on the face of it) for 
> me, but whether it is a suitable solution I've no idea.

Right, we're still looking at that. It seems that it's not an ideal
solution, the regulatory change I proposed is probably better. Could you
check if it helps as well? That is, remove this patch, and apply this
one: http://p.sipsolutions.net/8877cbe3440d94b1.txt

johannes

