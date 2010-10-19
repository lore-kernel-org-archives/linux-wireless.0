Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:35107 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752962Ab0JSPJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 11:09:14 -0400
Message-ID: <4CBDBEDB.3070407@gmx.net>
Date: Tue, 19 Oct 2010 17:52:59 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net>	<1287071844.11341.5.camel@gnutoo-laptop>	<AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>	<4CB74759.3030807@gmx.net>	<AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>	<4CB7F7C7.7030804@gmx.net>	<AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>	<4CBABB84.1090100@gmx.net>	<4CBC7725.7050202@gmx.net>	<AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>	<4CBC9A51.8030309@gmx.net>	<1287427291.8043.2.camel@powerslave>	<1287428554.8043.6.camel@powerslave>	<4CBD52DE.9090804@gmx.net>	<AANLkTi=dGSVBrdDXwJgmOjEGX+i+=P_KibiJd+NNMGfy@mail.gmail.com>	<4CBDB654.6060702@gmx.net> <AANLkTimyCv6U+Yjf7q0OFEYF3PHr5PfACSpbXbTi_PZe@mail.gmail.com>
In-Reply-To: <AANLkTimyCv6U+Yjf7q0OFEYF3PHr5PfACSpbXbTi_PZe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/10/2010 16:38, Grazvydas Ignotas wrote:
>>> I think your problem is that the driver (in
>>> drivers/net/wireless/wl1251/spi.c) and spi_board_info (in
>>> arch/arm/mach-omap2/board-rx51-peripherals.c) names don't match
>>> (wl1251 vs wl12xx). Probably easiest to edit .modalias in
>>> board-rx51-peripherals.c and rebuild the kernel.
>>>
>>
>> It seems getting closer ;)
>>
>> After changing wl12xx for spi:wl1251 now modules are uploaded on startup.
>
> You should just use "wl1251", not spi:wl1251, so it becomes:
>
> {
>                  .modalias               = "wl1251",
>                  .bus_num                = 4,
>                  .chip_select            = 0,
>                  .max_speed_hz           = 48000000,
> ...

Tried and got a similar behaviour as when using spi:wl1251.

I have also set the debug ALL mode to see if I get something that can 
help you out on finding the problem.

When uploading only wl1251 nothing appears in dmesg. But when uploading 
module spi, I got the following info: http://pastebin.com/ysdTSDnB

HTH

TA
Jorge

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

