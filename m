Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48718 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3EXXOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 19:14:05 -0400
Received: by mail-wi0-f174.google.com with SMTP id c10so170884wiw.7
        for <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 16:14:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369432740.13623.12.camel@johannes>
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
 <1368233453-10581-3-git-send-email-ashok@cozybit.com> <1369432740.13623.12.camel@johannes>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Fri, 24 May 2013 16:13:43 -0700
Message-ID: <CACcxo+pWnCFW3wvdjhHZvhb065Trup1KL=8fj7bbBhC5m4evqQ@mail.gmail.com> (sfid-20130525_011417_350593_8B9A7EA2)
Subject: Re: [PATCH 3/3] {nl,mac,cfg}80211: Allow user to configure basic
 rates for mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, May 24, 2013 at 2:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Sorry for leaving this open for so long. I think it didn't hurt since
> the merge window was open anyway.
>
>> + * @basic_rates: per-band bitmap of basic rates to use when creating the mesh
>
> Does per-band really make sense? The mesh channel is also determined at
> join time.
>
>>  static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>>  {
>>       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> @@ -7460,6 +7487,22 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
>>                           nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
>>                       return -EINVAL;
>>
>> +     if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
>
> I think you should consider allowing this attribute only if the channel
> is also specified (NL80211_ATTR_WIPHY_FREQ, parsed below), and not make
> it nested with rates for both bands but just the selected band.
>
Yes, I think by this approach, we eliminate the need for the user to
provide rates for both bands and also not require to have a per-band
for basic_rates.

Said that, I am wondering why give mcast_rate for both bands, but
basic_rates only for one band?
> johannes
>



--
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
