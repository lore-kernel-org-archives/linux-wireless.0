Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15495 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2CIXlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 18:41:15 -0500
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sujith <m.sujith@gmail.com>
Subject: RE: [PATCH 4/6] mac80211: remove spurious BSSID change flag
Date: Fri, 9 Mar 2012 23:40:21 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC8801E2B156@aphydexd01b> (sfid-20120310_004119_475114_0D0169B3)
References: <20120308140202.751490800@sipsolutions.net>
	 <20120308140227.133587480@sipsolutions.net>
	 (sfid-20120308_150328_058540_9FB5A49A),<1331223217.1598.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331223217.1598.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> The BSSID has been set a lot earlier already and
>> didn't change again in ieee80211_set_associated().
>>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>>  net/mac80211/mlme.c |    3 ---
>>  1 file changed, 3 deletions(-)
>>
>> --- a/net/mac80211/mlme.c     2012-03-08 13:55:16.000000000 +0100
>> +++ b/net/mac80211/mlme.c     2012-03-08 13:55:22.000000000 +0100
>> @@ -1351,9 +1351,6 @@ static void ieee80211_set_associated(str
>>        */
>>       bss_info_changed |= BSS_CHANGED_BASIC_RATES;
>>
>> -     /* And the BSSID changed - we're associated now */
>> -     bss_info_changed |= BSS_CHANGED_BSSID;
>
> Sujith tells me that this will break ath9k -- Rajkumar, can you take a
> look at this? Before your commit 99e4d43ad5ff5778f92ee3bc40a29a ath9k
> did listen to BSS_CHANGED_ASSOC -- it seems like it should again?

Sorry for the late reply. I changed back to ASSOC to configure bss info and verified w/ your changes.

-Rajkumar

