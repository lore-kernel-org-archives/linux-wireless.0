Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47242 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1FIH6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 03:58:50 -0400
Date: Thu, 9 Jun 2011 10:58:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	kernel-janitors@vger.kernel.org,
	"open list:B43 WIRELESS DRIVER" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch] b43: check for allocation failures
Message-ID: <20110609075813.GG4069@shale.localdomain> (sfid-20110609_095855_264085_7FA700D0)
References: <20110609070934.GE4069@shale.localdomain>
 <BANLkTim3zJNJfGHcaeY+PQN3wm1m20Qzjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <BANLkTim3zJNJfGHcaeY+PQN3wm1m20Qzjw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 09, 2011 at 09:43:44AM +0200, Rafał Miłecki wrote:
> >        dev = b43_bus_dev_ssb_init(sdev);
> > +       if (!dev)
> > +               return -ENOMEM;
> 
> I'm not sure if you should be aware of the reason here. What about returning
> error code by b43_bus_dev..., reporting it here with b43err and returning
> ENODEV or sth?

The kmalloc failure prints out a whole lot of crap.  Surely we don't
need to add more code in every function for an error that is almost
certainly not going to happen in real life.

If we were really worried about returning the right error code, then
we'd return an ERR_PTR() from the lower levels etc.  I don't think
it's worth it though.

regards,
dan carpenter
