Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:34013 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751461AbXLEMRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 07:17:52 -0500
Date: Wed, 5 Dec 2007 13:13:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: rc80211-pid: some tuning test results
Message-ID: <20071205131310.6b4c232a@morte> (sfid-20071205_121806_595871_F3A3F02E)
In-Reply-To: <20071205105230.0ecc56dc@morte>
References: <1196622331.7472.4.camel@localhost>
	<20071204024146.15689ee3@morte>
	<40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
	<200712050849.46760.hs4233@mail.mn-solutions.de>
	<20071205105230.0ecc56dc@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some results from recent tests. Each test lasted for 30 seconds.
Signal and noise figures have been provided by a prism2 card with an almost
isotropic antenna. Throughput tests have been made with a bcm4309 card, b43
driver.

Scenarios:
#1: very weak signal (ranging from -88 to -86dBm), low noise (-98dBm)
mostly produced by other devices in the area. High multi-path reflection
provided by grounded metal boxes between the two STAs. The b43 device has
been moved alternatively by 2cm to left and right, with an approximate
speed of 0.5cm/s.
#2: weak signal (-81dBm), very high noise (-86dBm) produced by a microwave
oven cooking vegetables at 750W. Multi-path reflection and moving as above.
#3: almost optimal conditions. Good signal (-43dBm) and low noise (-98dBm).
No multi-path reflection. Only moving as above.

Results: [all throughputs are in Mbps]
imul idiv   pf    p    i    d  sm_s sh_s sh_d   thr1   thr2   thr3
   1    8   25   15   10   20     3    1    1  1.300  0.055  14.40
   1    8   25   15   10   20     3    0    1  0.108  0.473  16.69
   1    8   25   15   10   20     3    0    0  0.745  0.190  12.17
   1    8   15   15   10   20     3    1    1  1.190  0.249  17.51
   1    8   15   15   10   20     3    0    1  0.624  0.134  13.80
   1    8   15   15   10   20     3    0    0  0.912  0.419  12.02
   1    8    5   15   10   20     3    1    1  1.370  1.180  12.06
   1    8    5   15   10   20     3    0    1  0.875  0.264  11.92
   1    8    5   15   10   20     3    0    0  0.739  0.971  11.76

   1    8   25   15   10   15     3    1    1  1.170  0.099  18.04
   1    8   25   15   10   15     3    0    1  0.797  0.296  11.93
   1    8   25   15   10   15     3    0    0  0.617  0.222  11.55
   1    8   15   15   10   15     3    1    1  1.690  1.380  11.19
   1    8   15   15   10   15     3    0    1  1.030  0.205  16.80
   1    8   15   15   10   15     3    0    0  1.190  0.062  17.07
   1    8    5   15   10   15     3    1    1  2.450  0.221  12.46
   1    8    5   15   10   15     3    0    1  1.610  0.193  18.16
   1    8    5   15   10   15     3    0    0  2.320  0.349  17.94

   1    8   25   15   15   20     3    1    1  1.690  0.790  12.38
   1    8   25   15   15   20     3    0    1  0.968  0.918  17.50
   1    8   25   15   15   20     3    0    0  1.160  0.134  11.59
   1    8   15   15   15   20     3    1    1  1.670  0.223  16.83
   1    8   15   15   15   20     3    0    1  0.734  0.164  12.28
   1    8   15   15   15   20     3    0    0  1.740  0.316  11.94
   1    8    5   15   15   20     3    1    1  0.886  0.620  17.00
   1    8    5   15   15   20     3    0    1  0.567  0.212  18.11
   1    8    5   15   15   20     3    0    0  1.080  0.089  12.13

   1    8   25   15   15   15     3    1    1  0.627  0.458  14.00
   1    8   25   15   15   15     3    0    1  0.521  0.617  12.07
   1    8   25   15   15   15     3    0    0  1.180  0.098  11.82
   1    8   15   15   15   15     3    1    1  1.450  0.366  17.40
   1    8   15   15   15   15     3    0    1  1.190  0.724  13.53
   1    8   15   15   15   15     3    0    0  1.250  0.627  18.28
   1    8    5   15   15   15     3    1    1  0.997  0.379  13.59
   1    8    5   15   15   15     3    0    1  0.550  0.240  11.68
   1    8    5   15   15   15     3    0    0  1.340  0.136  17.37


The second block of results looks good. There we can find the first and
third best results for scenario #1, best result for scenario #2, second
and fourth best for #3. It looks like Mattias's first guess for PID
coefficients was actually very accurate.


--
Ciao
Stefano
