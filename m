Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27593 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbYEYU2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2008 16:28:10 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: before sleeping, check for a command result
Date: Sun, 25 May 2008 22:28:05 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <002701c8bce1$04097010$0137550a@se.axis.com> <1211553146.31559.30.camel@localhost.localdomain>
In-Reply-To: <1211553146.31559.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805252228.06316.hs4233@mail.mn-solutions.de> (sfid-20080525_222815_773837_88AF990D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The thing is: now I don't have the issue that I reported
in the first message of this thread anymore. Libertas
works as expected without the patch.

I'm on wireless-testing v2.6.26-rc3-8056-gc2c4044 and have the
following patches applied:

libertas-fix-lock.patch
libertas-fix-printk.patch
libertas-if-cs-speed-firmware.patch
libertas-if-cs-int.patch


Compared to friday, I also turned on the following kernel debug
options:

+CONFIG_DEBUG_KERNEL=y
+CONFIG_DETECT_SOFTLOCKUP=y
+CONFIG_DEBUG_PREEMPT=y
+CONFIG_DEBUG_RT_MUTEXES=y
+CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_LOCKDEP=y
+CONFIG_LOCK_STAT=y
+CONFIG_TRACE_IRQFLAGS=y
+CONFIG_DEBUG_SPINLOCK_SLEEP=y

Yet associating and executing of commands works fine. I
did run "while true; do iwconfig eth1; sleep 0.2; done"
quite long (up to sequence number 8804) and did not
have any hickup.

On friday, I even saw the hickup on the first commands/response ...

