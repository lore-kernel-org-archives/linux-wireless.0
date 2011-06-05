Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:12225 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab1FEL3P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 07:29:15 -0400
Date: Sun, 5 Jun 2011 13:30:19 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH wireless-2.6 v2] rt2x00: fix rmmod crash
Message-ID: <20110605113019.GA2397@localhost.localdomain> (sfid-20110605_132918_556897_14E460D5)
References: <20110604144854.GA4865@localhost.localdomain>
 <20110604172940.GA10984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110604172940.GA10984@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 04, 2011 at 07:29:40PM +0200, Stanislaw Gruszka wrote:
> On Sat, Jun 04, 2011 at 04:48:54PM +0200, Stanislaw Gruszka wrote:
> > Avoid queue and run autowakeup_work when device is not present anymore.
> 
> This patch fix a problem with autowakeup_work, but seems there is still
> possible to use ->workqueue after free. This time with rxdone_work. I
> have these memory corruptions when removing/loading rt73usb module in a
> loop. Not observable with my previous patch.
Nope, I can reproduce this bug with my previous patch, so this one seems
to be not related with using ->workqueue after free.

Stanislaw
