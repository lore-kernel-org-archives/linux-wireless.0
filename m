Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ocean.emcraft.com ([213.221.7.182]:47562 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2HPP2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 11:28:42 -0400
Date: Thu, 16 Aug 2012 19:28:39 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Access Point Mode for Ralink RT5370? - Success
Message-ID: <20120816192839.1e595e4b@emcraft.com> (sfid-20120816_172854_450336_913995C9)
In-Reply-To: <CAOZOX0V1_zA3iTXhz7J4_t-BxNQ6k6V_-A_jky2B=fpbya-Lqg@mail.gmail.com>
References: <20120719133452.2fb375ae@emcraft.com>
	<CAOZOX0V=npQuQ03kur0mo7PtkdGVYiFO5B3OKhB7CMibLk50Ew@mail.gmail.com>
	<20120807190140.4796a045@emcraft.com>
	<CAOZOX0V1_zA3iTXhz7J4_t-BxNQ6k6V_-A_jky2B=fpbya-Lqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ivo, all,

I just want to report that we successfully built and configured DWA-140
(rev B3, RT5370 chip) USB-WiFi in access point mode. For this, we built
vcompat-wireless modules and hostapd and lbnl (required by hostapd).

Our target is the LPC1788 (ARM Cortex-M3 SOC) running Linux 2.6.33,
with USB support.

Our toolchain combo is CodeSourcery arm-2010q1, with uClibc modified to
support clone() and linuxthreads.

Thank you for your comments.

Regards,
Sergei Poselenov, Emcraft Systems

On Tue, 7 Aug 2012 17:38:53 +0200
Ivo Van Doorn <ivdoorn@gmail.com> wrote:

> Hi,
> 
> >> On Thu, Jul 19, 2012 at 11:34 AM, Sergei Poselenov
> >> <sposelenov@emcraft.com> wrote:
> >> > Hello,
> >> >
> >> > Does compat-wireless support the Access Point mode for the Ralink
> >> > RT5370 chip? The driver source pack from the Ralink site only
> >> > supports Managed and Ad-Hoc modes.
> >>
> >> Yes, the rt2x00-based drivers as found in the compat-wireless
> >> package are working in AP mode.
> >>
> >
> > I'm trying to set the master mode and it fails:
> > ~ # iwconfig wlan0 mode Master
> > Error for wireless request "Set Mode" (8B06) :
> >     SET failed on device wlan0 ; Invalid argument.
> > ~ #
> >
> > The Linux Wireless FAQ here
> > http://linuxwireless.org/en/users/Documentation/FAQ#Q:_iwconfig_wlan0_mode_master_does_not_work
> > tells me that I should use hostapd instead of iwconfig to configure
> > the master mode.
> >
> > However, for my project the WiFi security is not required. Also, I'm
> > working on a custom ARM board with Linux 2.6.33 running.
> 
> But the FAQ doesn't say you need hostapd for WiFi Security, it says
> if you want master mode, you must use hostapd..
> 
> > Could you please confirm I should really port hostapd to my target
> > to configure my USB WiFi as Access Point?
> 
> Yes, you _must_ use hostapd.
> 
> Ivo

