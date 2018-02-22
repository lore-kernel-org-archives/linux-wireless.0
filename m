Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackstar.xs4all.nl ([83.163.96.30]:35637 "EHLO
        blackstar.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933390AbeBVR2p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 12:28:45 -0500
Received: from [192.168.3.91] (unknown [192.168.3.91])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by blackstar.xs4all.nl (Postfix) with ESMTP id 9163634056C
        for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2018 18:10:01 +0100 (CET)
To: linux-wireless@vger.kernel.org
From: Bas Vermeulen <bvermeul@blackstar.nl>
Subject: ath9k: AR9287 device with little endian eeprom doesn't work on
 powerpc
Message-ID: <20a6ba1b-20be-0973-eea6-5d715544e685@blackstar.nl> (sfid-20180222_182850_167233_EC02495D)
Date: Thu, 22 Feb 2018 18:10:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have slotted a 300 Mbps Wireless N PCI Express Adapter into my 
PowerMac G5, and it failed
to initialize the driver with an error complaining about the EEPROM.

I disabled the line reading ah->ah_flags |= AH_NO_EEP_SWAP; in 
ath9k_of_init(), and this made my card show up and start working correctly.

Is there a better way of doing this? If not, what would be the best way 
to allow byte-swapping the eeprom on big endian machines?

Bas Vermeulen


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
