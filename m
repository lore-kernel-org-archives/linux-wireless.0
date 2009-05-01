Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:7308 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZEAOKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 10:10:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1166657fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2009 07:10:47 -0700 (PDT)
Subject: Re: PHY hangs on AR2425 (AR5007EG)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <bcopeland@gmail.com>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0905010507x75b14181t7263eb1717cd278e@mail.gmail.com>
References: <1240761579.10972.11.camel@maxim-laptop>
	 <1241036667.12942.0.camel@maxim-laptop>
	 <b6c5339f0905010507x75b14181t7263eb1717cd278e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 01 May 2009 17:10:43 +0300
Message-Id: <1241187043.12695.10.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-01 at 08:07 -0400, Bob Copeland wrote:
> On Wed, Apr 29, 2009 at 4:24 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> The issue is that if I load its TX unit up to it's maximum throughput,
> >> it stalls each and every few seconds, and only way to
> >
> > Are you aware of that bug?
> 
> Yeah, thanks, haven't lost the report but haven't
> had a chance to investigate so far.
No problem

> 
> By load TX up, do you mean you are sending large
> files, using ping, iperf, or.. ?
> 
Yes, I use netcat to send zeros via tcp.

Actually sometimes, it seems that doing a download, could also trigger
same behavier, but this is much rareler.

When I bombard the aspire one with udp packets (= TX unit doesn't work
at all - maybe it sends ACKS, but I haven't tested this, then I get
lower speed, don't remember what exactly, but around 1.5 MB/s, and no
hangs at all).

I also did another test, I manually lowered TX rate on both ends (and
this does work now), and yet, I got same behavior. (ends were iwl3945
and ath5k)

On the other hand, if I transfer data via router again iwl3945-ath5k) (=
half of the time card doesn't work) I never see any hangs.

Same hangs happen if I transfer data to wired host, my third computer.


If there is anything I can test futher please ask,


Also (small plug) still card hangs sometimes after resume from ram with
message : 'failed to wakeup MAC' S2RAM/S2DISK doesn't help, module
reload doesn't help, it will fail to load at all, since first thing it
does it 'wakes up the MAC'

Other that the above two bugs, everything works fine (ah forgot that I
need to rewrite led code in mac80211, to make it usable, some day I do
so).


Best regards,
	Maxim Levitsky

