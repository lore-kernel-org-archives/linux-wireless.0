Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:33235 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbFABhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 21:37:42 -0400
Received: by yhpn97 with SMTP id n97so29435016yhp.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 18:37:41 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 31 May 2015 21:37:41 -0400
Message-ID: <CAOiWkA_i8mSx_DtW-Z8mdSiqMZcUXJp0nwCrZGkEZDWBUb3cVg@mail.gmail.com> (sfid-20150601_033746_931329_E7BDD2C6)
Subject: system hang with backports-20150511/20150525
From: Marty Faltesek <mfaltesek@google.com>
To: linux-wireless@vger.kernel.org
Cc: Martin Faltesek <martin.faltesek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Starting with backports-20150511, and continuing with
backports-20150525, we see frequent system hangs. backports-20150424
had no issue.

After the freeze, the console is non-responsive, as well as the
network stack (ssh/ping does not work). Using sysrq, I can see log
messages continuing from ath10k_pci after the freeze, along with some
other threads as well.

mac80211/ath10k/cfg80211 are the only modules in use from backports,
so it seems like a deadlock  could possibly be with mac80211 or
ath10k.

LOCKDEP didn't reveal anything.

Using a 3.2.26 kernel on ARM. AP mode. No encryption.

I've collected ftrace events for sched mac80211 net napi cfg80211
workqueue, which are included in the dmesg you can find here because
of its size:

http://tinyurl.com/dmesg-ftrace

In the logs, the last timestamp that my test script wrote is:

[ 1021.291495] hbeat0352

I've captured  ftrace events before and after 1021.291495.

Thanks,
Marty Faltesek
Google Fiber
