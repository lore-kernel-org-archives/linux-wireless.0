Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60954 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab2FNXT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 19:19:28 -0400
Received: by qcro28 with SMTP id o28so1325285qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 16:19:28 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Jun 2012 19:11:41 -0400
Message-ID: <CAGjArBf8XTAUUXXO3D-URMQr76QsV0hQNC2zCxEohRatkPq5_w@mail.gmail.com> (sfid-20120615_011932_936544_010AF360)
Subject: cfg80211 can lock up the kernel when resuming from low power mode
From: Charles Gordon <digigordo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm seeing the kernel occasionally lock up when I put the system into
low power mode and then wake it up.  The lock up occurs while the
system is trying to resume from low power mode.  What happens is that
cfg80211 will sometimes kick off a process to update CRDA information.
 It prints the mesage "cfg80211: Calling CRDA for country: US".  When
it does this, call_crda in reg.c calls kobject_uevent_env to notify
the system that CRDA information has changed.  This eventually causes
the system to try to run /sbin/mdev.  That is where the lock up
occurs.

I'm running on a development system where I'm using NFS over Ethernet
to access the root file system.  When the system resumes from low
power mode, the Ethernet PHY driver renegotiates the Ethernet links.
This takes a couple seconds.  If cfg80211 attempts to run /sbin/mdev
before the Ethernet links are up, then the system won't be able to
access /sbin/mdev over NFS and this will cause a lock up.

I'm using the very latest Atheros ath6kl Wi-Fi driver.  It is built
using compat-wireless which includes the cfg80211 code.

Is this a known problem?  Can you recommend a solution for it?


---- Charles
