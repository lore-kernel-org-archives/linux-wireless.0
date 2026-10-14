Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA0A44C502
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 08:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966703; cv=none; b=TyPd3zUkuwtLI8Oa4YIwC+YAqVPrXW+r8mnalB0J++IdLU7goqBSPLmbIEP4V2KMCSSHX66mbvHs5QP0JTWw/JTRgm3JtDJkoZMmrzrFvs7EIwmqBWVs5ZU6AxjAZy0UJYDtsh1oxVx8cQcdsZ+Nbi1/152Yv3C5h5YfVkxZMXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966703; c=relaxed/simple;
	bh=wI78vTL7TbkCe1RDN0a3FOHBkRgmq9gti4GvU5Iu8oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvhpR3mj+Xm1oGOgv77aW0SCPfYxDSCJHd7D5LI8i0ihxbuNnv7nwmJm7igo+6HqYg283HihzIhl6lxFDTgJNMiwtuRHCwlw5ItObBMRGNgLGxB+sYiGf+p4Tt4hUkcvotCbdhZOhiIwigJhokPz3bWvLnsMtDpnDJC0YtGJKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=E+5hBMBi; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="E+5hBMBi"
Received: (wp-smtpd smtp.wp.pl 49057 invoked from network); 14 Oct 2026 10:31:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1791966692; bh=hULOe3o0cD/v3Ud36/uN9gOIN1iLNKRLSoryBNrNPwA=;
          h=From:To:Cc:Subject;
          b=E+5hBMBisAXz7RV5MCZtBsaam9o7BV7xbMSKTRRJ4BW+OshiElDENdwWhttBwm+Su
           r63OV9o0GL6zf2c2JgdlLchUvF9zIAwLE0AneNgF9hIy0uy2/MZDhDLmj17N+5CUcQ
           2xW6Cm7WzY836ybMS8NG3D+0kErIxpS9+6jARPd7fEeKIOWCJXub+5BMm4ZKkg7Ue1
           7o18iXYxSEyb2XuwWdZdlaTW/SeQz7VYG9wbJ1S23t2OgQR1VtV7ajukLy5P6Wxp/k
           FJQuNtE4Uodsg4/k4Z8VoaoMZLxiLdyMW2MzGsVfcV3zhcjNEUJDaTUmkLdHUubE9m
           z/1iIjPQb9SWA==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 14 Oct 2026 10:31:31 +0200
Date: Wed, 14 Oct 2026 10:31:31 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] wifi: rt2x00: use VCO_IC 0x2 for RF3053 on 2.4 GHz
Message-ID: <20261014083131.GA62404@wp.pl>
References: <20261012133728.77780-1-hjf3108@gmail.com>
 <20261013102305.GA58849@wp.pl>
 <CABOQOSU8KHVUrSc+qkCrpGK9zDBc3dNRqaRWKQ7ka=S6uLLbQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABOQOSU8KHVUrSc+qkCrpGK9zDBc3dNRqaRWKQ7ka=S6uLLbQA@mail.gmail.com>
X-WP-MailID: 4215d6effce8200f905927d0651f94ef
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AZPx]                               

On Tue, Oct 13, 2026 at 08:49:44PM +0800, Jie Feng wrote:
> On Tue, 13 Oct 2026 at 18:23, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> >
> > Hi
> >
> > On Mon, Oct 12, 2026 at 09:37:27PM +0800, Ho Jie Feng wrote:
> > > Using the 0x1, the VCO calibration result is 0x7f on channels 6
> > > and below. Using 0x2 fixes it.
> > >
> > > Hardware: Netgear WNDA4100 (USB 0846:9013, RT3593 rev 0402, RF3053)
> > >
> > > Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> > > ---
> > > RFC for this since I am not sure if it is a generic fix, since the
> > > vendor driver also doesn't use VCO_IC=0x2.

I looked at vendor driver it does not set VCO_IC=0x2 when switch 
a channel. However it does it after wake up from suspend:
https://github.com/ashaffer/rt3573sta/blob/09b80e6290769c53736dc09c5ae9025e15bfbe69/chips/rt3593.c#L194

This function: RT3593ReverseRFSleepModeSetup seams to be partially
the same what NICInitRT3593RFRegisters does. 

Also NICInitRT3593RFRegisters it's different from
rt2800_init_rfcsr_3593() i.e. it set RF_R02 before GPIO_SWITCH.

Could you check if modifying rt2800_init_rfcsr_3593() 
to be more the same with both NICInitRT3593RFRegistersr and
RT3593ReverseRFSleepModeSetup (regarding RF_R06 change)
solve the problem?

> > > Is this also a known issue?
I didn't knew about it.

> > Could you elaborate what is the issue and what you mean by
> > "VCO calibration result is 0x7f" ?'
> I had accidentally left the description out, sorry about that.
No problem.

> The adapter doesn't work on the lower channels in 2.4GHz,
> channels 8 and below. This looked like an issue with
> the PLL or something after debugging.
> 
> By tuning to channels 1-12 and using the debugfs to dump the
> RFCSR registers, RFCSR4 is always 0x7f on the failing channels
> consistently. Since there is code to switch RFCSR6 based on
> channel, I tried the same as the 5GHz code to switch RFCSR6=0x2
> for lower channels and it worked on all the channels surprisingly.
> 
> Due to the behaviour of RFCSR4, I think it is a VCO calibration
> result since it seems to change after enabling the calibration.
> 
> I could not find any mention of this issue elsewhere, and suspect
> either this hardware has very few Linux users or my hardware
> is special in some way, so I can't guarantee that setting
> it to 0x2 will work with another device even if it is the
> same WNDA4100 model and chipset, so some testing would
> be appreciated.
I do not have RT3573/RT3593 device by myself and ordinary users
do not read linux-wireless mailing list, so we have rather little
chance to get more test coverage here.

Anyways, if init change that would make rt2800_init_rfcsr_3593()
more like vendor driver do not fix the problem, it's ok to modify
rt2800_config_channel_rf3053(). 

If we want to be more safe with the change, we can limit it with
rt2x00_rt_rev() using 'rev' of your tested device.

Regards
Stanislaw
