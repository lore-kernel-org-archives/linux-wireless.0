Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:45741 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaJ0KvM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 06:51:12 -0400
Message-ID: <544E21D4.9020401@neratec.com> (sfid-20141027_115115_334983_7FFAF047)
Date: Mon, 27 Oct 2014 11:43:32 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrien Decostre <ad.decostre@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Questions regarding ath9k and new EN 300 328 regulation
References: <CAOtFK_Ue0xjEaYY3qm0n2Tj=Hnu1dbphupmdZmiouVuGLnktoA@mail.gmail.com>
In-Reply-To: <CAOtFK_Ue0xjEaYY3qm0n2Tj=Hnu1dbphupmdZmiouVuGLnktoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2014 05:23 PM, Adrien Decostre wrote:
> 
> I am looking for information about the compliancy of the ath9k driver
> to the EN 300 328 ETSI regulation.
> 
> Would someone know if ath9k has already been tested for this regulation?
> 
> Is it needed to enable any specific flag in ath9k to guarantee
> compliancy to the adaptivity tests described in EN 300 328?
> 
> 
The pattern detector currently used in ath was initially developed for ath9k when
EN 300.328 v1.5.1 was released. It passed the ETSI certification in a German lab
and the source code (besides moving it up in the tree to be also available for
10k) was basically not touched ever since.

I did not track all the DFS requirement changes up to the latest v1.9.1 draft, but
afaik the sole difference relevant for the detector is the reduction of the
shortest pulses width in the test pattern specification from 0.7 to 0.5us. With
that, the chance of the current implementation to pass a v1.8 certification
depends on ath9k's ability to detect the shorter pulses. I did some initial
measurements years ago to get a rough picture, which showed that the ath9k is
losing like 30% of the 0.5us pulses (as compared to .7us).

With the patches you referred, YMMV - you would need to perform thorough
statistical analyses to get an estimate on whether it would pass.

As for the adaptivity tests, they are not part of DFS (see note in 4.9.1) and
maybe would best fit within the ACS module
(http://wireless.kernel.org/en/users/Documentation/acs). The current DFS support
available in ath9k is limited to bare radar detection, which is enabled through
CONFIG_CFG80211_CERTIFICATION_ONUS.


Cheers,
Zefir
