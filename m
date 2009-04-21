Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49368 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZDUOAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 10:00:53 -0400
Date: Tue, 21 Apr 2009 09:54:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rami Rosen <roszenrami@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>, buytenh@marvell.com
Subject: Re: [PATCH ] mwl8: fix build warning.
Message-ID: <20090421135450.GI17805@tuxdriver.com> (sfid-20090421_160058_410878_92B02A30)
References: <b25312890904210457u1fffa553sa661d5b093a6e80f@mail.gmail.com> <1240317120.17388.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240317120.17388.16.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 02:32:00PM +0200, Johannes Berg wrote:
> On Tue, 2009-04-21 at 14:57 +0300, Rami Rosen wrote:
> > This patch fixes a build warning in mwl8.c.
> > (Marvell TOPDOG wireless driver)
> > 
> > The warning it fixes is: "large integer implicitly truncated to unsigned type."
> 
> > -		rx_desc->rx_ctrl =
> > -			cpu_to_le32(MWL8K_RX_CTRL_OWNED_BY_HOST);
> > +		rx_desc->rx_ctrl = MWL8K_RX_CTRL_OWNED_BY_HOST;
> 
> Umm. This really needs to come with an explanation.

Yeah -- trading a warning for a silent error seems unreasonable. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
