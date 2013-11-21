Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:49001 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3KUXvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 18:51:11 -0500
Received: by mail-lb0-f175.google.com with SMTP id x18so374102lbi.6
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2013 15:51:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEk6gTAR5O8SAK9-tcr9nXujGpZN9HciYXg5y4CBQYVFWnKHYA@mail.gmail.com>
References: <CAEk6gTB2as8XccgY3E9MBTXRCmKwLk9+9KzNx5YFqEz0L3A3tw@mail.gmail.com>
	<CAEk6gTDkn19tK9wz1k8apnw6LZpsE1wPVqQOGq+uvkqY7LfdjA@mail.gmail.com>
	<CAEk6gTAR5O8SAK9-tcr9nXujGpZN9HciYXg5y4CBQYVFWnKHYA@mail.gmail.com>
Date: Fri, 22 Nov 2013 00:51:07 +0100
Message-ID: <CAEk6gTB+X2F616MaphZYEMdrx8c9eYnuE=aU1_U-8J8cBtdaQQ@mail.gmail.com> (sfid-20131122_005116_149227_4E9DD786)
Subject: Re: AP mode with hostapd
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
For the future reference, discussion on this ath6kl problem (potential
firmware bug) is continued here:
http://www.spinics.net/lists/linux-wireless/msg115085.html

Best regards,
Drasko


