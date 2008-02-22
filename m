Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936130AbYBVWQZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 17:16:25 -0500
Subject: Re: Link Quality stats not updating, recieved_channel
From: Dan Williams <dcbw@redhat.com>
To: Andrew Lunn <andrew.lunn@ascom.ch>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20080222212103.GA7771@donkey.ma.tech.ascom.ch>
References: <20080222142614.GA18830@donkey.ma.tech.ascom.ch>
	 <1203714351.4422.2.camel@localhost.localdomain>
	 <20080222212103.GA7771@donkey.ma.tech.ascom.ch>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 17:14:13 -0500
Message-Id: <1203718453.4422.17.camel@localhost.localdomain> (sfid-20080222_221647_486134_2CE0AF38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 22:21 +0100, Andrew Lunn wrote:
> > Can you try the attached patch instead?  stats.received_channel really
> > should be filled by the hardware driver itself.  This patch essentially
> > does what bcm43xx does.  Can you test it please?
> 
> I can try it, but i suspect it will not work. The firmware in the
> ipw2100 does the scan, not the driver. So priv->channel will not be
> the frequency the probe_resp corresponds to when the firmware is off
> scanning on other frequencies.

Yeah; you're right.  I'm not sure there's a good way to do this unless
there's some way the ipw2100 passes back the channel number each frame
was received on.  We can't use IPW_ORD_OUR_FREQ because we can't
guarantee that when the interrupt for received frame occurs the frame
the driver is handed was received on the same channel that the card is
now on.

But also ignoring the check in update_network() will cause the signal
strength of networks to be lower than they should be, because the frame
bled over to a different channel.

Intel devs; does the ipw2100 firmware stick the channel into the frame
header anywhere like ipw2200?  Perhaps the ipw2100 driver just never got
updated for that feature?  If not, is there another way this could be
fixed?

Dan

