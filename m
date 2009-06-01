Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57700 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbZFAMqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 08:46:08 -0400
Date: Mon, 1 Jun 2009 09:45:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090601124553.GE11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local> <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com> <1243763887.19302.29.camel@johannes.local> <1243796509.6570.35.camel@localhost.localdomain> <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk> <20090601122839.GB11011@khazad-dum.debian.net> <1243859931.5299.17.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243859931.5299.17.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes!

On Mon, 01 Jun 2009, Johannes Berg wrote:

> On Mon, 2009-06-01 at 09:28 -0300, Henrique de Moraes Holschuh wrote:
> > On Mon, 01 Jun 2009, Alan Jenkins wrote:
> > >> See, Henrique says that the use case is Thinkpads which store the
> > >> previous state in the BIOS. But that matters to you only if you use a
> > >> mixture of operation systems, which we don't have to support.
> > 
> > Well, if you do all in userspace, how do you propose to avoid the usual race
> > conditions of the sort "radio starts on, but it should have started off",
> > etc?  You'd have to kick the radios off on rfkill module load for safety,
> > and that will also cause nastyness (it kicks my built-in wlan
> > (eeepcargh)/bluetooth(most)/wwan(most) off bus, then hotplugs it again!).
> 
> Have you bothered reading the code? If you turn things off with
> CHANGE_ALL that applies to hot-plugged devices too.

I mean platform devices which remember state.  Those will be turned on/off
by the platform firmware at boot and often at resume time, and overriding
them in rfkill (especially if it is done later, by a rfkilld) will cause
some flicker (on/off/on, off/on/off) in certain situations.  

This is a regression, because the current interface doesn't suffer this
limitation.

Also, remember that this on/off stuff CAN mean kicking devices off-bus,
that's very usual for everything other than WLAN, so it can be a lot more
annoying than just turning a transmitter off for a moment.

I certainly expect whatever the current global state to be applied to all
new devices getting registered, that is not something I would complain
about.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
