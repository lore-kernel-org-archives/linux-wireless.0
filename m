Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59869 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbbBFOIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 09:08:20 -0500
Received: by mail-wi0-f174.google.com with SMTP id n3so2735825wiv.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 06:08:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423230001.31870.128.camel@edumazet-glaptop2.roam.corp.google.com>
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
	<1423147286.31870.59.camel@edumazet-glaptop2.roam.corp.google.com>
	<1423156205.31870.86.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQ=WaKLV=r6qWaWAEfyDr2pqMWpm4NDmnek92TEVndnxRQ@mail.gmail.com>
	<1423230001.31870.128.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Fri, 6 Feb 2015 15:08:19 +0100
Message-ID: <CA+BoTQnEvF_mi68gyFns67oKC=8jEYdi3tLuW5dNj20KwUNs9A@mail.gmail.com> (sfid-20150206_150825_684695_AED2110D)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Michal Kazior <michal.kazior@tieto.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Eyal Perry <eyalpe@dev.mellanox.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2015 at 14:40, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2015-02-06 at 10:42 +0100, Michal Kazior wrote:
>
>> The above brings back previous behaviour, i.e. I can get 600mbps TCP
>> on 5 flows again. Single flow is still (as it was before TSO
>> autosizing) limited to roughly ~280mbps.
>>
>> I never really bothered before to understand why I need to push a few
>> flows through ath10k to max it out, i.e. if I run a single UDP flow I
>> get ~300mbps while with, e.g. 5 I get 670mbps easily.
>>
>
> For single UDP flow, tweaking /proc/sys/net/core/wmem_default might be
> enough : UDP has no callback from TX completion to feed following frames
> (No write queue like TCP)
>
> # cat /proc/sys/net/core/wmem_default
> 212992
> # ethtool -C eth1 tx-usecs 1024 tx-frames 120
> # ./netperf -H remote -t UDP_STREAM -- -m 1450
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
>
> 212992    1450   10.00      697705      0     809.27
> 212992           10.00      673412            781.09
>
> # echo 800000 >/proc/sys/net/core/wmem_default
> # ./netperf -H remote -t UDP_STREAM -- -m 1450
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
>
> 800000    1450   10.00     7329221      0    8501.84
> 212992           10.00     7284051           8449.44

Hmm.. I confirm it works. However the value at which I get full rate
on a single flow is more than 2048K. Also using non-default
wmem_default seems to introduce packet loss as per iperf reports at
the receiver. I suppose this is kind of expected but on the other hand
wmem_default=262992 and 5 flows of UDP max the device out with 0
packet loss.


Michał
