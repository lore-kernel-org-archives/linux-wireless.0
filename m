Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37500 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbbB1Iln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Feb 2015 03:41:43 -0500
Message-ID: <54F17F43.7060605@m4x.org> (sfid-20150228_094215_805035_4E2A8304)
Date: Sat, 28 Feb 2015 16:41:39 +0800
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
MIME-Version: 1.0
To: Christophe Ricard <christophe.ricard@gmail.com>,
	Samuel Ortiz <sameo@linux.intel.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Invalid assignment to gate in st21nfca_get_iso14443_3_uid
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

While compiling Linux with -Wunused-but-set-parameter, gcc reported a
warning in st21nfca_get_iso14443_3_uid function, about "gate" being set
but not used [1].  By looking at the code, it is clear that "gate =
uid_skb->data;" does nothing useful.  The function is only called once,
by st21nfca_hci_target_from_gate [2], which uses the content of the uid
array which is NOT initialized by st21nfca_get_iso14443_3_uid as the
source of a memcpy [3].

My understanding of the code is that "gate = uid_skb->data;" in
st21nfca_get_iso14443_3_uid should be changed to "memcpy(gate,
uid_skb->data, uid_skb->len);".

I'm new to the NFC subsystem so I can be wrong, in which case please
tell me what I missed in my analysis.  Please Cc me when replying as I
am not subscribed to the mailing lists.

Thanks,

Nicolas


[1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/nfc/st21nfca/st21nfca.c?id=v4.0-rc1#n575
[2]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/nfc/st21nfca/st21nfca.c?id=v4.0-rc1#n646
[3]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/nfc/st21nfca/st21nfca.c?id=v4.0-rc1#n682
