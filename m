Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:41200 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab3CTU5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 16:57:00 -0400
Received: from [24.144.95.9] (helo=192.168.1.10)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <marco@tampabay.rr.com>)
	id 1UIPxe-0008OP-3X
	for linux-wireless@vger.kernel.org; Wed, 20 Mar 2013 16:50:14 -0400
Date: Wed, 20 Mar 2013 16:50:13 -0400
From: Marco Fonseca <marco@tampabay.rr.com>
To: linux-wireless@vger.kernel.org
Subject: carl9170: monitor mode hangs due to channel changes
Message-ID: <20130320205013.GA3462@192.168.1.10> (sfid-20130320_215705_177494_276305BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm seeing a problem with the carl driver.  If I change channels
repeatedly on the 2.4ghz band, monitoring (e.g. tcpdump) will
eventually halt.  I've seen this on various versions of the carl
driver/firmware (both from 1.9.4 to 1.9.7)

After monitoring has hung, changing to a 5ghz channel, causes
monitoring to resume.  Bouncing the interface (ip link set mon0
down/up) also fixes it.


Here are some steps to reproduce:

    # setup interface
    iw wlan0 interface add mon0 type monitor
    ip link set mon0 up


    # start channging channels
    while true ; do for i in 1 6 11 ; do iw mon0 set channel $i ; \
    sleep .250 ; done ; done


In a second terminal:
    tcpdump -i mon0


Wait until tcpdump stops printing.  I've seen the failure rate vary
greatly, sometime minutes, sometime hours, but usually less then an
hour.

Regards,

Marco Fonseca
