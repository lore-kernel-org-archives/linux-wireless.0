Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38841 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754334AbZEUXWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 19:22:05 -0400
Message-ID: <4A15E219.7040908@gmx.de>
Date: Fri, 22 May 2009 01:22:01 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Stephen Chen <Stephen.Chen@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory	domain
 pair
References: <4A0802B0.9070206@gmx.de> <20090511190602.GC18696@tesla> <618D4DE9D5223A45A46C48063FD640451098774889@TAEXMB-01.global.atheros.com> <20090521171619.GB28691@tesla>
In-Reply-To: <20090521171619.GB28691@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/21/2009 07:16 PM, Luis R. Rodriguez wrote:

> Joerg, can you please try this patch, its just informative and I would
> like to see the output. A regulatory domain in the EEPROM set to 0x8000 
> should be cought, as you indicated, in this code:
> 
>         if (reg->country_code == CTRY_DEFAULT &&
>             regdmn == CTRY_DEFAULT)
>                 reg->country_code = CTRY_UNITED_STATES;
> 
> The debug prints should help.
 > ...
With the patch I get:

usb 1-5: firmware: requesting ar9170-2.fw
ath: EEPROM indicates we should expect a country code
ath: No regulatory domain pair found, cannot continue
ar9170usb: probe of 1-5:1.0 failed with error -22

IMHO the in the above if-statement regdmn == 0x8000 (as read from 
the EEPROM by ath_regd_get_eepromRD), but CTRY_DEFAULT is defined as 
zero, so reg->country_code isn't set.
Shouldn't we say "regdmn == (CTRY_DEFAULT|COUNTRY_ERD_FLAG)",because 
without the ERD flag set we cannot compare a regdomain with a 
country code?

/Joerg
