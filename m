Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36553 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3FKQkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 12:40:13 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl14so2378083pab.20
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 09:40:12 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 11 Jun 2013 12:40:12 -0400
Message-ID: <CA+7oyge=p5uTgCc+Veq-fZrH2Dd6Ew7OR8m0mz+e7+Ze+LNcYQ@mail.gmail.com> (sfid-20130611_184018_739789_A55E22E9)
Subject: where is ath9k debugfs?
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have configured my kernel to use ath9k debugfs:
$ grep ATH9K_DEBUGFS /boot/config-`uname -r`
CONFIG_ATH9K_DEBUGFS=y

The location of these debugfs files should be in
/sys/kernel/debug/ath9k according to:
http://wireless.kernel.org/en/users/Drivers/ath9k/debug#Debugfs_files_for_ath9k

However, when I load the modules and plug in an ath9k device, I do not
get any ath9k debugfs files:
root@parallels:/sys# find /sys -name ath9k
root@parallels:/sys# find /sys -name rx_chainmask
root@parallels:/sys# find /sys -name disable_ani
root@parallels:/sys#

I do get the ieee80211 debug, though:
# ls -l /sys/kernel/debug/ieee80211/
total 0
drwxr-xr-x 6 root root 0 Jun 11 12:30 phy0

Do I need to pass some parameter to the kernel module on load to get
the ath9k debugfs?  Am I missing something else?

Thanks!
George
