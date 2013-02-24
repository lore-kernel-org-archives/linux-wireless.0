Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab3BXR2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 12:28:11 -0500
Message-ID: <1361726886.8129.9.camel@jlt4.sipsolutions.net> (sfid-20130224_182815_723328_D7114D01)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Date: Sun, 24 Feb 2013 18:28:06 +0100
In-Reply-To: <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
	 <1361564916.3420.11.camel@jlt4.sipsolutions.net>
	,<CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com>
	 <A47087626F2942499CF47E79803E771E0431BD3C@SJEXCHMB13.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-23 at 17:47 +0000, Arend Van Spriel wrote:
> On Saturday, February 23, 2013 1:30 AM Adrian Chadd wrote:
> >
> > ... why not tag such traffic with a higher QOS priority and then have
> > the BT coex module snoop thaT?
> >
> 
> In the driver we could inspect each sk_buff and boost priority of any
> BOOTP packets so that it will end up in the AC_VO fifo and have
> hardware coexistence handle it further. I consider that more a
> pragmatic fix, which is not always the worst thing to go for. 

Well, I don't really think that's the best idea. Sniffing the protocol
is clumsy at best.

> However, I would prefer a solution is which user-space, ie. dhcp
> client can control the priority and/or BT coexistence.

It's not just BT coex btw, with multi-channel support it might also be
interesting to not switch channels while DHCP is going on, for example.

johannes

