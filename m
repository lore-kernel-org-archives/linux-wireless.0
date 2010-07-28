Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23666 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0G1SKI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 14:10:08 -0400
Subject: Re: [BUG] after starting wimaxd at boot iwlagn module will crash
 for intel 6250 card
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: alexxy@gentoo.org
Cc: wimax@linuxwimax.org, linux-wireless@vger.kernel.org
In-Reply-To: <201007282154.06383.alexxy@gentoo.org>
References: <201007280028.48674.alexxy@gentoo.org>
	 <1280270313.26204.288.camel@localhost.localdomain>
	 <201007282154.06383.alexxy@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 11:09:57 -0700
Message-ID: <1280340597.26204.300.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexey

On Wed, 2010-07-28 at 21:53 +0400, Alexey Shvetsov wrote: 
> Updated relevant part of logs for this bug
> 

My concern here is that I am not seeing why the i2400m is failing to
initialize; there are no i2400m relevant messages. If I remember
correctly, over IRC you said that a grep of messages for i2400m only
turned:

Jul 22 16:20:03 x201 kernel: i2400m_usb: probe of 2-1.3:1.0 failed with
error -22

It that's the case, I missed to make the code properly report an error
condition, and we need to find out which one is it.

Can you enable debugging?:

1. unload the i2400m and i2400m-usb modules
2. $ modprobe i2400m debug='driver:8 control:3'
3. $ modprobe i2400m-usb debug='usb:8'

that should be printing way more logs to the console


