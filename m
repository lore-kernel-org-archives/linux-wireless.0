Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34752 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbBBVZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 16:25:28 -0500
Message-ID: <54CFEB46.3050006@candelatech.com> (sfid-20150202_222535_918906_F24D1EC9)
Date: Mon, 02 Feb 2015 13:25:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>  <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>  <CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>  <1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>  <CA+BoTQkV+mOZfe_Niz5101sMQeaV6muKCsShptjGQ1AgOHqqoQ@mail.gmail.com> <1422903136.21689.114.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1422903136.21689.114.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2015 10:52 AM, Eric Dumazet wrote:
> On Mon, 2015-02-02 at 11:27 +0100, Michal Kazior wrote:
> 
>> While testing I've had my internal GRO patch for ath10k and no stretch
>> ack patches.
> 
> Thanks for the data, I took a look at it.
> 
> I am afraid this GRO patch might be the problem.
> 
> It seems to break ACK clocking badly (linux stack has a somewhat buggy
> tcp_tso_should_defer(), which relies on ACK being received smoothly, as
> no timer is setup to split the TSO packet.)

It is a big throughput win to have fewer TCP ack packets on
wireless since it is a half-duplex environment.  Is there anything
we could improve so that we can have fewer acks and still get
good tcp stack behaviour?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

