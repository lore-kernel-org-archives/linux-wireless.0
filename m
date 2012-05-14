Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31238 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab2ENJUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 05:20:23 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20400.52778.34625.954002@gargle.gargle.HOWL> (sfid-20120514_112027_595216_3A7FECE0)
Date: Mon, 14 May 2012 14:49:38 +0530
To: Robert Bouterse <robert.bouterse@dmh-global.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc fails with 
In-Reply-To: <loom.20120511T213645-406@post.gmane.org>
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
	<CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
	<20120321220242.GA26363@aldebaran.gro-tsen.net>
	<20120322002955.GA9391@aldebaran.gro-tsen.net>
	<20331.61854.29639.644902@gargle.gargle.HOWL>
	<20120323174708.GA2797@aldebaran.gro-tsen.net>
	<20337.31328.528725.786517@gargle.gargle.HOWL>
	<loom.20120511T213645-406@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Robert Bouterse wrote:
> I seem to running into this same issue, mine is that the driver emits the
> "Target unresponsive" error if the unit is powered-up with the TL-WN721N plugged
> in already. I think my issue is that the USB subsytem event is not recieved by
> the atk9k_htc driver, and therefore the hardware is not reset.
> 
> Has this ben fixed already? Can you give me the commit sha1 in wireless-testing?
> I am using compat-wireless, so I am lagging master a bit.
> 
> If not, can you point me at where in the driver code the reset happens? Maybe I
> can come up with a patch.

You can play around with the function ath9k_hif_usb_disconnect() in
drivers/net/wireless/ath/ath9k/hif_usb.c which has the deinit/reboot code. :)

Sujith
