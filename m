Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35336 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbbBEOso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 09:48:44 -0500
Message-ID: <1423147722.31870.65.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150205_154849_704308_4F25160D)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Neal Cardwell <ncardwell@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Date: Thu, 05 Feb 2015 06:48:42 -0800
In-Reply-To: <CA+BoTQmcShK0U_cXvEOLY_8y7LH8x3taTgjcyMzv0MLVn4UtCA@mail.gmail.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	 <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
	 <1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQkV+mOZfe_Niz5101sMQeaV6muKCsShptjGQ1AgOHqqoQ@mail.gmail.com>
	 <1422903136.21689.114.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1422926330.21689.138.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQkMikA8wxm1ce2DkKhPB0HiKeAqT7f+sQ=91W40z=X0Rg@mail.gmail.com>
	 <1422973660.907.10.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQmvUuFdfYF=wVMYxrf_nQZB5GCV=LvDZVvfs-3hAE4WKw@mail.gmail.com>
	 <1423051045.907.108.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQ=BDcQ779uKCuX+f40=4npXVF4MTQnpjKimNYAxPsxBoQ@mail.gmail.com>
	 <1423053531.907.115.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQ=qmCZz4CmSOvCOzMLowrDEG12XBffkTcYxjGqVD9604g@mail.gmail.com>
	 <1423055810.907.125.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1423056591.907.130.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1423084303.31870.15.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQnnwrv0nrKyGyQNvosz_E4e5fBa9iN8fpeqcd-iRfi17g@mail.gmail.com>
	 <1423141038.31870.38.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1423142342.31870.49.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQmcShK0U_cXvEOLY_8y7LH8x3taTgjcyMzv0MLVn4UtCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-02-05 at 14:44 +0100, Michal Kazior wrote:

> I do get your point. But 1.5ms is really tough on Wi-Fi.
> 
> Just look at this:
> 
> ; ping 192.168.1.2 -c 3
> PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
> 64 bytes from 192.168.1.2: icmp_seq=1 ttl=64 time=1.83 ms
> 64 bytes from 192.168.1.2: icmp_seq=2 ttl=64 time=2.02 ms
> 64 bytes from 192.168.1.2: icmp_seq=3 ttl=64 time=1.98 ms

Thats a different point.

I dont care about rtt but TX completions. (usually much much lower than
rtt)

I can have a 4 usec delay from the moment a NIC submits a packet to the
wire and I get TX completion IRQ, free the packet.

Yet the pong reply can come 100 ms later.

It does not mean the 4 usec delay is a problem.



