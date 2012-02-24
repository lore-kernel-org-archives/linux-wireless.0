Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4586 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2BXKj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 05:39:29 -0500
Message-ID: <4F4768D0.4030109@broadcom.com> (sfid-20120224_113946_190994_AFCFACFE)
Date: Fri, 24 Feb 2012 11:39:12 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <CACna6rwk8xbjbX7uisqAv_y_JYn636orR-VLgNQ908yOYS+i1A@mail.gmail.com>
In-Reply-To: <CACna6rwk8xbjbX7uisqAv_y_JYn636orR-VLgNQ908yOYS+i1A@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2012 08:52 AM, Rafał Miłecki wrote:
>> +               srom_control = bcma_read32(bus->drv_cc.core,
>> >  +                                          BCMA_CC_SROM_CONTROL);
>> >  +               return !!(srom_control&  BCMA_CC_SROM_CONTROL_PRESENT);
> Does any compiler complain on returning sth like 0xF as a bool?
>

The compiler probably will not complain, but the caller could have 
following:

if (bcma_sprom_ext_available(bus) == true) {
	return;
}
BUG();

I guess you would see the BUG show up in your log with the function 
returning 0xF.

Gr. AvS

