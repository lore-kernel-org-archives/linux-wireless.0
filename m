Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58486 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2C0IaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 04:30:05 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20337.31328.528725.786517@gargle.gargle.HOWL> (sfid-20120327_103013_663831_E44A0CAD)
Date: Tue, 27 Mar 2012 13:59:20 +0530
To: David Madore <david+ml@madore.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc fails with "Target is unresponsive"
In-Reply-To: <20120323174708.GA2797@aldebaran.gro-tsen.net>
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
	<CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
	<20120321220242.GA26363@aldebaran.gro-tsen.net>
	<20120322002955.GA9391@aldebaran.gro-tsen.net>
	<20331.61854.29639.644902@gargle.gargle.HOWL>
	<20120323174708.GA2797@aldebaran.gro-tsen.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Madore wrote:
> In other words: loading the module seems to place the dongle in a bad
> state that goes away after ifconfig up (but not by removing the
> modules), and if a reboot happens while the dongle is in that bad
> state, it will fail permanently.

Right, there's a difference here, a 'reboot' of the card is done only when
if the interface is brought up. The device status from the USB subsystem
is used to handle this - it works on x86.

On your platform, I think that a full reboot is required even when doing just
a simple load/unload cycle. I'll come up with a patch to test this.

Thanks for the detailed log.

Sujith
