Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 007.netroom.de ([194.0.247.207]:17336 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324AbZKDRlV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:41:21 -0500
Message-ID: <4AF1BCC3.8070205@draisberghof.de>
Date: Wed, 04 Nov 2009 18:41:23 +0100
From: Josua Dietze <digidietze@draisberghof.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Frank Schaefer <schaefer.frank@gmx.net>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <Pine.LNX.4.44L0.0911041204540.2968-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911041204540.2968-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern schrieb:

> On Wed, 4 Nov 2009, Johannes Berg wrote:
> 
>> I think you forgot to consider the case where both the driver and the
>> mode switch code need an update to handle a new device. This is relevant
>> in the case where a new device shows up that needs mode-switching, but
>> even after switching has an ID that the current driver doesn't know
>> about.
> 
> This could be handled by programs like usb_modeswitch.  The USB serial 
> drivers allow IDs to be added dynamically.
> 
> Of course, if something more than that is required then the situation 
> would be different.  However I think this is pretty rare.

So far, mostly cdc_acm and high speed serial devices are known. 
There is the special case of the HSO interface for "Option" modems 
which resembles a network device IIRC. But switching them is pretty 
straightforward and driver support by the manufacturer seems to be OK.
I don't know of any "switching" devices which are completely 
unsupported by the recent kernels.

usb_modeswitch now has a wrapper which loads the "option" module by 
default if the "new" device will not be claimed by "cdc_acm", "hso" 
or "option". Using the "new_id" feature *any* ID can be used with it 
right away.


Josua Dietze
-- 
Man is the only creature on earth enabled to take a
warm meal while flying!                      Loriot
