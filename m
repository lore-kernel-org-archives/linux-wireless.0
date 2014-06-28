Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:61964 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaF1VR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 17:17:28 -0400
Received: by mail-ob0-f182.google.com with SMTP id nu7so7126504obb.13
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 14:17:27 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 29 Jun 2014 05:17:27 +0800
Message-ID: <CAMtVo_MxCfV7MWC+ksWc=PJM0KEHDUVuCMpg0NCWBW8EeLU5Jw@mail.gmail.com> (sfid-20140628_231801_489284_29AEEE53)
Subject: Bug: USB wifi card TL-WN722N (AR9271, ath9k_htc) fails to get DHCP lease
From: lolilolicon <lolilolicon@gmail.com>
To: ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This bug was introduced in merge commit 88daf80 (if I did the bisect correctly).

A workaround around the bug is to set the ath9k_htc param nohwcrypt=1.

The difference in the journal/log between good and bad is that in the
presence of the bug, dhcpcd would time out soliciting a DHCP lease.
Some other users report that they're getting an IP, but the connection
is very slow.

Also reported elsewhere:
https://bugs.archlinux.org/task/40905
https://bugzilla.kernel.org/show_bug.cgi?id=78581

Apologies if I messed up anything (sending to the wrong ML/people,
inadequate info, etc.)
If you need anything else, just ask.
