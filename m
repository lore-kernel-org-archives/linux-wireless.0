Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40362 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbBFJ6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 04:58:01 -0500
Received: by mail-wi0-f169.google.com with SMTP id h11so1253315wiw.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 01:58:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA93jw45o-Tnt4hEYgc-wHJ26J11dDZLptO9ZONy0Jxp350S3A@mail.gmail.com>
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
	<CAA93jw45o-Tnt4hEYgc-wHJ26J11dDZLptO9ZONy0Jxp350S3A@mail.gmail.com>
Date: Fri, 6 Feb 2015 10:57:59 +0100
Message-ID: <CA+BoTQmU4VXw7yD9bLAvrr6mqSbkYcNHZ1o-CcLUtb+kbQa7DQ@mail.gmail.com> (sfid-20150206_105811_114649_48983736)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Michal Kazior <michal.kazior@tieto.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Eyal Perry <eyalpe@dev.mellanox.co.il>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 February 2015 at 20:50, Dave Taht <dave.taht@gmail.com> wrote:
[...]
> And I really, really, really wish, that just once during this thread,
> someone had bothered to try running a test
> at a real world MCS rate - say MCS1, or MCS4, and measured the latency
> under load of that...

Time between frame submission to firmware and tx-completion on one of
my ath10k machines:

Legacy 54mbps: ~18ms
Legacy 6mbps: ~37ms
11n MCS 3 (nss=0): ~13ms
11n MCS 8 (nss=1): ~6-8ms
11ac NSS=1 MCS=2: ~4-6ms
11ac NSS=2 MCS=0: ~5-8ms

Keep in mind this is a clean room environment so retransmissions are
kept at minimum. Obviously with a noisy environment you'll get retries
at different rates and higher latency.


Michał
