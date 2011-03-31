Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45904 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1CaNs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 09:48:27 -0400
Message-ID: <4D948624.3040605@suse.cz>
Date: Thu, 31 Mar 2011 15:48:20 +0200
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	rmk+kernel@arm.linux.org.uk, devel@linuxdriverproject.org,
	gregkh@suse.de, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality
 in separate module
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz> <201103301453.48607.arnd@arndb.de>
In-Reply-To: <201103301453.48607.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2011 02:53 PM, Arnd Bergmann wrote:
> On Tuesday 29 March 2011, Jiri Slaby wrote:
>> On 03/29/2011 11:40 AM, Arend van Spriel wrote:
>>> --- /dev/null
>>> +++ b/drivers/brcmaxi/axi.c
>>> @@ -0,0 +1,786 @@
>> ...
>>> +/* resetctrl */
>>> +#define	AIRC_RESET		1
>>> +
>>> +/* definition for specifying padding fields */
>>> +#define	_PADLINE(line)	pad ## line
>>> +#define	_XSTR(line)	_PADLINE(line)
>>> +#define	PAD		_XSTR(__LINE__)
>>> +
>>> +/*
>>> + * struct aidmp - device management plugin "wrapper" registers.
>>> + */
>>> +struct aidmp {
>>
>> This looks like it should be __packed__.
> 
> Why that? Adding the packed attribute would enforce byte access but
> not change the layout of the structure, so I think that would make
> it worse not better.

How it can? Packed only tells the compiler to have one byte alignment
steps. And it should not matter here as all the members are 32-bit long.

The structure seems to be something which maps to device registers. So
for documentation purposes it should be packed. And to avoid later
mistakes when the u32 are broken down to u8s and u16s.

regards,
-- 
js
suse labs
