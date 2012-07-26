Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47246 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2GZGKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 02:10:35 -0400
Received: by wibhr14 with SMTP id hr14so1534844wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 23:10:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XFjiofydQef-7GaUvZKXrH8Wx1sb1mh5j2jTHxh5bvd6NK5w@mail.gmail.com>
References: <1343283361-4050-1-git-send-email-zajec5@gmail.com>
	<CA+XFjiofydQef-7GaUvZKXrH8Wx1sb1mh5j2jTHxh5bvd6NK5w@mail.gmail.com>
Date: Thu, 26 Jul 2012 08:10:34 +0200
Message-ID: <CACna6ryQ4eV62Fsjn6jBOVasu2BX4C=CxRz_TacVVQ4MVJUxrA@mail.gmail.com> (sfid-20120726_081038_374176_58929B43)
Subject: Re: [PATCH V3] b43: be more user friendly with PHY info
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/26 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Thu, Jul 26, 2012 at 8:16 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
>> First of all, use PHY names instead of magic numbers. It should make
>> configuring kernel easier in case of not enabled PHY type support.
>> Secondly, always print info about PHY. This is really basic info about
>> hardware and quite important for the support level.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> V2: add new PHYTYPEs
>> V3: don't printk error in b43_phy_name, just return "UNKNOWN". We still
>>     can know PHY type thanks to change in caller, which prints both:
>>     %d and %s. Thanks Joe!
>> ---
>>  drivers/net/wireless/b43/b43.h  |    2 ++
>>  drivers/net/wireless/b43/main.c |   39 ++++++++++++++++++++++++++++++++++-----
>>  2 files changed, 36 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
>> index 7c899fc..b0c7f47 100644
>> --- a/drivers/net/wireless/b43/b43.h
>> +++ b/drivers/net/wireless/b43/b43.h
>> @@ -415,6 +415,8 @@ enum {
>>  #define B43_PHYTYPE_HT                 0x07
>>  #define B43_PHYTYPE_LCN                        0x08
>>  #define B43_PHYTYPE_LCNXN              0x09
>> +#define B43_PHYTYPE_LCN40              0x0a
>> +#define B43_PHYTYPE_AC                 0x0b
>>
>>  /* PHYRegisters */
>>  #define B43_PHY_ILT_A_CTRL             0x0072
>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
>> index b80352b..a8f812b 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -4277,6 +4277,35 @@ out:
>>         return err;
>>  }
>>
>> +static char *b43_phy_name(struct b43_wldev *dev, u8 phy_type)
>> +{
>> +       switch (phy_type) {
>> +       case B43_PHYTYPE_A:
>> +               return "A";
>> +       case B43_PHYTYPE_B:
>> +               return "B";
>> +       case B43_PHYTYPE_G:
>> +               return "G";
>> +       case B43_PHYTYPE_N:
>> +               return "N";
>> +       case B43_PHYTYPE_LP:
>> +               return "LP";
>> +       case B43_PHYTYPE_SSLPN:
>> +               return "SSLPN";
>> +       case B43_PHYTYPE_HT:
>> +               return "HT";
>> +       case B43_PHYTYPE_LCN:
>> +               return "LCN";
>> +       case B43_PHYTYPE_LCNXN:
>> +               return "LCNXN";
>> +       case B43_PHYTYPE_LCN40:
>> +               return "LCN40";
>> +       case B43_PHYTYPE_AC:
>> +               return "AC";
>> +       }
>> +       return "UNKNOWN";
>
> How about putting the PHY type ID into the string in the Unknown case?
> Or will it be printed somewhere else?

Hm, maybe I don't see something obvious. How would you do that? Using
which function?

-- 
Rafał
