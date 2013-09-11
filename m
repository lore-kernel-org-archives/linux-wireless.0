Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:40695 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab3IKTAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 15:00:09 -0400
Received: by mail-ea0-f181.google.com with SMTP id d10so4880866eaj.12
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 12:00:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: correct way to reduce traffic needed for LED triggering
Date: Wed, 11 Sep 2013 21:00:05 +0200
Message-ID: <2087752.rTT3R1h3WM@debian64> (sfid-20130911_210022_953524_31302F7F)
In-Reply-To: <5230B721.40104@rempel-privat.de>
References: <5230B721.40104@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 September 2013 20:32:01 Oleksij Rempel wrote:
> what is correct way to reduce IO needed for LED blinking? I did it with 
> ieee80211_queue_delayed_work(.., &priv->led-work, msecs_to_jiffird(HZ));
> 
> or are there other way to regulate it?
Yes, you can offload some "blinking" overhead by implementing
blink_set in led_classdev (aka "priv->led_cdev").

<http://lxr.free-electrons.com/source/include/linux/leds.h#L61>

(Of course, you'll have to add the "blink" routines into
the FW. But that shouldn't be much of a problem).

If you need some inspiration: rt2x00, iwlegacy and iwlwifi
are using blink_set.

Regards,

Christian
