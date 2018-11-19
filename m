Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C5CC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 17:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B577120C01
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 17:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B577120C01
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391092AbeKTDUF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 22:20:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:53546 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391087AbeKTDUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 22:20:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2018 08:55:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,253,1539673200"; 
   d="scan'208";a="109396740"
Received: from jprestwo.jf.intel.com ([10.54.74.49])
  by fmsmga001.fm.intel.com with ESMTP; 19 Nov 2018 08:55:49 -0800
Message-ID: <c088323302411e9f9b0354ac1d41c3b925dc879e.camel@linux.intel.com>
Subject: Re: IWD reconnection issues with hardware wireless switch
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     Jens Heyens <jens.heyens@ewetel.net>,
        linux-wireless@vger.kernel.org
Date:   Mon, 19 Nov 2018 08:59:48 -0800
In-Reply-To: <654b1788-79a2-7610-c2c7-9e0297a59220@ewetel.net>
References: <654b1788-79a2-7610-c2c7-9e0297a59220@ewetel.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Jens,

IWD actually has its own mailing list:

iwd@lists.01.org

as well as an IRC channel #IWD on freenode. You may want to ask on
either of those. Also, before doing that, it would be more helpful to
run IWD with the debug flag "-d":

ExecStart=/usr/lib/iwd/iwd -d

Thanks,
James

On Mon, 2018-11-19 at 15:35 +0100, Jens Heyens wrote:
> Hello,
> 
> Hopefully, I am not wrong here, but after looking through the kernel
> wiki, I thought this would be the right place to ask.
> 
> I am having issues with iwd not trying to connect to any access point
> (essentially, not scanning at all) if I use the hardware switch for
> the
> wireless devices of my notebook. I'm not yet sure, if this is
> considered
> to be a bug of some kind or if it may be expected (but undocumented,
> I
> think) behaviour. I would expect iwd to resume execution after the
> device becomes available again.
> 
> I'll start with my setup:
> 
> Hardware:
> Lenovo T430s with
> `lspci | grep Network` ->
> 03:00.0 Network controller: Intel Corporation Centrino Advanced-N
> 6205
> [Taylor Peak] (rev 34)
> BIOS/Firmware is up to date, I am booting in legacy (i.e. without
> EFI) mode
> 
> Software:
> `uname -r` ->
> 4.19.2-arch1-1-ARCH
> 
> `/usr/lib/iwd/iwd --version` ->
> 0.12
> 
> `lsmod | grep iwlwifi` ->
> iwlwifi               344064  1 iwldvm
> cfg80211              778240  3 iwldvm,iwlwifi,mac80211
> 
> `systemctl show | head -n 2` ->
> Version=239
> Features=+PAM +AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP
> +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID
> +ELFUTILS
> +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid
> 
> `cat /etc/systemd/system/multi-user.target.wants/iwd.service` ->
> [Unit]
> Description=Wireless service
> Before=network.target
> Wants=network.target
> 
> [Service]
> Type=dbus
> BusName=net.connman.iwd
> ExecStart=/usr/lib/iwd/iwd
> LimitNPROC=1
> 
> [Install]
> WantedBy=multi-user.target
> 
> 
> 
> This is whats happening with iwd and udev while disabling and
> reenabling
> the hardware switch:
> 
> `journalctl -u iwd --follow` -> (hardware switch off + hardware
> switch
> on happened at 15:21:00
> Nov 19 15:20:50 beowulf systemd[1]: Starting Wireless service...
> Nov 19 15:20:50 beowulf iwd[7017]: No asymmetric key support found.
> Nov 19 15:20:50 beowulf iwd[7017]: TLS based WPA-Enterprise
> authentication methods will not function.
> Nov 19 15:20:50 beowulf iwd[7017]: Kernel 4.20+ is required for this
> feature.
> Nov 19 15:20:50 beowulf iwd[7017]: The following options are missing
> in
> the kernel:
> Nov 19 15:20:50 beowulf iwd[7017]:         CONFIG_ASYMMETRIC_KEY_TYPE
> Nov 19 15:20:50 beowulf iwd[7017]:
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE
> Nov 19 15:20:50 beowulf
> iwd[7017]:         CONFIG_PKCS7_MESSAGE_PARSER
> Nov 19 15:20:50 beowulf
> iwd[7017]:         CONFIG_X509_CERTIFICATE_PARSER
> Nov 19 15:20:50 beowulf
> iwd[7017]:         CONFIG_PKCS8_PRIVATE_KEY_PARSER
> Nov 19 15:20:50 beowulf iwd[7017]: Wireless daemon version 0.12
> Nov 19 15:20:50 beowulf iwd[7017]: Skipping optional configuration
> file
> /etc/iwd/main.conf
> Nov 19 15:20:50 beowulf systemd[1]: Started Wireless service.
> Nov 19 15:20:50 beowulf iwd[7017]: Wiphy: 0, Name: phy0
> Nov 19 15:20:50 beowulf iwd[7017]:         Bands: 2.4 GHz 5 GHz
> Nov 19 15:20:50 beowulf iwd[7017]:         Ciphers: CCMP TKIP
> Nov 19 15:20:50 beowulf iwd[7017]:         Supported iftypes: ad-hoc
> station ap
> Nov 19 15:20:50 beowulf iwd[7017]: No ControlPortOverNL80211 setting,
> defaulting to True
> Nov 19 15:21:02 beowulf iwd[7017]: Received Deauthentication event,
> reason: 3, from_ap: false
> Nov 19 15:21:02 beowulf iwd[7017]: Periodic scan could not be
> triggered:
> Network is down (100)
> 
> `udevadm monitor | grep -v usb` -> (with hardware switch off / on
> again)
> KERNEL[9585.354038] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> UDEV  [9585.358004] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> KERNEL[9585.363258] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> KERNEL[9585.364144] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> KERNEL[9585.364253] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> UDEV  [9585.365693] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> UDEV  [9585.366578] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> UDEV  [9585.367126] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> KERNEL[9587.181141] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> UDEV  [9587.184391] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> KERNEL[9587.187325] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> KERNEL[9587.189195] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> KERNEL[9587.189284] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> UDEV  [9587.190770] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> UDEV  [9587.191815] change
> /devices/platform/thinkpad_acpi/rfkill/rfkill0 (rfkill)
> UDEV  [9587.192535] change
> /devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill1
> (rfkill)
> 
> 
> rfkill seems to work as expected, i.e. `rfkill list` returns
> 1: phy0: Wireless LAN
>     Soft blocked: no
>     Hard blocked: no
> 
> 
> 
> Should file an issue somewhere or is this expected?
> If it is expected, what is the recommended approach for my hardware
> switch to work as expected here?
> 
> 
> Thanks in advance,
> 
> Jens

