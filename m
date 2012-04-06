Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59305 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2DFWa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 18:30:28 -0400
Received: by dake40 with SMTP id e40so3159495dak.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 15:30:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7F20C1.208@candelatech.com>
References: <1333469939-26213-1-git-send-email-greearb@candelatech.com>
	<4F7C3815.8060902@openwrt.org>
	<4F7C652D.5050702@candelatech.com>
	<4F7F1F13.8060003@openwrt.org>
	<4F7F20C1.208@candelatech.com>
Date: Fri, 6 Apr 2012 15:30:27 -0700
Message-ID: <CAJ-VmonpczF+wAkhJKx1=o9bnMAsUyUfjiSBreT-FeJp4pEnHA@mail.gmail.com> (sfid-20120407_003032_154243_A164A016)
Subject: Re: [PATCH 2/2] ath9k: Add more recv stats.
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've thought about doing exactly that with the BSD ath/hal statistics code.

It's useful having all those fine grained counters, but I do think
some users will want to compile them out for whatever the performance
reason is. Especially in the net80211 case where it may have to do a
hashtable lookup just to add some error counters.

I'd do it with some kind of macro which does the statistics
incrementing, then compile that macro to a null statement if stats
aren't being kept.


Adrian
