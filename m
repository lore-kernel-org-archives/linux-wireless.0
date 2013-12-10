Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60188 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3LJWHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 17:07:39 -0500
Message-ID: <3121017861fe910940c6b44994156635.squirrel@www.codeaurora.org> (sfid-20131210_230742_728644_B467BB63)
In-Reply-To: <CA+XVXfc1ryVcfqsMOc_592iEGYmpP4x3F_w88-10Ky4YG7zZmQ@mail.gmail.com>
References: <1386045985-2398-1-git-send-email-clanctot@codeaurora.org>
    <1386045985-2398-2-git-send-email-clanctot@codeaurora.org>
    <CA+XVXfc1ryVcfqsMOc_592iEGYmpP4x3F_w88-10Ky4YG7zZmQ@mail.gmail.com>
Date: Tue, 10 Dec 2013 22:07:38 -0000
Subject: Re: [PATCH 1/2 V2] nl80211/cfg80211: Add support for drivers with AP
 SME that require PMF SA Query assistance
From: clanctot@codeaurora.org
To: "Arik Nemtsov" <arik@wizery.com>
Cc: "Chet Lanctot" <clanctot@codeaurora.org>,
	"John Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik,

Thank you for catching this and passing it along.  Yes, it is not non
purpose.  It is due to an error when I entered the changes. 
NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED is the correct name, but it should
have been that name from the beginning.

I also noticed that I did not break the changes up between the two commits
correctly.  I have fixed that.

I will now send out a new set of patch files for review.

-	Chet


> On Tue, Dec 3, 2013 at 6:46 AM, Chet Lanctot <clanctot@codeaurora.org>
> wrote:
>> This adds support for drivers that have AP SME integrated but do
>> not implement the SA Query procedure that is part of Protected
>> Management Frames (PMF, 802.11w).
>>
>> Instead, hostapd can be used to assist drivers that lack SA Query
>> Procedure handling on their own by allowing them to specify this as
>> a device capability flag.
>>
>> Also, a station flag is added to let hostapd indicate to the driver
>> that the SA Query procedure is complete and the driver can process
>> association requests from the station normally.
> [...]
>>   * enum nl80211_feature_flags - device/driver features
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 587ff84..14a14d4 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -3766,7 +3766,8 @@ int cfg80211_check_station_change(struct wiphy
>> *wiphy,
>>                                   BIT(NL80211_STA_FLAG_ASSOCIATED) |
>>                                   BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
>>                                   BIT(NL80211_STA_FLAG_WME) |
>> -                                 BIT(NL80211_STA_FLAG_MFP)))
>> +                                 BIT(NL80211_STA_FLAG_MFP) |
>> +
>> BIT(NL80211_STA_FLAG_SA_QUERY_REQUIRED)))
>
> I didn't really read the patch, but noticed you're adding
> NL80211_STA_FLAG_SA_QUERY_REQUIRED here and changing it to
> NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED in the next one.
> Pretty sure that's not on purpose :)
>
> Arik
>


