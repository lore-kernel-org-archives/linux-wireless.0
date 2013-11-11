Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43236 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3KKLBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 06:01:13 -0500
MIME-Version: 1.0
In-Reply-To: <CABPxzY+MkosJBeQdBFV3u5X=e5io3qKeb6sqd8Fn89awMc2vuA@mail.gmail.com>
References: <1384119945-31213-1-git-send-email-felipe.contreras@gmail.com>
	<CABPxzY+MkosJBeQdBFV3u5X=e5io3qKeb6sqd8Fn89awMc2vuA@mail.gmail.com>
Date: Mon, 11 Nov 2013 05:01:11 -0600
Message-ID: <CAMP44s3xycqUAxvporp6cmjCqyXg_T07Ee5zKUpnhdQGUhsmLQ@mail.gmail.com> (sfid-20131111_120118_414721_7841D9CC)
Subject: Re: [PATCH v2] mac80211: add assoc beacon timeout logic
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 12:41 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Mon, Nov 11, 2013 at 3:15 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> We don't want to be waiting forever for a beacon that will never come,
>> just continue the association.
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>
>> The previous version depended on some cleanup patches, plus had some unclear
>> rerun logic.
>>
>>  net/mac80211/ieee80211_i.h |  1 +
>>  net/mac80211/mlme.c        | 32 ++++++++++++++++++++++++++------
>>  2 files changed, 27 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index 611abfc..e1f858d 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -358,6 +358,7 @@ struct ieee80211_mgd_assoc_data {
>>         const u8 *supp_rates;
>>
>>         unsigned long timeout;
>> +       unsigned long beacon_timeout;
>>         int tries;
>>
>>         u16 capability;
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 86e4ad5..68f76f7 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -38,6 +38,7 @@
>>  #define IEEE80211_ASSOC_TIMEOUT                (HZ / 5)
>>  #define IEEE80211_ASSOC_TIMEOUT_LONG   (HZ / 2)
>>  #define IEEE80211_ASSOC_TIMEOUT_SHORT  (HZ / 10)
>> +#define IEEE80211_ASSOC_BEACON_TIMEOUT 2 * HZ
>
> Don't you think its too long? 3-4 beacon intervals should suffice.

I don't have an opinion, if you think that's better, that's fine by me.

-- 
Felipe Contreras
