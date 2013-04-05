Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46890 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762185Ab3DEP0K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 11:26:10 -0400
Message-ID: <515EED2D.8090601@openwrt.org> (sfid-20130405_172614_525602_EA89EFEC)
Date: Fri, 05 Apr 2013 17:26:37 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/6] rt2x00: rt2400pci: use the rt2x00mmio_* routines
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org> <1365143225-24532-3-git-send-email-juhosg@openwrt.org> <20130405133234.GB1571@redhat.com>
In-Reply-To: <20130405133234.GB1571@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.04.05. 15:32 keltezéssel, Stanislaw Gruszka írta:
> On Fri, Apr 05, 2013 at 08:27:01AM +0200, Gabor Juhos wrote:
>> Use the recently introduced rt2x00mmio_* routines
>> instead of the rt2x00pci_* variants.
>>
>> The patch contains no functional changes.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
>> ---
>>  drivers/net/wireless/rt2x00/rt2400pci.c |  309 ++++++++++++++++---------------
> 
> Why do you modify rt2400pci ?

Because the rt2x00pci_* functions provided by the rt2x00mmio module has been
renamed in the first patch and those are using the rt2x00mmio_ prefix now. The
rt2x00mmio.h header provides definitions for the old function names but those
definitions are removed by the last patch.

Here is a quote from 1/6:

"The renamed functions are used by several modules,
and updating the names in all of them would result
in a big patch. In order to keep the patch simple,
add compatibility defines for the old function
names. This allows to update the names in each
module separately. After each module is updated,
the defines can be removed."

Should I merge the whole series into a single patch instead?

-Gabor
