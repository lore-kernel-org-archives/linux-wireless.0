Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38224 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbYIRXKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 19:10:53 -0400
Received: by gxk9 with SMTP id 9so109508gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 16:10:52 -0700 (PDT)
Message-ID: <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> (sfid-20080919_011057_085624_6416966D)
Date: Thu, 18 Sep 2008 16:10:52 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Ingo Molnar" <mingo@elte.hu>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
	 <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
	 <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 4:04 PM, Steven Noonan
> I always get "1 megabit/sec". It actually measures (at best) to be a
> throughput of 8mbits/sec, though the average (due to strange random
> packet loss) is about 4mbits/sec. --

Yeah, iwconfig reports a wrong rate, should be easy to fix but I
haven't yet looked at it. If you can fix it it'd be appreciated.

> And that was with aggregation
> re-enabled via your patch.

That patch just fixes aggregation for mac80211 after the TX MQ
changes, its seems ath9k aggregation is broken. Looking into that now.

> Without, it never exceeds 1mbit/sec
> (actual, not just as indicated by iwconfig.

Right.

  Luis
