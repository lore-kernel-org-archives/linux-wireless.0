Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:48709 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3F0Nq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 09:46:27 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz10so672106veb.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 06:46:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ8GFOgCU7_8ETN2cn4m81y8afNyc8uPhxeJM63ON2sMaYX-mw@mail.gmail.com>
References: <CAJ8GFOgCU7_8ETN2cn4m81y8afNyc8uPhxeJM63ON2sMaYX-mw@mail.gmail.com>
Date: Thu, 27 Jun 2013 08:46:26 -0500
Message-ID: <CAJ8GFOik_wXLeorTNbfrEQVgEY9cTjWvcSEbyZ__E5YoLn6V4Q@mail.gmail.com> (sfid-20130627_154630_751469_445D6CEC)
Subject: Re: Timer rollback in beacons on AR9342-based AP
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 17, 2013 at 11:42 AM, Harshal Chhaya <harshal@gmail.com> wrote:
> On an AR9342-based AP, we occasionally see the TSF timer in beacons
> roll back i.e. the timer resets and starts over. This causes all
> clients to disconnect probably because their power-save timers get out
> of sync. This typically happens under heavy load.
...
> Any ideas on what could be causing the timer to reset? What kind of
> additional information would help in debugging this?


Additional analysis of the packets showed that this reset at the AP
was usually preceded by a flood of CRC errors i.e. it seems like a
conscious decision in response to a bad channel.

Can someone please verify this?

Further analysis showed that these large number of CRC errors usually
happened when a large number of clients (30-60) were sending uplink
traffic. All the clients are either AR6102 or AR6203 devices. We are
trying to adjust the CCA threshold on the clients to see if that helps
reduce the CRC errors which in turn should avoid the timer reset on
the AP.

Are there any recommendations for what a reasonable value for the CCA
threshold should be?

Also, as another data-point our other AR9170-based AP doesn't reset
the timer but it does hold off on transmitting beacons for several
beacon intervals when these CRC errors occur.
This also causes 'beacon lost' events on the clients which sometimes
results in a disconnection.

Thanks,
- Harshal
