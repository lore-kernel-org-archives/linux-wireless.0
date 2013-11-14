Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45333 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3KNKP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 05:15:26 -0500
Received: by mail-lb0-f178.google.com with SMTP id y6so1366719lbh.9
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 02:15:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384378173.28806.22.camel@jlt4.sipsolutions.net>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	<1384366379-25301-6-git-send-email-mcgrof@do-not-panic.com>
	<1384378173.28806.22.camel@jlt4.sipsolutions.net>
Date: Thu, 14 Nov 2013 11:15:25 +0100
Message-ID: <CALhHN=r4y+JDw9_i9FdKwNoHgic+bvkMJRpYwnaXoSK519Metw@mail.gmail.com> (sfid-20131114_111531_475319_5A1171AE)
Subject: Re: [RFC 5/5] cfg80211: DFS check dfs_region before usage
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, j@w1.fi,
	sunitb@qca.qualcomm.com, rsunki@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 November 2013 22:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2013-11-13 at 19:12 +0100, Luis R. Rodriguez wrote:
>> Check the DFS region before channel availability check
>> or declaring a channel as DFS usable.
>>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
>> ---
>>  net/wireless/chan.c    | 8 ++++++++
>>  net/wireless/nl80211.c | 5 +++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
>> index 78559b5..4e6eaa0 100644
>> --- a/net/wireless/chan.c
>> +++ b/net/wireless/chan.c
>> @@ -517,10 +517,18 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>>       struct ieee80211_sta_ht_cap *ht_cap;
>>       struct ieee80211_sta_vht_cap *vht_cap;
>>       u32 width, control_freq;
>> +     enum nl80211_dfs_regions dfs_region;
>>
>>       if (WARN_ON(!cfg80211_chandef_valid(chandef)))
>>               return false;
>>
>> +     rtnl_lock();
>> +     dfs_region = reg_get_dfs_region(wiphy);
>> +     rtnl_unlock();
>


Do we need check dfs_region in cfg80211_can_beacon() at all?
We already check first if all channels NL80211_DFS_AVAILABLE.
To be DFS_AVAILABLE we need pass CAC, and we will fail CAC if
dfs_region == UNSET.

Anyway we can do something like this in cfg80211_can_beacon()

        if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
-           cfg80211_chandef_dfs_available(wiphy, chandef)) {
+           cfg80211_chandef_dfs_available(wiphy, chandef) &&
+           reg_get_dfs_region(wiphy) != NL80211_DFS_UNSET) {
...
And change doc that cfg80211_can_beacon() require rtnl_lock.
But I think this is not required.

BR
Janusz
