Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38128 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbcGTUGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 16:06:49 -0400
Received: by mail-wm0-f52.google.com with SMTP id o80so84228566wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2016 13:06:48 -0700 (PDT)
From: Christopher Williamson <home@chrisaw.com>
In-Reply-To: <1469033825.3004.8.camel@redhat.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
 <1468946312.5661.2.camel@redhat.com> <CANXHH3kKV4m6rw9O=6x_QT2vwr7Tnx9EddpFq1VXfhnVdg9pFg@mail.gmail.com>
 <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
 <CANXHH3k3wSYYc2xS1rk9JqeWmekC+79YCYshMcXA-yz4rX_+Hw@mail.gmail.com>
 <1469033825.3004.8.camel@redhat.com> <1469033825.3004.8.camel@redhat.com>
MIME-Version: 1.0
Date: Wed, 20 Jul 2016 13:06:46 -0700
Message-ID: <CANXHH3minohF3z9bWc2NAghiU=w4DbsH1jU8iE8=v7H1pGdFcg@mail.gmail.com> (sfid-20160720_220712_358717_29BB830F)
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Ah - yeah I hadn’t thought it may be a kernel build option. I’ve now
built that and dmesg is a much more lively place!

I’ve provided output logs for both when the device is connected and
when a connection attempt is made - hopefully this is useful.

