Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:53607 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3K0XE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 18:04:27 -0500
Message-ID: <e5eb6ce01eb4d27cae5636e00f036936.squirrel@www.codeaurora.org> (sfid-20131128_000430_426755_18F2E78A)
In-Reply-To: <1380194106.14806.2.camel@jlt4.sipsolutions.net>
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
    <1379446296-22236-2-git-send-email-clanctot@codeaurora.org>
    <1380194106.14806.2.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Nov 2013 23:04:26 -0000
Subject: Re: [PATCH 1/2] nl80211/cfg80211: Driver with AP SME advertises need
 for PMF SA Query
From: clanctot@codeaurora.org
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Chet Lanctot" <clanctot@codeaurora.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2013-09-17 at 12:31 -0700, Chet Lanctot wrote:
>> Needed for drivers that have AP SME integrated but do not implement
>> The SA Query procedure that is part of Protected Management Frames
>> (PMF, 802.11w).  Instead, the need for upper layer software to do
>> this procedure is advertised through nl80211/cfg80211.
>>
>> Signed-off-by: Chet Lanctot <clanctot@codeaurora.org>
>> ---
>>  include/uapi/linux/nl80211.h | 11 ++++++++---
>>  net/wireless/nl80211.c       |  3 ++-
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index eb68735..aa1d122 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -1891,6 +1891,9 @@ enum nl80211_iftype {
>>   * @NL80211_STA_FLAG_ASSOCIATED: station is associated; used with
>> drivers
>>   *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
>>   *	previously added station into associated state
>> + * @NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED: no SA Query procedure is
>> needed
>> + *	when an association request is received from a station with which
>> there
>> + *	is already a MFP connection
>
> I don't understand this part, and also why is it part of the *station*
> info? Shouldn't it be part of the new-station event or something like
> that? How can it be valid when reading station info later?
>
> johannes
>
>

Johannes,

Thank you for your feedback.

>From your comment I can see I did not make clear the purpose of this flag.

“no SA Query required” will be set for the station after the station is
associated with the AP and after the driver has delivered a unprotected
Re/Association Request from the station to hostapd for which hostapd will
initiate an SA Query procedure.  If the SA Query procedure times out (no
response is received) then this “no SA Query required” state will be set
for the station to inform the driver that it should accept the next
Re/Association Request from the station and process it in the normal way.

I will try to make the code comment for this flag clearer.  I will also
try to clarify the commit text to make the change easier to understand.

          - Chet Lanctot



