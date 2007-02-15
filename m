Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:48757 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030216AbXBOQ6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 11:58:09 -0500
Received: by py-out-1112.google.com with SMTP id a29so280757pyi
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2007 08:58:08 -0800 (PST)
Message-ID: <1ba2fa240702150858g6598ab81p6b1fa5f904a94fad@mail.gmail.com>
Date: Thu, 15 Feb 2007 18:58:08 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Cc: "Michael Buesch" <mb@bu3sch.de>, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070213012041.GH16597@instant802.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702041344.19117.mb@bu3sch.de> <200702130023.53271.mb@bu3sch.de>
	 <1ba2fa240702121554v4e5b55b3t4582241f6347b355@mail.gmail.com>
	 <200702130110.02658.mb@bu3sch.de>
	 <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
	 <20070213002849.GE16597@instant802.com>
	 <1ba2fa240702121708k29634cf0r8d8ab8e02bca8dfc@mail.gmail.com>
	 <20070213012041.GH16597@instant802.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/07, Jouni Malinen <jkm@devicescape.com> wrote:
> On Tue, Feb 13, 2007 at 03:08:03AM +0200, Tomas Winkler wrote:
>
> > There are real cases when this happens. Try to two different AC for
> > example  VoIP and have FTP in parallel.  Packets for low priority AC
> > can be stalled encrypted and scheduled in a AP TX queue while high
> > priority packets are already sent with the new key.
> > Maybe the new key can be computed on demand but it's good thing to
> > preserve the old key for while.
>
> I don't know the particular hardware design well enough to comment on
> this, but d80211 software implementation keeps a separate RX P1K for
> each AC (actually, each TID). In other words, this kind of issue does
> not show up there. If the hardware implementation is limited to only one
> P1K for RX, there may be some benefit on storing old keys in some cases,
> but I'm not sure how that would work if the key has to be configured
> before the frame is actually received.


Since TX  can use only on sequence counter regardless of AC also on
receive side it's enough to use one phase1 key. To keep phase1 key for
each AC is possible but it wast of memory. You need to keep just old
key till all AC wraps.

> In other words, in this case, the next frame after an FTP packet could
> well be from voice and not background and reconfiguring the old P1K
> value could have caused more latency on the higher priority frame at
> this point.. In other word, if there is only one RX P1K, the benefits
> for throughput may be requiring compromise on latency for higher
> priority traffic and that may or may not be acceptable.
>

You decrypt with old phase1 only in software, usually it is only few
packets (since TX counter is global). It will be a bug to configure HW
with the old key.

> Jouni Malinen                                            PGP id EFC895FA
>