When I first connect the device:
root@nano:~# dmesg |grep libertas
[ 80.432144] libertas: module verification failed: signature and/or
required key missing - tainting kernel
[ 80.434563] libertas enter: lbs_init_module()
[ 80.434600] libertas leave: lbs_init_module()
[ 80.457044] libertas_sdio: Libertas SDIO driver
[ 80.457062] libertas_sdio: Copyright Pierre Ossman
[ 80.457782] libertas enter: lbs_add_card()
[ 80.457801] libertas enter: lbs_cfg_alloc()
[ 80.457875] libertas leave: lbs_cfg_alloc()
[ 80.457890] libertas enter: lbs_init_adapter()
[ 80.457905] libertas enter: lbs_allocate_cmd_buffer()
[ 80.458005] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458022] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458034] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458047] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458058] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458072] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458083] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458098] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458110] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458124] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458137] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458151] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458164] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458179] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458191] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458205] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458216] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458231] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458244] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 80.458259] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 80.458273] libertas leave: lbs_allocate_cmd_buffer(), ret 0
[ 80.458290] libertas leave: lbs_init_adapter(), ret 0
[ 80.458333] libertas thread: Starting main thread...
[ 80.458766] libertas enter: lbs_thread()
[ 80.458785] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 80.458802] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 80.458870] libertas leave: lbs_add_card(), priv f6700420
[ 81.020863] libertas enter: lbs_start_card()
[ 81.020880] libertas enter: lbs_update_hw_spec()
[ 81.020890] libertas enter: __lbs_cmd()
[ 81.020898] libertas enter: __lbs_cmd_async()
[ 81.020906] libertas enter: lbs_get_free_cmd_node()
[ 81.020915] libertas leave: lbs_get_free_cmd_node()
[ 81.020924] libertas host: PREP_CMD: command 0x0003
[ 81.020931] libertas enter: lbs_queue_cmd()
[ 81.020941] libertas host: QUEUE_CMD: inserted command 0x0003 into cmdpendingq
[ 81.020948] libertas leave: lbs_queue_cmd()
[ 81.020976] libertas leave: __lbs_cmd_async(), ret f64fc000
[ 81.021001] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.021014] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.021023] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.021032] libertas enter: lbs_execute_next_command()
[ 81.021041] libertas host: EXEC_NEXT_CMD: sending command 0x0003
[ 81.021049] libertas enter: lbs_submit_command()
[ 81.021059] libertas cmd: DNLD_CMD: command 0x0003, seq 1, size 46
[ 81.021089] libertas leave: lbs_submit_command()
[ 81.021098] libertas leave: lbs_execute_next_command()
[ 81.021107] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.021117] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.021443] libertas enter: lbs_host_to_card_done()
[ 81.021454] libertas leave: lbs_host_to_card_done()
[ 81.021763] libertas enter: lbs_notify_command_response()
[ 81.021786] libertas leave: lbs_notify_command_response()
[ 81.021799] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.021809] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.021818] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.021830] libertas enter: lbs_process_command_response()
[ 81.021846] libertas cmd: CMD_RESP: response 0x8003, seq 1, size 46
[ 81.021869] libertas leave: lbs_process_command_response(), ret 0
[ 81.021879] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.021888] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.021897] libertas leave: __lbs_cmd(), ret 0
[ 81.021908] libertas enter: lbs_execute_next_command()
[ 81.021922] libertas_sdio mmc1:0001:1 (unnamed net_device)
(uninitialized): 00:02:78:69:49:94, fw 9.70.20p0, cap 0x00000303
[ 81.021932] libertas cmd: GET_HW_SPEC: hardware interface 0x2,
hardware spec 0x0011
[ 81.021941] libertas leave: lbs_update_hw_spec()
[ 81.021949] libertas enter: lbs_get_tx_power()
[ 81.021957] libertas enter: __lbs_cmd()
[ 81.021965] libertas enter: __lbs_cmd_async()
[ 81.021973] libertas enter: lbs_get_free_cmd_node()
[ 81.021981] libertas leave: lbs_get_free_cmd_node()
[ 81.021990] libertas host: PREP_CMD: command 0x001e
[ 81.021998] libertas enter: lbs_queue_cmd()
[ 81.022006] libertas host: QUEUE_CMD: inserted command 0x001e into cmdpendingq
[ 81.022014] libertas leave: lbs_queue_cmd()
[ 81.022024] libertas leave: __lbs_cmd_async(), ret f64fc028
[ 81.022042] libertas host: EXEC_NEXT_CMD: sending command 0x001e
[ 81.022051] libertas enter: lbs_submit_command()
[ 81.022061] libertas cmd: DNLD_CMD: command 0x001e, seq 2, size 14
[ 81.022084] libertas leave: lbs_submit_command()
[ 81.022092] libertas leave: lbs_execute_next_command()
[ 81.022101] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.022111] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.022381] libertas enter: lbs_host_to_card_done()
[ 81.022393] libertas leave: lbs_host_to_card_done()
[ 81.022698] libertas enter: lbs_notify_command_response()
[ 81.022721] libertas leave: lbs_notify_command_response()
[ 81.022734] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.022744] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.022753] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.022764] libertas enter: lbs_process_command_response()
[ 81.022779] libertas cmd: CMD_RESP: response 0x801e, seq 2, size 14
[ 81.022801] libertas leave: lbs_process_command_response(), ret 0
[ 81.022812] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.022821] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.022829] libertas leave: __lbs_cmd(), ret 0
[ 81.022837] libertas leave: lbs_get_tx_power()
[ 81.022845] libertas enter: lbs_set_snmp_mib()
[ 81.022856] libertas cmd: SNMP_CMD: (set) oid 0x9, oid size 0x2, value 0x1
[ 81.022864] libertas enter: __lbs_cmd()
[ 81.022872] libertas enter: __lbs_cmd_async()
[ 81.022880] libertas enter: lbs_get_free_cmd_node()
[ 81.022888] libertas leave: lbs_get_free_cmd_node()
[ 81.022896] libertas host: PREP_CMD: command 0x0016
[ 81.022904] libertas enter: lbs_queue_cmd()
[ 81.022913] libertas host: QUEUE_CMD: inserted command 0x0016 into cmdpendingq
[ 81.022922] libertas leave: lbs_queue_cmd()
[ 81.022931] libertas leave: __lbs_cmd_async(), ret f64fc050
[ 81.022943] libertas enter: lbs_execute_next_command()
[ 81.022955] libertas host: EXEC_NEXT_CMD: sending command 0x0016
[ 81.022963] libertas enter: lbs_submit_command()
[ 81.022973] libertas cmd: DNLD_CMD: command 0x0016, seq 3, size 142
[ 81.022995] libertas leave: lbs_submit_command()
[ 81.023004] libertas leave: lbs_execute_next_command()
[ 81.023013] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.023023] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.023314] libertas enter: lbs_host_to_card_done()
[ 81.023325] libertas leave: lbs_host_to_card_done()
[ 81.023632] libertas enter: lbs_notify_command_response()
[ 81.023653] libertas leave: lbs_notify_command_response()
[ 81.023666] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.023676] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.023685] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.023696] libertas enter: lbs_process_command_response()
[ 81.023711] libertas cmd: CMD_RESP: response 0x8016, seq 3, size 142
[ 81.023732] libertas leave: lbs_process_command_response(), ret 0
[ 81.023743] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.023752] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.023760] libertas leave: __lbs_cmd(), ret 0
[ 81.023769] libertas leave: lbs_set_snmp_mib(), ret 0
[ 81.023777] libertas enter: lbs_set_mac_control_sync()
[ 81.023785] libertas enter: __lbs_cmd()
[ 81.023793] libertas enter: __lbs_cmd_async()
[ 81.023801] libertas enter: lbs_get_free_cmd_node()
[ 81.023810] libertas leave: lbs_get_free_cmd_node()
[ 81.023818] libertas host: PREP_CMD: command 0x0028
[ 81.023826] libertas enter: lbs_queue_cmd()
[ 81.023835] libertas host: QUEUE_CMD: inserted command 0x0028 into cmdpendingq
[ 81.023843] libertas leave: lbs_queue_cmd()
[ 81.023853] libertas leave: __lbs_cmd_async(), ret f64fc078
[ 81.023865] libertas enter: lbs_execute_next_command()
[ 81.023877] libertas host: EXEC_NEXT_CMD: sending command 0x0028
[ 81.023885] libertas enter: lbs_submit_command()
[ 81.023894] libertas cmd: DNLD_CMD: command 0x0028, seq 4, size 12
[ 81.023916] libertas leave: lbs_submit_command()
[ 81.023924] libertas leave: lbs_execute_next_command()
[ 81.023933] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.023943] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.024828] libertas enter: lbs_host_to_card_done()
[ 81.024840] libertas leave: lbs_host_to_card_done()
[ 81.025211] libertas enter: lbs_notify_command_response()
[ 81.025234] libertas leave: lbs_notify_command_response()
[ 81.025257] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.025271] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.025285] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.025299] libertas enter: lbs_process_command_response()
[ 81.025314] libertas cmd: CMD_RESP: response 0x8028, seq 4, size 12
[ 81.025341] libertas leave: lbs_process_command_response(), ret 0
[ 81.025356] libertas enter: lbs_execute_next_command()
[ 81.025367] libertas leave: lbs_execute_next_command()
[ 81.025381] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.025395] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.032568] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.032592] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.032607] libertas leave: __lbs_cmd(), ret 0
[ 81.032620] libertas leave: lbs_set_mac_control_sync()
[ 81.032636] libertas enter: lbs_init_mesh()
[ 81.032655] libertas cmd: mesh config action 0 type 0 channel 1 SSID
[ 81.032670] libertas enter: __lbs_mesh_config_send()
[ 81.032684] libertas enter: __lbs_cmd()
[ 81.032697] libertas enter: __lbs_cmd_async()
[ 81.032711] libertas enter: lbs_get_free_cmd_node()
[ 81.032725] libertas leave: lbs_get_free_cmd_node()
[ 81.032740] libertas host: PREP_CMD: command 0x00a3
[ 81.032753] libertas enter: lbs_queue_cmd()
[ 81.032768] libertas host: QUEUE_CMD: inserted command 0x00a3 into cmdpendingq
[ 81.032781] libertas leave: lbs_queue_cmd()
[ 81.032811] libertas leave: __lbs_cmd_async(), ret f64fc0a0
[ 81.034865] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.034879] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.034888] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.034903] libertas enter: lbs_execute_next_command()
[ 81.034911] libertas host: EXEC_NEXT_CMD: sending command 0x00a3
[ 81.034918] libertas enter: lbs_submit_command()
[ 81.034926] libertas cmd: DNLD_CMD: command 0x00a3, seq 5, size 144
[ 81.034955] libertas leave: lbs_submit_command()
[ 81.034963] libertas leave: lbs_execute_next_command()
[ 81.034971] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.034980] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.036280] libertas enter: lbs_host_to_card_done()
[ 81.036304] libertas leave: lbs_host_to_card_done()
[ 81.036579] libertas enter: lbs_notify_command_response()
[ 81.036601] libertas leave: lbs_notify_command_response()
[ 81.036610] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.036616] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.036622] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.036629] libertas enter: lbs_process_command_response()
[ 81.036640] libertas cmd: CMD_RESP: response 0x80a3, seq 5, size 144
[ 81.036650] libertas host: CMD_RESP: error 0x0002 in command reply 0x80a3
[ 81.036669] libertas leave: lbs_process_command_response(), ret -1
[ 81.036685] libertas_sdio mmc1:0001:1 (unnamed net_device)
(uninitialized): PREP_CMD: command 0x00a3 failed: 2
[ 81.036692] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.036700] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.036706] libertas leave: __lbs_cmd(), ret 2
[ 81.036708] libertas enter: lbs_execute_next_command()
[ 81.036713] libertas leave: lbs_execute_next_command()
[ 81.036719] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.036725] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.036736] libertas leave: __lbs_mesh_config_send()
[ 81.036745] libertas leave: lbs_init_mesh(), ret 0
[ 81.036753] libertas enter: lbs_cfg_register()
[ 81.037022] libertas enter: lbs_reg_notifier(cfg80211 regulatory
domain callback for domain 00
[ 81.037035] libertas leave: lbs_reg_notifier()
[ 81.044002] libertas enter: lbs_cfg_set_regulatory_hint()
[ 81.044067] libertas leave: lbs_cfg_set_regulatory_hint()
[ 81.044075] libertas leave: lbs_cfg_register(), ret 0
[ 81.044210] libertas_sdio mmc1:0001:1 wlan0: Marvell WLAN 802.11 adapter
[ 81.044220] libertas leave: lbs_start_card(), ret 0
[ 81.190920] libertas enter: lbs_dev_open()
[ 81.191574] libertas enter: __lbs_cmd()
[ 81.191586] libertas enter: __lbs_cmd_async()
[ 81.191594] libertas enter: lbs_get_free_cmd_node()
[ 81.191601] libertas leave: lbs_get_free_cmd_node()
[ 81.191609] libertas host: PREP_CMD: command 0x004d
[ 81.191616] libertas enter: lbs_queue_cmd()
[ 81.191623] libertas host: QUEUE_CMD: inserted command 0x004d into cmdpendingq
[ 81.191630] libertas leave: lbs_queue_cmd()
[ 81.191648] libertas leave: __lbs_cmd_async(), ret f64fc0c8
[ 81.191670] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.191679] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.191688] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.191697] libertas enter: lbs_execute_next_command()
[ 81.191705] libertas host: EXEC_NEXT_CMD: sending command 0x004d
[ 81.191712] libertas enter: lbs_submit_command()
[ 81.191720] libertas cmd: DNLD_CMD: command 0x004d, seq 6, size 16
[ 81.191745] libertas leave: lbs_submit_command()
[ 81.191753] libertas leave: lbs_execute_next_command()
[ 81.191762] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.191771] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.192089] libertas enter: lbs_host_to_card_done()
[ 81.192109] libertas leave: lbs_host_to_card_done()
[ 81.192405] libertas enter: lbs_notify_command_response()
[ 81.192424] libertas leave: lbs_notify_command_response()
[ 81.193309] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.193325] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.193334] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.193343] libertas enter: lbs_process_command_response()
[ 81.193354] libertas cmd: CMD_RESP: response 0x804d, seq 6, size 16
[ 81.193379] libertas leave: lbs_process_command_response(), ret 0
[ 81.193389] libertas enter: lbs_execute_next_command()
[ 81.193396] libertas leave: lbs_execute_next_command()
[ 81.193405] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.193415] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.193461] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.193472] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.193480] libertas leave: __lbs_cmd(), ret 0
[ 81.193489] libertas enter: lbs_set_snmp_mib()
[ 81.193497] libertas cmd: SNMP_CMD: (set) oid 0x0, oid size 0x1, value 0x1
[ 81.193504] libertas enter: __lbs_cmd()
[ 81.193511] libertas enter: __lbs_cmd_async()
[ 81.193517] libertas enter: lbs_get_free_cmd_node()
[ 81.193524] libertas leave: lbs_get_free_cmd_node()
[ 81.193531] libertas host: PREP_CMD: command 0x0016
[ 81.193537] libertas enter: lbs_queue_cmd()
[ 81.193545] libertas host: QUEUE_CMD: inserted command 0x0016 into cmdpendingq
[ 81.193551] libertas leave: lbs_queue_cmd()
[ 81.193568] libertas leave: __lbs_cmd_async(), ret f64fc0f0
[ 81.193589] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.193598] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.193606] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.193613] libertas enter: lbs_execute_next_command()
[ 81.193621] libertas host: EXEC_NEXT_CMD: sending command 0x0016
[ 81.193628] libertas enter: lbs_submit_command()
[ 81.193637] libertas cmd: DNLD_CMD: command 0x0016, seq 7, size 142
[ 81.193663] libertas leave: lbs_submit_command()
[ 81.193672] libertas leave: lbs_execute_next_command()
[ 81.193680] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.193688] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.193973] libertas enter: lbs_host_to_card_done()
[ 81.193982] libertas leave: lbs_host_to_card_done()
[ 81.194234] libertas enter: lbs_notify_command_response()
[ 81.194252] libertas leave: lbs_notify_command_response()
[ 81.194260] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.194266] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.194272] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.194279] libertas enter: lbs_process_command_response()
[ 81.194288] libertas cmd: CMD_RESP: response 0x8016, seq 7, size 142
[ 81.194309] libertas leave: lbs_process_command_response(), ret 0
[ 81.194318] libertas enter: lbs_execute_next_command()
[ 81.194325] libertas leave: lbs_execute_next_command()
[ 81.194334] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.194342] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.194360] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.194369] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.194376] libertas leave: __lbs_cmd(), ret 0
[ 81.194384] libertas leave: lbs_set_snmp_mib(), ret 0
[ 81.194391] libertas enter: lbs_set_11d_domain_info()
[ 81.194399] libertas 11d: Setting country code '00'
[ 81.194407] libertas 11d: 11D triplet (1, 14, 20)
[ 81.194414] libertas 11d: # triplets 1
[ 81.194421] libertas enter: __lbs_cmd()
[ 81.194431] libertas enter: __lbs_cmd_async()
[ 81.194438] libertas enter: lbs_get_free_cmd_node()
[ 81.194446] libertas leave: lbs_get_free_cmd_node()
[ 81.194455] libertas host: PREP_CMD: command 0x005b
[ 81.194462] libertas enter: lbs_queue_cmd()
[ 81.194469] libertas host: QUEUE_CMD: inserted command 0x005b into cmdpendingq
[ 81.194476] libertas leave: lbs_queue_cmd()
[ 81.194492] libertas leave: __lbs_cmd_async(), ret f64fc118
[ 81.194513] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.194521] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.194529] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.194536] libertas enter: lbs_execute_next_command()
[ 81.194544] libertas host: EXEC_NEXT_CMD: sending command 0x005b
[ 81.194551] libertas enter: lbs_submit_command()
[ 81.194559] libertas cmd: DNLD_CMD: command 0x005b, seq 8, size 20
[ 81.194581] libertas leave: lbs_submit_command()
[ 81.194590] libertas leave: lbs_execute_next_command()
[ 81.194599] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.194608] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.194824] libertas enter: lbs_host_to_card_done()
[ 81.194834] libertas leave: lbs_host_to_card_done()
[ 81.195297] libertas enter: lbs_notify_command_response()
[ 81.195317] libertas leave: lbs_notify_command_response()
[ 81.195326] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.195335] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.195342] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.195350] libertas enter: lbs_process_command_response()
[ 81.195358] libertas cmd: CMD_RESP: response 0x805b, seq 8, size 20
[ 81.195378] libertas leave: lbs_process_command_response(), ret 0
[ 81.195387] libertas enter: lbs_execute_next_command()
[ 81.195398] libertas leave: lbs_execute_next_command()
[ 81.195406] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.195414] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.195433] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.195443] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.195451] libertas leave: __lbs_cmd(), ret 0
[ 81.195458] libertas leave: lbs_set_11d_domain_info(), ret 0
[ 81.195466] libertas enter: lbs_update_channel()
[ 81.195472] libertas enter: lbs_get_channel()
[ 81.195479] libertas enter: __lbs_cmd()
[ 81.195486] libertas enter: __lbs_cmd_async()
[ 81.195492] libertas enter: lbs_get_free_cmd_node()
[ 81.195499] libertas leave: lbs_get_free_cmd_node()
[ 81.195506] libertas host: PREP_CMD: command 0x001d
[ 81.195513] libertas enter: lbs_queue_cmd()
[ 81.195520] libertas host: QUEUE_CMD: inserted command 0x001d into cmdpendingq
[ 81.195527] libertas leave: lbs_queue_cmd()
[ 81.195542] libertas leave: __lbs_cmd_async(), ret f64fc140
[ 81.195562] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.195571] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.195579] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.195586] libertas enter: lbs_execute_next_command()
[ 81.195594] libertas host: EXEC_NEXT_CMD: sending command 0x001d
[ 81.195601] libertas enter: lbs_submit_command()
[ 81.195610] libertas cmd: DNLD_CMD: command 0x001d, seq 9, size 48
[ 81.195629] libertas leave: lbs_submit_command()
[ 81.195636] libertas leave: lbs_execute_next_command()
[ 81.195644] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.195653] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.195876] libertas enter: lbs_host_to_card_done()
[ 81.195886] libertas leave: lbs_host_to_card_done()
[ 81.196217] libertas enter: lbs_notify_command_response()
[ 81.196245] libertas leave: lbs_notify_command_response()
[ 81.199478] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.199491] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.199500] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.199509] libertas enter: lbs_process_command_response()
[ 81.199518] libertas cmd: CMD_RESP: response 0x801d, seq 9, size 48
[ 81.199542] libertas leave: lbs_process_command_response(), ret 0
[ 81.199552] libertas enter: lbs_execute_next_command()
[ 81.199560] libertas leave: lbs_execute_next_command()
[ 81.199569] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.199579] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.199598] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.199608] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.199616] libertas leave: __lbs_cmd(), ret 0
[ 81.199623] libertas cmd: current radio channel is 1
[ 81.199630] libertas leave: lbs_get_channel(), ret 1
[ 81.199637] libertas leave: lbs_update_channel(), ret 0
[ 81.199662] libertas leave: lbs_dev_open(), ret 0
[ 81.202164] libertas enter: lbs_update_mcast()
[ 81.202179] libertas net (INT): mcast address wlan0:01:00:5e:00:00:01
added to filter
[ 81.202188] libertas enter: lbs_cmd_async()
[ 81.202195] libertas enter: __lbs_cmd_async()
[ 81.202202] libertas enter: lbs_get_free_cmd_node()
[ 81.202209] libertas leave: lbs_get_free_cmd_node()
[ 81.202217] libertas host: PREP_CMD: command 0x0010
[ 81.202223] libertas enter: lbs_queue_cmd()
[ 81.202231] libertas host: QUEUE_CMD: inserted command 0x0010 into cmdpendingq
[ 81.202238] libertas leave: lbs_queue_cmd()
[ 81.202256] libertas leave: __lbs_cmd_async(), ret f64fc168
[ 81.202268] libertas leave: lbs_cmd_async()
[ 81.202276] libertas enter: lbs_set_mac_control()
[ 81.202283] libertas enter: lbs_cmd_async()
[ 81.202290] libertas enter: __lbs_cmd_async()
[ 81.202297] libertas enter: lbs_get_free_cmd_node()
[ 81.202304] libertas leave: lbs_get_free_cmd_node()
[ 81.202311] libertas host: PREP_CMD: command 0x0028
[ 81.202317] libertas enter: lbs_queue_cmd()
[ 81.202325] libertas host: QUEUE_CMD: inserted command 0x0028 into cmdpendingq
[ 81.202332] libertas leave: lbs_queue_cmd()
[ 81.202340] libertas leave: __lbs_cmd_async(), ret f64fc000
[ 81.202347] libertas leave: lbs_cmd_async()
[ 81.202353] libertas leave: lbs_set_mac_control()
[ 81.202360] libertas leave: lbs_update_mcast()
[ 81.202631] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.202641] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.202650] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.202659] libertas enter: lbs_execute_next_command()
[ 81.202667] libertas host: EXEC_NEXT_CMD: sending command 0x0010
[ 81.202674] libertas enter: lbs_submit_command()
[ 81.202686] libertas cmd: DNLD_CMD: command 0x0010, seq 10, size 18
[ 81.202712] libertas leave: lbs_submit_command()
[ 81.202722] libertas leave: lbs_execute_next_command()
[ 81.202730] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.202739] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.203012] libertas enter: lbs_host_to_card_done()
[ 81.203024] libertas leave: lbs_host_to_card_done()
[ 81.203295] libertas enter: lbs_notify_command_response()
[ 81.203314] libertas leave: lbs_notify_command_response()
[ 81.203323] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.203329] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.203335] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.203343] libertas enter: lbs_process_command_response()
[ 81.203352] libertas cmd: CMD_RESP: response 0x8010, seq 10, size 18
[ 81.203361] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.203368] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.203375] libertas leave: lbs_process_command_response(), ret 0
[ 81.203383] libertas enter: lbs_execute_next_command()
[ 81.203390] libertas host: EXEC_NEXT_CMD: sending command 0x0028
[ 81.203397] libertas enter: lbs_submit_command()
[ 81.203405] libertas cmd: DNLD_CMD: command 0x0028, seq 11, size 12
[ 81.203428] libertas leave: lbs_submit_command()
[ 81.203436] libertas leave: lbs_execute_next_command()
[ 81.203444] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.203453] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.203671] libertas enter: lbs_host_to_card_done()
[ 81.203681] libertas leave: lbs_host_to_card_done()
[ 81.203937] libertas enter: lbs_notify_command_response()
[ 81.203959] libertas leave: lbs_notify_command_response()
[ 81.203970] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.203979] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.203987] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.203995] libertas enter: lbs_process_command_response()
[ 81.204053] libertas cmd: CMD_RESP: response 0x8028, seq 11, size 12
[ 81.204064] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.204072] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.204079] libertas leave: lbs_process_command_response(), ret 0
[ 81.204087] libertas enter: lbs_execute_next_command()
[ 81.204095] libertas leave: lbs_execute_next_command()
[ 81.204103] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.204112] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.310539] libertas enter: lbs_cfg_scan()
[ 81.310555] libertas enter: _internal_start_scan()
[ 81.310564] libertas scan: scan: ssids 1, channels 14, ie_len 0
[ 81.310575] libertas leave: _internal_start_scan()
[ 81.310582] libertas leave: lbs_cfg_scan(), ret 0
[ 81.360112] libertas enter: lbs_scan_worker()
[ 81.360135] libertas enter: __lbs_cmd()
[ 81.360143] libertas enter: __lbs_cmd_async()
[ 81.360150] libertas enter: lbs_get_free_cmd_node()
[ 81.360156] libertas leave: lbs_get_free_cmd_node()
[ 81.360164] libertas host: PREP_CMD: command 0x0006
[ 81.360170] libertas enter: lbs_queue_cmd()
[ 81.360177] libertas host: QUEUE_CMD: inserted command 0x0006 into cmdpendingq
[ 81.360184] libertas leave: lbs_queue_cmd()
[ 81.360203] libertas leave: __lbs_cmd_async(), ret f64fc028
[ 81.360219] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.360228] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.360236] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.360243] libertas enter: lbs_execute_next_command()
[ 81.360250] libertas host: EXEC_NEXT_CMD: sending command 0x0006
[ 81.360257] libertas enter: lbs_submit_command()
[ 81.360265] libertas cmd: DNLD_CMD: command 0x0006, seq 12, size 63
[ 81.360280] libertas leave: lbs_submit_command()
[ 81.360286] libertas leave: lbs_execute_next_command()
[ 81.360294] libertas thread: 1: currenttxskb (null), dnld_sent 2
[ 81.360302] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.360553] libertas enter: lbs_host_to_card_done()
[ 81.360562] libertas leave: lbs_host_to_card_done()
[ 81.552097] libertas enter: lbs_notify_command_response()
[ 81.552117] libertas leave: lbs_notify_command_response()
[ 81.552137] libertas thread: 2: currenttxskb (null), dnld_send 0
[ 81.552145] libertas thread: 3: currenttxskb (null), dnld_sent 0
[ 81.552152] libertas thread: 4: currenttxskb (null), dnld_sent 0
[ 81.552160] libertas enter: lbs_process_command_response()
[ 81.552169] libertas cmd: CMD_RESP: response 0x8006, seq 12, size 11
[ 81.552177] libertas enter: lbs_ret_scan()
[ 81.552185] libertas scan: scan response: 0 BSSs (0 bytes); resp size 11 bytes
[ 81.552193] libertas leave: lbs_ret_scan(), ret 0
[ 81.552210] libertas leave: lbs_process_command_response(), ret 0
[ 81.552218] libertas enter: lbs_execute_next_command()
[ 81.552225] libertas leave: lbs_execute_next_command()
[ 81.552232] libertas thread: 1: currenttxskb (null), dnld_sent 0
[ 81.552241] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[ 81.552256] libertas enter: __lbs_cleanup_and_insert_cmd()
[ 81.552264] libertas leave: __lbs_cleanup_and_insert_cmd()
[ 81.552271] libertas leave: __lbs_cmd(), ret 0
[ 81.552287] libertas leave: lbs_scan_worker()

