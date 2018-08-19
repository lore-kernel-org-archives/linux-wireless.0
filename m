Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:44858 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbeHSFcP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Aug 2018 01:32:15 -0400
Received: by mail-qt0-f180.google.com with SMTP id b15-v6so12799368qtp.11
        for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2018 19:22:26 -0700 (PDT)
Received: from ?IPv6:2001:470:8:209:ffff:ffff:ffff:ffff? ([2001:470:8:209:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id e29-v6sm4677711qte.47.2018.08.18.19.22.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Aug 2018 19:22:25 -0700 (PDT)
From: Farhan Khan <khanzf@gmail.com>
Subject: rtlwifi/rtl8188ee: _rtl_pci_rx_interrupt equivalent dropping frames
To: linux-wireless@vger.kernel.org
Message-ID: <37b22f82-8246-1f2e-019c-f78382995ca9@gmail.com> (sfid-20180819_042236_355273_30254415)
Date: Sat, 18 Aug 2018 22:22:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am working on porting the rtlwifi/rtl8188ee to expand FreeBSD's 
equivalent rtwn driver. In the equivalent code, the function 
_rtl_pci_rx_interrupt from drivers/net/wireless/realtek/rtlwifi/pci.c 
runs into the if-condition:

if (own) /* wait data to be filled by hardware */
	return;

The equivalent of this on FreeBSD is returning true, thus resulting in 
excessively dropped frames. Based on the surrounding code on the Linux 
side, this suggests that data has not been filled by Realtek device, 
despite the device triggering an interrupt.

What would cause the device to issue an interrupt, but continuously 
return true on this if-statement? Is this indicative of anything?
Are there any register values during initialization that may suggest 
this happening?

Its quite difficult to work on this without documentation, so your help 
is *greatly* appreciated.

Thank you,

--
Farhan Khan
PGP Fingerprint: B28D 2726 E2BC A97E 3854 5ABE 9A9F 00BC D525 16EE
