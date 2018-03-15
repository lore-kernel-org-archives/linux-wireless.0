Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:42281 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932589AbeCOWbb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 18:31:31 -0400
Received: by mail-oi0-f41.google.com with SMTP id c18so7087779oiy.9
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 15:31:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADsGw2a+u7dW3H3PF7jgJmj0A5oiQ1BbNuASW7v6192CC-U2gA@mail.gmail.com>
References: <CADsGw2ZBPK1hBY-a+v_1mVUOaFP3Uu5A4euyTc-070E4vSUrBg@mail.gmail.com>
 <CADjYELzsP37RWTqJOSoevNy32E38e4=bkjDkY6A4F3exnDYadQ@mail.gmail.com> <CADsGw2a+u7dW3H3PF7jgJmj0A5oiQ1BbNuASW7v6192CC-U2gA@mail.gmail.com>
From: Thomas Pedersen <thomas@eero.com>
Date: Thu, 15 Mar 2018 15:31:30 -0700
Message-ID: <CADjYELxj5J3U4EvXP=wrr24manop824RVgauGXN5eRXATYL7Jg@mail.gmail.com> (sfid-20180315_233135_705248_21906D0F)
Subject: Re: Query on queues in mesh mode
To: Phani Siriki <yvsg.phanis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 7, 2018 at 8:39 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
> Hi Thomas
>
> Thank you for your reply.
>
> Could you please let me know how can I verify these queues on a mesh
> router? (I am using TPLink router with Ath9k chipset).

try

$ iw mesh0 mpath dump

The mpath queue length is under the "QLEN" heading.

> Also, the TXQ parameters can only be set if device is in AP or P2P
> mode. Do you have any idea why this restriction is in place?

I don't think there is any reason modifying the queue parameters wouldn't work
in mesh mode. Why don't you hack up that code and give it a try.

> https://github.com/torvalds/linux/blob/master/net/wireless/nl80211.c
>
> static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
> {
>
>            if (info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS]) {
>            ....
>                    if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>                        netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>                                  return -EINVAL;
>            ...
> }
>
> Best Regards
> Phani
>
> On Tue, Mar 6, 2018 at 11:59 PM, Thomas Pedersen <thomas@eero.com> wrote:
>> On Thu, Mar 1, 2018 at 7:27 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
>>> Hi All
>>>
>>> I am trying to understand the queuing mechanism wireless mesh networks.
>>>
>>> As per AP mode is concerned, there are four queues (BK, BE, Vi, VO)
>>> and traffic is controlled based on CWmin, CWmax, AIFS and TxOP.
>>>
>>> Does, mesh mode also involve these queues? Does mesh mode have any
>>> queue or it is just a single queue?
>>
>> mesh mode maps to the different ACs like AP mode. The only additional
>> queue in mesh is the mpath->frame_queue, which may be used if an
>> active mpath for a given RA can't be found.
>>
>> --
>> thomas



-- 
thomas
