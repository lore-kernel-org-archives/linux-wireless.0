Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:54548 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYLRWFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 17:05:19 -0500
Received: from ol194-228.fibertel.com.ar ([24.232.228.194] helo=ws)
	by mail.openmoko.org with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63)
	(envelope-from <werner@openmoko.org>)
	id 1LDQPZ-0008VW-Hh
	for linux-wireless@vger.kernel.org; Thu, 18 Dec 2008 21:28:03 +0000
Date: Thu, 18 Dec 2008 19:22:34 -0200
From: Werner Almesberger <werner@openmoko.org>
To: linux-wireless@vger.kernel.org
Subject: AR6k: to rfkill or not to rfkill ?
Message-ID: <20081218212234.GI5019@almesberger.net> (sfid-20081218_230524_169647_EE51F075)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In Openmoko, we're wondering whether we should make the Atheros AR6k
driver register as an rfkill controller or not, and if we do it,
what semantics this should have. I'm looking for advice here.

The issue is that there's no real rfkill hardware in the sense of a
simple switch that cuts power to the transmitter. At least nothing
like this is visible from the kernel. Instead, there is a "fat" and
opaque firmware in the module that decides on such low-level actions
on its own.

There are currently two mechanisms which would fall into the domain
of WLAN APIs that control three operations:

- the possible operations are
  1) associate/de-associate with access point
  2) scan for access points
  3) return -EIO when attempting WLAN ioctls

- when 1) and 2) are applied together, the transmitter is supposed
  to be silent

- the mechanisms present so far are
  1) SIOCSIWTXPOW
  2) an Atheros-specific ioctl (AR6000_IOCTL_EXTENDED, sub-function
     AR6000_XIOCTRL_WMI_SET_WLAN_STATE)

- both mechanisms de-associate and stop scanning
- in the case of SIOCSIWTXPOW, setting the ESSID will re-associate
- in the case of AR6000_XIOCTRL_WMI_SET_WLAN_STATE, most ioctls will
  return -EIO until another AR6000_XIOCTRL_WMI_SET_WLAN_STATE is
  issued that re-enables WLAN

So, first of all, given that TX power is controlled only indirectly
anyway, should we implement rfkill control or not ? There is no kill
switch, so there would be no rfkill input.

If the answer is "yes", would the following semantics be right for
the disabled state ?

- we de-associate
- we stop scanning
- all ioctls still work as usual, but they have no effect on
  association and scanning until rfkill re-enables the device

Thanks,
- Werner