When attempting to connect for the first time:

[  431.706610] libertas enter: lbs_update_mcast()
[  431.706629] libertas net (INT): mcast address
wlan0:01:00:5e:00:00:01 added to filter
[  431.706638] libertas enter: lbs_cmd_async()
[  431.706645] libertas enter: __lbs_cmd_async()
[  431.706653] libertas enter: lbs_get_free_cmd_node()
[  431.706660] libertas leave: lbs_get_free_cmd_node()
[  431.706668] libertas host: PREP_CMD: command 0x0010
[  431.706676] libertas enter: lbs_queue_cmd()
[  431.706683] libertas host: QUEUE_CMD: inserted command 0x0010 into
cmdpendingq
[  431.706690] libertas leave: lbs_queue_cmd()
[  431.706713] libertas leave: __lbs_cmd_async(), ret f64fc140
[  431.706721] libertas leave: lbs_cmd_async()
[  431.706728] libertas leave: lbs_update_mcast()
[  431.706749] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  431.706759] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  431.706768] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  431.706777] libertas enter: lbs_execute_next_command()
[  431.706785] libertas host: EXEC_NEXT_CMD: sending command 0x0010
[  431.706793] libertas enter: lbs_submit_command()
[  431.706801] libertas cmd: DNLD_CMD: command 0x0010, seq 59, size 18
[  431.706829] libertas leave: lbs_submit_command()
[  431.706837] libertas leave: lbs_execute_next_command()
[  431.706845] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  431.706854] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  431.710229] libertas enter: lbs_host_to_card_done()
[  431.710243] libertas leave: lbs_host_to_card_done()
[  431.710513] libertas enter: lbs_notify_command_response()
[  431.710534] libertas leave: lbs_notify_command_response()
[  431.710561] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  431.710571] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  431.710579] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  431.710588] libertas enter: lbs_process_command_response()
[  431.710598] libertas cmd: CMD_RESP: response 0x8010, seq 59, size 18
[  431.710608] libertas enter: __lbs_cleanup_and_insert_cmd()
[  431.710617] libertas leave: __lbs_cleanup_and_insert_cmd()
[  431.710626] libertas leave: lbs_process_command_response(), ret 0
[  431.710634] libertas enter: lbs_execute_next_command()
[  431.710641] libertas leave: lbs_execute_next_command()
[  431.710650] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  431.710659] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  431.768306] libertas enter: lbs_update_mcast()
[  431.768326] libertas net (INT): mcast address
wlan0:01:00:5e:00:00:01 added to filter
[  431.768335] libertas enter: lbs_cmd_async()
[  431.768342] libertas enter: __lbs_cmd_async()
[  431.768348] libertas enter: lbs_get_free_cmd_node()
[  431.768356] libertas leave: lbs_get_free_cmd_node()
[  431.768364] libertas host: PREP_CMD: command 0x0010
[  431.768370] libertas enter: lbs_queue_cmd()
[  431.768378] libertas host: QUEUE_CMD: inserted command 0x0010 into
cmdpendingq
[  431.768386] libertas leave: lbs_queue_cmd()
[  431.768404] libertas leave: __lbs_cmd_async(), ret f64fc168
[  431.768411] libertas leave: lbs_cmd_async()
[  431.768417] libertas leave: lbs_update_mcast()
[  431.768437] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  431.768446] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  431.768453] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  431.768461] libertas enter: lbs_execute_next_command()
[  431.768468] libertas host: EXEC_NEXT_CMD: sending command 0x0010
[  431.768474] libertas enter: lbs_submit_command()
[  431.768481] libertas cmd: DNLD_CMD: command 0x0010, seq 60, size 18
[  431.768507] libertas leave: lbs_submit_command()
[  431.768515] libertas leave: lbs_execute_next_command()
[  431.768523] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  431.768531] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  431.768815] libertas enter: lbs_host_to_card_done()
[  431.768828] libertas leave: lbs_host_to_card_done()
[  431.769108] libertas enter: lbs_notify_command_response()
[  431.769128] libertas leave: lbs_notify_command_response()
[  431.769151] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  431.769160] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  431.769168] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  431.769178] libertas enter: lbs_process_command_response()
[  431.769188] libertas cmd: CMD_RESP: response 0x8010, seq 60, size 18
[  431.769198] libertas enter: __lbs_cleanup_and_insert_cmd()
[  431.769207] libertas leave: __lbs_cleanup_and_insert_cmd()
[  431.769216] libertas leave: lbs_process_command_response(), ret 0
[  431.769225] libertas enter: lbs_execute_next_command()
[  431.769232] libertas leave: lbs_execute_next_command()
[  431.769241] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  431.769250] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  457.013027] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  457.026465] libertas enter: lbs_cfg_scan()
[  457.026483] libertas enter: _internal_start_scan()
[  457.026494] libertas scan: scan: ssids 1, channels 11, ie_len 0
[  457.026507] libertas leave: _internal_start_scan()
[  457.026515] libertas leave: lbs_cfg_scan(), ret 0
[  457.076189] libertas enter: lbs_scan_worker()
[  457.076218] libertas enter: __lbs_cmd()
[  457.076228] libertas enter: __lbs_cmd_async()
[  457.076235] libertas enter: lbs_get_free_cmd_node()
[  457.076241] libertas leave: lbs_get_free_cmd_node()
[  457.076249] libertas host: PREP_CMD: command 0x0006
[  457.076256] libertas enter: lbs_queue_cmd()
[  457.076263] libertas host: QUEUE_CMD: inserted command 0x0006 into
cmdpendingq
[  457.076269] libertas leave: lbs_queue_cmd()
[  457.076294] libertas leave: __lbs_cmd_async(), ret f64fc000
[  457.076315] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  457.076324] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  457.076332] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  457.076339] libertas enter: lbs_execute_next_command()
[  457.076344] libertas host: EXEC_NEXT_CMD: sending command 0x0006
[  457.076349] libertas enter: lbs_submit_command()
[  457.076356] libertas cmd: DNLD_CMD: command 0x0006, seq 61, size 63
[  457.076382] libertas leave: lbs_submit_command()
[  457.076388] libertas leave: lbs_execute_next_command()
[  457.076394] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  457.076400] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  457.076783] libertas enter: lbs_host_to_card_done()
[  457.076794] libertas leave: lbs_host_to_card_done()
[  457.273201] libertas enter: lbs_notify_command_response()
[  457.273236] libertas leave: lbs_notify_command_response()
[  457.273258] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  457.273272] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  457.273282] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  457.273292] libertas enter: lbs_process_command_response()
[  457.273304] libertas cmd: CMD_RESP: response 0x8006, seq 61, size 477
[  457.273314] libertas enter: lbs_ret_scan()
[  457.273325] libertas scan: scan response: 1 BSSs (454 bytes); resp
size 477 bytes
[  457.273342] libertas scan: scan: c4:07:2f:78:49:b8, capa 0411, chan
 1, TALKTALK7849B1, -75 dBm
