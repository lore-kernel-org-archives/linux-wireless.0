Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62040 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3JBKHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 06:07:33 -0400
Received: by mail-oa0-f49.google.com with SMTP id i4so521950oah.8
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 03:07:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380704100.13329.6.camel@jlt4.sipsolutions.net>
References: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1380704100.13329.6.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 12:07:33 +0200
Message-ID: <CAA2SeN+nhLU7vGDNLJCD=UrNRSFm5hT6HGEEhUqr1kAcMF3O-A@mail.gmail.com> (sfid-20131002_120737_156878_29667DBC)
Subject: Re: [PATCH] mac80211: allow mgmt frame transmission on DFS channels
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before start beaconing cfg80211_reg_can_beacon() verifies the channel
is CAC checked and available calling cfg80211_secondary_chans_ok().
Although the channel is marked NL80211_DFS_AVAILABLE after a CAC
period, ieee80211_monitor_start_xmit() does not allow to inject mgmt
frames on DFS channels causing association failures.

Lorenzo

2013/10/2 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2013-09-30 at 14:52 +0200, Lorenzo Bianconi wrote:
>> Allow management frame injection on DFS channels if the channel has been CAC
>> checked and is available
>
>> +++ b/net/mac80211/tx.c
>> @@ -1694,8 +1694,10 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>>        * radar detection by itself. We can do that later by adding a
>>        * monitor flag interfaces used for AP support.
>>        */
>> -     if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
>> -                         IEEE80211_CHAN_PASSIVE_SCAN)))
>> +     if (((chan->flags & (IEEE80211_CHAN_PASSIVE_SCAN |
>> +                          IEEE80211_CHAN_NO_IBSS))) ||
>> +         ((chan->flags & IEEE80211_CHAN_RADAR) &&
>> +          chan->dfs_state != NL80211_DFS_AVAILABLE))
>
> This would be the only place where mac80211 is accessing
> chan->dfs_state, does that make sense? Why is it not needed elsewhere?
>
> johannes
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
