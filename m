Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:40385 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752939Ab2GTJGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 05:06:34 -0400
To: =?iso-8859-1?b?R+Fib3I=?= Stefanik <netrolller.3d@gmail.com>
Cc: Bastian Bittorf <bittorf@bluebottle.com>,
	openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	feint@lists.subsignal.org
Message-ID: <1342775190.50091f968c6af@mail.bluebottle.com> (sfid-20120720_110638_227151_7693BC95)
Date: Fri, 20 Jul 2012 10:06:30 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
References: <1342612598.5006a476022c6@mail.bluebottle.com> <CA+XFjiqGXCdMYOnQz95biGYdR65x8dEAZzWnyAoWovEJ1tFQrw@mail.gmail.com>
In-Reply-To: <CA+XFjiqGXCdMYOnQz95biGYdR65x8dEAZzWnyAoWovEJ1tFQrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > 1) why does a band change (can be seen through minstrel) is a
> problem?
> 
> Because IIRC b43 doesn't support anything other than 2.4GHz at
> all.

8-) sorry, i used the wrong term "band":
(fast) changing between b and g rates are the problem.

you can easily reproduce, when you force this by:

iw dev $WIFIDEV set bitrates legacy-2.4 11 12

("use only b-rate 11 and g-rate 12")
So minstrel will happily change/try both, wifi will stop.
The same with:

iw dev $WIFIDEV set bitrates legacy-2.4 5.5 6

bye, Bastian

