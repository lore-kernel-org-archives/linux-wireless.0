Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:46345 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbaJUNTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 09:19:24 -0400
Received: by mail-ig0-f181.google.com with SMTP id r10so1288562igi.8
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 06:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413895856.1998.6.camel@jlt4.sipsolutions.net>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	<21568.29077.518022.812356@gargle.gargle.HOWL>
	<1413797588.10246.3.camel@jlt4.sipsolutions.net>
	<21572.55536.308167.684155@gargle.gargle.HOWL>
	<1413798712.10246.14.camel@jlt4.sipsolutions.net>
	<21572.58249.490532.207564@gargle.gargle.HOWL>
	<1413801423.10246.16.camel@jlt4.sipsolutions.net>
	<21572.60015.349942.74265@gargle.gargle.HOWL>
	<1413806542.10246.21.camel@jlt4.sipsolutions.net>
	<1413809136.24269.0.camel@jlt4.sipsolutions.net>
	<21573.55666.43231.68176@gargle.gargle.HOWL>
	<1413873729.1998.2.camel@jlt4.sipsolutions.net>
	<CAB3XZEd8xCieC8xhOw=V0rHtJadYBKwe9NjwkNsmAmXqiL4ZRQ@mail.gmail.com>
	<1413895856.1998.6.camel@jlt4.sipsolutions.net>
Date: Tue, 21 Oct 2014 16:19:23 +0300
Message-ID: <CAB3XZEcFh1-=bS0T9=fA2n8Z2FedMirFATfqA_S9Y1YSqQT9zA@mail.gmail.com> (sfid-20141021_151927_429310_CC6631F4)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2014 at 3:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-10-21 at 15:27 +0300, Eliad Peller wrote:
>
>> This patch actually solves a kernel panic that can be reproduced
>> easily by increasing the delay in ieee80211_scan_completed() and
>> removing the driver right after initiating a scan - the delayed
>> scan_work never gets flushed, resulting in invalid memory access, etc.
>
> Yeah I thought about that too - we flush the workqueue but if the timer
> hasn't yet fired you can get issues.
>
> OTOH, the delay there is 0, so the workqueue code doesn't even arm the
> timer but rather puts the work on the workqueue immediately. Therefore
> flush_work() should be enough?
>
> Or did you not test with something like
>
> @@ -357,7 +357,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
>         set_bit(SCAN_COMPLETED, &local->scanning);
>         if (aborted)
>                 set_bit(SCAN_ABORTED, &local->scanning);
> -       ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
> +       ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 1);
>
yeah, that's how i tested it (with a larger delay).

you're right about the delay=0.
(this might not be enough if scan_work is already delayed_queued, but
i currently don't see how this can happen)

anyway, the patch looks good.

Eliad.
