Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60817 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2LDTpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 14:45:51 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1708841wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 11:45:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BE2D84.4010809@candelatech.com>
References: <50BD2B46.5080706@candelatech.com>
	<CAB=NE6XQGKTFq_yQt7QuFmozNCDT42w7B8qSdv_FY4arOQziZg@mail.gmail.com>
	<50BE2D84.4010809@candelatech.com>
Date: Tue, 4 Dec 2012 11:45:49 -0800
Message-ID: <CAJ-Vmom==i7Gn-PvYc+ruAPTWbnr1_Lah0913TgmNHE2tRwY0A@mail.gmail.com> (sfid-20121204_204554_737712_6467610A)
Subject: Re: Allow over-riding regdomain in NIC when CFG80211_CERTIFICATION_ONUS
 is enabled?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CTL edge is a regulatory concept where you have 'edges' to a
regulatory domain that imposes further restrictions.

For example, say you have 5500 -> 5600 as a certain set of rules (max
txpower 10), and 5400 - 5500 as a certain set of rules (max tx power
20).

The spectral mask for 802.11 rates has a certain dB dropoff at the
edge. That bleeds to the adjacent channels.

Now, you can configure a channel at 5490 to have a TX power of 20,
_BUT_ the spectral mask means that there'll be some non-zero amount of
RF energy "bled" out over the adjacent channels, which includes the
5500-5600MHz range. Because of this, you need some extra rule that
defines what the TX power should be at that particular boundary.

Now, for this particular scenario you could infer it from the lower TX
power at 5500-5600, but there are still requirements for meeting
maximum power output at band edges where the adjacent band is some
licenced spectrum or something that we don't run 802.11 on. So we
don't have a normal TX power rule for that channel; instead we need to
use a CTL rule that says "at this frequency edge, do X."

For further information, have a read of how the ctl edge stuff works
in the driver and be prepared to consume some nice wine whilst doing
so, in order to prevent clawing at your eyeballs at the hoops  that
you jump through.



Adrian
