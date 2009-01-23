Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49112 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbZAWDjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 22:39:36 -0500
Message-ID: <49793BE7.3020509@lwfinger.net> (sfid-20090123_043941_213202_831B7915)
Date: Thu, 22 Jan 2009 21:39:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: wireless <linux-wireless@vger.kernel.org>,
	=?ISO-8859-1?Q?Mart=EDn_?= =?ISO-8859-1?Q?Ernesto_Barreyro?=
	<barreyromartin@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Minstrel rate-setting question
References: <BLU144-W4266C309A1F9CD0F4B5C21B2D90@phx.gbl>	 <496CE438.6020408@lwfinger.net>	 <BLU144-W164FB7B41C703C52AAAF9BB2D90@phx.gbl>	 <496D2772.4060104@lwfinger.net>	 <BLU144-W254C2D7845CD9E851F745DB2D60@phx.gbl>	 <496D3118.7060906@lwfinger.net>	 <BLU144-W40A7F7D25BE3B92EABD5C7B2D60@phx.gbl> <496D665A.90608@lwfinger.net>	 <BLU144-W102912CECD6EE0D07D1BD8B2D50@phx.gbl>	 <4972B1E7.7000005@lwfinger.net>	 <BLU144-W211FE279F46EA07E0D35E0B2D10@phx.gbl>	 <4977612D.7050500@lwfinger.net> <1232664643.4589.5.camel@note-tatin> <49790C43.5050100@lwfinger.net> <497929C1.9060804@openwrt.org>
In-Reply-To: <497929C1.9060804@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I believe that it's not minstrel's fault. According to the information that
> I have about RTL8187L, the chip implements rate fallback. If the chip changes
> rates during retransmissions, the status information the way you gather it
> will not be accurate and will trick minstrel into believing that higher rates
> actually work (which in fact they don't). 
> Please do some transmissions at 54M and run a monitor mode capture on a different
> card to see if it changes the rate during transmission and how frequently it
> uses one rate before falling back (if indeed my theory is correct).
> This information could be used to provide some more accurate feedback through
> multi-rate retry status information.


I believe you have the clue. There is a register named RATE_FALLBACK
and a bit called RTL818X_RATE_FALLBACK_ENABLE. I'm testing a patch
that leaves this bit unset.

Thanks,

Larry
