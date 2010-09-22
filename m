Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40689 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0IVRMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 13:12:46 -0400
Received: by iwn5 with SMTP id 5so673936iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 10:12:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285163687.15806.9.camel@maggie>
References: <20100922123953.67a4fc5e@danmob> <20100922130245.GC5515@tuxdriver.com>
 <201009221545.41377.chunkeey@googlemail.com> <1285163687.15806.9.camel@maggie>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Sep 2010 10:12:24 -0700
Message-ID: <AANLkTinr0omWQCaMj91P8=CFZLDLroxWdrV2c=9KjG4e@mail.gmail.com>
Subject: Re: Manual Control about Sending ACKs
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Berger <daniel@dat-berger.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 6:54 AM, Michael Büsch <mb@bu3sch.de> wrote:
> On Wed, 2010-09-22 at 15:45 +0200, Christian Lamparter wrote:
>
>> > I suspect you need to be looking at hacking firmware.
>> > You might look at the open-source ar9170 firmware
>> > or the b43-openfwwf project.
>>
>> probably not ar9170 either.
>> The ACK - mechanism (response control) is mostly hardwired in
>> the chip, there is not much to control here.
>
> The ack mechanism is implemented in firmware for the b43 chip and I
> think it's understood pretty much completely how ACKing works in
> the firmware. So you may want to take a look at b43-openfwwf.
> The guys who created b43-openfwwf also experimented with this
> kind of stuff, so you might want to contact them.

You can also look at ath_hw_set_bssid_mask() for ath5k, ath9k, which
I've documented quite extensively:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/net/wireless/ath/hw.c;h=a8f81ea09f143cc56c981f80db73469196ddb4c6;hb=HEAD#l26

  Luis
