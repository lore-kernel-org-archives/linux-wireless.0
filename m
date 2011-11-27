Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52268 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1K0GHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 01:07:33 -0500
Received: by vcbfk14 with SMTP id fk14so2904795vcb.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Nov 2011 22:07:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321285041.10264.14.camel@jlt3.sipsolutions.net>
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	<1321285041.10264.14.camel@jlt3.sipsolutions.net>
Date: Sun, 27 Nov 2011 14:07:32 +0800
Message-ID: <CAJ-VmokTTXYEMp9=XJN=N_0ubH96NWRbGCFjfnnXp4q1s2iVUw@mail.gmail.com> (sfid-20111127_070737_505043_75C802D2)
Subject: Re: off- & multi-channel operation
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm sorry I haven't responded to this. I'm busy moving country :-)

Let's talk about this in a couple weeks. I know that FreeBSD's
net80211 code allows drivers to only override what methods they
require net80211 to provide. So drivers can do their own MLME, for
example, but still throw some control frame handling at
net80211/hostapd. Or use the net80211 rate control API whilst doing
mostly everything else in firmware (eg if_iwn.)

I'm also looking at how to handle off-channel operation when doing
active 802.11n (and not, but software aggregation does tickle things)
traffic. Flushing the actively queued traffic whilst doing off-channel
work is likely sub-optimal. I have no idea if that's what mac80211
does.

Anyway, I'll be back doing active hacking on this stuff in two or
three weeks. I bet we could save time by solving the same problem
together rather than solving it individually and differently.

(At that stage I may pick your brain about how P2P is supposed to
integrate correctly with off-channel operation..)


Adrian
