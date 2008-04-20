Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43490 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYDTS5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 14:57:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: compat-wireless-2008-04-20 doesn't build on armv5te (xscale)
Date: Sun, 20 Apr 2008 20:57:17 +0200
Cc: lrodriguez@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <480B8E70.4030703@hauke-m.de>
In-Reply-To: <480B8E70.4030703@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804202057.17607.mb@bu3sch.de> (sfid-20080420_195748_813231_278925B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 20 April 2008 20:41:52 Hauke Mehrtens wrote:
> I have tried to build the full compat-wireless-2008-04-20 for OpenWRT on
> Intel ixp4xx Platfrom (armv5te, xscale), but I got the following error.
> The parts before this were all like on the ofter architectures.
> This was made with gcc 4.1.2 and kernel 2.6.24.2
> 
> 
>   CC [M]
> /build_dir/linux-ixp4xx_generic/compat-wireless-2008-04-20/net/wireless/nl80211.o
>   LD [M]
> /build_dir/linux-ixp4xx_generic/compat-wireless-2008-04-20/net/wireless/cfg80211.o
>   Building modules, stage 2.
>   MODPOST 37 modules
> FATAL:
> /build_dir/linux-ixp4xx_generic/compat-wireless-2008-04-20/drivers/net/wireless/b43/b43:
> sizeof(struct ssb_device_id)=6 is not a modulo of the size of section
> __mod_ssb_device_table=64.
> Fix definition of struct ssb_device_id in mod_devicetable.h
> make[6]: *** [__modpost] Error 1
> make[5]: *** [modules] Error 2
> make[5]: Leaving directory `/build_dir/linux-ixp4xx_generic/linux-2.6.24.2'
> make[4]: *** [modules] Error 2
> 
> 

This is a bug in file2alias.c
A fix is already sent upstream. It might be in -mm. I'm not sure.


-- 
Greetings Michael.
