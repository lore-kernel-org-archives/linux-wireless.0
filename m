Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37477 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbbJNWd6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 18:33:58 -0400
Received: by wijq8 with SMTP id q8so103103624wij.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 15:33:57 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	nbd@openwrt.org
Subject: [RFC] ath9k: Simplify and fix eeprom endianness swapping 
Date: Thu, 15 Oct 2015 00:33:31 +0200
Message-Id: <1444862012-25376-1-git-send-email-martin.blumenstingl@googlemail.com> (sfid-20151015_003404_999307_2D811DE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k has some code which is supposed to adjust the endianness of the
eeprom's contents in case it does not match the CPU endianness.
However, it seems that this code was only working properly for chips
that used eeprom_def.

I personally have a device with an AR9227 chipset which uses an
eeprom with "incorrect endianness".
Feeding ath9k with this eeprom results in "no band has been marked
as supported in EEPROM". An OpenWrt user has tried to work around
this and documented the required steps in a ticket: [0].

The original goal of my patch was to fix the eeprom endianness
handling. However, it seemed easier to take the existing (working)
code from eeprom_def and make it re-usable by the other eeprom
implementations (namely _9287 and _4k).

I have tested my patch on a single AR9227 device and there it's
working fine. It would be great if more people would give this a go
before merging this patch.


Regards,
Martin


[0] https://dev.openwrt.org/ticket/13924

