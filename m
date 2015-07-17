Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34340 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbbGQUAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 16:00:48 -0400
Received: by wibud3 with SMTP id ud3so46890530wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 13:00:47 -0700 (PDT)
Received: from linux-suse.hu (catv-178-48-68-209.catv.broadband.hu. [178.48.68.209])
        by smtp.gmail.com with ESMTPSA id lz10sm19675945wjb.48.2015.07.17.13.00.46
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jul 2015 13:00:46 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Difficult to reconnect (RTL8191SU, authentication with xx:xx timed out)
Date: Fri, 17 Jul 2015 22:00:45 +0200
Message-ID: <1999704.oWOWvNZ29T@linux-suse.hu> (sfid-20150717_220052_404659_62D85122)
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list members,

I have an RTL8191SU USB WiFi card (with rtl8192su driver) and unfortunately it 
looses network connection many times (reproducibly, and only under Linux).

Re-connecting to the previous network is also very difficult because the 
following error messages appear in dmesg during that:
[164797.994074] wlp0s26f7u2: authenticate with 90:f6:52:7d:6e:0e
[164798.031433] wlp0s26f7u2: direct probe to 90:f6:52:7d:6e:0e (try 1/3)
[164798.232411] wlp0s26f7u2: direct probe to 90:f6:52:7d:6e:0e (try 2/3)
[164798.433700] wlp0s26f7u2: direct probe to 90:f6:52:7d:6e:0e (try 3/3)
[164798.634457] wlp0s26f7u2: authentication with 90:f6:52:7d:6e:0e timed out

When I turn the adapter off (in KDE network manager app), wait about ten 
seconds, then turn it on again, it can suddenly connect again flawlessly.

Since I'm not a kernel developer, I don't know the perfect ways to track down 
these kinds of issues. Anyway, I ran the following command when I tried to 
connect multiple times and the driver refused:
trace-cmd record -T -e mac80211 -e cfg80211

I uploaded the output which you can reach here: 
http://home.sch.bme.hu/~szotsaki/trace-auth-time-out.dat

I also traced out the firware version:
printk(KERN_WARNING "Version: %u\n", hal_get_firmwareversion(rtlpriv));
-> Version: 36926 (which is strange because in the source everywhere a v52-
like numbers are referenced).

Do you have time to fix this issue and if so, can I provide some more useful 
input?

Thank you very much!

All the best,

Ákos
