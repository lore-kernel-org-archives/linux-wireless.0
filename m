Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D769C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 22:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3231F206B7
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 22:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LkcWEo2V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfAJWzw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 17:55:52 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:45340 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbfAJWzv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 17:55:51 -0500
Received: by mail-ot1-f54.google.com with SMTP id 32so11459954ota.12
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 14:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=E0vZlTEW7bymtL2T+hINwoetDgB0bbxZda/DKmXIwdk=;
        b=LkcWEo2VqlibHJ2MJw26qTKP3SGo8UlQosWHu6QISYLSTYgIbdooy+Nxv/JnAUyJGY
         nL5zc3XBq3yt6UfItNFDlQsSB/gtOuXF6jJkdZl7m981DLknDd+wdK5r3GU8PlKpyFoq
         S5/p8VXpGMmECHdzyZkUM0suzXD/NsIDK4zBpeT3Yr6KFniEpR8bA07yjxUZix0f4CDm
         HlXtuD4U82InUfAvQHoBdKHJuF+nMQoRWy93cUeI/AsPV7creA4pMHH461vQxK1LXmyH
         HvHRxGjPeIhGPNDKkVOG6QCA97+fu8BYlu/k39XBaQ0O1WHsKnp+GsizmM4wIZhtYm8y
         G2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=E0vZlTEW7bymtL2T+hINwoetDgB0bbxZda/DKmXIwdk=;
        b=sz0xrdMS61D6qbC4arKXgzL96UtZtvy0hOBVDDwu9FgW+cLX84Q/13tMaTCY20Chbo
         A9KgGAams/7dH/YPiG9KgP1724wOOj2vDim6AmnlvV7clm25b8K//LCWmbIA6UD6DAYQ
         Rn2D6SKT3wSc8BS55W8dkFcgk3AK8Z+TGDPu5p1ryd935WpueQQvGRm7bS20i+8IrRM3
         aVCTGqkHB7HrKgDr/2wIMjEdpqgd3sMpMlJu1PcoaoYU6QKTewt0Gt68Sx9bum3d6pvn
         J2vjwMdggMU3dyM3Ie1vg/kJrClJSYGwqlLRuQMbuS6EA/1W7UnsaZtluQJ6UIkiETKQ
         uHsg==
X-Gm-Message-State: AJcUukclv+ZyzIMOj7y2i5X2Ap2y9y1E23FMwXrmmrj5J7L/LJZxQXFI
        XGF8Ghjy8FSXMI3oxAwYtQrGd5KCTf3WcihqPOoFYTMQE8g=
X-Google-Smtp-Source: ALg8bN5OuYkkgZKIguI8/KWWxLYnrVEvnoXH0efTFEghud7JUgLiZwhJBHkQ4xUtBWxxCoH0uRlxTWxY4PF0qcbOWWU=
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr8299154otm.65.1547160949676;
 Thu, 10 Jan 2019 14:55:49 -0800 (PST)
MIME-Version: 1.0
From:   Rosen Penev <rosenp@gmail.com>
Date:   Thu, 10 Jan 2019 14:55:38 -0800
Message-ID: <CAKxU2N9o5WeUwFMUwwXKHaPj7R+oiSKV1c2n8RtXwGNZRtw5Sw@mail.gmail.com>
Subject: MT76x2U crashes XHCI driver on AMD Ryzen system
To:     linux-wireless@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I have an ALFA AWUS036ACM and whenever I plug it in, the XHCI driver
dies. This is on an ASRock X370 motherboard. Kernel 4.20 Arch Linux.

After plugging in the adapter, the integrated wireless chip (Intel
3168) also dies. Disabling the motherboard wireless does not help.
Here are two fairly similar logs. First with Intel 3168 and the second
with it disabled in UEFI.

kernel: xhci_hcd 0000:03:00.0: xHCI host not responding to stop
endpoint command.
kernel: xhci_hcd 0000:03:00.0: xHCI host controller not responding, assume dead
kernel: xhci_hcd 0000:03:00.0: HC died; cleaning up
kernel: usb 1-9: USB disconnect, device number 2
kernel: usb 1-14: USB disconnect, device number 3
bluetoothd[506]: Endpoint unregistered: sender=:1.151
path=/MediaEndpoint/A2DPSource
bluetoothd[506]: Endpoint unregistered: sender=:1.151
path=/MediaEndpoint/A2DPSink
systemd[1]: Starting Load/Save RF Kill Switch Status...
NetworkManager[512]: <info>  [1547157527.0255] bluez5: NAP: removed
interface B0:35:9F:2D:73:1D
systemd[1]: Stopped target Bluetooth.
systemd[1]: Started Load/Save RF Kill Switch Status.
audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295
msg='unit=systemd-rfkill comm="systemd" exe="/usr/lib/systemd/systemd"
hostname=? addr=? terminal=? res=success'
kkuid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-rfkill
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=?
terminal=? res=success'
audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295
msg='unit=systemd-rfkill comm="systemd" exe="/usr/lib/systemd/systemd"
hostname=? addr=? terminal=? res=success'
kernel: audit: type=1131 audit(1547157532.035:57): pid=1 uid=0
auid=4294967295 ses=4294967295 msg='unit=systemd-rfkill comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=success'
kernel: iwlwifi 0000:27:00.0: iwl_pcie_cmdq_reclaim: Read index for
DMA queue txq id (0), index 0 is out of range [0-256] 61 60.
iwlwifi 0000:27:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT
domain=0x0000 address=0x00000000ff442000 flags=0x0020]
kernel: iwlwifi 0000:27:00.0: HCMD_ACTIVE already clear for command
REPLY_SF_CFG_CMD
iwlwifi 0000:27:00.0: iwl_pcie_cmdq_reclaim: Read index for DMA queue
txq id (0), index 0 is out of range [0-256] 61 60.

