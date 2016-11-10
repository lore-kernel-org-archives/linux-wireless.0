Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:34674 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751713AbcKJR7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 12:59:22 -0500
Date: Thu, 10 Nov 2016 18:59:15 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Problems getting mwifiex with sd8887 to work
Message-ID: <20161110175915.GB1585@katana> (sfid-20161110_185925_964135_DD150837)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I am trying to get a SD8887 based SDIO card to work with my Renesas H3
Salvator-X board. The card is either a u-blox emmy-w1-evk or a ZComax AC-180M,
I am evaluating both. I really prefer to run the upstream driver instead of the
paperwork protected and surprisingly old custom ones.

However, for both cards, I run into an error I cannot parse:

[    4.028588] mwifiex_sdio mmc2:0001:1: mwifiex_process_cmdresp: cmd 0x242 failed during	initialization

I use a v4.9-rc2 based tree called 'renesas-drives' [1] which has a few Renesas
specific patches on top but nothing mwifiex related AFAICT. I use the firmware from
the linux-firmware tree.

Any further use of the interface mlan0 or reading eeprom via debugfs will result in a timeout.

[   18.146710] mwifiex_sdio mmc2:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id = 0x10, act = 0x1

I assume this is a follow-up problem so I skip the logs for these timeouts (can
easily send them, of course, in case they are interesting). I'll attach a full
debug output from mwifiex from insertion until the initial 0x242 error.

For full disclaimer, I am the maintainer of the underlying Renesas SD driver
and I want to use this setup to create a test scenario for SDIO with UHS
speeds. So, if there is something wrong in the SD part, I'll happily hack on
that.

But for now, I simply would need a starting point :) 0x242 is
"HostCmd_CMD_CHAN_REGION_CFG". Could this mean it cannot load configuration
data? I did search around but couldn't find anything useful.

Thanks,

   Wolfram


[1] https://git.kernel.org/cgit/linux/kernel/git/geert/renesas-drivers.git/

