Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33552 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab2FQSQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2012 14:16:26 -0400
Received: by eeit10 with SMTP id t10so1345486eei.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2012 11:16:25 -0700 (PDT)
Message-ID: <4FDE1EF5.9030805@gmail.com> (sfid-20120617_201629_456776_12494CEC)
Date: Sun, 17 Jun 2012 20:16:21 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: erwin.vandevelde@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: ath9k bug in country domain handling
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erwin Van de Velde wrote:

> I have 802.11n cards with an atheros chipset with no default country domain.
> Upon initialization, crda is set to US domain, after which I try to change it
> to another domain, the driver only accepts further limitations: i.e. if a
> channel is allowed in the US but not in Belgium, it is disabled, but the other
> way round: if a channel is not allowed in the US, but is allowed in Belgium it
> is not enabled.

"no default country domain" :-???

# dmesg | grep ath:

look for:
ath: EEPROM regdomain: XXX
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: XX
ath: Regpair used: XXX


This is a Atheros *driver* feature.
Channels are restricted based on the EEPROM value.
And crda/wireless-regdb only can makes things _worse_.

Solutions:
- modify the driver
- reprogramming of the EEPROM
- buy another board and keep away from Atheros chipsets

You should read:
http://wireless.kernel.org/en/users/Drivers/ath#Regulatory
http://marc.info/?l=linux-wireless&m=125072768530674
http://marc.info/?l=linux-wireless&m=125078520924477
http://wiki.openwrt.org/doc/howto/wireless.utilities?s[]=regulatory#iw  see "Note:"

In linux source code, see regd* files:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=drivers/net/wireless/ath
