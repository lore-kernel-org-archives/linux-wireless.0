Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:34767 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYGRWk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 18:40:29 -0400
Received: by py-out-1112.google.com with SMTP id p76so435215pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 15:40:28 -0700 (PDT)
Message-ID: <1ba2fa240807181540s5fc91953h3dd223d38838ec58@mail.gmail.com> (sfid-20080719_004033_928284_31C924B3)
Date: Sat, 19 Jul 2008 01:40:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Brian Crowley" <brian@abtrafco.com>
Subject: Re: Build bug with 2.6.26-4
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2b4fb6bd0807180335q1b185fc2mf490c492d2724c59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <2b4fb6bd0807180335q1b185fc2mf490c492d2724c59@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2008 at 1:35 PM, Brian Crowley <brian@abtrafco.com> wrote:
> Have been usng compat for months now with no problems.
>
> 1. upgraded ubuntu hardy to intrepid alpha with new kernel (previous
> 2.6.24-19 generic)
>
> 2. wireless 3945 worked out of the box, even 3945 led blinking (but
> slowly instead of fast like used to with network traffic)
>
> compat-wireless-2008-07-18
>
> Following err's:
>
> make:
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:
> In function 'iwl_led_brightness_set':
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
> error: 'led_type_str' undeclared (first use in this function)
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
> error: (Each undeclared identifier is reported only once
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
> error: for each function it appears in.)
> make[4]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.o]
> Error 1
> make[3]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi]
> Error 2
> make[2]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless]
> Error 2
> make[1]: *** [_module_/home/brian/Desktop/Downloads/compat-wireless-2008-07-18]
> Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-4-generic'
> make: *** [modules] Error 2
>
> sudo make install:
>
> make -C /lib/modules/2.6.26-4-generic/build
> M=/home/brian/Desktop/Downloads/compat-wireless-2008-07-18 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.26-4-generic'
>  CC [M]  /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.o
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:
> In function 'iwl_led_brightness_set':
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
> error: 'led_type_str' undeclared (first use in this function)
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
> error: (Each undeclared identifier is reported only once
> /home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.c:198:
> error: for each function it appears in.)
> make[4]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi/iwl-led.o]
> Error 1
> make[3]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless/iwlwifi]
> Error 2
> make[2]: *** [/home/brian/Desktop/Downloads/compat-wireless-2008-07-18/drivers/net/wireless]
> Error 2
> make[1]: *** [_module_/home/brian/Desktop/Downloads/compat-wireless-2008-07-18]
> Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-4-generic'
> make: *** [modules] Error 2
> brian@brian-laptop:~/Desktop/Downloads/compat-wireless-2008-07-18$
>
> did not see the normal message telling me to use unload / load so
> think the process just stopped so I did not proceed with these steps.
>
> Thanks,
> Brian (linux user 1 year-yeah noob)

Defining IWLWIIF_DEBUG in config.mk should fix this. A patch that fix
this without it is on the way.
Thanks
Tomas
