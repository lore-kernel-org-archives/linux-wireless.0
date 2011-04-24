Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1DXT33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 15:29:29 -0400
Subject: Re: [PATCH 1/1 RFC] mac80211: add ratio to led blinking trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1303670920.22777.10.camel@wwguy-ubuntu>
References: <1303665300-1775-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110424_191812_851726_8A7D5FAA)  <1303670306.3603.5.camel@jlt3.sipsolutions.net>
	 <1303670920.22777.10.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 21:29:20 +0200
Message-ID: <1303673360.3603.7.camel@jlt3.sipsolutions.net> (sfid-20110424_212935_595413_358747C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-24 at 11:48 -0700, wwguy wrote:
> On Sun, 2011-04-24 at 11:38 -0700, Johannes Berg wrote:
> > On Sun, 2011-04-24 at 10:15 -0700, Wey-Yi Guy wrote:
> > > The current led blink trigger implementaion assume on/off time are equal,
> > > it works but not have any flexbile for different blink pattern.
> > > 
> > > Add "ratio" parameter in the trigger table and give driver more control
> > > on how the on/off blink time behavior should be.
> > 
> > I considered this when writing the original code, but then decided that
> > nobody needed to have unequal on/off times. Why would we need it now?
> > (FWIW, blink = 0 is always on already, no?)
> > 
> But from what I read for iwlwifi, to turn LED_SOLID_ON, on = 11, off =
> 0. Did I read it wrong.

Ah, well, mac80211 has:

        /* default to just solid on */
        on = 1;
        off = 0;

So if you want "solid on" by default for 0 tpt, you simply don't specify
the -1 value, ie. just remove the -1 line from the table completely.
IOW, instead of the patch you posted before, a simple patch just
removing the first line from the table should be sufficient.

> Yes, I agree as today, "on" == "off", just thinking we should make more
> flexible.

I just don't see the point since we don't really need it.

johannes

