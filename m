Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0H0M47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 08:56:59 -0400
Subject: Re: [PATCH] mac80211: fix offchannel queue stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Luis Rodriguez <mcgrof@gmail.com>
In-Reply-To: <20100827123054.GB3780@vasanth-laptop>
References: <1282909528.4377.8.camel@jlt3.sipsolutions.net>
	 <20100827123054.GB3780@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 14:56:56 +0200
Message-ID: <1282913816.4377.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-27 at 18:00 +0530, Vasanthakumar Thiagarajan wrote:

> > The problem, as I understand it, is that when
> > we go offchannel while the driver has a queue
> > stopped, the driver will likely start draining
> > the queue and then enable it while offchannel.
> > This in turn will enable the interface queue,
> > and that leads to transmitting data frames on
> > the wrong channel.

> thanks for fixing, It was me only. Somehow I forgot this.

Did I understand the issue correctly then?

johannes

