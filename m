Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbcF3Juw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 05:50:52 -0400
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name
 dt property
To: kvalo@codeaurora.org, Priit Laes <plaes@plaes.org>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <ea10ff70-26e6-e151-5cea-c54bd12a054c@redhat.com>
 <f8995599-115d-87e5-7928-c029b48584f1@broadcom.com>
 <6402170.5s0abZDqlD@wuerfel> <1467230078.2598.2.camel@plaes.org>
 <87eg7f6odi.fsf@kamboji.qca.qualcomm.com>
Cc: arnd@arndb.de, Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <e94f58fe-f709-94bd-21f6-144c4e038d17@redhat.com> (sfid-20160630_115056_662117_F24AAFCE)
Date: Thu, 30 Jun 2016 11:50:01 +0200
MIME-Version: 1.0
In-Reply-To: <87eg7f6odi.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 30-06-16 11:02, Kalle Valo wrote:
> Priit Laes <plaes@plaes.org> writes:
>
>>> What is the size of this nvram file? As it's board specific, I wonder
>>> if we can simply include it inside of the DT verbatim. I remember
>>> doing that (in the pre-dtb days, on real open firmware) for the
>>> "spidernet"
>>> ethernet driver.
>>
>> It contains a bit too much info:
>>
>> This is what CubieTruck requires:
>>
>> http://dl.cubieboard.org/public/Cubieboard/benn/firmware/ap6210/nvram_ap6210.txt
>
> In the nvram file I see lots of identifiers:
>
> manfid=0x2d0
> prodid=0x492
> vendid=0x14e4
> devid=0x4343
> boardtype=0x0598
> boardrev=0x1307
> boardnum=777
>
> Are any of these (or a combination of them) unique for each board type?
> What if one of these is provided through DT and then the driver could
> choose the nvram file based on the board id? Just another idea...

That would require updating a table in the driver every time a new
board comes out, I do not believe that that is a good solution.

Regards,

Hans
