Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62003 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaFJWFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 18:05:25 -0400
Received: by mail-lb0-f169.google.com with SMTP id s7so4370359lbd.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 15:05:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319017BCEBA@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A319017BCEBA@sbs2003.acksys.local>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 10 Jun 2014 15:05:04 -0700
Message-ID: <CAB=NE6UysThA_SOtoL-E5_+3wGsMA3af24vNN8EnS-bP6Wvd1w@mail.gmail.com> (sfid-20140611_000535_743902_1CA62C33)
Subject: Re: cfg80211: enable chanel with CRDA issue
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 3, 2014 at 6:14 AM, Cedric VONCKEN <cedric.voncken@acksys.fr> wrote:
>         Hi,
>
> I'm using a compat-wireless 2014-05-22 from openwrt.
> I changed the package/kernel/mac80211 Makefile to use the CRDA (I
> removed the CFG80211_INTERNAL_REGDB flags)
>
> My product boot on US regulatory domain. I set the FR regulatory domain
> with iw command.

Setting regulatory domain with iw is not what you want for a product,
using iw just helps compliance further meaning that it will likely end
up restricting your device further. If a device booted with a US
regulatory domain then it can mean that the device was programmed with
a US regulatory domain on the EEPROM / OTP / whatever, it all depends
on the driver you are using. Furthermore for ath9k / ath5k devices AP
manufacturers ended up programming tons of EEPROM / OTPs with a
regulatory domain set to 0x0, which for STA devices Atheros code
defaults that to mean "US". Users for products by these Atheros
customers had gotten the impression that Atheros supports setting
"0x0" to mean the debug regulatory domain, or to enable all channels,
and this is wrong -- Atheros gives out code and gives out stuff to
customers so that they program their hardware / calibrate it, if they
end up doing something funky its on them. Some APs then ship with 0x0
and default to US whereby they actually wanted to use regulatory
domain control in software. For OpenWrt then you're best off to enable
the hack they have that lets it override regulatory for those devices
but be careful, if its a product you certify it so its on you to do
the right thing.

For more details see:

http://wireless.kernel.org/en/users/Drivers/ath#The_0x0_regulatory_domain

  Luis
