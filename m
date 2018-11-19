Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F222DC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 14:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1AFC2089F
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 14:45:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1AFC2089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ewetel.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbeKTBJR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:09:17 -0500
Received: from mail-out24.ewetel.de ([212.6.122.24]:48439 "EHLO
        mail-out.ewetel.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729459AbeKTBJR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 20:09:17 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2018 20:09:16 EST
Received: from mail-hub0-pp.ewetel.de (mail-hub0-pp-adm.ncsadm.net [172.24.32.71])
        by mail-out.ewetel.de (EWE TEL) with ESMTP id 99D0E3E9DD
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2018 15:35:33 +0100 (CET)
Received: from mail-relay1-vp.ewetel.de (mail-relay1-vp-adm.ncsadm.net [172.24.32.198])
        by mail-hub0-pp.ewetel.de (8.12.1/8.12.9) with ESMTP id wAJEZWa9009251
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2018 15:35:33 +0100
Received: from [192.168.178.32] (i59F4FD7A.versanet.de [89.244.253.122])
        (Authenticated sender: jens.heyens@ewetel.net)
        by smtps-1.ewe.net (Postfix) with ESMTPSA id B316466039
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2018 15:35:32 +0100 (CET)
To:     linux-wireless@vger.kernel.org
From:   Jens Heyens <jens.heyens@ewetel.net>
Openpgp: preference=signencrypt
Subject: IWD reconnection issues with hardware wireless switch
Message-ID: <654b1788-79a2-7610-c2c7-9e0297a59220@ewetel.net>
Date:   Mon, 19 Nov 2018 15:35:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-ET-Id: 115291542638132.783947-ewe@mail-relay1-vp
X-ET-Auth: email:jens.heyens@ewetel.net
X-CheckCompat: OK
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

Hopefully, I am not wrong here, but after looking through the kernel
wiki, I thought this would be the right place to ask.

I am having issues with iwd not trying to connect to any access point
(essentially, not scanning at all) if I use the hardware switch for the
wireless devices of my notebook. I'm not yet sure, if this is considered
to be a bug of some kind or if it may be expected (but undocumented, I
think) behaviour. I would expect iwd to resume execution after the
device becomes available again.

I'll start with my setup:

Hardware:
Lenovo T430s with
`lspci | grep Network` ->
03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205
[Taylor Peak] (rev 34)
BIOS/Firmware is up to date, I am booting in legacy (i.e. without EFI) mode

Software:
`uname -r` ->
4.19.2-arch1-1-ARCH

`/usr/lib/iwd/iwd --version` ->
0.12

`lsmod | grep iwlwifi` ->
iwlwifi               344064  1 iwldvm
cfg80211              778240  3 iwldvm,iwlwifi,mac80211

`systemctl show | head -n 2` ->
Version=239
Features=+PAM +AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP
+LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS
+KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid

`cat /etc/systemd/system/multi-user.target.wants/iwd.service` ->
[Unit]
Description=Wireless service
Before=network.target
Wants=network.target

[Service]
Type=dbus
BusName=net.connman.iwd
ExecStart=/usr/lib/iwd/iwd
LimitNPROC=1

[Install]
WantedBy=multi-user.target



This is whats happening with iwd and udev while disabling and reenabling
the hardware switch:

`journalctl -u iwd --follow` -> (hardware switch off + hardware switch
on happened at 15:21:00
Nov 19 15:20:50 beowulf systemd[1]: Starting Wireless service...
Nov 19 15:20:50 beowulf iwd[7017]: No asymmetric key support found.
Nov 19 15:20:50 beowulf iwd[7017]: TLS based WPA-Enterprise
authentication methods will not function.
Nov 19 15:20:50 beowulf iwd[7017]: Kernel 4.20+ is required for this
feature.
Nov 19 15:20:50 beowulf iwd[7017]: The following options are missing in
the kernel:
Nov 19 15:20:50 beowulf iwd[7017]:         CONFIG_ASYMMETRIC_KEY_TYPE
Nov 19 15:20:50 beowulf iwd[7017]:
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE
Nov 19 15:20:50 beowulf iwd[7017]:         CONFIG_PKCS7_MESSAGE_PARSER
Nov 19 15:20:50 beowulf iwd[7017]:         CONFIG_X509_CERTIFICATE_PARSER
Nov 19 15:20:50 beowulf iwd[7017]:         CONFIG_PKCS8_PRIVATE_KEY_PARSER
Nov 19 15:20:50 beowulf iwd[7017]: Wireless daemon version 0.12
Nov 19 15:20:50 beowulf iwd[7017]: Skipping optional configuration file
/etc/iwd/main.conf
Nov 19 15:20:50 beowulf systemd[1]: Started Wireless service.
Nov 19 15:20:50 beowulf iwd[7017]: Wiphy: 0, Name: phy0
Nov 19 15:20:50 beowulf iwd[7017]:         Bands: 2.4 GHz 5 GHz
Nov 19 15:20:50 beowulf iwd[7017]:         Ciphers: CCMP TKIP
Nov 19 15:20:50 beowulf iwd[7017]:         Supported iftypes: ad-hoc
station ap
Nov 19 15:20:50 beowulf iwd[7017]: No ControlPortOverNL80211 setting,
defaulting to True
Nov 19 15:21:02 beowulf iwd[7017]: Received Deauthentication event,
reason: 3, from_ap: false
Nov 19 15:21:02 beowulf iwd[7017]: Periodic scan could not be triggered:
Network is down (100)

`udevadm monitor | grep -v usb` -> (with hardware switch off / on again)
KERNEL[9585.354038] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)
UDEV  [9585.358004] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)
KERNEL[9585.363258] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
KERNEL[9585.364144] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
KERNEL[9585.364253] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)
UDEV  [9585.365693] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
UDEV  [9585.366578] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
UDEV  [9585.367126] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)
KERNEL[9587.181141] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)
UDEV  [9587.184391] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)
KERNEL[9587.187325] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
KERNEL[9587.189195] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
KERNEL[9587.189284] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)
UDEV  [9587.190770] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
UDEV  [9587.191815] change
/devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
UDEV  [9587.192535] change
/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
(rfkill)


rfkill seems to work as expected, i.e. `rfkill list` returns
1: phy0: Wireless LAN
    Soft blocked: no
    Hard blocked: no



Should file an issue somewhere or is this expected?
If it is expected, what is the recommended approach for my hardware
switch to work as expected here?


Thanks in advance,

Jens
