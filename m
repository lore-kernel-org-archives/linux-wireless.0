Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ascomax.hasler.ascom.ch ([139.79.135.1]:48800 "EHLO
	ascomax.hasler.ascom.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbYBVXH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 18:07:58 -0500
Date: Sat, 23 Feb 2008 00:07:10 +0100
From: Andrew Lunn <andrew.lunn@ascom.ch>
To: Dan Williams <dcbw@redhat.com>
Cc: Andrew Lunn <andrew.lunn@ascom.ch>, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: Link Quality stats not updating, recieved_channel
Message-ID: <20080222230710.GB7771@donkey.ma.tech.ascom.ch> (sfid-20080222_230810_459966_D7BD89A7)
References: <20080222142614.GA18830@donkey.ma.tech.ascom.ch> <1203714351.4422.2.camel@localhost.localdomain> <20080222212103.GA7771@donkey.ma.tech.ascom.ch> <1203718453.4422.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203718453.4422.17.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yeah; you're right.  I'm not sure there's a good way to do this unless
> there's some way the ipw2100 passes back the channel number each frame
> was received on.

There is nothing obvious in the structures in the header file. That
was my first plan of attack to fix the problem.

> But also ignoring the check in update_network() will cause the signal
> strength of networks to be lower than they should be, because the frame
> bled over to a different channel.

Well i would prefer to have lower strengths than way outdated
strengths from the first packet received.

          Andrew
