Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50146 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3H0GR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 02:17:58 -0400
Received: by mail-lb0-f171.google.com with SMTP id u14so2265801lbd.30
        for <linux-wireless@vger.kernel.org>; Mon, 26 Aug 2013 23:17:57 -0700 (PDT)
Date: Tue, 27 Aug 2013 08:17:45 +0200
From: Tobias Waldekranz <tobias@waldekranz.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: sd8787 (mwifiex) on big endian system
Message-ID: <20130827061745.GA19431@gmail.com> (sfid-20130827_081802_683034_ACE6251C)
References: <20130826102759.GA14350@gmail.com>
 <477F20668A386D41ADCC57781B1F70430EAF1FEDA0@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EAF1FEDA0@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 26, 2013 at 12:16:00PM -0700, Bing Zhao wrote:
> Hi Tobias,
> 
> > As the subject suggests, I am trying to use the SD8787 on a PPC
> > system. I have found a few endian related issues (submitted a few
> > hours ago), but it is still not working.
> > 
> > So my first question, has anyone successfully used an mwifiex device
> > on a big endian system?
> 
> AFAIK, you are probably the first one to try on a big endian system ;)
> 
> > 
> > Also, I have found that the chip seems to signal interrupts before its
> > internal registers are in a consistent state. Specifically, the
> > sdio_ireg and wr_bitmask seems to be out of sync. Inserting a small
> > delay in mwifiex_interrupt_status (sdio.c), currently 50 us solves the
> > problem. Is there some bit that should be polled here to make sure that
> > the registers are in a consistent state?
> 
> Can you enable dynamic debug and post the logs showing the register mismatch?
> 
> Thanks,
> Bing

Hi Bing,

Here is the log output without the added udelay. It is always the 0xd9
command that fails, but not always with these sdio_ireg/wr_bitmask
values. I have seen these combinations:

 - sdio_ireg incorrect(2), wr_bitmask incorrect(fffe)
 - sdio_ireg   correct(3), wr_bitmask incorrect(fffe)
 - sdio_ireg incorrect(2), wr_bitmask   correct(ffff)

Waiting 50 us before reading the mp_regs always returns the correct
response.

mmc0: new high speed SDIO card at address 0001
mwifiex_sdio: info: vendor=0x02DF device=0x9119 class=0 function=1
mwifiex_sdio: info: SDIO FUNC1 IO port: 0x10000
mwifiex_sdio mmc0:0001:1: info: downloading FW image (447384 bytes)
mwifiex_sdio mmc0:0001:1: info: FW download over, size 447384 bytes
mwifiex_sdio mmc0:0001:1: WLAN FW is active
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xa9, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1035334.499952): 0xa9, act 0x0, len 8, seqno 0x1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=12
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1035334.645688): 0x80a9, result 0, len 8, seqno 0x1
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xa9, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x3, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1035334.645742): 0x3, act 0x0, len 71, seqno 0x2
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=75
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1035334.664109): 0x8003, result 0, len 71, seqno 0x2
mwifiex_sdio mmc0:0001:1: info: GET_HW_SPEC: fw_release_number- 0x600e4209
mwifiex_sdio mmc0:0001:1: info: GET_HW_SPEC: permanent addr: 00:06:c6:37:45:28
mwifiex_sdio mmc0:0001:1: info: GET_HW_SPEC: hw_if_version=0x2 version=0x41
mwifiex_sdio mmc0:0001:1: cmd: mp_end_port 16, data port mask 0xfffe
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x3, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: set tx_buf=2048
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xd9, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1035334.664215): 0xd9, act 0x1, len 16, seqno 0x3
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x2
mwifiex_sdio mmc0:0001:1: int: DNLD: wr_bitmap=0xfffe
mwifiex_sdio mmc0:0001:1: info:  <--- Tx DONE Interrupt --->
mwifiex_sdio mmc0:0001:1: info: cmd_sent=1 data_sent=0
mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (1035344.696670) = 0xd9, act = 0x1
mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
mwifiex_sdio mmc0:0001:1: last_cmd_index = 3
mwifiex_sdio mmc0:0001:1: last_cmd_id: 00 00 00 a9 00 03 00 d9 00 00
mwifiex_sdio mmc0:0001:1: last_cmd_act: 00 00 00 00 00 00 00 01 00 00
mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 2
mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 00 00 80 a9 80 03 00 00 00 00
mwifiex_sdio mmc0:0001:1: last_event_index = 0
mwifiex_sdio mmc0:0001:1: last_event: 00 00 00 00 00 00 00 00 00 00
mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=1
mwifiex_sdio mmc0:0001:1: ps_mode=0 ps_state=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xd9, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd completed: status=-110
mwifiex_sdio mmc0:0001:1: cmd timeout
mwifiex_sdio: Resetting card...
mwifiex_sdio: info: SDIO func num=1
mwifiex_sdio mmc0:0001:1: cmd: calling mwifiex_shutdown_drv...
mwifiex_sdio mmc0:0001:1: info: shutdown mwifiex...
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 0
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 1
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 2
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 3
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 4
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 5
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 6
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 7
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 0, head = dea340d0
mwifiex_sdio mmc0:0001:1: info: Delete node c79be1a0, next = c79be1b0
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 1, head = dea340e0
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 2, head = dea340f0
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 0
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 1
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 2
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 3
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 4
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 5
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 6
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 7
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 0, head = dea340d0
mwifiex_sdio mmc0:0001:1: info: Delete node c79be1b0, next = c79be1c0
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 1, head = dea340e0
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 2, head = dea340f0
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 0
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 1
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 2
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 3
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 4
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 5
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 6
mwifiex_sdio mmc0:0001:1: info: ra_list: freeing buf for tid 7
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 0, head = dea340d0
mwifiex_sdio mmc0:0001:1: info: Delete node c79be1c0, next = dea340d0
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 1, head = dea340e0
mwifiex_sdio mmc0:0001:1: info: delete BSS priority table, bss_type = 0, bss_num = 0, i = 2, head = dea340f0
mwifiex_sdio mmc0:0001:1: info: free cmd buffer
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 0
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 1
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 2
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 3
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 4
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 5
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 6
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 7
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 8
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 9
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 10
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 11
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 12
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 13
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 14
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 15
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 16
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 17
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 18
mwifiex_sdio mmc0:0001:1: cmd: free cmd buffer 19
mwifiex_sdio mmc0:0001:1: cmd: free cmd pool
mwifiex_sdio mmc0:0001:1: info: free scan table
mwifiex_sdio mmc0:0001:1: cmd: mwifiex_shutdown_drv done
WARNING: driver mwifiex_sdio did not remove its interrupt handler!
mmc0: card 0001 removed
mmc0: new high speed SDIO card at address 0001
mwifiex_sdio: info: vendor=0x02DF device=0x9119 class=0 function=1
mwifiex_sdio: info: SDIO FUNC1 IO port: 0x10000
mwifiex_sdio mmc0:0001:1: info: downloading FW image (447384 bytes)
mwifiex_sdio mmc0:0001:1: poll card status failed, tries = 100
mwifiex_sdio mmc0:0001:1: FW download with helper: poll status timeout @ 0
mwifiex_sdio mmc0:0001:1: prog_fw failed ret=0xffffffff

Thanks
 - wkz
