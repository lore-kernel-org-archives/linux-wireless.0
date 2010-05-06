Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64484 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0EFS7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 14:59:22 -0400
Received: by bwz19 with SMTP id 19so175649bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 11:59:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/3] rt2x00: rt2800: update initial SIFS values
Date: Thu, 6 May 2010 20:59:08 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201005061229.04897.helmut.schaa@googlemail.com> <201005062038.24982.helmut.schaa@googlemail.com> <m2wa32f33a41005061151h6aa62957qde225d5d8654a631@mail.gmail.com>
In-Reply-To: <m2wa32f33a41005061151h6aa62957qde225d5d8654a631@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201005062059.08360.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 06 Mai 2010 schrieb Ivo Van Doorn:
> On Thu, May 6, 2010 at 8:38 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > Am Donnerstag 06 Mai 2010 schrieb Ivo Van Doorn:
> >> On Thu, May 6, 2010 at 12:29 PM, Helmut Schaa
> >> <helmut.schaa@googlemail.com> wrote:
> >> > Currently the CCK and OFDM SIFS value is set to 32us. This value is neither
> >> > used by the Ralink driver nor specified in 802.11.
> >> >
> >> > Instead of using 10us for CCK SIFS (as defined in 802.11) use 16us like in the
> >> > Ralink drivers. And indeed using a SIFS value of 10us breaks connectivity with
> >> > 11g + CTS protected connections. Add a comment to the code why we don't use 10us
> >> > for CCK SIFS value.
> >> >
> >> > The OFDM SIFS value is set to 16us (as defined in 802.11 and also used by the
> >> > Ralink drivers).
> >>
> >> Just wondering, but we hardcode the SIFS value in the rt2x00.h file.
> >> Perhaps we should remove it in there, and no longer pass it from
> >> rt2x00lib. That way there can't be any confusion about which drivers
> >> uses the sifs field and whcih do not.
> >
> > Yes, wouldn't be too bad I guess. But all non 2800 drivers use the same sifs
> > value, so we could just leave the define in rt2x00.h and remove the sifs value
> > from the config_erp calback and use the define in all other places?
> 
> Well I would still remove the define in that case. I think some of the
> legacy drivers
> work with different SIFS values but always accepted the value which we used in
> the define. So I would still remove the define, and then each driver
> is free to set
> the value as used in the legacy drivers.

Sure. No objections from my side.

Helmut

