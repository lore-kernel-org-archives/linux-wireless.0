Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:35263 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851Ab3GCOEb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 10:04:31 -0400
Message-ID: <51D42CE9.9010003@inov.pt> (sfid-20130703_160447_990135_34B58F23)
Date: Wed, 03 Jul 2013 14:53:45 +0100
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WL1273: Firmware initialization problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm integrating a WL1273 based module (Jorjin's WG7350) in a S3C2416 based 
platform running kernel 3.9.8.
I've managed to configure my kernel platform data and set the wl127x calibration 
file and I'm now able to set the wlan0 interface up, what is shown in the 
following log;

[root ~]$ modprobe wlcore debug_level=0x40004
[root ~]$ modprobe wlcore_sdio
[   53.670000] wake enabled for irq 54
[   53.905000] wlcore: PG Ver major = 1 minor = 0, MAC is not present
[   53.905000] wlcore: chip id 0x4030111 (1271 PG20)
[   53.910000] wlcore: base address: oui deadbe nic ef0000
[   54.085000] wlcore: loaded
[root ~]$ ifconfig wlan0 up
[   66.160000] wlcore: booting firmware ti-connectivity/wl127x-fw-5-sr.bin
[   66.315000] wlcore: pause1 0xf05
[   66.315000] wlcore: clk2 0x0
[   66.315000] wlcore: soft reset bootdata 0x0
[   66.325000] wlcore: nvs burst write 0x30546c: 0xbeef0000
[   66.325000] wlcore: nvs burst write 0x305470: 0xdead
[   66.330000] wlcore: ACX_EEPROMLESS_IND_REG
[   66.335000] wlcore: chip id 0x4030111
[   66.335000] wlcore: firmware chunks to be uploaded: 6
[   66.340000] wlcore: chunk 5 addr 0x0 len 196544
[   66.350000] wlcore: starting firmware upload
[   66.350000] wlcore: fw_data_len 196544 chunk_size 16384
[   66.360000] wlcore: uploading fw chunk 0xc4b8700c to 0x0
[   66.365000] wlcore: uploading fw chunk 0xc4b8b00c to 0x4000
[   66.370000] wlcore: uploading fw chunk 0xc4b8f00c to 0x8000
[   66.375000] wlcore: uploading fw chunk 0xc4b9300c to 0xc000
[   66.380000] wlcore: uploading fw chunk 0xc4b9700c to 0x10000
[   66.385000] wlcore: uploading fw chunk 0xc4b9b00c to 0x14000
[   66.390000] wlcore: uploading fw chunk 0xc4b9f00c to 0x18000
[   66.400000] wlcore: uploading fw chunk 0xc4ba300c to 0x1c000
[   66.405000] wlcore: uploading fw chunk 0xc4ba700c to 0x20000
[   66.405000] wlcore: uploading fw chunk 0xc4bab00c to 0x24000
[   66.415000] wlcore: uploading fw chunk 0xc4baf00c to 0x28000
[   66.420000] wlcore: uploading fw last chunk (16320 B) 0xc4bb300c to 0x2c000
[   66.425000] wlcore: chunk 4 addr 0x20000000 len 41944
[   66.430000] wlcore: starting firmware upload
[   66.435000] wlcore: fw_data_len 41944 chunk_size 16384
[   66.440000] wlcore: uploading fw chunk 0xc4bb6fd4 to 0x20000000
[   66.450000] wlcore: uploading fw chunk 0xc4bbafd4 to 0x20004000
[   66.450000] wlcore: uploading fw last chunk (9176 B) 0xc4bbefd4 to 0x20008000
[   66.460000] wlcore: chunk 3 addr 0x40000 len 448
[   66.460000] wlcore: starting firmware upload
[   66.465000] wlcore: fw_data_len 448 chunk_size 16384
[   66.475000] wlcore: uploading fw last chunk (448 B) 0xc4bc13b4 to 0x40000
[   66.480000] wlcore: chunk 2 addr 0x40be0 len 29412
[   66.485000] wlcore: starting firmware upload
[   66.485000] wlcore: fw_data_len 29412 chunk_size 16384
[   66.500000] wlcore: uploading fw chunk 0xc4bc157c to 0x40be0
[   66.505000] wlcore: uploading fw last chunk (13028 B) 0xc4bc557c to 0x44be0
[   66.510000] wlcore: chunk 1 addr 0x312000 len 8092
[   66.515000] wlcore: starting firmware upload
[   66.520000] wlcore: fw_data_len 8092 chunk_size 16384
[   66.525000] wlcore: uploading fw last chunk (8092 B) 0xc4bc8868 to 0x312000
[   66.530000] wlcore: chunk 0 addr 0x316000 len 3784
[   66.535000] wlcore: starting firmware upload
[   66.540000] wlcore: fw_data_len 3784 chunk_size 16384
[   66.545000] wlcore: uploading fw last chunk (3784 B) 0xc4bca80c to 0x316000
[   66.555000] wlcore: chip id after firmware boot: 0x4030111
[   66.620000] wlcore: rx start cmd channel 1
[   66.620000] wlcore: tx start cmd channel 1
[   66.630000] wlcore: firmware booted (Rev 6.3.10.0.133)

The problem that I have is if I try to restart the wlan0 interface the wl127x 
firmware seems not to reinitialize, as you can see here;

[root ~]$ ifconfig wlan0 down
[   80.765000] wlcore: down
[root ~]$ ifconfig wlan0 up
[   87.585000] wlcore: pause1 0x40f75
[   87.585000] wlcore: clk2 0x80316a38
[   87.590000] wlcore: soft reset bootdata 0x0
[   87.595000] wlcore: nvs burst write 0x30546c: 0xbeef0000
[   87.600000] wlcore: nvs burst write 0x305470: 0xdead
[   87.605000] wlcore: ACX_EEPROMLESS_IND_REG
[   87.605000] wlcore: chip id 0x4030111
[   87.615000] wlcore: firmware chunks to be uploaded: 6
[   87.615000] wlcore: chunk 5 addr 0x0 len 196544
[   87.620000] wlcore: starting firmware upload
[   87.625000] wlcore: fw_data_len 196544 chunk_size 16384
[   87.630000] wlcore: uploading fw chunk 0xc4b8700c to 0x0
[   87.640000] wlcore: uploading fw chunk 0xc4b8b00c to 0x4000
[   87.640000] wlcore: uploading fw chunk 0xc4b8f00c to 0x8000
[   87.650000] wlcore: uploading fw chunk 0xc4b9300c to 0xc000
[   87.655000] wlcore: uploading fw chunk 0xc4b9700c to 0x10000
[   87.660000] wlcore: uploading fw chunk 0xc4b9b00c to 0x14000
[   87.665000] wlcore: uploading fw chunk 0xc4b9f00c to 0x18000
[   87.670000] wlcore: uploading fw chunk 0xc4ba300c to 0x1c000
[   87.675000] wlcore: uploading fw chunk 0xc4ba700c to 0x20000
[   87.680000] wlcore: uploading fw chunk 0xc4bab00c to 0x24000
[   87.685000] wlcore: uploading fw chunk 0xc4baf00c to 0x28000
[   87.690000] wlcore: uploading fw last chunk (16320 B) 0xc4bb300c to 0x2c000
[   87.700000] wlcore: chunk 4 addr 0x20000000 len 41944
[   87.700000] wlcore: starting firmware upload
[   87.705000] wlcore: fw_data_len 41944 chunk_size 16384
[   87.715000] wlcore: uploading fw chunk 0xc4bb6fd4 to 0x20000000
[   87.720000] wlcore: uploading fw chunk 0xc4bbafd4 to 0x20004000
[   87.725000] wlcore: uploading fw last chunk (9176 B) 0xc4bbefd4 to 0x20008000
[   87.735000] wlcore: chunk 3 addr 0x40000 len 448
[   87.735000] wlcore: starting firmware upload
[   87.740000] wlcore: fw_data_len 448 chunk_size 16384
[   87.750000] wlcore: uploading fw last chunk (448 B) 0xc4bc13b4 to 0x40000
[   87.750000] wlcore: chunk 2 addr 0x40be0 len 29412
[   87.755000] wlcore: starting firmware upload
[   87.765000] wlcore: fw_data_len 29412 chunk_size 16384
[   87.765000] wlcore: uploading fw chunk 0xc4bc157c to 0x40be0
[   87.775000] wlcore: uploading fw last chunk (13028 B) 0xc4bc557c to 0x44be0
[   87.780000] wlcore: chunk 1 addr 0x312000 len 8092
[   87.780000] wlcore: starting firmware upload
[   87.790000] wlcore: fw_data_len 8092 chunk_size 16384
[   87.790000] wlcore: uploading fw last chunk (8092 B) 0xc4bc8868 to 0x312000
[   87.795000] wlcore: chunk 0 addr 0x316000 len 3784
[   87.800000] wlcore: starting firmware upload
[   87.800000] wlcore: fw_data_len 3784 chunk_size 16384
[   87.810000] wlcore: uploading fw last chunk (3784 B) 0xc4bca80c to 0x316000
[   87.815000] wlcore: chip id after firmware boot: 0x4030111
[   91.105000] wlcore: ERROR timeout waiting for the hardware to complete 
initialization
[   91.385000] wlcore: pause1 0x40f75
[   91.385000] wlcore: clk2 0x80316a38
[   91.390000] wlcore: soft reset bootdata 0x0
[   91.390000] wlcore: nvs burst write 0x30546c: 0xbeef0000
[   91.400000] wlcore: nvs burst write 0x305470: 0xdead
[   91.405000] wlcore: ACX_EEPROMLESS_IND_REG
[   91.405000] wlcore: chip id 0x4030111
[   91.415000] wlcore: firmware chunks to be uploaded: 6
[   91.415000] wlcore: chunk 5 addr 0x0 len 196544
[   91.420000] wlcore: starting firmware upload
[   91.425000] wlcore: fw_data_len 196544 chunk_size 16384
[   91.430000] wlcore: uploading fw chunk 0xc4b8700c to 0x0
[   91.435000] wlcore: uploading fw chunk 0xc4b8b00c to 0x4000
[   91.440000] wlcore: uploading fw chunk 0xc4b8f00c to 0x8000
[   91.450000] wlcore: uploading fw chunk 0xc4b9300c to 0xc000
[   91.455000] wlcore: uploading fw chunk 0xc4b9700c to 0x10000
[   91.460000] wlcore: uploading fw chunk 0xc4b9b00c to 0x14000
[   91.465000] wlcore: uploading fw chunk 0xc4b9f00c to 0x18000
[   91.470000] wlcore: uploading fw chunk 0xc4ba300c to 0x1c000
[   91.475000] wlcore: uploading fw chunk 0xc4ba700c to 0x20000
[   91.480000] wlcore: uploading fw chunk 0xc4bab00c to 0x24000
[   91.485000] wlcore: uploading fw chunk 0xc4baf00c to 0x28000
[   91.495000] wlcore: uploading fw last chunk (16320 B) 0xc4bb300c to 0x2c000
[   91.500000] wlcore: chunk 4 addr 0x20000000 len 41944
[   91.500000] wlcore: starting firmware upload
[   91.505000] wlcore: fw_data_len 41944 chunk_size 16384
[   91.515000] wlcore: uploading fw chunk 0xc4bb6fd4 to 0x20000000
[   91.525000] wlcore: uploading fw chunk 0xc4bbafd4 to 0x20004000
[   91.525000] wlcore: uploading fw last chunk (9176 B) 0xc4bbefd4 to 0x20008000
[   91.535000] wlcore: chunk 3 addr 0x40000 len 448
[   91.535000] wlcore: starting firmware upload
[   91.540000] wlcore: fw_data_len 448 chunk_size 16384
[   91.550000] wlcore: uploading fw last chunk (448 B) 0xc4bc13b4 to 0x40000
[   91.550000] wlcore: chunk 2 addr 0x40be0 len 29412
[   91.560000] wlcore: starting firmware upload
[   91.560000] wlcore: fw_data_len 29412 chunk_size 16384
[   91.575000] wlcore: uploading fw chunk 0xc4bc157c to 0x40be0
[   91.580000] wlcore: uploading fw last chunk (13028 B) 0xc4bc557c to 0x44be0
[   91.585000] wlcore: chunk 1 addr 0x312000 len 8092
[   91.590000] wlcore: starting firmware upload
[   91.595000] wlcore: fw_data_len 8092 chunk_size 16384
[   91.600000] wlcore: uploading fw last chunk (8092 B) 0xc4bc8868 to 0x312000
[   91.605000] wlcore: chunk 0 addr 0x316000 len 3784
[   91.610000] wlcore: starting firmware upload
[   91.615000] wlcore: fw_data_len 3784 chunk_size 16384
[   91.620000] wlcore: uploading fw last chunk (3784 B) 0xc4bca80c to 0x316000
[   91.630000] wlcore: chip id after firmware boot: 0x4030111
[   94.910000] wlcore: ERROR timeout waiting for the hardware to complete 
initialization
[   95.190000] wlcore: pause1 0x40f75
[   95.190000] wlcore: clk2 0x80316a38
[   95.195000] wlcore: soft reset bootdata 0x0
[   95.195000] wlcore: nvs burst write 0x30546c: 0xbeef0000
[   95.205000] wlcore: nvs burst write 0x305470: 0xdead
[   95.210000] wlcore: ACX_EEPROMLESS_IND_REG
[   95.210000] wlcore: chip id 0x4030111
[   95.220000] wlcore: firmware chunks to be uploaded: 6
[   95.220000] wlcore: chunk 5 addr 0x0 len 196544
[   95.225000] wlcore: starting firmware upload
[   95.235000] wlcore: fw_data_len 196544 chunk_size 16384
[   95.235000] wlcore: uploading fw chunk 0xc4b8700c to 0x0
[   95.245000] wlcore: uploading fw chunk 0xc4b8b00c to 0x4000
[   95.245000] wlcore: uploading fw chunk 0xc4b8f00c to 0x8000
[   95.255000] wlcore: uploading fw chunk 0xc4b9300c to 0xc000
[   95.260000] wlcore: uploading fw chunk 0xc4b9700c to 0x10000
[   95.265000] wlcore: uploading fw chunk 0xc4b9b00c to 0x14000
[   95.270000] wlcore: uploading fw chunk 0xc4b9f00c to 0x18000
[   95.275000] wlcore: uploading fw chunk 0xc4ba300c to 0x1c000
[   95.280000] wlcore: uploading fw chunk 0xc4ba700c to 0x20000
[   95.285000] wlcore: uploading fw chunk 0xc4bab00c to 0x24000
[   95.290000] wlcore: uploading fw chunk 0xc4baf00c to 0x28000
[   95.295000] wlcore: uploading fw last chunk (16320 B) 0xc4bb300c to 0x2c000
[   95.305000] wlcore: chunk 4 addr 0x20000000 len 41944
[   95.305000] wlcore: starting firmware upload
[   95.310000] wlcore: fw_data_len 41944 chunk_size 16384
[   95.320000] wlcore: uploading fw chunk 0xc4bb6fd4 to 0x20000000
[   95.325000] wlcore: uploading fw chunk 0xc4bbafd4 to 0x20004000
[   95.330000] wlcore: uploading fw last chunk (9176 B) 0xc4bbefd4 to 0x20008000
[   95.340000] wlcore: chunk 3 addr 0x40000 len 448
[   95.340000] wlcore: starting firmware upload
[   95.345000] wlcore: fw_data_len 448 chunk_size 16384
[   95.350000] wlcore: uploading fw last chunk (448 B) 0xc4bc13b4 to 0x40000
[   95.355000] wlcore: chunk 2 addr 0x40be0 len 29412
[   95.360000] wlcore: starting firmware upload
[   95.365000] wlcore: fw_data_len 29412 chunk_size 16384
[   95.375000] wlcore: uploading fw chunk 0xc4bc157c to 0x40be0
[   95.375000] wlcore: uploading fw last chunk (13028 B) 0xc4bc557c to 0x44be0
[   95.385000] wlcore: chunk 1 addr 0x312000 len 8092
[   95.385000] wlcore: starting firmware upload
[   95.390000] wlcore: fw_data_len 8092 chunk_size 16384
[   95.400000] wlcore: uploading fw last chunk (8092 B) 0xc4bc8868 to 0x312000
[   95.405000] wlcore: chunk 0 addr 0x316000 len 3784
[   95.405000] wlcore: starting firmware upload
[   95.410000] wlcore: fw_data_len 3784 chunk_size 16384
[   95.420000] wlcore: uploading fw last chunk (3784 B) 0xc4bca80c to 0x316000
[   95.430000] wlcore: chip id after firmware boot: 0x4030111
[   98.710000] wlcore: ERROR timeout waiting for the hardware to complete 
initialization
[   98.715000] wlcore: ERROR firmware boot failed despite 3 retries
ifconfig: SIOCSIFFLAGS: Input/output error


Even If I reboot my kernel and reload the modules the error persist! Only if I 
power down/up my board I can initialize the network interface again.

Any hints on what could be wrong?

Best regards,
José Gonçalves
