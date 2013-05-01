Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39889 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3EAUKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:10:14 -0400
Received: by mail-ie0-f171.google.com with SMTP id e11so2372937iej.30
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:10:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:10:14 +0200
Message-ID: <CAL1gcdNQc1-vrxv5LGp3rtcLDPhNRqnCqedYRZdt+V4PSc71rg@mail.gmail.com> (sfid-20130501_221019_122904_FC988757)
Subject: Re: [PATCH 0/7] rt2x00: avoid a few superfluous pointer dereferences
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor,


On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Gabor Juhos (7):
>   rt2x00: rt2x00dev: use rt2x00dev->tx->limit
>   rt2x00: rt61pci: use rt2x00dev->tx->limit
>   rt2x00: rt2800pci: use rt2x00dev->tx->limit
>   rt2x00: rt2800usb: use rt2x00dev->rx->limit
>   rt2x00: rt2800lib: use rt2x00dev->bcn->winfo_size
>   rt2x00: rt2x00dev: defer operational mode detection
>   rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
>
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   36 +++++++++++++++----------------
>  drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
>  5 files changed, 22 insertions(+), 22 deletions(-)
>

Thanks for these. Although they are micro optimizations, I guess it is
cleaner to use
the actual queue data rather than the queue description data.

I've acked all patches, but I'm afraid they may have come just too
late to be included in
the 3.10 timeframe, but I leave it up to John to decide.

---
Gertjan
