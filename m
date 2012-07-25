Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50242 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2GYSdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 14:33:16 -0400
Received: by ghrr11 with SMTP id r11so1070224ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 11:33:16 -0700 (PDT)
Message-ID: <50103BE8.1020203@lwfinger.net> (sfid-20120725_203320_444386_B065667C)
Date: Wed, 25 Jul 2012 13:33:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tim and Alison Bentley <Home@TRARBentley.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: New Laptop and Driver
References: <CAAT9HsjZ7wPbkRMH94HDNBS+vOhLigKLYULqfyQobh_Oyt9M4w@mail.gmail.com> <501030E9.3090707@lwfinger.net> <CAAT9Hshwb+iPMALGvP1P2UHzEQbyvYNM0_zz0dHp0mJuy6KwLA@mail.gmail.com>
In-Reply-To: <CAAT9Hshwb+iPMALGvP1P2UHzEQbyvYNM0_zz0dHp0mJuy6KwLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2012 01:00 PM, Tim and Alison Bentley wrote:
> 01:00.0 VGA compatible controller [0300]: nVidia Corporation Device
> [10de:0de9] (rev a1)
> 03:00.0 Network controller [0280]: Atheros Communications Inc. Device
> [168c:0037] (rev 01)
> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
> 07)

The Realtek device is the one used for your wired network.

The Atheros device is not in the tables for the latest version of any wireless 
driver. Perhaps it will work if you do the following:

su -
modprobe -v ath9k
echo "168c 0037" > /sys/bus/pci/drivers/ath9k/new_id
exit

The above will work if the driver handles the device, but it is not yet in the 
tables. Perhaps the Atheros developers will know the status of that device.

When replying to E-mail in this list, and most other technical mailing lists, 
please do not top post. Always put your answer below the quoted material as I 
did here.

Larry



