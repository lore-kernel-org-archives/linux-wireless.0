Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37975 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939089AbcJXSKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 14:10:35 -0400
Received: by mail-wm0-f45.google.com with SMTP id c78so129615716wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 11:10:34 -0700 (PDT)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Jonas Gorski <jonas.gorski@gmail.com>
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
 <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
 <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
 <CAOiHx==nbvwiiMZaqg5okdM6ab9ZLc+JOPdHdJJMUh9uhEt3PQ@mail.gmail.com>
 <43544382-075a-6437-8f72-133a907d9def@gmail.com>
 <CAOiHx=kWh3P=Ye1Bnd35pRvwWyOdqEyYFVXvTTz60_Hj4TDFFg@mail.gmail.com>
 <faedb36a-d99c-5891-e9c6-40ecc4d54748@gmail.com>
 <CAOiHx=mY8DtgM-DxxqQW9U0=PeMjUbuvBsEjVbLissV6tVyYcA@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <b4341f8d-ed88-48d1-000a-edb43d88fd48@gmail.com> (sfid-20161024_201045_636330_F54BB631)
Date: Mon, 24 Oct 2016 20:10:31 +0200
MIME-Version: 1.0
In-Reply-To: <CAOiHx=mY8DtgM-DxxqQW9U0=PeMjUbuvBsEjVbLissV6tVyYcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> (please don't toppost)
Did not know that this is forbidden, sorry
> You can find an sd-card image at
> https://downloads.lede-project.org/snapshots/targets/mvebu/generic/ -
> it won't contain any wifi drivers though, you will need to install
> them separately - easiest by providing internet access over the wan
> port (the single ethernet port for the pro, it defaults to dhcp
> client), then running "opkg install kmod-ath10k" on shell.
I used dd to install the latest image from today to the SD. I am 
connected through usb with screen, thats a very nice feature of the 
board :)
I logged in, updated the packages with opkg update and then installed 
kmod-ath10k but i received many errors:

