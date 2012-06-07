Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42225 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095Ab2FGNdR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:33:17 -0400
Message-ID: <4FD0AD96.1050500@hauke-m.de> (sfid-20120607_153320_319833_9267A37F)
Date: Thu, 07 Jun 2012 15:33:10 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/18] brcmsmac: extend xmtfifo_sz array
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-15-git-send-email-hauke@hauke-m.de> <4FCF2FD4.6010103@broadcom.com>
In-Reply-To: <4FCF2FD4.6010103@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 12:24 PM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> The xmtfifo_sz array contains the queue sizes for the different chip
>> revs. This array missed the sizes for the core rev 17 and 28. This
> 
> Should probably use core revs instead of chip revs and I think we are
> talking about the 80211 core rev here.
Yes I will change this comment.

Are there any devices with the same phy type using different fifo sizes?
If this is not the case I think it is better to do this based on the phy
type.
> 
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>> @@ -268,7 +268,7 @@ struct brcms_c_bit_desc {
>>   */
>>  
>>  /* Starting corerev for the fifo size table */
>> -#define XMTFIFOTBL_STARTREV	20
>> +#define XMTFIFOTBL_STARTREV	10
> 
> Why not start the table at rev 17? I do not expect any lower revs to get
> brcmsmac support.
The 10 is a random number <=17. ;-)
I will change this to 17 then, makes sense.
> 
> Gr. AvS
> 

