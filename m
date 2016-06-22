Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:32781 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbcFVKyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 06:54:13 -0400
Received: by mail-pf0-f174.google.com with SMTP id i123so16793963pfg.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 03:54:13 -0700 (PDT)
Subject: Re: [PATCH] mac80211: Encrypt "Group addressed privacy" action frames
To: Jouni Malinen <j@w1.fi>
References: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
 <20160618091116.GA2972@w1.fi> <57673E10.7070706@gmail.com>
 <20160620212529.GA19076@w1.fi> <5768DBB6.2060501@gmail.com>
 <20160621170120.GA24882@w1.fi>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <576A6E52.1050705@gmail.com> (sfid-20160622_125416_467124_4420934B)
Date: Wed, 22 Jun 2016 19:54:10 +0900
MIME-Version: 1.0
In-Reply-To: <20160621170120.GA24882@w1.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2016年06月22日 02:01, Jouni Malinen wrote:
> Please keep in mind that "working" here means two things:
> (1) being able decrypt the frame,
> (2) being able to reject the frame if it was not properly protected. It
> is that (2) that is unlikely to be covered here..
>
> We actually cover (2) for some cases by "accident" since
> ieee80211_rx_h_decrypt() assigns rx->key to rx->sta->gtk[i] if one is
> available. I'm not completely sure this is correct since it applies to
> management frame as well, but that's the way commit
> 897bed8b4320774e56f282cdc1cceb4d77442797 ('mac80211: clean up RX key
> checks') implemented it (Johannes: Could you please take a look whether
> that gtk[] case was really supposed to apply for non-Data frames?).
> Interestingly, even on the TX side, we had code that picked tx->key for
> these group addressed Action frames, but that got then cleared later..
>
> That said, if rx->sta->gtk[i] is not set for any value of i, we would
> not enforce encryption of "group addressed privacy" Action frames as far
> as I can tell. This may be a pretty small window since RX MGTK is
> supposed to get set immediately for each peer. However, I would not be
> surprised if there were indeed a window between adding the STA entry and
> marking it authorized and configuring the RX MGTK. And even if this is
> not possible, this should really be commented somewhere so that there is
> less of a change of accidentally optimizing or cleaning up something
> that is needed for this to be protected..
>
> And when operating with PMF enabled, this is clearly broken, i.e., the
> RX path accepts BIP protected version of the broadcast Mesh Action frame
> while that frame needs to be rejected since it was not encrypted with
> CCMP/GCMP.
>
> To cover all these RX cases properly, I'd expect there to be RX path
> changes that use ieee80211_is_group_privacy_action() and reject some
> cases.. This should like be there in the !ieee80211_has_protected(fc)
> case in ieee80211_rx_h_decrypt() before selecting the key and if
> ieee80211_is_group_privacy_action() returns true, return RX_DROP_MONITOR
> would be needed.
>
Thank you Jouni and Johannes.

Indeed, received unencrypted Group Addressed Privacy action frame is 
dropped at
below if condition in ieee80211_drop_unencrypted_mgmt().
     /* BIP does not use Protected field, so need to check MMIE */
     if (unlikely(ieee80211_is_multicast_robust_mgmt_frame(rx->skb) &&
              ieee80211_get_mmie_keyidx(rx->skb) < 0)) {
         if (ieee80211_is_deauth(fc) ||
             ieee80211_is_disassoc(fc))
             cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
                              rx->skb->data,
                              rx->skb->len);
         return -EACCES;
     }
Because the frame was not encrypted and does not have MMIE.

And there could be one more case. Group Addressed Privacy action frame 
could have
robustness by MMIC because of previous wrong implementation. The frame could
not be cought by ieee80211_drop_unencrypted_mgmt(). Because the frame 
has MMIE.
So I have added new condition to ieee80211_rx_h_decrypt() by follwing patch.


