Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.openmoko.org ([88.198.124.205]:35226 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbZALTPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 14:15:30 -0500
Received: from 175-205-16-190.fibertel.com.ar ([190.16.205.175] helo=ws)
	by mail.openmoko.org with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.63)
	(envelope-from <werner@openmoko.org>)
	id 1LMSLT-0005e5-Je
	for linux-wireless@vger.kernel.org; Mon, 12 Jan 2009 19:21:09 +0000
Date: Mon, 12 Jan 2009 17:15:14 -0200
From: Werner Almesberger <werner@openmoko.org>
To: linux-wireless@vger.kernel.org
Subject: rfkill: how murderous can it be ?
Message-ID: <20090112191514.GA22112@almesberger.net> (sfid-20090112_201553_679260_F90049FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'd like to restart a discussion from last year, namely how aggressive
an rfkill implementation is allowed to be when it comes to destroying
MAC state.

The design suggested in rfkill.txt and also implemented in the existing
drivers basically assumes a simple on/off switch that cuts power to the
transmitter but doesn't change anything else. The question is if this 
is already the full extent to which rfkill is allowed to affect MAC
state or if it could go further.

In the AR6k, we don't have such a simple switch for the transmitter. We
can control what the transmitter does very indirectly by temporarily
reconfiguring the MAC, but this creates a fair amount of complexity,
which also seems to be at odds with the design of rfkill.

Alternatively, we could just power down the whole WLAN module. That is
easily done and very reliable. However, MAC state (ESSID, keys, and a
host of other settings) is obliterated if we do this. A watchful user 
space (e.g., wpa_supplicant) could then restore the status quo ante.

Now the question is whether this is still in the spirit of the design 
of rfkill of if it would take things too far.

It seems that there is no consensus on this issue yet. I started the 
implementation with the assumption that rfkill should always behave as 
if it only cut transmitter power, so no other state of the MAC is
allowed to be lost. This is also what Henrique suggested I should do.

However, Andy and recently Michael suggested that, given that an
interface that has no connectivity for an extended period of time is
likely to get reconfigured anyway, it may be sufficient if rfkill 
leaves things in a state that allows user space to restore 
connectivity, without having to worry about details beyond that.

rfkill.txt only specifies the minimum actions an RF kill is required
to perform, but it's silent on how far it is allowed to go. Let's fix
this :-)

Thanks,
- Werner
