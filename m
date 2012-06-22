Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:51175 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab2FVR63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:58:29 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: iwlwifi: "GF was set with SGI:SISO"
Date: Fri, 22 Jun 2012 19:58:23 +0200
Message-ID: <87lijfjkjk.fsf@nemi.mork.no> (sfid-20120622_195839_040723_F4125B6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I just started receiving these mysterious error messages on each
transmitted packet:


Jun 22 19:48:21 nemi kernel: [255522.415447] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
Jun 22 19:48:21 nemi kernel: [255522.445200] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
Jun 22 19:48:21 nemi kernel: [255522.448130] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
Jun 22 19:48:21 nemi kernel: [255522.454865] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
Jun 22 19:48:21 nemi kernel: [255522.474708] iwlwifi 0000:03:00.0: GF was set with SGI:SISO
Jun 22 19:48:21 nemi kernel: [255522.486878] iwlwifi 0000:03:00.0: GF was set with SGI:SISO

which seems to originate from this code in
drivers/net/wireless/iwlwifi/dvm/rs.c :

                if (use_green) {
                        rate_n_flags |= RATE_MCS_GF_MSK;
                        if (is_siso(tbl->lq_type) && tbl->is_SGI) {
                                rate_n_flags &= ~RATE_MCS_SGI_MSK;
                                IWL_ERR(priv, "GF was set with SGI:SISO\n");
                        }
                }



But I do fail to see what I as an user is expected to do about this...

Could the message be improved with some end user guidance?  And it
should obviously be rate-limited.

I am using the driver from 3.5-rc2.  The initial driver messages are:

bjorn@nemi:~$ grep iwl /var/log/dmesg
[   11.771797] iwlwifi: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   11.773943] iwlwifi: Copyright(c) 2003-2012 Intel Corporation
[   11.835304] bus: 'pci': add driver iwlwifi
[   11.835340] bus: 'pci': driver_probe_device: matched device 0000:03:00.0 with driver iwlwifi
[   11.835344] bus: 'pci': really_probe: probing driver iwlwifi with device 0000:03:00.0
[   11.835422] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[   11.835493] iwlwifi 0000:03:00.0: pci_resource_base = ffffc900057a4000
[   11.835562] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
[   11.853318] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
[   11.853366] driver: '0000:03:00.0': driver_bound: bound to device 'iwlwifi'
[   11.853425] firmware 0000:03:00.0: firmware: requesting iwlwifi-5000-5.ucode
[   11.856712] bus: 'pci': really_probe: bound device 0000:03:00.0 to driver iwlwifi
[   12.521925] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
[   12.522628] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   12.522675] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   12.522719] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   12.522770] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   12.522817] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[   12.522861] iwlwifi 0000:03:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
[   12.522989] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   12.550242] iwlwifi 0000:03:00.0: device EEPROM VER=0x11e, CALIB=0x4
[   12.550300] iwlwifi 0000:03:00.0: Device SKU: 0xF0
[   12.550339] iwlwifi 0000:03:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
[   12.550406] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   12.578444] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   30.708681] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   30.709069] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0
[   30.860998] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   30.865388] iwlwifi 0000:03:00.0: Radio type=0x0-0x2-0x0


This is the first time I notice this issue, so I don't think it's very
reproducible.




Thanks,
Bjørn
