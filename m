Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56538 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaKZLst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 06:48:49 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so12213447wid.9
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 03:48:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125202847.GL25677@wotan.suse.de>
References: <1416754941-4439-1-git-send-email-arik@wizery.com>
 <1416754941-4439-3-git-send-email-arik@wizery.com> <20141125202847.GL25677@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Nov 2014 13:48:32 +0200
Message-ID: <CA+XVXffwOGLNE+YW-JB9BS7WC_OaL_0aaikMiHO7zj6qoiFxHA@mail.gmail.com> (sfid-20141126_124852_369357_BA4CA85E)
Subject: Re: [PATCH v3 3/3] cfg80211: Allow usermode to query wiphy specific
 regd info
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 10:28 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Sun, Nov 23, 2014 at 05:02:21PM +0200, Arik Nemtsov wrote:
>> From: Jonathan Doron <jond@wizery.com>
>>
>> Allow usermode to query wiphy-specific regd info, for drivers that use
>> wiphy-specific regulatory management.
>>
>> Use the existing API for sending regdomain info to usermode, but return
>> the wiphy-specific regd in case wiphy index is provided and the driver
>> employs wiphy-specific management. This implies user and kernel-mode
>> support for the feature and is backward compatible.
>>
>> Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> ---
>>  include/uapi/linux/nl80211.h | 18 ++++++++++-
>>  net/wireless/nl80211.c       | 71 ++++++++++++++++++++++++++++++++++++--------
>>  net/wireless/reg.c           |  2 +-
>>  net/wireless/reg.h           |  1 +
>>  4 files changed, 78 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 3771e7d..b222e5c 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -252,7 +252,12 @@
>>   *   %NL80211_ATTR_IFINDEX.
>>   *
>>   * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
>> - *   regulatory domain.
>> + *   regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
>> + *   self-manages its regulatory settings, its private regulatory domain
>> + *   will be returned.
>> + *   If %NL80211_ATTR_WIPHY_GET_PRIV_REG is specified in addition to
>> + *   %NL80211_ATTR_WIPHY, a device's private regulatory domain will be
>> + *   returned, even if it's regulatory is not self-managed.
>>   * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
>>   *   after being queried by the kernel. CRDA replies by sending a regulatory
>>   *   domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
>> @@ -1693,6 +1698,14 @@ enum nl80211_commands {
>>   *
>>   * @NL80211_ATTR_MAC_MASK: MAC address mask
>>   *
>> + * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating the
>> + *   regulatory information was obtained from the private regdomain
>> + *   of a device with self-managed regulatory.
>> + * @NL80211_ATTR_WIPHY_GET_PRIV_REG: flag attribute indicating the regulatory
>> + *   information should be obtained from a device's private regdomain,
>> + *   if it exists. This will happen even if the device is not self-managing
>> + *   its regulatory.
>
> As with REGULATORY_WIPHY_SELF_MANAGED we need a flag that cfg80211 sets for
> drivers that use regulatory_hint() API, perhaps REGULATORY_WIPHY_REG_HINT.
> Then this can be used by cfg80211 to send to userspace regdomains for wiphys
> that have used this API. Below you enable userspace to only query for these
> explictly but we want to be able to let userspace get all information, ie
> through 'iw reg get'. This should go in as a separate patch along with
> NL80211_ATTR_WIPHY_GET_PRIV_REG as its use predates
> NL80211_ATTR_WIPHY_SELF_MANAGED_REG, this will also let you stuff in the boiler
> plate code for getting that reg first, getting self managed regd's can then
> go in as a clear secondary evolutionary step.
>
> The documentation for NL80211_ATTR_WIPHY_GET_PRIV_REG can refer to the new
> %REGULATORY_WIPHY_REG_HINT flag. NL80211_ATTR_WIPHY_SELF_MANAGED_REG should
> refer to %REGULATORY_WIPHY_SELF_MANAGED
>
>> @@ -5346,13 +5345,54 @@ static int nl80211_get_reg(struct sk_buff *skb, struct genl_info *info)
>>       if (!hdr)
>>               goto put_failure;
>>
>> -     if (reg_last_request_cell_base() &&
>> -         nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
>> -                     NL80211_USER_REG_HINT_CELL_BASE))
>> -             goto nla_put_failure;
>> +     if (info->attrs[NL80211_ATTR_WIPHY]) {
>> +             u32 reg_flags;
>> +             struct wiphy *wiphy;
>> +             struct cfg80211_registered_device *rdev =
>> +                     cfg80211_get_dev_from_info(genl_info_net(info), info);
>> +
>> +             if (IS_ERR(rdev)) {
>> +                     nlmsg_free(msg);
>> +                     return PTR_ERR(rdev);
>> +             }
>> +
>> +             wiphy = &rdev->wiphy;
>> +             reg_flags = wiphy->regulatory_flags;
>> +             if (reg_flags & REGULATORY_WIPHY_SELF_MANAGED ||
>> +                 info->attrs[NL80211_ATTR_WIPHY_GET_PRIV_REG]) {
>> +                     regdom = get_wiphy_regdom(wiphy);
>> +                     if (!regdom) {
>> +                             nlmsg_free(msg);
>> +                             return -EINVAL;
>> +                     }
>> +
>> +                     if (nla_put_u32(msg, NL80211_ATTR_WIPHY,
>> +                                     rdev->wiphy_idx))
>> +                             goto nla_put_failure;
>> +
>> +                     if (reg_flags & REGULATORY_WIPHY_SELF_MANAGED &&
>> +                         nla_put_flag(msg,
>> +                                      NL80211_ATTR_WIPHY_SELF_MANAGED_REG))
>> +                             goto nla_put_failure;
>> +             }
>> +     }
>
> If no NL80211_ATTR_WIPHY was requested specifically it would still
> be good to send the central regulatory domain followed by each
> wiphy's own regulatory domain whether priv or managed. Can you add
> that as well? With the split above the first patch would send
> all regds for all wiphys that used regulatory_hint(), the second
> patch would extend this to add the self managed list too.

Ok I'll make the change.

Arik
