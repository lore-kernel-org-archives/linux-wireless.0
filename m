Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:36614 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3FQG1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 02:27:31 -0400
Received: by mail-qc0-f169.google.com with SMTP id c10so1400087qcz.28
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jun 2013 23:27:30 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 16 Jun 2013 23:27:30 -0700
Message-ID: <CAJ-VmonxpTv0=5M6faG=UzswdH=c4+L1HYMXatnmssx1Rz7vLQ@mail.gmail.com> (sfid-20130617_082737_666398_B4C213D4)
Subject: ath3k hackery; doing it in userland
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As part of general freebsd wireless hackery I've found a need to port
ath3k to freebsd.

Whilst doing it, I asked - why isn't this in userland? All it's doing
is pushing firmware in. It doesn't have to be in the kernel!

So, without further ado:

https://github.com/erikarn/ath3k

I'm using the libusb 1.0 API so it should be portable between OSes.

There's some interesting issues that have crept up - specifically, the
AR3012 resets after loading in the syscfg and thus doesn't take the
"set normal mode" and "change VID".

So, why's this in the kernel?



Adrian
