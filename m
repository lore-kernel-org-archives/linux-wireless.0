Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40022 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2GJRSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:18:47 -0400
Received: by pbbrp8 with SMTP id rp8so553601pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 10:18:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341933955.4475.24.camel@jlt3.sipsolutions.net>
References: <1341613226-11774-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341613226-11774-3-git-send-email-rodrigue@qca.qualcomm.com> <1341933955.4475.24.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 10 Jul 2012 10:18:26 -0700
Message-ID: <CAB=NE6UXvdK_cJYQZuaK6_AiQJ-_HeucwBSdYp5Z8EpAGj0Ozg@mail.gmail.com> (sfid-20120710_191850_967543_1954C5AF)
Subject: Re: [PATCH v3 2/3] cfg80211: add cellular base station regulatory
 hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 8:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-06 at 15:20 -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
>>
>> Cellular base stations can provide hints to cfg80211 about
>> where they think we are. This can be done for example by on
>> a cell phone.
>
> by what? :)

Fixed, thanks.

>> To enable these hints we simply allow them
>> through as user regulatory hints but we allow userspace
>> to clasify the hint. This option is only available for
>
> if you're going to respin ... classify

OK I'll add:

"To enable these hints we simply allow them
through as user regulatory hints but we allow userspace
to clasify the hint as either coming directly from the
user or coming from a cellular base station. "


>> system integrators which are willing to enable
>
> who are willing? not sure

I'll reword:

"This option is only available when you enable
CONFIG_CFG80211_CERTIFICATION_ONUS."

>> CONFIG_CFG80211_CERTIFICATION_ONUS.
>>
>> The base station hints themselves will not be processsed
>
> processed :)

Thanks, fixed.

>> by the core unless at least one device on the system
>> supports this feature.
>
> So ... yeah I guess this is fine. we don't really want to distinguish
> between the devices too much anyway. And I suspect that if you're in an
> environment where you allow plugging in random wireless devices you
> wouldn't enable this anyway.

Well even if you do the other "random" device would disregards the
cell base station hint unless it has the capability enabled.

>>   *   DFS master operation on a known DFS region (NL80211_DFS_*),
>>   *   dfs_region represents that region. Drivers can use this and the
>>   *   @alpha2 to adjust their device's DFS parameters as required.
>> + * @user_reg_hint_type: if the @initiator was of type
>> + *   %NL80211_REGDOM_SET_BY_USER, this clasifies the type
>
> classifies

OK fine, I need a spell checker :P

>> + *   of hint passed. This could be any of the %NL80211_USER_REG_HINT_*
>
> could be any of the ... "values"?

Sure, I'll use "types".

>>       /* set up regulatory info */
>> +     wiphy_regulatory_register(wiphy);
>>       regulatory_update(wiphy, NL80211_REGDOM_SET_BY_CORE);
>
> might make sense to move the regulatory_update() call into the new
> function, then it could become a static function?

Good point! In fact we can then nuke regulatory_update() all together,
I'll do this through 2 separate patches.

>> +++ b/net/wireless/nl80211.c
>> @@ -294,6 +294,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
>>       [NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
>>       [NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
>>       [NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
>> +     [NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U8 },
>
> I think u32 makes more sense, u8 doesn't actually save you anything
> (same space in the netlink attributes, and you have to validate it
> anyway)

Sure, I'll use u32 and add a check.

>> -     r = regulatory_hint_user(data);
>> +     if (info->attrs[NL80211_ATTR_USER_REG_HINT_TYPE])
>> +             user_reg_hint_type =
>> +               nla_get_u8(info->attrs[NL80211_ATTR_USER_REG_HINT_TYPE]);
>
> need to validate that it's a valid value, otherwise I can pass "42" :-)

Thanks, yes, I'll add:


+       switch (user_reg_hint_type) {
+       case NL80211_USER_REG_HINT_USER:
+       case NL80211_USER_REG_HINT_CELL_BASE:
+               break;
+       default:
+               return -EINVAL;
+       }

  Luis
