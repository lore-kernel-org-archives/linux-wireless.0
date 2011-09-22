Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64357 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1IVHpK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:45:10 -0400
Received: by eya28 with SMTP id 28so1423127eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:45:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316606076.3940.19.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-2-git-send-email-arik@wizery.com> <1316606076.3940.19.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 22 Sep 2011 10:44:54 +0300
Message-ID: <CA+XVXfce2=nD7wgEonSL7STzGGESZgyM_=GdGW+h=-WAMgxAow@mail.gmail.com> (sfid-20110922_094514_767608_E6A4BC1C)
Subject: Re: [RFC 1/5] nl80211: support sending TDLS commands/frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 14:54, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
>
>> +static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +     struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +     struct net_device *dev = info->user_ptr[1];
>> +     u8 action_code, dialog_token;
>> +     u16 status_code;
>> +     u8 *peer;
>> +
>> +     if (!rdev->ops->tdls_mgmt)
>> +             return -EOPNOTSUPP;
>> +
>> +     if (!info->attrs[NL80211_ATTR_TDLS_ACTION] ||
>> +         !info->attrs[NL80211_ATTR_STATUS_CODE] ||
>> +         !info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN] ||
>> +         !info->attrs[NL80211_ATTR_FRAME] ||
>> +         !info->attrs[NL80211_ATTR_MAC])
>> +             return -EINVAL;
>
> Should that really use ATTR_FRAME as opposed to ATTR_IE?
>

I guess ATTR_IE is more appropriate (looking at the docs).

Arik
