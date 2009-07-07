Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:56014 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbZGGG7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 02:59:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: BUG REPORT: libertas causing kernel lockups
Date: Tue, 7 Jul 2009 08:59:39 +0200
Cc: Alexander Barinov <alex.barinov@gmail.com>
References: <20090704130346.01b2e869@dream>
In-Reply-To: <20090704130346.01b2e869@dream>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907070859.39413.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> By executing 'cat /proc/net/wireless' I get the same bug:

I haven't tested your exact but, but I've the following in my 
mind, back from about 1 year ago when I did lots of libertas and 
libertas_cs work:

Access wireless stats made the libertas driver (in wext.c) issue 
a command towards the firmware in the hardware. I think it was 
the command to get the current SNR/RSSI/whatever.

The libertas command-response-cycle does sleep, so you could 
trigger a bug. I once had a patch (and I think I posted that 
patch). The patch lied, by providing the last SNR/RSSI/whatever, 
and issueing a "get SNR/RSSI/whatever" in the background, just 
storing the result. So just one "cat /proc/net/wireless" returns 
bogus, but a continues command returns "valid" info, e.g. when 
doing "watch iwconfig eth1".

-- 
http://www.holgerschurig.de
