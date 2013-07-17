Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtava1.carestreamhealth.com ([205.173.211.14]:60768 "EHLO
	ashop0009.corp.carestreamhealth.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756689Ab3GQSUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jul 2013 14:20:41 -0400
Received: from ashop0009.corp.carestreamhealth.com (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 74C20AB367D
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jul 2013 18:58:23 +0000 (GMT)
Received: from lnhub001.cs-apps.carestreamhealth.com (ashzp0010.corp.carestreamhealth.com [10.124.124.33])
	by ashop0009.corp.carestreamhealth.com (Postfix) with ESMTP id 51311AB35FC
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jul 2013 18:58:23 +0000 (GMT)
Message-ID: <51E6DE4D.50902@carestream.com> (sfid-20130717_202047_023359_14C419DB)
Date: Wed, 17 Jul 2013 14:11:25 -0400
From: "greg.huber" <greg.huber@carestream.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Wake-On-Wireless and Deauthentication
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to get Wake-on-wireless working with an Atheros AR9462.
The problem I seem to be having is that there is a Deauth requested
when the system is suspended. Does anyone know how to keep the
association while suspended?? I'm using kernel 3.9.9.

The log after waking (from keyboard)

[  320.117062] wlp3s0: deauthenticating from 00:24:01:12:de:7a by local choice
(reason=3)
[  320.125719] cfg80211: Calling CRDA to update world regulatory domain
[  320.186243] cfg80211: World regulatory domain updated:
[  320.186255] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  320.186259] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  320.186263] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  320.186266] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[  320.186270] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  320.186273] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[  320.626022] PM: Syncing filesystems ... done.
[  320.632331] PM: Preparing system for mem sleep
[  320.633223] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  320.644617] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  320.655788] PM: Entering mem sleep
[  320.655917] Suspending console(s) (use no_console_suspend to debug)
[  320.656856] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  320.657069] serial 00:09: disabled
[  320.657086] serial 00:09: System wakeup disabled by ACPI
[  320.679813] sd 0:0:0:0: [sda] Stopping disk
[  320.681171] <6>[fglrx] IRQ 48 Disabled
[  320.681217] <6>[fglrx] Preparing suspend fglrx in kernel.
[  320.927890] <6>[fglrx] Suspending fglrx in kernel completed.
[  320.927893] <6>[fglrx] Power down the ASIC .
[  321.168217] PM: suspend of devices complete after 511.732 msecs
[  321.168512] PM: late suspend of devices complete after 0.289 msecs

Thanks for any insight you could provide.

Greg

