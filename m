Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp28.orange.fr ([80.12.242.99]:61960 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYFXU32 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 16:29:28 -0400
Message-ID: <48615925.8010203@crespel.net> (sfid-20080624_222931_372892_5499811B)
Date: Tue, 24 Jun 2008 22:29:25 +0200
From: Fabien Crespel <fabien@crespel.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by  	default
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>	 <1214252588-30723-5-git-send-email-hmh@hmh.eng.br>	 <g3quvb$8sa$1@ger.gmane.org>  <g3r9hn$av5$1@ger.gmane.org> <1214330213.23127.9.camel@localhost.localdomain>
In-Reply-To: <1214330213.23127.9.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote :
> On Tue, 2008-06-24 at 19:06 +0200, Fabien Crespel wrote:
>   
>> Indeed, I think it would be better to let the driver choose the default state 
>> (initialization) instead of forcing it when registering. This would allow drivers 
>> to restore the device state after a reboot or shutdown (provided the firmware 
>> stores it, which is the case at least on my ASUS F3JC laptop).
>>     
>
> Do you mean your laptop BIOS stores the value in nvram somewhere?  What
> specific driver reads that value back out?
>
> Dan
>   
Yes, the laptop BIOS stores the value. Reading it back is done the same 
way as reading the WLAN/BT status later (through an ACPI method), so the 
driver only has to read and write the status at initialization to 
restore the device status & LEDs (because the reported status doesn't 
reflect the hardware status at boot time).

- Fabien.

