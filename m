Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:38007 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYGRKfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 06:35:43 -0400
Received: by an-out-0708.google.com with SMTP id d40so222654and.103
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 03:35:43 -0700 (PDT)
Message-ID: <2b4fb6bd0807180335q1b185fc2mf490c492d2724c59@mail.gmail.com> (sfid-20080718_123549_574663_FA824FDC)
Date: Fri, 18 Jul 2008 12:35:42 +0200
From: "Brian Crowley" <brian@abtrafco.com>
To: linux-wireless@vger.kernel.org
Subject: Build bug with 2.6.26-4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have been usng compat for months now with no problems.

1. upgraded ubuntu hardy to intrepid alpha with new kernel (previous
2.6.24-19 generic)

2. wireless 3945 worked out of the box, even 3945 led blinking (but
slowly instead of fast like used to with network traffic)

compat-wireless-2008-07-18

Following err's:

make:
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:
In function 'iwl_led_brightness_set':
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: 'led_type_str' undeclared (first use in this function)
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: (Each undeclared identifier is reported only once
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: for each function it appears in.)
make[4]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.o]
Error 1
make[3]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi]
Error 2
make[2]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless]
Error 2
make[1]: *** [_module_/home/brian/Desktop/Downloads/compat-wireless-2008-07-18]
Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-4-generic'
make: *** [modules] Error 2

sudo make install:

make -C /lib/modules/2.6.26-4-generic/build
M=/home/brian/Desktop/Downloads/compat-wireless-2008-07-18 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.26-4-generic'
  CC [M]  /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.o
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:
In function 'iwl_led_brightness_set':
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: 'led_type_str' undeclared (first use in this function)
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: (Each undeclared identifier is reported only once
/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
error: for each function it appears in.)
make[4]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.o]
Error 1
make[3]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi]
Error 2
make[2]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless]
Error 2
make[1]: *** [_module_/home/brian/Desktop/Downloads/compat-wireless-2008-07-18]
Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-4-generic'
make: *** [modules] Error 2
brian@brian-laptop:~/Desktop/Downloads/compat-wireless-2008-07-18$

did not see the normal message telling me to use unload / load so
think the process just stopped so I did not proceed with these steps.

Thanks,
Brian (linux user 1 year-yeah noob)
