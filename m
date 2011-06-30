Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36986 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1F3Cgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 22:36:51 -0400
Received: by bwd5 with SMTP id 5so1472969bwd.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 19:36:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=3imkrK7Chzb5_-c2GT5omo0Ae=g@mail.gmail.com>
References: <BLU158-w3443764A60DE4B497231DB87570@phx.gbl> <BANLkTinhc2QAgWTk9tur9Y-m2i3tDhvXOQ@mail.gmail.com>
 <BANLkTi=3imkrK7Chzb5_-c2GT5omo0Ae=g@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 29 Jun 2011 19:36:30 -0700
Message-ID: <BANLkTinQOWiddbSiyCDMhwu78fFUkw+seA@mail.gmail.com> (sfid-20110630_043655_000444_1E41E810)
Subject: Re: [ath9k-devel] STBC functionality details request
To: Fred Matthews <fredmm@hotmail.co.uk>
Cc: Adrian Chadd <adrian@freebsd.org>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 6:17 PM, Fred Matthews <fredmm@hotmail.co.uk> wrote:
>
> Hi,
> Thanks for replying Adrian,
>
> OK, just for clarity, you are saying for 1-stream STBC NICs
> (AR9380/9280), when I enable STBC from hostapd, the driver only
> transmits in STBC (transmits multiple copies of data to each antenna)
> if it sending at MCSs 0-7 (1 stream rates), due to low signal quality
> or via fixing the MCS to those values. For all other MCSs STBC is
> disabled.
>
> Does the rate adaptation (minstrel/ath9k) tell the driver to use STBC,
> or is this done at automatically at a lower level?
>
> Any other information about STBC would be appreciated.
>
You should really look at the 802.11n standard to understand how they
implement STBC. From the driver side, from what I can tell, there is
never a downside (rate-wise) to enabling STBC for transmissions at
MCS0--MCS7. Thus, minstrel_ht turns it on by default.

Dan
