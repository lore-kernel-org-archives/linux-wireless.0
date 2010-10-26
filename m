Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab0JZJli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 05:41:38 -0400
Subject: Re: Question about starting up an AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Joshua Smith <JoshuaESmith@charter.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
In-Reply-To: <201010261135.31232.helmut.schaa@googlemail.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com>
	 <B3E6C8F9-24E4-4F12-B19C-15A474E5BCFA@charter.net>
	 <201010151146.53640.helmut.schaa@googlemail.com>
	 <201010261135.31232.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 11:41:34 +0200
Message-ID: <1288086094.3761.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-26 at 11:35 +0200, Helmut Schaa wrote:

> > I'll let Ivo decide on this. At least if we really want to wait more then one
> > second for DMA to be ready we should increase the msleep(1) to msleep(10) and
> > keep the maximum number of retries at 100.

> Ivo, do we want to add the excessive waiting (up to one second) for DMA on
> rt2800 as it fixes Joshuas device? At the moment we're waiting 100ms.

I don't usually chime in on other drivers but is there any reason not
to? Properly functioning devices obviously reply within 100ms, so they
wouldn't change behaviour, hopefully broken ones that _never_ work are
rare, and the remaining ones like Joshua's would be fixed ...

johannes

