Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out21.han.skanova.net ([195.67.226.208]:50317 "EHLO
	smtp-out21.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934474Ab3E1PHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 11:07:52 -0400
Message-ID: <51A4C6D6.1020002@emagii.com> (sfid-20130528_170755_778759_E13B0285)
Date: Tue, 28 May 2013 17:01:42 +0200
From: Ulf Samuelsson <ntp@emagii.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ath6kl-devel@qualcomm.com
Subject: ath6kl_sdio blocked by RFKILL
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have built the ath6kl_sdio driver for an Cortex-A5 chip using the 
linux-3.6.9 kernel
File system built using Yocto  and Busybox RF-Kill.

Kernel Config contains:

CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set

When I do

# ifconfig wlan0 up.

I get the error message:

ifconfig: SIOCSIFFLAGS: Operation not possible due to RF-kill

If I run "rfkill list" I get

1: phy1: wlan
         Soft blocked: yes
         Hard blocked: no


If I try to unblock using "rfkill unblock all" or "wifi" or "wlan", the 
soft block remains.

Any clues?

Looking through the Busybox rfkill code, this seems to generate an event.
What is supposed to react to this?
Could there be a rule, which is missing?

BR
Ulf Samuelsson
