Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:20886 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2LLQT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 11:19:56 -0500
Date: Wed, 12 Dec 2012 17:19:40 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: =?iso-8859-1?Q?=22David_M=FCller_=28ELSOFT_AG=29=22?=
	<d.mueller@elsoft.ch>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2800: refactor RFCSR initialization
Message-ID: <20121212161940.GA17625@localhost.localdomain> (sfid-20121212_171959_289075_DDE9B3A9)
References: <20121212053054.GA4356@localhost.localdomain>
 <50C83998.4020508@elsoft.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <50C83998.4020508@elsoft.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Dec 12, 2012 at 09:00:24AM +0100, "David Müller (ELSOFT AG)" wrote:
> Stanislaw Gruszka wrote:
> > +static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
> > +{
> > +	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
> > +	rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
> > +	rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
> > +	rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
> > +	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
> > +	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
> > +	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
> > +	rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
> 
> 
> Wouldn't a table based initialization be more readable and also shorter?

It probably will. But in case of 5390 there are conditionals, so table
will not handle that.

Stanislaw
