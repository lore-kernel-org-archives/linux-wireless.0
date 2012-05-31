Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113Ab2EaTYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 15:24:17 -0400
Received: by pbbrp8 with SMTP id rp8so1878936pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 12:24:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmokf+EfpQ9m_8W6q3q-nsKgMMTn0w7=BgnW26AWh5vZB2g@mail.gmail.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<4FC0F8CE.1030303@candelatech.com>
	<20417.972.888113.821079@gargle.gargle.HOWL>
	<20417.1857.115550.807746@gargle.gargle.HOWL>
	<4FC2437C.9090106@candelatech.com>
	<CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
	<4FC2F73F.4070701@candelatech.com>
	<CAJ-VmonMtRUZpidJERT7hRUDJNgyoMdVovXoG5WdStH6zk7yFQ@mail.gmail.com>
	<20419.9719.160216.124618@gargle.gargle.HOWL>
	<CAJ-Vmokf+EfpQ9m_8W6q3q-nsKgMMTn0w7=BgnW26AWh5vZB2g@mail.gmail.com>
Date: Thu, 31 May 2012 12:24:17 -0700
Message-ID: <CAJ-Vmok8oK6G1U2GR074n3QWJUr924WitP4Xn47wG6k95msfDA@mail.gmail.com> (sfid-20120531_212421_322148_42E333C0)
Subject: Re: Anyone doing WiFi throughput tests?
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. yup, I got it to 250MBit UDP. :-)

It turns out that (at least in FreeBSD-9), the scheduler and sleep
state behaviour when doing adaptive power save/sleep state (ie,
adaptive CPU speed changes, going into C2) is enough to negatively
impact my iperf and ath/net80211 taskqueue scheduling.

When I nail it back up to C1, fixed speed - everything is perfectly fine.

I'll go and do some further digging into this, but it's good to see
that I can squeeze decently high throughput out of the 2x2 NICs.



Adrian