[    3.139424] mmc2: new ultra high speed SDR50 SDIO card at address 0001
[    3.142867] mwifiex_sdio: info: vendor=0x02DF device=0x9135 class=0 function=1
[    3.146696] mwifiex: rx work enabled, cpus 4
[    3.267184] mwifiex_sdio mmc2:0001:1: info: downloading FW image (391772 bytes)
[    3.452377] mwifiex_sdio mmc2:0001:1: info: FW download over, size 391772 bytes
[    3.671191] mwifiex_sdio mmc2:0001:1: WLAN FW is active
[    3.673910] mwifiex_sdio mmc2:0001:1: cmd: QUEUE_CMD: cmd=0xa9, cmd_pending=1
[    3.677550] mwifiex_sdio mmc2:0001:1: cmd: DNLD_CMD: 0xa9, act 0x0, len 8, seqno 0x1
[    3.681429] cmd buffer:00000000: a9 00 08 00 01 00 00 00
[    3.684089] mwifiex_sdio mmc2:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[    3.688527] mwifiex_sdio mmc2:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 32768
[    3.693652] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x80
[    3.696443] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=1
[    3.700321] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x82
[    3.703106] mwifiex_sdio mmc2:0001:1: int: DNLD: wr_bitmap=0xffffffff
[    3.706328] mwifiex_sdio mmc2:0001:1: info:  <--- Tx DONE Interrupt --->
[    3.709680] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.712811] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x40
[    3.715600] mwifiex_sdio mmc2:0001:1: info: rx_len = 256
[    3.718292] mwifiex_sdio mmc2:0001:1: info: --- Rx: Cmd Response ---
[    3.721471] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.724563] mwifiex_sdio mmc2:0001:1: cmd: CMD_RESP: 0x80a9, result 0, len 8, seqno 0x1
[    3.728565] CMD_RESP buffer:00000000: a9 00 08 00 01 00 00 00
[    3.731439] mwifiex_sdio mmc2:0001:1: cmd completed: status=0
[    3.734312] mwifiex_sdio mmc2:0001:1: cmd: FREE_CMD: cmd=0xa9, cmd_pending=0
[    3.737930] mwifiex_sdio mmc2:0001:1: cmd: QUEUE_CMD: cmd=0x3, cmd_pending=1
[    3.741459] mwifiex_sdio mmc2:0001:1: cmd: DNLD_CMD: 0x3, act 0x0, len 71, seqno 0x2
[    3.745333] cmd buffer:00000000: 03 00 47 00 02 00 00 00 00 00 00 00 00 00 00 00
[    3.749031] cmd buffer:00000010: ff ff ff ff ff ff 00 00 00 00 00 00 00 00 00 00
[    3.752729] cmd buffer:00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    3.756426] cmd buffer:00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    3.760189] cmd buffer:00000040: 00 00 00 00 00 00 00
[    3.762714] mwifiex_sdio mmc2:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[    3.767156] mwifiex_sdio mmc2:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 32768
[    3.771814] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x80
[    3.774599] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.777728] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x40
[    3.780517] mwifiex_sdio mmc2:0001:1: info: rx_len = 256
[    3.783210] mwifiex_sdio mmc2:0001:1: info: --- Rx: Cmd Response ---
[    3.786386] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.789484] mwifiex_sdio mmc2:0001:1: cmd: CMD_RESP: 0x8003, result 0, len 79, seqno 0x2
[    3.793530] CMD_RESP buffer:00000000: 03 00 4f 00 02 00 00 00 02 00 02 42 00 00 40 00
[    3.797444] CMD_RESP buffer:00000010: d4 ca 6e 00 03 94 10 00 01 00 07 44 0f 05 00 00
[    3.801359] CMD_RESP buffer:00000020: 00 00 00 00 00 00 00 00 00 00 03 ff 00 00 11 00
[    3.805273] CMD_RESP buffer:00000030: d3 65 11 20 00 0e 00 00 00 00 00 00 00 00 00 30
[    3.809188] CMD_RESP buffer:00000040: 71 c0 33 fe ff fe ff c7 01 04 00 01 00 02 00
[    3.812974] mwifiex_sdio mmc2:0001:1: key_api v2.0
[    3.815370] mwifiex_sdio mmc2:0001:1: info: GET_HW_SPEC: fw_release_number- 0x50f4407
[    3.819285] mwifiex_sdio mmc2:0001:1: info: GET_HW_SPEC: permanent addr: d4:ca:6e:00:03:94
[    3.823417] mwifiex_sdio mmc2:0001:1: info: GET_HW_SPEC: hw_if_version=0x2 version=0x4202
[    3.827507] mwifiex_sdio mmc2:0001:1: cmd: mp_end_port 32, data port mask 0xffffffff
[    3.831379] mwifiex_sdio mmc2:0001:1: cmd completed: status=0
[    3.834251] mwifiex_sdio mmc2:0001:1: cmd: FREE_CMD: cmd=0x3, cmd_pending=0
[    3.837886] mwifiex_sdio mmc2:0001:1: cmd: set tx_buf=2048
[    3.840631] mwifiex_sdio mmc2:0001:1: cmd: QUEUE_CMD: cmd=0xd9, cmd_pending=1
[    3.844228] mwifiex_sdio mmc2:0001:1: cmd: DNLD_CMD: 0xd9, act 0x1, len 16, seqno 0x3
[    3.848151] cmd buffer:00000000: d9 00 10 00 03 00 00 00 01 00 00 08 00 00 00 00
[    3.851850] mwifiex_sdio mmc2:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[    3.856286] mwifiex_sdio mmc2:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 32768
[    3.861255] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x82
[    3.864043] mwifiex_sdio mmc2:0001:1: int: DNLD: wr_bitmap=0xffffffff
[    3.867266] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.870391] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x40
[    3.873187] mwifiex_sdio mmc2:0001:1: info: rx_len = 256
[    3.875881] mwifiex_sdio mmc2:0001:1: info: --- Rx: Cmd Response ---
[    3.879057] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.882148] mwifiex_sdio mmc2:0001:1: cmd: CMD_RESP: 0x80d9, result 0, len 16, seqno 0x3
[    3.886194] CMD_RESP buffer:00000000: d9 00 10 00 03 00 00 00 01 00 00 06 20 00 00 00
[    3.890110] mwifiex_sdio mmc2:0001:1: cmd: curr_tx_buf_size=1536
[    3.893113] mwifiex_sdio mmc2:0001:1: cmd: mp_end_port 32, data port mask 0xffffffff
[    3.896984] mwifiex_sdio mmc2:0001:1: cmd completed: status=0
[    3.899859] mwifiex_sdio mmc2:0001:1: cmd: FREE_CMD: cmd=0xd9, cmd_pending=0
[    3.903480] mwifiex_sdio mmc2:0001:1: cmd: PS Command: Enter PS
[    3.906439] mwifiex_sdio mmc2:0001:1: cmd: QUEUE_CMD: cmd=0xe4, cmd_pending=1
[    3.910042] mwifiex_sdio mmc2:0001:1: cmd: DNLD_CMD: 0xe4, act 0xff, len 30, seqno 0x4
[    3.914003] cmd buffer:00000000: e4 00 1e 00 04 00 00 00 ff 00 10 00 72 01 0e 00
[    3.917701] cmd buffer:00000010: 00 00 01 00 05 00 00 00 00 00 01 00 e8 03
[    3.921139] mwifiex_sdio mmc2:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[    3.925575] mwifiex_sdio mmc2:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 32768
[    3.930274] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x80
[    3.933065] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.936193] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x40
[    3.938977] mwifiex_sdio mmc2:0001:1: info: rx_len = 256
[    3.941672] mwifiex_sdio mmc2:0001:1: info: --- Rx: Cmd Response ---
[    3.944851] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.947942] mwifiex_sdio mmc2:0001:1: cmd: CMD_RESP: 0x80e4, result 0, len 30, seqno 0x4
[    3.951987] CMD_RESP buffer:00000000: e4 00 1e 00 04 00 00 00 ff 00 10 00 72 01 0e 00
[    3.955902] CMD_RESP buffer:00000010: 00 00 01 00 05 00 00 00 00 00 01 00 e8 03
[    3.959558] mwifiex_sdio mmc2:0001:1: info: mwifiex_ret_enh_power_mode: PS_MODE cmd reply result=0x0 action=0XFF
[    3.964645] mwifiex_sdio mmc2:0001:1: cmd: Enabled STA power save
[    3.967692] mwifiex_sdio mmc2:0001:1: cmd completed: status=0
[    3.970563] mwifiex_sdio mmc2:0001:1: cmd: FREE_CMD: cmd=0xe4, cmd_pending=0
[    3.974188] mwifiex_sdio mmc2:0001:1: cmd: QUEUE_CMD: cmd=0x242, cmd_pending=1
[    3.977808] mwifiex_sdio mmc2:0001:1: cmd: DNLD_CMD: 0x242, act 0x0, len 10, seqno 0x5
[    3.981768] cmd buffer:00000000: 42 02 0a 00 05 00 00 00 00 00
[    3.984685] mwifiex_sdio mmc2:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[    3.989121] mwifiex_sdio mmc2:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 32768
[    3.993759] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x80
[    3.996547] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    3.999679] mwifiex_sdio mmc2:0001:1: int: sdio_ireg = 0x40
[    4.002464] mwifiex_sdio mmc2:0001:1: info: rx_len = 256
[    4.005160] mwifiex_sdio mmc2:0001:1: info: --- Rx: Cmd Response ---
[    4.008339] mwifiex_sdio mmc2:0001:1: info: cmd_sent=0 data_sent=0
[    4.011435] mwifiex_sdio mmc2:0001:1: cmd: CMD_RESP: 0x8242, result 2, len 10, seqno 0x5
[    4.015481] CMD_RESP buffer:00000000: 42 02 0a 00 05 00 02 00 00 00
[    4.018614] mwifiex_sdio mmc2:0001:1: CMD_RESP: cmd 0x242 error, result=0x2
[    4.022099] mwifiex_sdio mmc2:0001:1: cmd completed: status=-1
[    4.025017] mwifiex_sdio mmc2:0001:1: cmd: FREE_CMD: cmd=0x242, cmd_pending=0
[    4.028588] mwifiex_sdio mmc2:0001:1: mwifiex_process_cmdresp: cmd 0x242 failed during	initialization


