Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48535 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab3H1LxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 07:53:01 -0400
Received: by mail-lb0-f177.google.com with SMTP id p5so3636831lbi.36
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 04:52:59 -0700 (PDT)
Date: Wed, 28 Aug 2013 13:52:51 +0200
From: Tobias Waldekranz <tobias@waldekranz.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: sd8787 (mwifiex) on big endian system
Message-ID: <20130828115251.GA3504@gmail.com> (sfid-20130828_135316_419193_6352C9FB)
References: <20130826102759.GA14350@gmail.com>
 <477F20668A386D41ADCC57781B1F70430EAF1FEDA0@SC-VEXCH1.marvell.com>
 <20130827061745.GA19431@gmail.com>
 <477F20668A386D41ADCC57781B1F70430EAF1FF23F@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EAF1FF23F@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 27, 2013 at 04:42:37PM -0700, Bing Zhao wrote:
> Hi Tobias,
> 
> > Hi Bing,
> > 
> > Here is the log output without the added udelay. It is always the 0xd9
> > command that fails, but not always with these sdio_ireg/wr_bitmask
> > values. I have seen these combinations:
> > 
> >  - sdio_ireg incorrect(2), wr_bitmask incorrect(fffe)
> >  - sdio_ireg   correct(3), wr_bitmask incorrect(fffe)
> >  - sdio_ireg incorrect(2), wr_bitmask   correct(ffff)
> > 
> > Waiting 50 us before reading the mp_regs always returns the correct
> > response.
> 
> Thanks for the logs.
> 
> Could you try the following change to bypass 0xd9 command?
> 
> diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifi
> index c0268b5..3cecc86 100644
> --- a/drivers/net/wireless/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/mwifiex/sta_cmd.c
> @@ -1541,6 +1541,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8
>                 if (ret)
>                         return -1;
> 
> +#if 0
>                 /* Reconfigure tx buf size */
>                 ret = mwifiex_send_cmd_sync(priv,
>                                             HostCmd_CMD_RECONFIGURE_TX_BUFF,
> @@ -1548,6 +1549,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8
>                                             &priv->adapter->tx_buf_size);
>                 if (ret)
>                         return -1;
> +#endif
> 
>                 if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
>                         /* Enable IEEE PS by default */
> 
> Thanks,
> Bing
> 

Hi,

Here is the log:

