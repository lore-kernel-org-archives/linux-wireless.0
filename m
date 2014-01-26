Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:44706 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaAZFzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 00:55:16 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Petko Manolov <petkan@nucleusys.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Date: Sun, 26 Jan 2014 05:55:05 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558E6221@ALA-MBA.corp.ad.wrs.com> (sfid-20140126_065522_465940_EF572AE0)
References: <DE84205DFC6FCF4A904A2F75D822FABA558E6210@ALA-MBA.corp.ad.wrs.com>
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558E6210@ALA-MBA.corp.ad.wrs.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several hours ago, My laptop suddenly disconnected from the wifi. When I tried to connect again, I was surprised that my wlan0 disappeared from `iwconfig`. I wasn't updating the system at that time, and restarting the system doesn't work either. I found my wifi driver iwlwifi threw many errors in the log(errors.log):

Jan 10 20:38:27 localhost kernel: [113149.852944] iwlwifi 0000:01:00.0: Error sending REPLY_SCAN_ABORT_CMD: time out after 2000ms.
Jan 10 20:38:27 localhost kernel: [113149.852955] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 38 write_ptr 39
Jan 10 20:38:29 localhost kernel: [113152.546430] iwlwifi 0000:01:00.0: Error sending REPLY_SCAN_ABORT_CMD: time out after 2000ms.
Jan 10 20:38:29 localhost kernel: [113152.546436] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 31 write_ptr 32
Jan 10 22:23:56 localhost kernel: [ 2457.512612] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Jan 10 22:23:58 localhost kernel: [ 2459.513621] iwlwifi 0000:01:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
Jan 10 22:23:58 localhost kernel: [ 2459.513633] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 59
Jan 10 22:24:00 localhost kernel: [ 2461.511172] iwlwifi 0000:01:00.0: Error sending REPLY_QOS_PARAM: time out after 2000ms.
Jan 10 22:24:00 localhost kernel: [ 2461.511184] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 60
Jan 10 22:24:00 localhost kernel: [ 2461.511190] iwlwifi 0000:01:00.0: Failed to update QoS
Jan 10 22:24:02 localhost kernel: [ 2463.508766] iwlwifi 0000:01:00.0: Error sending REPLY_RXON: time out after 2000ms.
Jan 10 22:24:02 localhost kernel: [ 2463.508778] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 61
Jan 10 22:24:02 localhost kernel: [ 2463.508784] iwlwifi 0000:01:00.0: Error clearing ASSOC_MSK on BSS (-110)
Jan 10 22:24:04 localhost kernel: [ 2465.509680] iwlwifi 0000:01:00.0: Error sending REPLY_ADD_STA: time out after 2000ms.
Jan 10 22:24:04 localhost kernel: [ 2465.509692] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 62
Jan 10 22:24:06 localhost kernel: [ 2467.507347] iwlwifi 0000:01:00.0: Error sending REPLY_RXON: time out after 2000ms.
Jan 10 22:24:06 localhost kernel: [ 2467.507358] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 63
Jan 10 22:24:06 localhost kernel: [ 2467.507365] iwlwifi 0000:01:00.0: Error clearing ASSOC_MSK on BSS (-110)
Jan 10 22:24:08 localhost kernel: [ 2469.511585] iwlwifi 0000:01:00.0: fail to flush all tx fifo queues
Jan 10 22:24:10 localhost kernel: [ 2471.509223] iwlwifi 0000:01:00.0: Error sending POWER_TABLE_CMD: time out after 2000ms.
Jan 10 22:24:10 localhost kernel: [ 2471.509235] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 64
Jan 10 22:24:10 localhost kernel: [ 2471.509243] iwlwifi 0000:01:00.0: set power fail, ret = -110
Jan 10 22:24:12 localhost kernel: [ 2473.506820] iwlwifi 0000:01:00.0: Error sending REPLY_RXON: time out after 2000ms.
Jan 10 22:24:12 localhost kernel: [ 2473.506832] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 65
Jan 10 22:24:12 localhost kernel: [ 2473.506839] iwlwifi 0000:01:00.0: Error clearing ASSOC_MSK on BSS (-110)
Jan 10 22:24:14 localhost kernel: [ 2475.504496] iwlwifi 0000:01:00.0: Error sending REPLY_RXON: time out after 2000ms.
Jan 10 22:24:14 localhost kernel: [ 2475.504507] iwlwifi 0000:01:00.0: Current CMD queue read_ptr 58 write_ptr 66
Jan 10 22:24:14 localhost kernel: [ 2475.504514] iwlwifi 0000:01:00.0: Error clearing ASSOC_MSK on BSS (-110)
Jan 10 22:24:20 localhost kernel: [ 2481.523820] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:24:20 localhost kernel: [ 2481.523827] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:24:20 localhost kernel: [ 2481.868576] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:24:26 localhost kernel: [ 2487.533336] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:24:26 localhost kernel: [ 2487.533344] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:24:26 localhost kernel: [ 2487.878047] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:24:32 localhost kernel: [ 2493.789143] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:24:32 localhost kernel: [ 2493.789149] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:24:32 localhost kernel: [ 2494.134314] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:24:38 localhost kernel: [ 2499.815317] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:24:38 localhost kernel: [ 2499.815329] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:24:38 localhost kernel: [ 2500.160083] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:24:44 localhost kernel: [ 2505.848075] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:24:44 localhost kernel: [ 2505.848084] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:24:45 localhost kernel: [ 2506.196373] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:24:51 localhost kernel: [ 2511.880875] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:24:51 localhost kernel: [ 2511.880890] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:24:51 localhost kernel: [ 2512.231387] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:25:18 localhost kernel: [ 2539.621011] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:25:18 localhost kernel: [ 2539.621026] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:25:18 localhost kernel: [ 2539.966357] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:25:52 localhost kernel: [ 2573.001004] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:25:52 localhost kernel: [ 2573.001019] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:25:52 localhost kernel: [ 2573.351802] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:25:58 localhost kernel: [ 2579.037156] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:25:58 localhost kernel: [ 2579.037171] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:25:58 localhost kernel: [ 2579.387332] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:26:06 localhost kernel: [ 2587.550298] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:26:06 localhost kernel: [ 2587.550312] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:26:06 localhost kernel: [ 2587.900805] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:26:31 localhost kernel: [ 2611.877855] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:26:31 localhost kernel: [ 2611.877871] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:26:31 localhost kernel: [ 2612.228728] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:26:54 localhost kernel: [ 2635.699298] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:26:54 localhost kernel: [ 2635.699313] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:26:55 localhost kernel: [ 2636.045143] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:27:01 localhost kernel: [ 2641.788744] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:27:01 localhost kernel: [ 2641.788759] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:27:01 localhost kernel: [ 2642.139609] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:27:07 localhost kernel: [ 2647.804846] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:27:07 localhost kernel: [ 2647.804862] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:27:07 localhost kernel: [ 2648.155079] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:29:29 localhost kernel: [ 2789.844711] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:29:29 localhost kernel: [ 2789.844718] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:29:29 localhost kernel: [ 2790.195159] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:30:45 localhost kernel: [ 2866.030330] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:30:45 localhost kernel: [ 2866.030345] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:30:45 localhost kernel: [ 2866.380744] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:30:51 localhost kernel: [ 2872.079648] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:30:51 localhost kernel: [ 2872.079662] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:30:51 localhost kernel: [ 2872.430819] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:30:57 localhost kernel: [ 2878.112402] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:30:57 localhost kernel: [ 2878.112418] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:30:57 localhost kernel: [ 2878.463280] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:06 localhost kernel: [ 2886.978539] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:06 localhost kernel: [ 2886.978554] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:06 localhost kernel: [ 2887.328609] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:12 localhost kernel: [ 2893.007995] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:12 localhost kernel: [ 2893.008009] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:12 localhost kernel: [ 2893.358563] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:18 localhost kernel: [ 2899.253862] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:18 localhost kernel: [ 2899.253876] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:18 localhost kernel: [ 2899.604209] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:25 localhost kernel: [ 2905.493049] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:25 localhost kernel: [ 2905.493064] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:25 localhost kernel: [ 2905.843638] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:37 localhost kernel: [ 2917.871538] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:37 localhost kernel: [ 2917.871559] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:37 localhost kernel: [ 2918.222060] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:43 localhost kernel: [ 2923.901021] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:43 localhost kernel: [ 2923.901037] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:43 localhost kernel: [ 2924.251968] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:52 localhost kernel: [ 2932.447455] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:52 localhost kernel: [ 2932.447469] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:52 localhost kernel: [ 2932.799165] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:31:58 localhost kernel: [ 2938.483548] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:31:58 localhost kernel: [ 2938.483563] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:31:58 localhost kernel: [ 2938.833953] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:32:43 localhost kernel: [ 2983.529581] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:32:43 localhost kernel: [ 2983.529595] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:32:43 localhost kernel: [ 2983.880403] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:32:49 localhost kernel: [ 2989.569025] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:32:49 localhost kernel: [ 2989.569039] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:32:49 localhost kernel: [ 2989.919984] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:33:20 localhost kernel: [ 3020.332175] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:33:20 localhost kernel: [ 3020.332194] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:33:20 localhost kernel: [ 3020.683036] iwlwifi 0000:01:00.0: Unable to initialize device.
Jan 10 22:33:26 localhost kernel: [ 3026.361601] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
Jan 10 22:33:26 localhost kernel: [ 3026.361620] iwlwifi 0000:01:00.0: Failed to start RT ucode: -110
Jan 10 22:33:26 localhost kernel: [ 3026.712424] iwlwifi 0000:01:00.0: Unable to initialize device.

so, what should I do?


Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Liu, Bopeng
Sent: Sunday, January 26, 2014 1:52 PM
To: Emmanuel Grumbach; Petko Manolov; Grumbach, Emmanuel; linux-wireless@vger.kernel.org; remove
Cc: linux-wireless@vger.kernel.org; ilw@linux.intel.com; Berg, Johannes
Subject: iwlwifi 0000:01:00.0: fail to flush all tx fifo queues

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