Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout028.mac.com ([17.148.16.103]:62543 "EHLO
	asmtpout028.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LWVNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 16:13:07 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp028.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDW00L95G99GK70@asmtp028.mac.com>
 for linux-wireless@vger.kernel.org; Thu, 23 Dec 2010 13:12:49 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <AANLkTinyjZ0x1jvKndotDm-xHf0c192NQfB9y9_BQxFg@mail.gmail.com>
Date: Fri, 24 Dec 2010 01:12:29 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <FF69470D-9C14-4324-BA8E-F134B2AD9DEE@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
 <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com>
 <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com>
 <4D123FBB.1050801@hauke-m.de> <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com>
 <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com> <4D125B9F.7090503@hauke-m.de>
 <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com> <4D1266FA.7080305@hauke-m.de>
 <9AD18479-91B8-42DB-8D81-2AF11DD05405@mac.com>
 <AANLkTinyjZ0x1jvKndotDm-xHf0c192NQfB9y9_BQxFg@mail.gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,
                   For 2.6.32, some more SDIO stuff needs to be backported. For example, I get the following error:

[   16.232482] mmc1: card claims to support voltages below the defined range. These will be ignored.
[   16.241424] mmc1: host doesn't support card's voltages
[   16.246643] mmc1: error -22 whilst initialising SDIO card


So, the part for handling reporting card voltages need to be added in.

Also the SDIO run-time PM patches are not nearly as easy to apply to the android-rowboat-eclair-2.6.32 kernel.

Is the SDIO subsystem sufficiently modular so as to allow me to take a few file and use it as a drop in 
replacement for the 2.6.32 kernel?

Elvis Dowson

