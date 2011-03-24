Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38705 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1CXUig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 16:38:36 -0400
Received: by vws1 with SMTP id 1so334998vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 13:38:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300987930.26265.6.camel@jlt3.sipsolutions.net>
References: <201103232358.29966.helmut.schaa@googlemail.com>
	<201103241409.03170.helmut.schaa@googlemail.com>
	<1300972793.26265.2.camel@jlt3.sipsolutions.net>
	<201103241457.46343.helmut.schaa@googlemail.com>
	<1300987930.26265.6.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Mar 2011 22:38:35 +0200
Message-ID: <AANLkTi=mFbtLbQwNX6ZnzW9_xn_CYUBvv98z3-ZT9uf0@mail.gmail.com>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 24, 2011 at 19:32, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-03-24 at 14:57 +0100, Helmut Schaa wrote:
>
>> I guess so, yes (as I wrote before this is an Intel 5100 client running Windows
>> Vista and the latest Intel driver). It sends a nullfunc going to sleep and returns
>> a few hundret ms later. And in the meantime I can see my rt2800 AP sending an
>> AMPDU to the sleeping STA which of course times out and therefore ends up as
>> filtered frame.
>
> Ok so it gets reported to mac80211.
>
>> > Maybe the PS buffer should be larger then?
>>
>> 128 frames per STA is already large, no? And also it's nothing unusual
>> that some frames get dropped if the STA stays in powersave for a long time.
>>
>> > I don't see how we can lose a
>> > frame due to rx/tx processing races either, how does that happen? I
>> > thought we had the ability to avoid all those races now.
>>
>> Good point. Maybe this only happens with rt2x00. The frame exchange looks
>> basically like (if you want to see the pcap just ask ;) ):
>>
>> STA -> AP  nullfunc PM=1
>> AP -> STA  AMPDU (seqnr 3106 - 3112)
>> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> AP -> STA  AMPDU (seqnr 3106 - 3112), retry
>> ...
>> STA -> AP nullfunc PM=0
>> ...

Hold on, why do mac80211 send a frame to a sleeping station ?
Am I stupid or is this buggy ?
Johannes, is this the buggy behavior in PS you were pointing out later
in your mail ?


>> AP -> STA  AMPDU (seqnr 3108)
>> STA -> AP  BlockAck
>> AP -> STA  AMPDU (seqnr 3109 - 3114)
>> STA -> AP  BlockAck
>> ...
>>
>> As you can see 3106 and 3107 somehow got lost and thus leave a hole in
>> the STAs reorder buffer leading to the strange behavior I described before.
>
> but if they are reported to mac80211 they should be put on the queue
> again? Are they maybe not reported back quite in the right way?
>
>> > I don't know, you tell me, does it? :)
>>
>> Ha Ha ;)
>>
>> Sending a BAR at this point would at least ensure that the Intel STAs RX
>> reorder buffer gets flushed (in case we dropped any frames while the STA was
>> sleeping, which happened in this case).
>
> Right, but so far this looks like it's more like a bug in the powersave
> code rather than something we desperately need to recover from with a
> BAR.
>

The originator tried to send data and this data didn't get acked. In
this case a BAR should be sent regardless the reason why this frame
didn't get acked.
This is done by reporting IEEE80211_TX_STAT_AMPDU_NO_BACK to mac80211.
Can it be that the rt2800 doesn't report properly the xmit failure ?
