Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35071 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbcAEP4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 10:56:45 -0500
Received: by mail-io0-f174.google.com with SMTP id 77so159784792ioc.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 07:56:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452009156.12357.38.camel@sipsolutions.net>
References: <1452004632-20263-1-git-send-email-helmut.schaa@googlemail.com>
	<1452008139.12357.32.camel@sipsolutions.net>
	<CAGXE3d9TZbUF0k0moa_hzOUip9q5PgDSe0kDbiD1KCH7mjX+Ng@mail.gmail.com>
	<1452009156.12357.38.camel@sipsolutions.net>
Date: Tue, 5 Jan 2016 16:56:44 +0100
Message-ID: <CAGXE3d9CVOAkQm_76k8mZUKPpVj4M2fTL76dhQH6Mp2GsTWE3g@mail.gmail.com> (sfid-20160105_165648_492023_7B4FF132)
Subject: Re: [PATCH] mac80211: Don't buffer non-bufferable MMPDUs
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 5, 2016 at 4:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-01-05 at 16:43 +0100, Helmut Schaa wrote:
>
>> > That said, it obviously also points to a driver bug not treating
>> > these frames correctly, so you might want to investigate why you
>> > got here to start with!
>>
>> It was not the driver marking the frame as filtered but mac80211
>> itself in status.c:
>>
>>                 acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
>>                 if (!acked && test_sta_flag(sta, WLAN_STA_PS_STA)) {
>>                         /*
>>                          * The STA is in power save mode, so assume
>>                          * that this TX packet failed because of
>> that.
>>                          */
>>                         ieee80211_handle_filtered_frame(local, sta,
>> skb);
>>                         rcu_read_unlock();
>>                         return;
>>                 }
>
> Ah, yes, ok. So the frame simply didn't go through, for whatever
> reason. Hopefully the driver actually transmitted it :)

Yep, saw it on the air.

It was a STA sending probe requests while in PS mode and jumping to a new
channel before receiving/acking all probe responses. Hence, a probe response
ended up in the filtered queue. And it was easy to reproduce with this specific
STA (some old voip phone).

>> However, I've put the code into ieee80211_handle_filtered_frame to
>> not grow ieee80211_tx_status even more :)
>>
>> If you prefer to add it here directly I'm fine to change it.
>>
>
> No, looks fine as is. I just misunderstood how we got here.

Ok, I'd still like to change to checking IEEE80211_TX_CTL_NO_PS_BUFFER
instead -> v2 follows.

Helmut
