Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:39287 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab3BUX4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 18:56:07 -0500
Received: by mail-vc0-f172.google.com with SMTP id l6so67172vcl.17
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2013 15:56:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5126B368.9010209@candelatech.com>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
	<20770.57339.20017.225929@gargle.gargle.HOWL>
	<51255360.6060603@candelatech.com>
	<51257304.10109@candelatech.com>
	<20773.31380.740958.31338@gargle.gargle.HOWL>
	<5125B39F.3010200@candelatech.com>
	<51265AC3.5030304@candelatech.com>
	<5126A993.8060408@candelatech.com>
	<CAJ-Vmo=FC=jdJ9VyZtZy_nbdGhCCfJ9dhS3993fwneGhFjoBJg@mail.gmail.com>
	<5126B368.9010209@candelatech.com>
Date: Thu, 21 Feb 2013 15:56:06 -0800
Message-ID: <CAJ-Vmom3v1+==u0RS8d6m+P-=DR8A755--t2_gQR+6Szf5N5VQ@mail.gmail.com> (sfid-20130222_005633_093285_4DF5DA13)
Subject: Re: 3.7.6+: ath9k: tx logic locks up after taking attenuation very high.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right. As you increase attenuation, two things happen:

* You're going to see lots more filtered frames pop up; which may
involve pause/unpause of the queue;
* You're going to see BAR frames go out, which will involve
pausing/unpausing the queue.

So you may have found some very nice way to reproduce pause/unpause
related problems that are brought on by lots of TX failures leading to
BARs and filtered frames.

(Having your BAR frames be filtered .. god I hope not.)

So see whether there's some odd scenario where a queue is unpaused and
things aren't drained from the pending queue?



Adrian
