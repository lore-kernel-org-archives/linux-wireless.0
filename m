Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:55709 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZDCFQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 01:16:19 -0400
Received: by bwz17 with SMTP id 17so800359bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Apr 2009 22:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D59AA1.6030602@lwfinger.net>
References: <49D59AA1.6030602@lwfinger.net>
Date: Fri, 3 Apr 2009 07:16:01 +0200
Message-ID: <ac3eb2510904022216g43e3c03cy1f3fed67b0663e21@mail.gmail.com> (sfid-20090403_071621_427989_563B2148)
Subject: Re: Directory in sysfs being truncated
From: Kay Sievers <kay.sievers@vrfy.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>, Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 3, 2009 at 07:12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The wireless driver b43legacy uses a leds-class entry to interact with the
> rfkill subsystem to control the radio LED. The name under which the LED is
> registered is "b43legacy-phy0::radio", which is 21 characters in length. When
> the corresponding directory is created in sysfs, the name is truncated to 19
> characters due to the "#define BUS_ID_SIZE 20" statement in include/linux/device.h.
>
> Marcel Holtmann wrote that he understood that this limitation will be
> eliminated, and suggested that I contact you regarding this matter. I was
> thinking of changing the driver so as to be able to control the naming; however,
> if this limitation will be relaxed then I will just wait.

The limit is gone already:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1fa5ae857bb14f6046205171d98506d8112dd74e

Kay
