Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41715 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2FRM0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 08:26:06 -0400
Received: by eeit10 with SMTP id t10so1539583eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 05:26:04 -0700 (PDT)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: ath9k bug in country domain handling
Date: Mon, 18 Jun 2012 14:25:58 +0200
Message-ID: <4283314.5zPdis6seJ@sylvesterjr.cmi.ua.ac.be> (sfid-20120618_142610_876335_C2307D8F)
In-Reply-To: <4FDE1EF5.9030805@gmail.com>
References: <4FDE1EF5.9030805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 June 2012 20:16:21 Xose Vazquez Perez wrote:
> Erwin Van de Velde wrote:
> > I have 802.11n cards with an atheros chipset with no default country
> > domain. Upon initialization, crda is set to US domain, after which I try
> > to change it to another domain, the driver only accepts further
> > limitations: i.e. if a channel is allowed in the US but not in Belgium,
> > it is disabled, but the other way round: if a channel is not allowed in
> > the US, but is allowed in Belgium it is not enabled.
> 
> "no default country domain" :-???
> 
> # dmesg | grep ath:
> 
> look for:
> ath: EEPROM regdomain: XXX
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: XX
> ath: Regpair used: XXX
> 
> 
> This is a Atheros *driver* feature.
> Channels are restricted based on the EEPROM value.
> And crda/wireless-regdb only can makes things _worse_.

The output I get is:
[ 8.931463] ath: EEPROM regdomain: 0x0
[ 8.931483] ath: EEPROM indicates default country code should be used
[ 8.931502] ath: doing EEPROM country->regdmn map search
[ 8.931526] ath: country maps to regdmn code: 0x3a
[ 8.931544] ath: Country alpha2 being used: US
[ 8.931561] ath: Regpair used: 0x3a

As I see it, the regdomain is 00 and not US, so why does the ath9k driver 
decide to put me in the US? US should not be the default country code, but 
world reg domain. The preferred solution in my opinion is that the driver 
would require a regdomain to be given if it is not already set by the card. 
Choosing US as a default seems purely random . It would make far more sense to 
have no restricions by default if no regdomain is given and require it as a 
parameter, so everyone can set it correctly to his correct domain. The current 
method not only disallows valid channels to be used, but can also allow for 
legally forbidden channels to be used, which could be even worse.

Regards,
Erwin

