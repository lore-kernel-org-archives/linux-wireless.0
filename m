Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41761 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0LASpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 13:45:52 -0500
Received: by qyk11 with SMTP id 11so2918835qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 10:45:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291184383.4199.4.camel@jlt3.sipsolutions.net>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com> <1291184383.4199.4.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 1 Dec 2010 10:45:30 -0800
Message-ID: <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Support beacon configuration via nl80211 for
 mesh interfaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Tue, Nov 30, 2010 at 10:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-11-30 at 17:58 -0800, Javier Cardona wrote:
>> This patch adds the capability to the mesh stack to receive vendor
>> specific information elements from userspace.  When a vendor specific
>> IE is set via nl80211, the mesh stack will configure the mesh beacon to
>> advertise that a vendor specific path selection and metric is in use.
>> This is accordance with the Extensible Path Selection Framework
>> specified in version 7.0 of the 802.11s draft.
>
>> @@ -1709,6 +1709,7 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
>>               return -EINVAL;
>>
>>       if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>> +         dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
>>           dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>>               return -EOPNOTSUPP;
>
> I'm not convinced that letting userspace set the *entire* beacon is the
> right way to do it? Wouldn't it make more sense to allow it to specify
> vendor-specific IEs (like IBSS), and the fact that vendor selection
> protocol is used? It seems to me that somebody may want to have vendor
> IEs while using the default protocols?

Yes, agreed.  We'll investigate a way to provide a protocol switch
(maybe a new NL80211_CMD_SET_MESH_PARAMS) + a vendor specific IE
(NL80211_CMD_SET_MGMT_EXTRA_IE would have been ideal, but I see it's
gone).

Thanks!

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
