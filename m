Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39241 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1DRUpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 16:45:14 -0400
Received: by iwn34 with SMTP id 34so4212459iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 13:45:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303129610.3588.7.camel@jlt3.sipsolutions.net>
References: <1303125749-31967-1-git-send-email-arik@wizery.com> <1303129610.3588.7.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 18 Apr 2011 23:44:58 +0300
Message-ID: <BANLkTikc9wrZ__8URZ3ASQ6F=rUHix2iGA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: allow low level drivers to report packet loss
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 18, 2011 at 15:26, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-04-18 at 14:22 +0300, Arik Nemtsov wrote:
>> Add API that allows low level drivers to notify mac80211 about TX
>> packet loss. This is useful when there are FW triggers to notify the
>> low level driver about these events.
>
>> +void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
>> +{
>> +     struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
>> +     cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
>> +                                 num_packets, GFP_ATOMIC);
>
> I think it would make more sense to add num_packets to sta->lost_packets
> and invoke it only when over the threshold as done in
> ieee80211_tx_status(), as then we can share any threshold calculation
> improvements.

Well in a wl12xx chip we just configure some thresholds to the FW and
it triggers the event for us. Using TX status doesn't really make
sense since the FW has automatic rate control (so 50 tries are more
like 50 * 8).

>
> Also, are you sure? Do you really not get _any_ TX status?

Currently we do get TX status, but there are plans to remove it later on.

Regards,
Arik
