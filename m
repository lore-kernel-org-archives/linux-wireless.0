Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:5966 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZJGDrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 23:47:06 -0400
Received: by ey-out-2122.google.com with SMTP id 4so940734eyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 20:45:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com>
References: <1254886762-17211-1-git-send-email-HinTak.Leung@gmail.com>
Date: Wed, 7 Oct 2009 04:45:58 +0100
Message-ID: <3ace41890910062045s626777dew4b47fe18bc8d9aee@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: adding ethtool.h to compat-2.6.31.h
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After 'compat-2.6: adjusting 01-netdev.patch for libertas cfg80211
support' (which fixes the patches), and 'compat-2.6: adding ethtool.h
to compat-2.6.31.h' (which fixes the cfg80211.h header), the next
error is ath5k_pm_ops type missing:

----------------
  CC [M]  /home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath/ath5k/base.o
/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath/ath5k/base.c:201:
warning: data definition has no type or storage class
/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath/ath5k/base.c:201:
warning: type defaults to ‘int’ in declaration of ‘SIMPLE_DEV_PM_OPS’
/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath/ath5k/base.c:201:
warning: parameter names (without types) in function declaration
/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath/ath5k/base.c:212:
error: ‘ath5k_pm_ops’ undeclared here (not in a function)
make[5]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath/ath5k/base.o]
Error 1
make[4]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath/ath5k]
Error 2
make[3]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless/ath]
Error 2
make[2]: *** [/home/Hin-Tak/tmp-git/compat-wireless-2.6/drivers/net/wireless]
Error 2
make[1]: *** [_module_/home/Hin-Tak/tmp-git/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.30.8-67.fc11.x86_64'
make: *** [modules] Error 2
---------------

Since this is slightly outside my interest (I am mostly just tracking
rtl818x and to a lesser extent zd1211rw), I'll let others carry on
fixing compat-wireless against current wireless-testing... apologies.
