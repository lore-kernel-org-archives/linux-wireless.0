Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3145 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab1EZJbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 05:31:08 -0400
Message-ID: <4DDE1DD0.4000404@broadcom.com> (sfid-20110526_113126_630586_4AC70E85)
Date: Thu, 26 May 2011 11:30:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC V1] lib: cordic: add library module for cordic angle
 calculation
References: <1306352426-1899-1-git-send-email-arend@broadcom.com>
 <4DDD6801.4010100@lwfinger.net>
In-Reply-To: <4DDD6801.4010100@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2011 10:35 PM, Larry Finger wrote:
> On 05/25/2011 02:40 PM, Arend van Spriel wrote:
>> The brcm80211 driver in the staging tree has a cordic function to
>> determine cosine and sine for a given angle. Feedback received from
>> John Linville suggested that these kind of functions should be made
>> available to others as a library function in the kernel tree.
> There is a similar routine in b43, thus this library function will likely have
> at least 2 users.

I know (forgot to mention it in the commit message). Henry Ptasinski 
(broadcom colleague) actually verified both functions against Matlab 
implementation (or Scilab, if you prefer open-source ;-) ). The b43 
version has a more limited range of the angle input in which the 
calculation is accurate.

>> +static const s32 AtanTbl[] = {
> In Documentation/CodingStyle, variables with mixed-case names are frownid upon.

No frowning needed. I will change it ;-)

>
>> +/*
>> + * cordic_calc_iq() - calculates the i/q coordinate for given angle
>> + *
>> + * theta: angle in degrees for which i/q coordinate is to be calculated
>> + * coord: function output parameter holding the i/q coordinate
>> + */
>> +void cordic_calc_iq(s32 theta, struct cordic_iq *coord)
> As "coord" is only for output, why not have this be a function returning a
> struct cordic_iq?

Only to avoid passing the structure over the stack. Given the fact that 
it is only 8 bytes (4 bytes extra) I think it is ok to change it.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


