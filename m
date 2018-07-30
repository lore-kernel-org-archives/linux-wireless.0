Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbeG3Plz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 11:41:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 5/6] qtnfmac: add support for PTA configuration
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
        <20180531091102.28666-6-sergey.matyukevich.os@quantenna.com>
Date: Mon, 30 Jul 2018 17:06:41 +0300
In-Reply-To: <20180531091102.28666-6-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Thu, 31 May 2018 12:11:01 +0300")
Message-ID: <87d0v4stqm.fsf@codeaurora.org> (sfid-20180730_160648_223893_B62570FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> From: Andrey Shevchenko <ashevchenko@quantenna.com>
>
> Implement support for PTA (Packet Traffic Arbitration) configuration.
> The PTA mechanism is used to coordinate sharing of the medium between
> WiFi and other 2.4 wireless networks, e.g. Bluetooth or ZigBee.
>
> This patch implements core infrastructure and vendor specific commands
> to control PTA functionality in firmware.

And no description of the actual interface which would have helped with
the review.

Anyway, the vendor commands are pain and they just make me grumpy. The
original idea was that upstream drivers should not support them at all,
later we flexed the rules so that low level hardware specific interfaces
might be ok, for example we added one in wil6210.

If I would even consider applying a patch which adds a vendor command it
needs a really good commit log with a proper description of the actual
interface and good justifications why a generic nl80211 command won't
work. I don't see anything even remotely close here.

Sorry for being grumpy, I just hate these vendor commands. Especially
when I see that a generic nl80211 command has not even be consired at
all.

-- 
Kalle Valo