mmc0: new high speed SDIO card at address 0001
mwifiex_sdio: info: vendor=0x02DF device=0x9119 class=0 function=1
mwifiex_sdio: info: SDIO FUNC1 IO port: 0x10000
mwifiex_sdio mmc0:0001:1: info: downloading FW image (447384 bytes)
mwifiex_sdio mmc0:0001:1: info: FW download over, size 447384 bytes
mwifiex_sdio mmc0:0001:1: WLAN FW is active
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xa9, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141981.833590): 0xa9, act 0x0, len 8, seqno 0x1
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
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141981.989543): 0x80a9, result 0, len 8, seqno 0x1
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xa9, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x3, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141981.989581): 0x3, act 0x0, len 71, seqno 0x2
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
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.7678): 0x8003, result 0, len 71, seqno 0x2
mwifiex_sdio mmc0:0001:1: info: GET_HW_SPEC: fw_release_number- 0x600e4209
mwifiex_sdio mmc0:0001:1: info: GET_HW_SPEC: permanent addr: 00:06:c6:37:45:28
mwifiex_sdio mmc0:0001:1: info: GET_HW_SPEC: hw_if_version=0x2 version=0x41
mwifiex_sdio mmc0:0001:1: cmd: mp_end_port 16, data port mask 0xfffe
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x3, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: PS Command: Enter PS
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xe4, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.7772): 0xe4, act 0xff, len 30, seqno 0x3
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=34
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.37680): 0x80e4, result 0, len 30, seqno 0x3
mwifiex_sdio mmc0:0001:1: info: mwifiex_ret_enh_power_mode: PS_MODE cmd reply result=0x0 action=0XFF
mwifiex_sdio mmc0:0001:1: cmd: Enabled STA power save
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xe4, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.37730): 0xd6, act 0x0, len 44, seqno 0x4
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=804
mwifiex_sdio mmc0:0001:1: info: rx_len = 1024 skb->len = 1024
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 1024
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.58031): 0x80d6, result 0, len 800, seqno 0x4
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.58065): 0x1e, act 0x0, len 14, seqno 0x5
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.77665): 0x801e, result 0, len 14, seqno 0x5
mwifiex_sdio mmc0:0001:1: Current TxPower Level=0, Max Power=18, Min Power=4
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.77706): 0x83, act 0x1, len 24, seqno 0x6
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=28
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.97644): 0x8083, result 0, len 24, seqno 0x6
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.97677): 0xdf, act 0x1, len 14, seqno 0x7
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.117648): 0x80df, result 0, len 14, seqno 0x7
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.117679): 0x28, act 0x13, len 12, seqno 0x8
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.137678): 0x8028, result 0, len 12, seqno 0x8
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: PS Command: Enter Auto Deep Sleep
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xe4, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.137743): 0xe4, act 0xff, len 18, seqno 0x9
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=22
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.157687): 0x80e4, result 0, len 18, seqno 0x9
mwifiex_sdio mmc0:0001:1: info: mwifiex_ret_enh_power_mode: PS_MODE cmd reply result=0x0 action=0XFF
mwifiex_sdio mmc0:0001:1: cmd: Enabled auto deep sleep
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xe4, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: SNMP_CMD: cmd_oid = 0x9
mwifiex_sdio mmc0:0001:1: cmd: SNMP_CMD: Action=0x1, OID=0x9, OIDSize=0x2, Value=0x0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.157781): 0x16, act 0x1, len 16, seqno 0xa
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.177667): 0x8016, result 0, len 16, seqno 0xa
mwifiex_sdio mmc0:0001:1: info: SNMP_RESP: oid value = 0x9, query_type = 0x1, buf size = 0x2
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.177711): 0xcd, act 0x1, len 16, seqno 0xb
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.197711): 0x80cd, result 0, len 16, seqno 0xb
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.197745): 0xd6, act 0x0, len 44, seqno 0xc
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=804
mwifiex_sdio mmc0:0001:1: info: rx_len = 1024 skb->len = 1024
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 1024
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.218053): 0x80d6, result 0, len 800, seqno 0xc
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.218090): 0x1e, act 0x0, len 14, seqno 0xd
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.237678): 0x801e, result 0, len 14, seqno 0xd
mwifiex_sdio mmc0:0001:1: Current TxPower Level=0, Max Power=18, Min Power=4
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.237719): 0x83, act 0x1, len 24, seqno 0xe
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=28
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.257659): 0x8083, result 0, len 24, seqno 0xe
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.257693): 0xdf, act 0x1, len 14, seqno 0xf
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.277659): 0x80df, result 0, len 14, seqno 0xf
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.277690): 0x28, act 0x13, len 12, seqno 0x10
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.297670): 0x8028, result 0, len 12, seqno 0x10
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: SNMP_CMD: cmd_oid = 0x9
mwifiex_sdio mmc0:0001:1: cmd: SNMP_CMD: Action=0x1, OID=0x9, OIDSize=0x2, Value=0x0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.297738): 0x16, act 0x1, len 16, seqno 0x11
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.317665): 0x8016, result 0, len 16, seqno 0x11
mwifiex_sdio mmc0:0001:1: info: SNMP_RESP: oid value = 0x9, query_type = 0x1, buf size = 0x2
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.317707): 0xcd, act 0x1, len 16, seqno 0x12
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.318964): 0x80cd, result 0, len 16, seqno 0x12
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.318993): 0xd6, act 0x0, len 44, seqno 0x13
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=804
mwifiex_sdio mmc0:0001:1: info: rx_len = 1024 skb->len = 1024
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 1024
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.319768): 0x80d6, result 0, len 800, seqno 0x13
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.319828): 0x1e, act 0x0, len 14, seqno 0x14
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.320202): 0x801e, result 0, len 14, seqno 0x14
mwifiex_sdio mmc0:0001:1: Current TxPower Level=0, Max Power=18, Min Power=4
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.320240): 0x83, act 0x1, len 24, seqno 0x15
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=28
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.320593): 0x8083, result 0, len 24, seqno 0x15
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.320647): 0xdf, act 0x1, len 14, seqno 0x16
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.321017): 0x80df, result 0, len 14, seqno 0x16
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.321047): 0x28, act 0x13, len 12, seqno 0x17
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.321415): 0x8028, result 0, len 12, seqno 0x17
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: SNMP_CMD: cmd_oid = 0x9
mwifiex_sdio mmc0:0001:1: cmd: SNMP_CMD: Action=0x1, OID=0x9, OIDSize=0x2, Value=0x0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.321482): 0x16, act 0x1, len 16, seqno 0x18
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.321850): 0x8016, result 0, len 16, seqno 0x18
mwifiex_sdio mmc0:0001:1: info: SNMP_RESP: oid value = 0x9, query_type = 0x1, buf size = 0x2
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.321888): 0xcd, act 0x1, len 16, seqno 0x19
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=20
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.322259): 0x80cd, result 0, len 16, seqno 0x19
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
mwifiex_sdio mmc0:0001:1: ignoring F/W country code US
mwifiex_sdio mmc0:0001:1: info: mlan0: Marvell 802.11 Adapter
mwifiex_sdio mmc0:0001:1: info: uap0: Marvell 802.11 Adapter
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xeb, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.362104): 0xeb, act 0x1, len 12, seqno 0x201a
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.364515): 0x80eb, result 0, len 12, seqno 0x201a
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xeb, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xeb, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.364593): 0xeb, act 0x1, len 12, seqno 0x201b
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.366498): 0x80eb, result 0, len 12, seqno 0x201b
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xeb, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xeb, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1141982.366578): 0xeb, act 0x1, len 12, seqno 0x201c
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1141982.367029): 0x80eb, result 0, len 12, seqno 0x201c
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xeb, cmd_pending=0
mwifiex_sdio mmc0:0001:1: info: p2p0: Marvell 802.11 Adapter
mwifiex_sdio mmc0:0001:1: info: MWIFIEX VERSION: mwifiex 1.0 (66.14.96.p9) 
mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0 (66.14.96.p9) 
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=10
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Event ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: info: EVENT: SLEEP
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=1
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available