[  380.987440] ath10k_core: Unknown symbol cfg80211_find_ie_match (err 0)
[  380.993996] ath10k_core: Unknown symbol ieee80211_wake_queue (err 0)
[  381.000383] ath10k_core: Unknown symbol ieee80211_find_sta (err 0)
[  381.006586] ath10k_core: Unknown symbol 
ieee80211_stop_rx_ba_session_offl (err 0)
[  381.014101] ath10k_core: Unknown symbol ieee80211_tx_status_irqsafe 
(err 0)
[  381.021096] ath10k_core: Unknown symbol 
ieee80211_iter_chan_contexts_atomic (err 0)
[  381.028778] ath10k_core: Unknown symbol __cfg80211_alloc_reply_skb 
(err 0)
[  381.035681] ath10k_core: Unknown symbol __cfg80211_alloc_event_skb 
(err 0)
[  381.042584] ath10k_core: Unknown symbol cfg80211_put_bss (err 0)
[  381.048623] ath10k_core: Unknown symbol ieee80211_bss_get_ie (err 0)
[  381.055005] ath10k_core: Unknown symbol wiphy_to_ieee80211_hw (err 0)
[  381.061472] ath10k_core: Unknown symbol __cfg80211_send_event_skb (err 0)
[  381.068284] ath10k_core: Unknown symbol ath_reg_notifier_apply (err 0)
[  381.074878] ath10k_core: Unknown symbol ieee80211_queue_delayed_work 
(err 0)
[  381.081959] ath10k_core: Unknown symbol ieee80211_proberesp_get (err 0)
[  381.088610] ath10k_core: Unknown symbol ieee80211_find_sta_by_ifaddr 
(err 0)
[  381.095689] ath10k_core: Unknown symbol 
ieee80211_remain_on_channel_expired (err 0)
[  381.103379] ath10k_core: Unknown symbol ath_is_world_regd (err 0)
[  381.109503] ath10k_core: Unknown symbol ieee80211_wake_queues (err 0)
[  381.115965] ath10k_core: Unknown symbol ieee80211_report_low_ack (err 0)
[  381.122691] ath10k_core: Unknown symbol ieee80211_beacon_get_template 
(err 0)
[  381.129855] ath10k_core: Unknown symbol ieee80211_free_txskb (err 0)
[  381.136232] ath10k_core: Unknown symbol ieee80211_alloc_hw_nm (err 0)
[  381.142699] ath10k_core: Unknown symbol cfg80211_get_bss (err 0)
[  381.148731] ath10k_core: Unknown symbol ieee80211_tx_dequeue (err 0)
[  381.155111] ath10k_core: Unknown symbol __ieee80211_get_channel (err 0)
[  381.161755] ath10k_core: Unknown symbol cfg80211_vendor_cmd_reply (err 0)
[  381.168574] ath10k_core: Unknown symbol ieee80211_tx_status (err 0)
[  381.174866] ath10k_core: Unknown symbol ieee80211_stop_queue (err 0)
[  381.181246] ath10k_core: Unknown symbol ieee80211_ready_on_channel 
(err 0)
[  381.188142] ath10k_core: Unknown symbol ieee80211_stop_queues (err 0)
[  381.194621] ath10k_core: Unknown symbol ieee80211_scan_completed (err 0)
[  381.201349] ath10k_core: Unknown symbol 
ieee80211_iterate_active_interfaces_atomic (err 0)
[  381.209651] ath10k_core: Unknown symbol 
ieee80211_channel_to_frequency (err 0)
[  381.216896] ath10k_core: Unknown symbol ieee80211_unregister_hw (err 0)
[  381.223537] ath10k_core: Unknown symbol dfs_pattern_detector_init (err 0)
[  381.230354] ath10k_core: Unknown symbol ath_regd_init (err 0)
[  381.236119] ath10k_core: Unknown symbol ieee80211_csa_update_counter 
(err 0)
[  381.243195] ath10k_core: Unknown symbol ieee80211_beacon_get_tim (err 0)
[  381.249924] ath10k_core: Unknown symbol ieee80211_hdrlen (err 0)
[  381.255951] ath10k_core: Unknown symbol 
ieee80211_start_rx_ba_session_offl (err 0)
[  381.263548] ath10k_core: Unknown symbol ieee80211_radar_detected (err 0)
[  381.270276] ath10k_core: Unknown symbol ieee80211_csa_is_complete (err 0)
[  381.277090] ath10k_core: Unknown symbol ieee80211_queue_work (err 0)
[  381.283475] ath10k_core: Unknown symbol cfg80211_find_vendor_ie (err 0)
[  381.290123] ath10k_core: Unknown symbol ieee80211_csa_finish (err 0)
[  381.296498] ath10k_core: Unknown symbol ieee80211_rx_napi (err 0)
[  381.330745] ath10k_pci: Unknown symbol ath10k_warn (err 0)
[  381.336261] ath10k_pci: Unknown symbol ath10k_err (err 0)
[  381.341699] ath10k_pci: Unknown symbol ath10k_print_driver_info (err 0)
[  381.348340] ath10k_pci: Unknown symbol ath10k_htt_hif_tx_complete (err 0)
[  381.355162] ath10k_pci: Unknown symbol 
ath10k_htc_tx_completion_handler (err 0)
[  381.362509] ath10k_pci: Unknown symbol 
ath10k_debug_get_new_fw_crash_data (err 0)
[  381.370020] ath10k_pci: Unknown symbol ath10k_core_create (err 0)
[  381.376143] ath10k_pci: Unknown symbol 
ath10k_htt_rx_pktlog_completion_handler (err 0)
[  381.384097] ath10k_pci: Unknown symbol ath10k_core_destroy (err 0)
[  381.390304] ath10k_pci: Unknown symbol 
ath10k_htc_rx_completion_handler (err 0)
[  381.397637] ath10k_pci: Unknown symbol ath10k_core_register (err 0)
[  381.403930] ath10k_pci: Unknown symbol ath10k_info (err 0)
[  381.409445] ath10k_pci: Unknown symbol backport_dependency_symbol (err 0)
[  381.416255] ath10k_pci: Unknown symbol ath10k_htt_t2h_msg_handler (err 0)
[  381.423072] ath10k_pci: Unknown symbol ath10k_core_unregister (err 0)
[  381.429537] ath10k_pci: Unknown symbol ath10k_htt_txrx_compl_task (err 0)

Regards
Oli