On Tue, Nov 19, 2013 at 12:18 PM, Drasko DRASKOVIC
<drasko.draskovic@gmail.com> wrote:
> Hi all,
> debugging further (still without solution), I am adding ftrace log of
> this bug (below).
>
> BR,
> Drasko
>
> root@socfpga_cyclone5:~# cat /sys/kernel/debug/tracing/trace
> # tracer: function
> #
> # entries-in-buffer/entries-written: 949/949   #P:2
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>          hostapd-1749  [001] ....  4423.224819: cfg80211_change_iface
> <-nl80211_set_interface
>          hostapd-1749  [001] ....  4423.224829:
> ath6kl_cfg80211_change_iface <-cfg80211_change_iface
>          hostapd-1749  [001] ....  4423.224832: ath6kl_dbg
> <-ath6kl_cfg80211_change_iface
>          hostapd-1749  [001] ....  4423.224835: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.224856: ath6kl_log_dbg:
> ath6kl_cfg80211_change_iface: type 3
>
>          hostapd-1749  [001] ....  4423.224863:
> ath6kl_cfg80211_sta_bmiss_enhance <-ath6kl_cfg80211_change_iface
>          hostapd-1749  [001] ....  4423.225622:
> cfg80211_mlme_register_mgmt <-nl80211_register_mgmt
>          hostapd-1749  [001] ..s.  4423.225627:
> ath6kl_mgmt_frame_register <-cfg80211_mlme_register_mgmt
>          hostapd-1749  [001] ..s.  4423.225629: ath6kl_dbg
> <-ath6kl_mgmt_frame_register
>          hostapd-1749  [001] ..s.  4423.225631: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.225646: ath6kl_log_dbg:
> ath6kl_mgmt_frame_register: frame_type=0xd0 reg=1
>
>          hostapd-1749  [001] ....  4423.226143:
> cfg80211_mlme_register_mgmt <-nl80211_register_mgmt
>          hostapd-1749  [001] ..s.  4423.226148:
> ath6kl_mgmt_frame_register <-cfg80211_mlme_register_mgmt
>          hostapd-1749  [001] ..s.  4423.226150: ath6kl_dbg
> <-ath6kl_mgmt_frame_register
>          hostapd-1749  [001] ..s.  4423.226151: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226164: ath6kl_log_dbg:
> ath6kl_mgmt_frame_register: frame_type=0x40 reg=1
>
>          hostapd-1749  [001] ....  4423.226209:
> cfg80211_netdev_notifier_call <-notifier_call_chain
>          hostapd-1749  [001] ....  4423.226212:
> cfg80211_can_use_iftype_chan <-cfg80211_netdev_notifier_call
>          hostapd-1749  [001] ....  4423.226221: ath6kl_open <-__dev_open
>          hostapd-1749  [001] ..s.  4423.226224:
> ath6kl_set_multicast_list <-__dev_set_rx_mode
>          hostapd-1749  [001] ..s.  4423.226226: ath6kl_dbg
> <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226227: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226236: ath6kl_log_dbg:
> disabling multicast-all filter
>
>          hostapd-1749  [001] ..s.  4423.226240:
> ath6kl_wmi_mcast_filter_cmd <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226241: ath6kl_buf_alloc
> <-ath6kl_wmi_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226244: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226246: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226248: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226256: ath6kl_log_dbg: wmi tx
> id 61481 len 1 flag 0
>
>          hostapd-1749  [001] ..s.  4423.226261: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226272: ath6kl_log_dbg_dump: wmi tx /
>
>          hostapd-1749  [001] ..s.  4423.226275: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226277: ath6kl_wmi_cmd: id 61481 len 7
>          hostapd-1749  [001] ..s.  4423.226279: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226281: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226290: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbf0f7540, len=0x7 eid =1
>
>          hostapd-1749  [001] ..s.  4423.226295: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226298: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226300: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [001] ..s.  4423.226301: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226309: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf3f977e, length: 7
>
>          hostapd-1749  [001] ..s.  4423.226314: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226316: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226323: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bcd8 depth:1)
>
>          hostapd-1749  [001] ..s.  4423.226329: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226330: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226338: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11ce60 , queue depth:
> 1
>
>          hostapd-1749  [001] ..s.  4423.226342: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226343: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226350: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>          hostapd-1749  [001] ..s.  4423.226354: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226355: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226362: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>          hostapd-1749  [001] ..s.  4423.226365: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226366: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226374: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbed4bc98, pkts 1
>
>          hostapd-1749  [001] ..s.  4423.226378: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226380: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226385: ath6kl_log_dbg: hif pipe send
>
>          hostapd-1749  [001] ..s.  4423.226388: ath6kl_usb_send <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226389: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [001] ..s.  4423.226391: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226400: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbf0f7540
>
>          hostapd-1749  [001] ..s.  4423.226405:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>          hostapd-1749  [001] ..s.  4423.226409: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [001] ..s.  4423.226410: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226420: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 13 bytes
>
>          hostapd-1749  [001] ..s.  4423.226446: ath6kl_dbg
> <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226448: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226458: ath6kl_log_dbg:
> Removing 01:00:5e:00:00:01 from multicast filter
>
>          hostapd-1749  [001] ..s.  4423.226462:
> ath6kl_wmi_add_del_mcast_filter_cmd <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226464: ath6kl_buf_alloc
> <-ath6kl_wmi_add_del_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226467: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_add_del_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226468: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226470: ath6kl_printk <-ath6kl_dbg
>           <idle>-0     [000] d.H.  4423.226471:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>           <idle>-0     [000] d.H.  4423.226474: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>           <idle>-0     [000] d.H.  4423.226476: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226487: ath6kl_log_dbg: wmi tx
> id 61466 len 6 flag 0
>
>           <idle>-0     [000] d.H.  4423.226490: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
>
>          hostapd-1749  [001] ..s.  4423.226492: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>           <idle>-0     [000] d.H.  4423.226496:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [001] ..s.  4423.226501: ath6kl_log_dbg_dump: wmi tx /
>
>          hostapd-1749  [001] ..s.  4423.226503: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226504: ath6kl_wmi_cmd: id 61466 len 12
>          hostapd-1749  [001] ..s.  4423.226506: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226508: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226517: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbf0f7600, len=0xc eid =1
>
>          hostapd-1749  [001] ..s.  4423.226522: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>           <idle>-0     [000] dNH.  4423.226523:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [001] ..s.  4423.226524: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>           <idle>-0     [000] dNH.  4423.226525: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>          hostapd-1749  [001] ..s.  4423.226525: ath6kl_dbg <-ath6kl_htc_pipe_tx
>           <idle>-0     [000] dNH.  4423.226526: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226527: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226541: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf3f99be, length: 12
>
>           <idle>-0     [000] dNH.  4423.226544: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf3e9500
>
>          hostapd-1749  [001] ..s.  4423.226545: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226547: ath6kl_printk <-ath6kl_dbg
>           <idle>-0     [000] dNH.  4423.226552:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>          hostapd-1749  [001] ..s.  4423.226554: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bcc8 depth:1)
>
>          hostapd-1749  [001] ..s.  4423.226559: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226560: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226569: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cbb4 , queue depth:
> 1
>
>          hostapd-1749  [001] ..s.  4423.226573: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226574: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226581: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>          hostapd-1749  [001] ..s.  4423.226592:
> ath6kl_set_multicast_list <-__dev_set_rx_mode
>          hostapd-1749  [001] ..s.  4423.226594: ath6kl_dbg
> <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226595: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226603: ath6kl_log_dbg:
> disabling multicast-all filter
>
>          hostapd-1749  [001] ..s.  4423.226606:
> ath6kl_wmi_mcast_filter_cmd <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226607: ath6kl_buf_alloc
> <-ath6kl_wmi_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226609: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226611: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226612: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226621: ath6kl_log_dbg: wmi tx
> id 61481 len 1 flag 0
>
>          hostapd-1749  [001] ..s.  4423.226625: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226634: ath6kl_log_dbg_dump: wmi tx /
>
>          hostapd-1749  [001] ..s.  4423.226638: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226639: ath6kl_wmi_cmd: id 61481 len 7
>          hostapd-1749  [001] ..s.  4423.226642: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226644: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226652: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbf0f7300, len=0x7 eid =1
>
>          hostapd-1749  [001] ..s.  4423.226656: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226658: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>      kworker/0:1-29    [000] ....  4423.226658:
> ath6kl_usb_io_comp_work <-process_one_work
>          hostapd-1749  [001] ..s.  4423.226659: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [001] ..s.  4423.226661: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226662: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.226663: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226674: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbf0f7540
>
>          hostapd-1749  [001] ..s.  4423.226676: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf3f9bfe, length: 7
>
>      kworker/0:1-29    [000] ....  4423.226677:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.226679:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>          hostapd-1749  [001] ..s.  4423.226680: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226682: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226682: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.226683: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226693: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.226697: ath6kl_tx_complete
> <-do_send_completion
>          hostapd-1749  [001] ..s.  4423.226698: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bcf8 depth:1)
>
>      kworker/0:1-29    [000] ..s.  4423.226701:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>          hostapd-1749  [001] ..s.  4423.226702: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.226703: ath6kl_dbg <-ath6kl_tx_complete
>          hostapd-1749  [001] ..s.  4423.226704: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.226704: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.226716: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbf0f7540 data=0xbf3f977e len=0x7 eid=1 OK
>
>          hostapd-1749  [001] ..s.  4423.226719: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cbb4 , queue depth:
> 2
>
>      kworker/0:1-29    [000] ..s.  4423.226722: ath6kl_free_cookie
> <-ath6kl_tx_complete
>          hostapd-1749  [001] ..s.  4423.226723: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226725: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226728:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.226730: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.226731: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226732: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>      kworker/0:1-29    [000] ....  4423.226739: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3e6240
>
>      kworker/0:1-29    [000] ....  4423.226742:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.226744:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ....  4423.226747: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ....  4423.226747: ath6kl_get_stats <-dev_get_stats
>      kworker/0:1-29    [000] ....  4423.226749: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226756: ath6kl_log_dbg:
> htc_try_send: (queue:0x  (null) depth:0)
>
>      kworker/0:1-29    [000] ..s.  4423.226761: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ....  4423.226762:
> cfg80211_netdev_notifier_call <-notifier_call_chain
>      kworker/0:1-29    [000] ..s.  4423.226762: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.226766:
> cfg80211_update_iface_num <-cfg80211_netdev_notifier_call
>      kworker/0:1-29    [000] ..s.  4423.226770: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cbb4 , queue depth:
> 2
>
>      kworker/0:1-29    [000] ..s.  4423.226774: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226774:
> ath6kl_set_multicast_list <-__dev_set_rx_mode
>      kworker/0:1-29    [000] ..s.  4423.226775: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226776: ath6kl_dbg
> <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226777: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226786: ath6kl_log_dbg:
> disabling multicast-all filter
>
>      kworker/0:1-29    [000] ..s.  4423.226788: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>          hostapd-1749  [001] ..s.  4423.226788:
> ath6kl_wmi_mcast_filter_cmd <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226790: ath6kl_buf_alloc
> <-ath6kl_wmi_mcast_filter_cmd
>      kworker/0:1-29    [000] ..s.  4423.226791: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226792: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_mcast_filter_cmd
>      kworker/0:1-29    [000] ..s.  4423.226793: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226793: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226795: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226803: ath6kl_log_dbg: wmi tx
> id 61481 len 1 flag 0
>
>      kworker/0:1-29    [000] ..s.  4423.226805: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>          hostapd-1749  [001] ..s.  4423.226807: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>      kworker/0:1-29    [000] ..s.  4423.226808: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.226809: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.226818: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cc00 , queue depth:
> 1
>
>          hostapd-1749  [001] ..s.  4423.226822: ath6kl_log_dbg_dump: wmi tx /
>
>      kworker/0:1-29    [000] ..s.  4423.226822: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.226824: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226824: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226825: ath6kl_wmi_cmd: id 61481 len 7
>          hostapd-1749  [001] ..s.  4423.226827: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226829: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.226837: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>          hostapd-1749  [001] ..s.  4423.226838: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbf0f7f00, len=0x7 eid =1
>
>      kworker/0:1-29    [000] ....  4423.226840: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.226842: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226842: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226844: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226845: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [001] ..s.  4423.226847: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226854: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf3f9e3e, length: 7
>
>      kworker/0:1-29    [000] ....  4423.226855: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbf9b7e08, pkts 1
>
>          hostapd-1749  [001] ..s.  4423.226858: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226859: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226860: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.226861: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226868: ath6kl_log_dbg: hif pipe send
>
>          hostapd-1749  [001] ..s.  4423.226870: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bb88 depth:1)
>
>      kworker/0:1-29    [000] ....  4423.226870: ath6kl_usb_send <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.226872: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.226873: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226875: ath6kl_dbg
> <-ath6kl_set_multicast_list
>          hostapd-1749  [001] ..s.  4423.226877: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226883: ath6kl_log_dbg: Adding
> 01:00:5e:00:00:01 to multicast filter list
>
>          hostapd-1749  [001] ..s.  4423.226886:
> ath6kl_wmi_add_del_mcast_filter_cmd <-ath6kl_set_multicast_list
>      kworker/0:1-29    [000] ....  4423.226887: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbf0f7600
>
>          hostapd-1749  [001] ..s.  4423.226888: ath6kl_buf_alloc
> <-ath6kl_wmi_add_del_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226890: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_add_del_mcast_filter_cmd
>          hostapd-1749  [001] ..s.  4423.226891: ath6kl_dbg <-ath6kl_wmi_cmd_send
>      kworker/0:1-29    [000] ....  4423.226891:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>          hostapd-1749  [001] ..s.  4423.226893: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226894: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.226896: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.226905: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 18 bytes
>
>          hostapd-1749  [001] ..s.  4423.226907: ath6kl_log_dbg: wmi tx
> id 61465 len 6 flag 0
>
>          hostapd-1749  [001] ..s.  4423.226911: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ..s.  4423.226920: ath6kl_log_dbg_dump: wmi tx /
>
>          hostapd-1749  [001] ..s.  4423.226922: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>      kworker/0:1-29    [000] ..s.  4423.226922: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226923: ath6kl_wmi_cmd: id 61465 len 12
>      kworker/0:1-29    [000] ..s.  4423.226924: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226925: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226926: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226937: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbf0f73c0, len=0xc eid =1
>
>          hostapd-1749  [001] ..s.  4423.226941: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226944: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.226945: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [001] ..s.  4423.226946: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.226953:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [001] ..s.  4423.226955: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf3fa07e, length: 12
>
>      kworker/0:1-29    [000] d.H.  4423.226955: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.226957: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226959: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.226961: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.226969: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bb78 depth:1)
>
>      kworker/0:1-29    [000] d.H.  4423.226972: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:18
>
>      kworker/0:1-29    [000] d.H.  4423.226977:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.226992:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>      kworker/0:1-29    [000] d.H.  4423.226994: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] d.H.  4423.226995: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227006: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf3e9a00
>
>      kworker/0:1-29    [000] d.H.  4423.227013:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] ..s.  4423.227026: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cc00 , queue depth:
> 2
>
>      kworker/0:1-29    [000] ..s.  4423.227031: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227033: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227041: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>          hostapd-1749  [001] ..s.  4423.227046: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.227048: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.227057: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cc00 , queue depth:
> 3
>
>          hostapd-1749  [001] ..s.  4423.227061: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.227063: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.227070: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>      kworker/0:1-29    [000] ..s.  4423.227074: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.227076: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227083: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>      kworker/0:1-29    [000] ....  4423.227092: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.227094: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227102: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3e6300
>
>      kworker/0:1-29    [000] ....  4423.227105:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.227107:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ....  4423.227109: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.227111: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227118: ath6kl_log_dbg:
> htc_try_send: (queue:0x  (null) depth:0)
>
>      kworker/0:1-29    [000] ..s.  4423.227123: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227124: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227132: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cc00 , queue depth:
> 3
>
>      kworker/0:1-29    [000] ..s.  4423.227136: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227137: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227152: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>      kworker/0:1-29    [000] ..s.  4423.227157: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227159: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227166: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>      kworker/0:1-29    [000] ..s.  4423.227169: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227170: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227177: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11ce60 , queue depth:
> 2
>
>      kworker/0:1-29    [000] ..s.  4423.227181: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227183: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227190: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>      kworker/0:1-29    [000] ....  4423.227194: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.227195: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227202: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbf9b7e08, pkts 1
>
>      kworker/0:1-29    [000] ....  4423.227207: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.227210: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227216: ath6kl_log_dbg: hif pipe send
>
>      kworker/0:1-29    [000] ....  4423.227218: ath6kl_usb_send <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.227220: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.227221: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227229: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbf0f7300
>
>      kworker/0:1-29    [000] ....  4423.227233:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.227235: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.227237: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227249: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 13 bytes
>
>      kworker/0:1-29    [000] ..s.  4423.227271: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227274: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227296:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>      kworker/0:1-29    [000] d.H.  4423.227298: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.227300: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227309: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
>
>      kworker/0:1-29    [000] d.H.  4423.227314:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.227332:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>      kworker/0:1-29    [000] d.H.  4423.227334: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] d.H.  4423.227336: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227346: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf3e9780
>
>      kworker/0:1-29    [000] d.H.  4423.227352:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] d.H.  4423.227355:
> ath6kl_usb_post_recv_transfers.constprop.6 <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] d.H.  4423.227357:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227360: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227362: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227372: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed12a80
>
>      kworker/0:1-29    [000] d.H.  4423.227386:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227389: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227391: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227402: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed12900
>
>      kworker/0:1-29    [000] d.H.  4423.227419:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227422: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227423: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227434: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed12840
>
>      kworker/0:1-29    [000] d.H.  4423.227448:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227451: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227453: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227463: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed12b40
>
>      kworker/0:1-29    [000] d.H.  4423.227476:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227479: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227481: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227495: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed12f00
>
>      kworker/0:1-29    [000] d.H.  4423.227514:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227525: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227526: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227538: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed12c00
>
>      kworker/0:1-29    [000] d.H.  4423.227550:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227554: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227555: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227566: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed12000
>
>      kworker/0:1-29    [000] d.H.  4423.227577:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227580: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227581: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227591: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbed120c0
>
>      kworker/0:1-29    [000] d.H.  4423.227606:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227612: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227613: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227623: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf353e40
>
>      kworker/0:1-29    [000] d.H.  4423.227634:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227637: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227641: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227651: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf3533c0
>
>      kworker/0:1-29    [000] d.H.  4423.227662:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227665: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227667: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227676: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf353300
>
>      kworker/0:1-29    [000] d.H.  4423.227688:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227691: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227692: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227702: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf353d80
>
>      kworker/0:1-29    [000] d.H.  4423.227712:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227715: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227716: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227725: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf353a80
>
>      kworker/0:1-29    [000] d.H.  4423.227737:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227739: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227741: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227750: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf353c00
>
>      kworker/0:1-29    [000] d.H.  4423.227761:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227764: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227766: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227775: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf353540
>
>      kworker/0:1-29    [000] d.H.  4423.227789:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227792: ath6kl_dbg
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] d.H.  4423.227793: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.227802: ath6kl_log_dbg: ath6kl
> usb: bulk recv submit:5, 0xC0410380 (ep:0x82), 1700 bytes
> buf:0xbf353900
>
>      kworker/0:1-29    [000] d.H.  4423.227816:
> ath6kl_usb_alloc_urb_from_pipe
> <-ath6kl_usb_post_recv_transfers.constprop.6
>      kworker/0:1-29    [000] ..s.  4423.227866: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11ce60 , queue depth:
> 2
>
>      kworker/0:1-29    [000] ..s.  4423.227873: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227875: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227886: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>      kworker/0:1-29    [000] ..s.  4423.227896: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.227898: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227906: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>      kworker/0:1-29    [000] ....  4423.227913: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.227915: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227922: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3e6b40
>
>      kworker/0:1-29    [000] ....  4423.227926:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.227927:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ....  4423.227930: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.227931: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.227938: ath6kl_log_dbg:
> htc_try_send: (queue:0x  (null) depth:0)
>
>      kworker/0:1-29    [000] ..s.  4423.227942: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227944: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227952: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11ce60 , queue depth:
> 2
>
>      kworker/0:1-29    [000] ..s.  4423.227956: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227957: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227964: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>      kworker/0:1-29    [000] ..s.  4423.227968: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227969: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227975: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>      kworker/0:1-29    [000] ..s.  4423.227980: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227981: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.227989: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cb1c , queue depth:
> 1
>
>      kworker/0:1-29    [000] ..s.  4423.227992: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.227994: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228001: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>      kworker/0:1-29    [000] ....  4423.228005: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.228006: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228013: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbf9b7e08, pkts 1
>
>      kworker/0:1-29    [000] ....  4423.228018: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.228019: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228025: ath6kl_log_dbg: hif pipe send
>
>      kworker/0:1-29    [000] ....  4423.228028: ath6kl_usb_send <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.228029: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.228031: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228038: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbf0f7f00
>
>      kworker/0:1-29    [000] ....  4423.228042:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.228044: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.228046: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228055: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 13 bytes
>
>      kworker/0:1-29    [000] ..s.  4423.228072: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.228074: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.228093:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>      kworker/0:1-29    [000] d.H.  4423.228095: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.228096: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.228106: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
>
>      kworker/0:1-29    [000] d.H.  4423.228111:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.228132:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>      kworker/0:1-29    [000] d.H.  4423.228134: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] d.H.  4423.228135: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.228145: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf3e9680
>
>      kworker/0:1-29    [000] d.H.  4423.228153:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] ..s.  4423.228166: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cb1c , queue depth:
> 1
>
>      kworker/0:1-29    [000] ..s.  4423.228172: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.228174: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228182: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:0
>
>      kworker/0:1-29    [000] ..s.  4423.228187: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.228189: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228200: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>      kworker/0:1-29    [000] ....  4423.228280: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228283: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228293: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3d80c0
>
>      kworker/0:1-29    [000] ....  4423.228296:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228298:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ....  4423.228300: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.228302: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228309: ath6kl_log_dbg:
> htc_try_send: (queue:0x  (null) depth:0)
>
>      kworker/0:1-29    [000] ..s.  4423.228313: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.228315: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228322: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cb1c , queue depth:
> 1
>
>      kworker/0:1-29    [000] ..s.  4423.228326: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.228327: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228336: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>      kworker/0:1-29    [000] ..s.  4423.228340: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ..s.  4423.228341: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228348: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>      kworker/0:1-29    [000] ....  4423.228351: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.228352: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228359: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbf9b7e08, pkts 1
>
>      kworker/0:1-29    [000] ....  4423.228364: ath6kl_dbg <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.228365: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228371: ath6kl_log_dbg: hif pipe send
>
>      kworker/0:1-29    [000] ....  4423.228373: ath6kl_usb_send <-htc_try_send
>      kworker/0:1-29    [000] ....  4423.228374: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.228376: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228383: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbf0f73c0
>
>      kworker/0:1-29    [000] ....  4423.228387:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.228389: ath6kl_dbg <-ath6kl_usb_send
>      kworker/0:1-29    [000] ....  4423.228390: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228399: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 18 bytes
>
>      kworker/0:1-29    [000] ..s.  4423.228416: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.228418: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.228436:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>      kworker/0:1-29    [000] d.H.  4423.228438: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.228439: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.228449: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:18
>
>      kworker/0:1-29    [000] d.H.  4423.228454:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>      kworker/0:1-29    [000] d.H.  4423.228475:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>      kworker/0:1-29    [000] d.H.  4423.228476: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] d.H.  4423.228478: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] d.H.  4423.228488: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf3e9a80
>
>      kworker/0:1-29    [000] d.H.  4423.228494:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] ..s.  4423.228507: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>      kworker/0:1-29    [000] ....  4423.228513: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228515: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228522: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3680c0
>
>      kworker/0:1-29    [000] ....  4423.228525:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228527:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.228529: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.228530: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228537: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>      kworker/0:1-29    [000] ....  4423.228543:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.228545: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228546: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228553: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbf0f7600
>
>      kworker/0:1-29    [000] ....  4423.228556:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228557:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>      kworker/0:1-29    [000] ....  4423.228560: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.228561: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228570: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.228574: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.228576:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228578: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228580: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228589: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbf0f7600 data=0xbf3f99be len=0xc eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.228594: ath6kl_free_cookie
> <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ....  4423.228599: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228601: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228609: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbf0f7300
>
>      kworker/0:1-29    [000] ....  4423.228612:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228614:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>      kworker/0:1-29    [000] ....  4423.228616: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.228617: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228625: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.228629: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.228631:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228632: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228634: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228642: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbf0f7300 data=0xbf3f9bfe len=0x7 eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.228647: ath6kl_free_cookie
> <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ....  4423.228651: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228652: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228659: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbf0f7f00
>
>      kworker/0:1-29    [000] ....  4423.228662:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228663:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>      kworker/0:1-29    [000] ....  4423.228665: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.228666: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228674: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.228677: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.228679:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228681: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228682: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228691: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbf0f7f00 data=0xbf3f9e3e len=0x7 eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.228696: ath6kl_free_cookie
> <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ....  4423.228699: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228701: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228707: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbf0f73c0
>
>      kworker/0:1-29    [000] ....  4423.228709:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.228711:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>      kworker/0:1-29    [000] ....  4423.228713: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.228714: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.228721: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.228725: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.228727:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228728: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.228730: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.228738: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbf0f73c0 data=0xbf3fa07e len=0xc eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.228743: ath6kl_free_cookie
> <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ....  4423.228747:
> ath6kl_usb_io_comp_work <-process_one_work
>          hostapd-1749  [000] ....  4423.230401:
> cfg80211_chandef_create <-nl80211_parse_chandef
>          hostapd-1749  [000] ....  4423.230405: cfg80211_chandef_valid
> <-nl80211_parse_chandef
>          hostapd-1749  [000] ....  4423.230407:
> cfg80211_chandef_usable <-nl80211_parse_chandef
>          hostapd-1749  [000] ....  4423.230408: cfg80211_chandef_valid
> <-cfg80211_chandef_usable
>          hostapd-1749  [000] ....  4423.232952: ath6kl_del_station
> <-nl80211_del_station
>          hostapd-1749  [000] ....  4423.232957: ath6kl_wmi_ap_set_mlme
> <-ath6kl_del_station
>          hostapd-1749  [000] ....  4423.232958: ath6kl_buf_alloc
> <-ath6kl_wmi_ap_set_mlme
>          hostapd-1749  [000] ....  4423.232961: ath6kl_dbg
> <-ath6kl_wmi_ap_set_mlme
>          hostapd-1749  [000] ....  4423.232964: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.232980: ath6kl_log_dbg:
> ap_set_mlme: cmd=3 reason=2
>
>          hostapd-1749  [000] ....  4423.232986: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_ap_set_mlme
>          hostapd-1749  [000] ....  4423.232988: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ....  4423.232989: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.232998: ath6kl_log_dbg: wmi tx
> id 61456 len 9 flag 0
>
>          hostapd-1749  [000] ....  4423.233003: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ....  4423.233015: ath6kl_log_dbg_dump: wmi tx /
>
>          hostapd-1749  [000] ....  4423.233018: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ....  4423.233020: ath6kl_wmi_cmd: id 61456 len 15
>          hostapd-1749  [000] ..s.  4423.233022: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [000] ..s.  4423.233024: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233034: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbec89300, len=0xf eid =1
>
>          hostapd-1749  [000] ..s.  4423.233040: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>          hostapd-1749  [000] ....  4423.233043: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>          hostapd-1749  [000] ....  4423.233045: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [000] ....  4423.233046: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233056: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbed1df7e, length: 15
>
>          hostapd-1749  [000] ....  4423.233060: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ....  4423.233062: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233071: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bb38 depth:1)
>
>          hostapd-1749  [000] ..s.  4423.233076: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.233078: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233086: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cb1c , queue depth:
> 1
>
>          hostapd-1749  [000] ..s.  4423.233091: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.233092: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233099: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>          hostapd-1749  [000] ..s.  4423.233103: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.233105: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233111: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>          hostapd-1749  [000] ....  4423.233114: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ....  4423.233116: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233123: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbed4baf8, pkts 1
>
>          hostapd-1749  [000] ....  4423.233127: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ....  4423.233129: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233134: ath6kl_log_dbg: hif pipe send
>
>          hostapd-1749  [000] ....  4423.233137: ath6kl_usb_send <-htc_try_send
>          hostapd-1749  [000] ....  4423.233139: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [000] ....  4423.233140: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233148: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbec89300
>
>          hostapd-1749  [000] ....  4423.233152:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>          hostapd-1749  [000] ....  4423.233156: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [000] ....  4423.233157: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233166: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 21 bytes
>
>          hostapd-1749  [000] d.h.  4423.233215:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [000] d.h.  4423.233217: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [000] d.h.  4423.233219: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] d.h.  4423.233231: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:21
>
>          hostapd-1749  [000] d.h.  4423.233237:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [000] dNh.  4423.233271:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [000] dNh.  4423.233274: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>          hostapd-1749  [000] dNh.  4423.233275: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] dNh.  4423.233288: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf3e9f00
>
>          hostapd-1749  [000] dNh.  4423.233297:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] ....  4423.233335:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.233338: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233339: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.233350: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbec89300
>
>      kworker/0:1-29    [000] ....  4423.233353:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233355:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>      kworker/0:1-29    [000] ....  4423.233358: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.233359: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.233368: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.233373: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.233376:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.233378: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.233380: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.233390: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbec89300 data=0xbed1df7e len=0xf eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.233396: ath6kl_free_cookie
> <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ....  4423.233402:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.233404: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233405: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.233413: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3f5600
>
>      kworker/0:1-29    [000] ....  4423.233416:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233418:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.233420: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.233421: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.233430: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>          hostapd-1749  [000] ....  4423.233587: ath6kl_del_station
> <-nl80211_del_station
>          hostapd-1749  [000] ....  4423.233590: ath6kl_wmi_ap_set_mlme
> <-ath6kl_del_station
>          hostapd-1749  [000] ....  4423.233591: ath6kl_buf_alloc
> <-ath6kl_wmi_ap_set_mlme
>          hostapd-1749  [000] ....  4423.233594: ath6kl_dbg
> <-ath6kl_wmi_ap_set_mlme
>          hostapd-1749  [000] ....  4423.233596: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233609: ath6kl_log_dbg:
> ap_set_mlme: cmd=3 reason=2
>
>          hostapd-1749  [000] ....  4423.233615: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_ap_set_mlme
>          hostapd-1749  [000] ....  4423.233617: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ....  4423.233618: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233626: ath6kl_log_dbg: wmi tx
> id 61456 len 9 flag 0
>
>          hostapd-1749  [000] ....  4423.233630: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ....  4423.233641: ath6kl_log_dbg_dump: wmi tx /
>
>          hostapd-1749  [000] ....  4423.233644: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ....  4423.233645: ath6kl_wmi_cmd: id 61456 len 15
>          hostapd-1749  [000] ..s.  4423.233647: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [000] ..s.  4423.233649: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233658: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbec89780, len=0xf eid =1
>
>          hostapd-1749  [000] ..s.  4423.233663: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>          hostapd-1749  [000] ....  4423.233665: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>          hostapd-1749  [000] ....  4423.233667: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [000] ....  4423.233668: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233677: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbed1e1be, length: 15
>
>          hostapd-1749  [000] ....  4423.233682: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ....  4423.233683: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233691: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bb38 depth:1)
>
>          hostapd-1749  [000] ..s.  4423.233695: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.233697: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233705: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cb1c , queue depth:
> 1
>
>          hostapd-1749  [000] ..s.  4423.233709: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.233710: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233717: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>          hostapd-1749  [000] ..s.  4423.233721: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.233722: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.233728: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>          hostapd-1749  [000] ....  4423.233731: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ....  4423.233733: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233740: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbed4baf8, pkts 1
>
>          hostapd-1749  [000] ....  4423.233744: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ....  4423.233745: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233751: ath6kl_log_dbg: hif pipe send
>
>          hostapd-1749  [000] ....  4423.233753: ath6kl_usb_send <-htc_try_send
>          hostapd-1749  [000] ....  4423.233755: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [000] ....  4423.233756: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233763: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbec89780
>
>          hostapd-1749  [000] ....  4423.233767:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>          hostapd-1749  [000] ....  4423.233771: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [000] ....  4423.233772: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.233781: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 21 bytes
>
>          hostapd-1749  [000] d.h.  4423.233820:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [000] d.h.  4423.233822: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [000] d.h.  4423.233824: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] d.h.  4423.233835: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:21
>
>          hostapd-1749  [000] d.h.  4423.233840:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [000] dNh.  4423.233862:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [000] dNh.  4423.233864: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>          hostapd-1749  [000] dNh.  4423.233865: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] dNh.  4423.233878: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf359480
>
>          hostapd-1749  [000] dNh.  4423.233886:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] ....  4423.233908:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.233910: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233911: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.233920: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbec89780
>
>      kworker/0:1-29    [000] ....  4423.233923:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233925:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>      kworker/0:1-29    [000] ....  4423.233927: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.233929: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.233937: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.233941: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.233944:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.233946: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.233947: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.233957: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbec89780 data=0xbed1e1be len=0xf eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.233962: ath6kl_free_cookie
> <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ....  4423.233968:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.233969: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233971: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.233978: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3f56c0
>
>      kworker/0:1-29    [000] ....  4423.233981:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.233983:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.233985: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.233986: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.233993: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>          hostapd-1749  [000] ....  4423.234243:
> ath6kl_cfg80211_del_key <-nl80211_del_key
>          hostapd-1749  [000] ....  4423.234246: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234248: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234261: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 0
>
>          hostapd-1749  [000] ....  4423.234265: ath6kl_cfg80211_ready
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234267: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234268: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234276: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 0 is empty
>
>          hostapd-1749  [000] ....  4423.234405:
> ath6kl_cfg80211_del_key <-nl80211_del_key
>          hostapd-1749  [000] ....  4423.234408: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234410: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234421: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 1
>
>          hostapd-1749  [000] ....  4423.234425: ath6kl_cfg80211_ready
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234426: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234428: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234435: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 1 is empty
>
>          hostapd-1749  [000] ....  4423.234556:
> ath6kl_cfg80211_del_key <-nl80211_del_key
>          hostapd-1749  [000] ....  4423.234558: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234560: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234571: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 2
>
>          hostapd-1749  [000] ....  4423.234575: ath6kl_cfg80211_ready
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234576: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234578: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234585: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 2 is empty
>
>          hostapd-1749  [000] ....  4423.234700:
> ath6kl_cfg80211_del_key <-nl80211_del_key
>          hostapd-1749  [000] ....  4423.234703: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234705: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234715: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 3
>
>          hostapd-1749  [000] ....  4423.234719: ath6kl_cfg80211_ready
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234721: ath6kl_dbg
> <-ath6kl_cfg80211_del_key
>          hostapd-1749  [000] ....  4423.234722: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ....  4423.234730: ath6kl_log_dbg:
> ath6kl_cfg80211_del_key: index 3 is empty
>
>          hostapd-1749  [000] ....  4423.277937: cfg80211_stop_ap
> <-nl80211_stop_ap
>          hostapd-1749  [000] ..s.  4423.327934:
> ath6kl_set_multicast_list <-__dev_set_rx_mode
>          hostapd-1749  [000] ..s.  4423.327939: ath6kl_dbg
> <-ath6kl_set_multicast_list
>          hostapd-1749  [000] ..s.  4423.327943: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.327958: ath6kl_log_dbg:
> disabling multicast-all filter
>
>          hostapd-1749  [000] ..s.  4423.327963:
> ath6kl_wmi_mcast_filter_cmd <-ath6kl_set_multicast_list
>          hostapd-1749  [000] ..s.  4423.327965: ath6kl_buf_alloc
> <-ath6kl_wmi_mcast_filter_cmd
>          hostapd-1749  [000] ..s.  4423.327968: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_mcast_filter_cmd
>          hostapd-1749  [000] ..s.  4423.327970: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ..s.  4423.327971: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.327983: ath6kl_log_dbg: wmi tx
> id 61481 len 1 flag 0
>
>          hostapd-1749  [000] ..s.  4423.327987: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ..s.  4423.327998: ath6kl_log_dbg_dump: wmi tx /
>
>          hostapd-1749  [000] ..s.  4423.328002: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>          hostapd-1749  [000] ..s.  4423.328004: ath6kl_wmi_cmd: id 61481 len 7
>          hostapd-1749  [000] ..s.  4423.328006: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [000] ..s.  4423.328007: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328017: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbec89f00, len=0x7 eid =1
>
>          hostapd-1749  [000] ..s.  4423.328022: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>          hostapd-1749  [000] ..s.  4423.328025: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>          hostapd-1749  [000] ..s.  4423.328026: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [000] ..s.  4423.328028: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328037: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf189cbe, length: 7
>
>          hostapd-1749  [000] ..s.  4423.328042: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.328043: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328051: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bcf8 depth:1)
>
>          hostapd-1749  [000] ..s.  4423.328055: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.328057: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328065: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cb1c , queue depth:
> 1
>
>          hostapd-1749  [000] ..s.  4423.328069: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.328070: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328077: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>          hostapd-1749  [000] ..s.  4423.328081: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.328082: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328088: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>          hostapd-1749  [000] ..s.  4423.328091: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.328093: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328100: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbed4bcb8, pkts 1
>
>          hostapd-1749  [000] ..s.  4423.328104: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.328106: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328111: ath6kl_log_dbg: hif pipe send
>
>          hostapd-1749  [000] ..s.  4423.328113: ath6kl_usb_send <-htc_try_send
>          hostapd-1749  [000] ..s.  4423.328115: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [000] ..s.  4423.328116: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328124: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbec89f00
>
>          hostapd-1749  [000] ..s.  4423.328128:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>          hostapd-1749  [000] ..s.  4423.328132: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [000] ..s.  4423.328133: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] ..s.  4423.328143: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 13 bytes
>
>          hostapd-1749  [000] ....  4423.328169:
> cfg80211_netdev_notifier_call <-notifier_call_chain
>          hostapd-1749  [000] ....  4423.328173: cfg80211_leave
> <-cfg80211_netdev_notifier_call
>          hostapd-1749  [000] d.h.  4423.328173:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [000] d.h.  4423.328173: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [000] d.h.  4423.328173: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] d.h.  4423.328173: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:13
>
>          hostapd-1749  [000] d.h.  4423.328173:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [000] dNh.  4423.328173:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>          hostapd-1749  [000] dNh.  4423.328173: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>          hostapd-1749  [000] dNh.  4423.328173: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [000] dNh.  4423.328173: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf359280
>
>          hostapd-1749  [000] dNh.  4423.328173:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>          hostapd-1749  [000] .N..  4423.328269: cfg80211_stop_ap
> <-cfg80211_leave
>      kworker/0:1-29    [000] ....  4423.328308:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.328310: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.328312: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328314: ath6kl_close <-__dev_close_many
>          hostapd-1749  [001] ....  4423.328318: ath6kl_cfg80211_stop
> <-ath6kl_close
>          hostapd-1749  [001] ....  4423.328320:
> ath6kl_cfg80211_sscan_disable <-ath6kl_cfg80211_stop
>      kworker/0:1-29    [000] ....  4423.328322: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbec89f00
>
>          hostapd-1749  [001] ....  4423.328322:
> ath6kl_wmi_scanparams_cmd <-ath6kl_cfg80211_stop
>          hostapd-1749  [001] ....  4423.328324: ath6kl_buf_alloc
> <-ath6kl_wmi_scanparams_cmd
>      kworker/0:1-29    [000] ....  4423.328326:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>          hostapd-1749  [001] ....  4423.328327: ath6kl_wmi_cmd_send
> <-ath6kl_wmi_scanparams_cmd
>      kworker/0:1-29    [000] ....  4423.328328:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>          hostapd-1749  [001] ....  4423.328329: ath6kl_dbg <-ath6kl_wmi_cmd_send
>          hostapd-1749  [001] ....  4423.328330: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.328331: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.328333: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.328345: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>          hostapd-1749  [001] ....  4423.328349: ath6kl_log_dbg: wmi tx
> id 8 len 20 flag 0
>
>      kworker/0:1-29    [000] ....  4423.328350: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.328352:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>          hostapd-1749  [001] ....  4423.328354: ath6kl_dbg_dump
> <-ath6kl_wmi_cmd_send
>      kworker/0:1-29    [000] ..s.  4423.328354: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.328356: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.328369: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbec89f00 data=0xbf189cbe len=0x7 eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.328374: ath6kl_free_cookie
> <-ath6kl_tx_complete
>          hostapd-1749  [001] ....  4423.328378: ath6kl_log_dbg_dump: wmi tx /
>
>      kworker/0:1-29    [000] ....  4423.328381:
> ath6kl_usb_io_comp_work <-process_one_work
>          hostapd-1749  [001] ....  4423.328381: ath6kl_control_tx
> <-ath6kl_wmi_cmd_send
>      kworker/0:1-29    [000] ....  4423.328382: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>          hostapd-1749  [001] ....  4423.328383: ath6kl_wmi_cmd: id 8 len 26
>      kworker/0:1-29    [000] ....  4423.328384: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.328385: ath6kl_dbg <-ath6kl_control_tx
>          hostapd-1749  [001] ..s.  4423.328386: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.328395: ath6kl_log_dbg:
> ath6kl_control_tx: skb=0xbf1f79c0, len=0x1a eid =1
>
>      kworker/0:1-29    [000] ....  4423.328398: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3f59c0
>
>          hostapd-1749  [001] ..s.  4423.328400: ath6kl_alloc_cookie
> <-ath6kl_control_tx
>      kworker/0:1-29    [000] ....  4423.328402:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>          hostapd-1749  [001] ....  4423.328402: ath6kl_htc_pipe_tx
> <-ath6kl_control_tx
>      kworker/0:1-29    [000] ....  4423.328404:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>          hostapd-1749  [001] ....  4423.328404: ath6kl_dbg <-ath6kl_htc_pipe_tx
>          hostapd-1749  [001] ....  4423.328405: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.328406: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.328407: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.328417: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>          hostapd-1749  [001] ....  4423.328420: ath6kl_log_dbg:
> ath6kl_htc_pipe_tx: endPointId: 1, buffer: 0xbf3fa2be, length: 26
>
>          hostapd-1749  [001] ....  4423.328425: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ....  4423.328426: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328434: ath6kl_log_dbg:
> htc_try_send: (queue:0xbed4bcc8 depth:1)
>
>          hostapd-1749  [001] ..s.  4423.328438: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.328440: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.328448: ath6kl_log_dbg:
> get_htc_packet_credit_based: got head packet:0xbf11cb1c , queue depth:
> 1
>
>          hostapd-1749  [001] ..s.  4423.328451: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.328453: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.328460: ath6kl_log_dbg:
> get_htc_packet_credit_based: creds required:1 got:1
>
>          hostapd-1749  [001] ..s.  4423.328464: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ..s.  4423.328465: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.328471: ath6kl_log_dbg:
> get_htc_packet_credit_based: host needs credits
>
>          hostapd-1749  [001] ....  4423.328474: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ....  4423.328476: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328483: ath6kl_log_dbg:
> htc_issue_packets: queue: 0xbed4bc88, pkts 1
>
>          hostapd-1749  [001] ....  4423.328487: ath6kl_dbg <-htc_try_send
>          hostapd-1749  [001] ....  4423.328488: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328494: ath6kl_log_dbg: hif pipe send
>
>          hostapd-1749  [001] ....  4423.328496: ath6kl_usb_send <-htc_try_send
>          hostapd-1749  [001] ....  4423.328498: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [001] ....  4423.328499: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328506: ath6kl_log_dbg:
> +ath6kl_usb_send pipe : 0, buf:0xbf1f79c0
>
>          hostapd-1749  [001] ....  4423.328510:
> ath6kl_usb_alloc_urb_from_pipe <-ath6kl_usb_send
>          hostapd-1749  [001] ....  4423.328513: ath6kl_dbg <-ath6kl_usb_send
>          hostapd-1749  [001] ....  4423.328514: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328523: ath6kl_log_dbg: athusb
> bulk send submit:0, 0xC0008300 (ep:0x01), 32 bytes
>
>          hostapd-1749  [001] ....  4423.328541:
> ath6kl_cfg80211_scan_complete_event <-ath6kl_cfg80211_stop
>          hostapd-1749  [001] ....  4423.328543: ath6kl_dbg
> <-ath6kl_cfg80211_scan_complete_event
>          hostapd-1749  [001] ....  4423.328544: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328553: ath6kl_log_dbg:
> ath6kl_cfg80211_scan_complete_event: status aborted
>
>           <idle>-0     [000] d.h.  4423.328561:
> ath6kl_usb_usb_transmit_complete <-usb_hcd_giveback_urb
>           <idle>-0     [000] d.h.  4423.328564: ath6kl_dbg
> <-ath6kl_usb_usb_transmit_complete
>           <idle>-0     [000] d.h.  4423.328565: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328567: ath6kl_get_stats <-dev_get_stats
>           <idle>-0     [000] d.h.  4423.328576: ath6kl_log_dbg:
> ath6kl_usb_usb_transmit_complete: pipe: 0, stat:0, len:32
>
>          hostapd-1749  [001] ....  4423.328581:
> cfg80211_netdev_notifier_call <-notifier_call_chain
>           <idle>-0     [000] d.h.  4423.328581:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_usb_transmit_complete
>          hostapd-1749  [001] ....  4423.328585:
> cfg80211_update_iface_num <-cfg80211_netdev_notifier_call
>           <idle>-0     [000] dNh.  4423.328617:
> ath6kl_usb_recv_complete <-usb_hcd_giveback_urb
>           <idle>-0     [000] dNh.  4423.328619: ath6kl_dbg
> <-ath6kl_usb_recv_complete
>           <idle>-0     [000] dNh.  4423.328621: ath6kl_printk <-ath6kl_dbg
>           <idle>-0     [000] dNh.  4423.328633: ath6kl_log_dbg:
> ath6kl_usb_recv_complete: recv pipe: 5, stat:0, len:10 urb:0xbf359f80
>
>           <idle>-0     [000] dNh.  4423.328640:
> ath6kl_usb_free_urb_to_pipe <-ath6kl_usb_recv_complete
>      kworker/0:1-29    [000] ....  4423.328691:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.328694: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.328695: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.328705: ath6kl_log_dbg: ath6kl
> usb xmit callback buf:0xbf1f79c0
>
>      kworker/0:1-29    [000] ....  4423.328709:
> ath6kl_core_tx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.328711:
> ath6kl_htc_pipe_tx_complete <-ath6kl_core_tx_complete
>      kworker/0:1-29    [000] ....  4423.328713: ath6kl_dbg <-do_send_completion
>      kworker/0:1-29    [000] ....  4423.328715: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.328723: ath6kl_log_dbg:
> do_send_completion: calling ep 1, send complete multiple callback (1
> pkts)
>
>      kworker/0:1-29    [000] ....  4423.328728: ath6kl_tx_complete
> <-do_send_completion
>      kworker/0:1-29    [000] ..s.  4423.328730:
> ath6kl_get_vif_by_index <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.328731: ath6kl_dbg <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ..s.  4423.328733: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.328742: ath6kl_log_dbg:
> ath6kl_tx_complete: skb=0xbf1f79c0 data=0xbf3fa2be len=0x1a eid=1 OK
>
>      kworker/0:1-29    [000] ..s.  4423.328747: ath6kl_free_cookie
> <-ath6kl_tx_complete
>      kworker/0:1-29    [000] ....  4423.328755:
> ath6kl_usb_io_comp_work <-process_one_work
>      kworker/0:1-29    [000] ....  4423.328756: ath6kl_dbg
> <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.328758: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ....  4423.328836: ath6kl_log_dbg: ath6kl
> usb recv callback buf:0xbf3f5a80
>
>      kworker/0:1-29    [000] ....  4423.328842:
> ath6kl_core_rx_complete <-ath6kl_usb_io_comp_work
>      kworker/0:1-29    [000] ....  4423.328844:
> ath6kl_htc_pipe_rx_complete <-ath6kl_core_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.328846: ath6kl_dbg
> <-ath6kl_htc_pipe_rx_complete
>      kworker/0:1-29    [000] ..s.  4423.328849: ath6kl_printk <-ath6kl_dbg
>      kworker/0:1-29    [000] ..s.  4423.328864: ath6kl_log_dbg: Report
> indicated 1 credits to distribute
>
>          hostapd-1749  [001] ....  4423.328934: cfg80211_change_iface
> <-nl80211_set_interface
>          hostapd-1749  [001] ....  4423.328937:
> ath6kl_cfg80211_change_iface <-cfg80211_change_iface
>          hostapd-1749  [001] ....  4423.328939: ath6kl_dbg
> <-ath6kl_cfg80211_change_iface
>          hostapd-1749  [001] ....  4423.328941: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ....  4423.328952: ath6kl_log_dbg:
> ath6kl_cfg80211_change_iface: type 2
>
>          hostapd-1749  [001] ....  4423.328957:
> ath6kl_cfg80211_sta_bmiss_enhance <-ath6kl_cfg80211_change_iface
>          hostapd-1749  [001] ....  4423.329180:
> cfg80211_mlme_unregister_socket <-nl80211_netlink_notify
>          hostapd-1749  [001] ..s.  4423.329184:
> ath6kl_mgmt_frame_register <-cfg80211_mlme_unregister_socket
>          hostapd-1749  [001] ..s.  4423.329185: ath6kl_dbg
> <-ath6kl_mgmt_frame_register
>          hostapd-1749  [001] ..s.  4423.329187: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.329201: ath6kl_log_dbg:
> ath6kl_mgmt_frame_register: frame_type=0x40 reg=0
>
>          hostapd-1749  [001] ....  4423.329388:
> cfg80211_mlme_unregister_socket <-nl80211_netlink_notify
>          hostapd-1749  [001] ..s.  4423.329391:
> ath6kl_mgmt_frame_register <-cfg80211_mlme_unregister_socket
>          hostapd-1749  [001] ..s.  4423.329392: ath6kl_dbg
> <-ath6kl_mgmt_frame_register
>          hostapd-1749  [001] ..s.  4423.329394: ath6kl_printk <-ath6kl_dbg
>          hostapd-1749  [001] ..s.  4423.329406: ath6kl_log_dbg:
> ath6kl_mgmt_frame_register: frame_type=0xd0 reg=0
>
>          hostapd-1749  [001] ....  4423.329471:
> cfg80211_mlme_unregister_socket <-nl80211_netlink_notify
>          hostapd-1749  [001] ....  4423.329495:
> cfg80211_mlme_unregister_socket <-nl80211_netlink_notify
>          hostapd-1749  [001] ....  4423.329512:
> cfg80211_mlme_unregister_socket <-nl80211_netlink_notify
