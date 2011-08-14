Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1HNCrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 22:47:16 -0400
Received: by gwaa12 with SMTP id a12so2710166gwa.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 19:47:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110813180910.GB16149@vmraj-lnx.users.atheros.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1313211498-14442-3-git-send-email-rmanohar@qca.qualcomm.com>
	<CAJ-Vmo=dzs4ZsmXq2C6gCsy+vAgdKAAQ1ZjC2VSPTtfw-aexuA@mail.gmail.com>
	<20110813180910.GB16149@vmraj-lnx.users.atheros.com>
Date: Sun, 14 Aug 2011 10:47:15 +0800
Message-ID: <CAJ-Vmo=oNUd+eKgLGgCWvahKJoPR1QdpohNcZG8s_MK9G4vM2Q@mail.gmail.com> (sfid-20110814_044719_931257_4570E40C)
Subject: Re: [PATCH 03/11] ath9k: Re-enable RXOEL interrupt after processing
 rx buffers
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 August 2011 02:09, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
> On Sat, Aug 13, 2011 at 06:53:12PM +0800, Adrian Chadd wrote:
>> .. again, I'll just point out that because I was seeing this when the
>> PCU honestly had hit the end of the RX descriptor list (lots of radar
>> phyerr frames), I needed to kick the PCU to start again.
>>
> so without PCU restart you are still getting rxeol. am i right?

Yup. That's because I've actually hit the end of the RX descriptor
list and since the 11n NIC code (so ath9k, and FreeBSD's ath when
using an 11n NIC) doesn't enable the self-link descriptor trick, the
PCU is now "stopped". I hit this when doing radar phyerr frame
reception and (artificially) generated lots of radar phyerr frames
whilst keeping the CPU busy. The RX thread would be CPU starved and it
wouldn't be able to service the RX descriptor list in time.

I've never hit it in normal operation, because (a) I wasn't doing RX
phyerr reception, and (b) I wasn't _trying_ to break RX under load.
:-)

The next problem (which I hinted at in another email) is that I'm
seeing an AR9280 NIC (Ubiquiti SR71-E) get itself into a situation
where its unable to do any kind of DMA, and constantly fires off RXEOL
interrupts, even if I then reset the PCU RX on RXEOL. The only fix is
a cold reset - a warm reset doesn't trigger it. So, I wonder what is
causing your underlying issues on Merlin, as it doesn't sound like
you've hit the end of the RX descriptor list (or you'd have to restart
the PCU w/ a new RX descriptor list to fix it.) Your problem may be
tangentally related to what I'm seeing :-)



Adrian
