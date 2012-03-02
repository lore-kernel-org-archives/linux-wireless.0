Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514Ab2CBIuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 03:50:16 -0500
Subject: Re: [PATCH 21/21] cw1200: Kconfig + Makefile for the driver.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1330652495-25837-22-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024231_185549_5ECA663F)
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
	 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
	 <1330652495-25837-22-git-send-email-dmitry.tarnyagin@stericsson.com>
	 (sfid-20120302_024231_185549_5ECA663F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 09:50:13 +0100
Message-ID: <1330678213.8542.6.camel@jlt3.sipsolutions.net> (sfid-20120302_095021_187751_6786205C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 02:41 +0100, Dmitry Tarnyagin wrote:

> +if CW1200

I don't think that's necessary with the "depends on?"

> +config CW1200_STANDALONE
> +      bool "Build a standalone cw1200 driver"
> +      depends on CW1200
> +      help
> +        Say Y here if you would like to build a standalone cw1200 driver,
> +        not associated with any platform. Likely you wil not be able to use
> +	it for any purposes.
> +        If unsure, say N.

typo "will", and some indentation issue

> +config CW1200_USE_STE_EXTENSIONS
> +      bool "STE extensions"
> +      depends on CW1200
> +      help
> +        Say Y if you want to include experimental code or code with
> +	not resolved dependency.
> +        If unsure, say N.

This seems questionable. Maybe you should get rid of it for now and
explain what is needed and extend the APIs as needed?

> +config CW1200_WAPI_SUPPORT
> +      bool "WAPI support"
> +      depends on CW1200_USE_STE_EXTENSIONS
> +      help
> +        Say Y if your compat-wireless support WAPI.
> +        If unsure, say N.

This is unnecessary. You can always advertise support for SMS4. Also, it
really shouldn't be talking about compat-wireless here since you're
submitting this driver for upstream :-)

> +config CW1200_DISABLE_BEACON_HINTS
> +      bool "Disable 11d beacon hints"
> +      depends on CW1200
> +      help
> +        Say Y if you want to disable 11d beacon hints.
> +        If unsure, say N.

I don't understand this -- beacon hints or not should be your decision
based on how the device works wrt. regulatory, not the users?

> +config CW1200_BH_DEBUG
> +      bool "Enable low-level device communication logs (DEVELOPMENT)"
> +      help
> +        Say Y if you want to enable BH logs.
> +        If unsure, say N.

What does "BH" stand for here? In the kernel it typically stands for
Bottom Half (or softirq) but that can't be meant? In other places in
your code you do mean that though, it seems, so this is a bit confusing.

> +config CW1200_WSM_DEBUG
> +      bool "Enable WSM API debug messages (DEVELOPMENT)"
> +      help
> +        Say Y if you want to enable WSM logs.
> +        If unsure, say N.
> +
> +config CW1200_WSM_DUMPS
> +      bool "Verbose WSM API logging (DEVELOPMENT)"
> +      help
> +        Say Y if you want to enable WSM dumps.
> +        If unsure, say N.

You should think about adding tracing instead.

> +config CW1200_WSM_DUMPS_SHORT
> +      depends on CW1200_WSM_DUMPS
> +      bool "Dump only first x bytes (default 20) (DEVELOPMENT)"
> +      help
> +        Say Y if you want to limit amount of data printed in WSM dumps.
> +        If unsure, say N.

Then you also don't need this since tracing is really fast. On a core i3
I can trace full HT "line" rate. It's also a lot more powerful for
analysis tools. Yes I need to give a talk about this some time ;-)


johannes

