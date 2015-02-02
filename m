Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:33670 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420AbbBBXGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 18:06:05 -0500
Message-ID: <1422918363.21689.132.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150203_000620_719007_56761351)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Date: Mon, 02 Feb 2015 15:06:03 -0800
In-Reply-To: <54CFEB46.3050006@candelatech.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	 <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
	 <1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQkV+mOZfe_Niz5101sMQeaV6muKCsShptjGQ1AgOHqqoQ@mail.gmail.com>
	 <1422903136.21689.114.camel@edumazet-glaptop2.roam.corp.google.com>
	 <54CFEB46.3050006@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-02 at 13:25 -0800, Ben Greear wrote:

> It is a big throughput win to have fewer TCP ack packets on
> wireless since it is a half-duplex environment.  Is there anything
> we could improve so that we can have fewer acks and still get
> good tcp stack behaviour?

First apply TCP stretch ack fixes to the sender. There is no way to get
good performance if the sender does not handle stretch ack.

d6b1a8a92a14 tcp: fix timing issue in CUBIC slope calculation
9cd981dcf174 tcp: fix stretch ACK bugs in CUBIC
c22bdca94782 tcp: fix stretch ACK bugs in Reno
814d488c6126 tcp: fix the timid additive increase on stretch ACKs
e73ebb0881ea tcp: stretch ACK fixes prep

Then, make sure you do not throttle ACK too long, especially if you hope
to get Gbit line rate on a 4 ms RTT flow.

GRO does not mean : send one ACK every ms, or after 3ms delay...

It is literally :
  aggregate X packets at receive, and send the ACK asap.

If the receiver expects to have 64 ACK packets in the TX ring buffer to
actually send them (wifi aggregation), then you certainly do not want to
compress ACK too much.



