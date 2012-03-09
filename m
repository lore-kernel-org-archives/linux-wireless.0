Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46937 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993Ab2CIMc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 07:32:26 -0500
Received: by obbuo6 with SMTP id uo6so2081813obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 04:32:25 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 9 Mar 2012 18:02:25 +0530
Message-ID: <CACAxKDqxgqpBGTwb6MRcq5SFoPrw_WPEr=RxHYkEU_MichsFpQ@mail.gmail.com> (sfid-20120309_133229_778808_7349D826)
Subject: Compat Wireless Backporting :wl12xx: WARNING unsupported chip id: 0x0
From: Girish B N <bngirish1@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am backporting the WL1271 driver from Compat Wireless-2.6 to Linux
2.6.28.2 on LPC313X platform.
Now the issue I am facing is the WL1271 chip id is always read as 0x0
when I load the WL12XX drivers. The reason I suspect is the issue with
struct sdio_func *func->num,
The Wi-FI interface in WL1271 can work with function number 0x2,
however, when I load the wl12xx_sdio.ko, I get the func->num = 0x01,
Which could a reason why I fail.
My system log when  the mmc platform driver loaded is as follows
mmc0: card claims to support voltages below the defined range. These
will be ignored.
mmc0: queuing CIS tuple 0x91 length 3
mmc0: new SDIO card at address 0001
I always get the "wl12xx: WARNING unsupported chip id: 0x0" error when
I run the following command "ifconfig wlan0 up".
My sdio write/read operations are successful.
The log from console
mac80211 add interface type 2 mac c1f48850
sdio write 53 addr 0x1ffc4, 4 bytes
sdio write 53 addr 0x1ffc0, 4 bytes
sdio write 53 addr 0x1ffcc, 4 bytes
sdio write 53 addr 0x1ffc8, 4 bytes
sdio write 53 addr 0x1ffd4, 4 bytes
sdio write 53 addr 0x1ffd0, 4 bytes
sdio write 53 addr 0x1ffd8, 4 bytes
sdio write 52 addr 0x1fffc, byte 0x01
wl12xx: WARNING unsupported chip id: 0x0
sdio write 53 addr 0x1ffc4, 4 bytes
sdio write 53 addr 0x1ffc0, 4 bytes
sdio write 53 addr 0x1ffcc, 4 bytes
sdio write 53 addr 0x1ffc8, 4 bytes
sdio write 53 addr 0x1ffd4, 4 bytes
sdio write 53 addr 0x1ffd0, 4 bytes
sdio write 53 addr 0x1ffd8, 4 bytes
sdio write 52 addr 0x1fffc, byte 0x01
wl12xx: WARNING unsupported chip id: 0x0
sdio write 53 addr 0x1ffc4, 4 bytes
sdio write 53 addr 0x1ffc0, 4 bytes
sdio write 53 addr 0x1ffcc, 4 bytes
sdio write 53 addr 0x1ffc8, 4 bytes
sdio write 53 addr 0x1ffd4, 4 bytes
sdio write 53 addr 0x1ffd0, 4 bytes
sdio write 53 addr 0x1ffd8, 4 bytes
sdio write 52 addr 0x1fffc, byte 0x01
wl12xx: WARNING unsupported chip id: 0x0
wl12xx: ERROR firmware boot failed despite 3 retries
We have done the necessary modifications to load the all the compat
wireless related KOs ( compat.ko, rfkill_backport.ko, cfg80211.ko,
mac80211.ko, wl12xx.ko and wl12xx_sdio.ko)
The following modifications are made to successfully load the modules
1. Disable all SDIO power management functions in Compat  wireless
drivers because the our kernel doesn't support SDIO/MMC run time power
management functions
2. Modified the check to "if (func->num != 0x01)" from "if (func->num
!= 0x02)" in wl1271_probe() functions of
sdio.c(/compat-wireless-2012-02-26/drivers/net/wireless/wl12xx/sdio.c)
3. The name was modified from "wl12xx_driver" to "wl12xx" in main.c
   static struct platform_driver wl12xx_driver = {
    .probe        = wl12xx_probe,
    .remove        = __devexit_p(wl12xx_remove),
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30)
    .id_table    = wl12xx_id_table,
#endif
    .driver = {
    //    .name    = "wl12xx_driver",
        .name    = "wl12xx",
        .owner    = THIS_MODULE,
    }
};\
But the chip id is not being read properly and due to this firmware is
not loaded.
Please let us know any suggestions on this
Thanks
Girish
