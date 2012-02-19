Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58631 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab2BST2y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 14:28:54 -0500
Message-ID: <4F414D63.1070409@hauke-m.de> (sfid-20120219_202857_851406_729A8C47)
Date: Sun, 19 Feb 2012 20:28:35 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, arend@broadcom.com
Subject: Re: [PATCH 04/11] ssb: add ccode
References: <1329676345-15856-1-git-send-email-hauke@hauke-m.de> <1329676345-15856-5-git-send-email-hauke@hauke-m.de> <20120219194923.566f3fe8@milhouse>
In-Reply-To: <20120219194923.566f3fe8@milhouse>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2012 07:49 PM, Michael Büsch wrote:
> On Sun, 19 Feb 2012 19:32:18 +0100
> Hauke Mehrtens <hauke@hauke-m.de> wrote:
> 
>> This member contains the country code encoded with two chars
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  include/linux/ssb/ssb.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
>> index 4928419..44e486e 100644
>> --- a/include/linux/ssb/ssb.h
>> +++ b/include/linux/ssb/ssb.h
>> @@ -33,6 +33,7 @@ struct ssb_sprom {
>>  	u8 et1mdcport;		/* MDIO for enet1 */
>>  	u16 board_rev;		/* Board revision number from SPROM. */
>>  	u8 country_code;	/* Country Code */
>> +	char ccode[2];		/* Country Code as two chars like EU or US */
> 
> This usually is referred to as "alpha2". So we should name it like that, too.
I can not find any references to "alpha2" in the spec, the broadcom
code, ssb, bcma or b43. ccode was the name broadcom gave this value so I
took it.
http://bcm-v4.sipsolutions.net/SPROM wrongly maps ccode to country_code,
but cc is stored into country_code in ssb.

Hauke
