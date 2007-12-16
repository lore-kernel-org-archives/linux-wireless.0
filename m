Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37097 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXLPU2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 15:28:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: b43 problem with led trigger registration
Date: Sun, 16 Dec 2007 21:26:56 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Richard Purdie <rpurdie@openedhand.com>
References: <1197822019.4138.2.camel@johannes.berg> <200712162036.11084.mb@bu3sch.de> <1197835176.6769.21.camel@johannes.berg>
In-Reply-To: <1197835176.6769.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712162126.56483.mb@bu3sch.de> (sfid-20071216_202857_142162_714C346E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 December 2007 20:59:36 Johannes Berg wrote:
> 
> > I have no idea where we enter atomic state.
> 
> Uh huh...
> 
> drivers/leds/led-triggers.c:led_trigger_register:
> 
> |        read_lock(&leds_list_lock);
> |        list_for_each_entry(led_cdev, &leds_list, node) {
> |                down_write(&led_cdev->trigger_lock);
> 
> introduced in
> 
> commit dc47206e552c0850ad11f7e9a1fca0a3c92f5d65
> Author: Richard Purdie <rpurdie@rpsys.net>
> Date:   Sat Nov 10 13:29:04 2007 +0000
> 
>     leds: Fix led trigger locking bugs
> 
> I guess the read_lock needs to be a mutex/rw semaphore.

Uh, yes. Was this patch tested at all?

-- 
Greetings Michael.
