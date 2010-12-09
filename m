Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44603 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0LIOMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:12:53 -0500
Received: by vws16 with SMTP id 16so1565488vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 06:12:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291756117.27497.101.camel@maggie>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	<1291755360-21570-3-git-send-email-zajec5@gmail.com>
	<1291756117.27497.101.camel@maggie>
Date: Thu, 9 Dec 2010 15:12:52 +0100
Message-ID: <AANLkTinN_12RwWiugzxn5dB1he3b6h_y7K3C=8vFPyXO@mail.gmail.com>
Subject: Re: [PATCH 2/4] b43: set TMS to work with current band width for N-PHY
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 7 grudnia 2010 22:08 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Tue, 2010-12-07 at 21:55 +0100, Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/main.c       |    6 ++++++
>>  drivers/net/wireless/b43/phy_common.c |    7 +++++++
>>  drivers/net/wireless/b43/phy_common.h |    2 ++
>>  drivers/net/wireless/b43/phy_n.c      |    7 -------
>>  4 files changed, 15 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
>> index fa48803..670fd7b 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -1150,6 +1150,12 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
>>
>>       flags |= B43_TMSLOW_PHYCLKEN;
>>       flags |= B43_TMSLOW_PHYRESET;
>> +     if (dev->phy.type == B43_PHYTYPE_N) {
>> +             if (b43_channel_type_is_40mhz(dev->phy.channel_type))
>
> Is channel_type already set at this time?

Yeah, that core switching seems to be a little tricky. I didn't figure
it out completely yet. We may need to fix that, or fix calls to this
function.

Thanks for reviewing!

-- 
Rafał
