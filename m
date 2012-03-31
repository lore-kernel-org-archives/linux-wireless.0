Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60407 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2CaCBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 22:01:15 -0400
Received: by dake40 with SMTP id e40so165491dak.11
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2012 19:01:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ8GFOihCt_JBPoawk2xKOO6wan_03F9LLwhsOAbmAKXSs0ygg@mail.gmail.com>
References: <CAJ8GFOihCt_JBPoawk2xKOO6wan_03F9LLwhsOAbmAKXSs0ygg@mail.gmail.com>
Date: Fri, 30 Mar 2012 19:01:14 -0700
Message-ID: <CAJ-Vmok1qzkHVhJescbuEwz8OzfeqpHg5RC=vk4XA1KEqAGeKQ@mail.gmail.com> (sfid-20120331_040118_860466_C93F4F11)
Subject: Re: Dual-band support for AP mode for AR9280?
From: Adrian Chadd <adrian@freebsd.org>
To: Harshal Chhaya <harshal@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 March 2012 14:04, Harshal Chhaya <harshal@gmail.com> wrote:
> Hello,
>
> The 'ath9k' project page
> (http://linuxwireless.org/en/users/Drivers/ath9k) mentions that '2x2
> DB 11n' operation is supported for AR9280. A later section says that
> 'AP mode' is supported.

These are both true.

> Does the AP mode support full 11n features in a dual-band
> configuration? Is there a hard limit to the number of clients when the
> AR9280 is used as an AP? I am currently using an AR9170 (using
> carl9170 - thanks, Christian) as an AP and found that I had to switch
> to software encryption to scale beyond 32 clients because of the
> number of key slots on the chip.

Yes. It's a dual band chip, but you only get to choose one band at a time.

Yes, there are limited keycache slot chips. I don't remember if the
hardware limit is 32 or 64 clients.

> And are the numbers in the 'power consumption' analysis
> (http://linuxwireless.org/en/users/Drivers/ath9k/power-consumption)
> for STA mode or AP mode? The 'PS On' configuration implies that this
> is for an STA mode but I wanted to confirm.

You should always do your own power consumption tests. It differs
based on operating mode, environment, TX rate selection/power, what
kind of amplifiers and other circuitry are on the NIC, etc.



Adrian
