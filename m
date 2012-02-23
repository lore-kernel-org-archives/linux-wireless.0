Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45221 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab2BWSOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 13:14:18 -0500
Received: by wics10 with SMTP id s10so944844wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 10:14:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329676345-15856-2-git-send-email-hauke@hauke-m.de>
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de>
	<1329676345-15856-2-git-send-email-hauke@hauke-m.de>
Date: Thu, 23 Feb 2012 19:14:17 +0100
Message-ID: <CACna6rwNEPY3iJCeWV3AmbBy7fQwQrgr9Oji6tro-Dr23y5udQ@mail.gmail.com> (sfid-20120223_191422_115029_DA554F43)
Subject: Re: [PATCH 01/11] ssb: sprom fix some sizes / signedness
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/19 Hauke Mehrtens <hauke@hauke-m.de>:
> @@ -53,10 +53,10 @@ struct ssb_sprom {
>        u8 gpio1;               /* GPIO pin 1 */
>        u8 gpio2;               /* GPIO pin 2 */
>        u8 gpio3;               /* GPIO pin 3 */
> -       u16 maxpwr_bg;          /* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
> -       u16 maxpwr_al;          /* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
> -       u16 maxpwr_a;           /* 5.3GHz Amplifier Max Power (in dBm Q5.2) */
> -       u16 maxpwr_ah;          /* 5.8GHz Amplifier Max Power (in dBm Q5.2) */
> +       u8 maxpwr_bg;           /* 2.4GHz Amplifier Max Power (in dBm Q5.2) */
> +       u8 maxpwr_al;           /* 5.2GHz Amplifier Max Power (in dBm Q5.2) */
> +       u8 maxpwr_a;            /* 5.3GHz Amplifier Max Power (in dBm Q5.2) */
> +       u8 maxpwr_ah;           /* 5.8GHz Amplifier Max Power (in dBm Q5.2) */
>        u8 itssi_a;             /* Idle TSSI Target for A-PHY */
>        u8 itssi_bg;            /* Idle TSSI Target for B/G-PHY */
>        u8 tri2g;               /* 2.4GHz TX isolation */

Just a note in case you're going to develop ssb/bcma/b43/brcm code.
Please note we're trying to switch from properties you modified to
struct ssb_sprom_core_pwr_info.

The patch still looks fine.

-- 
Rafał
