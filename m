Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56178 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab2LSL73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 06:59:29 -0500
Message-ID: <50D1AC1E.7070002@openwrt.org> (sfid-20121219_125933_878883_08C9681D)
Date: Wed, 19 Dec 2012 12:59:26 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Jones Desougi <jones.desougi@27m.se>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Daniel Golle <dgolle@allnet.de>, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: rt2800pci: verify ioremap return value
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org> <50D19F97.9000000@27m.se>
In-Reply-To: <50D19F97.9000000@27m.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.19. 12:05 keltezéssel, Jones Desougi írta:
> Hi Gabor,
> 
> One thing:
> 
> On 12/18/2012 05:22 PM, Gabor Juhos wrote:
>> An ioremap call is allowed to fail, however
>> the return value of that is not checked in
>> the 'rt2800pci_read_eeprom_soc' function.
>>
>> The patch adds the missing check, and makes
>> the function return an int value. The patch
>> also converts the 'rt2800_read_eeprom' and
>> 'rt2800_ops.read_eeprom' functions to return
>> an int value, so the error value can be
>> propagated up to the 'rt2800_validate_eeprom'
>> function.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

>> +static int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
>>  {
>>  	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
>>  
>> +	if (!base_addr)
>> +		return -ENOMEM;
>> +
>>  	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
>>  
>>  	iounmap(base_addr);
>>  }
> 
> Missing return at the end, since it should now return an int.

You are right.

> Even if this is gone with the second patch.

I will post an updated version of the patch-set anyway and will fix this.

Thank you for the review!

-Gabor