[  457.273363] libertas leave: lbs_ret_scan(), ret 0
[  457.273388] libertas leave: lbs_process_command_response(), ret 0
[  457.273401] libertas enter: __lbs_cleanup_and_insert_cmd()
[  457.273414] libertas leave: __lbs_cleanup_and_insert_cmd()
[  457.273425] libertas leave: __lbs_cmd(), ret 0
[  457.273428] libertas enter: lbs_execute_next_command()
[  457.273437] libertas leave: lbs_execute_next_command()
[  457.273447] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  457.273458] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  457.273488] libertas leave: lbs_scan_worker()
[  457.376250] libertas enter: lbs_scan_worker()
[  457.376277] libertas enter: __lbs_cmd()
[  457.376284] libertas enter: __lbs_cmd_async()
[  457.376290] libertas enter: lbs_get_free_cmd_node()
[  457.376297] libertas leave: lbs_get_free_cmd_node()
[  457.376303] libertas host: PREP_CMD: command 0x0006
[  457.376310] libertas enter: lbs_queue_cmd()
[  457.376317] libertas host: QUEUE_CMD: inserted command 0x0006 into
cmdpendingq
[  457.376322] libertas leave: lbs_queue_cmd()
[  457.376347] libertas leave: __lbs_cmd_async(), ret f64fc028
[  457.376377] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  457.376389] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  457.376398] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  457.376405] libertas enter: lbs_execute_next_command()
[  457.376413] libertas host: EXEC_NEXT_CMD: sending command 0x0006
[  457.376419] libertas enter: lbs_submit_command()
[  457.376426] libertas cmd: DNLD_CMD: command 0x0006, seq 62, size 63
[  457.376455] libertas leave: lbs_submit_command()
[  457.376462] libertas leave: lbs_execute_next_command()
[  457.376469] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  457.376477] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  457.376886] libertas enter: lbs_host_to_card_done()
[  457.376897] libertas leave: lbs_host_to_card_done()
[  457.567200] libertas enter: lbs_notify_command_response()
[  457.567237] libertas leave: lbs_notify_command_response()
[  457.567265] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  457.567279] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  457.567289] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  457.567298] libertas enter: lbs_process_command_response()
[  457.567310] libertas cmd: CMD_RESP: response 0x8006, seq 62, size 840
[  457.567320] libertas enter: lbs_ret_scan()
[  457.567331] libertas scan: scan response: 3 BSSs (801 bytes); resp
size 840 bytes
[  457.567349] libertas scan: scan: 34:8a:ae:dd:44:80, capa 0431, chan
 6, BTHub4-95TR, -83 dBm
