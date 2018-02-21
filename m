Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:46782 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753328AbeBURoi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 12:44:38 -0500
Received: by mail-qt0-f182.google.com with SMTP id u6so2927059qtg.13
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 09:44:38 -0800 (PST)
MIME-Version: 1.0
From: Neelansh Mittal <neelansh@gmail.com>
Date: Wed, 21 Feb 2018 23:13:56 +0530
Message-ID: <CANg=XDR-jDpdJ19cXbWMNUf4gDR8jnJh8Gj7YKHNSZxK2Y-F-g@mail.gmail.com> (sfid-20180221_184443_034655_99257B94)
Subject: Marvell STA getting hanged during BA neg
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Observing that Marvell STA is getting hanged after association, during
ADDBA req/response exchange.

Logs
--------------------
Feb 19 20:53:23 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:23 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:23 debian kernel: mlan0: 1519073603.149002 : Event: 0x17
Feb 19 20:53:23 debian kernel: EVENT: WMM status changed: 88
Feb 19 20:53:23 debian kernel: WMM_STATUS: QSTATUS TLV: 0
Feb 19 20:53:23 debian kernel: WMM_STATUS: QSTATUS TLV: 1
Feb 19 20:53:23 debian kernel: WMM_STATUS: QSTATUS TLV: 2
Feb 19 20:53:23 debian kernel: WMM_STATUS: QSTATUS TLV: 3
Feb 19 20:53:23 debian kernel: WMM STATUS: WMM IE
Feb 19 20:53:23 debian kernel: WMM: CWmax=1023 CWmin=15 Avg Back-off=10
Feb 19 20:53:23 debian kernel: WMM: CWmax=1023 CWmin=15 Avg Back-off=14
Feb 19 20:53:23 debian kernel: WMM: CWmax=15 CWmin=7 Avg Back-off=5
Feb 19 20:53:23 debian kernel: WMM: CWmax=7 CWmin=3 Avg Back-off=3
Feb 19 20:53:23 debian kernel: event id:0x19
Feb 19 20:53:23 debian kernel: *
Feb 19 20:53:23 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:23 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:23 debian kernel: mlan0: 1519073603.208305 : Event: 0x2b
Feb 19 20:53:23 debian kernel: EVENT: PORT RELEASE
Feb 19 20:53:23 debian kernel: mlan0: QUEUE_CMD: cmd=0xc7 is queued
Feb 19 20:53:23 debian kernel: PORT_RELEASE: Sending PORT_REL to moal
Feb 19 20:53:23 debian kernel: event id:0x10
Feb 19 20:53:23 debian kernel: LinkRecovery Stop: Enabled: (null), Arg: 0, 0
Feb 19 20:53:23 debian kernel: mlan0: DNLD_CMD (1519073603.237076):
0xc7, act 0x0, len 8, seqno 0xcf
Feb 19 20:53:23 debian kernel: *
Feb 19 20:53:23 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:23 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:23 debian kernel: mlan0: CMD_RESP (1519073603.254242):
0x80c7, result 0, len 106, seqno 0xcf
Feb 19 20:53:23 debian kernel: LINK_STATUS: 00:0c:43:26:60:50
Feb 19 20:53:23 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:23 debian kernel: ADDRCONF(NETDEV_CHANGE): mlan0: link
becomes ready
Feb 19 20:53:23 debian kernel: mlan0: QUEUE_CMD: cmd=0x10 is queued
Feb 19 20:53:23 debian kernel: IOCTL pending: de838800 id=0x20000,
sub_id=0x20007 wait_option=0, action=1
Feb 19 20:53:23 debian kernel: mlan0: QUEUE_CMD: cmd=0x10 is queued
Feb 19 20:53:23 debian kernel: IOCTL pending: de838000 id=0x20000,
sub_id=0x20007 wait_option=0, action=1
Feb 19 20:53:23 debian kernel: mlan0: DNLD_CMD (1519073603.294835):
0x10, act 0x1, len 204, seqno 0xd0
Feb 19 20:53:23 debian kernel: *
Feb 19 20:53:23 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:23 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:23 debian kernel: mlan0: CMD_RESP (1519073603.311794):
0x8010, result 0, len 204, seqno 0xd0
Feb 19 20:53:23 debian kernel: IOCTL completed: de838800 id=0x20000
sub_id=0x20007, action=1,  status=0, status_code=0x0
Feb 19 20:53:23 debian kernel: mlan0: <7>select queue: tid=0, index=2
Feb 19 20:53:23 debian kernel: 114083 : mlan0 (bss=0): Data <= kernel
Feb 19 20:53:23 debian kernel: mlan0: Adding pkt de838800 (priority=0,
tid_down=0) to ra_list de81f380
Feb 19 20:53:23 debian kernel: DNLD_CMD (1519073603.321234): 0x10, act
0x1, len 204, seqno 0xd1
Feb 19 20:53:23 debian kernel: mlan0: 1519073603.342561 : Data => FW
Feb 19 20:53:23 debian kernel: *
Feb 19 20:53:23 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:23 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:23 debian kernel: mlan0: CMD_RESP (1519073603.356854):
0x8010, result 0, len 204, seqno 0xd1
Feb 19 20:53:23 debian kernel: IOCTL completed: de838000 id=0x20000
sub_id=0x20007, action=1,  status=0, status_code=0x0
Feb 19 20:53:23 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:23 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:23 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:23 debian kernel: select queue: tid=0, index=2
Feb 19 20:53:23 debian kernel: 114103 : mlan0 (bss=0): Data <= kernel
Feb 19 20:53:23 debian kernel: mlan0: Adding pkt dea3d000 (priority=0,
tid_down=0) to ra_list de81f380
Feb 19 20:53:23 debian kernel: mlan0: 1519073603.529004 : Data => FW
Feb 19 20:53:23 debian kernel: IOCTL: dea541e0 id=0x70000,
sub_id=0x70003 wait_option=1, action=2 status=0
Feb 19 20:53:23 debian kernel: IOCTL: de838800 id=0x20000,
sub_id=0x20005 wait_option=1, action=2 status=0
Feb 19 20:53:23 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:23 debian kernel: mlan0: QUEUE_CMD: cmd=0xd4 is queued
Feb 19 20:53:23 debian kernel: IOCTL pending: deab8000 id=0x200000,
sub_id=0x200005 wait_option=1, action=0
Feb 19 20:53:23 debian kernel: mlan0: DNLD_CMD (1519073603.726497):
0xd4, act 0x0, len 36, seqno 0xd2
Feb 19 20:53:23 debian kernel: *
Feb 19 20:53:23 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:23 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:23 debian kernel: mlan0: CMD_RESP (1519073603.742793):
0x80d4, result 0, len 36, seqno 0xd2
Feb 19 20:53:23 debian kernel: IOCTL completed: deab8000 id=0x200000
sub_id=0x200005, action=0,  status=0, status_code=0x0
Feb 19 20:53:23 debian kernel: mlan0: QUEUE_CMD: cmd=0x80d4 is queued
Feb 19 20:53:23 debian kernel: IOCTL pending: deab8000 id=0x200000,
sub_id=0x200005 wait_option=1, action=0
Feb 19 20:53:23 debian kernel: mlan0: DNLD_CMD (1519073603.757028):
0x80d4, act 0x1, len 36, seqno 0xd3
Feb 19 20:53:23 debian kernel: *
Feb 19 20:53:23 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:23 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:23 debian kernel: mlan0: CMD_RESP (1519073603.774456):
0x80d4, result 0, len 36, seqno 0xd3
Feb 19 20:53:23 debian kernel: IOCTL completed: deab8000 id=0x200000
sub_id=0x200005, action=0,  status=0, status_code=0x0
Feb 19 20:53:24 debian kernel: select queue: tid=0, index=2
Feb 19 20:53:24 debian kernel: 114203 : mlan0 (bss=0): Data <= kernel
Feb 19 20:53:24 debian kernel: mlan0: Adding pkt dea3d400 (priority=0,
tid_down=0) to ra_list de81f380
Feb 19 20:53:24 debian kernel: mlan0: 1519073604.528686 : Data => FW
Feb 19 20:53:25 debian kernel: *
Feb 19 20:53:25 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:25 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:25 debian kernel: mlan0: 1519073605.052733 : Event: 0x33
Feb 19 20:53:25 debian kernel: EVENT: ADDBA Request
Feb 19 20:53:25 debian kernel: mlan0: QUEUE_CMD: cmd=0xcf is queued
Feb 19 20:53:25 debian kernel: mlan0: DNLD_CMD (1519073605.061533):
0xcf, act 0x0, len 24, seqno 0xd4
Feb 19 20:53:25 debian kernel: *
Feb 19 20:53:25 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:25 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:25 debian kernel: invalid packet, *nb=33001, npayload=256
Feb 19 20:53:25 debian kernel: Card to host failed: int status=0x1
Feb 19 20:53:25 debian kernel: *
Feb 19 20:53:25 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:25 debian kernel: UPLD: rd_bitmap=0x00000002
Feb 19 20:53:25 debian kernel: mlan0: 1519073605.086004 : Data <= FW
Feb 19 20:53:25 debian kernel: *
Feb 19 20:53:25 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:25 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:25 debian kernel: mlan0: 1519073605.155160 : Event: 0x33
Feb 19 20:53:25 debian kernel: EVENT: ADDBA Request
Feb 19 20:53:25 debian kernel: mlan0: QUEUE_CMD: cmd=0xcf is queued
Feb 19 20:53:26 debian kernel: select queue: tid=0, index=2
Feb 19 20:53:26 debian kernel: 114360 : mlan0 (bss=0): Data <= kernel
Feb 19 20:53:26 debian kernel: mlan0: Adding pkt de838800 (priority=0,
tid_down=0) to ra_list de81f380
Feb 19 20:53:26 debian kernel: mlan0: 1519073606.098565 : Data => FW
Feb 19 20:53:27 debian kernel: *
Feb 19 20:53:27 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:27 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:27 debian kernel: mlan0: 1519073607.156702 : Event: 0x33
Feb 19 20:53:27 debian kernel: EVENT: ADDBA Request
Feb 19 20:53:27 debian kernel: mlan0: QUEUE_CMD: cmd=0xcf is queued
Feb 19 20:53:28 debian kernel: select queue: tid=0, index=2
Feb 19 20:53:28 debian kernel: 114603 : mlan0 (bss=0): Data <= kernel
Feb 19 20:53:28 debian kernel: mlan0: Adding pkt dea3d000 (priority=0,
tid_down=0) to ra_list de81f380
Feb 19 20:53:28 debian kernel: mlan0: 1519073608.528557 : Data => FW
Feb 19 20:53:29 debian kernel: *
Feb 19 20:53:29 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:29 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:29 debian kernel: mlan0: 1519073609.160666 : Event: 0x33
Feb 19 20:53:29 debian kernel: EVENT: ADDBA Request
Feb 19 20:53:29 debian kernel: mlan0: QUEUE_CMD: cmd=0xcf is queued
Feb 19 20:53:31 debian kernel: *
Feb 19 20:53:31 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:31 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:31 debian kernel: mlan0: 1519073611.164623 : Event: 0x33
Feb 19 20:53:31 debian kernel: EVENT: ADDBA Request
Feb 19 20:53:31 debian kernel: mlan0: QUEUE_CMD: cmd=0xcf is queued
Feb 19 20:53:32 debian kernel: select queue: tid=0, index=2
Feb 19 20:53:32 debian kernel: 115003 : mlan0 (bss=0): Data <= kernel
Feb 19 20:53:32 debian kernel: mlan0: Adding pkt dea3d000 (priority=0,
tid_down=0) to ra_list de81f380
Feb 19 20:53:32 debian kernel: mlan0: 1519073612.528550 : Data => FW
Feb 19 20:53:33 debian kernel: *
Feb 19 20:53:33 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:33 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:33 debian kernel: mlan0: 1519073613.168570 : Event: 0x33
Feb 19 20:53:33 debian kernel: EVENT: ADDBA Request
Feb 19 20:53:33 debian kernel: mlan0: QUEUE_CMD: cmd=0xcf is queued
Feb 19 20:53:33 debian kernel: mlan0: no IPv6 routers present
Feb 19 20:53:35 debian kernel: *
Feb 19 20:53:35 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:53:35 debian kernel: UPLD: rd_bitmap=0x00000001
Feb 19 20:53:35 debian kernel: mlan0: 1519073615.172534 : Event: 0x33
Feb 19 20:53:35 debian kernel: EVENT: ADDBA Request
Feb 19 20:53:35 debian kernel: mlan0: QUEUE_CMD: cmd=0xcf is queued
Feb 19 20:53:38 debian kernel: IOCTL: de83d800 id=0x20000,
sub_id=0x20004 wait_option=1, action=2 status=0
Feb 19 20:53:38 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:38 debian kernel: IOCTL: de83d800 id=0x20000,
sub_id=0x20003 wait_option=1, action=2 status=0
Feb 19 20:53:38 debian kernel: IOCTL: dea541e0 id=0x70000,
sub_id=0x70003 wait_option=1, action=2 status=0
Feb 19 20:53:38 debian kernel: IOCTL: de83d000 id=0x20000,
sub_id=0x20005 wait_option=1, action=2 status=0
Feb 19 20:53:38 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:38 debian kernel: IOCTL: df3ba000 id=0x50000,
sub_id=0x50005 wait_option=1, action=2 status=0
Feb 19 20:53:38 debian kernel: mlan0: QUEUE_CMD: cmd=0x7f is queued
Feb 19 20:53:38 debian kernel: IOCTL pending: dea541e0 id=0x70000,
sub_id=0x70001 wait_option=1, action=2
Feb 19 20:54:07 debian kernel: *
Feb 19 20:54:07 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:54:07 debian kernel: UPLD: rd_bitmap=0x00000004
Feb 19 20:54:07 debian kernel: mlan0: 1519073647.929150 : Data <= FW
Feb 19 20:54:07 debian kernel: mlan0: 1519073647.932601 : Data =>
kernel seq_num=0 tid=255
Feb 19 20:54:07 debian kernel: *
Feb 19 20:54:07 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:54:07 debian kernel: UPLD: rd_bitmap=0x00000008
Feb 19 20:54:07 debian kernel: mlan0: 1519073647.943428 : Data <= FW
Feb 19 20:54:07 debian kernel: mlan0: 1519073647.946858 : Data =>
kernel seq_num=1 tid=255
Feb 19 20:54:25 debian kernel: Timeout cmd id (1519073665.062045) =
0xcf, act = 0x0
Feb 19 20:54:25 debian kernel: cf 00 18 00 d4 00 00 00 00 00 0c 43 26 60 50 02
Feb 19 20:54:25 debian kernel: BSS type = 0 BSS role= 0
Feb 19 20:54:25 debian kernel: num_cmd_timeout = 1
Feb 19 20:54:25 debian kernel: last_cmd_index = 2
Feb 19 20:54:25 debian kernel: last_cmd_id = 0xd4 0x80d4 0xcf 0x10 0x10
Feb 19 20:54:25 debian kernel: last_cmd_act = 0x0 0x1 0x0 0x1 0x1
Feb 19 20:54:25 debian kernel: last_cmd_resp_index = 1
Feb 19 20:54:25 debian kernel: last_cmd_resp_id = 0x80d4 0x80d4 0x80c7
0x8010 0x8010
Feb 19 20:54:25 debian kernel: last_event_index = 3
Feb 19 20:54:25 debian kernel: last_event = 0x33 0x33 0x33 0x33 0x33
Feb 19 20:54:25 debian kernel: num_data_h2c_failure = 0
Feb 19 20:54:25 debian kernel: num_cmd_h2c_failure = 0
Feb 19 20:54:25 debian kernel: num_data_c2h_failure = 0
Feb 19 20:54:25 debian kernel: num_cmdevt_c2h_failure = 1
Feb 19 20:54:25 debian kernel: num_int_read_failure = 0
Feb 19 20:54:25 debian kernel: last_int_status = 1
Feb 19 20:54:25 debian kernel: num_event_deauth = 0
Feb 19 20:54:25 debian kernel: num_event_disassoc = 0
Feb 19 20:54:25 debian kernel: num_event_link_lost = 0
Feb 19 20:54:25 debian kernel: num_cmd_deauth = 1
Feb 19 20:54:25 debian kernel: num_cmd_assoc_success = 0
Feb 19 20:54:25 debian kernel: num_cmd_assoc_failure = 0
Feb 19 20:54:25 debian kernel: cmd_resp_received=0
Feb 19 20:54:25 debian kernel: event_received=0
Feb 19 20:54:25 debian kernel: max_tx_buf_size=2048
Feb 19 20:54:25 debian kernel: tx_buf_size=1792
Feb 19 20:54:25 debian kernel: curr_tx_buf_size=1792
Feb 19 20:54:25 debian kernel: data_sent=0 cmd_sent=0
Feb 19 20:54:25 debian kernel: ps_mode=0 ps_state=0
Feb 19 20:54:25 debian kernel: wakeup_dev_req=0 wakeup_tries=0
Feb 19 20:54:25 debian kernel: hs_configured=0 hs_activated=0
Feb 19 20:54:25 debian kernel: pps_uapsd_mode=0 sleep_pd=0
Feb 19 20:54:25 debian kernel: tx_lock_flag = 0
Feb 19 20:54:25 debian kernel: scan_processing = 0
Feb 19 20:54:25 debian kernel: mp_rd_bitmap=0x0 curr_rd_port=0x4
Feb 19 20:54:25 debian kernel: mp_wr_bitmap=0xff81 curr_wr_port=0x7
Feb 19 20:54:25 debian kernel: event id:0x8000000e
Feb 19 20:54:25 debian kernel: Driver version =
SD8787-14.40.20.p1-M2614346-GPL-(FP40)
Feb 19 20:54:25 debian kernel: main_state = 4
Feb 19 20:54:25 debian kernel: ioctl_pending = 2
Feb 19 20:54:25 debian kernel: tx_pending = 0
Feb 19 20:54:25 debian kernel: wmm_tx_pending[0] = 0
Feb 19 20:54:25 debian kernel: wmm_tx_pending[1] = 0
Feb 19 20:54:25 debian kernel: wmm_tx_pending[2] = 0
Feb 19 20:54:25 debian kernel: wmm_tx_pending[3] = 0
Feb 19 20:54:25 debian kernel: rx_pending = 0
Feb 19 20:54:25 debian kernel: lock_count = 21
Feb 19 20:54:25 debian kernel: malloc_count = 35
Feb 19 20:54:25 debian kernel: mbufalloc_count = 0
Feb 19 20:54:25 debian kernel: hs_skip_count = 0
Feb 19 20:54:25 debian kernel: hs_force_count = 0
Feb 19 20:54:25 debian kernel: Media state = "Connected"
Feb 19 20:54:25 debian kernel: carrier on
Feb 19 20:54:25 debian kernel: tx queue 0: started
Feb 19 20:54:25 debian kernel: tx queue 1: started
Feb 19 20:54:25 debian kernel: tx queue 2: started
Feb 19 20:54:25 debian kernel: tx queue 3: started
Feb 19 20:54:25 debian kernel: SDIO Func0 (0x0-0x9): 32 02 02 02 03 00
00 02 03 00
Feb 19 20:54:25 debian kernel: SDIO Func1 (0x0-0x9): 00 3f 03 00 00 00
81 ff 16 00
Feb 19 20:54:25 debian kernel: SDIO Func1: (0x28) 00 (0x30) 08 (0x34)
07 (0x38) 00 (0x3c) 00
Feb 19 20:54:25 debian kernel: SDIO Func1 (0x60-0x6a): dc fe 00 05 00
00 9b 01 dc fe 30
Feb 19 20:54:25 debian kernel: SDIO Func1 (0x60-0x6a): dc fe 00 05 00
00 9b 01 dc fe 30
Feb 19 20:55:08 debian kernel: *
Feb 19 20:55:08 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:55:08 debian kernel: UPLD: rd_bitmap=0x00000010
Feb 19 20:55:08 debian kernel: mlan0: 1519073708.933275 : Data <= FW
Feb 19 20:55:08 debian kernel: mlan0: 1519073708.936709 : Data =>
kernel seq_num=7 tid=255
Feb 19 20:55:08 debian kernel: *
Feb 19 20:55:08 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:55:08 debian kernel: UPLD: rd_bitmap=0x00000020
Feb 19 20:55:08 debian kernel: mlan0: 1519073708.947504 : Data <= FW
Feb 19 20:55:08 debian kernel: mlan0: 1519073708.950931 : Data =>
kernel seq_num=8 tid=255
Feb 19 20:56:09 debian kernel: *
Feb 19 20:56:09 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:56:09 debian kernel: UPLD: rd_bitmap=0x00000040
Feb 19 20:56:09 debian kernel: mlan0: 1519073769.937673 : Data <= FW
Feb 19 20:56:09 debian kernel: mlan0: 1519073769.941106 : Data =>
kernel seq_num=9 tid=255
Feb 19 20:56:09 debian kernel: *
Feb 19 20:56:09 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:56:09 debian kernel: UPLD: rd_bitmap=0x00000080
Feb 19 20:56:09 debian kernel: mlan0: 1519073769.951917 : Data <= FW
Feb 19 20:56:09 debian kernel: mlan0: 1519073769.955362 : Data =>
kernel seq_num=10 tid=255
Feb 19 20:57:10 debian kernel: *
Feb 19 20:57:10 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:57:10 debian kernel: UPLD: rd_bitmap=0x00000100
Feb 19 20:57:10 debian kernel: mlan0: 1519073830.941545 : Data <= FW
Feb 19 20:57:10 debian kernel: mlan0: 1519073830.944997 : Data =>
kernel seq_num=20 tid=255
Feb 19 20:57:10 debian kernel: *
Feb 19 20:57:10 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:57:10 debian kernel: UPLD: rd_bitmap=0x00000200
Feb 19 20:57:10 debian kernel: mlan0: 1519073830.955895 : Data <= FW
Feb 19 20:57:10 debian kernel: mlan0: 1519073830.959322 : Data =>
kernel seq_num=21 tid=255
Feb 19 20:57:22 debian kernel: INFO: task ifplugd:932 blocked for more
than 120 seconds.
Feb 19 20:57:22 debian kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 19 20:57:22 debian kernel: ifplugd       D c03aca04     0   932      1
Feb 19 20:57:22 debian kernel: [<c03aca04>] (__schedule+0x34c/0x3d0)
from [<c03ad58c>] (__mutex_lock_slowpath+0x90/0x10c)
Feb 19 20:57:22 debian kernel: [<c03ad58c>]
(__mutex_lock_slowpath+0x90/0x10c) from [<c02fc5b8>]
(dev_ioctl+0x5a4/0x768)
Feb 19 20:57:22 debian kernel: [<c02fc5b8>] (dev_ioctl+0x5a4/0x768)
from [<c00abaf8>] (vfs_ioctl+0x2c/0x8c)
Feb 19 20:57:22 debian kernel: [<c00abaf8>] (vfs_ioctl+0x2c/0x8c) from
[<c00ac070>] (do_vfs_ioctl+0x518/0x568)
Feb 19 20:57:22 debian kernel: [<c00ac070>] (do_vfs_ioctl+0x518/0x568)
from [<c00ac0f4>] (sys_ioctl+0x34/0x54)
Feb 19 20:57:22 debian kernel: [<c00ac0f4>] (sys_ioctl+0x34/0x54) from
[<c002a920>] (ret_fast_syscall+0x0/0x2c)
Feb 19 20:57:58 debian kernel: *
Feb 19 20:57:58 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:57:58 debian kernel: UPLD: rd_bitmap=0x00000400
Feb 19 20:57:58 debian kernel: mlan0: 1519073878.475957 : Data <= FW
Feb 19 20:57:58 debian kernel: mlan0: 1519073878.479391 : Data =>
kernel seq_num=30 tid=255
Feb 19 20:58:11 debian kernel: *
Feb 19 20:58:11 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:58:11 debian kernel: UPLD: rd_bitmap=0x00000800
Feb 19 20:58:11 debian kernel: mlan0: 1519073891.945240 : Data <= FW
Feb 19 20:58:11 debian kernel: mlan0: 1519073891.948677 : Data =>
kernel seq_num=51 tid=255
Feb 19 20:58:11 debian kernel: *
Feb 19 20:58:11 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:58:11 debian kernel: UPLD: rd_bitmap=0x00001000
Feb 19 20:58:11 debian kernel: mlan0: 1519073891.959559 : Data <= FW
Feb 19 20:58:11 debian kernel: mlan0: 1519073891.963007 : Data =>
kernel seq_num=52 tid=255
root@debian:~/pmf# wlan_interrupt: sdio_ireg = 0x1
UPLD: rd_bitmap=0x00002000
mlan0: 1519073952.475830 : Data <= FW
mlan0: 1519073952.479264 : Data => kernel seq_num=69 tid=255
Feb 19 20:59:12 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:59:12 debian kernel: UPLD: rd_bitmap=0x00002000
Feb 19 20:59:12 debian kernel: mlan0: 1519073952.475830 : Data <= FW
Feb 19 20:59:12 debian kernel: mlan0: 1519073952.479264 : Data =>
kernel seq_num=69 tid=255
wlan_interrupt: sdio_ireg = 0x1
UPLD: rd_bitmap=0x00004000
mlan0: 1519073952.949142 : Data <= FW
mlan0: 1519073952.952592 : Data => kernel seq_num=74 tid=255
wlan_interrupt: sdio_ireg = 0x1
UPLD: rd_bitmap=0x00008000
mlan0: 1519073952.963471 : Data <= FW
mlan0: 1519073952.966903 : Data => kernel seq_num=75 tid=255
Feb 19 20:59:12 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:59:12 debian kernel: UPLD: rd_bitmap=0x00004000
Feb 19 20:59:12 debian kernel: mlan0: 1519073952.949142 : Data <= FW
Feb 19 20:59:12 debian kernel: mlan0: 1519073952.952592 : Data =>
kernel seq_num=74 tid=255
Feb 19 20:59:12 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 20:59:12 debian kernel: UPLD: rd_bitmap=0x00008000
Feb 19 20:59:12 debian kernel: mlan0: 1519073952.963471 : Data <= FW
Feb 19 20:59:12 debian kernel: mlan0: 1519073952.966903 : Data =>
kernel seq_num=75 tid=255
INFO: task ifplugd:932 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ifplugd       D c03aca04     0   932      1
[<c03aca04>] (__schedule+0x34c/0x3d0) from [<c03ad58c>]
(__mutex_lock_slowpath+0x90/0x10c)
[<c03ad58c>] (__mutex_lock_slowpath+0x90/0x10c) from [<c02fc5b8>]
(dev_ioctl+0x5a4/0x768)
[<c02fc5b8>] (dev_ioctl+0x5a4/0x768) from [<c00abaf8>] (vfs_ioctl+0x2c/0x8c)
[<c00abaf8>] (vfs_ioctl+0x2c/0x8c) from [<c00ac070>] (do_vfs_ioctl+0x518/0x568)
[<c00ac070>] (do_vfs_ioctl+0x518/0x568) from [<c00ac0f4>] (sys_ioctl+0x34/0x54)
[<c00ac0f4>] (sys_ioctl+0x34/0x54) from [<c002a920>] (ret_fast_syscall+0x0/0x2c)
Feb 19 20:59:22 debian kernel: ifplugd       D c03aca04     0   932      1
Feb 19 20:59:22 debian kernel: [<c03aca04>] (__schedule+0x34c/0x3d0)
from [<c03ad58c>] (__mutex_lock_slowpath+0x90/0x10c)
Feb 19 20:59:22 debian kernel: [<c03ad58c>]
(__mutex_lock_slowpath+0x90/0x10c) from [<c02fc5b8>]
(dev_ioctl+0x5a4/0x768)
Feb 19 20:59:22 debian kernel: [<c02fc5b8>] (dev_ioctl+0x5a4/0x768)
from [<c00abaf8>] (vfs_ioctl+0x2c/0x8c)
Feb 19 20:59:22 debian kernel: [<c00abaf8>] (vfs_ioctl+0x2c/0x8c) from
[<c00ac070>] (do_vfs_ioctl+0x518/0x568)
Feb 19 20:59:22 debian kernel: [<c00ac070>] (do_vfs_ioctl+0x518/0x568)
from [<c00ac0f4>] (sys_ioctl+0x34/0x54)
Feb 19 20:59:22 debian kernel: [<c00ac0f4>] (sys_ioctl+0x34/0x54) from
[<c002a920>] (ret_fast_syscall+0x0/0x2c)
wlan_interrupt: sdio_ireg = 0x1
UPLD: rd_bitmap=0x00000002
mlan0: 1519074013.952639 : Data <= FW
mlan0: 1519074013.956075 : Data => kernel seq_num=88 tid=255
wlan_interrupt: sdio_ireg = 0x1
UPLD: rd_bitmap=0x00000004
mlan0: 1519074013.966957 : Data <= FW
mlan0: 1519074013.970392 : Data => kernel seq_num=89 tid=255
Feb 19 21:00:13 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 21:00:13 debian kernel: UPLD: rd_bitmap=0x00000002
Feb 19 21:00:13 debian kernel: mlan0: 1519074013.952639 : Data <= FW
Feb 19 21:00:13 debian kernel: mlan0: 1519074013.956075 : Data =>
kernel seq_num=88 tid=255
Feb 19 21:00:13 debian kernel: wlan_interrupt: sdio_ireg = 0x1
Feb 19 21:00:13 debian kernel: UPLD: rd_bitmap=0x00000004
Feb 19 21:00:13 debian kernel: mlan0: 1519074013.966957 : Data <= FW
Feb 19 21:00:13 debian kernel: mlan0: 1519074013.970392 : Data =>
kernel seq_num=89 tid=255
----------------------------------------

Any Clues on what is happening?
Issue is not seen when BA neg is disabled from the AP side.

Regards
Neelansh
