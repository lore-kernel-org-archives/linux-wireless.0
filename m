Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:60055 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbcALMM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 07:12:56 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 375D547FBF7
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 13:05:38 +0100 (CET)
Message-ID: <1452600332.17103.10.camel@hadess.net> (sfid-20160112_131300_106800_BE4A6C82)
Subject: How to revert RFKILL_IOC_NOINPUT ioctl?
From: Bastien Nocera <hadess@hadess.net>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date: Tue, 12 Jan 2016 13:05:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

I recently implemented support for rfkill multimedia/keyboard keys in
GNOME:
http://www.hadess.net/2016/01/support-for-airplane-mode-keys.html

But, as my laptop doesn't have those keys (or rather it does have them,
but they're not supported by the thinkpad kernel driver), I assigned
the functionality temporarily to other keys. It worked well enough.

I realised looking at the rfkill kernel configuration, and noticed that
it wasn't possible to disable CONFIG_RFKILL_INPUT without enabling the
expert mode. "Why" would be the first question in this mail.

See https://lists.fedoraproject.org/archives/list/kernel@lists.fedoraproject.org/thread/FWCOCU2ODZHK7AQVOWSFJLBXL744LYNO/

To make my GNOME code work, I'd need to disable rfkill-input. But if I
still wanted to allow rfkill-input to work when GNOME isn't running,
such as when switching to a console, or another less-capable desktop
environment. But there doesn't seem to be a counterpart
for RFKILL_IOC_NOINPUT. Any reason why?

See https://bugzilla.gnome.org/show_bug.cgi?id=760517

Cheers