[  457.567377] libertas scan: scan: 34:8a:ae:dd:44:85, capa 0431, chan
 6, BTWifi-X, -83 dBm
[  457.567395] libertas scan: scan: 00:91:f9:4d:38:22, capa 0431, chan
 6, BTHub5-JKP3, -78 dBm
[  457.567410] libertas leave: lbs_ret_scan(), ret 0
[  457.567436] libertas leave: lbs_process_command_response(), ret 0
[  457.567449] libertas enter: __lbs_cleanup_and_insert_cmd()
[  457.567461] libertas leave: __lbs_cleanup_and_insert_cmd()
[  457.567472] libertas leave: __lbs_cmd(), ret 0
[  457.567476] libertas enter: lbs_execute_next_command()
[  457.567485] libertas leave: lbs_execute_next_command()
[  457.567495] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  457.567505] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  457.567536] libertas leave: lbs_scan_worker()
[  457.676215] libertas enter: lbs_scan_worker()
[  457.676238] libertas enter: __lbs_cmd()
[  457.676248] libertas enter: __lbs_cmd_async()
[  457.676256] libertas enter: lbs_get_free_cmd_node()
[  457.676264] libertas leave: lbs_get_free_cmd_node()
[  457.676271] libertas host: PREP_CMD: command 0x0006
[  457.676277] libertas enter: lbs_queue_cmd()
[  457.676284] libertas host: QUEUE_CMD: inserted command 0x0006 into
cmdpendingq
[  457.676289] libertas leave: lbs_queue_cmd()
[  457.676315] libertas leave: __lbs_cmd_async(), ret f64fc050
[  457.676343] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  457.676355] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  457.676363] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  457.676371] libertas enter: lbs_execute_next_command()
[  457.676378] libertas host: EXEC_NEXT_CMD: sending command 0x0006
[  457.676384] libertas enter: lbs_submit_command()
[  457.676391] libertas cmd: DNLD_CMD: command 0x0006, seq 63, size 56
[  457.676422] libertas leave: lbs_submit_command()
[  457.676429] libertas leave: lbs_execute_next_command()
[  457.676437] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  457.676445] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  457.676762] libertas enter: lbs_host_to_card_done()
[  457.676773] libertas leave: lbs_host_to_card_done()
[  457.828077] libertas enter: lbs_notify_command_response()
[  457.828108] libertas leave: lbs_notify_command_response()
[  457.828133] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  457.828143] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  457.828150] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  457.828158] libertas enter: lbs_process_command_response()
[  457.828167] libertas cmd: CMD_RESP: response 0x8006, seq 63, size 739
[  457.828175] libertas enter: lbs_ret_scan()
[  457.828183] libertas scan: scan response: 2 BSSs (708 bytes); resp
size 739 bytes
[  457.828196] libertas scan: scan: a0:63:91:1e:ee:43, capa 1411, chan
10, shaunthesheep, -72 dBm
[  457.828218] libertas scan: scan: a0:21:b7:cb:ad:8f, capa 0411, chan
11, PedersenVeseth, -83 dBm
[  457.828229] libertas leave: lbs_ret_scan(), ret 0
[  457.828250] libertas leave: lbs_process_command_response(), ret 0
[  457.828261] libertas enter: lbs_execute_next_command()
[  457.828264] libertas enter: __lbs_cleanup_and_insert_cmd()
[  457.828271] libertas leave: __lbs_cleanup_and_insert_cmd()
[  457.828278] libertas leave: __lbs_cmd(), ret 0
[  457.828289] libertas leave: lbs_execute_next_command()
[  457.828300] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  457.828308] libertas scan: scan: waking up waiters
[  457.828312] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  457.828325] libertas leave: lbs_scan_worker()
[  460.010490] libertas enter: lbs_cfg_scan()
[  460.010508] libertas enter: _internal_start_scan()
[  460.010518] libertas scan: scan: ssids 1, channels 11, ie_len 0
[  460.010530] libertas leave: _internal_start_scan()
[  460.010537] libertas leave: lbs_cfg_scan(), ret 0
[  460.060203] libertas enter: lbs_scan_worker()
[  460.060237] libertas enter: __lbs_cmd()
[  460.060248] libertas enter: __lbs_cmd_async()
[  460.060257] libertas enter: lbs_get_free_cmd_node()
[  460.060266] libertas leave: lbs_get_free_cmd_node()
[  460.060276] libertas host: PREP_CMD: command 0x0006
[  460.060284] libertas enter: lbs_queue_cmd()
[  460.060292] libertas host: QUEUE_CMD: inserted command 0x0006 into
cmdpendingq
[  460.060299] libertas leave: lbs_queue_cmd()
[  460.060323] libertas leave: __lbs_cmd_async(), ret f64fc078
[  460.060346] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  460.060358] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  460.060367] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  460.060375] libertas enter: lbs_execute_next_command()
[  460.060382] libertas host: EXEC_NEXT_CMD: sending command 0x0006
[  460.060388] libertas enter: lbs_submit_command()
[  460.060395] libertas cmd: DNLD_CMD: command 0x0006, seq 64, size 63
[  460.060425] libertas leave: lbs_submit_command()
[  460.060431] libertas leave: lbs_execute_next_command()
[  460.060439] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  460.060447] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  460.060854] libertas enter: lbs_host_to_card_done()
[  460.060865] libertas leave: lbs_host_to_card_done()
[  460.253091] libertas enter: lbs_notify_command_response()
[  460.253122] libertas leave: lbs_notify_command_response()
[  460.253143] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  460.253153] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  460.253161] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  460.253168] libertas enter: lbs_process_command_response()
[  460.253177] libertas cmd: CMD_RESP: response 0x8006, seq 64, size 477
[  460.253185] libertas enter: lbs_ret_scan()
[  460.253193] libertas scan: scan response: 1 BSSs (454 bytes); resp
size 477 bytes
[  460.253207] libertas scan: scan: c4:07:2f:78:49:b8, capa 0411, chan
 1, TALKTALK7849B1, -72 dBm
