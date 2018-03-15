Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:44376 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932372AbeCOQls (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 12:41:48 -0400
Received: by mail-qk0-f172.google.com with SMTP id h14so2498579qkj.11
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 09:41:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADsGw2a+u7dW3H3PF7jgJmj0A5oiQ1BbNuASW7v6192CC-U2gA@mail.gmail.com>
References: <CADsGw2ZBPK1hBY-a+v_1mVUOaFP3Uu5A4euyTc-070E4vSUrBg@mail.gmail.com>
 <CADjYELzsP37RWTqJOSoevNy32E38e4=bkjDkY6A4F3exnDYadQ@mail.gmail.com> <CADsGw2a+u7dW3H3PF7jgJmj0A5oiQ1BbNuASW7v6192CC-U2gA@mail.gmail.com>
From: Phani Siriki <yvsg.phanis@gmail.com>
Date: Thu, 15 Mar 2018 11:41:46 -0500
Message-ID: <CADsGw2a9zqVEeT_w1r_41ufO5oK14D3naYwNFS+4fv-ezDnMww@mail.gmail.com> (sfid-20180315_174208_725329_DF2BC50A)
Subject: Re: Query on queues in mesh mode
To: Thomas Pedersen <thomas@eero.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could someone help me on this?

On Wed, Mar 7, 2018 at 10:39 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
> Hi Thomas
>
> Thank you for your reply.
>
> Could you please let me know how can I verify these queues on a mesh
> router? (I am using TPLink router with Ath9k chipset).
>
> Also, the TXQ parameters can only be set if device is in AP or P2P
> mode. Do you have any idea why this restriction is in place?
>
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
