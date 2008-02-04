Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58563 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYBDOpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 09:45:13 -0500
Message-ID: <47A718CF.50303@openwrt.org> (sfid-20080204_144520_766309_31F8A570)
Date: Mon, 04 Feb 2008 14:53:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
References: <12020697053277-git-send-email-tomas.winkler@intel.com>    <1ba2fa240802040227g23fe41adu446adc8f0de22712@mail.gmail.com>    <-6799378017406559341@unknownmsgid>    <1ba2fa240802040305u611bb7edk3c757b73f40c1037@mail.gmail.com>    <-4694429725714512287@unknownmsgid>    <1ba2fa240802040321s515e61deld176d79eef2b444d@mail.gmail.com>    <-2417195033053015320@unknownmsgid>    <1ba2fa240802040326v425fe147y52f2d8731e3012cb@mail.gmail.com>    <1ba2fa240802040330o5b9ffb2dk32b28f7f959e49f4@mail.gmail.com>    <5358276387473684738@unknownmsgid>    <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com> <49711.::ffff:91.5.56.63.1202126931.squirrel@secure.sipsolutions.net>
In-Reply-To: <49711.::ffff:91.5.56.63.1202126931.squirrel@secure.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I thought we just agreed not to because they're not bit rate but rather
> rate control specific. Think of it this way: the rate control algorithm
> selects a bitrate and those control flags you mentioned (SISO/MIMO/...),
> right?
> 
> So the rate control algorithm has to communicate the bitrate and the flags
> to the hardware. It currently communicates the bitrate selection by giving
> a bitrate structure pointer (it could simply give the bitrate in kbps or
> whatever but that would mean the driver needs to look up its hw_value so
> this is the reason for passing the pointer) and cannot currently
> communicate the control flags selection.
> 
> So the way I see it we'd add something like "u32 rate_control_flags" to
> struct tx_control for the flags you wanted, and also add a similar field
> (to be able to reuse the flag definitions) to the tx status & rx status
> structs. It seems to me that makes most sense, no?
I'd like to have multiple rates in the tx status, including the number of
attempts for each rate. The Minstrel rate control needs these to build its
statistics properly.

- Felix
