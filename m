Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55839 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZHZPPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:15:24 -0400
Date: Wed, 26 Aug 2009 11:03:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Richard Farina <sidhayn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
	enabled
Message-ID: <20090826150323.GA2807@tuxdriver.com>
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net> <4A94B01E.9040309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4A94B01E.9040309@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 11:46:38PM -0400, Richard Farina wrote:
> Larry Finger wrote:
>> When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
>> may oops when the module is unloaded as the workqueue for led_on was
>> not being cancelled.
>>
>> This patch fixes the problem reported in
>> http://marc.info/?l=linux-wireless&m=124742957615781&w=2.
>>
>> Reported-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
>> ---
>>
>> V2 - Do not create a new workqueue.
>>
>> John,
>>
>> This patch is 2.6.31 material. To the best of my knowledge, a formal bug
>> report was never filed; however, it was reported in the reference given above.
>>
>>   
> Anyone know what happened here? This bug still seems very much alive in  
> compat-wireless-2.6.31-rc7.  I know the window is closed and this really
> isn't "earthshattering" but a kernel panick is kind of "a big deal".  I  
> seems like it was tested doing a proper modprobe -r but not if you just  
> unplug the usb card.
> When I unplug the usb I get instadeath, very uncool.  If someone can  
> teach me how to get the kernel output from a non-functional system I am  
> happy to provide whatever.

commit 3da7429ce92abd79b14e2275a28be144ce2c3013
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Tue Jul 14 15:55:16 2009 -0500

    rtl8187: Fix for kernel oops when unloading with LEDs enabled
    
    When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
    may oops when the module is unloaded as the workqueue for led_on was
    not being cancelled.
    
    This patch fixes the problem reported in
    http://marc.info/?l=linux-wireless&m=124742957615781&w=2.
    
    Reported-by: Gábor Stefanik <netrolller.3d@gmail.com>
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

The above commit is in linux-2.6 since v2.6.31-rc2.  If it isn't in
compat-wireless, I have no idea why.

Hth...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
