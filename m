Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:64154 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaJ0Ou6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 10:50:58 -0400
Message-ID: <544E5BCF.6000703@neratec.com> (sfid-20141027_155101_570907_EE82A498)
Date: Mon, 27 Oct 2014 15:50:55 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrien Decostre <ad.decostre@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: Questions regarding ath9k and new EN 300 328 regulation
References: <CAOtFK_Ue0xjEaYY3qm0n2Tj=Hnu1dbphupmdZmiouVuGLnktoA@mail.gmail.com> <544E21D4.9020401@neratec.com> <CAOtFK_XWgBxPNy77XVDc1XbYUkdPSd-Q9wmREN2iL6A8bzFDoQ@mail.gmail.com>
In-Reply-To: <CAOtFK_XWgBxPNy77XVDc1XbYUkdPSd-Q9wmREN2iL6A8bzFDoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2014 03:18 PM, Adrien Decostre wrote:
> Hello Zefir,
> 
> Thanks a lot for your answer. This helps me a lot.
> If I correctly understand, the ability of ath9k to detect all pulses
> may also depend of the platform performances. So on an embedded
> platform with limited performances, we may observe more pulses losses
> than on a more powerful platform. Is this a right statement?
> 
No, there is no bottleneck in the platform performance. Presumed radar pulses are
reported as RX_ERROR descriptors and even lower end embedded systems are able to
handle the load. What makes the difference with the minimum pulse width is the
chip DFS engine's ability to isolate and identify very short spikes as potential
radar pulses.

This goes very deeply into material I had available under NDA while implementing
the DFS support for ath9k. If you intend to work on that topic, I encourage you to
contact the folks at QCA and join their 'NDA for Developers' program. The document
you want to read is 'Baseband DFS 2 (Radar) Micro-Architecture'.

> What about the CONFIG_ATH9K_DFS_CERTIFIED build options? Do we need it
> to enable the detection of 0.5usec. pulses?
> 
Yes, this driver specific flag (also available for 10k) you need to set to get the
DFS detector built (not related to pulse width). It essentially shifts the
responsibility of the product working in restricted bands to you / the manufacturer.


> Thanks in advance for your answer.
> 
> Best regards
> 
> Adrien
> 

Good Luck,
Zefir
