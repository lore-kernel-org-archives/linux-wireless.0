Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from frosty.hhs.nl ([145.52.2.15]:45700 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbXHWQBZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:01:25 -0400
Received: from exim (helo=frosty)
	by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>)
	id 1IODzI-000407-67
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 16:48:44 +0200
Received: from [145.52.8.13] (port=53589 helo=hhs.nl)
	by frosty.hhs.nl with esmtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>)
	id 1IODzH-0003zu-NM
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 16:48:43 +0200
Message-ID: <46CD9B54.4090100@hhs.nl>
Date: Thu, 23 Aug 2007 16:36:04 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <200708201351.45575.chunkeey@web.de> <46CD6E5F.9040601@hhs.nl> <200708231643.43741.chunkeey@web.de>
In-Reply-To: <200708231643.43741.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Thursday, 23. August 2007, Hans de Goede wrote:
>> Maybe it would be an idea to dump the eeprom from the driver with the 2.4.12.0 
>> firmware, and then fake the eeprom in the driver using newer firmware to see if 
>> the eeprom reading is the only problem with newer firmware and my card ?
> 
> Hmm, I don't think that the firmware somehow changes the eeprom.
> 

I think you misunderstood me. The driver fails to load when using newer 
firmware with a "can not read eeprom" error. So I have the idea to add a couple 
of printk's printing all the important bits from the eeprom using the 2.4.12.0 
firmware, then modify the driver to hardcode these bits from the eeprom in to 
the driver and then try newer firmware with the driver with the hardcoded bits 
in. This way I want to see if the reading of the eeprom is the only problem, or 
if there are other problems too when using newer firmware. Does this sound like 
a plan or is it a waste of time?

Regards,

Hans



