Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42771 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbbBFOfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 09:35:48 -0500
Message-ID: <1423233346.31870.136.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150206_153556_365742_62FA1ACB)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Neal Cardwell <ncardwell@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Eyal Perry <eyalpe@dev.mellanox.co.il>
Date: Fri, 06 Feb 2015 06:35:46 -0800
In-Reply-To: <CA+BoTQnEvF_mi68gyFns67oKC=8jEYdi3tLuW5dNj20KwUNs9A@mail.gmail.com>
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
	 <CA+BoTQnEvF_mi68gyFns67oKC=8jEYdi3tLuW5dNj20KwUNs9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-02-06 at 15:08 +0100, Michal Kazior wrote:

> Hmm.. I confirm it works. However the value at which I get full rate
> on a single flow is more than 2048K. Also using non-default
> wmem_default seems to introduce packet loss as per iperf reports at
> the receiver. I suppose this is kind of expected but on the other hand
> wmem_default=262992 and 5 flows of UDP max the device out with 0
> packet loss.

If you increase ability to flood on one flow, then you need to make sure
receiver has big rcvbuf as well.

echo 2000000 >/proc/sys/net/core/rmem_default

Otherwise it might drop bursts.

This is the kind of things that TCP does automatically, not UDP.


