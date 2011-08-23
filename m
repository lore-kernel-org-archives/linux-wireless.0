Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:37589 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1HWRqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 13:46:16 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id F1AB138CA1
	for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 19:41:22 +0200 (CEST)
Date: Tue, 23 Aug 2011 10:41:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-wireless@vger.kernel.org
Cc: Jamey Sharp <jamey@minilop.net>
Subject: Re: EINVAL when setting 802.11a channel in Ad-Hoc mode
Message-ID: <20110823174113.GA3155@leaf> (sfid-20110823_194619_975882_2F24748F)
References: <20110817025141.GA4529@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110817025141.GA4529@leaf>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 16, 2011 at 07:51:42PM -0700, Josh Triplett wrote:
> We're trying to run 802.11a in Ad-Hoc mode.  However, when we get to the
> point of setting the channel, we almost always get EINVAL back from the
> kernel.  We ran the following series of commands:
> 
> wlan=wlan3
> iwconfig $wlan mode Ad-Hoc
> ifconfig $wlan up
> iwconfig $wlan essid PSAS-flight-computer
> iwconfig $wlan channel 36
> 
> The channel command almost always got back an EINVAL.  This occurred on
> three different wifi chipsets: a USB ar9170 (with either carl9170 or the
> older ar9170usb driver), a USB rt2800usb, and iwlwifi with a Lenovo
> X220.  In the former two cases, it occurs on both x86 (the
> aforementioned X220) and powerpc (an MPC5200).
> 
> More strangely, the channel command would *sometimes* successfully set
> the channel without error.
> 
> Have we done something wrong with the sequence of commands above?  Why
> might we get EINVAL when setting a valid channel?  What next steps
> should we take to debug this?
> 
> Currently about to compile in function_graph tracing and start walking
> through the execution of SIOCSIWFREQ looking for what generates the
> EINVAL.

Having done that, I managed to track down the source of the problem.
Note that in the script above, I used channel 36 as an example; however,
we tried a couple of other channels that should theoretically work in
the US, such as 136, but those apparently have additional requirements
to use, and it looks like Linux just gives a blanket "no".

As it turns out, we want to use channel 36 anyway, so it doesn't matter
that 136 doesn't work.

- Josh Triplett
