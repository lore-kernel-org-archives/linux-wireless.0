Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35431 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbZJ2R3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 13:29:31 -0400
Received: by pwj9 with SMTP id 9so176055pwj.21
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 10:29:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0D107966AF6D79418315B7C5549F4B5101150D82@lemail1.le.imgtec.org>
References: <1256687501-8636-1-git-send-email-andrey@cozybit.com>
	 <0D107966AF6D79418315B7C5549F4B5101150D82@lemail1.le.imgtec.org>
Date: Thu, 29 Oct 2009 10:29:36 -0700
Message-ID: <45e8e6c40910291029nac07e96o5ea7cc95b2e24917@mail.gmail.com>
Subject: Re: [PATCH] libertas: remove internal buffers from GSPI driver
From: Andrey Yurovsky <andrey@cozybit.com>
To: George Shore <George.Shore@imgtec.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	sebatian@breakpoint.cc, dcbw@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks George,

On Thu, Oct 29, 2009 at 7:27 AM, George Shore <George.Shore@imgtec.com> wrote:
> I've tested this on our in-house dev board with our in-house CPU, on the
> 8686 in GSPI mode. Everything works as expected :)
>
> Tested-by: George Shore <george.shore@imgtec.com>

Can you please tell us what you were able to test?  I'm curious about:
1) were you able to turn IEEE PS on and off?
2) were you able to use WPA2?
3) were you able to use WPA2 with IEEE PS at the same time?

(3) is really tricky and may need additional work.  One issue that I'm
seeing is that the driver gets out of sync with the device, the way
I'm reproducing this is:

1) use wpa_supplicant to associate to an AP with WPA2 security.
2) iwconfig eth1 power on -- you should see the LED blinking to
indicate IEEE PS (the LED is off while the device is sleeping)
3) issue a command or two to temporarily take the device out of IEEE
PS mode (ex: iwconfig with no arguments to look at the configuration
and stats)
4) the LED should be temporarily solid-on and then return to blinking
after the driver re-enables IEEE PS mode

Thanks again,

  -Andrey
