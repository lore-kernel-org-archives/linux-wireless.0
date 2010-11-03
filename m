Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35677 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0KCVwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 17:52:07 -0400
Received: by wwi17 with SMTP id 17so1951823wwi.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 14:52:05 -0700 (PDT)
Message-ID: <4CD1D99D.5070501@lwfinger.net>
Date: Wed, 03 Nov 2010 16:52:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: workarounds: be verbose about hacking SPROM revision,
 don't duplicate code
References: <1288818386-25073-1-git-send-email-zajec5@gmail.com>	 (sfid-20101103_220727_407923_69716152) <1288820625.7368.117.camel@maggie>
In-Reply-To: <1288820625.7368.117.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2010 04:43 PM, Michael Büsch wrote:
> On Wed, 2010-11-03 at 22:06 +0100, Rafał Miłecki wrote: 
>> +	default:
>> +		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
>> +			   "  revision %d detected. Will extract"
>> +			   " v1\n", out->revision);
>> +		out->revision = 1;
>> +		sprom_extract_r123(out, in);
> 
> I think we should change this to throw a hard error if the sprom is
> unknown. Extracting r123 is unlikely to do any good these days.
> This workaround was only useful back in the days where 95% of the
> cards out there were r123. But today that's not the case.
> 
>> 	}
>>  
>>  	if (out->boardflags_lo == 0xFFFF)

In any case, the out->revision = 1 statement should be before the ssb_printk() call.

I agree - throw a hard error.

Larry
