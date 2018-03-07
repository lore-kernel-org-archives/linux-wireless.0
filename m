Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:45650 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933768AbeCGQjd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 11:39:33 -0500
Received: by mail-qt0-f176.google.com with SMTP id v90so3337477qte.12
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2018 08:39:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADjYELzsP37RWTqJOSoevNy32E38e4=bkjDkY6A4F3exnDYadQ@mail.gmail.com>
References: <CADsGw2ZBPK1hBY-a+v_1mVUOaFP3Uu5A4euyTc-070E4vSUrBg@mail.gmail.com>
 <CADjYELzsP37RWTqJOSoevNy32E38e4=bkjDkY6A4F3exnDYadQ@mail.gmail.com>
From: Phani Siriki <yvsg.phanis@gmail.com>
Date: Wed, 7 Mar 2018 10:39:32 -0600
Message-ID: <CADsGw2a+u7dW3H3PF7jgJmj0A5oiQ1BbNuASW7v6192CC-U2gA@mail.gmail.com> (sfid-20180307_173936_959750_015E5093)
Subject: Re: Query on queues in mesh mode
To: Thomas Pedersen <thomas@eero.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas

Thank you for your reply.

Could you please let me know how can I verify these queues on a mesh
router? (I am using TPLink router with Ath9k chipset).

Also, the TXQ parameters can only be set if device is in AP or P2P
mode. Do you have any idea why this restriction is in place?

https://github.com/torvalds/linux/blob/master/net/wireless/nl80211.c

static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
{

           if (info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS]) {
           ....
                   if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
                       netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
                                 return -EINVAL;
           ...
}

Best Regards
Phani

On Tue, Mar 6, 2018 at 11:59 PM, Thomas Pedersen <thomas@eero.com> wrote:
> On Thu, Mar 1, 2018 at 7:27 AM, Phani Siriki <yvsg.phanis@gmail.com> wrote:
>> Hi All
>>
>> I am trying to understand the queuing mechanism wireless mesh networks.
>>
>> As per AP mode is concerned, there are four queues (BK, BE, Vi, VO)
>> and traffic is controlled based on CWmin, CWmax, AIFS and TxOP.
>>
>> Does, mesh mode also involve these queues? Does mesh mode have any
>> queue or it is just a single queue?
>
> mesh mode maps to the different ACs like AP mode. The only additional
> queue in mesh is the mpath->frame_queue, which may be used if an
> active mpath for a given RA can't be found.
>
> --
> thomas
