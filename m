Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.iopen.co.nz ([202.6.116.226]:54081 "EHLO mail.iopen.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1IVDUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 23:20:34 -0400
Message-ID: <4E7AA97D.40402@iopen.net> (sfid-20110922_052049_213489_E35F6C44)
Date: Thu, 22 Sep 2011 15:20:29 +1200
From: Linux Wireless Stuff for IOPEN <linwir-list@iopen.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [wireless-regdb] Update regulatory rules for New Zealand (NZ)
References: <4E73F3FA.502@iopen.net> <20110919141340.GB2608@tuxdriver.com>
In-Reply-To: <20110919141340.GB2608@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2011 02:13 AM, John W. Linville wrote:
> On Sat, Sep 17, 2011 at 01:12:26PM +1200, Linux Wireless Stuff for IOPEN wrote:
>> From Fedora 14 :
>> ==============
>>
>>> country NZ:
>>>         (2402 - 2482 @ 40), (N/A, 30)
>>>         (5170 - 5250 @ 20), (3, 23)
>>>         (5250 - 5330 @ 20), (3, 23), DFS
>>>         (5735 - 5835 @ 20), (3, 30)
>>
>> Updates for 2.4 GHz :
>> ===================
>>
>>   Frequency range is 2400 to 2483.5 (Ref 1)
>>   Maximum EIRP is 36 dBm (4 W)      (Ref 1)
>>
>> Updates for 5 GHz :
>> =================
>>
>>   5150 - 5250  23 dBm (200 mW) indoor only            (Ref 1,3)
>>   5250 - 5350  23 dBm (200 mW) indoor/outdoor,DFS+TPC (Ref 1,3)
>>   5725 - 5875  36 dBm (  4  W) PtMP/PtP               (Ref 1,3)
>>   5725 - 5825  53 dBm (200  W) PtP fixed              (Ref 1,2,3)
>>
>>   And possibly this via the Spread Spectrum Device provision
>>
>>   5470 - 5725  30 dBm (  1  W) requires DFS+TPC       (Ref 3)
>>
>>   Maximum power density is specified for some chunks.
>>
>> References :
>> ==========
>> 1 :
>>> http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/fixed-radio-link-devices/information-on-the-operation-of-wireless-lan-and-related-systems-in-the-2-ghz-and-5-ghz-bands
>> 2 :
>>> http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/fixed-radio-link-devices
>> 3 :
>>> http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/short-range-devices
>>
>> Cheers
>> The IOPEN wireless deployers
> 
> Thanks for the info.  Any chance you could propose this in the form
> of a patch?

TaDa!

kernel.org is still down so we've derived the below patch from ...

> http://linuxwireless.org/download/wireless-regdb/wireless-regdb-2011.04.28.tar.bz2

For the DFS items, if TPC isn't used the maximum power is 3 dB less, but
there's no way of representing that in your scheme.

-----CUT-----
*** db.txt      2011-04-29 07:17:40.000000000 +1200
--- db-updated.txt      2011-09-22 14:36:04.966154148 +1200
***************

*** 512,521 ****
        (5735 - 5835 @ 40), (N/A, 30)

  country NZ:
!       (2402 - 2482 @ 40), (N/A, 30)
!       (5170 - 5250 @ 20), (3, 23)
!       (5250 - 5330 @ 20), (3, 23), DFS
!       (5735 - 5835 @ 20), (3, 30)

  country OM:
        (2402 - 2482 @ 40), (N/A, 20)
--- 512,523 ----
        (5735 - 5835 @ 40), (N/A, 30)

  country NZ:
!       (2400 - 2483 @ 40), (N/A, 36)
!       (5150 - 5250 @ 40), (N/A, 23), NO-OUTDOOR
!       (5250 - 5350 @ 40), (N/A, 23), DFS
!       (5470 - 5725 @ 40), (N/A, 30), DFS
!       (5725 - 5875 @ 40), (N/A, 36)
!       (5725 - 5825 @ 40), (N/A, 53), PTP-ONLY

  country OM:
        (2402 - 2482 @ 40), (N/A, 20)
-----CUT-----

Cheers
The IOPEN wireless deployers
