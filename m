Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53167 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab1AGX1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 18:27:19 -0500
Date: Sat, 8 Jan 2011 01:26:51 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Aleksandar Milivojevic <alex@milivojevic.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
Message-ID: <20110107232651.GA32712@jm.kir.nu>
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
 <AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com>
 <20110107024432.GC20431@tux>
 <201101071111.17423.helmut.schaa@googlemail.com>
 <AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com>
 <20110107202224.GI21588@tux>
 <20110107221305.6484.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110107221305.6484.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 11:13:05PM +0100, Peter Stuge wrote:
> Luis R. Rodriguez wrote:
> >         bgscan="simple:30:-45:300"
> ..
> > No Linux distributions today uses this other than ChromeOS, but
> > they should all change to use it.
> 
> Maybe wpa_supplicant should be changed to use it by default?

It probably should at some point. I did not want to do it during early
development part of bgscan, but it could now be a reasonable change in
the current development branch (obviously only if the build is
configured to include bgscan). Though, that signal level value is a bit
hardware specific, so -45 may not be ideal for everything. In addition,
the bgscan learn module could be better for many networks.

Though, there is a drawback involved with this, too. In case of a
networks with only a single AP, this would be adding unnecessary
background scanning every 30 or 300 seconds based on signal strength. As
such, enabling the functionality by default is a bit problematic if
there is no mechanism for the user to disable it.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
