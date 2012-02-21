Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35259 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab2BUTNB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 14:13:01 -0500
Message-ID: <4F43EC77.6030409@hauke-m.de> (sfid-20120221_201315_036266_0F5570A9)
Date: Tue, 21 Feb 2012 20:11:51 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, m@bues.ch
Subject: Re: [RFC] b43: fix memory leak on bcm5354
References: <1329781099-17342-1-git-send-email-hauke@hauke-m.de> <4F42EBFC.4060307@lwfinger.net>
In-Reply-To: <4F42EBFC.4060307@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2012 01:57 AM, Larry Finger wrote:
> On 02/20/2012 05:38 PM, Hauke Mehrtens wrote:
>> When using the bcm5354 with a recent firmware>= 478.104 it runs into a
>> memory very shortly after doing an active scan or any thing else where
> 
> You are missing a word after memory.
It leaked to somewhere else. ;-)

>> packages are send. This was cased by a gpio misconfiguration, the
>> firmware triggered the GPIO pins used for buttons on some devices and
>> that caused an other driver (OpenWrt diag) listening for these buttons
>> to send many user space messages.
>> This patch fixes the bug for my devices (Asus WL-520GU) and makes it
>> work with firmware 666.2, but I do not know if this patch is correct.
>> The spec for this part is out of date:
>> http://bcm-specs.sipsolutions.net/GPIO
> 
> I just updated the specs based on additional info I found. Everything I
> see say that there are 4 bits for the LEDs. Do you have a source for
> what you posted below?
Thanks for updating the spec, but this is nothing special for the
bcm5354. My device just has one WLAN LED, like many SoCs.

>> GPIO pin layout:
>> pin#    name    type
>> 0    power    led
>> 1    wlan    led
>> 2    reset    button
>> 3    ses    buttom

This is from the Asus WL-520GU section of the the OpenWrt diag driver
[0] and I verified it myself on this device.

>> related nvram configuration:
>> wl0gpio2=11
>> wl0gpio3=11
>> wl0gpio0=11
>> wl0gpio1=0x02
>> reset_gpio=2

This was extracted from the nvram of the Asus W-520GU with "nvram show
|grep gpio". This was a used device, so I do not know if someone else
already did some modifications to the nvram.

Hauke

[0]: https://dev.openwrt.org/browser/trunk/package/broadcom-diag/src/diag.c
