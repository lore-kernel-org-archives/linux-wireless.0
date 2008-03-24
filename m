Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:9073 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbYCXQVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 12:21:53 -0400
Received: by rn-out-0910.google.com with SMTP id v46so1347024rnb.15
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2008 09:21:52 -0700 (PDT)
Message-ID: <1ba2fa240803240921h44321705s923ecac89427196e@mail.gmail.com> (sfid-20080324_162156_026330_E1B802F6)
Date: Mon, 24 Mar 2008 18:21:51 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: IBSS RTNL assertion
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Has anybody experience the one bellow? Any insights?

Thanks
Tomas

wl4965: U iwl4965_mac_reset_tsf enter
iwl4965: U iwl4965_mac_reset_tsf leave
iwl4965: U iwl4965_mac_config_interface bssid: 02:0e:35:20:5a:48
iwl4965: U iwl4965_mac_config_interface leave
iwl4965: U iwl4965_mac_config enter to channel 1
iwl4965: U iwl4965_mac_config leave
iwl4965: U iwl4965_mac_beacon_update enter
iwl4965: U iwl4965_mac_beacon_update leave
wlan0: Configured IBSS beacon template
phy2: Adding new IBSS station 00:0e:35:24:c1:32 (dev=wlan0)
RTNL: assertion failed at net/mac80211/sta_info.c (140)
Pid: 4177, comm: iwl4965 Not tainted 2.6.25-rc4-wl #6
 [<f8a74427>] sta_info_destroy+0x30/0xf4 [mac80211]
 [<f8a7459c>] sta_info_flush+0xb1/0xcd [mac80211]
 [<f8a7726e>] ieee80211_sta_join_ibss+0x4f/0x58d [mac80211]
 [<c042fc92>] __queue_work+0x1c/0x28
 [<f8a778ab>] ieee80211_rx_bss_add+0xff/0x109 [mac80211]
 [<f8a78126>] ieee80211_rx_bss_info+0x6e9/0x716 [mac80211]
 [<f8a78191>] ieee80211_rx_mgmt_beacon+0x3e/0x165 [mac80211]
 [<c0434ea8>] hrtimer_interrupt+0x127/0x14f
 [<f8a7b416>] ieee80211_sta_rx_queued_mgmt+0xb77/0xb97 [mac80211]
 [<c0426d6a>] irq_exit+0x50/0x67
 [<c0412bd5>] smp_apic_timer_interrupt+0x6e/0x79
 [<c046be74>] add_partial+0x23/0x33
 [<c046cfdf>] __slab_free+0x60/0x1db
 [<f8a7b416>] ieee80211_sta_rx_queued_mgmt+0xb77/0xb97 [mac80211]
 [<c046d95e>] kmem_cache_free+0x60/0x69
 [<f8a7b416>] ieee80211_sta_rx_queued_mgmt+0xb77/0xb97 [mac80211]
 [<f8a7aacb>] ieee80211_sta_rx_queued_mgmt+0x22c/0xb97 [mac80211]
 [<c04d9e80>] __next_cpu+0x12/0x21
 [<c04198a3>] find_busiest_group+0x210/0x605
 [<c047f0b7>] d_alloc+0x1b/0x16e
 [<f8a7b938>] ieee80211_sta_work+0x0/0x54a [mac80211]
 [<f8a7b9ba>] ieee80211_sta_work+0x82/0x54a [mac80211]
 [<c041e864>] hrtick_set+0x7a/0xd8
 [<c0601229>] schedule+0x6df/0x711
 [<f8a7b938>] ieee80211_sta_work+0x0/0x54a [mac80211]
 [<c042f919>] run_workqueue+0x6b/0xe0
 [<c042ffe9>] worker_thread+0x0/0xbd
 [<c043009c>] worker_thread+0xb3/0xbd
 [<c04321ec>] autoremove_wake_function+0x0/0x2d
 [<c0432128>] kthread+0x38/0x60
 [<c04320f0>] kthread+0x0/0x60
 [<c0405527>] kernel_thread_helper+0x7/0x10
 =======================
RTNL: assertion failed at net/mac80211/key.c (275)
Pid: 4177, comm: iwl4965 Not tainted 2.6.25-rc4-wl #6
 [<f8a82d79>] ieee80211_key_free+0x2b/0x97 [mac80211]
 [<f8ab02ad>] rs_remove_debugfs+0x0/0x25 [iwl4965]
 [<f8a74461>] sta_info_destroy+0x6a/0xf4 [mac80211]
 [<f8a7459c>] sta_info_flush+0xb1/0xcd [mac80211]
 [<f8a7726e>] ieee80211_sta_join_ibss+0x4f/0x58d [mac80211]
 [<c042fc92>] __queue_work+0x1c/0x28
 [<f8a778ab>] ieee80211_rx_bss_add+0xff/0x109 [mac80211]
 [<f8a78126>] ieee80211_rx_bss_info+0x6e9/0x716 [mac80211]
 [<f8a78191>] ieee80211_rx_mgmt_beacon+0x3e/0x165 [mac80211]
 [<c0434ea8>] hrtimer_interrupt+0x127/0x14f
 [<f8a7b416>] ieee80211_sta_rx_queued_mgmt+0xb77/0xb97 [mac80211]
 [<c0426d6a>] irq_exit+0x50/0x67
 [<c0412bd5>] smp_apic_timer_interrupt+0x6e/0x79
 [<c046be74>] add_partial+0x23/0x33
 [<c046cfdf>] __slab_free+0x60/0x1db
 [<f8a7b416>] ieee80211_sta_rx_queued_mgmt+0xb77/0xb97 [mac80211]
 [<c046d95e>] kmem_cache_free+0x60/0x69
 [<f8a7b416>] ieee80211_sta_rx_queued_mgmt+0xb77/0xb97 [mac80211]
 [<f8a7aacb>] ieee80211_sta_rx_queued_mgmt+0x22c/0xb97 [mac80211]
 [<c04d9e80>] __next_cpu+0x12/0x21
 [<c04198a3>] find_busiest_group+0x210/0x605
 [<c047f0b7>] d_alloc+0x1b/0x16e
 [<f8a7b938>] ieee80211_sta_work+0x0/0x54a [mac80211]
 [<f8a7b9ba>] ieee80211_sta_work+0x82/0x54a [mac80211]
 [<c041e864>] hrtick_set+0x7a/0xd8
 [<c0601229>] schedule+0x6df/0x711
 [<f8a7b938>] ieee80211_sta_work+0x0/0x54a [mac80211]
 [<c042f919>] run_workqueue+0x6b/0xe0
 [<c042ffe9>] worker_thread+0x0/0xbd
 [<c043009c>] worker_thread+0xb3/0xbd
 [<c04321ec>] autoremove_wake_function+0x0/0x2d
 [<c0432128>] kthread+0x38/0x60
 [<c04320f0>] kthread+0x0/0x60
 [<c0405527>] kernel_thread_helper+0x7/0x10
 =======================
