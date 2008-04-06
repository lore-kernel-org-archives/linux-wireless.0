Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:11558 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYDFPGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 11:06:53 -0400
Received: by fk-out-0910.google.com with SMTP id 19so1390831fkr.5
        for <linux-wireless@vger.kernel.org>; Sun, 06 Apr 2008 08:06:46 -0700 (PDT)
To: Bas Hulsken <bhulsken@hotmail.com>
Subject: Re: hostapd hangs on rt2500pci, leaving the nic in an unstable state
Date: Sun, 6 Apr 2008 17:08:50 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1207412527.6965.21.camel@Bas> <200804051946.24100.IvDoorn@gmail.com> <1207486334.7395.9.camel@Bas>
In-Reply-To: <1207486334.7395.9.camel@Bas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804061708.51044.IvDoorn@gmail.com> (sfid-20080406_160656_159254_52A6E2CA)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > This is all very strange behavior, I don't know what can cause the
> > ACPI to disable an interrupt for the device, but what is interesting to
> > see is that the BSSID in the register seems to have been cleared....
> I remember reading somewhere that ACPI can do that, if it detects
> spurious interrupts coming from the device. Not sure if that's the only
> situation where ACPI does this.

Could you try editing rt2500pci.c
and in rt2500pci_interrupt() change:

	if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
		rt2x00lib_beacondone(rt2x00dev);

to

	//if (rt2x00_get_field32(reg, CSR7_TBCN_EXPIRE))
	//	rt2x00lib_beacondone(rt2x00dev);

> > Could you create a debugfs dump of the time just before it breaks?
> > Because it is very odd to see the BSSID to be suddenly cleared, currently
> > is seems to occur with some people in managed mode as well and so
> > far I haven't been able to trace it.
> > Although now that it occurs in master mode as well it becomes
> > more worrying since mac80211 doesn't control the BSSID in that case
> > (rt2x00 just grabs the MAC address). So if this seems reproducable there
> > might be some sort of hardware register reset occuring that messes
> > things up badly.. :S
> ok, here are some regdumps:
> 
> 1) regdump_beforeifup: a regdump taken before the interface is brought
> up (module is loaded of course)
> 2) regdump_beforehostapd: a regdump taken immediately after the
> interface is brought up, but before hostapd is running.
> 3) regdump_beforeauth: a regdump taken after hostapd is started, and
> running, but before a client has started an authentication.
> 4) regdump_afterauthhang: a regdump, after hostapd has locked up, due to
> an authentication attempt.

Ivo
