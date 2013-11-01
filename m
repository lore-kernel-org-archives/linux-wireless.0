Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49328 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3KAGWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 02:22:30 -0400
Received: by mail-ie0-f178.google.com with SMTP id x13so6724609ief.37
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 23:22:30 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 Nov 2013 14:22:30 +0800
Message-ID: <CAA+hA=TSonWMWm9gf+n4T9+HxWT=pvJG9jnkdoUyZUNjPpnJfg@mail.gmail.com> (sfid-20131101_072235_488688_310C987E)
Subject: brcmfmac driver does not work with a BCM4335 WiFi module
From: Dong Aisheng <dongas86@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: frankyl@broadcom.com, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi ALL,

I'm verifying BCM4335 WiFi module on i.MX6SL EVK board.
The kernel i ran is latest from:
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git

The firmware is used is from:
git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

NVRAM file is got from the vendor which should work for the module.

But i ran into the following issues, hope somebody can give me some hints.

First, i met error when module is auto loaded, but seems the driver is
still loaded successfully since i found the new WiFi interface with
ifconfig.
But it can not work after run rfkill unblock wlan and a lot error
messages comes out.

I'm wondering if this driver can support bcm4335 well, can anybody
provide some help?

Regards
Dong Aisheng

Below is the log FYI.

root@imx6slevk:~# mmc0: queuing unknown CIS tuple 0x91 (3 bytes)
mmc0: new high speed SDIO card at address 0001
brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
brcmfmac: brcmf_sdioh_request_word: Failed to read word, Err: 0xffffffac
brcmfmac: brcmf_sdio_regrw_helper: failed with -84
brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength
init done for chip 4335 rev 1 pmurev 18
brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Mar 24 2013
20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
brcmfmac: brcmf_fil_cmd_data: Failed err=-23

