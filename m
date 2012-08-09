Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37148 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2HISRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:17:09 -0400
Received: by wibhm11 with SMTP id hm11so613239wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:17:08 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Aug 2012 13:17:08 -0500
Message-ID: <CALSu_Yo4Nm9WTXXG3ywFci0hvE+A=MLyQkbreZqNK-=tu_f3RQ@mail.gmail.com> (sfid-20120809_201715_972405_FA3C5956)
Subject: Palm T|X Libertas Wifi problems Kernel 3.4.7 stable
From: Joseph Honold <mozzwald@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to get wirless working on the Palm T|X (arm pxa270 cpu)
with the 3.4.7 stable kernel using the cocoboot bootloader app for
PalmOS. I have extracted the Libertas firmware with cocoboot and
placed it in the /lib/firmware dir.The kernel is booting fine to a
debian squeeze rootfs, the pxa2xx_pcmcia, libertas, and libertas_cs
modules load with no errors (as long as I do a wifi scan in PalmOS
before booting linux). When I scan with iwlist I get no results. Here
is a snippet of libertas debug messages. Does anyone have a suggestion
of what I could try to get it working? I can provide more info if
needed.

Aug  9 17:20:01 mozzwald kernel: libertas_cs enter: if_cs_init()
Aug  9 17:20:01 mozzwald kernel: libertas_cs leave: if_cs_init()
Aug  9 17:20:02 mozzwald kernel: libertas_cs enter: if_cs_probe()
Aug  9 17:20:02 mozzwald kernel: libertas_cs cs: irq 212, io [io
0xc2860000-0xc286007f]
Aug  9 17:20:02 mozzwald kernel: libertas_cs enter: if_cs_prog_helper()
Aug  9 17:20:02 mozzwald kernel: libertas_cs cs: helper size 2064
Aug  9 17:20:02 mozzwald kernel: libertas_cs leave: if_cs_prog_helper(), ret 0
Aug  9 17:20:02 mozzwald kernel: libertas_cs enter: if_cs_prog_real()
Aug  9 17:20:02 mozzwald kernel: libertas_cs cs: fw size 82876
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave: if_cs_prog_real(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_add_card()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_cfg_alloc()
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_cfg_alloc()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_init_adapter()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_allocate_cmd_buffer()
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cleanup_and_insert_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave: __lbs_cleanup_and_insert_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave:
lbs_allocate_cmd_buffer(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_init_adapter(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: Starting main thread...
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_thread()
Aug  9 17:20:03 mozzwald kernel: libertas thread: 1: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: sleeping,
connect_status 1, psmode 0, psstate 0
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_add_card(), priv c0694280
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter: if_cs_enable_ints()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_start_card()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_setup_firmware()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_update_hw_spec()
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cmd_async()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_get_free_cmd_node()
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_get_free_cmd_node()
Aug  9 17:20:03 mozzwald kernel: libertas host: PREP_CMD: command 0x0003
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_queue_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas host: QUEUE_CMD: inserted
command 0x0003 into cmdpendingq
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_queue_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave: __lbs_cmd_async(), ret c1bf5600
Aug  9 17:20:03 mozzwald kernel: libertas thread: 2: currenttxskb
(null), dnld_send 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: 3: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: 4: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_execute_next_command()
Aug  9 17:20:03 mozzwald kernel: libertas host: EXEC_NEXT_CMD: sending
command 0x0003
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_submit_command()
Aug  9 17:20:03 mozzwald kernel: libertas cmd: DNLD_CMD: command
0x0003, seq 1, size 46
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter:
if_cs_host_to_card(type 1, bytes 46)
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter: if_cs_send_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter: if_cs_disable_ints()
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter: if_cs_enable_ints()
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave: if_cs_send_cmd(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave: if_cs_host_to_card(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_submit_command()
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_execute_next_command()
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter (INT): if_cs_interrupt()
Aug  9 17:20:03 mozzwald kernel: libertas_cs cs (INT): cause 0x0008
Aug  9 17:20:03 mozzwald kernel: libertas_cs cs (INT): cmd resp
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter (INT): if_cs_receive_cmdres()
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave (INT):
if_cs_receive_cmdres(), ret 0, len 46
Aug  9 17:20:03 mozzwald kernel: libertas enter (INT):
lbs_notify_command_response()
Aug  9 17:20:03 mozzwald kernel: libertas leave (INT):
lbs_notify_command_response()
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave (INT): if_cs_interrupt()
Aug  9 17:20:03 mozzwald kernel: libertas thread: 1: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: 2: currenttxskb
(null), dnld_send 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: 3: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: 4: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_process_command_response()
Aug  9 17:20:03 mozzwald kernel: libertas cmd: CMD_RESP: response
0x8003, seq 1, size 46
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cleanup_and_insert_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave: __lbs_cleanup_and_insert_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave: __lbs_cmd(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas cmd: GET_HW_SPEC: hardware
interface 0x2, hardware spec 0x0004
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_update_hw_spec()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_get_tx_power()
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cmd_async()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_get_free_cmd_node()
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_get_free_cmd_node()
Aug  9 17:20:03 mozzwald kernel: libertas host: PREP_CMD: command 0x001e
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_queue_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas host: QUEUE_CMD: inserted
command 0x001e into cmdpendingq
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_queue_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave: __lbs_cmd_async(), ret c1bf5624
Aug  9 17:20:03 mozzwald kernel: libertas leave:
lbs_process_command_response(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_execute_next_command()
Aug  9 17:20:03 mozzwald kernel: libertas host: EXEC_NEXT_CMD: sending
command 0x001e
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_submit_command()
Aug  9 17:20:03 mozzwald kernel: libertas cmd: DNLD_CMD: command
0x001e, seq 2, size 14
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter:
if_cs_host_to_card(type 1, bytes 14)
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter: if_cs_send_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter: if_cs_disable_ints()
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter: if_cs_enable_ints()
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave: if_cs_send_cmd(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave: if_cs_host_to_card(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_submit_command()
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_execute_next_command()
Aug  9 17:20:03 mozzwald kernel: libertas thread: 1: currenttxskb
(null), dnld_sent 2
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter (INT): if_cs_interrupt()
Aug  9 17:20:03 mozzwald kernel: libertas_cs cs (INT): cause 0x0008
Aug  9 17:20:03 mozzwald kernel: libertas_cs cs (INT): cmd resp
Aug  9 17:20:03 mozzwald kernel: libertas_cs enter (INT): if_cs_receive_cmdres()
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave (INT):
if_cs_receive_cmdres(), ret 0, len 14
Aug  9 17:20:03 mozzwald kernel: libertas enter (INT):
lbs_notify_command_response()
Aug  9 17:20:03 mozzwald kernel: libertas leave (INT):
lbs_notify_command_response()
Aug  9 17:20:03 mozzwald kernel: libertas_cs leave (INT): if_cs_interrupt()
Aug  9 17:20:03 mozzwald kernel: libertas thread: 2: currenttxskb
(null), dnld_send 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: 3: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas thread: 4: currenttxskb
(null), dnld_sent 0
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_process_command_response()
Aug  9 17:20:03 mozzwald kernel: libertas cmd: CMD_RESP: response
0x801e, seq 2, size 14
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cleanup_and_insert_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave: __lbs_cleanup_and_insert_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas leave: __lbs_cmd(), ret 0
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_get_tx_power()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_set_snmp_mib()
Aug  9 17:20:03 mozzwald kernel: libertas cmd: SNMP_CMD: (set) oid
0x9, oid size 0x2, value 0x1
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cmd()
Aug  9 17:20:03 mozzwald kernel: libertas enter: __lbs_cmd_async()
Aug  9 17:20:03 mozzwald kernel: libertas enter: lbs_get_free_cmd_node()
Aug  9 17:20:03 mozzwald kernel: libertas leave: lbs_get_free_cmd_node()
Aug  9 17:20:03 mozzwald kernel: libertas host: PREP_CMD: command 0x0016

--
Joe Honold
http://www.mozzwald.com