Folllowed by more iwlwifi errors as well as kernel crashdumps.

Without iwlwifi:

kernel: usb 1-14: new high-speed USB device number 3 using xhci_hcd
kernel: usb 1-14: New USB device found, idVendor=0e8d, idProduct=7612,
bcdDevice= 1.00
kernel: usb 1-14: New USB device strings: Mfr=2, Product=3, SerialNumber=4
usb 1-14: Product: Wireless
kernel: usb 1-14: Manufacturer: MediaTek Inc.
kernel: usb 1-14: SerialNumber: 000000000
mtp-probe[1400]: checking bus 1, device 3:
"/sys/devices/pci0000:00/0000:00:01.3/0000:03:00.0/usb1/1-14"
mtp-probe[1400]: bus: 1, device: 3 was not an MTP device
kernel: usb 1-14: reset high-speed USB device number 3 using xhci_hcd
kernel: mt76x2u 1-14:1.0: ASIC revision: 76120044
kernel: mt76x2u 1-14:1.0: ROM patch build: 20140408060640a
kernel: xhci_hcd 0000:03:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT
domain=0x0000 address=0x00000000f6d5c400 flags=0x0000]
kernel: mt76x2u 1-14:1.0: firmware upload timed out
kernel: xhci_hcd 0000:03:00.0: xHCI host not responding to stop
endpoint command.
kernel: xhci_hcd 0000:03:00.0: xHCI host controller not responding, assume dead
kernel: xhci_hcd 0000:03:00.0: HC died; cleaning up
kernel: usb 1-9: USB disconnect, device number 2
bluetoothd[489]: Endpoint unregistered: sender=:1.150
path=/MediaEndpoint/A2DPSource
kernel: usb 1-14: USB disconnect, device number 3
NetworkManager[496]: <info>  [1547157974.3360] bluez5: NAP: removed
interface B0:35:9F:2D:73:1D
bluetoothd[489]: Endpoint unregistered: sender=:1.150
path=/MediaEndpoint/A2DPSink
systemd[1]: Starting Load/Save RF Kill Switch Status...
systemd[1]: Stopped target Bluetooth.
systemd[1]: Started Load/Save RF Kill Switch Status.
audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295
msg='unit=systemd-rfkill comm="systemd" exe="/usr/lib/systemd/systemd"
hostname=? addr=? terminal=? res=success'
kernel: audit: type=1130 audit(1547157974.336:52): pid=1 uid=0
auid=4294967295 ses=4294967295 msg='unit=systemd-rfkill comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=success'
audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295
msg='unit=systemd-localed comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=success'
audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295
msg='unit=systemd-hostnamed comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=success'
kernel: audit: type=1131 audit(1547157977.826:53): pid=1 uid=0
auid=4294967295 ses=4294967295 msg='unit=systemd-localed
comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=?
terminal=? res=success'
audit: type=1131 audit(1547157977.826:54): pid=1 uid=0 auid=4294967295
ses=4294967295 msg='unit=systemd-hostnamed comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=success'
audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295
msg='unit=systemd-rfkill comm="systemd" exe="/usr/lib/systemd/systemd"
hostname=? addr=? terminal=? res=success'
kernel: audit: type=1131 audit(1547157979.346:55): pid=1 uid=0
auid=4294967295 ses=4294967295 msg='unit=systemd-rfkill comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=success'
kernel: mt76x2u 1-14:1.0: MAC RX failed to stop
kernel: mt76x2u: probe of 1-14:1.0 failed with error -5
kernel: usbcore: registered new interface driver mt76x2u
geoclue[785]: Service not used for 60 seconds. Shutting down..
audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295
msg='unit=geoclue comm="systemd" exe="/usr/lib/systemd/systemd"
hostname=? addr=? terminal=? res=success'
kernel: audit: type=1131 audit(1547157990.969:56): pid=1 uid=0
auid=4294967295 ses=4294967295 msg='unit=geoclue comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=success'
