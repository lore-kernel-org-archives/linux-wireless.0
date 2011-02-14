Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61339 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab1BNKDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:03:37 -0500
Received: by qwa26 with SMTP id 26so2966246qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 02:03:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110207195301.GB2430@thinkpad-t410>
References: <20110131214515.GC6368@thinkpad-t410>
	<AANLkTikYS1EUdTc9mo2kvoR-S1Cv+WcKqkGaFDA8fR+0@mail.gmail.com>
	<AANLkTi=mRO99U5t3Z_gscuwix0X+brFhWtC=9nkytE+M@mail.gmail.com>
	<20110207041007.GA14242@thinkpad-t410>
	<20110207195301.GB2430@thinkpad-t410>
Date: Mon, 14 Feb 2011 11:03:36 +0100
Message-ID: <AANLkTikYJXzkjQKJbjpdS8m3XVjj+SpO8rjE6qhF4WY1@mail.gmail.com>
Subject: Re: Missing skb_pad() return value checks in rt2x00 driver
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Wolfgang Kufner <wolfgang.kufner@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Well this patch managed to slip through my list. :S

> From 4a8b3969775cd233750a1b74b1d4f5fc065932bf Mon Sep 17 00:00:00 2001
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Mon, 7 Feb 2011 13:50:33 -0600
> Subject: [PATCH] rt2x00: Check for errors from skb_pad() calls
>
> Commit 739fd94 ("rt2x00: Pad beacon to multiple of 32 bits")
> added calls to skb_pad() without checking the return value,
> which could cause problems if any of those calls does happen
> to fail. Add checks to prevent this from happening.

Thanks for the updated patch. I only have one small request.

> +       if (padding_len && skb_pad(entry->skb, padding_len)) {
> +               dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");

Please change to:
  ERROR(rt2x00dev, "Failure padding beacon, aborting\n");
same for the other changed drivers in this patch.

Thanks,

Ivo
