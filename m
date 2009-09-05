Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.trivenet.it ([212.103.192.15]:3384 "EHLO tbox.trivenet.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbZIEK5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 06:57:45 -0400
Received: from localhost ([212.103.192.15])
        by tbox.trivenet.it (Trivenet Mailserver) with SMTP id MTY50939
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2009 12:45:39 +0200
Date: Sat, 05 Sep 2009 12:45:39 +0200
From: "Riccardo Gori" <goric@trivenet.it>
Reply-To: "Riccardo Gori" <goric@trivenet.it>
To: linux-wireless@vger.kernel.org
Subject: compat-wireless compilation error on 2.6.29 kernel
Message-ID: <af320d47da5ad895b4fa0ba64fc4cec4@trivenet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I'm trying to compile compat-wireless-2009-09-05 and it gives me the following error:

$ ./scripts/driver-select ath5k
$ make

...snip...

  CC [M]  /home/riccardo/Download/compat-wireless-2009-09-05/net/wireless/scan.o
/home/riccardo/Download/compat-wireless-2009-09-05/net/wireless/scan.c: In function ‘cfg80211_inform_bss’:
/home/riccardo/Download/compat-wireless-2009-09-05/net/wireless/scan.c:503: error: implicit declaration of function ‘kmemleak_ignore’
make[3]: *** [/home/riccardo/Download/compat-wireless-2009-09-05/net/wireless/scan.o] Error 1
make[2]: *** [/home/riccardo/Download/compat-wireless-2009-09-05/net/wireless] Error 2
make[1]: *** [_module_/home/riccardo/Download/compat-wireless-2009-09-05] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.29.6-217.2.16.fc11.i586'
make: *** [modules] Error 2

I'm using the 2.6.29 fedora 11 kernel.

Commenting out line 503:
kmemleak_ignore(res);
solve the compilation problem

Thanks,
Riccardo

