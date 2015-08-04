Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:53684 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbbHDWty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 18:49:54 -0400
Date: Wed, 5 Aug 2015 00:49:51 +0200
From: Maxime Bizon <mbizon@freebox.fr>
To: Chor Teck Law <ctlaw@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
Message-ID: <20150804224951.GA31383@sakura.staff.proxad.net> (sfid-20150805_005011_726393_7E3F8F99)
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <1436455659.36587.131.camel@sakura.staff.proxad.net>
 <87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
 <db9a0d4afa9b435d8efa380715955bee@SC-EXCH03.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <db9a0d4afa9b435d8efa380715955bee@SC-EXCH03.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tuesday 04 Aug 2015 à 18:11:29 (+0000), Chor Teck Law wrote:

Hi Chor,

> mwl8k was a driver for chips few generations older sponsored by
> Marvell. We did leverage part of driver framework that is still
> applicable. However, for the current development, the firmware API
> specs, chip capabilities and bandwidth requirements have changed in
> order to handle newer technologies and features.

this is a fullmac driver, what differs between them is:
 - how you boot the device / load firmware
 - how you send commands to it
 - datapath


from a quick glance at your new driver

 1) firmware loading works the same way

 2) "hostcmd" are used to communicate with the firmware, of course new
   commands are needed for newer standards, but a common API could be
   used for common basic operations

 3) rx datapath looks the same (look at struct mwl_rx_desc vs mwl8k_rxd_ap)

 4) AMPDU code is copied/pasted from mwl8k driver, even the original
   comments have not been updated:

+  /* Defer calling mwl8k_start_stream so that the current


> No, we are not treating the submission as dumping! We would not have
> responded with effort to meet the requests/feedback if so. We
> appreciate and have taken the feedbacks seriously to complete to
> patch6. In fact the submission was requested by some community
> members who has seen the benefit of its evolvement on openwrt
> github, and they would like to see the new driver consolidated into
> the wireless mainline.

judging from the mwl8k experience (hello, unhappy customer here),
mainline is indeed the goal, but after that, nothing.

driver & firmware left at version 1, unless customer (me in that case)
made an explicit bug report or feature request.

> Due to hardware, firmware, specs and requirements change over time,
> it is not feasible for us to revisit generations old products or
> making sure new changes are backward compatible with it. (If
> desired, we welcome the community to take any new useful changes
> that are independent of chip rev to other similar branches.)

no hardware specs, no firmware source or docs, community can only make
blind guesses.

also see my answer beyond.

> Lastly, I do not think we are creating a precedence with different
> generation of drivers supporting different families of chips.

these are firmware based chipsets, not hard-wired. having a common
driver for two completely different set of chipsets is indeed stupid,
and makes it unreadable.

but from my POV, your pattern is: build new chipset, obsolete previous
chipset, fork current firmware, make uncompatible changes to both
firmware & host driver to accomodate new chipset peculiarities.

and eventually, if a customer requests a mainline linux driver, then
write one... this is what I'd call "dumping"

-- 
Maxime
