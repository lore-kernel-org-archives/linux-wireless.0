Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ascomax.hasler.ascom.ch ([139.79.135.1]:44170 "EHLO
	ascomax.hasler.ascom.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759181AbYBVVVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 16:21:51 -0500
Date: Fri, 22 Feb 2008 22:21:03 +0100
From: Andrew Lunn <andrew.lunn@ascom.ch>
To: Dan Williams <dcbw@redhat.com>
Cc: Andrew Lunn <andrew.lunn@ascom.ch>, linux-wireless@vger.kernel.org
Subject: Re: Link Quality stats not updating, recieved_channel
Message-ID: <20080222212103.GA7771@donkey.ma.tech.ascom.ch> (sfid-20080222_212157_469537_779F65E6)
References: <20080222142614.GA18830@donkey.ma.tech.ascom.ch> <1203714351.4422.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203714351.4422.2.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Can you try the attached patch instead?  stats.received_channel really
> should be filled by the hardware driver itself.  This patch essentially
> does what bcm43xx does.  Can you test it please?

I can try it, but i suspect it will not work. The firmware in the
ipw2100 does the scan, not the driver. So priv->channel will not be
the frequency the probe_resp corresponds to when the firmware is off
scanning on other frequencies.

But i will try it for in case i'm wrong.

    Andrew
