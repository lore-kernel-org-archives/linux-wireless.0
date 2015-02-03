Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49006 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbbBCPED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 10:04:03 -0500
Message-ID: <1422975839.907.17.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150203_160410_573524_1281A049)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Date: Tue, 03 Feb 2015 07:03:59 -0800
In-Reply-To: <1422973660.907.10.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	 <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
	 <1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQkV+mOZfe_Niz5101sMQeaV6muKCsShptjGQ1AgOHqqoQ@mail.gmail.com>
	 <1422903136.21689.114.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1422926330.21689.138.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQkMikA8wxm1ce2DkKhPB0HiKeAqT7f+sQ=91W40z=X0Rg@mail.gmail.com>
	 <1422973660.907.10.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-03 at 06:27 -0800, Eric Dumazet wrote:

> Are packets TX completed after a timer or something ?
> 
> Some very heavy stuff might run from tasklet (or other softirq triggered) event.
> 

Right, commit 6c5151a9ffa9f796f2d707617cecb6b6b241dff8
("ath10k: batch htt tx/rx completions")
is very suspicious.

Please revert it.

BTW, ath10k_htt_txrx_compl_task() runs from softirq context, so the 
_bh() prefixes are not really needed.

It seems lot of batching happens in wifi drivers, not necessarily at the
right places.



