Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60395 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HEIfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 04:35:42 -0400
Date: Fri, 5 Aug 2011 14:06:02 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 11/13] ath9k_hw: Disable Walsh spatial spreading for 2
 chains
Message-ID: <20110805083601.GA6702@vmraj-lnx.users.atheros.com> (sfid-20110805_103547_008489_505FBB19)
References: <1312480447-27483-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E3AE3A0.2000308@openwrt.org>
 <20110805025452.GA28266@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110805025452.GA28266@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 05, 2011 at 08:24:53AM +0530, Rajkumar Manoharan wrote:
> On Thu, Aug 04, 2011 at 08:23:28PM +0200, Felix Fietkau wrote:
> > On 2011-08-04 7:54 PM, Rajkumar Manoharan wrote:
> > >The Walsh bit is disabled for regulatory consideration.
> > >
> > >As per the FCC rulings, only transmissions that are completely
> > >non-coherent, are allowed to waive the array gain contribution
> > >to EIRP for multi-transmit configurations. The use of 2-stream
> > >with 2 transmit and use of 3-steam with 3 transmit qualifies
> > >for this spatial multiplexing MIMO classification as long as
> > >the streams are directly mapped to each radio (not Walsh spread
> > >prior to splitting to multiple radios)
> > I think ath9k does not waive the array gain contribution. I haven't
> > checked AR9003, but on AR9002 and older, it explicitly includes the
> > array gain contribution in the tx power limit calculation. I'm not
> > sure that unconditionally disabling spatial spreading is the right
> > way to deal with this.
> >
> We might violate the FCC rule with 2x2 config(3dB higher at 2-stream)
> if this bit is enabled. Based on chainmask we can disable Walsh bit.

This change does not affect 3x3, since we don't use 2-chain for 2-stream.
And Walsh mode would follow INI setting for 2x2 or 3x3 config.

--
Rajkumar
