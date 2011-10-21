Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:46634 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752090Ab1JUUUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 16:20:09 -0400
Date: Fri, 21 Oct 2011 22:20:38 +0200
From: Clemens Buchacher <drizzd@aon.at>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: ath9k: irq storm after suspend/resume
Message-ID: <20111021202038.GA1523@ecki.lan> (sfid-20111021_222016_683485_93623F09)
References: <CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
 <20111005062528.GA1403@ecki>
 <CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
 <CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
 <20111015093902.GA23520@ecki>
 <CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com>
 <20111018064459.GA1442@ecki>
 <CAJ-Vmo=Qt3rGDbM0yOvFuz6Pksdx9bdm8HEBnhfjP6=zjGOgTA@mail.gmail.com>
 <20111021102221.GA1463@ecki.lan>
 <CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmonaec_i5d_LGupY5uwzMUn3CzNn-rGSh6oqLOHc8ewFVg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 21, 2011 at 10:10:21PM +0800, Adrian Chadd wrote:
> 
> I assume you have disabled the NIC power save option. Not just APSM,
> etc, but the powersave options in iw. I don't know what they are,
> sorry, only that they exist.

I am not sure if that's what you mean, but if I set "iwconfig wlan0
power off" it makes no difference.

> I suggest modifying ath_intr() so if there is an interrupt storm,
> disable _all_ sources of interrupts (ie, set sync_cause, async_cause
> to 0, set imr to 0, set ier to 0) and see if it continues occuring.

They keep coming with this too.

> If the interrupt storm continue occuring, try putting the whole NIC to
> sleep entirely (ie, call pcipowersave to put the NIC to sleep, then
> make sure the NIC -stays- asleep somehow, ie so nothing else tries
> waking it up - I don't know how to do this, likely you'll have to
> clear some interface flag so the rest of the ath9k and 802.11 stack
> thinks the nic is actually down for the count) and see if you're still
> getting spurious interrupts.

I am now calling

 ath9k_hw_ops(sc->sc_ah)->config_pci_powersave(sc->sc_ah, true);
 ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);

right before request_irq, and the interrupts still come. And the
device is in FULL_SLEEP the whole time, at least according to
ah->power_mode.

Clemens
