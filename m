Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55441 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZHAUi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 16:38:58 -0400
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
From: Marcel Holtmann <marcel@holtmann.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <1249152859-14769-1-git-send-email-mjg@redhat.com>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 13:38:53 -0700
Message-Id: <1249159133.3491.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthew,

> Most laptops have keys that are intended to toggle all device state, not
> just wifi. These are currently generally mapped to KEY_WLAN. As a result,
> rfkill will only kill or enable wifi in response to the key press. This
> confuses users and can make it difficult for them to enable bluetooth
> and wwan devices.
> 
> This patch adds a new keycode, KEY_RFKILL_ALL. It indicates that the
> system should toggle the state of all rfkillable devices.

actually I would prefer if we name this key KEY_RFKILL and not put the
policy of ALL into the kernel. Since we wanna get rid of rfkill-input.
That needs to be done in userspace and by users policy. If they wanna
map that key to ALL then that is fine. If they just wanna toggle WiFi,
then that is also fine. If the wanna have to popup some UI, that is also
reasonable.

So just having a KEY_RFKILL is the better way here and policy free. You
can still for the short term have rfkill-input map this to an ALL policy
until we remove that piece and replace it with a proper userspace
solution (which thanks to /dev/rfkill is now possible).

Regards

Marcel


