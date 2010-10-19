Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:44203 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0JSOiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 10:38:06 -0400
Received: by pxi16 with SMTP id 16so481710pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 07:38:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CBDB654.6060702@gmx.net>
References: <4CB6BE57.8010401@gmx.net>
	<1287071844.11341.5.camel@gnutoo-laptop>
	<AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
	<4CB74759.3030807@gmx.net>
	<AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
	<4CB7F7C7.7030804@gmx.net>
	<AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>
	<4CBABB84.1090100@gmx.net>
	<4CBC7725.7050202@gmx.net>
	<AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>
	<4CBC9A51.8030309@gmx.net>
	<1287427291.8043.2.camel@powerslave>
	<1287428554.8043.6.camel@powerslave>
	<4CBD52DE.9090804@gmx.net>
	<AANLkTi=dGSVBrdDXwJgmOjEGX+i+=P_KibiJd+NNMGfy@mail.gmail.com>
	<4CBDB654.6060702@gmx.net>
Date: Tue, 19 Oct 2010 17:38:05 +0300
Message-ID: <AANLkTimyCv6U+Yjf7q0OFEYF3PHr5PfACSpbXbTi_PZe@mail.gmail.com>
Subject: Re: Compat-wireless N900
From: Grazvydas Ignotas <notasas@gmail.com>
To: George <george.news@gmx.net>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I think your problem is that the driver (in
>> drivers/net/wireless/wl1251/spi.c) and spi_board_info (in
>> arch/arm/mach-omap2/board-rx51-peripherals.c) names don't match
>> (wl1251 vs wl12xx). Probably easiest to edit .modalias in
>> board-rx51-peripherals.c and rebuild the kernel.
>>
>
> It seems getting closer ;)
>
> After changing wl12xx for spi:wl1251 now modules are uploaded on startup.

You should just use "wl1251", not spi:wl1251, so it becomes:

{
                .modalias               = "wl1251",
                .bus_num                = 4,
                .chip_select            = 0,
                .max_speed_hz           = 48000000,
...
