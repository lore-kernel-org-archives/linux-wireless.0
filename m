Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:45941 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab1EXGSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 02:18:49 -0400
From: Rob Browning <rlb@defaultvalue.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Slow receive with rtl8192cu (usb ew-7811Un)
References: <87pqnl5i81.fsf@raven.defaultvalue.org>
	<4DD074E3.3090502@lwfinger.net>
	<87vcxbe5xz.fsf@trouble.defaultvalue.org>
	<4DD09C78.2010304@lwfinger.net>
	<8762pbkytq.fsf@trouble.defaultvalue.org>
	<4DD13EF0.2070803@lwfinger.net>
	<87iptaj8nf.fsf@trouble.defaultvalue.org>
	<87fwoehtd7.fsf@trouble.defaultvalue.org>
	<4DD2A3A9.90003@lwfinger.net> <87pqnhj5e7.fsf@raven.defaultvalue.org>
Date: Tue, 24 May 2011 01:18:34 -0500
In-Reply-To: <87pqnhj5e7.fsf@raven.defaultvalue.org> (Rob Browning's message
	of "Tue, 17 May 2011 18:04:16 -0500")
Message-ID: <87r57otydh.fsf@raven.defaultvalue.org> (sfid-20110524_081852_350895_0D31B586)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I just tested Debian's 2.6.38-1 kernel, and it has the same problem,
though I just noticed something potentially interesting.

Right after booting the system, I started a wget which ran at a steady
800+K/s.  Then I started an "lftp get -c" to grab a kernel image, and
both connections settled at about 400K/s.

After a minute or so, I killed the ftp connection; from then on all
transfers were limited to 60K/s.

Now that I think about it, that's consistent with what I've seen up to
this point.

Hope this helps
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
