Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40638 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3FLEEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 00:04:10 -0400
Received: by mail-ob0-f182.google.com with SMTP id va7so12603406obc.41
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 21:04:10 -0700 (PDT)
Date: Tue, 11 Jun 2013 23:04:06 -0500
From: Edward Seyler <epseyler@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Intel Centrino Wireless-N 2200 Tech Support
Message-ID: <20130612040406.GA8429@GregoriusMagnus.arch> (sfid-20130612_060414_670691_A3D2E385)
References: <20130611042801.GA217@FermiDesk>
 <CANUX_P0ddkfEY+hxir8=PGH1ocS5FQRFwvrm2otj3eTUkwJ+Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P0ddkfEY+hxir8=PGH1ocS5FQRFwvrm2otj3eTUkwJ+Gw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> This is really weird...
> Can you compile with CONFIG_IWLWIFI_DEBUG?
> I will then need a few debug prints.
> I recently changed this flow to speed up the fw loading process on
> platform that can afford a bit amount of DMA, but I just tested it
> (again) and it works even if there is not big DMA chunk available.



I compiled with CONFIG_IWLWIFI_DEBUG.  I also absent mindedly enabled CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE--please let me know if you do not want this.  I can provide other debugging output, but I am sending this now in case I cannot respond promptly.

# echo 0xFFFFFFFF > /sys/module/iwlwifi/parameters/debug
# dmesg | grep iwl


[   10.116748] iwlwifi 0000:03:00.0: irq 43 for MSI/MSI-X
[   10.234866] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
[   10.362940] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   10.362952] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   10.362957] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   10.362963] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   10.362967] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[   10.362974] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-N 2200 BGN, REV=0x104
[   10.363003] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[   10.377474] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[ 1180.920142] iwlwifi 0000:03:00.0: U iwlagn_mac_start enter
[ 1180.920152] iwlwifi 0000:03:00.0: I iwl_prep_station Add STA to driver ID 15: ff:ff:ff:ff:ff:ff
[ 1180.920158] iwlwifi 0000:03:00.0: I iwl_prep_station Add STA to driver ID 14: ff:ff:ff:ff:ff:ff
[ 1180.920163] iwlwifi 0000:03:00.0: U iwl_pcie_prepare_card_hw iwl_trans_prepare_card_hw enter
[ 1180.920171] iwlwifi 0000:03:00.0: U iwl_pcie_set_hw_ready hardware ready
[ 1180.920173] iwlwifi 0000:03:00.0: U iwl_enable_rfkill_int Enabling rfkill interrupt
[ 1180.920180] iwlwifi 0000:03:00.0: U iwl_pcie_apm_init Init card's basic functions
[ 1180.920196] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[ 1180.928171] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
[ 1180.929423] iwlwifi 0000:03:00.0: U iwl_enable_interrupts Enabling interrupts
[ 1180.929431] iwlwifi 0000:03:00.0: U iwl_pcie_load_section [0] uCode section being loaded...
[ 1185.926627] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[ 1185.926967] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[ 1185.927256] iwlwifi 0000:03:00.0: U iwl_disable_interrupts Disabled interrupts
[ 1185.927442] iwlwifi 0000:03:00.0: U iwl_pcie_apm_stop Stop card, put in low power state
[ 1185.927449] iwlwifi 0000:03:00.0: U iwl_pcie_apm_stop_master stop master
[ 1185.927465] iwlwifi 0000:03:00.0: U iwl_disable_interrupts Disabled interrupts
[ 1185.927467] iwlwifi 0000:03:00.0: U iwl_enable_rfkill_int Enabling rfkill interrupt
[ 1185.927470] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
[ 1185.927712] iwlwifi 0000:03:00.0: U iwl_down iwlwifi is going down
[ 1185.927715] iwlwifi 0000:03:00.0: U iwl_scan_cancel_timeout Scan cancel timeout
[ 1185.927718] iwlwifi 0000:03:00.0: U iwl_do_scan_abort Not performing scan to abort
[ 1185.927721] iwlwifi 0000:03:00.0: U iwl_clear_ucode_stations Clearing ucode stations in driver
[ 1185.927725] iwlwifi 0000:03:00.0: U iwl_clear_ucode_stations No active stations found to be cleared
[ 1185.927733] iwlwifi 0000:03:00.0: U iwl_disable_interrupts Disabled interrupts
[ 1185.927738] iwlwifi 0000:03:00.0: U iwl_pcie_apm_stop Stop card, put in low power state
[ 1185.927744] iwlwifi 0000:03:00.0: U iwl_pcie_apm_stop_master stop master
[ 1185.927759] iwlwifi 0000:03:00.0: U iwl_disable_interrupts Disabled interrupts
[ 1185.927761] iwlwifi 0000:03:00.0: U iwl_enable_rfkill_int Enabling rfkill interrupt
[ 1185.927763] iwlwifi 0000:03:00.0: Unable to initialize device.



