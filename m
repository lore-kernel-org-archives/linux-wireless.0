Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37093 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHSM61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 08:58:27 -0400
From: Vincent Donnefort <vdonnefort@gmail.com>
To: hughd@google.com, cooloney@gmail.com
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH] leds: make led_blink_set IRQ safe
Date: Tue, 19 Aug 2014 14:58:20 +0200
Message-Id: <1408453101-30290-1-git-send-email-vdonnefort@gmail.com> (sfid-20140819_145858_790862_65FA3E06)
In-Reply-To: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
References: <alpine.LSU.2.11.1408161946450.1064@eggly.anvils>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hugh,

Here's a patch which must fix your problem. It allows to call led_blink_set()
from on IRQ handler by adding a work to take care of the scheduling function 
cancel_delayed_work_sync().

Regards,
Vincent.

Vincent Donnefort (1):
  leds: make led_blink_set IRQ safe

 drivers/leds/led-class.c | 19 +++++++++++++++++++
 drivers/leds/led-core.c  | 16 +---------------
 include/linux/leds.h     |  1 +
 3 files changed, 21 insertions(+), 15 deletions(-)

-- 
1.9.1