root@imx6slevk:~#
root@imx6slevk:~# ifconfig -a
eth0      Link encap:Ethernet  HWaddr 00:04:9F:02:76:E5
          inet addr:10.192.242.69  Bcast:10.192.242.255  Mask:255.255.255.0
          inet6 addr: fe80::204:9fff:fe02:76e5/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:20301 errors:0 dropped:1 overruns:0 frame:0
          TX packets:16888 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:22233761 (21.2 MiB)  TX bytes:2373414 (2.2 MiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:34 errors:0 dropped:0 overruns:0 frame:0
          TX packets:34 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:2340 (2.2 KiB)  TX bytes:2340 (2.2 KiB)

sit0      Link encap:IPv6-in-IPv4
          NOARP  MTU:1480  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr 00:90:4C:C5:12:38
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

root@imx6slevk:~#
root@imx6slevk:~# rfkill list
0: phy0: wlan
        Soft blocked: yes
        Hard blocked: no

root@imx6slevk:~# rfkill unblock wlan
root@imx6slevk:~# brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
brcmfmac: brcmf_add_if: ignore IF event
brcmfmac: brcmf_fil_cmd_data: Failed err=-110
brcmfmac: brcmf_fil_cmd_data: Failed err=-23
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to read byte
F1:@0x1001f=ff, Err: -110
brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
brcmfmac: brcmf_fil_cmd_data: Failed err=-110
brcmfmac: brcmf_set_mpc: fail to set mpc
brcmfmac: brcmf_escan_timeout: timer expired
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdioh_request_byte: Failed to write byte
F1:@0x1001f=01, Err: -110
brcmfmac: brcmf_sdbrcm_bus_rxctl: resumed on timeout
brcmfmac: brcmf_fil_cmd_data: Failed err=-110
brcmfmac: brcmf_set_mpc: fail to set mpc
............

The following detailed Log for drver probe, if you also need the full
log after run rfkill please let me know.

[   36.555580] brcmfmac: brcmf_sdbrcm_probe Enter
[   36.564293] brcmfmac: F1 signature read @0x18000000=0x16214335
[   36.564425] brcmfmac: brcmf_sdio_chip_attach Enter
[   36.564973] brcmfmac: brcmf_sdio_chip_recognition chipid=0x4335 chiprev=1
[   36.565163] brcmfmac: brcmf_sdio_chip_buscoresetup ccrev=43,
pmurev=18, buscore rev/type=15/0x829
[   36.566410] brcmfmac: brcmf_sdioh_request_word: Failed to read
word, Err: 0xffffffac
[   36.594407] brcmfmac: brcmf_sdioh_request_word: Failed to read
word, Err: 0xffffffac
[   36.621092] brcmfmac: brcmf_sdioh_request_word: Failed to read
word, Err: 0xffffffac
[   36.627684] brcmfmac: brcmf_sdio_regrw_helper: failed with -84
[   36.638085] brcmfmac: brcmf_sdbrcm_kso_init Enter
[   36.638167] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO
Drive strength init done for chip 4335 rev 1 pmurev 18
[   36.648862] brcmfmac: brcmf_attach Enter
[   36.648947] brcmfmac: brcmf_sdbrcm_probe_malloc Enter
[   36.648965] brcmfmac: brcmf_sdbrcm_probe_init Enter
[   36.649174] brcmfmac: brcmf_sdbrcm_probe completed!!
[   36.649190] brcmfmac: brcmf_bus_start
[   36.649201] brcmfmac: brcmf_sdbrcm_bus_init Enter
[   36.650399] brcmfmac: brcmf_sdbrcm_download_code_file Enter
[   37.065998] brcmfmac: brcmf_sdio_chip_verifynvram Compare NVRAM dl
& ul; size=2216
[   37.067114] brcmfmac: brcmf_sdio_chip_writenvram RAM size: 786432
[   37.067137] brcmfmac: brcmf_sdio_chip_writenvram nvram is placed at
2357076, size 2216, token=0xfdd5022a
[   37.226519] brcmfmac: brcmf_sdbrcm_bus_init enable 0x06, ready 0x06
[   37.226674] brcmfmac: brcmf_sdbrcm_sr_capable Enter
[   37.226845] brcmfmac: brcmf_sdbrcm_sr_init Enter
[   37.227026] brcmfmac: brcmf_sdbrcm_sr_init SR enabled
[   37.227368] brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
[   37.227383] brcmfmac: brcmf_add_if allocate netdev interface
[   37.227408] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.227419] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.227548] brcmfmac: brcmf_add_if  ==== pid:11, if:wlan%d
(00:00:00:00:00:00) created ===
[   37.227567] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.227675] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.227688] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.230910] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.231124] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.231139] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.231337] brcmfmac: brcmf_sdbrcm_dpc Dongle reports CHIPACTIVE
[   37.231350] brcmfmac: brcmf_sdio_readframes Enter
[   37.231550] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.231870] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.231883] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.232082] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.232097] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.232224] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.246569] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.246587] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.246807] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.247031] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.247047] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.247059] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.250219] brcmfmac: brcmf_sdio_readframes Enter
[   37.250346] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.250549] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.250606] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.250730] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.266635] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.266651] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.266869] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.267097] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.267112] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.267123] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.270283] brcmfmac: brcmf_sdio_readframes Enter
[   37.270410] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.270709] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
wl0: Mar 24 2013 20:36:01 version 6.30.171.24.20 (B0 Station/P2P)
[   37.282106] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.282125] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.282281] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.296548] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.296564] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.296775] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.297000] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.297015] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.297025] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.300190] brcmfmac: brcmf_sdio_readframes Enter
[   37.300317] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.300523] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.300538] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.300657] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.316546] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.316562] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.316767] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.316989] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.317005] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.317015] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.320178] brcmfmac: brcmf_sdio_readframes Enter
[   37.320302] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.320506] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.320522] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.320644] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.336555] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.336571] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.336782] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.337005] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.337020] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.337031] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.340209] brcmfmac: brcmf_sdio_readframes Enter
[   37.340334] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.340542] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.340558] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.340680] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.356551] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.356568] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.356781] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.357012] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.357027] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.357037] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.360196] brcmfmac: brcmf_sdio_readframes Enter
[   37.360323] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.360524] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.360539] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.360659] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.376550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.376567] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.376772] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.376995] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.377012] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.377021] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.380178] brcmfmac: brcmf_sdio_readframes Enter
[   37.380306] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.380506] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.380522] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.380645] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.396550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.396568] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.396774] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.397002] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.397018] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.397029] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.400187] brcmfmac: brcmf_sdio_readframes Enter
[   37.400316] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.400533] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.400549] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.400674] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.416549] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.416566] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.416774] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.416998] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.417015] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.417026] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.420187] brcmfmac: brcmf_sdio_readframes Enter
[   37.420310] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.420617] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.420633] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.420753] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.436550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.436566] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.436777] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.437003] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.437018] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.437028] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.440189] brcmfmac: brcmf_sdio_readframes Enter
[   37.440311] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.440518] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.440533] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.440654] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.456547] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.456563] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.456773] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.456999] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.457015] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.457025] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.460185] brcmfmac: brcmf_sdio_readframes Enter
[   37.460312] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.460518] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.460534] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.460651] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.466742] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.466953] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.466967] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.466981] brcmfmac: brcmf_sdio_readframes Enter
[   37.467102] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.469141] brcmfmac: brcmf_fweh_register event handler registered
for FIFO_CREDIT_MAP
[   37.469161] brcmfmac: brcmf_fweh_register event handler registered
for BCMC_CREDIT_SUPPORT
[   37.469178] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.469193] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.469334] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.486546] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.486563] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.486778] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.487004] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.487020] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.487031] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.490190] brcmfmac: brcmf_sdio_readframes Enter
[   37.490316] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.490525] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.490542] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.490661] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.506550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.506568] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.506781] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.507008] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.507024] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.507035] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.510194] brcmfmac: brcmf_sdio_readframes Enter
[   37.510318] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.510507] brcmfmac: brcmf_fil_cmd_data: Failed err=-23
[   37.514539] brcmfmac: brcmf_fws_init enabling AMPDU host-reorder failed
[   37.514573] brcmfmac: brcmf_fws_macdesc_init enter: desc bec567f0
ea=  (null), ifidx=0
[   37.514626] brcmfmac: brcmf_fws_init enabled bdcv2 tlv signaling [1]
[   37.514644] brcmfmac: brcmf_fws_macdesc_init enter: desc bec55030
ea=00:90:4c:c5:12:38, ifidx=0
[   37.514658] brcmfmac: brcmf_fws_add_interface added MACIF:0
[   37.514796] brcmfmac: brcmf_setup_wiphy Registering custom regulatory
[   37.522518] brcmfmac: brcmf_alloc_vif allocating virtual interface
(size=2332)
[   37.522550] brcmfmac: brcmf_fweh_register event handler registered for LINK
[   37.522563] brcmfmac: brcmf_fweh_register event handler registered
for DEAUTH_IND
[   37.522574] brcmfmac: brcmf_fweh_register event handler registered for DEAUTH
[   37.522584] brcmfmac: brcmf_fweh_register event handler registered
for DISASSOC_IND
[   37.522593] brcmfmac: brcmf_fweh_register event handler registered
for ASSOC_IND
[   37.522603] brcmfmac: brcmf_fweh_register event handler registered
for REASSOC_IND
[   37.522613] brcmfmac: brcmf_fweh_register event handler registered for ROAM
[   37.522622] brcmfmac: brcmf_fweh_register event handler registered
for MIC_ERROR
[   37.522633] brcmfmac: brcmf_fweh_register event handler registered
for SET_SSID
[   37.522644] brcmfmac: brcmf_fweh_register event handler registered
for PFN_NET_FOUND
[   37.522655] brcmfmac: brcmf_fweh_register event handler registered for IF
[   37.522667] brcmfmac: brcmf_fweh_register event handler registered
for P2P_PROBEREQ_MSG
[   37.522677] brcmfmac: brcmf_fweh_register event handler registered
for P2P_DISC_LISTEN_COMPLETE
[   37.522688] brcmfmac: brcmf_fweh_register event handler registered
for ACTION_FRAME_RX
[   37.522699] brcmfmac: brcmf_fweh_register event handler registered
for ACTION_FRAME_COMPLETE
[   37.522710] brcmfmac: brcmf_fweh_register event handler registered
for ACTION_FRAME_OFF_CHAN_COMPLETE
[   37.522720] brcmfmac: brcmf_fweh_register event handler registered
for ESCAN_RESULT
[   37.522732] brcmfmac: brcmf_btcoex_attach enter
[   37.523262] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.523284] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.523429] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.536624] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.536644] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.536879] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.537111] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.537126] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.537137] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.540301] brcmfmac: brcmf_sdio_readframes Enter
[   37.540434] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.540656] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.540672] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.540796] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.556688] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.556706] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.556927] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.557152] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.557167] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.557178] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.560348] brcmfmac: brcmf_sdio_readframes Enter
[   37.560476] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.560705] brcmfmac: brcmf_sdbrcm_bus_txctl Enter
[   37.560721] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.560846] brcmfmac: brcmf_sdbrcm_bus_rxctl Enter
[   37.576550] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.576567] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.576777] brcmfmac: brcmf_sdbrcm_isr Enter
[   37.577001] brcmfmac: brcmf_sdbrcm_dpc Enter
[   37.577016] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.577026] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   37.580188] brcmfmac: brcmf_sdio_readframes Enter
[   37.580311] brcmfmac: brcmf_sdbrcm_read_control Enter
[   37.580518] brcmfmac: brcmf_net_attach Enter, idx=0 mac=00:90:4c:c5:12:38
[   37.581610] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
[   37.581704] brcmfmac: brcmf_net_attach wlan0: Broadcom Dongle Host Driver
[   37.596623] brcmfmac: brcmf_sdbrcm_bus_sleep Enter
[   37.596641] brcmfmac: brcmf_sdbrcm_kso_control Enter
[   45.955942] brcmfmac: brcmf_netdev_get_stats Enter, idx=0
