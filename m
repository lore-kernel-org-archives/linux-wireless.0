Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61427 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1JUOKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:10:22 -0400
Received: by ywf7 with SMTP id 7so3899182ywf.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 07:10:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111021102221.GA1463@ecki.lan>
References: <CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
	<20111004181534.GA1502@ecki>
	<CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
	<20111005062528.GA1403@ecki>
	<CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
	<CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
	<20111015093902.GA23520@ecki>
	<CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
	<20111018064459.GA1442@ecki>
	<CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
	<20111021102221.GA1463@ecki.lan>
Date: Fri, 21 Oct 2011 22:10:21 +0800
Message-ID: <CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com> (sfid-20111021_161025_990041_D37AD28D)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2011 18:22, Clemens Buchacher <drizzd@aon.at> wrote:

> It matches AR_SREV_9285, but it does not match AR_SREV_9285E_20.

Ok. Well, I've read the ar9285 host documentation that I've gotten my
hands on and I can't see anything obvious. All I can think of is that
something else is throwing those interrupts - whether it's the NIC
throwing the error, or whether its the bus itself throwing an error
and you're seeing the AR9285 because it's the only thing attached. I
however know next to nothing about PCI/PCIe and the various fruity
behaviour seen.

I assume you have disabled the NIC power save option. Not just APSM,
etc, but the powersave options in iw. I don't know what they are,
sorry, only that they exist.

I suggest modifying ath_intr() so if there is an interrupt storm,
disable _all_ sources of interrupts (ie, set sync_cause, async_cause
to 0, set imr to 0, set ier to 0) and see if it continues occuring.

If the interrupt storm continue occuring, try putting the whole NIC to
sleep entirely (ie, call pcipowersave to put the NIC to sleep, then
make sure the NIC -stays- asleep somehow, ie so nothing else tries
waking it up - I don't know how to do this, likely you'll have to
clear some interface flag so the rest of the ath9k and 802.11 stack
thinks the nic is actually down for the count) and see if you're still
getting spurious interrupts.

If you are at this point, the only other possible thing I can think of
doing involves a PCIe bus analyser, and you/I don't have access to
those. :-)



Adrian
