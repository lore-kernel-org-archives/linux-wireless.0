Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f173.google.com ([209.85.210.173]:63110 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZFPSt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:49:57 -0400
Received: by yxe3 with SMTP id 3so95745yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 11:49:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245177307.21287.34.camel@johannes.local>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
Date: Tue, 16 Jun 2009 11:42:10 -0700
Message-ID: <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Andrey Yurovsky <andrey@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 11:35 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-16 at 11:31 -0700, Andrey Yurovsky wrote:
>> Commit b2a151a288 added a check that prevents adding or deleting
>> stations on non-AP interfaces.  Adding and deleting stations is
>> supported for Mesh Point interfaces, so add Mesh Point to that check as
>> well.
>
> Why? Aren't those automatically discovered like IBSS peers?

Yes, they normally are, however it's possible to turn that off from
user space (via iw).

The reason for this is that it's useful to manually create mesh
topologies.  This is mostly for testing, verification, and
experimentation.  For example, you can manually create a topology
where you have two paths and you know one path is better than another
and then run a test script that verifies that the right path was
taken.  It could presumably also be used by some user-space "mesh
manager" similar to hostapd for APs.

  -Andrey

>> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
>> ---
>>  net/wireless/nl80211.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index e18856c..b28c641 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -1763,7 +1763,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
>>               goto out_rtnl;
>>
>>       if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>> -         dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
>> +         dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
>> +         dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
>>               err = -EINVAL;
>>               goto out;
>>       }
>> @@ -1812,7 +1813,8 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
>>               goto out_rtnl;
>>
>>       if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>> -         dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN) {
>> +         dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
>> +         dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
>>               err = -EINVAL;
>>               goto out;
>>       }
>
