Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34019 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab2BYO3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 09:29:17 -0500
Received: by wibhm11 with SMTP id hm11so493061wib.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Feb 2012 06:29:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F48D997.1060400@hauke-m.de>
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
	<4F48D997.1060400@hauke-m.de>
Date: Sat, 25 Feb 2012 15:29:15 +0100
Message-ID: <CACna6rysAAEdowZagwnis6W20tcpbtc05jE_ongzcMPEMDBfeg@mail.gmail.com> (sfid-20120225_152947_681531_B0B54E40)
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for SPROM storage
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Saul St. John" <saul.stjohn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/25 Hauke Mehrtens <hauke@hauke-m.de>:
> On 02/23/2012 10:52 PM, Arend van Spriel wrote:
>> +#define BCMA_CC_OTPL                 0x001C          /* OTP layout */
>> +#define  BCMA_CC_OTPL_GURGN_OFFSET   0x00000FFF      /* offset of general use region */
>>  #define BCMA_CC_IRQSTAT                      0x0020
>>  #define BCMA_CC_IRQMASK                      0x0024
>>  #define       BCMA_CC_IRQ_GPIO               0x00000001      /* gpio intr */
>> @@ -79,6 +84,10 @@
>>  #define       BCMA_CC_IRQ_WDRESET            0x80000000      /* watchdog reset occurred */
>>  #define BCMA_CC_CHIPCTL                      0x0028          /* Rev >= 11 only */
>>  #define BCMA_CC_CHIPSTAT             0x002C          /* Rev >= 11 only */
>> +#define  BCMA_CC_CHIPST_4313_SPROM_PRESENT   1
>> +#define  BCMA_CC_CHIPST_4313_OTP_PRESENT     2
>> +#define  BCMA_CC_CHIPST_4331_SPROM_PRESENT   2
>> +#define       BCMA_CC_CHIPST_4331_OTP_PRESENT        4
>>  #define BCMA_CC_JCMD                 0x0030          /* Rev >= 10 only */
>>  #define  BCMA_CC_JCMD_START          0x80000000
>>  #define  BCMA_CC_JCMD_BUSY           0x80000000
>
> What is the correct way to format this file? BCMA_CC_JCMD_BUSY uses two
> spaces after the define and BCMA_CC_OTPS_CID_PROTECT uses a tabulator
> and a space, what is the correct or intended way to format this? This
> does not have directly something to do with this patches as both ways
> are currently coded in this file.

I tried to use two spaces, I didn't mean to add tabs after "define".
If I did, it was done by a mistake.

I also used to use hexadecimal numbers for values (like
BCMA_CC_CHIPST_4331_OTP_PRESENT):
0x00000004 rather than 4

I don't really have any arguments for that choice, I've just copied
ssb (and b43?) coding style. However keeping one styles sounds
reasonable.

-- 
Rafał
