Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:61775 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0EFSii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:38:38 -0400
Received: by fg-out-1718.google.com with SMTP id d23so479777fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 11:38:37 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/3] rt2x00: rt2800: update initial SIFS values
Date: Thu, 6 May 2010 20:38:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201005061229.04897.helmut.schaa@googlemail.com> <s2ma32f33a41005061001w5e7258f0p3715ec238a00a4f4@mail.gmail.com>
In-Reply-To: <s2ma32f33a41005061001w5e7258f0p3715ec238a00a4f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005062038.24982.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 06 Mai 2010 schrieb Ivo Van Doorn:
> On Thu, May 6, 2010 at 12:29 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > Currently the CCK and OFDM SIFS value is set to 32us. This value is neither
> > used by the Ralink driver nor specified in 802.11.
> >
> > Instead of using 10us for CCK SIFS (as defined in 802.11) use 16us like in the
> > Ralink drivers. And indeed using a SIFS value of 10us breaks connectivity with
> > 11g + CTS protected connections. Add a comment to the code why we don't use 10us
> > for CCK SIFS value.
> >
> > The OFDM SIFS value is set to 16us (as defined in 802.11 and also used by the
> > Ralink drivers).
> 
> Just wondering, but we hardcode the SIFS value in the rt2x00.h file.
> Perhaps we should remove it in there, and no longer pass it from
> rt2x00lib. That way there can't be any confusion about which drivers
> uses the sifs field and whcih do not.

Yes, wouldn't be too bad I guess. But all non 2800 drivers use the same sifs
value, so we could just leave the define in rt2x00.h and remove the sifs value
from the config_erp calback and use the define in all other places?

Nevertheless, I'm not sure why the rt2800 devices don't like the 10us CCK
SIFS value (which is defined in 802.11) but I wasn't able to get CTS to self
working correctly with it set to 10 (the actual data frame was sent out
way too late after the CTS frame, somtimes with delays >100us). Using the 16us
also for CCK (as the ralink drivers do) results in perfect CTS & data frame
timing. Maybe it's a hardware issue and the (ralink) driver just works around
it?

Helmut