The driver seems to complete the initialization process. But if I now
launch hostapd, I get a timeout in another command (0xb1):

mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x10c, cmd_pending=1
mwifiex_sdio mmc0:0001:1: event: wakeup device...
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x10c, cmd_pending=2
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x3
mwifiex_sdio mmc0:0001:1: int: DNLD: wr_bitmap=0xffff
mwifiex_sdio mmc0:0001:1: info:  <--- Tx DONE Interrupt --->
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=10
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Event ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: info: EVENT: AWAKE
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.253127): 0x10c, act 0x1, len 14, seqno 0x101e
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: Enable Promiscuous mode
mwifiex_sdio mmc0:0001:1: info: old_pkt_filter=0x13, curr_pkt_filter=0x93
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=3
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: Enable Promiscuous mode
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: old_pkt_filter=0x93, curr_pkt_filter=0x93
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: info: Enable Promiscuous mode
mwifiex_sdio mmc0:0001:1: info: old_pkt_filter=0x93, curr_pkt_filter=0x93
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.253760): 0x810c, result 0, len 14, seqno 0x101e
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x10c, cmd_pending=2
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.253789): 0x10c, act 0x1, len 14, seqno 0x101f
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=18
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.254157): 0x810c, result 0, len 14, seqno 0x101f
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x10c, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.254180): 0x28, act 0x93, len 12, seqno 0x1020
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.255185): 0x8028, result 0, len 12, seqno 0x1021
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.257267): 0x28, act 0x93, len 12, seqno 0x1022
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.257653): 0x8028, result 0, len 12, seqno 0x1022
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.257859): 0x28, act 0x93, len 12, seqno 0x1023
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.258220): 0x8028, result 0, len 12, seqno 0x1023
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.258392): 0x28, act 0x93, len 12, seqno 0x1024
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.258745): 0x8028, result 0, len 12, seqno 0x1024
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
mwifiex_sdio mmc0:0001:1: info: 11D: no_of_triplet=0x1
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x5b, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xb2, cmd_pending=2
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.259117): 0x5b, act 0x1, len 20, seqno 0x25
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=24
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.259522): 0x805b, result 0, len 20, seqno 0x25
mwifiex_sdio mmc0:0001:1: info: 11D Domain Info Resp: no_of_triplet=1
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0x5b, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.259553): 0xb2, act 0x0, len 8, seqno 0x1026
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
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
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.259880): 0x80b2, result 0, len 8, seqno 0x1026
mwifiex_sdio mmc0:0001:1: cmd completed: status=0
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xb2, cmd_pending=0
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xb0, cmd_pending=1
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0xb1, cmd_pending=2
mwifiex_sdio mmc0:0001:1: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=3
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.259960): 0xb0, act 0x1, len 115, seqno 0x1027
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=119
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: cmd: CMD_RESP: (1142011.260400): 0x80b0, result 0, len 115, seqno 0x1027
mwifiex_sdio mmc0:0001:1: cmd: FREE_CMD: cmd=0xb0, cmd_pending=2
mwifiex_sdio mmc0:0001:1: cmd: DNLD_CMD: (1142011.260426): 0xb1, act 0x0, len 8, seqno 0x1028
mwifiex_sdio mmc0:0001:1: info: mwifiex_host_to_card_mp_aggr: tx aggregation disabled
mwifiex_sdio mmc0:0001:1: data: mwifiex_host_to_card_mp_aggr: send current buffer 0
mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0001
mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=21
mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
mwifiex_sdio mmc0:0001:1: info: mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
mwifiex_sdio mmc0:0001:1: info: --- Rx: Event ---
mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x0000
mwifiex_sdio mmc0:0001:1: info: no more rd_port available
mwifiex_sdio mmc0:0001:1: event: 1142011.264553: cause: 0x2e
mwifiex_sdio mmc0:0001:1: AP EVENT: event id: 0x2e
mwifiex_sdio mmc0:0001:1: cmd_wait_q terminated: -512
mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (1142021.275294) = 0xb1, act = 0x0
mwifiex_sdio mmc0:0001:1: num_data_h2c_failure = 0
mwifiex_sdio mmc0:0001:1: num_cmd_h2c_failure = 0
mwifiex_sdio mmc0:0001:1: num_cmd_timeout = 1
mwifiex_sdio mmc0:0001:1: num_tx_timeout = 0
mwifiex_sdio mmc0:0001:1: last_cmd_index = 4
mwifiex_sdio mmc0:0001:1: last_cmd_id: 00 28 00 5b 00 b2 00 b0 00 b1
mwifiex_sdio mmc0:0001:1: last_cmd_act: 00 93 00 01 00 00 00 01 00 00
mwifiex_sdio mmc0:0001:1: last_cmd_resp_index = 3
mwifiex_sdio mmc0:0001:1: last_cmd_resp_id: 80 28 80 5b 80 b2 80 b0 80 28
mwifiex_sdio mmc0:0001:1: last_event_index = 3
mwifiex_sdio mmc0:0001:1: last_event: 00 00 00 0b 00 0a 00 2e 00 00
mwifiex_sdio mmc0:0001:1: data_sent=0 cmd_sent=0
mwifiex_sdio mmc0:0001:1: ps_mode=1 ps_state=0
mwifiex_sdio: Resetting card...

-- 
Thanks
 - wkz