[  460.253225] libertas leave: lbs_ret_scan(), ret 0
[  460.253245] libertas leave: lbs_process_command_response(), ret 0
[  460.253255] libertas enter: __lbs_cleanup_and_insert_cmd()
[  460.253258] libertas enter: lbs_execute_next_command()
[  460.253271] libertas leave: __lbs_cleanup_and_insert_cmd()
[  460.253279] libertas leave: __lbs_cmd(), ret 0
[  460.253282] libertas leave: lbs_execute_next_command()
[  460.253290] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  460.253297] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  460.253321] libertas leave: lbs_scan_worker()
[  460.360214] libertas enter: lbs_scan_worker()
[  460.360243] libertas enter: __lbs_cmd()
[  460.360252] libertas enter: __lbs_cmd_async()
[  460.360259] libertas enter: lbs_get_free_cmd_node()
[  460.360266] libertas leave: lbs_get_free_cmd_node()
[  460.360273] libertas host: PREP_CMD: command 0x0006
[  460.360279] libertas enter: lbs_queue_cmd()
[  460.360286] libertas host: QUEUE_CMD: inserted command 0x0006 into
cmdpendingq
[  460.360292] libertas leave: lbs_queue_cmd()
[  460.360320] libertas leave: __lbs_cmd_async(), ret f64fc0a0
[  460.360343] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  460.360351] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  460.360359] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  460.360366] libertas enter: lbs_execute_next_command()
[  460.360372] libertas host: EXEC_NEXT_CMD: sending command 0x0006
[  460.360377] libertas enter: lbs_submit_command()
[  460.360383] libertas cmd: DNLD_CMD: command 0x0006, seq 65, size 63
[  460.360409] libertas leave: lbs_submit_command()
[  460.360414] libertas leave: lbs_execute_next_command()
[  460.360421] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  460.360427] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  460.360738] libertas enter: lbs_host_to_card_done()
[  460.360747] libertas leave: lbs_host_to_card_done()
[  460.557850] libertas enter: lbs_notify_command_response()
[  460.557877] libertas leave: lbs_notify_command_response()
[  460.557897] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  460.557905] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  460.557911] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  460.557917] libertas enter: lbs_process_command_response()
[  460.557925] libertas cmd: CMD_RESP: response 0x8006, seq 65, size 1245
[  460.557931] libertas enter: lbs_ret_scan()
[  460.557938] libertas scan: scan response: 5 BSSs (1190 bytes); resp
size 1245 bytes
[  460.557949] libertas scan: scan: 34:8a:ae:dd:44:80, capa 0431, chan
 6, BTHub4-95TR, -83 dBm
