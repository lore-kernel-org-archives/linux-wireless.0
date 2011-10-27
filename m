Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62004 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1J0Bje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 21:39:34 -0400
Received: by vcge1 with SMTP id e1so2015720vcg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 18:39:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG6FYh6dPVQuvoTQsOAqbe_WrMMj7qji8T45DWmdrk-RNb-Bw@mail.gmail.com>
References: <CAMG6FYh6dPVQuvoTQsOAqbe_WrMMj7qji8T45DWmdrk-RNb-Bw@mail.gmail.com>
Date: Wed, 26 Oct 2011 21:39:33 -0400
Message-ID: <CAEKwDSDBf6kXYp6hdqgHoUORAEkQOJrJmrsqXg6BVQTQvEYwxg@mail.gmail.com> (sfid-20111027_033938_237987_98DFA698)
Subject: Re: How to enable clock/power from a wlan device driver
From: Bob Copeland <me@bobcopeland.com>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2011 at 8:35 AM, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
> 3. Driver can call platform callback and request platform code to
> enable the clock.

> For my understanding clocks and power are platform-specific.

Beats me what is best for your needs, but in light of the above it
seems #3 fits the bill?

This is the way other wireless drivers have done it -- e.g. wl12xx has
a set_power() callback and the platform device uses it to disable the
clock when the device is in low power mode.

-- 
Bob Copeland %% www.bobcopeland.com
