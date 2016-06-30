Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44323 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbcF3JC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 05:02:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Priit Laes <plaes@plaes.org>
Cc: arnd@arndb.de, Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel\@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
	<ea10ff70-26e6-e151-5cea-c54bd12a054c@redhat.com>
	<f8995599-115d-87e5-7928-c029b48584f1@broadcom.com>
	<6402170.5s0abZDqlD@wuerfel> <1467230078.2598.2.camel@plaes.org>
Date: Thu, 30 Jun 2016 12:02:17 +0300
In-Reply-To: <1467230078.2598.2.camel@plaes.org> (Priit Laes's message of
	"Wed, 29 Jun 2016 22:54:38 +0300")
Message-ID: <87eg7f6odi.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_110231_788952_D9C64DD7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Priit Laes <plaes@plaes.org> writes:

>> What is the size of this nvram file? As it's board specific, I wonder
>> if we can simply include it inside of the DT verbatim. I remember
>> doing that (in the pre-dtb days, on real open firmware) for the
>> "spidernet"
>> ethernet driver.
>
> It contains a bit too much info:
>
> This is what CubieTruck requires:
>
> http://dl.cubieboard.org/public/Cubieboard/benn/firmware/ap6210/nvram_ap6210.txt

In the nvram file I see lots of identifiers:

manfid=0x2d0
prodid=0x492
vendid=0x14e4
devid=0x4343
boardtype=0x0598
boardrev=0x1307
boardnum=777

Are any of these (or a combination of them) unique for each board type?
What if one of these is provided through DT and then the driver could
choose the nvram file based on the board id? Just another idea...

-- 
Kalle Valo
