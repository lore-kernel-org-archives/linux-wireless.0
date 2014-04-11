Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64547 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaDKGyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 02:54:00 -0400
Received: by mail-pd0-f178.google.com with SMTP id x10so4908759pdj.9
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 23:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5346DED8.2030704@free.fr>
References: <5346DED8.2030704@free.fr>
Date: Fri, 11 Apr 2014 12:24:00 +0530
Message-ID: <CAJwzM1k=OOBa7C3u0+TzmRUBwMYfJSMgB+smbORfKmPE6KnF2g@mail.gmail.com> (sfid-20140411_085405_457312_A37CF496)
Subject: Re: Mwifiex driver on Globascal Mirabox
From: Avinash Patil <avinashapatil@gmail.com>
To: WebAV <webav@free.fr>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---Resending as plain text----

Hi,

Thanks for your email & logs.

What is FW version? You can see this in driver dmesg logs at load time.

Thanks,
Avinash

On Thu, Apr 10, 2014 at 11:41 PM, WebAV <webav@free.fr> wrote:
>     Hi,
>
> Mwifiex driver doesn't work on Globalscale Mirabox (SD8787), when I do a "iw
> mlan0 scan" command :
>
> with a 3.12 kernel : mwifiex_cmd_timeout_func: Timeout cmd id () = 0x6, act
> = 0x3
>
> With a 3.14.0-next-20140409 :  mwifiex_cmd_timeout_func: Timeout cmd id () =
> 0x107, act = 0x0
>
> dmesg :
>
> mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x107, cmd_pending=1
> mwifiex_sdio mmc0:0001:1: event: wakeup device...
> mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x3
> mwifiex_sdio mmc0:0001:1: int: DNLD: wr_bitmap=0xffff
> mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
> mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x1
> mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x00000001
> mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x00000000
> mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=10
> mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
> mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no
> aggregation for cmd response
> mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
> mwifiex_sdio mmc0:0001:1: info: --- Rx: Event ---
> mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x00000000
> mwifiex_sdio mmc0:0001:1: info: no more rd_port available
> mwifiex_sdio mmc0:0001:1: info: EVENT: AWAKE
> mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1397151023.654452): 0x107, act
> 0x0, len 80, seqno 0x26
> mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation
> disabled
> mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current
> buffer 0
> mwifiex_sdio mmc0:0001:1: data: 3595 BSS(0-0): Data <= kernel
> mwifiex_sdio mmc0:0001:1: data: 3996 BSS(0-0): Data <= kernel
> mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id
> (1397151033.670677) = 0x107, act = 0x0
> mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
> mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
> mwifiex_sdio mmc0:0001:1: is_cmd_timedout = 1
> mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
> mwifiex_sdio mmc0:0001:1: last_cmd_index = 1
> mwifiex_sdio mmc0:0001:1: last_cmd_id: 10 00 07 01 10 00 e4 00 10 00
> mwifiex_sdio mmc0:0001:1: last_cmd_act: 01 00 00 00 01 00 ff 00 01 00
> mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 0
> mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 10 80 10 80 10 80 e4 80 10 80
> mwifiex_sdio mmc0:0001:1: last_event_index = 4
> mwifiex_sdio mmc0:0001:1: last_event: 00 00 0b 00 0a 00 0b 00 0a 00
> mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
> mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
> mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x107, cmd_pending=0
> mwifiex_sdio mmc0:0001:1: cmd timeout
> mwifiex_sdio mmc0:0001:1: info: aborting scan
> mwifiex_sdio: Resetting card...
> mwifiex_sdio: info: SDIO func num=1
> mwifiex_sdio mmc0:0001:1: cmd: calling mwifiex_shutdown_drv...
> mwifiex_sdio mmc0:0001:1: info: shutdown mwifiex...
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 0, head = ee1180d0
> mwifiex_sdio mmc0:0001:1: info: Delete node ee3fb1c0, next = ee3fb380
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 1, head = ee1180dc
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 2, head = ee1180e8
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 0, head = ee1180d0
> mwifiex_sdio mmc0:0001:1: info: Delete node ee3fb380, next = ee3fb300
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 1, head = ee1180dc
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 2, head = ee1180e8
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 0, head = ee1180d0
> mwifiex_sdio mmc0:0001:1: info: Delete node ee3fb300, next = ee1180d0
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 1, head = ee1180dc
> mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0,
> bss_num = 0, i = 2, head = ee1180e8
> mwifiex_sdio mmc0:0001:1: info: free cmd buffer
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 0
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 1
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 2
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 3
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 4
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 5
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 6
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 7
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 8
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 9
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 10
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 11
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 12
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 13
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 14
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 15
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 16
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 17
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 18
> mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 19
> mwifiex_sdio mmc0:0001:1: cmd: free cmd pool
> mwifiex_sdio mmc0:0001:1: info: free scan table
> mwifiex_sdio mmc0:0001:1: cmd: mwifiex_shutdown_drv done
> mwifiex_sdio mmc0:0001:1: info: unregister device
> mwifiex_sdio mmc0:0001:1: info: free adapter
> mwifiex: info: mwifiex_free_adapter: free adapter
> mmc0: card 0001 removed
> mmc0: new high speed SDIO card at address 0001
> mwifiex_sdio: info: vendor=0x02DF device=0x9119 class=0 function=1
> mwifiex_sdio: info: SDIO FUNC1 IO port: 0x10000
> mwifiex_sdio mmc0:0001:1: info: downloading FW image (447384 bytes)
> mwifiex_sdio mmc0:0001:1: poll card status failed, tries = 100
> mwifiex_sdio mmc0:0001:1: FW download with helper: poll status timeout @ 0
> mwifiex_sdio mmc0:0001:1: prog_fw failed ret=0xffffffff
> mwifiex: info: mwifiex_fw_dpc: unregister device
> mwifiex: info: mwifiex_free_adapter: free adapter
>
> Tell me if you need more information.
>
>
>
>
>
>
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
