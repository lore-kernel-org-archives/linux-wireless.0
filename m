Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:43118 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2LLTMG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 14:12:06 -0500
Message-ID: <50C8D705.3090304@openwrt.org> (sfid-20121212_201211_847324_A0445057)
Date: Wed, 12 Dec 2012 20:12:05 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Daniel Golle <dgolle@allnet.de>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, helmut.schaa@googlemail.com,
	gwingerde@gmail.com, john@phrozen.org
Subject: Re: [PATCH 1/3] rt2x00: allow overriding eeprom through platform_data
References: <20121211100350.GA7813@earthship.arig> <20121212073627.GB2253@redhat.com>
In-Reply-To: <20121212073627.GB2253@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.12. 8:36 keltezéssel, Stanislaw Gruszka írta:
> Hi 
> 
> I have one additional question:
> 
> On Tue, Dec 11, 2012 at 12:03:53PM +0200, Daniel Golle wrote:
>> +	if (rt2x00_is_soc(rt2x00dev) ||
>> +	    test_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags))
>> +		rt2800pci_read_eeprom_file(rt2x00dev);
> Is || correct here ?

There are various embedded boards where a Ralink WiFi chip is soldered directly
onto the PCB and that does not have a separate EEPROM. The EEPROM data is stored
in the main flash of the board. The '||' allows to load the EEPROM data via
firmware API for such PCI devices as well.

However, the condition can be simplified. The REQUIRE_EEPROM_FILE bit is always
set for SoC devices, so the 'rt2x00_is_soc(rt2x00dev) ||' part is superfluous.

Given the fact that the patch must be reworked, this part will go away anyway
probably.

-Gabor
