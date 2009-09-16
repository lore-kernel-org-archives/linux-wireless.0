Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.schicktech.com ([74.201.138.167]:61375 "EHLO
	mail.schicktech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbZIPRY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 13:24:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Continuous monitoring of wifi stats
Date: Wed, 16 Sep 2009 13:24:14 -0400
Message-ID: <C6BB22C4F02E0E4AB5B55BD3B1FEDBCD056C4ABD@schickmail.schicknt.com>
From: "John Goyette" <jgoyette@schicktech.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

 

I am looking for some advice on a Libertas related issue.  I am having a problem with a recent feature we added to our embedded system that continuously monitors wifi statistics, i.e., signal strength.  We are using a Blackfin platform with a Marvell 8686 device in the G-SPI configuration.  Our kernel is based on a 2.6.28.6 release.  

 

The problem occurs after pressing Ctrl-C to terminate a user space program that is polling the wireless stats in a loop.  A number of libertas error messages appear indicating a failure to download command 0x0000.  I am pretty sure there is no command 0x0000, so I do not know how it got queued.  Here is a sample of the error messages from dmesg:

 

libertas: command 0x0000 timed out
libertas: requeueing command 0x0000 due to timeout (#1)
libertas: if_spi_host_to_card: invalid size requested: 0
libertas: DNLD_CMD: hw_host_to_card failed: -22
libertas: command 0x0000 timed out
libertas: requeueing command 0x0000 due to timeout (0000002 <http://schicksw/mantis/view.php?id=2> )
libertas: if_spi_host_to_card: invalid size requested: 0
libertas: DNLD_CMD: hw_host_to_card failed: -22
libertas: command 0x0000 timed out
libertas: requeueing command 0x0000 due to timeout (0000003 <http://schicksw/mantis/view.php?id=3> )
libertas: if_spi_host_to_card: invalid size requested: 0
libertas: DNLD_CMD: hw_host_to_card failed: -22
libertas: command 0x0000 timed out
libertas: Excessive timeouts submitting command 0x0000

 

 

This can be reproduced by enabling IEEE Power Savings mode and flooding the card with wireless stats requests by running something like the following from a terminal:

while true; do iwconfig eth1;done

 

Let this run for 30-60 secs, and then press Ctrl-C.  With IEEE power savings off, it may take several minutes, but does eventually give the same problem.  I have downloaded the compat-wireless-2.6.30 release and was able to cross-compile it for our kernel.  It helped a little in that it seemed to take longer before the error messaged occurred after pressing ctrl-c, but it did not completely resolve the problem.

 

Has anyone seen something similar?  Are there any more recent patches that may address this issue?

 

Thanks.

 

-John Goyette

Schick Technologies, Inc.

 

