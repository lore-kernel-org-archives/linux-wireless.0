Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2485BC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 17:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E298F218AC
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 17:34:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="L6Dm7DAo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbfCOReJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 13:34:09 -0400
Received: from mail-vs1-f45.google.com ([209.85.217.45]:39040 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbfCOReI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 13:34:08 -0400
Received: by mail-vs1-f45.google.com with SMTP id w14so5859348vso.6
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 10:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4Nb0SyeHm8KrORQQJpAu069t7L9qLDVfe9U2FT865Tk=;
        b=L6Dm7DAoMN2j5z9v/uqj662dO9lumQWXuxIV9A2eS8nr9bwVIhd95MQlWCpkfiYK+N
         bUkT+8uURE+GaCftjshNyq80vLJvIXuU/sxMv7WViApbj3pBrity5k2oAR2Dt1CFFBuP
         HbFJH6h74lAdMma+MffGBDrYSYWtUzwAXALhAivlvYE2d5psp9ABt4+m/WIl7mFKoACI
         hBorpXYx2LQbng2ImSp4uJfPp3VhFVkXN4n7ZE4jQ1WL0uG8DtUodNfbe7DgrMPI+/jV
         u6PsOvqFdKQLZrARn5Sz6H9TlzrWMKtO9k2z1PzZSina9N9TLaHdDh/mWHJkE8/DpC+Z
         C8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4Nb0SyeHm8KrORQQJpAu069t7L9qLDVfe9U2FT865Tk=;
        b=KuosnhAV0DrIeQNhILNUX9PdsiDA/3IspWtKWr+Uodob180klg2Z14uHQgpyh6jrkR
         dXFGBxWyhsC0gRWzZ+up9EsP1rH+zSoWsHDdTImX/Uxuc6YjNPPhXBsnuotaNJAUYMsD
         cxYXxZnSeeVBAejOgMzzJspBXecdIdPT6+H2plvzmWPa7gZ8HEyhglHGij4J8dLEy9nH
         TYkXBpk43E0PZyL/053HjeDWNHvd3/BBQh08zmRJXlG3gWgkq09xtDaFl/iURxW3Qrl5
         ga0nbrRxfZscowSlmhSEMfuTEvGayYDWElU2NCKLKldCVnmKeVPQwQqz29auy/KAPe3j
         JfYA==
X-Gm-Message-State: APjAAAX7RPIJXqQcBWoTQU+TS4n4hoJhbj2F00UAN8pVd5CJr8/pT1s1
        ubX9EIC+onv2kk/0tqS1wv7KilIBj9AqSOzmwH1OinTHUv0=
X-Google-Smtp-Source: APXvYqxqoGajHPeYLL8BDAXC6lwusDls0EIY4W+e7P4+s0R+xM9QcGeJmALSVddpEaEgd6kH7FALCwky1dXNBdlYknI=
X-Received: by 2002:a67:f88a:: with SMTP id h10mr2528423vso.71.1552671246730;
 Fri, 15 Mar 2019 10:34:06 -0700 (PDT)
MIME-Version: 1.0
From:   Ryan Erbstoesser <rerbstoesser@gateworks.com>
Date:   Fri, 15 Mar 2019 10:32:04 -0700
Message-ID: <CAHUc_tsH9DsAnwfTWHbAwF7enp+ywWi8iFLX23JW=Dp4Tqn+BQ@mail.gmail.com>
Subject: Sparklan WPEQ-160ACN(BT) USB Support
To:     linux-wireless@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I apologize in advance, I am new to posting on here.

I am trying to use the radio Sparklan WPEQ-160ACN(BT) (USB only, no
PCIe) on an embedded ARM SBC.

The card is detected in lsusb but does not create an interface in
/sys/class/net.
I don't see anything in the logs that ath10k tried to load any firmware, etc.

The current wiki says that usb is not supported.
(https://wireless.wiki.kernel.org/en/users/drivers/ath10k#not_supported)

Is the wiki still correct?

Thank you, Ryan

Logs and info below:

root@bionic-armhf:~# lsusb
Bus 001 Device 003: ID 0cf3:9378 Atheros Communications, Inc.
Bus 001 Device 002: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

root@bionic-armhf:~# uname -a
Linux bionic-armhf 4.20.7-gaf078a3 #1 SMP Wed Feb 13 17:42:49 PST 2019
armv7l armv7l armv7l GNU/Linux

root@bionic-armhf:~# ls /sys/class/net/
can0  enp8s0  eth0  lo

root@bionic-armhf:~# dmesg | grep ath
root@bionic-armhf:~# dmesg | grep usb
[    0.201196] usbcore: registered new interface driver usbfs
[    0.201386] usbcore: registered new interface driver hub
[    0.201713] usbcore: registered new device driver usb
[    3.756564] usbcore: registered new interface driver usb-storage
[    3.766381] imx_usb 2184000.usb: Linked as a consumer to regulator.10
[    3.782126] imx_usb 2184200.usb: Linked as a consumer to regulator.9
[    3.834669] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002, bcdDevice= 4.20
[    3.843208] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.850519] usb usb1: Product: EHCI Host Controller
[    3.855420] usb usb1: Manufacturer: Linux 4.20.7-gaf078a3 ehci_hcd
[    3.861673] usb usb1: SerialNumber: ci_hdrc.1
[    4.228010] usb usb1-port1: over-current condition
[    4.588013] usb 1-1: new high-speed USB device number 2 using ci_hdrc
[    4.669721] usb_otg_vbus: disabling
[    4.808872] usb 1-1: New USB device found, idVendor=0424,
idProduct=2514, bcdDevice= b.b3
[    4.817185] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.157790] usb 1-1.2: new high-speed USB device number 3 using ci_hdrc
[    5.320105] usb 1-1.2: New USB device found, idVendor=0cf3,
idProduct=9378, bcdDevice= 3.00
[    5.328545] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    5.335877] usb 1-1.2: Product: USBWLAN
[    5.339783] usb 1-1.2: Manufacturer: Qualcomm Atheros
[    5.344856] usb 1-1.2: SerialNumber: 12345678
root@bionic-armhf:~#

root@bionic-armhf:~# ls /lib/firmware/ath10k/QCA9377/hw1.0/
board-2.bin  board.bin  firmware-5.bin  notice_ath10k_firmware-5.txt
