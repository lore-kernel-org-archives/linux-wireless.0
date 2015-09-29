Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37651 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477AbbI2QiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 12:38:22 -0400
Received: by wicfx3 with SMTP id fx3so24658054wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2015 09:38:21 -0700 (PDT)
To: sgruszka@redhat.com
Cc: linux-wireless@vger.kernel.org
From: Pascal Huerst <pascal.huerst@gmail.com>
Subject: rt2x00: Firmware loading vs. udev rules
Message-ID: <560ABE7B.1080109@gmail.com> (sfid-20150929_183830_017761_74676D2B)
Date: Tue, 29 Sep 2015 18:38:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Stanislaw, all,

on rt2x00 devices, firmware gets loaded in:

int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)

which is called, when we start the interface by:

ifconfig wlan0 up

I need to lower tx power of the device and created a udev rule for that:

KERNEL=="wlan0", RUN+="/usr/sbin/iw dev wlan0 set txpower fixed 1800"

Obviously this does not work, since the firmware is not loaded, yet.

Is there a reason, why the firmware is loaded so late and not earlier in
probe or so?
Can this be done in any other proper way I don't know about?
I think the device should be ready for any operation, when the udev rule
triggers, right?

regards
Pascal
