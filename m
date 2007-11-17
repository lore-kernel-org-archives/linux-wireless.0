Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:15465 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbXKQRGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2007 12:06:34 -0500
Received: by an-out-0708.google.com with SMTP id d31so309341and
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2007 09:06:30 -0800 (PST)
Message-ID: <40f31dec0711170906u53a4dd09p251a54a1ed53c16e@mail.gmail.com> (sfid-20071117_170642_160614_D6084442)
Date: Sat, 17 Nov 2007 19:06:30 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org,
	madwifi-devel <madwifi-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] ath5k: Per queue interrupt handling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello ppl ;-)

I'm working on implementing per queue interrupt setting (well i've
done it already and i'm currently testing it) on secondary interrupt
mask registers. Interrupts may be enabled on each queue by using txq
flags (checkout ath5k.h -ah.h on madwifi- and base.c -if_ath.c in
madwifi-) instead of setting global imr.

This is what i've found so far (tests on a 5414 chip):

a) I disabled all tx interrupts on sc->sc_imask (primary interrupt
mask register) and verified that tx wasn't working (i only got rxok
and bmiss interrupts).

b) Then I enabled them per queue (TXOK/TXERR for start). It wasn't
supposed to work (since primary interrupt mask register masks primary
interrupt status register on hw -at least that's what i thought it
did) but it did (i had to remove status &= sc->sc_imask from
ath(5k)_intr) since i got txok interrupts and tx worked fine.

c) Enabling tx interrupts on primary interrupt mask register overrides
secondary mask registers. I set 0 on secondary mask register for all
queues (flags = 0) and i got tx interrupts if i set INT_TX on primary
imr.

d) BMISS interrupts are non-fatal on 5414 (eg. no reset needed, after
a few interrupts, isr gets auto-cleaned and keeps working). Actually i
figured out we don't handle BMISS interrupts on ath5k, i didn't got
any problems so far with any of the cards i tested. Maybe we need to
review BMISS interrupt handling in moth ath5k/madwifi.

So it seems that what we get on primary interrupt status (via get_isr)
takes into account both primary interrupt mask register and secondary
mask registers (we need to see if that's the case for all mac chips
and not just 5414).

A Q for linux-wireless: I don't know what is the right thing to do
about per queue interrupts, what about making a function that reads
secondary interrupt status register so we can also get for which tx
queue is this interrupt ? Could that help more in wme ? Does mac80211
make use of this info (eg. schedule each q differently) ?

One last thing: We currently enable TXDESC and TXEOL interrupts for
data queues and TXDESC interrupt for beacon q but we don't handle
these interrupts on interrupt handler, so what's the point of setting
them up ? Also have you ever got such interrupts and under what
circumstances ? Because i did a few tests and i got weird results (eg.
i got txdesc and txeol interrupt at the same time -isr reads TXDESC |
TXEOL = 0x480). Also have in mind that TXEOL interrupt is not even
included in ath5k.h/ah.h ! I checked out ath5k/madwifi/ath (freebsd)
code and it's the same everywhere, why do we set these interrupts ?
TXDESC is supposed to declare that we need to set up a txdescriptor
and TXEOL is supposed to declare that txdescriptor is empty (we don't
know for what q because we only read primary isr so that's pointless !
eg. when i got txdesc + txeol from pisr it might be that txdesc was
for beacon q and txeol for the data q)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