[  460.557968] libertas scan: scan: 00:91:f9:4d:38:22, capa 0431, chan
 6, BTHub5-JKP3, -79 dBm
[  460.557979] libertas scan: scan: 34:8a:ae:dd:44:83, capa 0421, chan
 6, BTWifi-with-FON, -84 dBm
[  460.557992] libertas scan: scan: e2:91:f9:4d:38:22, capa 0431, chan
 6, BTWifi-X, -79 dBm
[  460.558002] libertas scan: scan: 34:8a:ae:dd:44:85, capa 0431, chan
 6, BTWifi-X, -84 dBm
[  460.558009] libertas leave: lbs_ret_scan(), ret 0
[  460.558027] libertas leave: lbs_process_command_response(), ret 0
[  460.558036] libertas enter: lbs_execute_next_command()
[  460.558039] libertas enter: __lbs_cleanup_and_insert_cmd()
[  460.558044] libertas leave: __lbs_cleanup_and_insert_cmd()
[  460.558050] libertas leave: __lbs_cmd(), ret 0
[  460.558059] libertas leave: lbs_execute_next_command()
[  460.558065] libertas leave: lbs_scan_worker()
[  460.558072] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  460.558080] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  460.660187] libertas enter: lbs_scan_worker()
[  460.660209] libertas enter: __lbs_cmd()
[  460.660217] libertas enter: __lbs_cmd_async()
[  460.660224] libertas enter: lbs_get_free_cmd_node()
[  460.660244] libertas leave: lbs_get_free_cmd_node()
[  460.660264] libertas host: PREP_CMD: command 0x0006
[  460.660274] libertas enter: lbs_queue_cmd()
[  460.660287] libertas host: QUEUE_CMD: inserted command 0x0006 into
cmdpendingq
[  460.660298] libertas leave: lbs_queue_cmd()
[  460.660334] libertas leave: __lbs_cmd_async(), ret f64fc0c8
[  460.660361] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  460.660376] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  460.660388] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  460.660398] libertas enter: lbs_execute_next_command()
[  460.660407] libertas host: EXEC_NEXT_CMD: sending command 0x0006
[  460.660415] libertas enter: lbs_submit_command()
[  460.660425] libertas cmd: DNLD_CMD: command 0x0006, seq 66, size 56
[  460.660463] libertas leave: lbs_submit_command()
[  460.660472] libertas leave: lbs_execute_next_command()
[  460.660482] libertas thread: 1: currenttxskb   (null), dnld_sent 2
[  460.660492] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  460.660907] libertas enter: lbs_host_to_card_done()
[  460.660923] libertas leave: lbs_host_to_card_done()
[  460.808003] libertas enter: lbs_notify_command_response()
[  460.808033] libertas leave: lbs_notify_command_response()
[  460.808057] libertas thread: 2: currenttxskb   (null), dnld_send 0
[  460.808068] libertas thread: 3: currenttxskb   (null), dnld_sent 0
[  460.808078] libertas thread: 4: currenttxskb   (null), dnld_sent 0
[  460.808088] libertas enter: lbs_process_command_response()
[  460.808100] libertas cmd: CMD_RESP: response 0x8006, seq 66, size 643
[  460.808111] libertas enter: lbs_ret_scan()
[  460.808122] libertas scan: scan response: 2 BSSs (612 bytes); resp
size 643 bytes
[  460.808140] libertas scan: scan: a0:63:91:1e:ee:43, capa 1411, chan
10, shaunthesheep, -73 dBm
[  460.808167] libertas scan: scan: a0:21:b7:cb:ad:8f, capa 0411, chan
11, PedersenVeseth, -83 dBm
[  460.808183] libertas leave: lbs_ret_scan(), ret 0
[  460.808206] libertas leave: lbs_process_command_response(), ret 0
[  460.808216] libertas enter: __lbs_cleanup_and_insert_cmd()
[  460.808226] libertas leave: __lbs_cleanup_and_insert_cmd()
[  460.808234] libertas leave: __lbs_cmd(), ret 0
[  460.808237] libertas enter: lbs_execute_next_command()
[  460.808244] libertas leave: lbs_execute_next_command()
[  460.808251] libertas thread: 1: currenttxskb   (null), dnld_sent 0
[  460.808259] libertas thread: sleeping, connect_status 1, psmode 0, psstate 0
[  460.808298] libertas scan: scan: waking up waiters
[  460.808309] libertas leave: lbs_scan_worker()

