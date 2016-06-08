Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34316 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbcFHHlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 03:41:11 -0400
Received: by mail-pf0-f173.google.com with SMTP id 62so36501pfd.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2016 00:41:10 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	driverdev-devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 0/2] *** r8723au: Replace semaphore lock with mutex ***
Date: Wed,  8 Jun 2016 13:10:53 +0530
Message-Id: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org> (sfid-20160608_094201_692839_E88AD14A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These are a set of patches which removes semaphores from:

drivers/staging/rtl8723au

These are part of a bigger effort to eliminate all semaphores 
from the linux kernel.

They build correctly (individually and as a whole).
NB: I have not tested this as I do not have the following hardware:

R8723AU
"Realtek RTL8723AU Wireless LAN NIC driver"

Thanks,
Binoy

Binoy Jayan (2):
  staging: r8723au: pwrctrl_priv: Replace semaphore lock with mutex
  staging: r8723au: Remove unused semaphores

 drivers/staging/rtl8723au/core/rtw_pwrctrl.c      | 11 ++++++-----
 drivers/staging/rtl8723au/core/rtw_xmit.c         |  4 ----
 drivers/staging/rtl8723au/include/osdep_service.h |  1 -
 drivers/staging/rtl8723au/include/rtw_io.h        |  2 --
 drivers/staging/rtl8723au/include/rtw_pwrctrl.h   |  3 ++-
 drivers/staging/rtl8723au/include/rtw_xmit.h      |  5 -----
 drivers/staging/rtl8723au/os_dep/usb_intf.c       | 11 ++++++-----
 7 files changed, 14 insertions(+), 23 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

