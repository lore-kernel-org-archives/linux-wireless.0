Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63852 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2E1GuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 02:50:08 -0400
Received: by dady13 with SMTP id y13so3769589dad.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 May 2012 23:50:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC2F73F.4070701@candelatech.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<4FC0F8CE.1030303@candelatech.com>
	<20417.972.888113.821079@gargle.gargle.HOWL>
	<20417.1857.115550.807746@gargle.gargle.HOWL>
	<4FC2437C.9090106@candelatech.com>
	<CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
	<4FC2F73F.4070701@candelatech.com>
Date: Sun, 27 May 2012 23:50:08 -0700
Message-ID: <CAJ-VmonMtRUZpidJERT7hRUDJNgyoMdVovXoG5WdStH6zk7yFQ@mail.gmail.com> (sfid-20120528_085013_597449_B3FBD9E3)
Subject: Re: Anyone doing WiFi throughput tests?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ah, Osprey is AR93xx series stuff. Well, not strictly speaking, but
that "family."

I'd have to go and check what the current state of all the latest 11n
chips are. Luis, Sujith and Felix would know better than I; I'm still
stuck in the land of AR92xx in FreeBSD (at least for the next few
weeks.)

Also, FreeBSD on 2x2 (AR9160) hostap:


TCP sta -> hostap:

[SUM]  0.0-10.0 sec    178 MBytes    149 Mbits/sec

UDP sta -> hostap:


[ ID] Interval       Transfer     Bandwidth       Jitter   Lost/Total Datagrams
[  3]  0.0-10.1 sec    274 MBytes    228 Mbits/sec  0.135 ms 17045/212291 (8%)

TCP is around the expected spot, but I've seen it around 160MBit in
the past. I think I messed up something with BAR/TX scheduling. The
UDP RX is likely another scheduling issue; I seem to be occasionally
overflowing the RX descriptor list.

In any case, I'll fix it up and report back, just as a comparison point.



Adrian
