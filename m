Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53185 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab1I2KCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 06:02:15 -0400
Received: by yib18 with SMTP id 18so364320yib.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 03:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317290375.3974.1.camel@jlt3.sipsolutions.net>
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	<1317290375.3974.1.camel@jlt3.sipsolutions.net>
Date: Thu, 29 Sep 2011 12:02:15 +0200
Message-ID: <CAGXE3d87utQhKifrA8bco14rv9zn3-uZEsDiisg8wkDfipeBMQ@mail.gmail.com> (sfid-20110929_120219_050529_D11E6135)
Subject: Re: [PATCH] mac80211: Allow NO_ACK flag overwrite for injected frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 29, 2011 at 11:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-29 at 11:27 +0200, Helmut Schaa wrote:
>> Allow injected unicast frames to be sent without having to wait
>> for an ACK.
>>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> ---
>>
>> Just in case you're interested in what's the intended purpose of this:
>>
>> Some clients are staying on scanned channels for a very short period of
>> time. hostapd sends out probe responses for each configured BSSID. Under
>> some circumstances I can see that the client already left the channel
>> while some probe responses are still sent out and thus retried. This
>> consumes quite some airtime. Commercial wireless APs (Aruba for example)
>> seem to disable retries for probe responses to mitigate such issues.
>
> Makes sense, but I wonder if we really should continue using
> radiotap :-) Maybe mgmt-tx in nl80211 would be appropriate.

Hmm, not sure how much work that would be ...

>> @@ -1257,7 +1265,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>>               tx->flags |= IEEE80211_TX_UNICAST;
>>               if (unlikely(local->wifi_wme_noack_test))
>>                       info->flags |= IEEE80211_TX_CTL_NO_ACK;
>> -             else
>> +             else if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
>>                       info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
>
> ??

Don't remove the IEEE80211_TX_CTL_NO_ACK flag when it was set via radiotap.

Helmut
