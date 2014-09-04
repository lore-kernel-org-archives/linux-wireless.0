Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:61437 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIDGGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 02:06:38 -0400
Received: by mail-la0-f54.google.com with SMTP id b17so11215663lan.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 23:06:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1409031720280.17274@admin.chi.technicality.org>
References: <CANUX_P1udm36NoF-dbOARa671VthuYfrEEz2ODSmkCgDzcRe8g@mail.gmail.com>
	<alpine.DEB.2.02.1409031720280.17274@admin.chi.technicality.org>
Date: Thu, 4 Sep 2014 09:06:36 +0300
Message-ID: <CANUX_P2ZqEo4pcVxcB1GHzaG8Fc3NqgBdr3Se8aGq+DXZPMLqQ@mail.gmail.com> (sfid-20140904_080641_912257_244D6534)
Subject: Re: [ANN] new experimental firmware for 7260 / 3160 / 7265 - Core7
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Nate Carlson <linux-wireless@natecarlson.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just saw something weird...

The Q 16 is still working while we flush:

>
> Gave this a shot on 3.17-rc3 plus the patch to support the new firmware.. it
> seemed to work well for a while, and then I got disconnected with the error
> below; after that I had to unload and reload iwlmvm and iwlwifi to get
> connected again..
>
> [ 4685.025024] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
> [ 4685.025037] iwlwifi 0000:03:00.0: Current SW read_ptr 62 write_ptr 63
> [ 4685.025077] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 40 00 00
> 00 00  ...........@....
> [ 4685.025104] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
> [ 4685.025129] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc0110006
> [ 4685.025155] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
> [ 4685.025181] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x8030001a
> [ 4685.025207] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
> [ 4685.025233] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
> [ 4685.025259] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
> [ 4685.025285] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00709072
> [ 4685.025355] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
> ra_tid 0x0000 [27,27]
> [ 4685.025424] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
> ra_tid 0x0000 [0,0]
> [ 4685.025493] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
> ra_tid 0x0000 [62,63]
> [ 4685.025561] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.025630] iwlwifi 0000:03:00.0: Q 4 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.025698] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.025767] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.025835] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.025904] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.025972] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
> ra_tid 0x0000 [115,115]
> [ 4685.026041] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.026110] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.026180] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.026249] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.026318] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.026386] iwlwifi 0000:03:00.0: Q 15 is active and mapped to fifo 5
> ra_tid 0x0000 [0,0]
> [ 4685.026454] iwlwifi 0000:03:00.0: Q 16 is active and mapped to fifo 1
> ra_tid 0x0000 [5,7]

<<<===>>> Here the last packet in Q16 is 7

> [ 4685.026523] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.026591] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4685.026666] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.030789] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 16
> [ 4687.030802] iwlwifi 0000:03:00.0: Current SW read_ptr 6 write_ptr 11
> [ 4687.030854] iwl data: 00000000: 80 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [ 4687.030881] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
> [ 4687.030907] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc011000a
> [ 4687.030924] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
> [ 4687.030970] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x8030001b
> [ 4687.030984] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
> [ 4687.031019] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
> [ 4687.031044] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
> [ 4687.031070] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00709072
> [ 4687.031140] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3
> ra_tid 0x0000 [28,28]
> [ 4687.031207] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2
> ra_tid 0x0000 [0,0]
> [ 4687.031276] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1
> ra_tid 0x0000 [63,63]
> [ 4687.031345] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031414] iwlwifi 0000:03:00.0: Q 4 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031481] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031550] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031625] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031696] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031764] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7
> ra_tid 0x0000 [115,115]
> [ 4687.031833] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031901] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.031970] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.032038] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.032107] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.032176] iwlwifi 0000:03:00.0: Q 15 is active and mapped to fifo 5
> ra_tid 0x0000 [0,0]
> [ 4687.032245] iwlwifi 0000:03:00.0: Q 16 is active and mapped to fifo 1
> ra_tid 0x0000 [7,11]

<<<===>>> Here the last packet in Q16 is 11 - which means that the
stack is still sending packets while it tries to flush. This is ...
surprising.

> [ 4687.032313] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.032382] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
> [ 4687.032451] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0
> ra_tid 0x0000 [0,0]
>


can you please re-run with trace-cmd -e iwlwifi -iwlwifi_msg -e
mac80211 and send the trace.dat output.

Thanks!
