Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57761 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1CXN7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 09:59:35 -0400
Received: by bwz15 with SMTP id 15so67761bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 06:59:34 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Thu, 24 Mar 2011 14:57:46 +0100
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201103232358.29966.helmut.schaa@googlemail.com> <201103241409.03170.helmut.schaa@googlemail.com> <1300972793.26265.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1300972793.26265.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103241457.46343.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 24. März 2011 schrieb Johannes Berg:
> On Thu, 2011-03-24 at 14:09 +0100, Helmut Schaa wrote:
> 
> > Ok, found out some more. The problem now seems to trigger only if the Intel STA
> > leaves powersave and mac80211 dropped a frame while the STA was sleeping (either
> > due to the size of the STA PS buffer or due to a race between rx/tx processing).
> 
> Why do we even have aggregation sessions active while the station goes
> to sleep? Is it scanning?

I guess so, yes (as I wrote before this is an Intel 5100 client running Windows
Vista and the latest Intel driver). It sends a nullfunc going to sleep and returns
a few hundret ms later. And in the meantime I can see my rt2800 AP sending an
AMPDU to the sleeping STA which of course times out and therefore ends up as
filtered frame.

> Maybe the PS buffer should be larger then?

128 frames per STA is already large, no? And also it's nothing unusual
that some frames get dropped if the STA stays in powersave for a long time.

> I don't see how we can lose a
> frame due to rx/tx processing races either, how does that happen? I
> thought we had the ability to avoid all those races now.

Good point. Maybe this only happens with rt2x00. The frame exchange looks
basically like (if you want to see the pcap just ask ;) ):

STA -> AP  nullfunc PM=1
AP -> STA  AMPDU (seqnr 3106 - 3112)
AP -> STA  AMPDU (seqnr 3106 - 3112), retry
AP -> STA  AMPDU (seqnr 3106 - 3112), retry
AP -> STA  AMPDU (seqnr 3106 - 3112), retry
AP -> STA  AMPDU (seqnr 3106 - 3112), retry
AP -> STA  AMPDU (seqnr 3106 - 3112), retry
...
STA -> AP nullfunc PM=0
...
AP -> STA  AMPDU (seqnr 3108)
STA -> AP  BlockAck
AP -> STA  AMPDU (seqnr 3109 - 3114)
STA -> AP  BlockAck
...

As you can see 3106 and 3107 somehow got lost and thus leave a hole in
the STAs reorder buffer leading to the strange behavior I described before.

> > This can also cause a sequence number hole in the STAs rx reordering buffer but
> > we won't send a BAR in that case ending in the same situation that the Intel STA
> > BlockAcks AMPDUs to it but doesn't pass them to the user space.
> > 
> > Johannes, does it make sense to always send a BAR when a STA wakes up from
> > sleep and we've got an active aggregation session?
> 
> I don't know, you tell me, does it? :)

Ha Ha ;)

Sending a BAR at this point would at least ensure that the Intel STAs RX
reorder buffer gets flushed (in case we dropped any frames while the STA was
sleeping, which happened in this case).

Helmut
