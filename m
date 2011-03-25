Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41904 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1CYM5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 08:57:44 -0400
Received: by bwz15 with SMTP id 15so871422bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 05:57:43 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Fri, 25 Mar 2011 13:55:55 +0100
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201103232358.29966.helmut.schaa@googlemail.com> <201103251208.22473.helmut.schaa@googlemail.com> <1301052224.3827.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1301052224.3827.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103251355.55824.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 25. März 2011 schrieb Johannes Berg:
> On Fri, 2011-03-25 at 12:08 +0100, Helmut Schaa wrote:
> > So, if a frame failed because the STA entered PS state it will be added
> > to the filtered frames queue and no BAR will get generated.
> 
> Right. Of course, if the device could help and the driver would set
> IEEE80211_TX_STAT_TX_FILTERED this would be better since then the frames
> wouldn't even be on the air...

Yeah, unfortunately ralink devices don't seem capable of handling that
in hw/fw :(
 
> FWIW, since Intel hw uses special queues for aggregation the ucode just
> stops those queues when the station goes to sleep. Caused me some grey
> hair in fact since I had naively expected it to reject those frames too.
> 
> > However, if this was the case mac80211 should send out all filtered frames
> > after the STA wakes up again, which does not happen in the situation
> > above (3106 and 3107 got lost) :(
> 
> Yeah, that's in fact strange. Unless they timed out?

Hmm, right, maybe I should enable mac80211 PS debugging to see if frames
time out or get dropped from the buffer ...

> > Generating the BAR also for filtered frames might improve the situation but
> > looks more like a workaround to me.
> 
> Agree.
> 
> > Still debugging the rt2800 tx status reporting.
> 
> Maybe it's not reporting the right status for all frames?

So far the tx status as returned by the device look correct. I printed the
sequence numbers of failed AMPDU subframes and had a second device capturing
the traffic and compared them.

But I noticed that there still appear holes from time to time that cause the
strange Intel driver stuck problem (which is really really strange and IMHO
the driver has a problem too). And it is not necessarily PS related.

Johannes, what happens if a frame gets dropped on its way though the tx path
after getting a seqnr assigned? That would cause a hole in the sequence number
series without the chance to get a IEEE80211_TX_STAT_AMPDU_NO_BACK tx status.

Helmut