Christopher Williamson




On 20 July 2016 at 17:57:07, Dan Williams
(dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:

> On Wed, 2016-07-20 at 02:53 -0700, Christopher Williamson wrote:
> > Just following up from my previous email:
> >
> > I am actually setting the reg domain using: iw reg set GB
> > (copy/pasted
> > the IN from elsewhere - oops!)
> >
> > As for progress, however, I have tried the following:
> >
> > - setting the debug level to 0xfffffff. This still produces no
> > additional output even with 8 set in printk.
>
> Yeah, looks like you'd need to rebuild the libertas driver with
> CONFIG_LIBERTAS_DEBUG set. Or just #define that to 1 in defs.h. Is
> that something you could do?
>
> Dan
>
> > - removing the v9 firmware - same result as before - system fully
> > locks up.
> >
> > - disabling ipv6 - gets rid of IPv6 interface not up warning but
> > that’s not causing any problems and this didn’t make any difference.
> >
> > It doesn’t seem to matter what I try at the moment - all attempts to
> > connect result in the system crashing which I guess is better than it
> > just asking me for a password over and over - it looks like it is
> > attempting association at this point which is good but I don’t know
> > why the box is crashing out and dmesg -w doesn’t show any additional
> > output before the freeze.
> >
> > If anyone has any more ideas I would be more than happy to try them!
> > Thanks for the help so far Dan!
> >
> > Christopher Williamson
> >
> > On 19 July 2016 at 18:41:34, Christopher Williamson
> > (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
> >
> > >
> > > So I’ve now disabled IPv6 and have set the GB (Great Britain)
> > > regulation code using:
> > >
> > > iw reg set IN
> > >
> > > Now when I try to connect to the network using wicd the system
> > > seems to crash - I guess at least it’s doing something more than
> > > just asking for the password again like it did with NetworkManager
> > > but so far no further progress on getting this working properly.
> > >
> > > Christopher Williamson
> > >
> > >
> > >
> > > On 19 July 2016 at 18:03:16, Christopher Williamson (home@chrisaw.c
> > > om(mailto:home@chrisaw.com)) wrote:
> > >
> > > >
> > > > Absolutely!
> > > >
> > > > With the debug logging enabled I got the following:
> > > >
> > > > Connecting the device initially with debug enabled:
> > > >
> > > > [ 205.302685] libertas_sdio: Libertas SDIO driver
> > > > [ 205.302698] libertas_sdio: Copyright Pierre Ossman
> > > > [ 205.503465] cfg80211: World regulatory domain updated:
> > > > [ 205.503478] cfg80211: DFS Master region: unset
> > > > [ 205.503483] cfg80211: (start_freq - end_freq @ bandwidth),
> > > > (max_antenna_gain, max_eirp), (dfs_cac_time)
> > > > [ 205.503492] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz),
> > > > (N/A, 2000 mBm), (N/A)
> > > > [ 205.503499] cfg80211: (2457000 KHz - 2482000 KHz @ 40000 KHz),
> > > > (N/A, 2000 mBm), (N/A)
> > > > [ 205.503505] cfg80211: (2474000 KHz - 2494000 KHz @ 20000 KHz),
> > > > (N/A, 2000 mBm), (N/A)
> > > > [ 205.503513] cfg80211: (5170000 KHz - 5250000 KHz @ 80000 KHz,
> > > > 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
> > > > [ 205.503522] cfg80211: (5250000 KHz - 5330000 KHz @ 80000 KHz,
> > > > 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
> > > > [ 205.503529] cfg80211: (5490000 KHz - 5730000 KHz @ 160000 KHz),
> > > > (N/A, 2000 mBm), (0 s)
> > > > [ 205.503535] cfg80211: (5735000 KHz - 5835000 KHz @ 80000 KHz),
> > > > (N/A, 2000 mBm), (N/A)
> > > > [ 205.503542] cfg80211: (57240000 KHz - 63720000 KHz @ 2160000
> > > > KHz), (N/A, 0 mBm), (N/A)
> > > > [ 212.249171] gma500 0000:00:02.0: Backlight lvds set brightness
> > > > 7a127a12
> > > > [ 212.324898] mmc1: new SDIO card at address 0001
> > > > [ 212.921672] libertas_sdio mmc1:0001:1 (unnamed net_device)
> > > > (uninitialized): 00:02:78:69:49:94, fw 9.70.20p0, cap 0x00000303
> > > > [ 212.925774] libertas_sdio mmc1:0001:1 (unnamed net_device)
> > > > (uninitialized): PREP_CMD: command 0x00a3 failed: 2
> > > > [ 212.936190] libertas_sdio mmc1:0001:1 wlan0: Marvell WLAN
> > > > 802.11 adapter
> > > > [ 213.053612] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > > >
> > > >
> > > > Strangely when I attempt to connect to the WiFi network I’m using
> > > > the only error I get is:
> > > >
> > > > [ 338.076632] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > > >
> > > > I was expecting more output and am guessing I’ve missed something
> > > > here.
> > > >
> > > > Christopher Williamson
> > > >
> > > > On 19 July 2016 at 17:38:35, Dan Williams (dcbw@redhat.com(mailto
> > > > :dcbw@redhat.com)) wrote:
> > > >
> > > > >
> > > > > On Tue, 2016-07-19 at 12:06 -0400, Christopher Williamson
> > > > > wrote:
> > > > > >
> > > > > > Hi everyone!
> > > > > >
> > > > > > I’ve just got myself a Viliv N5 and am trying to get the
> > > > > > integrated
> > > > > > Wifi chipset working on it.
> > > > > >
> > > > > > I am able to see networks around me but any attempts to
> > > > > > connect them
> > > > > > appear to time out and fail.
> > > > > >
> > > > > > I have filed a linux kernel bug related to this issue:
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=135421goo
> > > > > >
> > > > > > I figured here may be a good place to ask about it and
> > > > > > hopefully to
> > > > > > get to the bottom of why it happens and how I can help to fix
> > > > > > it.
> > > > > >
> > > > > > Happy to provide any information which may be helpful! :)
> > > > > Can you reload the driver stack:
> > > > >
> > > > > rmmod libertas_sdio
> > > > > rmmod libertas
> > > > > modprobe libertas libertas_debug=0x251e7ff
> > > > > modprobe libertas_sdio
> > > > >
> > > > > and then reproduce the issue? The debug info should dump to
> > > > > 'dmesg'
> > > > > and may tell us what's going on.
> > > > >
> > > > > Dan
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
