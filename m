Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41315 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752369AbXLHDrx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 22:47:53 -0500
Date: Sat, 8 Dec 2007 04:42:02 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: rc80211-pid: some tuning test results
Message-ID: <20071208044202.20c91ae1@morte> (sfid-20071208_034757_175272_60FD4649)
In-Reply-To: <20071205131310.6b4c232a@morte>
References: <1196622331.7472.4.camel@localhost>
	<20071204024146.15689ee3@morte>
	<40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
	<200712050849.46760.hs4233@mail.mn-solutions.de>
	<20071205105230.0ecc56dc@morte>
	<20071205131310.6b4c232a@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I run further tests. It looks like I found out the optimal parameters for
minimizing latency or maximizing throughput or maximizing reliability.

Best throughput:
rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
1       8        11     14       10     12       3      0        1

Best latency:
rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
1       8        15     12       8      16       2      1        1

Best reliability:
rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
1       8        4      15       8      15       3      0        0

While a general good setup looks to be:

rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
1       8        10     15       9      15       3      0        1

I would then adopt a system like the one outlined below in order to take
into account userspace parameters.

We have Three userspace parameters, ranging from 0 (don't care) to 5
(care the most). I don't think it makes any sense to have more granularity
here.

Starting from:
rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
1       8        10     15       9      15       3      0        1

We add:
For every threshold point:
rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
		+0.2	-0.2	+0.2	-0.6

latency points:
rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
		+1	-0.6	-0.2	+0.2	-0.2	+0.2

reliability points:
rc_imul rc_idiv rc_pf   rc_p    rc_i    rc_d    rc_sm_s rc_sh_s rc_sh_d
		-1.2		-0.2				-0.2

I'll now try to implement this sorting out the fixed point calculation
issues.


--
Ciao
Stefano
