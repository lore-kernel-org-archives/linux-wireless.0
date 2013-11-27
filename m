Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56265 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3K0PZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 10:25:04 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21142.3512.516720.706589@gargle.gargle.HOWL> (sfid-20131127_162509_504939_0D7AC421)
Date: Wed, 27 Nov 2013 20:50:24 +0530
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k pending patches
In-Reply-To: <5295E60D.90600@open-mesh.com>
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>
	<21141.51790.303263.385517@gargle.gargle.HOWL>
	<5295E60D.90600@open-mesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli wrote:
> What patch is addressing this change? And can could please explain a
> bit more about what is needed to address the key cache corruption problem?
> 
> Right now I am working on a "reactive behavior" which tries to detect
> a cache corruption event and subsequently re-install all the keys one
> by one to ensure they are back to a proper state.
> 
> What does this ALWAYS_PERFORM_KEY_SEARCH bit do? Is it set within the
> initvalues?

Normally, key search for decryption is done by the HW only for the first frame
in an aggregate. Enabling ALWAYS_PERFORM_KEY_SEARCH makes the HW do a key lookup
for each sub-frame in aggregate.

This is one step in addressing the key cache corruption problem, but
it comes at a cost. The HW MAC is stressed more when this bit is enabled,
especially when the number of associated clients is high.

This issue was first seen in AR9300 and I don't think it has been
fixed in any later chip since the workaround of enabling ALWAYS_PERFORM_KEY_SEARCH
works fine in actual usage.

But, in some high-interference environments, the key cache gets corrupted
and large number of decrypt errors are seen. The root cause is not known
and the workaround is to set all the keys in the HW again, when this happens.

Still, this is not sufficient and sometimes decrypt errors are not received
at all from the HW, since the flags in the RX descriptor are mangled, so just
monitoring the RX path in the driver is not enough and a periodic timer
comparing the HW keys with the driver is needed. If any mismatch is seen,
the keys are programmed again in the HW.

So, if ALWAYS_PERFORM_KEY_SEARCH is enabled, we need to see how the driver/HW
performs with 16 associated clients or more. Internally, it was enabled on
a per-project basis, but it has been enabled by default recently. But, I think
this should be tested properly.

As for the RX-path/timer workaround, it's just a nasty hack. :-)

Sujith
