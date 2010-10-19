Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45343 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0JSNwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 09:52:02 -0400
Received: by pwj4 with SMTP id 4so449579pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 06:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CBD52DE.9090804@gmx.net>
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
Date: Tue, 19 Oct 2010 16:52:00 +0300
Message-ID: <AANLkTi=dGSVBrdDXwJgmOjEGX+i+=P_KibiJd+NNMGfy@mail.gmail.com>
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

On Tue, Oct 19, 2010 at 11:12 AM, George <george.news@gmx.net> wrote:
> On 18/10/2010 21:02, Luciano Coelho wrote:
>>
>> On Mon, 2010-10-18 at 20:41 +0200, ext Luciano Coelho wrote:
>>>
>>> On Mon, 2010-10-18 at 21:04 +0200, ext George wrote:
>>>>
>>>> On 18/10/2010 19:21, Luis R. Rodriguez wrote:
>>>>> Does your device use SDIO or SPI?
>>>>>
>>>>>    Luis
>>>>
>>>> I have tried both and none of them have worked.
>>>
>>> On the N900 the wl1271 chip is connected via SPI.
>
> The chip is a wl1251, isn't it? wl1271 is n capable and n900 is not.

I think your problem is that the driver (in
drivers/net/wireless/wl1251/spi.c) and spi_board_info (in
arch/arm/mach-omap2/board-rx51-peripherals.c) names don't match
(wl1251 vs wl12xx). Probably easiest to edit .modalias in
board-rx51-peripherals.c and rebuild the kernel.
