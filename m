Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36799 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbbLUC2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 21:28:55 -0500
Received: by mail-pa0-f46.google.com with SMTP id q3so70697764pav.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2015 18:28:55 -0800 (PST)
From: Dan Lenski <dlenski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Lenski <dlenski@gmail.com>, larry.finger@lwfinger.net
Subject: [PATCH] fix MAC-setting for r8723au
Date: Sun, 20 Dec 2015 18:28:35 -0800
Message-Id: <1450664916-25205-1-git-send-email-dlenski@gmail.com> (sfid-20151221_032859_841890_AF3446C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
The r8723au driver silently leaves the MAC address unchanged
when attempting to set it.

This was mentioned in a Debian security bug for macchanger
(https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=774898;msg=46) and
more recently has been causing me frustration with captive portals at
that give a short window of free connectivity, and refuse further
connections from the same MAC address.

This patch:

* Correctly sets the dev_addr field of struct net_device. The code to
  do this was for some reason commented out in the original version of
  the driver from Realtek:
  http://github.com/lwfinger/rtl8723au/blob/bc13943b872dc666a3cfa55407e7f9965f0aab52/os_dep/os_intfs.c#L827

* Removes the restriction wherein the MAC address cannot be set after
  the network driver is first brought up, and replaces it with a
  warning.  Because rtw_adapter->bup is set to 1 when the device is
  first opened, and _never_ set back to 0, it would be necessary to
  reload the module to change the MAC with this restriction.

I have tested repeatedly changing the MAC address while the device is
up, and there seem to be no ill effects, other than userspace tools
getting confused.

Thanks,
Dan


Dan Lenski (1):
  enable setting MAC address for r8723au

 drivers/staging/rtl8723au/os_dep/os_intfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.5.0

