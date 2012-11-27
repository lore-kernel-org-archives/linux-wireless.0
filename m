Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59680 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2K0G2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:28:30 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so7699215iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:28:29 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 27 Nov 2012 11:58:09 +0530
Message-ID: <CABPxzYKmbyUwZg49O9OyzRNmR2xjRJcE_TsH3p0pADLAho1cVw@mail.gmail.com> (sfid-20121127_072834_131865_E82D072E)
Subject: AMPDU Stats in the Radio Tap: Mac80211 and Drivers Support
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

When using a compat-wireless drivers for sniffing on intel and ath9k
based wifi cards, i could see that the wireshark in monitor mode
doesn't display AMPDU stats.
How do we get to know the AMPDU details from the wireshark?

Currently we see the data packet and BA, we have patched the wireshark
to support the AMPDU stats, with this patch if i open the saved
capture shared in the same patch thread i am able to see the AMPDU
stats but not with the live capture using my network card.

So this means that my current driver/mac80211 doesn't support it and
the nic used for the saved capture does. So when walking through the
code i could see that this requires support from mac80211 and driver
as well.

Can someone answer the below queries?
==================================


1) Support in madc80211

wireless-testing git has support for AMPDU stats in mac80211
Latest Kernel: mac80211 doesnt has this support, why is this?

2) Support in drivers

I have also checked few drivers like the ath9k and iwlwifi but see
that none of the driver populates the AMPDU Rx Details
(RX_FLAG_AMPDU_DETAILS).
Is there any reason for this?


Patch Info: http://www.wireshark.org/lists/wireshark-bugs/201208/msg00161.html
AMPDU Radio Tap Fields: http://www.radiotap.org/defined-fields/A-MPDU%20status

Thanks in advance.

Regards,
Chaitanya T K.
