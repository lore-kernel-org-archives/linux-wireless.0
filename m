Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46032 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZCVMpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 08:45:18 -0400
Received: by fxm2 with SMTP id 2so1437218fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 05:45:15 -0700 (PDT)
Date: Sun, 22 Mar 2009 17:45:15 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Kernel panic with zd1211rw and today's compat-wireless
Message-ID: <20090322174515.22f11d92@home.aephome.ru> (sfid-20090322_134524_211033_029824A8)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

Today I tried to use wpa_supplicant version 0.6.8 with -Dnl80211
switch, in order to confirm that setting the country code in the
configuration file works. My zd1211rw-based card works for a short
time, and then I get a kernel panic. Sometimes the bug can be reproduced
with just a few seconds of flood ping, and sometimes the card survives
100 MB of data transfer. The problem didn't exist with the stock driver
included in linux-2.6.28.

There are several different panic messages,
the common thing is "Fatal exception in interrupt". Without uvesafb,
they also include "zd_op_tx+0x98/0x1cc [zd1211rw]" as the last line,
but with uvesafb, this sometimes changes to
"rate_control_get_rate+0xb7/0xc3 [mac80211]". Sometimes the kernel
becomes tainted with G and W flags (what do they mean?), but there were
two untainted cases.

The card is in ad-hoc mode, if that matters, and the rate control
algorithm is minstrel. WEP is used, because WPA+ad-hoc doesn't work
with this card (should it?).

Screen photos from all cases of panic are available at the following
URL:

http://picasaweb.google.com/patrakov/KernelPanic?authkey=Gv1sRgCKn5ne2jqbLYpAE&feat=directlink

-- 
Alexander E. Patrakov
