Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:44659 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaAZFwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 00:52:15 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Petko Manolov <petkan@nucleusys.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	remove <ilw@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Date: Sun, 26 Jan 2014 05:52:01 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558E6210@ALA-MBA.corp.ad.wrs.com> (sfid-20140126_065235_666047_3F164ED6)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,All:

Have you ever met such problem?

----
On hostap mode:

I use iperf3 to set up a client and server for testing the performance of wifi.

But, wlan0 often down and I can't ping successfully to server on client side.


The logs:

wifi_log# grep phy0 *
0.0.log:[   26.269709] Registered led device: phy0-led
0.0.log:[   26.295254] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
0.0.syslog.txt:Oct 16 17:35:04 WR-IntelligentDevice kernel: [   26.269709] Registered led device: phy0-led
0.0.syslog.txt:Oct 16 17:35:04 WR-IntelligentDevice kernel: [   26.295254] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
1:Oct 16 13:39:29 WR-IntelligentDevice kernel: [   74.209275] Registered led device: phy0-led
1:Oct 16 13:39:29 WR-IntelligentDevice kernel: [   74.233835] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
2:[   74.209275] Registered led device: phy0-led
2:[   74.233835] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
log1:[  187.283480] Registered led device: phy0-led
log1:[  187.340005] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
log1:[  937.014207] cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on phy0
root@pek-bliu2-d3:~/Desktop/wifi_log# 





root@pek-bliu2-d3:~/Desktop/wifi_log# grep fail *
0.0.log:[    1.127111] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
0.0.log:[    2.298207] button: probe of LNXPWRBN:00 failed with error -22
0.0.log:[    2.754792] lpc_sch: probe of 0000:00:1f.0 failed with error -16
0.0.log:[    4.288308] i2c_eg20t: probe of 0000:05:0c.2 failed with error -16
0.0.log:[  360.510445] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.log:[ 1246.718648] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.log:[ 1592.318580] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.log:[ 1760.430714] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.log:[ 2515.854822] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.log:[ 2561.998692] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.log:[ 2586.030725] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.syslog.txt:Oct 16 17:35:04 WR-IntelligentDevice kernel: [    1.127111] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
0.0.syslog.txt:Oct 16 17:35:04 WR-IntelligentDevice kernel: [    2.298207] button: probe of LNXPWRBN:00 failed with error -22
0.0.syslog.txt:Oct 16 17:35:04 WR-IntelligentDevice kernel: [    2.754792] lpc_sch: probe of 0000:00:1f.0 failed with error -16
0.0.syslog.txt:Oct 16 17:35:04 WR-IntelligentDevice kernel: [    4.288308] i2c_eg20t: probe of 0000:05:0c.2 failed with error -16
0.0.syslog.txt:Oct 16 17:39:41 WR-IntelligentDevice kernel: [  360.510445] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.syslog.txt:Oct 16 17:54:27 WR-IntelligentDevice kernel: [ 1246.718648] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.syslog.txt:Jan 17 07:11:09 WR-IntelligentDevice kernel: [ 1592.318580] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.syslog.txt:Jan 17 07:13:57 WR-IntelligentDevice kernel: [ 1760.430714] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.syslog.txt:Jan 17 07:26:32 WR-IntelligentDevice kernel: [ 2515.854822] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.syslog.txt:Jan 17 07:27:19 WR-IntelligentDevice kernel: [ 2561.998692] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
0.0.syslog.txt:Jan 17 07:27:43 WR-IntelligentDevice kernel: [ 2586.030725] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Oct 16 13:39:29 WR-IntelligentDevice kernel: [    1.127139] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
1:Oct 16 13:39:29 WR-IntelligentDevice kernel: [    2.252334] button: probe of LNXPWRBN:00 failed with error -22
1:Oct 16 13:39:29 WR-IntelligentDevice kernel: [    2.714659] lpc_sch: probe of 0000:00:1f.0 failed with error -16
1:Oct 16 13:39:29 WR-IntelligentDevice kernel: [    4.248330] i2c_eg20t: probe of 0000:05:0c.2 failed with error -16
1:Jan 17 02:56:10 WR-IntelligentDevice kernel: [  476.038463] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 03:08:23 WR-IntelligentDevice kernel: [ 1209.414518] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 03:11:58 WR-IntelligentDevice kernel: [ 1424.182555] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 03:12:09 WR-IntelligentDevice kernel: [ 1435.782677] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 03:23:01 WR-IntelligentDevice kernel: [ 2087.318658] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 03:53:10 WR-IntelligentDevice kernel: [ 3896.774891] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 03:56:43 WR-IntelligentDevice kernel: [ 4109.574897] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 03:59:47 WR-IntelligentDevice kernel: [ 4293.270915] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 04:12:57 WR-IntelligentDevice kernel: [ 5082.983133] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 04:20:13 WR-IntelligentDevice kernel: [ 5519.207071] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 04:45:20 WR-IntelligentDevice kernel: [ 7026.279286] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 05:06:10 WR-IntelligentDevice kernel: [ 8276.359433] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 05:09:14 WR-IntelligentDevice kernel: [ 8460.487560] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 05:16:29 WR-IntelligentDevice kernel: [ 8895.543505] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
1:Jan 17 05:18:25 WR-IntelligentDevice kernel: [ 9011.144097] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
1:Jan 17 05:18:30 WR-IntelligentDevice kernel: [ 9016.340103] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
1:Jan 17 05:22:45 WR-IntelligentDevice kernel: [ 9270.976150] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
1:Jan 17 05:22:50 WR-IntelligentDevice kernel: [ 9276.296190] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
1:Jan 17 05:22:58 WR-IntelligentDevice kernel: [ 9284.452175] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
1:Jan 17 05:23:15 WR-IntelligentDevice kernel: [ 9301.047675] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[    1.127139] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
2:[    2.252334] button: probe of LNXPWRBN:00 failed with error -22
2:[    2.714659] lpc_sch: probe of 0000:00:1f.0 failed with error -16
2:[    4.248330] i2c_eg20t: probe of 0000:05:0c.2 failed with error -16
2:[  476.038463] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 1209.414518] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 1424.182555] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 1435.782677] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 2087.318658] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 3896.774891] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 4109.574897] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 4293.270915] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 5082.983133] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 5519.207071] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 7026.279286] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 8276.359433] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 8460.487560] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 8895.543505] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
2:[ 9011.144097] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
2:[ 9016.340103] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
2:[ 9270.976150] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
2:[ 9276.296190] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
2:[ 9284.452175] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
2:[ 9301.047675] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
log1:[    1.123103] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
log1:[    2.252346] button: probe of LNXPWRBN:00 failed with error -22
log1:[    2.714689] lpc_sch: probe of 0000:00:1f.0 failed with error -16
log1:[    4.248330] i2c_eg20t: probe of 0000:05:0c.2 failed with error -16
log1:[ 1074.870540] cdc_acm 1-2:1.1: acm_ctrl_irq - usb_submit_urb failed: -1
root@pek-bliu2-d3:~/Desktop/wifi_log# ^C
root@pek-bliu2-d3:~/Desktop/wifi_log# 
