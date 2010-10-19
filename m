Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:43466 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751310Ab0JSOfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 10:35:09 -0400
Message-ID: <4CBDB6E1.3020209@gmx.net>
Date: Tue, 19 Oct 2010 17:18:57 +0200
From: George <george.news@gmx.net>
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Compat-wireless N900
References: <4CB6BE57.8010401@gmx.net>	<1287071844.11341.5.camel@gnutoo-laptop>	<AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>	<4CB74759.3030807@gmx.net>	<AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>	<4CB7F7C7.7030804@gmx.net>	<AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>	<4CBABB84.1090100@gmx.net>	<4CBC7725.7050202@gmx.net>	<AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>	<4CBC9A51.8030309@gmx.net>	<1287427291.8043.2.camel@powerslave>	<1287428554.8043.6.camel@powerslave>	<4CBD52DE.9090804@gmx.net> <AANLkTi=dGSVBrdDXwJgmOjEGX+i+=P_KibiJd+NNMGfy@mail.gmail.com> <4CBDB654.6060702@gmx.net>
In-Reply-To: <4CBDB654.6060702@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19/10/2010 17:16, George wrote:
> On 19/10/2010 15:52, Grazvydas Ignotas wrote:
>> On Tue, Oct 19, 2010 at 11:12 AM, George<george.news@gmx.net> wrote:
>>> On 18/10/2010 21:02, Luciano Coelho wrote:
>>>>
>>>> On Mon, 2010-10-18 at 20:41 +0200, ext Luciano Coelho wrote:
>>>>>
>>>>> On Mon, 2010-10-18 at 21:04 +0200, ext George wrote:
>>>>>>
>>>>>> On 18/10/2010 19:21, Luis R. Rodriguez wrote:
>>>>>>> Does your device use SDIO or SPI?
>>>>>>>
>>>>>>> Luis
>>>>>>
>>>>>> I have tried both and none of them have worked.
>>>>>
>>>>> On the N900 the wl1271 chip is connected via SPI.
>>>
>>> The chip is a wl1251, isn't it? wl1271 is n capable and n900 is not.
>>
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
>
> However this is the output from lsmod | grep spi
> spi 4352 0
> wl1251 75840 1 spi
> mac80211 256892 2 spi,wl1251
> crc7 1216 1 spi
>
> As you can see spi module is not used :( and no interface is created.
> Still a way to go.
>

I forgot also to mention that bluetooth in not working with new modules 
from compat-wireless


> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

