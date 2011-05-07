Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1900 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab1EGQaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 12:30:11 -0400
Message-ID: <4DC57383.3050903@broadcom.com> (sfid-20110507_183016_424964_8843F9FC)
Date: Sat, 7 May 2011 18:29:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Arnd Bergmann" <arnd@arndb.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"Greg KH" <greg@kroah.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"George Kashperko" <george@znau.edu.ua>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Russell King" <rmk@arm.linux.org.uk>,
	"Andy Botting" <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
 driver
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
 <201105061605.31625.arnd@arndb.de>
 <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
 <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
 <1304776555.16344.2.camel@maggie>
In-Reply-To: <1304776555.16344.2.camel@maggie>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2011 03:55 PM, Michael Büsch wrote:
>
>> Arnd: did you have a look at defines at all?
>>
>> Most of the defines have values in range 0x800 → 0x837. Converting
>> this to array means loosing 0x800 u16 entries. We can not use 0x800
>> offset, because there are also some defined between 0x000 and 0x800:
>> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
>> #define BCMA_CORE_INVALID              0x700
Please be aware that the core identifier itself is not unique (in the 
current list they are). In the scan the BCMA_CORE_OOB_ROUTER will always 
show BCMA_MANUF_ARM (did not look up the proper manufacturer define but 
you get the idea, i hope).

Gr. AvS

