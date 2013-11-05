Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:53567 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3KETwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:52:42 -0500
Received: by mail-we0-f178.google.com with SMTP id q59so3918192wes.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:52:41 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 6 Nov 2013 01:22:20 +0530
Message-ID: <CABPxzY++gCivs1u8nDtAeB5=p+ZkGHXmOnqud1hkh=TWB5Xprg@mail.gmail.com> (sfid-20131105_205248_293310_9940CD69)
Subject: [Query] Decryption and Monitor Mode
To: radiotap@netbsd.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In our internal tests we make use of monitor mode heavily for all the
debugging, especially with security related issues (as packets are
already decrypted).

But as the decryption is done in HW (most cases), the HW decrypts the
packet but still retains the Security Header and sends to the host (at
least in our solution), we remove that header while giving the packet
to network stack but while giving it to the monitor mode we do not
strip off that and also protection=1.

With this wireshark is not able to decode the packets, even thought
they are decrypted. I propose 2 solutions

Radiotap and Wireshark:

1) Add 2 flags to the radiotap RX Flags (HW Decrypted the packet,
Packet has security Header (for some chipsets which consume the
security header as well..??).)

Based on these the wireshark dissector decodes the packet accordingly.

mac80211:

2) Remove the security header information in the monitor path as well
based on the existing RX_FLAGS.


Solutions 2 looks more elegant and simple, any comments?

-- 
Thanks,
Regards,
Chaitanya T K.
