Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41013 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab3EAUld (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:41:33 -0400
Message-ID: <51817E10.2000906@openwrt.org> (sfid-20130501_224137_162592_AB0CBD77)
Date: Wed, 01 May 2013 22:41:52 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 0/7] rt2x00: avoid a few superfluous pointer dereferences
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org> <CAL1gcdNQc1-vrxv5LGp3rtcLDPhNRqnCqedYRZdt+V4PSc71rg@mail.gmail.com>
In-Reply-To: <CAL1gcdNQc1-vrxv5LGp3rtcLDPhNRqnCqedYRZdt+V4PSc71rg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gertjan,

> On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> Gabor Juhos (7):
>>   rt2x00: rt2x00dev: use rt2x00dev->tx->limit
>>   rt2x00: rt61pci: use rt2x00dev->tx->limit
>>   rt2x00: rt2800pci: use rt2x00dev->tx->limit
>>   rt2x00: rt2800usb: use rt2x00dev->rx->limit
>>   rt2x00: rt2800lib: use rt2x00dev->bcn->winfo_size
>>   rt2x00: rt2x00dev: defer operational mode detection
>>   rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
>>
>>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
>>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>>  drivers/net/wireless/rt2x00/rt2x00dev.c |   36 +++++++++++++++----------------
>>  drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
>>  5 files changed, 22 insertions(+), 22 deletions(-)
>>
> 
> Thanks for these. Although they are micro optimizations, I guess it is 
> cleaner to use the actual queue data rather than the queue description data.

To be honest, I made these patches in preparation of queue descriptor data
removal. However these changes are not strictly related to that, so I posted the
patches as a separate series.

> I've acked all patches, 

Thanks!

> but I'm afraid they may have come just too late to be included in
> the 3.10 timeframe, but I leave it up to John to decide.

No problem, the patches can wait for 3.11.

-Gabor