--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYJLVzAAoJEBQN5MwUoCm2ausQAJ/mLE9QSHvhKiOqUa+TIOXs
Wf1fprLzBs5+MDxb/W8xR5wB6xqK7Q5jQXp3rorQKKkxnxoXjiRvHBbN5/pxrpzU
T//4Q6sLL8W8KIWW2ZE4OpRJqCPIF691y1UEFDtuzU7d8ZbjN7e+RoQtmKP0zL1t
OB1G42eUQiJ+fdSWmIVUf5jfSDQ0EVHyKvxNCIhRStxRljNsy7wuvT8kRVnjdi1P
W/vtAj/ecTtNCT9AcFfTEf9gLQDWObAOBERpbRMQ9iGso4wflY5Uox4XTN3CBRb9
O6sCBTmacBOHQOrahPeGOstzgep+mYaXQ5l+lEU1yuJTdlThKrWmF/Grq/Yace4u
EcSvxJH+ZsNgMVkbsmfFdh7N51KJjUrEK8wdQyWkRNMX9SnOB8br3oLSRIssvl4B
wCyBXaCk6YmpBQVtfUAI5ULn+3StgBysm/ypYZEsnMJOEyEcz0fVARlto82s9kSw
tj6iewq6kBY5ikmXUOeqrZ84HNshEaIh/uL7nVSOBzT8uAvTig9l1OGF7zuyekRu
ayqMH6wvHoI9wj1R0XXlnst5o/wp+/8yeIABALGYUgqxuHHQbAlpPXImeYruMfR2
5LoNxaDIKnZMdRz+lYHUsUXulM4KHJjCdTcQUZU23aBSAFwNo7quYhCt2jMbiCKK
m0dOpc0Dq7ez45ofJSHk
=TbUI
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--
