Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1979 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1KUSbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 13:31:17 -0500
Message-ID: <4ECA98DB.4030608@broadcom.com> (sfid-20111121_193120_588528_DC0F8F97)
Date: Mon, 21 Nov 2011 10:30:51 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm80211 (with bcm4329-chip)
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
 <4ECA8908.7070304@broadcom.com>
In-Reply-To: <4ECA8908.7070304@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 09:23 AM, Arend van Spriel wrote:
> On 11/21/2011 02:56 PM, Thomas Langås wrote:
>> Hi!
>>
>> I'm trying to make our board use this driver instead of an old,
>> proprietary bcm4329-driver, but I can't seem
>> to find much detail on how to tell the driver where my chip is located
>> (on what SDIO-bus).  I suppose there
>> is some specifics I need to include in my machine-file?  Or is
>> everything magic?  Because, currently
>> the platform crashes when enabling the driver. I suspect that this is
>> because we boot from an uSD-card,
>> and that the brcm80211 tries to access the same port for connecting to the chip.
>>
>
> The MMC core should be able to come up with the correct device. It
> sounds strange that the driver would be activated for an SD card.
>
> Could you provide some information on the board you are using. Type of
> processor, kernel version, and anything else you can/want to share. In
> /sys/bus/sdio/devices/ you may find the location of the bcm4329.

Current MMC stack in Linux would not confuse a MMC/SD card and a SDIO 
device. Basically the intialization and command sets they used are 
different.

Just for curiosity, do you know the version of your proprietary driver? 
You should be able to find it in epivers.h.

A crash log would be helpful to locate the issue.

Regards,
Franky


