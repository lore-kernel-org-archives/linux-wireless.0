Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:58936 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbYDSR6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 13:58:53 -0400
Subject: Re: Does mac80211 support ap mode
From: Bas Hulsken <bhulsken@zonnet.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, cao jing <caojing.china@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208257427.3502.28.camel@johannes.berg>
References: <9f33c5230804141218j5778195ajc1a7bae011eb9528@mail.gmail.com>
	 <1208202280.12139.23.camel@localhost.localdomain>
	 (sfid-20080414_204742_445593_54A5FE8E)  <1208257427.3502.28.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 19:54:35 +0200
Message-Id: <1208627675.27478.7.camel@Bas> (sfid-20080419_185859_084877_86BC1524)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2008-04-15 at 13:03 +0200, Johannes Berg wrote:
> > > I read the mac80211 code. I found only the STA, IBSS and Mesh_Point
> > > interface type are processed by the code. So does it support the ap
> > > mode.
> > 
> > Yes, it does.  I'd suggest using hostapd as your AP daemon and the
> > nl80211 hostap driver.  While it's still under pretty heavy development,
> > it all should be fairly usable.  Johannes Berg would probably have a
> > more up-to-date description of the status of the hostapd nl80211 driver
> > and mac80211 AP-mode support.
> 
> As for drivers, b43 is known to work (I test this), rt2500pci seems to
> have some trouble (Bas Hulsken was trying it) and I don't know about any
> others.

I have tested AP mode on rt2500pci and rtl8187, both don't work at the
moment.

rt2500pci works best, but hangs somewhere in the
handshake/authentication process (I've posted logs on this list). I did
manage to get it to work beginning of Feb. this year, I'm still trying
to find the regression. Unfortunately the rt2x00 code has changed a lot
since then, and I'm extremely busy at work, so I haven't made a lot of
progress there.

rtl8187 does not come very far at all, hostapd can't switch it to master
mode apparently.. haven't investigated very much why this happens
though.. so it might be something trivial.

Bas


