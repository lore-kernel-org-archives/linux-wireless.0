Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33142 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZLYN7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2009 08:59:46 -0500
Received: by ewy19 with SMTP id 19so194686ewy.21
        for <linux-wireless@vger.kernel.org>; Fri, 25 Dec 2009 05:59:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2d0a357f0912250159n66368d8ana894298bec2b17fa@mail.gmail.com>
References: <2d0a357f0912250159n66368d8ana894298bec2b17fa@mail.gmail.com>
Date: Fri, 25 Dec 2009 14:59:44 +0100
Message-ID: <2d0a357f0912250559n3f326242hc2580c2425cb0c7b@mail.gmail.com>
Subject: Re: [2.6.33-rc{1,2}]: iwl3945: Microcode SW errors w/ DHCP
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems a bit better after merging wireless-2.6 master GIT into upstream
(2.6.33-rc2) with DHCP and iwl3945, now.

wireless-2.6 patchset:

$ ls debian/patches/wireless-2.6/
0001-rt2x00-Fix-rt2800usb-detection-in-rt2800lib.patch
0002-mac80211-Add-define-for-TX-headroom-reserved-by-mac8.patch
0003-iwlwifi-allocated-rx-page-accounting-cleanup.patch
0004-iwlwifi-power-up-all-devices-for-EEPROM-read.patch
0005-iwlwifi-fix-syslog-message-for-event-log-dump-size.patch
0006-ath9k-Last-fix-for-TX-software-padding.patch
0007-drivers-net-wireless-Correct-code-taking-the-size-of.patch
0008-rt2x00-Disable-powersaving-for-rt61pci-and-rt2800pci.patch
0009-iwlwifi-fix-EEPROM-OTP-reading-endian-annotations-an.patch
0010-iwlwifi-fix-more-eeprom-endian-bugs.patch
0011-iwl3945-disable-power-save.patch
0012-iwlwifi-initialize-spinlock-before-use.patch
0013-iwl3945-fix-panic-in-iwl3945-driver.patch
0014-iwlwifi-fix-40MHz-operation-setting-on-cards-that-do.patch
0015-rt2x00-Fix-calculation-of-rt2800-iveiv-entry-offset.patch
0016-ath9k-Fix-bug-in-assigning-sequence-number.patch
0017-ath9k-Fix-TX-queue-draining.patch
0018-ath9k-Stop-ANI-when-doing-a-reset.patch
0019-drivers-net-wireless-iwlwifi-iwl-tx.c-fix-gcc-3.4.5-.patch
0020-Libertas-fix-buffer-overflow-in-lbs_get_essid.patch
0021-iwmc3200wifi-Fix-test-of-unsigned-in-iwm_ntf_stop_re.patch
0022-mac80211-fix-peer-HT-capabilities.patch
0023-mac80211-fix-WMM-AP-settings-application.patch
0024-ps3_gelic_wireless-Fix-build-failure-due-to-missing-.patch

Nevertheless, I will have an eye on this issue.

- Sedat -

On Fri, Dec 25, 2009 at 10:59 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Hi,
>
> I am having Microcode SW errors when using network via DHCP with
> upstream kernel:
>
> # /etc/init.d/networking start
> Configuring network interfaces...Internet Systems Consortium DHCP Client V3.1.3
> Copyright 2004-2009 Internet Systems Consortium.
> All rights reserved.
> For info, please visit https://www.isc.org/software/dhcp/
>
> Listening on LPF/wlan0/00:19:d2:62:e4:bb
> Sending on   LPF/wlan0/00:19:d2:62:e4:bb
> Sending on   Socket/fallback
> [  325.481013] iwl3945 0000:10:00.0: Microcode SW error detected.
> Restarting 0x2000008.
> [  325.481972] iwl3945 0000:10:00.0: Start IWL Error Log Dump:
> [  325.483291] iwl3945 0000:10:00.0: Status: 0x000302E4, count: 1
> [  325.485352] iwl3945 0000:10:00.0: Desc       Time       asrtPC
> blink2 ilink1  nmiPC   Line
> [  325.487376] iwl3945 0000:10:00.0: SYSASSERT     (#5) 0000000024
> 0x008B6 0x0F3F2 0x0029A 0x00000 947
> [  325.487376]
> [  325.489543] iwl3945 0000:10:00.0: Start IWL Event Log Dump: display
> last 4 count
> [  325.493983] iwl3945 0000:10:00.0: 0000000000○0x00000108○0117
> [  325.493983] iwl3945 0000:10:00.0: 0000000000○0x000000be○0118
> [  325.493983] iwl3945 0000:10:00.0: 0000000022○0x00000000○1104
> [  325.493983] iwl3945 0000:10:00.0: 0000000025○0x00000100○0125
> DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 4
> DHCPOFFER from 192.168.2.1
> DHCPREQUEST on wlan0 to 255.255.255.255 port 67
> DHCPACK from 192.168.2.1
> bound to 192.168.2.103 -- renewal in 416665 seconds.
> done.
>
> Configuring wlan0 via static-IP is OK.
>
> Diff between /e/n/i looks like this:
>
>  auto wlan0
> -iface wlan0 inet dhcp
> +iface wlan0 inet static
> +       address 192.168.2.103
> +       broadcast 192.168.2.255
> +       dns-nameservers 192.168.2.1 208.67.222.222 208.67.220.220
> +       gateway 192.168.2.1
> +       netmask 255.255.255.0
> +       network 192.168.2.0
>        wpa-bssid topsecret
>        wpa-psk topsecret
>        wpa-ssid topsecret
>
> Is this a known issue or any hints?
>
> Kind Regards,
> - Sedat -
>
