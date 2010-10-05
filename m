Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52135 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab0JEXHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 19:07:40 -0400
Received: by iwn5 with SMTP id 5so8900645iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 16:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0B26B230-4AA6-48DE-9241-F5DA6A557153@Atheros.com>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
 <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
 <1285611630.4043.26.camel@jlt3.sipsolutions.net> <AANLkTin+1-_RA8fY8B5-omQi3kMJ3U0iw8Kdg=FC2rnP@mail.gmail.com>
 <1285613669.4043.27.camel@jlt3.sipsolutions.net> <AANLkTimmZZiMbtA-8m69grwV_v95KcGKRQi6=-fz0JuT@mail.gmail.com>
 <1285614371.4043.28.camel@jlt3.sipsolutions.net> <AANLkTikcqU3kMCELc9QadC0JOA2ic1=Mw+X34kOus4VL@mail.gmail.com>
 <1285614631.4043.29.camel@jlt3.sipsolutions.net> <AANLkTimMzR2LoH0Qxqi-VH=o15vERFSTZSBbMbDGvv8Q@mail.gmail.com>
 <0B26B230-4AA6-48DE-9241-F5DA6A557153@Atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Oct 2010 16:07:19 -0700
Message-ID: <AANLkTi=u16NwKzEyh2FRn9DsU+=HwFpxsuMz9cSx43TU@mail.gmail.com>
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
To: Matt Smith <Matt.Smith@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 3:34 PM, Matt Smith <Matt.Smith@atheros.com> wrote:
> I would not send voice data under a BA agreement.  If you have to give up on transmitting a frame, it will leave a hole at the receiver which will then require a BAR to move past.  Since you will typically only send one frame at a time, it (use of A-MPDU aggregation) doesn't buy you anything.  IIRC, there are industry certification tests that send more than one frame a second at AC_VO, however, which one needs to to pass.

Thanks Matt, I've stashed this under out TODO list:

http://wireless.kernel.org/en/users/Drivers/ath9k/todo

  Luis
