Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18C2C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 13:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A3720664
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 13:57:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04A3720664
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbeJ2Wq2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 18:46:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:15625 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbeJ2Wq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 18:46:27 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2018 06:42:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,440,1534834800"; 
   d="xz'?scan'208";a="86448742"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.6])
  by orsmga006.jf.intel.com with ESMTP; 29 Oct 2018 06:42:17 -0700
Date:   Mon, 29 Oct 2018 21:42:35 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Sriram R <srirrama@codeaurora.org>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Sriram R <srirrama@codeaurora.org>, lkp@01.org
Subject: [LKP] [cfg80211]  d3e95c31e6: hwsim.wnm_bss_tm_nei_11a.fail
Message-ID: <20181029134235.GS24195@shao2-debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oP9at/Ymg5VWhwKB"
Content-Disposition: inline
In-Reply-To: <1539940379-1395-1-git-send-email-srirrama@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--oP9at/Ymg5VWhwKB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

FYI, we noticed the following commit (built with gcc-7):

commit: d3e95c31e68e09731b3ac5dec3b8835211bb2072 ("[PATCH] cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces")
url: https://github.com/0day-ci/linux/commits/Sriram-R/cfg80211-Prevent-regulatory-restore-during-STA-disconnect-in-concurrent-interfaces/20181021-011208
base: https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git master

in testcase: hwsim
with following parameters:

	group: hwsim-12



on test machine: qemu-system-x86_64 -enable-kvm -cpu host -smp 2 -m 4G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):




2018-10-28 12:00:43 export USER=root
2018-10-28 12:00:43 ./build.sh
Building TNC testing tools
Building wlantest
Building hostapd
Building wpa_supplicant
2018-10-28 12:02:49 ./start.sh
ignored_by_lkp sigma_dut_ap_cipher_ccmp_gcmp_2
ignored_by_lkp sigma_dut_ap_cipher_gcmp_128
ignored_by_lkp sigma_dut_ap_cipher_gcmp_256
ignored_by_lkp sigma_dut_ap_cipher_gcmp_256_group_ccmp
ignored_by_lkp sigma_dut_ap_dpp_pkex_responder
ignored_by_lkp sigma_dut_ap_dpp_qr
ignored_by_lkp sigma_dut_ap_dpp_qr_legacy
ignored_by_lkp sigma_dut_ap_dpp_qr_legacy_psk
ignored_by_lkp sigma_dut_ap_dpp_self_config
ignored_by_lkp sigma_dut_ap_eap
ignored_by_lkp sigma_dut_ap_eap_osen
ignored_by_lkp sigma_dut_ap_eap_sha256
ignored_by_lkp sigma_dut_ap_ent_ft_eap
ignored_by_lkp sigma_dut_ap_ft_eap
ignored_by_lkp sigma_dut_ap_ft_psk
ignored_by_lkp sigma_dut_ap_osen
ignored_by_lkp sigma_dut_ap_override_rsne
ignored_by_lkp sigma_dut_ap_owe
ignored_by_lkp sigma_dut_ap_owe_ecgroupid
ignored_by_lkp sigma_dut_ap_owe_transition_mode
ignored_by_lkp sigma_dut_ap_owe_transition_mode_2
ignored_by_lkp sigma_dut_ap_psk
ignored_by_lkp sigma_dut_ap_psk_sae
ignored_by_lkp sigma_dut_ap_psk_sha256
ignored_by_lkp sigma_dut_ap_pskhex
ignored_by_lkp sigma_dut_ap_sae
ignored_by_lkp sigma_dut_ap_sae_group
ignored_by_lkp sigma_dut_ap_sae_password
ignored_by_lkp sigma_dut_ap_suite_b
ignored_by_lkp sigma_dut_basic
ignored_by_lkp sigma_dut_dpp_incompatible_roles_init
ignored_by_lkp sigma_dut_dpp_incompatible_roles_resp
ignored_by_lkp sigma_dut_dpp_pkex_init_configurator
ignored_by_lkp sigma_dut_dpp_pkex_responder_proto
ignored_by_lkp sigma_dut_dpp_proto_initiator
ignored_by_lkp sigma_dut_dpp_proto_initiator_pkex
ignored_by_lkp sigma_dut_dpp_proto_peer_disc_req
ignored_by_lkp sigma_dut_dpp_proto_responder
ignored_by_lkp sigma_dut_dpp_proto_responder_pkex
ignored_by_lkp sigma_dut_dpp_proto_stop_at_initiator
ignored_by_lkp sigma_dut_dpp_proto_stop_at_initiator_enrollee
ignored_by_lkp sigma_dut_dpp_proto_stop_at_responder
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_1
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_2
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_3
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_4
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_5
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_6
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_7
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_both
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_neg_freq
ignored_by_lkp sigma_dut_dpp_qr_init_enrollee
ignored_by_lkp sigma_dut_dpp_qr_init_enrollee_psk
ignored_by_lkp sigma_dut_dpp_qr_init_enrollee_sae
ignored_by_lkp sigma_dut_dpp_qr_mutual_init_enrollee
ignored_by_lkp sigma_dut_dpp_qr_mutual_init_enrollee_check
ignored_by_lkp sigma_dut_dpp_qr_mutual_init_enrollee_pending
ignored_by_lkp sigma_dut_dpp_qr_mutual_resp_enrollee
ignored_by_lkp sigma_dut_dpp_qr_mutual_resp_enrollee_pending
ignored_by_lkp sigma_dut_dpp_qr_resp_1
ignored_by_lkp sigma_dut_dpp_qr_resp_2
ignored_by_lkp sigma_dut_dpp_qr_resp_3
ignored_by_lkp sigma_dut_dpp_qr_resp_4
ignored_by_lkp sigma_dut_dpp_qr_resp_5
ignored_by_lkp sigma_dut_dpp_qr_resp_6
ignored_by_lkp sigma_dut_dpp_qr_resp_7
ignored_by_lkp sigma_dut_dpp_qr_resp_chan_list
ignored_by_lkp sigma_dut_dpp_self_config
ignored_by_lkp sigma_dut_hs20_assoc_24
ignored_by_lkp sigma_dut_hs20_assoc_5
ignored_by_lkp sigma_dut_open
ignored_by_lkp sigma_dut_owe
ignored_by_lkp sigma_dut_preconfigured_profile
ignored_by_lkp sigma_dut_psk_pmf
ignored_by_lkp sigma_dut_psk_pmf_bip_cmac_128
ignored_by_lkp sigma_dut_psk_pmf_bip_cmac_256
ignored_by_lkp sigma_dut_psk_pmf_bip_gmac_128
ignored_by_lkp sigma_dut_psk_pmf_bip_gmac_256
ignored_by_lkp sigma_dut_psk_pmf_bip_gmac_256_mismatch
ignored_by_lkp sigma_dut_sae
ignored_by_lkp sigma_dut_sae_password
ignored_by_lkp sigma_dut_sta_override_rsne
ignored_by_lkp sigma_dut_sta_scan_bss
ignored_by_lkp sigma_dut_suite_b
ignored_by_lkp sigma_dut_suite_b_rsa
ignored_by_lkp sigma_dut_venue_url
ignored_by_lkp sigma_dut_wps_pbc
2018-10-28 12:02:50 	./run-tests.py ssid_1_octet 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_1_octet 1/1
Test: SSID with one octet
Starting AP wlan3
Connect STA wlan0 to AP
PASS ssid_1_octet 0.469068 2018-10-28 12:02:52.353460
passed all 1 test case(s)
2018-10-28 12:02:52 	./run-tests.py ssid_32_octets 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_32_octets 1/1
Test: SSID with 32 octets
Starting AP wlan3
Connect STA wlan0 to AP
PASS ssid_32_octets 0.416617 2018-10-28 12:02:53.187065
passed all 1 test case(s)
2018-10-28 12:02:53 	./run-tests.py ssid_hex_encoded 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hex_encoded 1/1
Test: SSID configuration using hex encoded version
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
PASS ssid_hex_encoded 0.576768 2018-10-28 12:02:54.111255
passed all 1 test case(s)
2018-10-28 12:02:54 	./run-tests.py ssid_hidden 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hidden 1/1
Test: Hidden SSID
Starting AP wlan3
Connect STA wlan1 to AP
Connect STA wlan0 to AP
PASS ssid_hidden 1.619968 2018-10-28 12:02:56.141386
passed all 1 test case(s)
2018-10-28 12:02:56 	./run-tests.py ssid_hidden2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hidden2 1/1
Test: Hidden SSID using zero octets as payload
Starting AP wlan3
Connect STA wlan1 to AP
Connect STA wlan0 to AP
PASS ssid_hidden2 1.648897 2018-10-28 12:02:58.194421
passed all 1 test case(s)
2018-10-28 12:02:58 	./run-tests.py ssid_hidden_wpa2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hidden_wpa2 1/1
Test: Hidden SSID with WPA2-PSK
Starting AP wlan3
Connect STA wlan1 to AP
Connect STA wlan0 to AP
PASS ssid_hidden_wpa2 1.69057 2018-10-28 12:03:00.312712
passed all 1 test case(s)
2018-10-28 12:03:00 	./run-tests.py ssid_printf_encoded 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_printf_encoded 1/1
Test: SSID configuration using printf encoded version
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
PASS ssid_printf_encoded 0.930009 2018-10-28 12:03:01.714338
passed all 1 test case(s)
2018-10-28 12:03:01 	./run-tests.py ssid_utf8 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_utf8 1/1
Test: SSID with UTF8 encoding
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
PASS ssid_utf8 0.750463 2018-10-28 12:03:02.908392
passed all 1 test case(s)
2018-10-28 12:03:02 	./run-tests.py sta_ap_scan_0 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_ap_scan_0 1/1
Test: Dynamically added wpa_supplicant interface with AP_SCAN 0 connection
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_ap_scan_0 1.142476 2018-10-28 12:03:04.468008
passed all 1 test case(s)
2018-10-28 12:03:04 	./run-tests.py sta_ap_scan_2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_ap_scan_2 1/1
Test: Dynamically added wpa_supplicant interface with AP_SCAN 2 connection
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_ap_scan_2 2.559885 2018-10-28 12:03:07.477257
passed all 1 test case(s)
2018-10-28 12:03:07 	./run-tests.py sta_ap_scan_2b 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_ap_scan_2b 1/1
Test: Dynamically added wpa_supplicant interface with AP_SCAN 2 operation
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_ap_scan_2b 13.738109 2018-10-28 12:03:21.630069
passed all 1 test case(s)
2018-10-28 12:03:21 	./run-tests.py sta_dynamic 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic 1/1
Test: Dynamically added wpa_supplicant interface
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_dynamic 0.721891 2018-10-28 12:03:22.758197
passed all 1 test case(s)
2018-10-28 12:03:22 	./run-tests.py sta_dynamic_down_up 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_down_up 1/1
Test: Dynamically added wpa_supplicant interface down/up
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_dynamic_down_up 1.15274 2018-10-28 12:03:24.319761
passed all 1 test case(s)
2018-10-28 12:03:24 	./run-tests.py sta_dynamic_ext_mac_addr_change 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_ext_mac_addr_change 1/1
Test: Dynamically added wpa_supplicant interface with external MAC address change
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_dynamic_ext_mac_addr_change 1.251325 2018-10-28 12:03:26.046355
passed all 1 test case(s)
2018-10-28 12:03:26 	./run-tests.py sta_dynamic_random_mac_addr 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address
Starting AP wlan3
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr 1.363314 2018-10-28 12:03:27.829346
passed all 1 test case(s)
2018-10-28 12:03:27 	./run-tests.py sta_dynamic_random_mac_addr_keep_oui 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr_keep_oui 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address (keep OUI)
Starting AP wlan3
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr_keep_oui 1.370933 2018-10-28 12:03:29.644521
passed all 1 test case(s)
2018-10-28 12:03:29 	./run-tests.py sta_dynamic_random_mac_addr_scan 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr_scan 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address for scan
Starting AP wlan3
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr_scan 0.989996 2018-10-28 12:03:31.179899
passed all 1 test case(s)
2018-10-28 12:03:31 	./run-tests.py sta_dynamic_random_mac_addr_scan_keep_oui 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr_scan_keep_oui 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address for scan (keep OUI)
Starting AP wlan3
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr_scan_keep_oui 0.918663 2018-10-28 12:03:32.568132
passed all 1 test case(s)
2018-10-28 12:03:32 	./run-tests.py suite_b 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b 1/1
Test: WPA2/GCMP connection at Suite B 128-bit level
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b 0.931645 2018-10-28 12:03:34.052579
passed all 1 test case(s)
2018-10-28 12:03:34 	./run-tests.py suite_b_192 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192 1.121564 2018-10-28 12:03:35.753060
passed all 1 test case(s)
2018-10-28 12:03:35 	./run-tests.py suite_b_192_mic_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_mic_failure 1/1
Test: WPA2/GCMP connection at Suite B 192-bit level and MIC derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_mic_failure 0.713166 2018-10-28 12:03:37.006557
passed all 1 test case(s)
2018-10-28 12:03:37 	./run-tests.py suite_b_192_pmkid_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_pmkid_failure 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and PMKID derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_pmkid_failure 0.639846 2018-10-28 12:03:38.153704
passed all 1 test case(s)
2018-10-28 12:03:38 	./run-tests.py suite_b_192_radius 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_radius 1/1
Test: WPA2/GCMP-256 (RADIUS) connection at Suite B 192-bit level
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_radius 0.975543 2018-10-28 12:03:39.552257
passed all 1 test case(s)
2018-10-28 12:03:39 	./run-tests.py suite_b_192_radius_and_p256_cert 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_radius_and_p256_cert 1/1
Test: Suite B 192-bit level and p256 client cert
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_radius_and_p256_cert 0.976882 2018-10-28 12:03:41.032750
passed all 1 test case(s)
2018-10-28 12:03:41 	./run-tests.py suite_b_192_rsa 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa 0.848577 2018-10-28 12:03:42.511323
passed all 1 test case(s)
2018-10-28 12:03:42 	./run-tests.py suite_b_192_rsa_dhe 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_dhe 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA (DHE)
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_dhe 0.956581 2018-10-28 12:03:43.954524
passed all 1 test case(s)
2018-10-28 12:03:44 	./run-tests.py suite_b_192_rsa_dhe_radius_rsa2048_client 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_dhe_radius_rsa2048_client 1/1
Test: Suite B 192-bit level and RSA (DHE) and RSA2048 client
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_dhe_radius_rsa2048_client 0.878744 2018-10-28 12:03:45.321909
passed all 1 test case(s)
2018-10-28 12:03:45 	./run-tests.py suite_b_192_rsa_ecdhe 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_ecdhe 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA (ECDHE)
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_ecdhe 1.079896 2018-10-28 12:03:46.950174
passed all 1 test case(s)
2018-10-28 12:03:47 	./run-tests.py suite_b_192_rsa_ecdhe_radius_rsa2048_client 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_ecdhe_radius_rsa2048_client 1/1
Test: Suite B 192-bit level and RSA (ECDHE) and RSA2048 client
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_ecdhe_radius_rsa2048_client 1.131369 2018-10-28 12:03:48.617713
passed all 1 test case(s)
2018-10-28 12:03:48 	./run-tests.py suite_b_192_rsa_insufficient_dh 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_insufficient_dh 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA with insufficient DH key length
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_insufficient_dh 0.761804 2018-10-28 12:03:49.803313
passed all 1 test case(s)
2018-10-28 12:03:49 	./run-tests.py suite_b_192_rsa_insufficient_key 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_insufficient_key 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA with insufficient key length
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_insufficient_key 0.716303 2018-10-28 12:03:51.024431
passed all 1 test case(s)
2018-10-28 12:03:51 	./run-tests.py suite_b_192_rsa_radius 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_radius 1/1
Test: WPA2/GCMP-256 (RADIUS) connection at Suite B 192-bit level and RSA (ECDHE)
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_radius 1.294771 2018-10-28 12:03:52.864967
passed all 1 test case(s)
2018-10-28 12:03:52 	./run-tests.py suite_b_mic_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_mic_failure 1/1
Test: WPA2/GCMP connection at Suite B 128-bit level and MIC derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_mic_failure 0.853263 2018-10-28 12:03:54.271571
passed all 1 test case(s)
2018-10-28 12:03:54 	./run-tests.py suite_b_pmkid_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_pmkid_failure 1/1
Test: WPA2/GCMP connection at Suite B 128-bit level and PMKID derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_pmkid_failure 0.782954 2018-10-28 12:03:55.602313
passed all 1 test case(s)
2018-10-28 12:03:55 	./run-tests.py suite_b_radius 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_radius 1/1
Test: WPA2/GCMP (RADIUS) connection at Suite B 128-bit level
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_radius 1.013984 2018-10-28 12:03:57.075159
passed all 1 test case(s)
ignored_by_lkp tdls_chan_switch
2018-10-28 12:03:57 	./run-tests.py tnc_fast 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_fast 1/1
Test: TNC FAST
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 194, in test_tnc_fast
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_fast 10.377092 2018-10-28 12:04:07.904561
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_fast
2018-10-28 12:04:07 	./run-tests.py tnc_peap_soh 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_peap_soh 1/1
Test: TNC PEAP-SoH
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 26, in test_tnc_peap_soh
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_peap_soh 10.416039 2018-10-28 12:04:18.850401
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_peap_soh
2018-10-28 12:04:18 	./run-tests.py tnc_peap_soh_errors 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_peap_soh_errors 1/1
Test: TNC PEAP-SoH local error cases
Starting AP wlan3
Connect STA wlan0 to AP
Failure not triggered
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 60, in test_tnc_peap_soh_errors
    wait_fail_trigger(dev[0], "GET_ALLOC_FAIL")
  File "/lkp/benchmarks/hwsim/tests/hwsim/utils.py", line 62, in wait_fail_trigger
    raise Exception(note)
Exception: Failure not triggered
FAIL tnc_peap_soh_errors 2.543831 2018-10-28 12:04:21.980850
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_peap_soh_errors
2018-10-28 12:04:22 	./run-tests.py tnc_ttls 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_ttls 1/1
Test: TNC TTLS
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 91, in test_tnc_ttls
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_ttls 10.453996 2018-10-28 12:04:32.939168
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_ttls
2018-10-28 12:04:33 	./run-tests.py tnc_ttls_errors 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_ttls_errors 1/1
Test: TNC TTLS local error cases
Starting AP wlan3
Connect STA wlan0 to AP
Allocation failure not triggered for: 1:eap_ttls_process_phase2_eap;eap_ttls_process_tnc_start
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 167, in test_tnc_ttls_errors
    note="Allocation failure not triggered for: %d:%s" % (count, func))
  File "/lkp/benchmarks/hwsim/tests/hwsim/utils.py", line 62, in wait_fail_trigger
    raise Exception(note)
Exception: Allocation failure not triggered for: 1:eap_ttls_process_phase2_eap;eap_ttls_process_tnc_start
FAIL tnc_ttls_errors 2.607626 2018-10-28 12:04:36.056599
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_ttls_errors
2018-10-28 12:04:36 	./run-tests.py tnc_ttls_fragmentation 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_ttls_fragmentation 1/1
Test: TNC TTLS with fragmentation
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 111, in test_tnc_ttls_fragmentation
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_ttls_fragmentation 10.423287 2018-10-28 12:04:47.018479
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_ttls_fragmentation
2018-10-28 12:04:47 	./run-tests.py tspec 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec 1/1
Test: Basic addts/delts tests
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec 0.775814 2018-10-28 12:04:48.287804
passed all 1 test case(s)
2018-10-28 12:04:48 	./run-tests.py tspec_ap_fail 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_ap_fail 1/1
Test: AP failing to send tspec response
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_ap_fail 1.526823 2018-10-28 12:04:50.392410
passed all 1 test case(s)
2018-10-28 12:04:50 	./run-tests.py tspec_ap_parsing 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_ap_parsing 1/1
Test: TSPEC AP parsing tests
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_ap_parsing 0.72163 2018-10-28 12:04:51.663684
passed all 1 test case(s)
2018-10-28 12:04:51 	./run-tests.py tspec_ap_roam_open 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_ap_roam_open 1/1
Test: Roam between two open APs while having tspecs
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan4
PASS tspec_ap_roam_open 5.374646 2018-10-28 12:04:57.611491
passed all 1 test case(s)
2018-10-28 12:04:57 	./run-tests.py tspec_not_enabled 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_not_enabled 1/1
Test: addts failing if AP does not support WMM
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_not_enabled 0.731853 2018-10-28 12:04:58.814328
passed all 1 test case(s)
2018-10-28 12:04:58 	./run-tests.py tspec_protocol 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_protocol 1/1
Test: Protocol tests for addts/delts
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_protocol 1.723449 2018-10-28 12:05:01.037510
passed all 1 test case(s)
2018-10-28 12:05:01 	./run-tests.py tspec_reassoc 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_reassoc 1/1
Test: Reassociation to same BSS while having tspecs
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_reassoc 4.699278 2018-10-28 12:05:06.226323
passed all 1 test case(s)
2018-10-28 12:05:06 	./run-tests.py wep_ht_vht 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_ht_vht 1/1
Test: WEP and HT/VHT
Starting AP wlan3
Connect STA wlan0 to AP
hostapd STATUS: {'olbc_ht': '0', 'cac_time_left_seconds': 'N/A', 'num_sta_no_short_slot_time': '1', 'olbc': '0', 'num_sta_non_erp': '0', 'supported_rates': '0c 12 18 24 30 48 60 6c', 'ht_op_mode': '0x13', 'state': 'ENABLED', 'num_sta_ht40_intolerant': '0', 'channel': '36', 'bssid[0]': '02:00:00:00:03:00', 'ieee80211n': '0', 'cac_time_seconds': '0', 'num_sta[0]': '1', 'ieee80211ac': '0', 'phy': 'phy3', 'max_txpower': '20', 'num_sta_ht_no_gf': '0', 'freq': '5180', 'num_sta_ht_20_mhz': '0', 'num_sta_no_short_preamble': '1', 'secondary_channel': '0', 'ssid[0]': 'test-vht40-wep', 'dtim_period': '2', 'beacon_int': '100', 'num_sta_no_ht': '1', 'bss[0]': 'wlan3'}
PASS wep_ht_vht 1.086451 2018-10-28 12:05:07.754182
passed all 1 test case(s)
2018-10-28 12:05:07 	./run-tests.py wep_ifdown 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_ifdown 1/1
Test: AP with WEP and external ifconfig down
Starting AP wlan3
Connect STA wlan0 to AP
PASS wep_ifdown 1.179304 2018-10-28 12:05:09.475904
passed all 1 test case(s)
2018-10-28 12:05:09 	./run-tests.py wep_open_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_open_auth 1/1
Test: WEP Open System authentication
Starting AP wlan3
Connect STA wlan0 to AP
PASS wep_open_auth 0.508769 2018-10-28 12:05:10.426938
passed all 1 test case(s)
2018-10-28 12:05:10 	./run-tests.py wep_shared_key_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_shared_key_auth 1/1
Test: WEP Shared Key authentication
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
PASS wep_shared_key_auth 0.82823 2018-10-28 12:05:11.676748
passed all 1 test case(s)
2018-10-28 12:05:11 	./run-tests.py wep_shared_key_auth_multi_key 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_shared_key_auth_multi_key 1/1
Test: WEP Shared Key authentication with multiple keys
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
PASS wep_shared_key_auth_multi_key 1.247324 2018-10-28 12:05:13.337600
passed all 1 test case(s)
2018-10-28 12:05:13 	./run-tests.py wep_shared_key_auth_not_allowed 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_shared_key_auth_not_allowed 1/1
Test: WEP Shared Key authentication not allowed
Starting AP wlan3
Connect STA wlan0 to AP
PASS wep_shared_key_auth_not_allowed 1.348489 2018-10-28 12:05:15.151311
passed all 1 test case(s)
2018-10-28 12:05:15 	./run-tests.py wext_open 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_open 1/1
Test: WEXT driver interface with open network
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_open 4.644343 2018-10-28 12:05:20.226635
passed all 1 test case(s)
2018-10-28 12:05:20 	./run-tests.py wext_pmf 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_pmf 1/1
Test: WEXT driver interface with WPA2-PSK and PMF
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_pmf 8.845238 2018-10-28 12:05:29.666662
passed all 1 test case(s)
2018-10-28 12:05:29 	./run-tests.py wext_pmksa_cache 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_pmksa_cache 1/1
Test: PMKSA caching with WEXT
Starting AP wlan3
Connect STA wlan5 to AP
Starting AP wlan4
Roam to AP2
Roam back to AP1
PASS wext_pmksa_cache 32.945808 2018-10-28 12:06:03.243617
passed all 1 test case(s)
2018-10-28 12:06:03 	./run-tests.py wext_rfkill 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_rfkill 1/1
Test: WEXT and rfkill block/unblock
Starting AP wlan3
Connect STA wlan5 to AP
rfkill block
rfkill unblock
PASS wext_rfkill 8.952556 2018-10-28 12:06:12.756213
passed all 1 test case(s)
2018-10-28 12:06:12 	./run-tests.py wext_scan_hidden 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_scan_hidden 1/1
Test: WEXT with hidden SSID
Starting AP wlan3
Starting AP wlan4
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS wext_scan_hidden 18.402832 2018-10-28 12:06:31.751499
passed all 1 test case(s)
2018-10-28 12:06:31 	./run-tests.py wext_wep_open_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wep_open_auth 1/1
Test: WEP Open System authentication
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_wep_open_auth 4.813233 2018-10-28 12:06:37.087342
passed all 1 test case(s)
2018-10-28 12:06:37 	./run-tests.py wext_wep_shared_key_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wep_shared_key_auth 1/1
Test: WEP Shared Key authentication
Starting AP wlan3
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS wext_wep_shared_key_auth 5.042088 2018-10-28 12:06:42.655147
passed all 1 test case(s)
2018-10-28 12:06:42 	./run-tests.py wext_wpa2_psk 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wpa2_psk 1/1
Test: WEXT driver interface with WPA2-PSK
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_wpa2_psk 4.706991 2018-10-28 12:06:47.905331
passed all 1 test case(s)
2018-10-28 12:06:47 	./run-tests.py wext_wpa_psk 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wpa_psk 1/1
Test: WEXT driver interface with WPA-PSK
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_wpa_psk 5.769256 2018-10-28 12:06:54.220483
passed all 1 test case(s)
2018-10-28 12:06:54 	./run-tests.py wifi_display 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display 1/1
Test: Wi-Fi Display extensions to P2P
wlan0: Trying to discover peer 02:00:00:00:01:00
wlan1: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display 5.12075 2018-10-28 12:06:59.916120
passed all 1 test case(s)
2018-10-28 12:06:59 	./run-tests.py wifi_display_disable 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_disable 1/1
Test: Peer disabling Wi-Fi Display advertisement
PASS wifi_display_disable 1.498646 2018-10-28 12:07:01.917863
passed all 1 test case(s)
2018-10-28 12:07:01 	./run-tests.py wifi_display_go_invite 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_go_invite 1/1
Test: P2P GO with Wi-Fi Display inviting a client to join
wlan0: Trying to discover peer 02:00:00:00:01:00
wlan1: Trying to discover peer 02:00:00:00:00:00
Authorize invitation
Try to connect the client to the GO
wlan2: Trying to discover peer 02:00:00:00:00:00
Client connected
Invite peer to join the group
PASS wifi_display_go_invite 3.399298 2018-10-28 12:07:05.829763
passed all 1 test case(s)
2018-10-28 12:07:05 	./run-tests.py wifi_display_invalid_subelem 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_invalid_subelem 1/1
Test: Wi-Fi Display and invalid subelement parsing
PASS wifi_display_invalid_subelem 0.368611 2018-10-28 12:07:06.697400
passed all 1 test case(s)
2018-10-28 12:07:06 	./run-tests.py wifi_display_parsing 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_parsing 1/1
Test: Wi-Fi Display extensions to P2P and special parsing cases
wlan1: Trying to discover peer 02:00:00:00:00:00
wlan2: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display_parsing 2.652806 2018-10-28 12:07:09.825581
passed all 1 test case(s)
2018-10-28 12:07:09 	./run-tests.py wifi_display_persistent_group 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_persistent_group 1/1
Test: P2P persistent group formation and re-invocation with Wi-Fi Display enabled
Form a persistent group
Start GO negotiation wlan0 -> wlan1
wlan1: Trying to discover peer 02:00:00:00:00:00
wlan0: Trying to discover peer 02:00:00:00:01:00
Group formed
Terminate persistent group
Re-invoke persistent group from client
wlan1: Trying to discover peer 02:00:00:00:00:00
Terminate persistent group
Re-invoke persistent group from GO
wlan0: Trying to discover peer 02:00:00:00:01:00
Terminate persistent group
Try to connect the client to the GO
wlan2: Trying to discover peer 02:00:00:00:00:00
Client connected
wlan1: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display_persistent_group 8.358167 2018-10-28 12:07:18.734524
passed all 1 test case(s)
2018-10-28 12:07:18 	./run-tests.py wifi_display_r2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_r2 1/1
Test: Wi-Fi Display extensions to P2P with R2 subelems
wlan0: Trying to discover peer 02:00:00:00:01:00
wlan1: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display_r2 2.029335 2018-10-28 12:07:21.294642
passed all 1 test case(s)
ignored_by_lkp wmediumd_path_rann
2018-10-28 12:07:21 	./run-tests.py wmediumd_path_simple 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmediumd_path_simple 1/1
Test: test a mesh path
PASS wmediumd_path_simple 1.785899 2018-10-28 12:07:23.579587
passed all 1 test case(s)
2018-10-28 12:07:23 	./run-tests.py wmediumd_path_ttl 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmediumd_path_ttl 1/1
Test: Mesh path request TTL
PASS wmediumd_path_ttl 10.094398 2018-10-28 12:07:34.185400
passed all 1 test case(s)
2018-10-28 12:07:34 	./run-tests.py wmediumd_simple 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmediumd_simple 1/1
Test: test a simple wmediumd configuration
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan3
Connect STA wlan0 to AP
PASS wmediumd_simple 1.282524 2018-10-28 12:07:36.029586
passed all 1 test case(s)
2018-10-28 12:07:36 	./run-tests.py wmm_disabled 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmm_disabled 1/1
Test: WMM disabled and unexpected TSPEC
Starting AP wlan3 (old add_ap argument type)
Connect STA wlan0 to AP
PASS wmm_disabled 0.563496 2018-10-28 12:07:37.129336
passed all 1 test case(s)
2018-10-28 12:07:37 	./run-tests.py wmm_element 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmm_element 1/1
Test: hostapd FTM range request timeout
Starting AP wlan3 (old add_ap argument type)
Connect STA wlan0 to AP
Connect STA wlan0 to AP
Connect STA wlan0 to AP
PASS wmm_element 0.788016 2018-10-28 12:07:38.402345
passed all 1 test case(s)
2018-10-28 12:07:38 	./run-tests.py wnm_action_proto 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_action_proto 1/1
Test: WNM Action protocol testing
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_action_proto 0.666706 2018-10-28 12:07:39.580035
passed all 1 test case(s)
2018-10-28 12:07:39 	./run-tests.py wnm_action_proto_no_pmf 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_action_proto_no_pmf 1/1
Test: WNM Action protocol testing (PMF disabled)
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_action_proto_no_pmf 0.852016 2018-10-28 12:07:41.033369
passed all 1 test case(s)
2018-10-28 12:07:41 	./run-tests.py wnm_action_proto_pmf 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_action_proto_pmf 1/1
Test: WNM Action protocol testing (PMF enabled)
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_action_proto_pmf 0.723645 2018-10-28 12:07:42.316429
passed all 1 test case(s)
2018-10-28 12:07:42 	./run-tests.py wnm_bss_keep_alive 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_keep_alive 1/1
Test: WNM keep-alive
Starting AP wlan3
Connect STA wlan0 to AP
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=DISASSOC rx_packets=9 tx_packets=5
PASS wnm_bss_keep_alive 18.610134 2018-10-28 12:08:01.364287
passed all 1 test case(s)
2018-10-28 12:08:01 	./run-tests.py wnm_bss_tm 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm 1/1
Test: WNM BSS Transition Management
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan4
No neighbor list entries
Neighbor list entry, but not claimed as Preferred Candidate List
Preferred Candidate List (no matching neighbor) without Disassociation Imminent
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
Preferred Candidate List with two matches, no roam needed
Preferred Candidate List with two matches and extra frequency (160 MHz), no roam needed
PASS wnm_bss_tm 2.867458 2018-10-28 12:08:04.685365
passed all 1 test case(s)
2018-10-28 12:08:04 	./run-tests.py wnm_bss_tm_ap_proto 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_ap_proto 1/1
Test: WNM BSS TM - protocol testing for AP message parsing
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_ap_proto 0.59005 2018-10-28 12:08:05.782304
passed all 1 test case(s)
2018-10-28 12:08:05 	./run-tests.py wnm_bss_tm_connect_cmd 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_connect_cmd 1/1
Test: WNM BSS Transition Management and cfg80211 connect command
Starting AP wlan3
Starting AP wlan4
Connect STA wlan5 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_connect_cmd 1.3009 2018-10-28 12:08:07.551933
passed all 1 test case(s)
2018-10-28 12:08:07 	./run-tests.py wnm_bss_tm_country_cn 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_country_cn 1/1
Test: WNM BSS Transition Management (CN)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
PASS wnm_bss_tm_country_cn 6.351981 2018-10-28 12:08:14.444079
passed all 1 test case(s)
2018-10-28 12:08:14 	./run-tests.py wnm_bss_tm_country_fi 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_country_fi 1/1
Test: WNM BSS Transition Management (FI)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
Preferred Candidate List (no matching neighbor, unknown channels 2)
PASS wnm_bss_tm_country_fi 6.838004 2018-10-28 12:08:21.875460
passed all 1 test case(s)
2018-10-28 12:08:21 	./run-tests.py wnm_bss_tm_country_jp 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_country_jp 1/1
Test: WNM BSS Transition Management (JP)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
PASS wnm_bss_tm_country_jp 7.111868 2018-10-28 12:08:29.613278
passed all 1 test case(s)
ignored_by_lkp wnm_bss_tm_country_us
2018-10-28 12:08:29 	./run-tests.py wnm_bss_tm_errors 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_errors 1/1
Test: WNM BSS Transition Management errors
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_errors 0.725001 2018-10-28 12:08:31.074478
passed all 1 test case(s)
2018-10-28 12:08:31 	./run-tests.py wnm_bss_tm_global 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_global 1/1
Test: WNM BSS Transition Management (global)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
Preferred Candidate List (no matching neighbor, unknown channels 2)
PASS wnm_bss_tm_global 7.304235 2018-10-28 12:08:38.996287
passed all 1 test case(s)
2018-10-28 12:08:39 	./run-tests.py wnm_bss_tm_global4 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_global4 1/1
Test: WNM BSS Transition Management (global; indicate table E-4)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
Preferred Candidate List (no matching neighbor, unknown channels 2)
PASS wnm_bss_tm_global4 2.79861 2018-10-28 12:08:42.269785
passed all 1 test case(s)
2018-10-28 12:08:42 	./run-tests.py wnm_bss_tm_nei_11a 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_11a 1/1
Test: WNM BSS Transition Management and 11a neighbor
Starting AP wlan3
Starting AP wlan4
AP startup failed
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 795, in test_wnm_bss_tm_nei_11a
    run_wnm_bss_tm_scan_not_needed(dev, apdev, ht=False, nei_info="115,36,4")
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 834, in run_wnm_bss_tm_scan_not_needed
    hapd2 = hostapd.add_ap(apdev[1], params)
  File "/lkp/benchmarks/hwsim/tests/hwsim/hostapd.py", line 427, in add_ap
    raise Exception("AP startup failed")
Exception: AP startup failed
FAIL wnm_bss_tm_nei_11a 10.75536 2018-10-28 12:08:53.690255
passed 0 test case(s)
skipped 0 test case(s)
failed tests: wnm_bss_tm_nei_11a
2018-10-28 12:08:53 	./run-tests.py wnm_bss_tm_nei_11b 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_11b 1/1
Test: WNM BSS Transition Management and 11g neighbor
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_nei_11b 11.615235 2018-10-28 12:09:06.070069
passed all 1 test case(s)
2018-10-28 12:09:06 	./run-tests.py wnm_bss_tm_nei_11g 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_11g 1/1
Test: WNM BSS Transition Management and 11g neighbor
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_nei_11g 11.497865 2018-10-28 12:09:18.072521
passed all 1 test case(s)
2018-10-28 12:09:18 	./run-tests.py wnm_bss_tm_nei_vht 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_vht 1/1
Test: WNM BSS Transition Management and VHT neighbor
Starting AP wlan3
Starting AP wlan4
AP startup failed
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 791, in test_wnm_bss_tm_nei_vht
    run_wnm_bss_tm_scan_not_needed(dev, apdev, vht=True, nei_info="115,36,9")
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 834, in run_wnm_bss_tm_scan_not_needed
    hapd2 = hostapd.add_ap(apdev[1], params)
  File "/lkp/benchmarks/hwsim/tests/hwsim/hostapd.py", line 427, in add_ap
    raise Exception("AP startup failed")
Exception: AP startup failed
FAIL wnm_bss_tm_nei_vht 10.522934 2018-10-28 12:09:29.087800
passed 0 test case(s)
skipped 0 test case(s)
failed tests: wnm_bss_tm_nei_vht
2018-10-28 12:09:29 	./run-tests.py wnm_bss_tm_op_class_0 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_op_class_0 1/1
Test: WNM BSS Transition Management with invalid operating class
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, invalid op class specified for channels)
PASS wnm_bss_tm_op_class_0 6.003448 2018-10-28 12:09:35.580689
passed all 1 test case(s)
2018-10-28 12:09:35 	./run-tests.py wnm_bss_tm_reject 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_reject 1/1
Test: WNM BSS Transition Management request getting rejected
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_reject 5.898884 2018-10-28 12:09:41.983279
passed all 1 test case(s)
2018-10-28 12:09:42 	./run-tests.py wnm_bss_tm_req 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_req 1/1
Test: BSS Transition Management Request
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_req 3.484342 2018-10-28 12:09:45.940828
passed all 1 test case(s)
2018-10-28 12:09:46 	./run-tests.py wnm_bss_tm_req_with_mbo_ie 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_req_with_mbo_ie 1/1
Test: WNM BSS transition request with MBO IE and reassociation delay attribute
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_req_with_mbo_ie 6.640216 2018-10-28 12:09:53.133134
passed all 1 test case(s)
2018-10-28 12:09:53 	./run-tests.py wnm_bss_tm_rsn 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_rsn 1/1
Test: WNM BSS Transition Management with RSN
Starting AP wlan3
Starting AP wlan4
AP startup failed
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 1163, in test_wnm_bss_tm_rsn
    hapd2 = hostapd.add_ap(apdev[1], params)
  File "/lkp/benchmarks/hwsim/tests/hwsim/hostapd.py", line 427, in add_ap
    raise Exception("AP startup failed")
Exception: AP startup failed
FAIL wnm_bss_tm_rsn 10.730249 2018-10-28 12:10:04.336376
passed 0 test case(s)
skipped 0 test case(s)
failed tests: wnm_bss_tm_rsn
ignored_by_lkp wnm_bss_tm_scan_needed
ignored_by_lkp wnm_bss_tm_scan_needed_e4
ignored_by_lkp wnm_bss_tm_scan_not_needed
2018-10-28 12:10:04 	./run-tests.py wnm_bss_tm_security_mismatch 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_security_mismatch 1/1
Test: WNM BSS Transition Management and security mismatch
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_security_mismatch 1.481285 2018-10-28 12:10:06.336375
passed all 1 test case(s)
2018-10-28 12:10:06 	./run-tests.py wnm_bss_tm_termination 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_termination 1/1
Test: WNM BSS Transition Management and BSS termination
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_termination 1.043985 2018-10-28 12:10:08.051759
passed all 1 test case(s)
2018-10-28 12:10:08 	./run-tests.py wnm_bss_transition_mgmt 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt 1/1
Test: WNM BSS Transition Management
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt 1.7073 2018-10-28 12:10:10.522504
passed all 1 test case(s)
2018-10-28 12:10:10 	./run-tests.py wnm_bss_transition_mgmt_oom 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt_oom 1/1
Test: WNM BSS Transition Management OOM
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt_oom 0.931991 2018-10-28 12:10:12.377147
passed all 1 test case(s)
2018-10-28 12:10:12 	./run-tests.py wnm_bss_transition_mgmt_query 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt_query 1/1
Test: WNM BSS Transition Management query
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt_query 1.334503 2018-10-28 12:10:14.345372
passed all 1 test case(s)
2018-10-28 12:10:14 	./run-tests.py wnm_bss_transition_mgmt_query_with_unknown_candidates 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt_query_with_unknown_candidates 1/1
Test: WNM BSS Transition Management query with unknown candidates
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt_query_with_unknown_candidates 0.84895 2018-10-28 12:10:15.877206
passed all 1 test case(s)
2018-10-28 12:10:16 	./run-tests.py wnm_disassoc_imminent 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_disassoc_imminent 1/1
Test: WNM Disassociation Imminent
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_disassoc_imminent 0.979628 2018-10-28 12:10:17.546748
passed all 1 test case(s)
2018-10-28 12:10:17 	./run-tests.py wnm_disassoc_imminent_fail 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_disassoc_imminent_fail 1/1
Test: WNM Disassociation Imminent failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_disassoc_imminent_fail 0.707111 2018-10-28 12:10:19.107410
passed all 1 test case(s)
2018-10-28 12:10:19 	./run-tests.py wnm_ess_disassoc_imminent 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_ess_disassoc_imminent 1/1
Test: WNM ESS Disassociation Imminent
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_ess_disassoc_imminent 0.898813 2018-10-28 12:10:20.641968
passed all 1 test case(s)
2018-10-28 12:10:20 	./run-tests.py wnm_ess_disassoc_imminent_fail 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_ess_disassoc_imminent_fail 1/1
Test: WNM ESS Disassociation Imminent failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_ess_disassoc_imminent_fail 0.852755 2018-10-28 12:10:22.162744
passed all 1 test case(s)
2018-10-28 12:10:22 ./stop.sh
2018-10-28 12:10:23 ./start.sh channels=4
2018-10-28 12:10:24 ./stop.sh



To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email



Thanks,
Rong Chen

--oP9at/Ymg5VWhwKB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-4.19.0-rc6-01867-gd3e95c3"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.19.0-rc6 Kernel Configuration
#

#
# Compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=70300
CONFIG_CLANG_VERSION=0
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
# CONFIG_BPF_JIT_ALWAYS_ON is not set
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_INTEL_RDT=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_QUEUED_LOCK_STAT is not set
CONFIG_XEN=y
CONFIG_XEN_PV=y
CONFIG_XEN_PV_SMP=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_512GB=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_5LEVEL is not set
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_UMIP=y
CONFIG_X86_INTEL_MPX=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_EFI_MIXED is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
# CONFIG_LIVEPATCH is not set
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_DPTF_POWER is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_PCI_PF_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_PCI_HYPERV is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#
# CONFIG_VMD is not set

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_HAVE_GENERIC_GUP=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Tegra firmware driver
#
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_MMU_AUDIT=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
# CONFIG_VHOST_VSOCK is not set
CONFIG_VHOST=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_HAVE_RCU_TABLE_INVALIDATE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
# CONFIG_REFCOUNT_FULL is not set
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_CGROUP_IOLATENCY is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_ZONE_DEVICE=y
CONFIG_ZONE_DEVICE=y
CONFIG_ARCH_HAS_HMM=y
CONFIG_DEV_PAGEMAP_OPS=y
# CONFIG_HMM_MIRROR is not set
# CONFIG_DEVICE_PRIVATE is not set
# CONFIG_DEVICE_PUBLIC is not set
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_NET_FOU=m
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_ESP_OFFLOAD is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_TCP_CONG_DCTCP is not set
# CONFIG_TCP_CONG_CDG is not set
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_ESP_OFFLOAD is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_FOU=m
CONFIG_IPV6_FOU_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
# CONFIG_NF_LOG_NETDEV is not set
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_UDPLITE=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
# CONFIG_NF_TABLES_SET is not set
# CONFIG_NF_TABLES_INET is not set
# CONFIG_NF_TABLES_NETDEV is not set
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
# CONFIG_NFT_CONNLIMIT is not set
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
# CONFIG_NFT_MASQ is not set
# CONFIG_NFT_REDIR is not set
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
# CONFIG_NFT_OBJREF is not set
# CONFIG_NFT_QUEUE is not set
# CONFIG_NFT_QUOTA is not set
# CONFIG_NFT_REJECT is not set
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
# CONFIG_NFT_SOCKET is not set
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_IPMAC is not set
# CONFIG_IP_SET_HASH_MAC is not set
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=m
# CONFIG_IP_SET_HASH_NETNET is not set
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_FO is not set
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
# CONFIG_NF_SOCKET_IPV4 is not set
CONFIG_NF_TPROXY_IPV4=m
# CONFIG_NF_TABLES_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_DUP_IPV4=m
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_IPV4=m
CONFIG_NF_NAT_MASQUERADE_IPV4=y
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_SOCKET_IPV6 is not set
CONFIG_NF_TPROXY_IPV6=m
# CONFIG_NF_TABLES_IPV6 is not set
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_NF_NAT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_IP6_NF_NAT is not set
CONFIG_NF_DEFRAG_IPV6=m
# CONFIG_NF_TABLES_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_CAKE is not set
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_DEFAULT is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
# CONFIG_NET_CLS_FLOWER is not set
# CONFIG_NET_CLS_MATCHALL is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_SAMPLE is not set
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_VLAN is not set
# CONFIG_NET_ACT_BPF is not set
# CONFIG_NET_ACT_CONNMARK is not set
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
# CONFIG_NET_ACT_TUNNEL_KEY is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
# CONFIG_VIRTIO_VSOCKETS is not set
# CONFIG_HYPERV_VSOCKETS is not set
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_MPLS_ROUTING is not set
CONFIG_NET_NSH=m
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_SOFTING is not set

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_FAILOVER=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# Partition parsers
#

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
CONFIG_BLK_DEV_FD=m
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
# CONFIG_XEN_BLKDEV_BACKEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_VIRTIO_BLK_SCSI is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=m

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_FC is not set
CONFIG_NVME_TARGET=m
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_FC is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_MQ_DEFAULT is not set
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
# CONFIG_DM_WRITECACHE is not set
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
# CONFIG_DM_INTEGRITY is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
# CONFIG_TCM_USER2 is not set
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
# CONFIG_ISCSI_TARGET_CXGB4 is not set
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=m
# CONFIG_GENEVE is not set
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=m
CONFIG_NET_VRF=y
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
# CONFIG_NET_VENDOR_AURORA is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BCMGENET is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=y
CONFIG_TIGON3_HWMON=y
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
CONFIG_BE2NET_BE2=y
CONFIG_BE2NET_BE3=y
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_EZCHIP=y
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=m
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_MLX4_CORE_GEN2=y
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=m
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_HWMON=y
CONFIG_QLGE=m
CONFIG_NETXEN_NIC=m
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
# CONFIG_SFC_FALCON is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_SOCIONEXT=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
# CONFIG_MDIO_BCM_UNIMAC is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_ASIX_PHY is not set
CONFIG_AT803X_PHY=m
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BROADCOM_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=m
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_LXT_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_MARVELL_10G_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
# CONFIG_USB_NET_CH9200 is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PEARL_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=m
# CONFIG_XEN_NETDEV_BACKEND is not set
CONFIG_VMXNET3=m
# CONFIG_FUJITSU_ES is not set
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set
CONFIG_ISDN_CAPI=m
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPIDRV=m
# CONFIG_ISDN_CAPI_CAPIDRV_VERBOSE is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
# CONFIG_RMI4_CORE is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set
# CONFIG_RANDOM_TRUST_CPU is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
# CONFIG_I2C_MUX_MLXCPLD is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
CONFIG_PTP_1588_CLOCK_KVM=y
CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_LYNXPOINT=m
# CONFIG_GPIO_MB86S7X is not set
CONFIG_GPIO_MOCKUP=y
# CONFIG_GPIO_VX855 is not set

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set

#
# MFD GPIO expanders
#

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set

#
# USB GPIO expanders
#
# CONFIG_GPIO_VIPERBOARD is not set
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LTC3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_IR35221 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_CLOCK_THERMAL is not set
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
CONFIG_INTEL_PCH_THERMAL=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
# CONFIG_WATCHDOG_SYSFS is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_INTEL_MEI_WDT is not set
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS68470 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
# CONFIG_LIRC is not set
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_XMP_DECODER=m
# CONFIG_IR_IMON_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_SERIAL is not set
# CONFIG_IR_SIR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_DVB_CORE=m
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_DIB3000MC=m
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_USB_DVBSKY is not set
# CONFIG_DVB_USB_ZD1301 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_DVB_DDBRIDGE_MSIENABLE is not set
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
# CONFIG_SMS_SIANO_DEBUGFS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# Media SPI Adapters
#
# CONFIG_CXD2880_SPI_DRV is not set
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_GP8PSK_FE=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#

#
# AMD Library routines
#
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
CONFIG_DRM_VGEM=m
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_PM8941_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_SEQUENCER_OSS=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_PREALLOC_SIZE=512
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_BCD2000 is not set
# CONFIG_SND_USB_POD is not set
# CONFIG_SND_USB_PODHD is not set
# CONFIG_SND_USB_TONEPORT is not set
# CONFIG_SND_USB_VARIAX is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
CONFIG_SND_ISIGHT=m
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_FIREWIRE_MOTU is not set
# CONFIG_SND_FIREFACE is not set
# CONFIG_SND_SOC is not set
CONFIG_SND_X86=y
# CONFIG_HDMI_LPE_AUDIO is not set
CONFIG_SND_SYNTH_EMUX=m
# CONFIG_SND_XEN_FRONTEND is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
# CONFIG_HID_BETOP_FF is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
CONFIG_HID_PRODIKEYS=m
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GOOGLE_HAMMER is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
# CONFIG_HID_ITE is not set
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTI is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=m

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_HAPS=y
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_BDC_UDC is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_MASS_STORAGE=m
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
# CONFIG_EDAC_GHES is not set
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
# CONFIG_EDAC_IE31200 is not set
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
# CONFIG_EDAC_SKX is not set
# CONFIG_EDAC_PND2 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV8803 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RX4581 is not set
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_IMG_ASCII_LCD is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_UIO_HV_GENERIC is not set
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
# CONFIG_VFIO_NOIOMMU is not set
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI_IGD=y
# CONFIG_VFIO_MDEV is not set
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TSCPAGE=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SELFBALLOONING is not set
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES_DEFAULT=y
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
# CONFIG_XEN_PVCALLS_FRONTEND is not set
# CONFIG_XEN_PVCALLS_BACKEND is not set
# CONFIG_XEN_SCSI_BACKEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_SYMS=y
CONFIG_XEN_HAVE_VPMU=y
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
# CONFIG_RTL8723BS is not set
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_R8822BE is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_FB_XGI is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_DGNC is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
# CONFIG_MOST is not set
# CONFIG_KS7010 is not set
# CONFIG_GREYBUS is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_PI433 is not set
# CONFIG_MTK_MMC is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# CONFIG_XIL_AXIS_FIFO is not set
# CONFIG_EROFS_FS is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACERHDF=m
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_SMBIOS is not set
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_WMI_LED is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_DELL_RBTN is not set
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_SURFACE3_WMI is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_INTEL_WMI_THUNDERBOLT is not set
CONFIG_MSI_WMI=m
# CONFIG_PEAQ_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_VBTN is not set
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_IOVA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#

#
# Broadcom SoC drivers
#

#
# NXP/Freescale QorIQ SoC drivers
#

#
# i.MX SoC drivers
#

#
# Qualcomm SoC drivers
#
# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_INTEL_INT3496 is not set
# CONFIG_EXTCON_MAX3355 is not set
# CONFIG_EXTCON_RT8973A is not set
# CONFIG_EXTCON_SM5502 is not set
# CONFIG_EXTCON_USB_GPIO is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
CONFIG_ARM_GIC_MAX_NR=1
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_NVMEM=y

#
# HW tracing support
#
CONFIG_STM=m
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
# CONFIG_INTEL_TH_ACPI is not set
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# CONFIG_FPGA is not set
CONFIG_PM_OPP=y
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_ENCRYPTION=y
CONFIG_EXT4_FS_ENCRYPTION=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_F2FS_FS_ENCRYPTION=y
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
# CONFIG_NFSD_SCSILAYOUT is not set
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_COMPAT=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_LOADPIN is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
# CONFIG_CRYPTO_DH is not set
# CONFIG_CRYPTO_ECDH is not set
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_MCRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m
CONFIG_CRYPTO_ENGINE=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128L is not set
# CONFIG_CRYPTO_AEGIS256 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS256_AESNI_SSE2 is not set
# CONFIG_CRYPTO_MORUS640 is not set
# CONFIG_CRYPTO_MORUS640_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280 is not set
# CONFIG_CRYPTO_MORUS1280_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280_AVX2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA1_MB=m
CONFIG_CRYPTO_SHA256_MB=m
CONFIG_CRYPTO_SHA512_MB=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
# CONFIG_CRYPTO_SPECK is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
# CONFIG_CRYPTO_DEV_NITROX_CNN55XX is not set
# CONFIG_CRYPTO_DEV_CHELSIO is not set
CONFIG_CRYPTO_DEV_VIRTIO=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_XXHASH=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_DIRECT_OPS=y
CONFIG_SWIOTLB=y
CONFIG_SGL_ALLOC=y
CONFIG_IOMMU_HELPER=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_SBITMAP=y
CONFIG_PRIME_NUMBERS=m
# CONFIG_STRING_SELFTEST is not set

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KASAN=y
# CONFIG_KASAN is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_WW_MUTEX_SELFTEST=m
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
CONFIG_RCU_PERF_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_HWLAT_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_TRACE_EVAL_MAP_FILE is not set
CONFIG_TRACING_EVENTS_GPIO=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=m
CONFIG_TEST_UDELAY=m
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_MEMTEST is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set

--oP9at/Ymg5VWhwKB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='hwsim'
	export testcase='hwsim'
	export category='functional'
	export need_memory='4G'
	export job_origin='/lkp/lkp/.src-20181026-121544/allot/cyclic:vm:linux-devel:devel-hourly/vm-lkp-hsw01-4G/hwsim.yaml'
	export queue='validate'
	export testbox='vm-lkp-hsw01-4G-22'
	export tbox_group='vm-lkp-hsw01-4G'
	export submit_id='5bd5340e0b9a93ff805611ea'
	export job_file='/lkp/jobs/scheduled/vm-lkp-hsw01-4G-22/hwsim-hwsim-12-debian-x86_64-2018-04-03.cgz-d3e95c31e68e09731b3ac5dec3b8835211bb2072-20181028-65408-17sqf13-3.yaml'
	export id='2952279021d5b8853f80e5130a81f57ac9249213'
	export model='qemu-system-x86_64 -enable-kvm -cpu host'
	export nr_vm=24
	export nr_cpu=2
	export memory='4G'
	export hdd_partitions='/dev/vda /dev/vdb /dev/vdc /dev/vdd /dev/vde'
	export need_kconfig='CONFIG_WLAN=y
CONFIG_CFG80211=m
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=m
CONFIG_MAC80211_HWSIM=m
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_KVM_GUEST=y'
	export commit='d3e95c31e68e09731b3ac5dec3b8835211bb2072'
	export kconfig='x86_64-rhel-7.2'
	export compiler='gcc-7'
	export rootfs='debian-x86_64-2018-04-03.cgz'
	export enqueue_time='2018-10-28 11:59:10 +0800'
	export _id='5bd5340e0b9a93ff805611eb'
	export _rt='/result/hwsim/hwsim-12/vm-lkp-hsw01-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/d3e95c31e68e09731b3ac5dec3b8835211bb2072'
	export user='lkp'
	export head_commit='91ca70c8f6d0511b53461808722ade3610096140'
	export base_commit='84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d'
	export branch='linux-devel/devel-hourly-2018102706'
	export result_root='/result/hwsim/hwsim-12/vm-lkp-hsw01-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/d3e95c31e68e09731b3ac5dec3b8835211bb2072/3'
	export LKP_SERVER='inn'
	export max_uptime=3600
	export initrd='/osimage/debian/debian-x86_64-2018-04-03.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/vm-lkp-hsw01-4G-22/hwsim-hwsim-12-debian-x86_64-2018-04-03.cgz-d3e95c31e68e09731b3ac5dec3b8835211bb2072-20181028-65408-17sqf13-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.2
branch=linux-devel/devel-hourly-2018102706
commit=d3e95c31e68e09731b3ac5dec3b8835211bb2072
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.2/gcc-7/d3e95c31e68e09731b3ac5dec3b8835211bb2072/vmlinuz-4.19.0-rc6-01867-gd3e95c3
max_uptime=3600
RESULT_ROOT=/result/hwsim/hwsim-12/vm-lkp-hsw01-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.2/gcc-7/d3e95c31e68e09731b3ac5dec3b8835211bb2072/3
LKP_SERVER=inn
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-7.2/gcc-7/d3e95c31e68e09731b3ac5dec3b8835211bb2072/modules.cgz'
	export bm_initrd='/osimage/deps/debian-x86_64-2018-04-03.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/lkp_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/hwsim_2018-09-18.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/hwsim-x86_64-cc6263ef6_2018-09-18.cgz'
	export lkp_initrd='/lkp/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export repeat_to=4
	export kernel='/pkg/linux/x86_64-rhel-7.2/gcc-7/d3e95c31e68e09731b3ac5dec3b8835211bb2072/vmlinuz-4.19.0-rc6-01867-gd3e95c3'
	export dequeue_time='2018-10-28 12:00:06 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-lkp-hsw01-4G-22/hwsim-hwsim-12-debian-x86_64-2018-04-03.cgz-d3e95c31e68e09731b3ac5dec3b8835211bb2072-20181028-65408-17sqf13-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='hwsim-12' $LKP_SRC/tests/wrapper hwsim
}

extract_stats()
{
	$LKP_SRC/stats/wrapper hwsim
	$LKP_SRC/stats/wrapper kmsg

	$LKP_SRC/stats/wrapper time hwsim.time
	$LKP_SRC/stats/wrapper time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper last_state
}

"$@"

--oP9at/Ymg5VWhwKB
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj6b+h7/9dADKYSqt8kKSEWvAZo7Ydv/tz/AJuxJZ5
vBF30b/zsUFOhv9TudZULcPnnyAaraV0UdmWBL/0Qq2x8RyxDtkd8eDlFp664TyRWk15adee
FsGoNV0CFcUhdzRTXPevHYdBUb+I37y3jxW+irGuJukmzF1Q7RKULErU8ZkS9LAvGhxi7TVX
YE5DNsVPn0EMrfmIrO3yLZoUWNpuQ9WX4XpineW40Ch7b+yoHI97Yw8oKgR324ObFiCglhWR
ap3zbDRPnnO/7C9SYJKp9L2EkZ0op9H0XYs9+2Hn0LLYnHPlcQQMN+0y9HFXeDeRYJHQ9sM0
u3PJLbWpyBCSxbQsCbOiNlbnqSopwPQt8Jfbs8j0RZMdgnG2tFrDkw2DBttdo+im3swBJ4nU
pdS1NyT0wiaUpOspZou0HnJM132XOlN63oBS+vW9/Igu+4Rbk4GaLEtoxs6KTNNdedYLMSHt
0OJSNn7FztpKnzKw7LnxVmHeF0lNKFxqTIgCJ6E+CgfVS6P0MLb+XVQufqPaibMWhouE51lz
Dmyv99gcZRwVmCQZfO1Q1eWbnSRp4gC7amDumPTHNcXX/+W2hwJkWwnLS4kOssHP2hJrSpPJ
uvR7emkREHZB20Wbrcf/YcOFnDvi4oG7Zcq7MMlIuGJKtktAokEpV4pTYdE4Ce/r5uTkXA/C
zCrbuZmWQ/hSMI3GkTgMcY+BOkbFK5vMDYDAHIFtebGcMnsyUCzjsXweL8crbOy7UQelQDYy
eu6p7tp4NVHziPOsZmRib2thbB6B1azhaJKSxIynOmjQ/y4acLq+X39odNn5EYBrH75AATLJ
NjAt4EsH1oATIb2xEIB/+FfMUupMj3tJBEQCnyyzpqJ0moKJaJlYKswKC4t+dhUxzs+GxrUo
xQknRuOD3VJHk565CUfwac6vrFB9ogi7rs/Dr0AhsjZxDgwUOt9auT77KUvQDnB9pLnUE3MF
ucCW1wEf+m3FcGXtVThsLj0i1FZvYxsIOxmefnjJeEs/txEKt/swW9SaK6hvQfLtJMBKlEeR
3BAWadsisiMzptL21pNNFps4xH96wGOh5z/0ZNbQPx7bsgqCs/FX/Puyz27/clqHn0UQ9jdK
07z3+gnOmtsZkANoaWf7nLvUVBDVZ52QLUGRKyukeXTI069/ozChAxrcNadDUP1SxJBy9DwA
fmsjxJMUB9iNth8hWokqi/IT+wi+y52AZI/FZFiyyPm2ls1xd1I6rw1+oxGCGwm5HPh6QFrT
MFwZrg6M3RmMnRYcVJf8ZOHYVf5MOyykt0COkR9FA8dezlxVjdcHsc29uKmFDAnc/BxkkJFX
Y8MMwMFE+0edozHEDzuA6tPuQChCdIT2QOXcCDrAmPZi3FgIruA5OU1TYDPf4ULC0hnFpfqQ
HJTuoR5sps5meIViFME8NFsjax4GEGkVS+t+GgotD9xrutRn1cKLfhAG4Bxa7fHCV4frKK+/
d1L4nkIDxPq9QnebUWEgwboBQIc9PUANoMpQGtW+ioK7wH6qqfbeYOfKOGdC5E5rdiVzXrPw
4wg9iUFAVd7Xa+BrQThTXzyQGnPiEP2vT4deMWDosBldEQoPLAR8Z14Du0MkiCoedW5wu34V
YVfTXPjBjlx+bNgjghsvJEAAz/Mv280PEdZHHdqFYwmVepz6bvPxfkX5mswplZg3y/tTJ99j
s5CsHEgoCaQXabT3qDnKPogYmInllAGYcG2t/jr0TeMSUWCGoccwfROoPYNoiZxd39nVCyaQ
s+MRacPOgoFLsm0HciFNC+u4OPj+i7ACmXfXve8a9AzUBMFTQPpQ+lGHbhGuJ/QpfC6/EyBY
SFbSmWbwt+WExVItjR56xkcKDKrnYt3tYpPxcmUt7vG6TFjLuIyPz2AB0GGQmbVrPmRdmUu5
FyvM53Oa7UDb3aCi8B24X3ClX6D9EGrjtAy96ICrMZ5ATcVFwAVfMiEGiAwK2GOofv6mkqC/
pTjOXY+G2Eh2SMv64SSRcO4gmX6DATxhydQYJm3lTPYYg7/WdWI4t3hANV/pzdlNZWHy1OQg
+ckZjxNTX0wOS6K6fGl/90y/4veBNYLu8/56WZOtOS2Bu0TWoMwtvTZYw0r4XHkqaJkwJA/v
M7JbT4qwOPgwoH/PPFlfe79NApzIyq7xNMC/oISYN7dJd6K3iMN79DYhAHVqy7hjs0hP3ldw
g1aD1cB2HttyT+5AIgdgRTeuhoFl8LK9zmh7DCGYUmt6kO3zv0j8AcH0GU60apYBo9qMJD7A
RlQ6IbF6WqGWGcNNgq0IuZ8g7pCheaCDP22+Z98N1vac3IBr3KNXdHmI0zFoKk9H7GHlX4y2
vXRscdhNKwd96C5erWFQh1hllMFYlsg5mvEb2loXdvs8JUoKGgkJJogEV43MDCURNDXdCDQZ
lxDU/8Wfvoce359EW+jkYVdBZQfyAMjgm/LBYn0YyAH7UDIPKzZBdF+Gk2uLIiMkvia1/cFw
TYaCcMjikaGiQ+yxwbQje8fU7lCJv+1NmxQrhiBsnZR//Fk3pbGfRUxQ9J17g0S3AWeHQFr3
qNqyXZmnfIRT4xFZW2b4VGlKFsahnPD9SiH7T36XeMxyVXRnSIdYdsDnbtBSFwFmLTOYwubE
UYbRkEsu/zL69vi/VJPw/yIZqPLn/z8w8rT2nLi0WeapvJIlamsVTXmiWFtBsFSxLmT+Mp6/
4DkO/C2D3XlO4UFa8xZqSLBS9IrGOpdHgDFioRF/21480IvrOVg5ZOF0ykFxNlL06+bxForF
jlUPxI+leZCRNN//BxzWD58PACuUDsSSTWIYs8jnxZM1LhyMym0WLgrmQ6vNISK9btrmVbrq
GKSLp7OY1y7Wu0aIIkh6XlhMOWS1xSYOuuEL4MeUQ3lX4BDm103J+TjsAzMLRGaZxQLUrlea
WH2TPLbTkkXkwISOwpMKghdRAxRgDm9qMKoQCWMorQ2vaeuTb0uvsDzn24G/urUycXT5SPCv
5lpgDtsxxwDffMKC+1HBU9/112WFGE2MX30WpZQ62OrmFSx5o1t/6gKI+OSkgeMQjHSxccg1
6KU+IL4mxV+5Z6s8tVeIk8cAfq8jJg9e16mq5lOx8KkqPudiPAgyLOqs7k9HEu0vfL/CeJGz
O5Jw5bAGRLjV/Rmv74gLcTKtfIyPlpO5E9GIgIlV6hIp0+x27mZ+XaZmdFBC3pwi9KrjOqPs
TFdhaIFz7UDUHIk7SWLlLN7uHkmHIYxZSNiTgVWKNbrAlIJaHtEKVx3BpokMFUQnE3pFf/mR
iml2tem+U2Z9QqvTAwxMdViNVPxF340n7IZR2w2tCY4t9dwZ0o6W3CQkyxyCbDrGejh4qumu
IBtV0fUYmhqjv8zbPCnXWvp4ZBpyO/HnaFd0sMvltg3Tu2x6clJHCYeJeDdKl2BxtxmXuSip
auHdtM6k3XVZ20alwzo+dLa74zYbvW/Nzytxlkf+2NAD8uzXNW+NJwJQbb5dBMWWWKP6nYJh
b19FE/PAzz96S7UabP8Yr7LNWI15ECuZbr143r7+rJmgol76EaoFW/j2gHHXV+qu1Wvevjse
2GTDGvE8advx2tBP5zpeLmMQ+rZ8rqLMcB43q/ukpsXfiUgmxJ8VZMAzbSPHbrFDSBNlb60/
D9sbqx5Uf2zRwTI6HtvAqTvuqvEF2ZTra5xuFcngI+aDhZCr2gfhcbDXayY2IWlpmBod56Xv
RNVTq+zJnTZpduF8/yfQOiJwAAfSalIext3fjFhEIpbW9P1S5+UViAXfy7c4/hIAiawJnL+X
IfR6dE4BCN+oN9EZhStsb8qrQLotza68M3XEvXS/JY9MPXNXA9UGuOmNjkE6A0tmLo4RHbxf
VhcXHDCigYOsNxcnnPHISNaHSB9VK94XMbbcOwAxRqdy+znUWKFeehRb5QYIjyuJjT6vD3Va
q49wEJoo9sAX/Lq7PGinSUBFxtAoF8ChMFfXLvRQyvP5avt9Eq/1JvVc9nNciR+FdeKbefSB
lwlaa+2CzOqxRt4Fnib7OdPcYI5JqW6MG6xmA4P1DkHJXHxWWF/qt8QC7fNVz6V93Meeg4g5
B5B6Unkv/MWVzYDJ2oxBHw68OjU1wEHB0iJKBi1CQmz2L579XWhPdRnO91jGniteDqp77VbQ
ss24j07skEovlH2RmwGpWTHhp+YHVHzmZCx9/dohLBxy5TrK+KkUSO/Z1f0KO9lnIzllD0QL
OBVcc1NdpvpJgdbYV0PsXyw9zsI6ceGQ55d11ck0ZOtwAcQxqFRbiueEL+/EhfFJhdDYDjym
KJMC7KoO9nwjUE5NGAx48oXsQ4ybDmFcOaGmBMr7LQl0l/tJqVuAzA+DJoa7NSVkdjsQ1aFl
vSiv9EFVPjN9EF+qQQVVhIHuIt705+YCET896ARnsaqGVQ3NT263do6T33VnUwaae2oBwGUi
ytJNU2ZmsIOUSzdRBtKlRbA+Zt5YTk94+bO9ZZ4upLputxjBEWbuxsgFcdcD4EUFpBWs+axP
CDjF4rZw7wxQ+pGzF5hZRNEQR7X1qMqGDFbyrnQ2dtHR8xAd7+w1Jx6gvhociC6yMAmrJ34r
UEy/3tpdbsaC826B1UpK5tR1NDHRFP5JnZS/HIHBulT0qHNv61XuCO2e4jRTENXslUAqqJ/V
envos5n3Ju6dk6CvkEKtJTJZ0eX+hsp+uXdZzsfBC562oWiII13UkjuxDJcCoyuxG9bSVrsm
8VMgN8KPw6zYCRWLbenwGCSMqGdBOgctii7L8zsZIbrzdTL5vTBJLQggByBRGGu5MfU84+Ye
NTr/exCl5ZbvD6XqeBYwyH4btwOfQWuhfh9TmWh9utIcvKa5atkU8B59mUQPDRRZgeMxuW4O
BlvnXltvwj5XTLp0LNGf6vMga2+h4QstV9ZHohSqARgh5FHdzswOixffBnN1fDDEh2+NqPkB
FFZpxNViLpUo99NH3tbb/jEtGsLOLDuBlOQVtb0qmiA+tWcFxW0KzikV+/NlGwe318mR3QJg
0mU25ToJAK3CXsHVkRLD1K3cL7vgJbVQZg2MgoVDMbmSIyI8h8NsFnAQg967kQrmNwOiqPo2
uWb6JbUfprW5oegCQfGXLERMZoIjH4WMiwHjRB/LuBanA8zzsewSvtIt79XvUQ1oDkIzqT7/
fPn8mKqROfVdP4B1t7Qe8rzt732+icATIFXi0Q8wjn3DkMpEeDxAl1kdmv1iuS30cyM9P9hY
yQrz2XYCYGYZKqEOAaPgrQjieNu3hqfzHgeJAuAbAqg9jDGtvE+gsxpaJkI2ohgUlVy5OUP6
m1LxxcvYJfHnVHEfr7onNVzw8IplYk3WUGhtLx7k8p3ZRwnwn3D4WzsfT9VCeNGmgttOtst8
R4zaUer8ICUFz5cIPcOm/4kb7R6u2awot4kKXi6g8spvTToOBpDVo9H95p9gKMP0Q1lwzwbO
8JcnXnDQUUBPql8+eEJQ3CLke8p71szJCTEu125QHtKkwXfWrFFaxiRMAOTS8yaBhuTTzmrM
xCt1WsbxqcEiTJcrz84oqTyuT2+wMzr1mP7uTDOEkVTm6YWErXGNBrTf4daCdZOObbCIwXAb
NNsVcw+LF9IcQNV+xoWJX/Imj10TTJF6rIMxnCSXw5L0sN6QA9jN6WC0V47kssJFFvmkHo5w
5ptYmtG5JQszYpK+0J2eYSME2BdE7sDzysP3F7r+rH5bu5G1aRYHcvoMhpkmI48GOyRMxibI
QWuw7LnZvo+AWJHReOoReqeMkTxWBE0eoPF16g1dczYFAGnVUmimu/kI0c1wz9x6uwTLzAhg
ettcz2KyLV6OfrStBN4+KTqrfC08+CW8Dh6hVuy4g9TSLH5lQNj2qRacmu4Ra6HyFDnIfa4i
//z1QWe0DOOEPKCFBrqoWdtxACu4B6/ZX/U1q0HzrvfFynZI2pUcS/3YLFfjPVfTMtBASQ1y
lE8AOvU3kNQ5j5mfOaS30grU9cT2laqckuJDzS2f2roaN9WLJZhbs3mhiAi43G0ODHHTa/1F
YtwE50zIhpUjFzfZTx5Dc7rrDYn8demTpZHZ4lz7VXuDDhCCzlItHaa8VewH0Irt6EZGxpiV
8jrxPXS8WkFDRUI1jv4FyqXj+jJsPimQBrDuTFuAQV5eRiTp7vzwu/oq+/K9kAlIPL/3IOUV
13rs/H34evWxHMWDRCcNSeLBKm+vVfBKa46KinYYpx9rlaqcB/I1Zm7oRk1eFCkc3z5jodax
y+S3oJIsm5lBCQ16+8ZrWuyOaanLuEuAtYsYl6pk6XW5P9Ys3DZuaZd0R8gT6/JBOKG9hZFZ
3r3LvEwpZY1yxAbmVsiiU8qdBq/2x+FDA5VVJi3v+uD+79cZ8Wt7+wIF1ynKUW1fHLnSvfJ0
+SVolj4KadEGbGhagZjPHVY1mD27GU31P/jvnML5SjptnoUEJspb4nwyqnrEifZAimJrgMUU
nN+0FGWwmNxg1FV1WnLU0Ujky6qWmOsMSjhjq9UbiMRAHnlyMRkEE46oI6NGRqFCjh6jD3U1
YOEsHmwQSf+WH0Y/xjuGcHiwrm67WZZJVwsvQvUIlkWkM10uVo0m/XEouihDSKmVN1sEYevx
Lfe6WnbM5nX1t1SRI0BDY7WuUvC4vc+5/hxiND8p8NPjkM++NE6LLbtCK4xrmqRMdDdBf4e1
qMQY7Y9vfr/tvcQ8pEqoaa1bJfOqc/MfPHO0NFdFznXsbG1HVxL+l39hPB9hpR9tPkD3Wb3K
6j99h2YmiH8lPtUKknpcpKV5EKe6oHBC6qjlhHVXIXkVY/mpIuMpHr8APj012rfAEdCh4Qm3
WIYyrDXp8xJ6fr0QrCoBX8dZo0E82Jglim9KLVTVoucxyF9appLX6mSJjr9V4HtjyGmg9bHC
jRUg2wvgWAdJ2JHu5M/Gi2ocpsFP4XMLQ2RmojhmjgM8Zw+MS1waJke9H78VRQxpBcHUj0H2
mB7wQeEtpKGsr43gCU7MS8Qhs7GO/q7Ciq0qHhHeopYnv68kXbTfCJ41fOUOhiVdcuS991HK
1Bmdu6kdqon9SvAaZtSeU1uzhaSOf9FirjLj4wVVj8iqWJGsUQBy6C0c6hpl0qLUMfNIGNU7
n6IIZfGajj1w4Fxq6JB7KneucE27EnMCXPPiS/PAi5MuKsmXmKxwixEIP7Rh+TUTpOPqnsEq
HdTuQ2g3cpaE+Y8w73mPZjB9oeYhLcc2s4Q238k09RNb/PWVlfftxC0UDGc7MrdHJoN3MXx1
nf7SMuT/cM3Pn9VIeGnE819rAxGdZgeTuY5LPXQQkBJWJKBMeWNf4l2i2ZPX7ztRUQz9jMnp
Z8iVkYRRN494fk2IKwonOZsI077LQ9PUXUn+nl9k6ODiKYMqjcjmcV3vrNUfh1cWKWClMS7e
QpOfIAex+0+fLuhXqQR14j13dZ7bf5kiZGZj1rvmkkskGtZR00LuyZPptmqlLXmfoVbM78Cv
Kopso1nYT+RM5Vuvcu6MX1anbqlrCbHlRAdBfG0Vm/0EysGMjJQDHIhCO2aFjJUDNeNARd+/
d+2q9ocICuY3OhH11VdwRCfZPatMvNqbcn7i4wLRYmdIu5uJZlXywRt4a4Tu+ABuh83/jsi0
r/BzGAVI1qpJmfu0L61awPGdPb2ZLpFl/B81WjDFXAOBKBLGkQIxdZjTYlAhak2fhS95yMdq
Ypgikjb9TnKSRjXLlqfUh+4ky9mCqhQEO7ynNNz8QtpzjtkK+ar+bQ35IOEcMx1fSm0y+YRh
0+lVjqPxxtJaEVrhIC3GJTWZpk9AMLQWKswvatOz3WobbT5NWAY/nMldZRAWFdLafjHIAuLi
g1ETKn/vnvK7q5RFqUnJNkbVjHLbla0kLhXbdc10S1E+TVP59MJToaP5cFS8URnUdsDXG8lw
j7jJsDC21u3TePzX7jTHt/MzqnRh7BSLK9TARvVtVopL051ScoqEamDG7Zl028sJ/7ZX5aDI
v2Cv9X8cMu1bH6DKCejqTXq9JGhnMAK6fKURw4wxDPV44tic5WEHw45gNK5Tee21yipuN54d
h2YUBSxQbpUQJ18ngByQEBWNWP61JENkBzEjMAUJezKdlhGNJN3/mNlLPntvHV16NVwI0yWX
uVf/PgYN93XbAJFvm5VoDHAqjVC46PHMDZR/3faFXQTtYvL/zb9vbSu7n0vQjTPumg7qgv3M
E/OQ8u5d6k1WfvyYJ18AAyFhqVZnGFA9kRBHVUJlD+1ac5d3AQFf/k5F1OnVokF2uo7eLP1R
WwrrVoVOz61gvkKvv0qUc51/uNlXaFVdjVoVHKfvRtZp5nbZvmmyBYHhWDLXS087OuMX3VYo
axh2Hp60qxPwnZcHeOgJvia2gamEq9dSg3Sp1CqJX9hfJwUnN29fyN5cz38yPY33RKLGqprt
zW7yJf0/evYaCO0Vd8xuZZoQ78C22WjM2U2nAdZLkouLTcALS0WchDfcbCFQ5OT0dsx2Zl7a
v7tSurRtF7HejxJGOpzI7XM1v0BundieWMW9WL7XO7Bl6d4Y8RLFt6nZDnUTWzzrLGMOcWJt
B/xmbS19INiqDJIBf6GzCXzQR4k34apz7RybAO2h69vAKs4OyiY81R47nEUajk4lWK851k9r
q/zCeUqGw9K0ik4gKJfjVR5/i6eKiWngYVHGcwCyZYJ3qjhH1rzBbIBRbmu4yXxUSFv8+sXa
ui8scrmkxvlRn510Mnl0i3kW3SK+CRqk7N3FrvJopsHAHxlbt1NkF94ukTuNQgS7hVLhIlnV
urVWHU5yBnGIQKxy/UVEC+4EiNeHKRiLV7hitDGliiohr48LXQj/ZV1J+qEulH1lTKLWgneO
u3BxERilx1OgDclmdOvxcqewqW5kPD/skPwQM5VMU2pubK7nJ4k/mAS5M3as3ZSxd6NnJGKM
RZYFaYKGV3NUaSh4QzFwEkE4TUJkD75wEIXxegO+4Yy15vklYxZ+Sa5WvZVXiqpF1CVHne9i
whciDJEHJdafXsalEzpnXLVMINefEkHL3ZLJbzsebrhwnmCfyU9EWodlcMebyaS3FV8DKovk
xU6jKPSz8dsWUbE1Y8p+hqFWmFtj9e817p+osqPgWvGHf8+Sr7EV6fyeHdOehxcb4XWnxnAd
gCIi6cxFUVcXFTIN3xXWOz00tvtZ50GnSPAv4bMol9FjlfVNttQFxFRenczoa4/T85yKILL1
LjW+oStIzV+a82w+7Nag74GtlSpGXyn+RUjOHtQburvx//8p/i0RzKuePBU9r2ufC/FqeUfF
+JfjYew1ce9RxieTzzAIf58pq0ZEgaqqz7NaxKxGncHqZL52vd5oRHxK0RfY/MAPTXxEiyep
YMVLMzwbCa14gHkswXM3A/Weg9yOJdIJG//4BVECTVFlyuiHIanmuBfxmzWBA/rjN6num9Do
76iUkl3t0DpTFVREytW0Xbip3GTDQ3rywzLxUGpNyxlTyfL13kS52kYLJVvCDc3m1E70lxKT
BjsRGod0bnZ6ozRz44hQI/EzjLfoPGksQyuFoXLWh+s1FIAKO0pCJYJ+5aMPfjmpy0kZAJPI
vdC18fnW2npBcGeAvE0rrPJrFDMLNAzTvkJjtfDaQ8lnPmbhND1UsAqCAl4LDLu+txXB0YhM
qhX3EA2Qi8eyIb77DPMMUQJjmFhsLCwze+UPemWLBAS/JTeISpLYws/Ar8ludVuaqgxoIAHn
ACOo9S81kkzZX9SEOzl9z8Cvk8EIS9fARVttzsLx40lnZW3+hYxT4uh/1R06buF2nDw1kMlL
z+6yGX79FjA2vGR5nL/RVZdYJ4pvlrY2FoyT+duLoPriNDCH01udzJA/EKO+wC0tjm2QbcdH
vKyjrxygfcVEkySo7VIm3MrEmnk2xb8LxJ48mroeB41XT0AVTgWwNBWMbTZJkXjzo2+DBM41
aiuiWJ49IZxphFPXonECdZt6sEspSOQHhOfAw7uANiCgnQejJrusz4Cm3e+UNp5q/MLExy7c
pgPSKnxwSA6iuNY7g77LQ+WeCUY7ROkQ2QqkegWeAAXL4E0X5z0YLp1wKbzrSbuSooaDFyze
ydtL3J1PkTj9+jM+r2rPt8XRYzz5ZCJ2eAJfqexF5F2gcypm16yYIjezUsIm+JKEVGRMb6PZ
oPlXbjRwVD4U7tXNDDw5nBzmqn5w2aDfHDMW5z1tTuV2gvthIfWznVG9s+Z7rwU1KnohS5w+
Ge6yH/6rSSpLrDo9+h7g3AC870dRA3aYdi+NmJJjhINeQxlvGf9qrhJJsAH7l94a5aYJbUgF
J7gSfYReRewfWtVryLWVNEreg8RAsZZoTP0uGyCUZvG9R2o+KYx/UBRJSO/fBpZR7Wd3I3f+
++ec8VDjDTBVSrs8zAzDQuPkSWcro1HLGSFWpnNBwSLBSTSr8+sQgP7GO7azzquX0lnA3em/
sJNBkIo1HD1rtVWmzM3iz3IepghSKJwzKk6w3Y/zUgZ4pQNiT4R55JC5yq3dynj9O1rEM2N7
4m7XyQ0WkoM+zZbYcsS5rWc1FgftDOMongPeup2X1UCdImpcpcRi/8ec/mewsXkKmcG8IpDQ
A75VwfncGK7znWutnn9VcNXY5RjnTdfGQ6yFqF+7/OlPzQ1zHiD43ORdHdNydUH7CMKBM/yM
MNt2RFYkx9AZcUjAY0ETYByJyX0i3zF3y8nalxnFTfmAJOk7QEC/NzEii0IaI5/vdn2F4qmD
gC5iahu9nS060Ur606EUp6SElcJRLGN8utmK/q5A7NBvc3vstF7HeNN2jirxggRARkTAsdJ+
g0GLXekkj/ntRL1Bbc2sdYUfLe49zFbrIoHhpUzW7E48i4C17QU2GTjDLgxr98UDhITNvPHp
oF0EERSrndBteSzyIzAYx0fjzFb3qy0roIi3eh6pT9gIGNFt2FOkHIRp4hw01jljSwoRl5Th
YsBzgJicrkP2KA8DPfZue3hvyhOl0kJb7cftwnHmoGbkp3wBVWW2sRr8quHdbGULKUCg1yMP
gG65K5k/sgR1g0C9icDg2Fu8KOgUYyw+rxf5oppv4T5nEPH+eNtP8aPkYQ5uJfVRAFTXPjKd
o2lyHo0VIukMch5p/fI/6tpbLp22TFf5Tk5NXgPxv9mT8ljmq4R6wtLPLtD86czi6kqESGN9
7bysVTSIdhpbsJgbQTEjHyOwo0LaF3r0lAaX2tTy6AD59DvGXG0adjwFmYqQ6PewqTxqL9Ju
u4L7/iGTR2AAUBs7PbkIr1dP5snqYPVbVpqGTa4fY4wORCJU9m6nCD8y1xhR8nAaD4zFhMh5
LTcX8tKoMUNlhZZOTFKmD9mbDlcGjydJiqD/lNXUx4czKMDOEzjBGqhql4ME7DIxIXbt47Si
pFPPlyuDPB94Ylz5oh1JWaZaE768ZnPPY4F/celvOvTSyqBxtLi030NDf8a3I50DiPZ7sq23
ZKw/+WkdMnhTqS8e6m/UNadmqr58YhZkodKnO0yKhyhlaCFkE9hKz2rmfnl5UPLOXNQ05H66
ZfiQXZmEBGzMrNRcs53G1mspH8MeQ7G6glpkQE8rnHzs4ZaJy968E+6aTTB5dq2KzKa/yQOW
svScZHEBR0dqKbvnr44U/3V0q9aSn75/slZRPAxcpN9kbyfdVUJq8TUuqYFqLSIZIofk2n8+
SAPa7AJrmCycIkpJxYrf1xW/Uir9bEEJOcBGQBTJsPUmWLCDqWb2h1/UYVqOY5LvYeucjlpX
e0eAVEhdBbtNgEbc4rRzIroB/Z579+btEYcMBUrzIefyyFqSqQfn/KJ2IdFHIvlp1NYJzUZa
ETh2rSOOMa/Ebo6TdkJ7yA5NAR0AflIYVU5eT93iXIyzSYZTUaCNF+U28soWZ6w/bZouTEMD
D48CzDIWAwoOihXIXLGQsh/CBYIAiqQWPl+n1JtcmQSWiINFVbL3d3+xWE+nVQ9kQSt7PNKH
vJhh6xpzXgAeCXOqzEl4Ou0yCk9pTbCsIf4EfreGjGDPn5d2Pl92fAa42e58P2pUKfirOPPq
uzBTBTgCHubyJjJlAkDvRHyJ+mLITc4eiD+SNalQnhpWeUNzX5++JuvOWC9GrSup1C/ScE5I
OmzBff62+l1PWRxfmaLiskgAMT7GV3oZruMtOkLTvl9Ofa6+Zfo6A6Ea9sotj3Z1NTvBSg54
vivAteIUFzOEaYCFwLwI8E3mE5b9Js+ItpnofWEjo+msX6QVOI9cDhoDH0detzpDXGDJMxnr
RqV+KI5PJpL2q5cEDycENx0NEerTe94iU1zeN9e+6nM2P4kszqzpnMBGF2/vVhouz/YJ17DT
hfjzi1XZtdhcecZV7TtvmsIfX+eZBAY87yt5iQ0gdhMygkKr48hmWMOipcq+RM0bU/n1tsgu
v33o2td6lFQheCTr4lPafCSy7cXEBZphKGNg8XEK8Arre0QxMhdxoaJ9nSK1xpcYW1Qd76bE
0Xs6NJnyrrX2IBH+ksgXEpai2bxGqy+ERyEEZH0uoCMFt/A749KMMggI+2WgEz8IUl7hdqU5
F7z3688kGAIoV9koHggvK9VPenikwGjiipyYFCi6y9xVDei1bh5xhD2euRP5LnO6tZlITcEj
Ek45mBfxuAcyrR2kroLEpGYv7Q0tzUgHfDok/xuYeDwIPM+dTAp2F/PGjJpEhSTk/qmk42MC
kAAg8zZcqLOiotFeX9bhv7D9mBV1KqINGOInosNvHeP4g5jxOdBKFU18zRkO9gP8FS5y23SG
tvahqquYAYEbkz3T4fAAzE0rzrQ6XIqIGtn3NBbuSkyFsMjhhxCoWpBnNsRHss2FMj3tt6TM
7IxQdpzBew9ZWAo6Yu/+0FfyDuPkTs8oyfQ2mGFrr+ble5ZQ0NkYTZJflIl9Kny/YRRvMH9k
tPv7H/oZa6KqA3BdEAehnG+15KZwfnorLU8mSncsKNXNoCB8pCdP2H0mCZqRlJhvNjBtsYym
j5lBpyHFLfQcowo/wKtJeqRIXKva85em3O453xunHLeTfRMjPmAIZrnAkXg22uWCEmzwQybI
GHkN1nKPbg1CyCpo+0/BsD+LTWuMyccPC+kRsGXOTZwLXNwxdfmQiO7qhOqp3IWpD8uijk7y
O1VFtiAN/Y8aH6dwzB4nAvtQx/PVJNOZEx/Ik5QVtEnAV+dE38bcehuJM3DDkCfNWvwLJ2Ii
YrFjnVFD5Q1Pcrlfcc1YWqslJZx5Ea8R1X15pjuy7i7fsbeTAmeQqtzvFD4SJHmw5rjUDSaJ
2ey+QykwPeZw+Woq6XHakgee0xpqjmUKShvo0T8GIEthSO0vw+EF6z27rXKRCadnVaMzryve
Sl5byIajf/scolOCWTRo8orEGQSni2HPSwsq7/wkYKX7QCY1xdAFfxueXs6igIg08kp+Kcyg
b1ddwF1KaQzcuU49gHUlMGa5YR0MQFBydEnTNrlMvtVRVyfcOd6r2MuKDbOdVcci2j9fnsB6
1zgB348oIVzpcDGJOQIK/xnjKWXxE/xOTeKrOHwA6aCC92IeLbBxtsnP82bApoVO3kvEWR/Z
fLIR+yj4FXIsmb4V3UCxNmE7AVM0SxLGWr4xsO6yNyI5T4v7KHOC+rjHlcF7Ncc1R0e2r4WP
mVEA7Om7f2oIBb3FlPqo9TO9RayGA7ZathEcHfVxrq/R2IKqJwS+06ef2aSbj+DEz/SKMKhA
hPZGbvWcx5QMnE+D7TlokWFwV6WLhQ5yxbCPdFqY7K5zOb2gagcSeL8xiWO5D1Elv0r0EY6G
QbGgg/o0mLExD2ow6DAmju58uCDAed9CHmf91tTEuJ7vZnu6hvA9m5F9MND67nyUV3sAR+zq
+xBakjSCBYFIA7iNp7uOcOGzXDDuCjS+JzFkPKHSALSGOSMIiue2EXaHht1NRovZkEpMXMCv
1qKlbwaxFir1ILnjGLedMcugmdzzfQqhmH4ud3x+nMe0F/M6QH8xOHPwGrAyz85+No+NVbi+
Uzw3Oov4sEO+saMjaD3xEsF27HuKcvu0j0vsiVfmkqPk2+4SFZLK30eYEUTWwqg71U4dC5IZ
7GPrzJasKEKint+CUMHFmjvggMI/CDyIo3wCe7V0oINP4HR7U89lPikJ1Jm2Q2pBq4tYsYcJ
P961Qs7cjvcH1gFKYh+0RI/l6TKUp2A0qN7DsBk7fHd0N4lxdczJ7Hzj4CaLPp+ZY9idVLXe
4ZdOBDCESd/PiFGRmHkbEyjfnoddrQc5szvZYthORC8kaeF+ZafhRvg+JeH7KEk47XeVbcxt
5vncch9Y092wajmwXS3Jj1rz8B1mhNQDn1sCXspPFsjJBRBP8zX2LDcnh7m52xAu55QXtU2L
JlWoBw+/G1Z71WppG5mdZ91xgpQ7EtGxb/A1IbziUpATlqHbdEv8pfsy3uXHDCEvMBlq3sZK
PqpC+H/wJx3FkovrQWr/6BDThV96xxaNhap7jmrDMwxkFWUBqPBB8VhyNBaJ5X95iuU1X9Th
tQojnaiMgppYYV9SSH9fgJktVvkHyJJSZ60PbgLOhKlNG4ibC0rB0ysR3ovHoMhyf8+WTdbt
XQIXUH0NZhz2mknWBH6ec5j9J+/7qlKHWZ9UPrep3OCYH4um0YwKEpb7O55fmLA3c7xoUvjd
5GZs3zCmFDf8n1V/N1+AZrCqggfaNL3uU3g/ZBmnKEW+vNhNFUuhvr2Av0ymywXWwgVvqzrz
bIkyh4ZpCsgfHKn1gmadX6M4oGFo1AWhzIN/PanWsnVnepHBP1fdoeSFJL23sRGWuOe5wJbk
PVzjDIrgwhZZOLiEDdnK6Cun3GCPBUMDiCSsccHXeGyphFirAJI8pEZsRKph2jf5zOkZII+R
J4VYuzzrpJLxpq80VBA1oiQXHd9PebdyefJ/jv1xQRufQ2z888sOjGRL0Vboa7enG7wg+QSP
F4TLVG929i3/o5/lQWRyJJ95sEjoLEGAtbr3mZ2BAfO+B5S+BHqSyrWsdVu2QdZ0ML5qvDqH
/zkNQ30E5doEf2xjSZfgfzq6yfMj8/V1ku+jXWX0WyNC0xdTgXhV/E0Af+9gc29Gz60GxEnr
2hx/gBneeMjNizr8qrlr1mZOMzDXblitnuOcSIDlIVJsUJCtJIAEMn/3Rs4z+awJgUe920XN
3H86utibuu9aXc0bBH2oIuNl0aKkdQbLHfRmHkcyG1KWZVAoXfxVHJt+xZdyvSqWABX6jGEs
gT6TG+BlteYjecYECob0Wsa0JfJLJdRxxCgsgIuGjgMC9nrGZ8wKpQUfOHfZTfNDid4vbj3j
NMs3qM9cFMJO0QVEqDwh+VrAm+xLZiz2m2pDhRzG8DH/Ev4qr8o6Gx65GLzeCb8tathoOLTX
hF5O+UY8eGWqzgFJb9aRYGkY6/fCLZbz6v5W3zWSTTxRrZ1wDe9H/LB0E24olNwpYFc5SxTW
+QnOUG/1IapEJ1J14m9g3h8cyZsYZ/B73XX6NbxjClF+4J1LMvUHZTsQZ/jY1mAP3S1YsEVZ
enl+FXjHKPVSdOESs/8EcYLzdNIr/lep/Lm2QAV3qdck7cI3QUQZqngzJI1JMet5+dc6LV8A
uE7ZU3IfcG6qKN/hx7/fpEmreYm/xYo7P55HTwheDb0RHvwSVjJpiiAKkOrHJOSJ0xeJYLIh
O2nPC0x2oBHLfYVvUUC0oXx2Yh0GZxsgtzkvVcRpAqx2uihVeMDQxEdmc794UKIATdoGESOy
9ec976wzmNByk+i+DB6rZap4sn7GhF1ozQo5kK60R7WKRkuOXacC96ypEonOn0dPMODLH1zk
fZAsmS7D+REOIvwi5ewPTer3Ftn1U/Irkfh3TMb0Pc3vu5O6aqksTxkU1+K1ZY8/HI9fmlDU
0ShvOd4m2SGDtlZ4ETpDndePgIeH4bMXN8N3weI+MFWmJUuDJ0DMXuW4HAvXznkDOK4wnnMb
wFi80aNJqDQRopyi4CTliM+AmVF/xhkpkcjkBKv3RbHqvuz8IUpRmDZqvjeZvCgyKnUQ+skN
WZeEtHSEayqzoFvNEgwzMOPZ4oE1ObAOZrjs0SKKxA2oM99wkVADh80oY7nC2/4gnrHmJGff
QkRhvXfnWImEzK5LXBmIXmkCsHg6bmBu1jA76i5MlzqrAYHHuy7/TYDUF2QQWQtbM0vxDsjm
sIkuVW6l3alZUZGcvMCC1eREs6SnBjvhZ6fhHRS7cxZfWJkDiAHXBX5MFQd3vaKQCcFqxgyB
M+mMLEya19QyLBh8hdFPrPPDuiNk1ulaYVTM1CKI2FvB8H2EZ+FdM1ypPbn8RSM6a1my2kbf
R2Zk8cpdsBDMhO7jL18PqtQ9GQw3SY9DUhMMSoCPlvBZDeF8pGdtRZSFrxm+fSTk8Bz27y8d
IcJr70z05FOiEjSwg+DA1TrEijVLtFrc+iLotAiG/NOtzh8kp8UbccDCSNtAnuilIAGMNmck
g/DSZbrlBKhoos3qX9f/GAgqf8p1SwWRfdKIrgydKKIF3bF0rd0Fr0ESxeyWPATyRIXLICxq
LMDyRutZ96iJehaacg0huxHHbQ73B13gmqX6sOAcpUtuzsJeE9pUWEXLyYz4aSqGeza6/CGl
ZL7V43gcE8036W1nb50KVsvOznZeZExXKn0XY8a3rY2dq776ZPHiBaMjcPKgZENlRIexhSkJ
0XGAG+tYVO1xhU4BYcK+peoTmR8Avj+NA2SFa9v8NOoH2uPWA8FIB3zD7p+WKPGFF7z6vYT4
1Wa0bDGvUZAbBN8UkGH0911N4zVaZIe+dRFnmrrCnBA0yzCcq2hz538+t2YHvXkOtRO3a1TC
UzIeq2r4rngPY9MnuiD7bc4XVGvbOOa/AmzCWhO+Xc5fM8/erJEN/Qu7AX3qj39aQC+dLpEj
cY/EK6HR8J5I3825dWU2QRIqqcaOOncQHsZLJBZaFum4+BtJLosLI681eJmCfijSbWZ3A12i
9Tpx7by99inHvJ7JAZgoN2vtFCba3hfo1Jw5cKv3MQJJxS7vbVsUmzwXun+UWHFwc6yEjgEj
+ebL8olBC8biAHE6Zve90h9RVEi6HW9SN9UXXZuRsyUR2B1S42dnt4Oib68xxVFwOPNmN7Wq
XZ0AUo17L7XM5RUqPSWtYAXes4PxxAarAKPsBJx4kHO1Ta4LgbPcqP85HaZTQa1YEQsiA41x
H91cOe+G337i2FOehxLpRDMCRN88+pCjoWhzJCHMHQW+U2J4kMo4cDKNBRoKwpoXlpD82G7Z
56ASHiauQNbMMsqcdlCs4003S52YxzcSCAAgEbET4fAU+tpS/a5kz/A1GCwem7aVOx6C+w64
d3qPBwqTxXWzyYJwszw9N9V6rDJQtYO+e2JIvQzJolZZUXy4h7dXtyh5d1PXsCpodQIodoNc
nCbEOzyLtZtPzGo1LXpxVQV1J2BS8WU5mTRWQudHDEczUhb4FGbQvJpjVtymTE/Qz1J0aShf
8wd0PwB5a819IzYOwHlxYneAdqX1yeBKGSzZ9gfPvNLpRRSjtuAelVNkecGlZpq9i6vczjy5
XfKPZBuHckkjMwqzWNdhPHgkfZRR1AaQXLLK0BIeRHu1d4w4Ne+0kLZdmQxw81fUuYichxTo
voCbMspeqHwTPSPy0z3zpYqyhR9dYBGpmi1gCfOxAg/IwdUS5ps19YBuBuZeLdfPzGRpfhAx
2AA9wUihsKzvxvUiW2HxF/OyQfTC9y4f7e6b+y2UvRbgPfMVo5zxh6pLWhkomWto58Z9yuUZ
zf/L9twzxbr/IjtM7SyHiZg3WY1/DcvGJFs+1s/mrAYzcJdTh/IGk68zjv069mUuXv3L/YyL
IymUxckKFEiwvg5rQYNgDZLMxdIq9VjNdRgTR5BuJISHdCmdWrA5PiTNBqd7ST2rArL4/vqe
feoIwKmm66DZj+xbNM/se1q2rP+JRny9iDe1HzTEZGtPhInQV+b9W/ht/yA3S1qkEgi16Sk7
JwSMkeo5gT0WzGKwMcmyZL6x88TnDhXSyu0UEv29QauZsxfO6UQtMzzR1RlcK3VTUJbnHAuR
aEWqEjVp/sn9d9u+ciKX9Fkh5KtsgLl3XuYKz6bO7wlxM/JgLnjA3rRyXa89GAcdXFioF61f
tyEaoBzeGxMytb0qE2oUKflhi5UOdHeE953KMazByZHmkSS6SeJiaSoAJjIwhe3vS+f+Zn6m
/bz9Gng2E5w8nl+c1/kWS5UBcBvajecMTuDNEf9NdoK0qXTNL1MhJiPMz1TUaYnLZ5GVrAg1
S/k4oS9lINykZneu5Gv1U4MNaDMIXzszguIY1wnU33Zqr76DLqtazXsey+MkLLz79w0xDBnE
ToLj5gjwbmSO77WxW8tDbXcjn1aJ+LZduJPEpGZiaGaIwPTlqGLPviOAl1t0dXpxeyQYIyaw
rC4HSMVOHcvWq/ZytX0shgP0aMo/gdiKXbIlIHMKVuxyZTP9gp5StsgFMl65bQk0/sKx6OuQ
cd2j7ylrJLjBVYDCIx/7gQ85W2Grm5QBTCehRbpyesl3wb60Wh2necsQ/0OE3HQrKGMGlScE
yJxCJKkEdPzItSzcH9MnPi4bct+uhKrfF9nP0bX5rjhCZ7AFyPYT5kCYDJ9cfZ0o/wWwas4m
jbHbZaNUsreQEsOINL7bCIXVp8C1NMYIRbeQEXiesVGdNM9kayaYXMR9UMG+daK1kcyTZL0I
3ZRrvbmtI50vdSnaJGKisgvEFM3JPGdYl+9hiNLZNyT9b5vaRE739q180xC+hH/pH1LunT83
Ese86pbEz3xwYavgLUEhTndIFNdamnk8LnqXxM62bQoiP79hxKaWqaRsAm7cBPyf5MMoVNvQ
gTM2dJIe+7Alt7LCBMYIz897spVluSj82tF5/t679aCpB8LFjXXmUa7UBazklN2/aVwMpdqa
ZipVLYASCw5oZ+J/Qs1cCKm+rr8JbPo8AMRSWDOLmEjqoWFxgTRMLRM8QRDfxkC8hGQw5slq
Y+bDXC+RFh4IMi4BLWyL5mIjnStsLGRD+WgYIPtVU7hSUE5Yf910nHbpQQztmouEef9mLLfM
A+SmHBGurfL7FqlFf1xcE82NYqYdmiW92UPsTNukHrbbpMaNvqIaHBQsk0H8W3Z7swCNZmt4
tUJTV3oUfADGb2QNX5DVSR8GneRrddqnte9ktHBcMeF5UCPn9/m2HsqWABNikCKG4bHOcvyx
QWcHV6VbLVrSEIarlkNtnkE/JXfIt3weotkWm96M8/qhtXAyo0Z2KpDSDr7EoEdV9zndSxKX
U7dfwT91yHXz6IdomN43uPF/aFKoIicqcXxh0HftPqN+3PncTvqxlwI8S8FxnFbEVgLPprrw
rUm7M9XyANgtf/EQwtcrSu+DK6sgv7yCXp/x24YFAvlNLogRBiN34Kuu376KHIcqNHvK9+ID
B9ED3cH5yLGq7lGMMTnVGUxauWXBxhlLVG0fyaC5qrMxnvjQDBpbFP8sl2rS0A8BLqVr6B0c
S6lsKNAFOcSlLKhAhmMKgfxCzEq4f1yll7WLtdAS/CZIH5It/Dj+943suTvKug5MFjCAOtCx
+xlm/F/nYetCdC8NDWrtBOHQuTdvrufn+HeEDnvmioxxzgEHkeJ+Poq16vAPHTNpNHJbPRcC
ac9JC1SFxJEFiU0nhdXTOi2HKehxRyPUtjnfuwSc1jGjONo465tmmPHva9MnSOS5FaNV9qvN
mLnke8JYY6hwkT/2R5xKUL9mDQMgjLFRwoVPgpm1lqOFKJGsAUi8fLRn7ZCJgjGqk9JO/hpl
OF5mUuEX0I8Th/p8D4cOe5GSSfJ4q06BOyN0EDw9A1UtX1Jd+cS3qF7FLJr3v37O0FilRO+A
hbFNuATZJgXJ0kKv6N/KVLqVvaov+k/Xy42gden5V24wm+/4kEY7sNzHmIw0RZzcSXFn7rjG
TgO8moJz4x+jBVo+xdv7JZqVRnONQqt3JXZ33qTE+X3E4pDiqVpwS4KCj9Ovai9gL8Vzx796
4aofWSd/9i/AByBTBor3v8HAPNGGfPu4ze21e7/Mb5alMWq1X+HE0rd7iIOUx+RBbnGuI9iL
NuUll9u4ExmJjsZmo9jnKFTxk7OhEJ3CgtuFufHZyzSpERaDe9h/sXbxnLFIDP5mOrm2v3AT
FY1Fmjk1/L5OPaCQZOAkf93Q0NiDv1KxixJA22HzbkIx/mRBbiEsE36262eUn/zLty4t4ccH
aRAN25Ejx3sTsWaPl496FmXA1Qs32K5MvuUTGr3Cnr+au1Digue5fLQGfjQPhZ+/xCmRRfcB
NxPaFPcD4Dw/pZL7voo+DPjMgxuuqpaILQBY8aHDcz9rIDg7fFaghgeps+3V4+8q4C9CpXsx
W3u4lXK17959lV+M8dtnQR25b6FJ6egexxavmthaqx+8011fbYaX5J0BEeWjrfrjYH/ZJnZc
iZZ1qZeXhzB6ayjSRfnBU85bbLxmUm3hkhFMqc2DNUaEaAWOPbg/jb51W4RJXWiA//p1rZVr
VJDkK+iw8UXhK81VjpA67MLTDrmKr6doTDiNTy1Ova8nY4/0X8sLAbfJKZhnGSDuJFlzTJ9E
/Qt4c+Bch0gJ/cM3yjb0lJyPqlo/piR91BDhoCIEYm77vbIB+ZMhDSKOxwrg2JY54MXK8oII
RfNV66irRs4302aAvkylf5cDV4W5A6ZTeqni7xaeS+drZUydNPR+OjQzwBVdHUsjKyAgue3m
RC05It9Z/LHSitDJp6tx+rV176JLtEVOXNYCH4HsPgPywiojBQ6hjBXS7Xn7/FORoEmeVUvU
ZqaL2ytANLtTC+vjbqECox1pnQ5QR/ufQrn6bwIiVsWpRGvBIRswjnFMFvaqNoZ8YFXpZzBz
hfFuTngZrHEoRZCzT1Z0x9VvLDwARMwByRbE3XAft8E8j1brI9bWR/g0SOZoHCT4F3SxJczB
aHvt0nOOHyfnBvPF43/3tWcGWVNz3+a4WPov9yPoanNIuuAa3Lu0wqnu2i6mZqYEQZxjuxpI
05ufTQRDQnJR969Rqy6zr5Sy/XMoA2k85IZeVjYpgAAV0PbKTBEfts0u6CNiKzpTNlv9K/lq
xzxLbFiebY8krIiyk9N+bjnh5jTHc5LjHDtOQv9fJB3Ur1ZP/GNNn78pabgqjH0CcGVbevsG
N6DW2E5mO7rRFzhNWPqInehl0+oQTt1qI72WGi+7yThMKlJLAcDiz/Rqa76ATYh1g+Q/VLM3
bCRtCK7sGvkswWdu3KgWyvf6mLDrMRBO0pKXS+WfaAGmdaEYaVpDAKYorD0PDQHUhlgTucds
9BOYSGH03pSypvWGOBhtacvijDcMA9RECUoFB+wzw2R9L6RbtvcGmAp9h7WPQtiXx/pNXSjl
5TafVzPrnMKcf1vhCBuZkv4ntDC95325g25x0DRVLduU7S57avR1T7UTxpkTeobsNDlTgrcU
1GUG/EPRbxLMIfCUSmhAS2EI5c04BmzVCGB2ZPzC4Y3/LVI4v+OH0LQLadhhf68MjONgUJd3
x+PMaT9M2rBMLMO+5bjcEi5wKeIziibUysPn4AQxuzpW9Q0MIiwDli+yT7EufI5LLCKUIg3J
iC1EdvjfP6BG7/YBVyL0ZgKhb9OyC+Lpy4Sd/NyTraBUtQXyk29kQwaj/cU/QBhxQ9QqpA2i
wDUnsewZfe+uTgTnZPQrIHogpLNWrNVsidDkNGEBEyEkTwwqZu4kNNT9CpPVwOoafOczl19p
YeJxJmM/NF9y/tFYYHWqlDpvBNsVlmEkhWWNCTv8EFz5cabwnS3HINGmiRfgoAnnW0llIgsY
t6nY+n1WtQmAY4yPA4fSMfcL+d7d1KQ/hA2dA/q6sh6MXEEA30uzpwJn11Asj3w8ifcL1iDV
bQo16OuL/8lZMsbir/U9bemDYdikIdwG+bem7UJzkuK/w5q/uEzd2Qs8T64dwA/SCT5CrUHB
Zgi+2XfAGC0bKD7Ie19/VJXqA4mviUln+giDiE2ZX9sKLGlJbarKvkyRgmK/dN9gdPy3vxRx
2P+t6t5ntYichlfv8L/VyVlBNyeNyBQikhylEI5AVaBYX812mQmhNuBDL9aCsiJIokwmaZIb
XnRGV+dfvUVQ8bpmv3FS4S+5IhpLiaJ6NDnlmjHNUTi9QKsPOZ8vT+areNYio2ash7r+4MN4
i37uBV06PMnh9KWxNROtk/5HNHLV2EwReMCji0S6yB6G35dRJ+Fx+KaGigOZIIPwJvH6qhDK
Fi1zfvSNCXQx3hhMPIVmHoSt1KstqacYynvYDyIPih1xU6Aw+07QpLmE8+R/y/v/402h9bel
fgja5t4tQFcisg5KTTTcAjx6gfWK0y13+LLvkvUTkkMk7Zx9Wx+Z5/MwUlK2EWr3HaeQT3tV
dc0F5MnTFeE1eVPheoAJiAazhSl4PN2+VA67RiKjWY7z1+Lof81TmHRVAGUad5RKKtMCs3Yu
B3v4zjsA2BfubFxG+XJgCIWyTfVpZLYz3OAMHV7bGdGC1MMct7GjkzQYCI1h0lfgeVKIs8Ti
1uMbC49RZzgori/F+Lc9J1akshyDbD4D8KxJcTi95qhtS2m+0AW74TphrFpuhg2VywC+euUT
33n8FPyddUDaKRibAO65hsHOVo4i6Ii5NG9Pbv1ULMLBYfTAYGchVgcckckH+Rq9P3ZRq+i9
RRzumXZ6gD+Oe27P5XYzL4m48AUyJ4LhHlpcO7sjTBLk+/5bLeHs9fpxYR52achmMQlGlrwu
Za55ad10WWY49b/jobOf1Cj1Rqw6xbjMmpJ9htDYgJSci+4t4Zw+iYXYDv7fa9Fgfbb/Cc4d
BDbvo9dObXPWGkT0TqjxL697ezFQ5NtFJhsjdpSGczE9FUxuF9h3SEwzeprv+bbN33no+yBV
dULpbBloqXcM/eB9XtbeneA4cuNIYZm0jME2VAV6TQOX+eAsr2a//r4gpjHsxfOb1NaVw2TH
2wtjcw5IIl5RHw0H35wg8XfiW22Fsj1oAVFTDLdQEZOZvzdAvuxxlbNlX6+L0QbUTQXRkpvz
g7cNEHWTysjAWlwcrGfD7lnNATh5JUjKiu/rw/q7SI/1w55/Ux7HzUq7U0zYEhA8fdys6r8U
1MU8VqxMyyUWzytfSAsSQR507TI8hFItwegP0SAYxXVERGcl+EOcn8Abmd8SWo1upMzANVdu
VgBs2nR1o23UvQHlEsQgwFGIHHGj/Er2KBogxtdMOuRrqNR3lZ66HhtYMjWtUoVc6e9H+czu
5rFN0L9T41DlmsjGNgDXXsSZ7E/mIHFHWLwiPkvlDP3f57SFTb6N+A+x9f/t14FGFieJN2L0
AwaXbNi+5uaHt7rmnb/kluwAbw2+1Wrzuei9cftlGqY8a2BjpTWRZZ1HeLwRQYh8DSNsRMZf
HuGSG1gA4T5Gn28JpyF7+j7rjwmj6NW5gJuD0m1YZVf6+6HNfJlUyFbeEIZ0Q5UKhg23zJ1p
HeRbeafM7bOXYKO2K4o1YgJj1xMH+UaIvd8d5S11Ns6SDOe01KOyZfzi2xFc+0m0x7mgCwL0
WZhamtpu4hHWKdzNGn0sOTAsXxeq5xozeFZAnIhUEOL2iAYF82nuQDtGbYhkKMOTAV63eQZ3
W9Ww3EGO2x8WysyT8WGF3wqWVxPMQcoJe25JF4TSdXF7dCCrfJomLZcKJ8PNqjzLosFQytrO
/MEfq/DPZd5FWYZM8a0J6H7fevHqmGB1lXFwcn5MIAguDusvEMkb6tk7L5HQ5YRsYEF/oQvR
t5dUdUFrnEZCgCpo8HP3SssYlfjrUkSFm6JpWlxUmJEtnB2qEWKuU4tVi6yIDAIqVGs6AT99
FJJNsLAV+iuVv9mMrxIogyfzJG02YRTjXZG7Xjx9CxEuISa6UOIrtWbly0VhUGDjLCAgNypL
uTlgdG9vYaigjdV7eAh+zHppAKycwmImwXFfJHoxV3oWpxcu41Pfg8TipzxQmU5bLiSmC+jM
r/gh+Df8YfE7unm5gDjduVSPu1Ajkz9R9ZPMzprMGV98WF3f9FXlRf4s0fBN614mAlO2S+k2
3g65ifNCJx5Slagvf4iO0M0Qbq5u/FsRWDq/kDuyWc4qwrRZNfyoUCXQFwvkWyZGxVGH4La7
bODSqJxvkkbcSeJQVqsyDBtUEO/3LlCHe3NgL/+xcDKOkaLhikXhJxDUtCPFS8q1g8bI7sxx
b7NiRFDQD/nKMbFHEp/1HjYHf6XA5UYL18tbJaIDqr4oSOKHXpyU0oZpS9N41azjI3HmRvjj
uFZeOX3pP998iSztmFcWRkOr2PTbbg0m14hB7t0oA8LZ5WbgWB8rdhaOgH8NCwkouxD64ZZ9
tzecdJ7Z7rzbEZtrCOSNVSdNn+puUMGrRJHYkXTSqFdZ13sDw5lWKfxT0YRC5E1kwE/S3SUh
I5IsaLCCZWaQmfjvBqbjl7UFulprFqxhzB+T3yxi5ydiAWUZlIx3r1cff5oC1oF75VYIYvQb
PlcVU32km/WoHFLnWJJlQGQZx84TlQroNPltBgNq8DN+1R7XNhzlqRFZAuqUKwfNONeAVgxM
4bwGTmk0Veb9Ql859wybqWhsOXSGPAPYRnKtVnDhV9TveDom2Q9mnrWUPvzwWa5YT7nWpNX1
phLRzXQzHeMrLshI5eUd+IuMc3QM6Vao/zDsS25NvhMg0mbMhabGavDVR+068JsVL8U1YU/L
dyqlCfRrz1o3ksgDy6idNvf7t53S01cdYA8TGR7oaImDfjFA0IBfPuGHpNBEWWCxA2A/rQb/
qyGRIXryZpExw41KGCncrLkSw7tpQFcEl5cIfHjInG6TIs78P4NhdW4Dd86jgMd6i6TfAihj
qTTA45TXlGvhoFGDFwykVmMYv+aijB1/u+QQ+99bG/WCA8IZ+fGH6+bBQ0zV0SPQ/zqfAIj7
ASEjPLs8poJItYkuhWDCZKKPEfpbnMVreaYFnyaVi/Du63g60Ro6oOke6lU6knuYvIWdTVIy
xm8coOWm7ly0QsOb7OC+CkrC+afmYhmTf4shLMoFWxkenBG7xwbNbRDK31EZi8TlZXZLClvk
Jl1JSQXzu9lRdnSXuUQ+AHBhn8POcQaPl+o/DrvxHTu4YIvye59Ab0bG4HaJOm4LaQHVv1b8
NxMqL5ZOqU/kWSWQnjGCmzKD2x3ivK0jy68V0Qp/QSl0+Nm1MMyEk9KN467eZW7lJYK725jY
nHTqrhCdK5Fbpi7SvuluvMwWESb5cWnpOZip7VnJyBAIVkj7+7SWBuPqvnRDi4AAyVGquqzN
YAmO30nAHsZG+2x08sgIdmdiATh32LmuX+n4UdpTcJVGnWlLL5Gyj5zrtqN1Wlt1ZTMCd7UF
ClPgJ9OJl7SwlTEsmIrtC5KLSLQI5q1X2ywkVEQ3gzogzQKJBSszIykXQto/B4oNX6ZNXiYY
yoZ/O9EEMwkAhKjZ8Tb/TL415pDxZZDIrFGHTl8FjJ2g/wq9rUFraBPNxPpiSPmQsDRDOjP1
QhYEXFD1dC1fTu6WoznSr5ASkiclYnX9xpHE7mVwJRaawTzV4KfKaGI8oUIWm45PFWaXwDuQ
wqp+DoLlZdMJbErAjmhkg6effALAFFCS11lZcGzLBP4Ya8B/bNV6IAKuERY7OtIBVNoCF76d
a3H9biNzll7n3BgPLRpAk+f/S0v8F0+zpjbyNx6iHf+tcJQleOurAAL/hhDcOAf6PFA2mDdr
d5bKBzpRl8egth6l74ECXSDQXHMLUljim5caPnwk1Z+TZiiFDnF2JMeyXToCqaTJw8VaQFwu
Ht3649nyAreDQGmUeAgAHkpTOELf1rnwGXOZklpru1YFz8DnB4gidKWlPwZFPPtnoZcp7B12
e/13U/ATs2fS3WU9hOdvwUwItIoY3R4o5OQFf6V00x8segGIHCcc6UB2FikKG76z/LaqJz66
SqejtJBnBUNEKpyGQ6k24d5cAlvTAxvLvsnoLroKIHLXbFM8PEPjZ5Rvt1kuCJ7oxCZwFatw
KdlsoOY3fOwVskgwAcgDvO7Bb+VVpat+O1QM/ad/eahzi6n1I7bJ208jvtOm8XrOve58gaeC
Me8xkFjl7824uQ4os6Lz0PilwzkQ/n+pHYaXLmQ0pXrCbO7J90rsTL2/R919vbzc7Yd9Y/3t
1M522NXbpRPnMI/txG2DlqngoA/VBDBQHYU+xt75zlN+EJiUtPdkrpL3/09XmAhjIvLvem4r
+++k19WVEqkJimz1cXN9cupoB/sSPKKAFth4ko0MfnU9hF30bWkTNaixZxs1YLsmnFChx7tH
tR/P9Ahq5lH6xQn6eWOreGtJBKKTq+JuYiTHieQit40KMCCyTACYCsBH0ywXuJp5hhgj5W41
bCyOvFptUDcpB1kywRsCQ4StpN8PAjdM829uhGfdYote1MuUXHn+PtPpzIzs7AXYqeY5tXmH
MAocFdoUNCYRtknzcQ0DmLKtaiAuOgx+FHwR/FQmUVtBr8WvOjrKXONkDMeupfsIj4+3Asdw
0KcdhXb6hi57IyjTXdYfmihUlzyO6aZXzkNbBwUuWIzHHpGfXJFAwYVsxGeb8TsM1OeA2jpR
QIcnHMNjSPZc6lswTRLm9FDvMVihKNNgKu2d/6iMwHS2AFM8xcsngT8QFEtucapp8x0bYiKf
A8GUoajut2oEWC1h2pyengRchC8oU7PLm2sXOH6l6/LoFACmPnf+CFWxu4xd4XqS/GQQ1kko
SgBezi3LRIJRLuBh5gTscKj+lMKjX/seKC/vwMSwW+/MIZy4LdTEds/4yvK5jMqfkTn/6aEg
obH3Q0eMXTt+vw+JwulzLUPGX+BHxrj730qvnHCAfEI4+AMqjo9XUtrynd43r0lDqHuM4DAt
wDGCwRmPdtJAduJzZ2Ftb5Y19zQmDNdIBCsoEuM4pFYQ6LDxgVzpI1tbbUQqYIbI5ydui84b
Px5o0i2CFovE6hSg7Ce1gSdfouicsN1a40nurzGVzI7Ztbp6ub1Wb5XFWeUC1XIiuHH+FIdg
8k8dSk4Y2hZm3PU/aTbimffOefdbfPTR6Rrp/c0jq7z8xrmk9kMdVebgWTisHy4oSeX35EuN
AZ39RuGg+tqsUP/SIWsmVd53Z/njYGg9wTCvyQKv3wDQ/8776FZ2VlSWrelKzXjD6iOMEsyz
rdZaQtmRI3GElzcGcUK3jT5qyM1xI6qw6hg7p1RYNTOrL3odsG47Ea7uhMAFgSCYnZ/OlOc5
k6WQ1n7Dov3dxxYNBU6dxqzvyvJC4flH0KkOkIg4sqG29cJbOanSaQdo3RiTEpwWY2DFDglR
Z2NMtnqHyEw/N3p3KCpd7VBzz/JnGqo7LsyGeATiQxsCzQlKaD3Ka5BZbqY5kG3RWfkPWNwZ
cPFRHcaFysxqeu9VYfyZc801p7Qk6ydi5bJJYZS7jCX3SpHm6anK+ti2KxTVxWmydDm7L2vM
hj1oMYzoJTqwiw2pUJf8ZMV6W2yhJW+aZuPo2jLi1JT8HvrYhlAoHcUuo9S2Km53V0P8+cd0
Bw0JvL4nCABEmNyiczWuWgVDEm7h7gf6YFF8nQTukcxhiy2g4pifKmwjNSbE9jVasUMe0orn
SAqmt9ZzkgW5WIDL804SY1znz/fYjlhfuWKohqJm13iGIEy75AOMZqzTiWShyUSBQfMJ+W0a
aI+BGGeZLVWSZwEFvb7J91DOzN+SMxzym5f3rV36avB1eb49dRV4nLQ7mdd2ZwzfCTSix4fI
CFa3y1CKHdKBZUYT1gghL1JaXXpnib6b1HP+qnfKZ3lZPsxaUgwJJkRdmkrJMBY6hIh9doRO
mA0+00v8q3BM7w+58kXgOSUoqYeaNssESb1zZ2Taa2klGSkHmWXK+E9wBSByxRG8/mkuCazY
NdY8UNO66KGAm3fr6i7bVcxfXObTCuqXhipgf7AlCGBZfyok60UKfiHEZSLa73R1XjUg2Uba
3pL96Iu49s+JxqSMbzY92oviPlgWQDhgNoiJKW9Pq4fYulEFAxYLzDoZIJJuRjSeu0dm97kd
VeIx6vTRGrjkKo/D7S8dQ5bxDPPWW74eV2GymFTn0gOa+rZ2gSO7AMLxZhGbn1in+BULiQq3
CI3cDfN8aVpVlWd8g6UDTIpPHz/4NiVj3777Gi/P5DkNGC+JqIweDp4Y/JNprJkELhlALSvW
z4+VDFRxiq/7IiD3Sdr7l7zf2eeTiu4ieYQks56DsXo4P3k9V3AhFiYIVBNGH8CzCdpqvph1
Rsdv0QsNNFA16wrMod5tvMzDMpzFBiL6lwzbA63Y/mfSIG0LvFYl/KQeiaowppShHdWVNsY9
Wa6Csn7DnmtUJpecfhGCnG4KKsPa0PH5H61esCX1pzUcqqxqe5mDvCP3SCjXEaSF8STk1CVZ
S0GU5RnFpscwGT1PNatnGmnwCzfBqgrxFyrePOFkURIW69hFUGCZdF9lPSKJHksjNEvwELCx
AzVQy/Ctd8bGDfXZ3BaAm8s+n5yo1MXPLVIaqMA12ELSUj/0+vKR3kxCRtT1TKXlkrbvYv/v
gm8bLDi6NqTIraeShD6rnC7acAxxft5xL6RMjzk1dwnddP0Nn86Tw4LJXoD3gyNlsuhbHdnN
hrRV05PGDvh0MuVamQfk6vRn05bwdKXFIDN0l6UcvEE9qpI8/tri7bfotz9+YGSjm0oXnxmG
NPcSIZSlv+xCptTO0ZeYac7IfnjEOnuMmOeoZNvHtKABU3iBvpKb4mDcrZoVJEDa0/hcb7IJ
QCoy+qffsHf1t/+7wlpEWH2Zbyio4LrEvOc0lKywIjIb3oSPBub7/qg5YAGQn4mlaWIWylFZ
d3jSpZhpt4X7tD3nb/wQfwgF0xm4ejwnOzlv+p3Gnb9Utv0VeYseigCd3gqfpJ7Q3KvWUCgJ
DgZHiiZhFDuqDRkd/dQPpFszmYvv1XekUk55MDnoAxVN19kHcYe24nL8H1jaPh/dDb6MgwXT
A2YeyWZRVmYTb/KOH6dz9LqhKwcB8rYL4GuOzPp4hdFn+TyAB+yNqIZdc4faIRpKbZrJIluN
WV0jyh8crSLkuFqG8tLrh7gd/kvwsqBhz5tGx0i5EUAXiRhbxMXgKpfssNCIv/L8UwMRIU7g
7eMtEBEYGEJz95pJ1a/xDGzznKr+H3fNV9xyE3Bpb890hnczeCeIrDMbznlO8oI3Zam3u8lQ
dFmBbWDsb3RKtw1geQKLwPWo1iillH8rrCSSkAiPbbcZecYwQBaL2PPLzEKLpofjMuu/FLgG
WgR/KxBPd6fTE46HBMm6eySYTWIYfLpVTqKxUlb7ibW3MakP/nyYSvx+qzKWrASq3LDAxb5b
tX2w1o1BZ1PyDC9qWVlrFTGv9cn96bTHHumIs4dBHYEi6pjrML5QjzyUhGshXtIVv4SiPsoP
Va/fljH5qvbE4pjZF6HM5W0GpcmKyCGUa2qTwhuxR/vjkvGotRDcQqizs/6jAEMNtU9zi/Vd
xbDlirH2hKZy6yTpwk81F6gJl/ycbx1+w631UUc+OoNckeJdAUO8DR3XABhNQGdDSgQGuG2c
G35jpgAZZYiR/g4RBTj2oF3IAokMiXnbMjlrlbldyIk2LMZlcxukzNwBTTLR4/VIDE96fsz4
b/0t1wZFanY1BkQM7bZzyT/FT0eQ//H1BFV+e+ny8u/vjtdmb55nK5i3ib/t/Awz9ggVSOzG
ryBwKUZtUwUFvAKwuyBOzmIhZqYVvq8/YhAEVu9dRZIyQ6lLVSEAFqxfgUV8BmGgxoN/Ef8k
rJkk/1PHBxcoJ0D0flYhWeHnhwTts/XkP8uliki0QkV3QhGDJWVIaJF+W4VOoxgAnSktLaFk
jchMN8brbvdSGMiUQ06IO4D3ItwrVqj0ET0XiSRDCt8SkxTn2AJFTB2DX9lT3E36D3IWFQKP
TTO4Y7zidF6hAYefvfmlHyzD4h/CcCZwSDH37/bA0//NgMyFZ3U5kGCtHoCR7d4dMPyIbBWk
4K0zDLgZZjyb+zay4GSlOzHSUNZiJ8xoXx8Ju7+ILL4HKSmZHAIp69P0wt6V4gAtUjZnhRAH
nf/3hIj4lHAaPs3+UpLmfiGw5vSWUsGX9RGYmZ4fVMADszxy2zppeU1D2EMoji45Kx2EngYy
qIGBHANYc0MRDzCKxRmjj6pBOnQO4vTCJLuRTG/cIFxGQZc6aoUdr/0M1LZb27Ogaai3WsyK
+YN4HQNxI/Ue3cOA10weAPXkuppoAt72vjEZrOb00A7lHV+nDWgxi6FFQsMUPzgQ61L6tyR/
FbHwZJ/BCtEVpA+mEUt+D4bfyGu45EFV3KhjSBmHaQ39wTS2FhBLsoau5frMSgwevSipByh5
SitXWwolx5naPbDimQq+UYdrBPCePMEuSFLRWEd4mCBHv9NQM/POL0x9Z/fvJqOdkgtfKd2r
/lJaa8sCo3YO4JOmb27GwzK0Zmvw7mPZGMj0qyGe7FfPYNbIs9ND32y+fBA0MzQBRGRiaNNM
8yl/HDW7ZYldPI0xeqkNVox5e5ebnrsBbxYEv3jRu1EO+SReW9s7qXkPRx1HuepvAIbs2ZD3
qbhKTpkOHMaEuM3r3U/FMrSjDeeu/pUFmRBu+MGeEef7kdZtjqPv0gCh6ugFrfeursoQSXLa
a2sU6+D9X/3ZxB4rY6ysMRDZkXqxbVrnwLnNeA1zU2hGzOIzPzufK1VG61ue/jwDNqOX7b/X
XMFcSqds0qcS9IEOunkQWcYIBh/VCcQKHbWiTYcfNojcxjIhR2poso388dqjOxvtX69PGkuC
BjEhkQs1L/i4duyfAMYpU+9AUPeZd8X8H6eWbjKhGyov89zK30Pa6/XJ9mgj1FIddtsd5V05
mQ1oyKzHCI9gj29arxpcbVghQLVstUC4meGNneg4ONbR8C/tBtTjuvmIDhkTM87fgTw+wu+z
84rIuuiFrYM4nizMtW6RxXweDcsc6USWitruMAfca7u5lMv4TAqX+3ZvpyE8n8SeQAJmeqZA
+sasuDj9Y0Aip/TirJI/NQofxXAjEY0R8fF3WDINbDno5Clu7umwEcu+OUVRsno2QXEoZ+Yw
diAixfqLg9sTZAM0O1ZxACe/qyBqEQMrFCz9PEdqQfaFO0PAa1JEhGgp9dTTLUW3r47kMPXL
1Xd0AsFVkheuuRNtvbHWUj6Fa+I592ajF5n8uim7kefrjKtgAe0IctMv4R6rJZRm/tXDkVhj
VEErFnGBiDX+sooZ//LtEkqaoybua2BTe86SB8kTmSi0sQ/VuF7XY3y+amdWXy/eWdQNts/X
KuH/FCPOrVvkS57GvStCiGGws8LaE5zZ6fXlca8DDFHfn2ZJjH+wxvA1dyGDMj/1dL0cJZ7s
6E68Z+fbHm34eQWQQRSyUpwASkDhslyMhdT6SNoBVXTXnKtA1Zq0U41ilTWlWrIRh8f7gIsD
ieUOcJ7zk4Jd00zRm6jX6CJLuPzI4J6JKr7VVQB4hB0MHf1prMPQjbgGQAqnz2FE/BwGXS8K
C42YptLld6sBwLrCCV6DJVJggznAYd7L/xmDbphYiigTFSk4aiDqsXIT4ABfp2hQRuitxMYD
AW1UBJuGYRvPhTvbuTFfc9YX5Z0CL8+dS4fh4/Wfr9sjLialymQZYewOX0csNR7Ox6qkI74M
Gn3P3wG33xPkNnrCJU35siF4YJtBRUidyzPNW8brUU838RNQIipTAbSBwZrS8wXtqWpdp/cF
MNApsLyGt5mKo8dA/hWgulBzaTdB1FjgKY1E/9Pawb088h+ZFHPl5vEdJ7dgMBCWpDrwFmbI
9dmm9MqlkMkxLB4Cv9ZdS2CKKQ/Lar4Zn+QCzdt1rEpNII2xBf8BeLrVNinTt5/KE67qlxIc
1EWp5EgqAVNYSfK2vlMfiMFAT71otfSybX4WAn4KTJPNeDrtxeFZuxEgdhdHZCCL62a5lqOA
vovfXSjP6klQZMfbWRnvEj/y4AqWQkFL2eUT8AFzAnsrHYEF92/ZeTQLeVpcVZ2lOC8F2Z6H
1ZF1da8ilWBBjM/vbM77wOXqB+oyzYhoFJNfQuOSrKmjV9bVnzE9vkoMFK3884KpyICQvGx+
A14oBxNcyCnPXkixSf5gDK5d7gRzyk0W2qXqc3klp+9TwfZYE5yHQFp3LPJ9tSmt5RXFX3Vq
CTgTL2QLuEN7Wt68ydivDa5DxBM0SLdORd+CAxNBWFRLlfw8CUIn34BcDT/MVYYd8GLB37J3
tRKgQTVJaDWTwfsUtPNjIVxW7CY2HHSF0amnORpsKACS9ROk2LmxV7cnrXaBdCuPmCa+z0Hl
twjJ6wL8YKjD8DIqJGM9jA6Xemg5psZAA9lx1j8tdXn7wLDu1tCSYU2ZwR03cylnTOApTn+K
S31sESrwslqOax5IXKVKBGFprna6emM86Dp3yth3GRIj0UTHxVnzAWK0DARJeXOtD7u0EH5d
XYh56Q1qcZUVEXPinizPieR8Nu+lHn5e1uTwPlR08Ve1h98rCpenNAa4T5gY8mks+sjFxYJo
WlIwOUK7cNwA9WpnZdznDY9YNWZR0nGtvDYX5WsQKDwAgnG6ITa/Z2ya8XwgC99zBoYFxaW8
QuKzxYq8Q1j58cCd8jdU+1PnISHAXBQMf2yyzBEHUL1XV3T4eSU9D0xFFl/V4Z0FmcOQrx6m
D9JB9vbfyFKIlN5AdJceeX+3v99/hysIqxBaItXrWuvbzG6i/yN7BVJ0w54G533BcxEOaBci
CXwzJb8EmqzQd/WiexwxVtXTend1O75ezMs+jBzDfcrNuZZ2k2tjZD9ryvlo6lTWDoNeqt2S
eWWnOgHdOIe9V1+pRptdd6CcADYaNnVyRUosHuV6GxsuaXL/D1PW4XR0IiPw/OdlQ+Resk6A
JVfI6r4nrGFgePRfKBDqDmHakBUuppROguxuFX12rhM/lzX0/Sl+XoUMiD66laO24ykZl4m6
SWZZDZ3mXRPJdBZ7QIIbIAdiWBgkAz+z2VlAoqBiQ5Z0ZUXJwhoaA/X+qzhQOEuMQ/pDvpCt
Ge1lKcsU8SiFujw8d0zXeQ3oD2TVEqHf3EqQZ3tSMui5UNvW/c84AeBBchxGlw1r74ApR25i
qr2V9oGrGy3TRIoY18iSz8A1Kh5x6D7fhE5i8n1VDuSu6BV0JrSJlkBUCzTWq7I5wO4BI6wk
jmOQWzec2mNAkDYrbGIJjwe18RdgfZzN60MFUji3+4wdthkxs3zPlWO/z/TLlJ3njoFq2/8p
ACLs4/x9yeETgt5qX2lo/jrY0/ew6w6oAvyFmwH78YPLJsuTEBbdpjnBvuP3k3/ygxu6aSAd
LdVQffxS4I7hkd/cqbjgGOynySkHTZE5TiGyyhLSEfWwlw4nAHCIg6iQpIqLRBATr7BnvIwm
MHTc8qZkAfhrE4O4U1BIaucOWjgrZXxpm58yGP3Rxn2VXUKrZ+dFTOFfVGvVyTREoAbbbVxY
nw7nIilY/+HiK0oxQZGK/XDx6jYVsC2vIhp+/W6ci//pPRxZg0aNeYdFiM/QE37QRe51RwlP
oCfllfKEdLrp7zN44BdExoPouvD28HkHKSf54biBP7/AKAJ9R0kWjBkvGmPLCuMg2Wzr+RsO
yxi0B8kisjjnoBLijGbcNqVxBwz6Pr5LLJFSN9zAft2qqFguAC7EPvBr4bG65fFCmIhVtylE
THZ0epM3c9QNEXLhrJUjJLEOygDDuWJpQMHiIJbUOPrBkREsrV4IjQvVzooNGmluzameF4d4
Lvb3tB8lS9Obh2ZvXSXaxL9iFiL+FMjTXcmZ0e1bN4ojrE9kmfwISyVMr8rbzo8xHbbHeo5j
s8HKg3qzQi8aZ6Q/EhiQcD78l0xL6pQrTYxjWmQgw+/MSvz9nMJyxhsKgXbQNULyvxCqMssq
OMs6zI6xeg9b9aZZO4RZfUArg6U/leON50cMVZhtO3/45RMmo/ovl+VEB9lTbG/XDe8bjV+R
rYkMEtnFhIee7SxmGiUOJTJJZBV8NDWWps3+MI8LVgYFHkUWqA5UJOzda0AUw10RPz2+ZlFd
CkpUmIbC3NRUhCNmW9ViGDrJ3GcTS2g1HJsAOvjRtafPrZasW6H9wXLSbL7VwPIwlfVEErE/
fc+f+cf4s1MiAUD8THkH3+VjDA2QX70sREJBwTHNzW7yYNHeNSyl1ZhSNJ/ACP5oOpqKMaeu
CLwQyT1yw7qrVd9pTak3+10WSYIl4oSLWGWBzVyTBUNODynI9tDJQpHhxjgZZvak6w/2Zgck
MqkXWRaH/rTFoAdngeO8nofbdJ5Q9iBMPnUrGq5jHp4KrdHkQYEI0YXaiqPInC94mWtJhGVy
qkw4D2P0YQRdyJm8wGJrZJb3MgUDmft7SNxYinFU8rO9oH9dgB3+71L0+hdeWICanq4Cs0CI
vQBnTXI9YYec1w1qA4TYPktCmBkwxqe+Flsnc8HfjGDUgGkcO/hTtQe1sGFiMKpyDMcxmmkt
1opj3XoLpMaAwzn2K5LAKzU6NfiXVl1kYtK7Tq34xFnAiKMDncFO9F2vSaFPhxeqHbaITKf+
ZiWf0oc09EHPO41XWTqRe5W8pZS65IKwoc6qH03Ac70dHsAnjCt9lL6s/hl0APWbPS4CiVcq
FX3FNUMdtgvGmL9SwvIoWl96tNBilVHrcZGBLF/JIlnysEsOpR9zyoocbIHfXjIhf2qnI8YZ
21Ldx86oGnfQhiIsNYgR58wjn9UkhK4f5hTfG/WJs016uROK+BgNWu0jd22pjgRIHlUjTHor
Tb0m1t+c/XEl+wkFWWiQhgM3lKDsc+BmhQop00U5OreCwvsFxDO0Y/l5UW6QuZApdUxFu/A+
ZdW1KVszh6IFCGmaVDkaa23LxVWZ945lmnsdpHy1zyyfV5Ur4+IJVEDs+ilNnAOjV1NJqjZk
qc+0FuEaRuhH+SrhrqhZKQmd3TPQE3Dz7MyHjghAMr1Rybw5+dUrXPYjXY/hOGmNQulET0do
eW5h8PxSSmYPYv2mljcI8T6djF/4xWBVKhFo/wRl5CihQjoVeinrBonsxLLXEE3CpmETUudR
GShJzQ8WsKEEXzSJuKtdT2HfuKoBbcbNhZPveSNlFDXc8Zc/8YPhWfT7wjVwna0//gFDV1AK
/dBgTUZkaciHrTw7yyvK/foBohn42x2oHrHGx02MgO/rItdN8W+ocIpK7PWJlBByXdVVeh9d
926vlkHNdQiaYHt9W6OIgcaipWAM6dj1N8orDcqvMvVMuVWb0E9abJR/zHEYzBU2+M/GWdrr
73bmq9YIUdLOf+9GG6oMqCQpkJmTItiDyMHy0lzXmJPXPtax1stfdgSWQKWPhVu39OpHEkxD
K6KOLsXwgrWdR8ZN/HjH00id+WmvtuMOl9vuyccX9wPkWYh0HVNS63dsYPh8kBTbWjgw2qF+
MTjfGACR2tjgnAaNtqndE7NzGV+vaeWazHNWi8fDRnZ+soTDtknDVuVnxXxRpZad66qDhziR
HOYN9e6yDe+Ru9SxnSCc4ln/+QKctJoLcKLnI0iho7a8gfoWWOCAb5xHvCdHLAiI9ClYVNyi
Q++HCtNvMCrN9KRxAHtfIgoS5r/KtDm5w9TIMCwYj09pJFOwutu2rr5z7Pat/pudvdYWyQ6m
eeFkvI7Kwfjv5lLHqrwL1fLdsNNz9kcsYz1tr2txHvZMptjzvdLt7RAFozitxEBRTvOaMPon
81vKVrIlg/sVV6Ohc9L/jIR+bTWuJC33Mrz+q+teX67W3RQPHJOD66ONHOm4Y31nkwair7bA
Kyhh4fYTOwHORQC6bOZ+3ihkrJrww+0JX/4ihM1GzOi3Syp+zj6sjVch0L0cX4AnQkLqx71V
1go7VDBjQZsZ2v07BcJ9BiZKj0XahvZEvCNnhPISYQoCV+el6ZBCHtwgJ1MpBPs44OJpHW0R
O8AXLVdYC17eqZ+3wDYMRdBszKPp8yJ3nPeWBDwrwbNoMcI9grfNu/TnGFK7lXzNYdNZ4IaD
jeLtkZIUO+2RmdS22B5MwHTc7WG3w89rroIhy/k+cxrtltO4YsH7VZopF9BVJ43RgKNlzr4m
iKk7hR1Z0VTiqdr/zqJ75wWC+L7SKY7l7ANuvNoEQ/BL7uY/uV3fbQsSwJ2zqvjh2h0mmHaJ
owg69JolzOau//nnuHYj6KGS0/08Lv1jPPTCWHKzA3CZyWwxKfkDrAi+Zx1h53UB8LkEsVHV
2ZUs8pHwNDUpHL4i0Ds3AykruyYIWU7WRdjFpRRcsMCP0MKvEDstXGQAfNlsl0YpzePX0Avt
o1mvCUsMsLwHz1Hm10iJm1mtf4PiLS4ELlnwxfI4Lz/w8e+B45dbOW8P9bVvewndgZFsZwvw
ftUk0XGIo1e6oaBaJK60gSdKb5exNyw8VvzEkrXTQDUGWZR/9GV1ovTp2tSzeh07kMvvN4GF
+KTPsurf8txNTlnflzToCO+35g+deB3wd/mi8uWwo/p7Ua7q0B+TJ5qhgjS9Fxo31dsPC8zs
80FJr0ywZIjUzO9/l9vHNW8NCLZQiL4GayGlBUUwbldTgueNFE0ZfpPKnYce+Hdhfo2jpYLf
aolFTrl+DaIVNYlRqeDibet8qnwJMvEzwfk77YBjaOlShTE2znzl4aYL9aIeEXzn8ScINciT
qp3aGISPl77DVYTBZbKY7KM7nA+EmRpmGQ/qifCsMBB6MV/H8gcmTCGtHGO3DdSeIxms1FAo
Zld7PWMC/FJUxAmsD5b7dOvtSyxMP1q2aZig0E0S5G+7rejUjI94lO8R7q+nYSzt5AYNoSLb
OAdQFykR3zWxlxbmakTRw1f2YR18BpFzNl5bY2QrsG5uNVnxOyXz5FEnvLIIY9Hl9+Rsisuv
C/jGAjRwWmU1mGOdUi8cfufqyyIpbRHpij64Wd0WZAegRjZd9qlbBss2fvSwygiazbMcUN4W
qPOe0+C6mCi/AYQxFVLfcHKPz+OU48jvOuQjQgf/Qn9ccMdnXV/hjd9pRkzOESnFpGTioR+c
F0FpiIkjr5/2hwHlA4admNWpSOxKUhWuzkKFBm2C2kp7XAiIAqI2aPpkmX9IZIcbpu/yyoLA
Q9fsio+xUMOk4pm/WhELou6BojHfClr5JKPK7ThSS4PypHx6/hQVbMSllBuannOiqMzawd+c
qHokGPDqhcRzhtEfIJzaPE9GnGpwiiXtmRcoBWmAYwEg/6t+FNx0v2Yv5khBf4rxN9g5Mlig
QljTenYvsXqjvbaESJzOVGUL5pjHplMqLDiyOWp/heufaHqYtwyWHNWJHWZgUUvE4/xtT66Y
+mOC9g34qO2ZEaw42pLyDkQsMROVGFTkC/yUc4OIljiDNSNvEnB/ksEm09NXbPcllFxaO7al
GLrc8p9N9W+N7nZMKxh1GkDvVz+AUUpaZUmNtv1RMq0qZnWzgBkg42SeHSOaEMG8YXdvPMQm
DfAgGi36mcTuB87qQZz/GvTUnhEDiD7OlqPU/HODyrxqrg+8cpMloS+ARpCn+6XCpRl6Z/Dt
Dwcv7z7Bf4HjgdOTFvNa6YkFe+ezO4beIhs2b4Ehh/Cfyw1+DITdtP6kAImgS3hmmDQuHPZf
3STHPqJy9MKFjUG+3KMvY3oh9jV26p0ISPmBvf+W3niUP9IOA7KpTGulVRLIbhO82oNdi7R8
NtWvw3RfiQlXA4YiuYiAPGNIqqoYAVUPxq/1/lR//fhyfJ9LCwfwnJwsnxTFX3twwfXkSuy7
5ZrRn5OJok3qPFPFtvIIL6/Q6sJ5pNbuY11sRKQhUhjuWPpIsMCLqMCVm+LsWCXOtDOHqpDD
1+a4FBG/Y7rSl+A4O/3EAmBG3lIlnXoZ1hOiuzNQZkfdlXnMH6Csx8C/H/BfrexQkvtfrgWH
xswuLGdMxFvKkLsEiq4SEWYki6oLXn1v+GXrmtBSqon/KU9CIPhyjrrR9qFWGklkB5dcYj6j
62wyCh+t33+LBTpiJsEaFcGNKou880XmDTFgFuG7+4VQcHYymquRfI5L5MnzoHvGDBX7R/Tx
QkZpmbKFPUCOnZK7cEUdYW0IuIUvLXUF5DYKEFDYVCgSb8Aw9XXWl8V2MARs/Hn3xaA9uPi8
oJ1tAgumTAFjbam125jj1yNDEvw/+u3ytNO8ky5b8XeadDB4kroOyzQbhbDOLAmJiNQyiYM4
Cg0tLEWg0z50MC3Gp/U/aWrj64gF05zPuFHA9BZWUW0ipCvfqGcL/WXlRrQ4YN0pgip8MGoW
xEZPtSWHEltN4dQlIv0OxT5WBjrl78qTe+POr5x2C7z7er93EUr30/40QmELKzcDK7GVVBS9
3KMhFfzSoalk8rPiGoF5gZu1ec95nJMT8VxJ+aO9R8/Ru7WNSZ1HyBTSvP1W3Fiksf31TCnc
tfLvIxBBDQaPD+rvXKMOU6OY4cySBjih0cQ+XgoEE43RaDgzjwTsCnNHCbQngyZZfa3fghU2
wCIqvFdJ6e3xV3F7r9fOd4Xq+mo/L8oHEpnJanbI0xRZu/3oXloyItYV2+dMzM4/tFGXMiWM
Cen1+QDxyJgZEHOrPbSXnAQ8GQAvL2TRXtm9l+Ddk9xXOiuqS2cSjPS+Ks12gM+3gm0LZzaj
vmpK5UBY6/clSeDB4TOGx6UpQX+5j/OaPRLPnorYsiFudr7kmSdqz7tB3tgfpnyPTyZefBMm
/4cPed9F+OsHv1c7CXqvgAojm6PAUi+xcs/gyg2svU7XlIDk53TckEX9jZUbZcrmfBhDNTeF
raNE0BmqrCB69Qqetdm/cafaK5dLLU+L7LpeMeF4l+ACOG+Hwyq/Uo21iUqLIV+2YfMZIAOs
hd8vpXXzNEU0hK4P4Mz2QjYKbBOvItyl9T4Q9Njy9aUIJl09G22d/bGKQatMkhC0h5lIMwpg
SMKc6qop82GxBPW1XywpoGeOe1K6ZXnbr7zXjgNnYdAsrPNUcPvkUcMRvf/FwiAdVdKojB4i
J4z+pKL3ivvrTjmQF43ESsqBeqMaUf8UrO0ts/q0R3GBUcZ3OjEbyzyOgfEsf531lREA5W8c
vn1vbpFEPwlDU0k8Lai7x3gRtZOH/wijAnw/QJ94JItp34Aacl7cvqbt4qIsbc5QT6MmFcPi
JjUoRIlKae8QJuTyDAUbsGMQeVq8nhWNBtJyElnvC0o9+oAqYMmhnQ3WCbmvvK1looPJuRWS
05T/yiYX1Ht3udc0cnyiRS3uw1tOcOtBOIA7ux0+YPSBEAErbKZcXOUV6uHqtsfQXjpEw28f
wUQp6KiAfr+lQdTRlE7DscIADsFPGATg5Kf/n2Z6d3fx2/AlOaiHy8yxeHEi+MKoZGnpcSLB
10gnQ7RlYXcGiwhwvNQOxNvJ1Fyt07JMPvjusLK/Z3VA2TESKWD0vW8Iz0EF4sbHVB7vhLN+
QyBFDszC3JceIG5DgA6L1W1u0P99Rfyrg74ymLN1m2su9kBKr3Xrg+8ipsOeusPywG4CKMYg
+qbssnCYENwqVhzEnHTZ9GYhCXxu1+0LwvU3VDOvhLEOQG2zUpGCLxAEk+SE64vZuSX5sZx7
MEu9E1rQQtgqJCaWYCr9/HWTqLmz875NCFCoMmzvP5iqBudpFC6SDGBscAWJ0IfdxEW++xb5
04ljmTViS+FDXqgRq6hWeWvzsLY7jQvz64b/fJdfc86FMJXyMq3mhCD7Hu7nO8J5OZlrD1yy
nd0UNufh4QBWnpX4Eg8yBHK7gZrGF2A/krpwDtLCJfuKsH0c4VwUPUhfDqM/CLN+yqoqyNq6
F+e6Y9ZEl4+59BjrXK2P2lLU1FMF4vyjTXQFyybgcnN+wQplJW+nNh2pVuf9b0ogwE8H+SxV
7oYUNIRccGSa8uGe0+d4VYIqtCXKk3fwhN30BVTIOCupCdBN5xIsRXpmzAggJSC19uX7pQ3S
jBP0dIF1BvjZxHLOy0B5hxaT8NAq0o28+F4QWByb5xUfhu9vzUAPricI20BRXpfMjI6CDKT9
0JJv4pC8KIZ4mBTepMq2GZfnTRjdS3GRNZ0eogcvfsuSG2En6hlBHvXuCTmCU0ePHMjutOAX
OPYv8WbYOUQNjJ7c+Z/aEIXa9XfB3UErihp1ldNW2nyBXD9qhvyl5cpWwDDYRo3V3yWU42qO
PSoUtVeuquqw9rHh/5F1J8I3ClcDAkfUH1s+JT1Rc4kyrf4JobEoE//ne/S0A8ZXZhbAHeuM
XR7pPfONIS0h1fMsqqr9J3ocQmA2Ym6J8Fw20YpKvOG2zcD8mMBPYDq/2ir6x5vgKDb9uOU4
uAUHHRkuu/wSGB946YsoIJ7AA55Jloy9SJVuKaSaHNJivSVFaWO3tIPq3TXD7XolT9uoXXpd
fK5KmbV+Gqe5zUGCPiNVus8meUJIDmUhAMmLkP+QLn23rJewSuc5SD+x9CcTotwXT+I0YWAY
EhScX7WUmrxcF3hVAwTkt/mIeQU2rCcdwwhGAuGjMIYyDYZe44iOYHkf+X0waDBZ6roFVuE/
n3ucZeplbAO4DT1mCw7pCDKkM16U6kEH4tc9CoSqO3nv7AMNMaJ58YjBf2b5pPLdj+v32VCB
bRxsMpCl4SuxQ4hKKyoFyg2bbM1cK90hncGDxsyThxqvA6ph0tAdMQfT6Gm/y5tIiKdC/qif
rFQ6/eAXCuSXm2esawRWGi5d++P+2kzKlWiYe9js0nTfQ1WxsnUOsj9GB18ocr8qF68bOvF1
4EvFbJWRXxy7XD5RQZjgGejzSxlAR6nq7vQK/X6vVBcEsErtwEljGrBy1TO3bPgt/2grIu9e
Q6trNYB17q9tLGtE6kyThxI74z9IjdtWdtiYQaIqP+gLK4mdkwvKp4VEK3AAPrO2MlpI7F82
+0hlSzbU6j6UmTUcFTE/fL6o6qzRxPFRdShN5awHqPJaMTGlME8QbkKThXUy/YZvGobHz456
B5WlZ4oIHIA1mB5alrtfw/Bqrb6ql1dZBdcLfbs9r3ch6oYQFS1iYFqJ6Q2L4/5f3wASneQJ
7PZ370laHGrfgreheQvfjweXic8vWBgF7W2P+rmAxgGfmSVgdGMCRcVm/DW0dj74RxS6l4oj
ixZoRZk7cIg+LtO2n5gXt+d3bhSiAgN2Y5CXa8jkTERyv2+bh72b8aA3sTSR5Qda3DfjUJs3
fXktR0iOZF4gpGpqXQznKtLchqNRXVruKBi7dTB5Zq4ghZmriZoMpPs0NOefJ1QEVEevWjKv
MHlv9FWFZ1Ozagq9+nBBbH2QvdH2xql1hT7SvoUO0WXvdSk7b3l82WTBKEKqO+rCjuD6ICgo
S1zB38xOHDX/bKqWb7G9BTz1wa+Exe7dvIIaea7nHlERdH7smiOxcXVd3ASghKG8BcBaH33b
/mdQe8l/J0ACeZDvrZXz75YJOMGNlWOYeSaPZPHmNg5BHK/Pn1fT+DkLWxI9+JEClaba+eFy
QDsjMKmCoRh5WftG3y7VEA6eC3aJ3iYoXlMr3UYNtBCyarer7ii0a/d10A0c3RsAeWNWLKDZ
QX6bcAGfsdRNVAXL3OVCwy7ZPpq7vNYiTpU9p/bQc+G6P8Jgvv7Ac9/wnYvar+nUIq/U1x17
0aRX3nWtZvYgU/RXCjVpS+M03Bi5kmkKWD25sSGGzy3gqGcS6ngLEu7CBAFOn23A69Jgrshw
VOx98ou5eKo/8q6BXMqyTDSUUM7NcoYl1lUWUZLM46pWUbiPwdbC7JvkcZ7fIsp95pDAsFA/
kfde5FWuSfk0q+Al2/utnbusb++/uffAbsb3LKjb/RQtcfFSbFMwLtHB6yhIHSsslkr8KNI4
w8WP5rpnLFGL6cUn7K7WP68LSZNG+nYh1zjINt9GFBc5W6wJuR+qA/QujGrvuBiUtd4Rht0X
yc5yr+iDl7jfKxhlw3KrUXqs1TURXK9vCKsws2JiqTvkJMJHaS85tvvAQh94LnuJ24Yr4teX
SLKH7lCXqjnjj4XPyWvpdWv6v/UoEcF0u72PmHtYQ92zKYM3SbsK8JtHX8p/d4gISTiRpwgt
a/gUpldjr9OOD1xhOAz0eOOuKh7zHVNGDMBadv4p3rqMwfmWmbiMs+dhWzjt7QnErXym3IOG
A7q3GChXEq2Q3hA8t44GnRzZuWqAWsUiiCv1iC5dQSF3YlRpneXgcj12ai7Ik5S7NrOZfGEI
VutROKJMTnSrLOPB0EbStqTkGhLBXKSJGQknRyjte/wn86ffCEkj5T/OQsWAalz7QX5+MuKI
Z2+IGhNeWMmNZChLj2v6CS/vlerppovG9JV8UE29TiAk0Lwc4gDWk8g6eAKrWj0p7kY9An8P
PxfHWDdNYWk9/cKvgfW+p/iCxJqtnV4bZjzhkKdh3Hb4RJkDY79+6ZnBUtBf57ffO6ZjGrye
SX2IkEEDMq5PlLTcPAT/o8iLiz23iyYKTsV/vk8NShAMngfhNRjGs/Cyil8jd7gkDaR2CjUB
P49yYP8HSuhNLUXVVRUyeHf5pdOxhTJncJGDVkBBZpNyQrUxebB8FcNepnud8BtHGDU+CnLW
HoJpCHJ4Y7aQh8D4RPc1Zz1XbPPevgFox1nZDhY67F5uAk5xwrgDpMgixHGr3m4lZBY9+PMf
G717XZ5HnBaGvnTqSK6PRCV0S+KZ46XsbK1ZtzjeHY8a5iQUKJZs1QVbQNIGvRKnrMo8nq4i
yLkE6x5GkGajPk+uzGVRJZ56oW62yyJbdcFXXdIHnMobuGJZ19rjAnfPMrTqDLzi/HbJJIM8
hoj4ZKOR9TnDzHTtfsVN3rjtdfIM4dLEklCWneboLLBHs+8686WSwqtt4HP17TcinMoGcEju
F0VVW6GYe6Dj2Lxk752vxLyqTcORu3HlEtL8sK6pZEMpw/p67hFYe3tNggMWL+7DuA9/u1XK
QudvTbHn2WNCBCbp+3KDx2oMh3Qwx39WINgSVg6rnNtRAP0gaNsWzew78WP8Qh8hCURDbtJJ
jklUd7VKyM2DkdKlHGrS/pXzJh5QxqfZ6O9UBwVpcHj9vQX2jDN5xjQkr042RBSJliSCaNI2
FfhBCGV45BMTHwVxT7dplWMB4bSVlyO6x0n9qIE/r14pQM49pMpXHili3axZYrMM+hd3v+un
Av2JJ0ZhbzbEy+h+9wd/ohgboPDneD0EG2lnpGtmTXeoWrmOzkk1bgnn8jsYm2z7jyYpZJB/
rLhQXXGhz/wUdtzKPy0Pn5SGz3+WnP24XIXlB6Rk0KJPk/Wo3+a5VoQ0IdGrEaI1ZXS1U30B
HxDYIOJx/S2PiImr0ajs6N8FpD+rPWRnw2e8CHe51dzKRB18E0NCa99+06CvjX0vpCBGVHDA
6HjOWxd2AyrG+Bp4U8H3l594lhAYeEXVmrLYK32p2yuqpsd/rVMZWfzNIhcW5eT73JRDJ8GH
LZCfCDnmURwkathWrtf9PTE5ADq1e0UMFiDdUSkWIaLqQyAx0iXjUe66O1esjEVkdLRBdugr
HPzqNNuQjFBSlyXzAuw7Kaz4OU5u9PI/qxsnz67dkhHcwWktbjod66AR6nw9ws40kq4kXitE
+JfmLTi0GhImhu1Gm7GEVxvSHOaMY2XxcHJZZmIyuaTbZMh8dTviwiHeqFArraRAL9zSIgrc
zED4KXp/Dc1Fpg+wztfgQL9xfrJW6TOu2JOStOQPi1EqkgdiokIHyS9Bc5tYLTTsm7x7CZlb
3CykZaAFEkBGP7A2VwiGDehcGt6px0KCYLlT4gz9rbCL6fepZ4cHy29z3bxSYy9gW4Q78aPZ
6+efjo/SOzF0xMjmzJrVYhBfVUH2s+6h79zU01ZkF42nnpYKgJNL2Uyb7RI70I/peTYXa2pb
5+ksofBwCqm/Wqisor4i+T2M9EObLUW7i04WjGbF/Hyk+0taBRqUOjMyNCQIPTd7qAHo3Rg9
MnSsRobsXWYOBH+jJ6Lp3k8hU0SFa0N3vqtgye0Q4l9osBi+PuAmvyYovix8sQSkZjcT0Da4
ci/YTCjmFkxwzDe0F7o6/GCDkOrKXW5xA535wXeVlg9zy9/9v6SPRtRspxZf0jq36j0OJgdY
zEmgehjYfd4n3bcgVE3JUFyxCD7i5mJcUqHrut2BNtHJWf1NSm3LPD1HkffGvwSv7RmjqmVl
Smxu7Lr8NNHyvLh47MAWJx1gAXsvfKw3/c6ZApIt/quy5MfqH0JlpPz9SlfJk2e9hULWbXHI
aONpbf+VTXlFKrcgZ7JqPC3xbeqF17OOuaaLFTzC7nuJ5X+cMogZzzItsl6ZCjTndd5yTGJV
Ru2OSSNjO0Xd/nwpl8n46uvRmx398fRvec/Uc/rwK2r9sl9MPY0jV7yk9X4EzFAYhYimyscu
P8DR4B9Dq6wbte25q12VEXnE7Ud4koZ5wftr4fh8kDhaZ0eevbHMaVEWdkznrfQa9sGZm2vz
KlszataKLDmhEC5lmLyxV66WUw0Pa8d8c4SVlVgi/EmpqF/lMMWiw/Nv9Qit0LKgvRAbAmbo
VUIJzbT6DNqp+eeu6GUvIeIp/voOpjw3bMcEuAXSDMyMvAnIAWxdZmz7CaJz1E8Z3E6xHXuF
QHZfOmU+b3NQ3xaZTyyC0AD/KdBxeAAC60X1E6VgNUqv4YU8h6wA9QUNBbXzCar20xEMsGFi
8iQJAgmzqlLpDESWP6W5G0YgBpXS41EWyjLxciOZFOJXXnQZwCmMHQDsLAaiJEqtlHQqFPNo
xTLqRcOd8HY0DXCuSdpz0d3tDz3ehl58uwB7fpsexP54cYtoDiJuK2fLzqFa3rsvhJnMQTPj
QrTRh2CelT0Kttda7ME8nY6T2k7SIE3KcVxll/ZeybgFhxmtnT4Mj4IWMl/1RvjUEtUZQa33
+hILo+VOWnC95JGNtz9IuWAXBnx2DJ5yVyhBEpjU2fuI4y/imIlbBr8K4adCmQptv5unycP9
nVk2kbsb8DB+jz7NwJVVTgsTzEvnTS8wLDyqne/NS2I0N5vJ0NUl8Bm78EoM1vaiwtbSHXLC
KBcZLeUzcnl7D5RqdIJdV1gp6T+R3W/0yvalh3s5M7q1JeC2p+ai4mY8G5KPMbwIxSn5zjzh
6k8tzUkDgkWsrIKcUHtdj3mLNbsKoiQyTvzWOwGUW8zFF+ChoZPf0FdmE91Ju4yT/bSBb9Ix
fdbrc/OPZ4Wyg3a/a4GklaDZC92GpYFBE037ovy5r+UWLKt1iTnW3vTMwyH2L8AqdhHzikyG
QGbwVrvspet5kpCyCqpW64AIWM4bI/HLdaDllnexaI9YMfVlaLtnmHS4nHbciAyCBPzqybcG
pY07Mb8/QmXyk7qenRcDBSf3pfRj/aMTN/mF10G+k6w3G4OpWc6DRlGFriFCbhPOMuWoQcfp
/bmANBV7YS8yvDEtZwa3WahtKymRjpCJTtT2/hKXJRuANqzKVuUA9QQQj80kpuyZZfV+6i3y
e29fFT19Di/IkuwMY+7PlEiGllT4n2u1zDNaZQe2ZlZkqtWRoE7BYA0J2TRhcWSmJJ4ncTeA
P6rDVumIR48xaJVlwWSLaRAAgoTMtilVb2+0MGh9WZAnzH7K7MTrMhIIMKCx2PIn/GJKqUdX
ppwqcqa6dR54zW3Wyl07UWPXkdwWF097X1g9TfhDVUmMisdG0Fm3aGseXWKPUa0ra3j8SDVk
/jtsBYNJe2eUi+DDGO03W6L0ma3SDRLhK49n9vD+L5j0Vtp92IHektR+Vy0tIKuOQCLoUope
DEhyc0BAjU+C+yM8saLyyfUZO6NaxHQZTIJyRU7qVrEp3O2v2Y4hnj86wnDQzoQK3fg42Q0T
FR6QeUTV+OBrqez2m+s0AM0oxrlJQl6r3ekZdNxOADs5CJV9TB2hcNthcS/Ao8yE2sHMFFTz
EwjKcB6Z9Ay+wCoOWCS6q7zXQskThvt0qqkCfIvqjrlbWtWBUfoNeNtH5crzLnGhBMzTzw2e
yGc+36PqkAPmeb6WDoTbQjy9vfD+PIhud1ndgjAmDCuzzomHburMenwgdlPEAQ6QiuNE5fd4
cZwxAG8IodAKBZSIHRcLLHORnq0u8mdZpYlYkg09dRjJNaIDvJJF/McbDahBllrIMgkN0u4v
2ktxaW2GKsWEg5LldMEnPqlREJ9yVa2wV/wivdevD+zX25AJqzaIA/pdFhkCWXQS3e8n9iUv
N6XL1yQCGudqQZ8hEY/7Z2pGLRcJJK35U9VUyuV/RQiVGX0TpjS67njy44mL/V4xwvlsng2R
DTMOItWWiYm5CGX2x6W1BrHOrzNzj6hsp4XThG2V6OwNsnkWxvRH5yZSDl3OJ0spk/Vrwqq9
FP21V59ktoKzbB82bj3FLseXCDsYsP3DFN8K5G50KNDwtd84YIbIT0BBFH0XysftAx/Ku0VE
aCP/vVraRBtcGPiIqFI5YIc+tyAr/PUhoaxqmNW9yRNbrLfNCcO89zdF+zV7GLz5IqxNBjhV
esn5zdjSKvdLfGDI7aOQWuNaQIwYO41iKWAlxJH5jzCahWG8j7D5EaqYVvTb/sjWVFIimQoI
qlnrz4xUKz8Sxjm55vnF27YnZHH4LvKK4h+hloojDQW6QesLJzWtYN5OKSI+cMQ0KnhcaDdf
5dArSs2Rd3LnGcWvdq7JRbwdizP9+yNsXLCNYIfqPJXHn0JVCMV3H9rIARMdqn9R2mRJqaKs
LiPkft9Mi9SVDIOhs6hQrCKLySR4VJvU4uqq7O5KVBqJrguTXmpkBn04QjihK1adarH/u1C2
QpC3XSnUoNGaTs7OIfoY+4IWadkkve3Gp3M1oUgPAmIX9aQJeEWw34vO6MpPXwFg+ndk9wdn
R0Bw4wnFEWOYYVCvjs1mXjWNmsS/zf5iCs3OZTI6QjGfbEbsbaujlQQ17n5Fga5xoc2cvjip
oGccBs5PYAP+qei9U1wDHN4R8gsSG+1IAIpsUmZSnaSqQtnrXRZyrnU90oq+lV28tCOLue5F
GkeAFJext/GAtJ7HLdlhL4eTIE8zXEHmc32whpyf1aml04BwVuA4tf9MKie1QXKhCYrvqvAP
jekvm6tZTDBx4eoJYFExRahGS7gjbfnHc7q63z5iWm8uv2UKUyvWCW63VQEr+HNzm6MuBICB
H2jiHfgtjsyf7LIZ5Qjy7KB8RG7BmUVyqkKnzaJkNfEJ9t4FOc42lau9kEaFZdV5CDByhV16
c/6e3SsNc9HnfoCpnrjGzImXuu1BhqSFXDd8mmnPi0/NqwPeAIJEE+eBWZ1H51012B5BKFwG
wB/mdgWilRG90Ez383a9b/PfEIebAZkJpe+GAtqmsgBxNNYymZbmQ6CFYd8Po95GAN8q1kSY
dSA3D98KD5kx90JtAsWQAONWmn6zfKbOXXXsDG2Jq8MpUGIf8pdfKTQBlve0FQO8a4uI/jHL
VEFYXJpe2h/ieZiEUfmPoWDRhn/hdt33H6UKd3mTGOyH3rw7YDEtXlud2XWH2DdqJGfwHzmQ
sYxEG8tYonPGlJJ/X0bUJuIUu+LbB2x0Mg5Ck6c1FuJ4kz87GW/DWdu5DAta/jijlmo+8od8
SXhJ50rGP4Fn3b37yf/r1++wIQqmEgWPvwep579qG9ZHV4tneslyng/o9v/iOiRISuMKxpSK
1za2z+ZaeqjH57D93UUxDuah/mmPwNX0Mf3AxUvYwyjDp+BZn1sjx0u0U5xA3Sx8F0ENaxBo
rgPB0060HUNjbMAwKyNELqH8Hpb6PjcNKR56LoBmS0pdMlQkC/R7oUWJe3UScCMKMZouLdi7
7v97CzspkkwlaQpSa+WvSKQLr3Ijr4p/0cU6JHsjp9ZXQbw6sRTB7aKidZKEguSlxo6VYmvZ
0am717S3SZXrXIF0Ly72NldSAPoZdYJ6VHGikpgqTfigM8MHFF7inMwvXYdkwk6tmwqp//61
kPLVxRufgzmA40Frw4wG1/8HGQjAhNR+vxM4mLU/7QBHAvTTobUGDF2VGkny9TcuBEISCn4p
ZJWDADc5hJbarOrQNEtIJ/C2xH/ylItO9mzF80ZLzptm0WucCQV2Lsp+/A1KLC0sVs91ealN
v8VgGhcKIxItI26Do+gHp68+qIy+nLBOV1mQpfv0kk7GpvpEyP8QeXb3edNeDlqCGOQSWElG
E8c4UbC+9tdb2plBmgWAYodKGhOz5TsJ54NdHSkyToaXU0wXzF8i1IGjsjUzoRqDwWTkvKIh
UcGSUwKYh8sipao/NyXeP1YoeRmG0iJVsgPj3agai4sLSMsLQZClC9DMZbHmtgYN+C9UcF7w
CfFZsTMkXn3uCnXN61T5eptkWTFmF8/jEIQeTTemC25mcynWylR36/M0QHQ/A9/2LzjoXBEe
rfqt5Bo59a/DSKZefaBc02B3e1SDcFcv6tI3cjYLyM3KPWGCStgJDqwWCPsZpz0Qed89ZhTh
cSUwrTSBNSdf7YyJqx22sp9kDY2CaFZzI/VQ14SIlHLpOV2IVVkf2c4ub2sL7uG5SDuCBkkx
L8ztE8EcgXYNFlQOfl/X3PkUchkDlkvii6yDkVOBnyGpTYjsd5dpdF4Kj7CYRrVqq2V9PulC
bZGOFOO1xV5A4DPB6+5te6/ZJGTQrXkoOqCg9S2gOaug1TlynVp2lRh386ZZMisHipSiM/96
Jl+E3O/9OlGEhNZlyd8hJs16eBZETV0JFwTTRS7TDlec8gCUc43YrX6lsqDFY4KoEUJBU38J
UQOnBoYa02WFLvkmZreJTSy8Jctt42ihoqgGqnTyE+OTaSnGMZ8rTlMvn5KCifTpxWkhoeIN
H/Rk5FSbdsETTs6rLjy2QKapELxZAiPeO2VOAj/mE+LIhqkb61Svk8scYVWps98y5kdal0I0
KEn2OwSrnkdQV5Cz/343Hv+nvSCG9o2Y/fh9+SXqqm6j0dL1tsYuklE3TCdxxa8bT05ikCHL
fYlqrz3nUd7yZMimLh0eQjaJ7E/Zm424/ekHGffkoUzpq6/4/Wrqtrzu9RSCPGfg4yWR7AlL
91cVu14kG2wSm5H1LfutblZjoWVhtwYc7jC2ks8z+w9Nf3uKaz/ldfVJupW2YKDOOdBkPIDN
PGllyb/cXJVxWRtzADtKa/Ftrj19TjHiVjAUivWXOb/BKu6e/S+Ss+lDbWI2NGIjilfUI5Mh
P7B23JdRrVRB4zok8vDIwm3Wl49Yxagj5pveNTIz4fMZydJhCN+X+P0aTSVs71HnOJRSeMzd
aaoaLRJ5bNDWvxdunYOy1yjQuglPeSVyBxUH5aQMbGoUMnJjCRcr5WLnApaNNGp9yoSxGFgy
k+ZsFD/LNPeABSM87JJXkQen0agxlXL5UV924amQMeD48cwQ5os4I0X5amIk69BxpvZOEAkn
cx68SgrQknSUoVqsE6ku+vm6qJDsUK0JWQPcyweMNX6trz3ySgfVBEjNwkH3dG45nvzHTX+9
cx4TmCjXkucY3bF+dCtwecCCw1FZM4nD/mirHW5t+UrktbUqUNTTeOSrxLITU8o7TEAwUdAX
RADr9iQbQt19XfifCMYW3LR8a5O5T+3xbkfMBvoHEQ6mRwOK+RTTQOM9ydUJMXNMa4YL3Bot
uHV1XxTwUZKu0opTv/fYCXlHRVzhbM0HdJjh6JhcFas+D7dthCTKzF1g7FH9NWmSjOuZyBL6
DYBWcu6S1KDQ/kYKF+aTMMQyHbJZHALL6Ya9VsIVFGiq1lKQ2dGAlALllWK6PNVGApJmKk4O
MH5zTsf2Il44SCvw2aEr6uKdvzTDY618PDee7ermgxnwP2rMk8K52Hv/2znA/KTxjPBUesyd
f7DcMfJdho22pcQ7K/egjdwvI0gMRltm3t6jUpvjbk1+iC2RChjc+s9Y4VUMR/C4k5Rhfeye
LHcprtdXPse3xpWjMGT1ZtFlLbuM5/5g5U1ORAId+BrZqG+YoB4VrNmKq2th01o7qkQCtkDy
QN8vCrO4aHoto9cTaDZ2mFBFLMjUbcJkUqrgNAXLVyzM3bYiunofl8Aqb+leWYHf7Eww+xSZ
R1Lah988NEfLO4lbSyIYRwkOgglbjtfrUpbKu1h6sIKceiFaRWmu1PGP+mqXXurm+eatF8NL
Ev/TVgjFtpTThoubbpH/yHzMOtYILJ70Dl2EKBv5Azs09YgABIIPDcrY1vnAsc4R9232kEWz
kwVSgaXBP52vTh8o42voQfbqY6z6mlIalUINjosw7kpXOcozunvNUUa8e6hIPPznmfPjwxTx
djVoLT1/D3VmY7M91p78XgG19eKhJvfUlSacpARqTN0pv4ayYuMfiOs5K3Lrqwu+Zd2/5qBb
sS7794rBM6DKfnIaB9tiPmlXwjJT4WjqmJet0og5F1SAiq51RUEWeU0O5GUw5zU0VD4qP6D1
LMD3WbRBQoArBy2yNwRGb934Z2AbFPKWs5Rzs1f0bTheIHFc8pQgIX5fAAVK3xya2ot89HMn
iN6aoiHggyhgyAtgcHUqKwWSEcUzqk3L8qcxNppRYGjC35ARaRDzTPnouaync62YTsv1/xwX
snfEKQX9U0K+4dQQYglHfOo+jh26bWqBCgAm2s4MI6c0ImXMz3LE3PuzC18ZcGGTNAP+dBSz
IrAQQL0dcF6GDyTt0wZ+vAOYimkGFTQmQM2T6zntheeU429HH0krthN1vofuo5Asn7A3ohQX
KARkVrKPyQq7hkKYQGtyuB8kY4qyMmmJBJtb39EK/3FlpFjnqCNL5J0ZeoRN6f4CLpsdMERE
Rhrn1kqktVGkrd4bzsEHI+hjvHcPAgGcK1aUZ2GRhPXVffm1hKzqxWmZm19sFYlr6HCCGxxb
ZhS1bFUuXJjcxk/fS8BP4KA+w6F+dOh40ME1tym6xlbVbmzEHCRkGNrZDF0xpnzcZGiRR4RQ
0GHNovsuwHmzLHZVhH6zuq1fVEtc1HXZbR381Xg7fGHwO1MsxADLotXPGX/+/IdRJqXNpy6X
YpPtjXw6IpCiAZ1MS2j20VLyogXjmKbB8zubyAe2yVlzSX6iuA+Hy3vrOk1pRtQCuPz9KTI4
4YgmoFyhiCCbdUWcYMM6QMdK4JCX9ZgwzcfFcbkLJCNhA/pYtaDDMN2ptgRu5XSRvxh3/Bij
l1yHifeAtDql8MdYr24Vl8dwK8ki3hEAsS8qYHH9mHK3qQFMfUexIL3ywtn7CIzT1/skRA8a
5KooB+0Z6ns+sVOfJWdJD/lB47FTBEgROWBieVWQrTKOXriTZom7gN7LzbrxLoMSBE7Lmmt8
4bpnAPBLghOey+sIWGGdMv6Z/tdN+JZflTFU5M70EG9scO3AeMmGHaz6bhCqGFrxhcn7dwv1
vD4DfZQtJcERtcOwcc2K7++Vwo29jVSP0Nnm6EJZ4ei6JiAuXnhLOnCzTtly6rWpgOWHQwAj
039UhXzHXhWiNLSYZCenJWgfiDNOwajWhQtfGCOJFpp7UHDj1qeY/uwlwtEK7aKt0FF1q9z9
N3dwNwoWBPBz47xNUT6kzPcBW6OwHsAY7MTa4BHnUHwCWFrxlctGAkY2Nvt+kUhWx3a6BqiK
HNnu1en6Y1reJpHuOZye1epaLqiQIk87JUrMkuDwh7MJ6dQXvxWGYdcS6UjLmGcUOrnshLru
VX+GHvwb78Ex97YyM2T3rEpvOHctybG4ZMEVrPLq9YpR1ktWYB1TrynniUsu5p9oq9Ewo20t
OjGyCiDWwgR1uPe82Xu8H9Ly07JvZkyYll8hWslhbR/B3Lb0zxk9mOCq0kGM4mAbdbf1oMRZ
2D+vNbEVgWQWcH5oJpu6I8qMGLASXYGkLATjNrTIQ9mwdUYlqw4MAu/Qixubgeg5kraMEDCg
z4FGVAbA8LoTwPf1EqGlsFf9Z1Diajqd2Li45HcLQ0jXyiIZ+853UZPTaRIFk5n+JeZh/4zq
k9gXGnPg6ewpdiW6eelU/ERElDeMcjoYYYP5kbpyzylnxWE4IQZ9SC7oNDuc1+E6SwqsHhA2
mMGcqATpDA7QUdJR41INeHuzUjD5VZLbZkFiFObSFG2xN78YuHTM4e7F9odcSHDllUiPWEmg
hM0AfMGRIunCLKNn6GPsD9wyKgu9aYeFEdMrPMTkgL4ITV13EnScAQglLbPV2+x6t68ijuUE
reA6ZcRmJa/+y7rV7+N96CaQx8r3UwcAQip2vPHTY3KvlUZrwdpSQzlQZupS0eiFLonn1M2y
F7zzHxW7v2rfJ2e1fvlOo7HSYYyOO2+WGb6UrgkrSgqNDHmah7Vc+tr6l1A/je8pOmfprBBD
UiF4My90gs5O1dy/zDHQyLL1WBGmI0Vlb6JnRlMPvg1oXWWX1uXm7YVTqKRZRRtecNo5fiUo
BuiMiR84Dw+6/OiP82fJ2UnYUXRuM4KjLcnqWHOgPAcMfsxMZEqUs/bxmPzL3mVrEAsXA91w
y7wr/QWJL2il3l30Wf+L0AZSYZJG4KayXsXjdjn/UkbMuTwYNOJZSzB9B0kNexIw3yIvNp5D
ELR6MfXH/ImKEOvT3dUkJjBLSWqmJaBcPvZhYNKKdcCklPwkioVibdQ/1hpS/eJzpbigCBTP
I76R2l3BioVZNJWGLdpxEhVUj8GC3Pii0aKUrqnXl8hE7agqmmlUOZ5xMGNCxxwA4+KJ1Aar
EqjwqsKuB9wH37glHR0XWBkaVV9TuXB/e4SJHaJ//58VPI5GEYUlwio2U9woOENUebh1eWFN
emHh20tl8yv+LdW+B/diLDHc3anNjNeijoTv4aF8fnBaygr6RxtDnAcjykPqK2jlnh9JAGBy
9IPtUviwCt/NT4syTTWeWHyoTfXTlyDcpCtzsA5zqePLlWpd7+shCRPmMIJ/cWVxDuoyUgYu
MkASbjhkQovjiJ0muYpZRzreB4gwh832cmZIuCgu3x7aHJm0QJHdS1qpAAbFnWv/JRRQN5Q5
H57xDoE9uCRxasr+Ni2fgrl+WFS+Uyf8ZULelVgX75VTZOhRblQETSbc3QvAR4KbaVqlQCqn
NDmbaIhrBwOWd+PHfhG2JowNU7EcgSbySO6uA8kgEYNPMC0jntgG5FycvsG2eVB4McGMyosT
nnFA56qYJwniP6x0IqMUzdOfjTbar3RBloZrHikNVpHqZRtMq6cdz39lqrCyQSrCm/pNZ8Ce
38g2IRgLxU2Jod+ToXLWpQ/Putad656Pc8ve4zxNNJInRdvfXX62OdeidgbSSNrQFfXHifyq
ZLb+gSnm+joyUFCOoPWb+KyEn4w4LLijjLL6ZMsGefZERqdaYffVpcYEJWaW2TYeZmnkbcfT
x2Q6A7l4uivnaB5BTB5lIoc6qziKkaqYPC34VRHh2SlJJA3S8DiD3o4Wm1EDUVL6yU46QR1W
8IarIvic63wrBBt7ydY0pBMw6bGQhHDi3NQqnTG8n5wSOdTuZh1EXOqrKyQOR05kJIuw/tkt
YMNFz6BJTO6w+QOmMzmgSw8UxGih7tqGT7lH4sH+QFSR84dJ5y/IyUnaF3apOkoch+zlNRkf
gHLW7wTVqV/UprQAv1vAI2Rz0c1QskqvC9nNznFoMvx+1AxkLmpt/P49pXhLYp+p2J7nB4Tc
GnfaZaJwWroD75ZV8AhmxokS1OEnE3R5Fi59u+XrS33xJj+fcvz19MGp8ZAk+iNiLo/SxQ31
9XdF0I+23Q6r2I59PI0dJd7UXdO7FO4GsUCuepN+8tOZHK/08vgzR0s025WufKlznq7cWp6a
XWvbS6DXHgdQevSWRNSHzYPAMqQTQ5ws9wIFMOu3IIeLk1o/7cFqkXRulWZd0E3Iio9f25f/
wHbg707qI7H0xWR952oNaGpSu9SD4Bn1MWj6bSENu+ulQwJHVA5avn925q1Rmwt7FMfsmRzc
wrgOWeDiPjzd+vu3UE4vZ4xLLfuedxKOS76FAfFbDYYI4OHvO2S2QRhmGobY81uUiSAAmYgQ
/fxYVBw2WZb67qkO122uOa21a1Z90Ibd+7+MK982iWC1THYlURcZO1GbKM1K6mSQW04XxUvI
cc3CwPv7KtfYYIh9igwq7XvKKL1m7mwV3cqrOuwYd1eQjNte2Pw72RHvtDucOgy7ZvD0HmGY
Fw39Z09Wyhk51Q1JR7wKy2KCo5B5n+o4rORSF/3g0bSjYPJrkiouu+1ndAGzseuhoIGAqknj
mKSTlxVyDzUEQFXL/2+BRKXHD95ByrYZxAgysFzS/qdw+ugstPORXqsoa/jCk05wPQdSlD+j
G8iAe0mxtliJhT8U67m6Pv0dcERiKm9/yBdl6odMa6xWLJ9yDDljjhHk/u7JE6qlUIbUrRQU
SjidPc4W/Ry2s1vFjqdyybyZutqMlogqxYr+3nUEWG/rYcWjNco6sA3xPteuw4wr1LjY5VmH
tyvBMCSM9VusjIDF03PFhouTJRGLGFsIg5BD5HeYrw/Uyo21iorDm/iyZadg3ZH5bkJKk6Mo
18cOpEMhqomslIWYHeiXE7SV7pmetnKzuJyiLaUttwAF1DLbbNI4YnM23t0CbL003R+K13oT
jr55h2G3K2SUkyshNTPQhrch/bGRnR6yUY/GsliSeJk3HFnzBton1rH8azWz8+Q6AybGih8G
FGt7FVx4q3+lUvIlEIoC9DNDTTb4A8Ap09Yz/UsUaRqCARMF9WXt8C/WpWaDsh4NvpEY3Y1a
VcZJSfLdoKMylbCjUPw2gmP6z5sCRtx9ezNMrXyw5Jr9Qn9JVXMTcN7eqrKYjVWa/NlaYVn7
8kkP/ZwENagQfHK0h07igyJtrkJLftQNc6XcJc0J0qvkO4RwgBruW9W0vuurmAKAarjRlJVU
TJNSqWpoWiwbToyp9xMV6rfrZdopsMOkmv8atvNKki/RMjtSb9G1p8B242ZdhSIet38ukUFl
u5ni2FNqc88tRUSITs27nvhDPdYmAcRLjo2XueEWt2DVITRyp9J6rDaZVPTohUUDqMT1pFDl
Zd8fBvMeB2qFFK4E1Yrhuo5D5Nt1CtqIICg0sEwjnbvxWZCPVKK7v8dJTz0xxQMjpA9cpC4j
mWQndesATPtikjwrVEbiQrhUm0k4BC4UNt049nWmjGKUNIMB1tfzzrk7KhHavVEZEEdFdafe
93L2ZNvA1MiIO8Pb/DhevBxAS4HtWEUHdGYlFbuGQCqQKjY/tHk9D4bRp/0g80v/C/r3EhHz
lwLO3xi4FBiBLsawYM/X+V2jsWQxTmETeDG9RMCoWP7/uxnS4bHIftEg3qipeiV0MBEu7fnn
DCGm8eCNN178q0Xp+kiHo4cZy5X4SfP50W38flRq9uOJy2F+i73+A2z29VHbhMJpBCf2sJgw
3udsQ9wXIWp173elZ/vqvatk4btm09yt+L4/rjeYeiAvVzlNAdRw+eus1Ywcwd3pcYsgqsdo
wOutp3ub3v3j4HPEFO8hJ4xnwh2Uf1O5NQRi+Xhx0PFghovRQlhjHequW65VvY6z6quoqms8
0R0BX6UZfm8aanE3AbeFrYRiZlxJXo2lJ5YEYhWYnWcs/UD4OWcIpdOMIvsfgqHT786mHhrb
XgyInE+FUyByukkY53BYeCRexDAhksRSFHZCZJu3Z0FRa1FptRoY5esKCXbPBuiJLdi/l6dG
UuUWylSn7bs7C5xJ8XQiZf4PvC+9GdBruK4MkGK9241/mR73WrsNjcXg//ghRzMNoYhR4qj7
49wAhDAtkSlpq82W1TgMDJJeplD4UvStx3L8lC20wB/HZjCaGl1r72ykeEQSBjTdzdlwtYPr
9GLS0z94KizvhXLtrxIaYlALNJwag3CCR5qthUHYxj7BAUO5ijs1YoyV7kuxzg6x1p3jMGZZ
7nbVtL7nt/mWQ/fGxxy71nPYpA7JJXxdP+o/DCMtw+79Z2K6UKWjyQSwIEoeNrzdqHqu09I0
zwMPuiybwBZ3yAM9o4im+klNwj1KobYDjrj1yCqPyh2a4rnt6ZcOehF19BDjMXfPWbvPQT+0
83G7F3Th1RzqaVIRjQZYvtFHFIripumG8LjIPw2D7kPYvSYCh7vRItbobIUaI/2R6gTcVPGS
AUxhVVYft0TqWAIUzgX7JLKfQ7jtjD/y5iGg0UnqjTnMgj/dJD4Lnc09QIz3COjMUdw/efRr
ntWqv4yGbaLRFtjPQe0qF5SR38jU40mBYpujET8XoWf20jJ85AymOngzNBWX5IPNRBWvDmiH
lRWkYeAnR1SuFQJGDv32tOy7lbEyWzs0vcDs54BByjsBUEuG32/NPw99d2OSpgOSwAOzjJr7
ndmP6+aNy600j6jfqb3RV649METigieWT1iOkDtzCweoWga6A0JumF6ddSCgAfWeNAw6k8If
x9gmsN1L9HH80loYEP/TvA/xPEdH9AFut5rUdMkxk+DpSvt+5lYmmed/ekBY/a6egzl5fu2X
AKeOPr5neP/mXQjDQiazuvvzOLLZRcnzCoc4mpf/0a16s7xsNNrP/Mf8KPArZMBQL9Et5BZ9
/ilHY/LOejcd795U2NI9/EjeVxefh6XOnVs5s4E2AudEjN/WLyc6BBwpTFc8zRGt7PD5jz07
20UzgUQYmFc/Y760oLJwsytNdVQJutkjb9cm7xiA6wb75illVGTdtl0BqibDI83Pm0ALpUY9
BbWCPdF7lX7lMjd7EQjgu4eegCUVaooV/o2aBFuivrt4+orRlvSbtuASFUkd+Tvl2E1H8u9Y
w/lq1laWgbm3pDmwkpQgvXANeA+vDEySUUYJq1gOWmMSawNh/XZw+zIJVUzxb2BFqI1kvyYO
4ERNzgZv9u5Z+50Cty1bcYae0VuVMhbTYBMJlldbci26v4pK+4UcTdUD20QgZBmmZFYX7MNE
AAAgftWr0BYL2ZHlgbalYuSi11ss0bsf0cYaPBScFMZa2R+FLYFk4A5G55SOSzAndAzGrZZo
m/QQtFdtD87s78qll1T4ytYMVA5XBxBdKl06a/vL0RInUVUh95Yc4++5MgLaPikcVsVz1Fqd
iz01ZkluJodA/wi3muYHxxIj1b6ZzovJpjaQED7h0dqtv/wy2EJUN/lzbotdyMIhnfr6Gu08
ciz0s3Cs/5xOeKHAU8VoecGhwQQusqMBAnAAXVy53Q05Z1k1MBDZ/7Qi0OuPkob2qW29d6T0
VmMiCopa/lSM9GThuwuoxOr8dd6a7rWR3kqpQ5owrEahyrg0JoR+LyLqx1RSiqOghedteHaY
86sxeSgS0u87+hWJHGkyUMwdzxHG6woqZBQKEOnMbJ4dlwoYeXBdwG6JtgM1zL0+nY4wDUFB
1vggYk40QwaKDxkpm37nn8B1BADBj02k8YIbMUM1Q+RekbNQuDOQ1Y2si5scne2Gb4ATFXtT
SZ5ACFAimXSWdVxxYxe2ilk538OcVECIMGoyEw6HssfhlttME0EOghI6L2PCtHHTQePBc0/v
FGqycdi1EYfw1CYfO2buQGdw4y/5FlR6hY+/31zcpBo06xiq+bqj0irLkYd7Nl3Q1w2da7Hp
w1oMMpWcNKEwvNe7rbOTD7eekVru9zCZjGg/EJOQ+He3A6ucJg3iN17Iesh5fDf9AzqVQB4e
A4Xatz2Am8FNfmS+w8hGadwEi78hDdPpwT7teaW0GFnomT1Pv5pGS5ifrhsbooCHewUMcpVx
t5u+PHgOb7FdTuD+hi93l4ief2HKpfR8kG6BC56DpeKkpFMDkZMzy4kV8llSMV8quciyDKLy
fUTgn/v5BWCkLLqBEaGkSgiLuFOrmhrXlQJYcckbC5FcavQAEoFh2WqAZOgxd6A10tEtFWbQ
F9SIC+hyAh3ujjSdtjuQvaK1kLsB0OpfguBpYFRMylBdedJ5So41o+J8eEObee00s77S+PZm
3A06hKTMx0zu0iYvwzoT+KWMhE2xQ8WNgu2AbNb9wxul8i6Lih7tz3FFo12CCEPbbBEurpv9
56ZY81YLWOD35u33NHXrW0oLGmnmxbqCHdNg4G+majMhCzeWUAA7Vz42EFjVIIk14lLFoZU6
Mty378WkIlW+zo+1ZWJP88v+DXotmY2gsJ5HqAVVqTl1ic3XOGVGZ155sc/RElbXFswtoxt8
IRotIgAtYtD0jfyc3L4J+ioVFKZ8grTKSVUFgqW6orCtr+Ne5eEYy5M1+qOthLgC8vXwEEYX
aQVdtaVjN7+GMvMT5RLGJ5n862C5G5C561+y5rec/rkj/2mOfdoQgC2U0NFxQ9k/b4Z7obPy
vDVE/nK8GhLxKoRZa01x6HSOuiFLYAQb4vz/t1Bs7vZEK+qOqeLAKFSW3SDI/UqLrTVvRH5d
nUzz3IajrKZ0JGgtDwf0vlWqSNBK84ozvlqWWLn8JEoJMwJzGrOKrHcj2VqGdFdhYBp0wrC8
gdPmywMRdPauDDGHUcsQPAtVXLsyhaxasiU6cx+GlsDllfAF/8fRAlJ0Jn2N2xGHj7qvGbEO
4RM5DDCf+RVCp7siRZ2GVb3ljQg1Ql5FIqTXJPJzMLBWgOb7DrzVzOhuL4JOuhlOqIsUu2MZ
Olr7oPtZ53/DPVDnAzAR8CHOSzyT1pU76ncKrIxqTJlVxXrvUh7WXfCVf+hM+CFXPvmzk9R0
tnqOLPG8yvJArHBvFl6pWmJtCPQxnPOJmbUMR2FCnL8kUsfiSTTabBoj29vz73ZOqinasdQQ
OxsKHHJuAYiXCW6LZKICYXrqCISWkybq3QtHaRIHWwm2eVc7NyiboJsFMl9iow+aPiyJe8dY
kKAeuBUgy4r6hmyv69JD14byl0EH82SpTw3DzFWE4o/F6Ui0L412YcX8HIQDe2PKL9D6LeJR
F8F2EFLIgckMwNU/8pMnvq1cIvpX1fpifSnQhPONGDSHjyrIcWYhLKOiJp2mUaqmdXDlATPG
4uTsp/A6gyjoimCXFdEVN1Q8E9NeozOOLT4OYqffDV6H1aZVOOzP/pMXn96Du7CfpPdgtg39
Jr1MWQ9bQJVe1LBq48ThfQZFmKwJl8DsqCGPe9NyozpojQl9wZknYPs4WCQUG1OsRJ5dBp8o
59r9TmEvlTav3H/w8MG3NxUtUPdbFLUl8jYJEtOag9KS0JxXUNvNcXyLFaJw8krJJ+yFtNh1
5oxPOozkR7PKBsrEfSacMEOtLozE3CNLZ6rRs/g+wxY3/OX6BumAWVt7DNUlWAHmgeIlVYvI
/SSbpzAbN7VO3BEyH3r3hnK2i/MUyZKdd4U8pqDT81JUil9iGhUeIIamLXOojRykoe2JAim6
iAM7W5jXAn2pQHyEKNG72ZOqQoqbBE79pfVY4wooIB+8DzwkbbKexsKal24o5+xGTeYCO6j6
aHF/UjzQ7QNAr7yP0gASAKSsQQRVMIAaOc79T3q1Gg4ro9y5dtAZSZDm3fV6X1BctJ5H4cS6
oiEYDNhv4qTHAzmDabSeH9erJxoW21w1SNE5GPJlKKjmrLXEoJkoDz2DO6A5XWcLhgQVvrjj
l5NyVHkdL52iOjlq19AyeAWCycoTyKKWAaRFNXUkdcIg4QTLVg4EyFo7E2BVNw4Wj0hG3yaw
3qDHXOLpsSZIDkZj5KP9NHKCr8T8nXcpqK1iahwQFHmiS/EMXFLK5AiO/MrLBL8ECxPr7Lo5
Z5oNzZd2TBaEOePj8bFVdG3phDkE16gKZS+K/H8F6FYr9FUt8+a0F+OQAErzdSw6Po8Yg32J
dpH7nHnGYuhyGZ3QPOJnlzOobj4IyPlCm+XnaUKwY+mNL4Chd1ULCaEMtMTYd+l+dQjh2Iv1
xulCMoc72qU+MUPkKpIoXFiwEEYYn7Zp9T+9fyYGdDa44eXYyM06Pydty7kweb/CDufaDr5L
M4hZiSFny8gpFBhSXAarTBWBWg2vxu0FEptTm9QSV8nkU/zt00HQUSah8OxmCg5PavqFJ3y3
Qt0R515aXtKCbB0FQS2I/bmgXJE5rCcSIoRr6fHYVsLRjyCkdhwYga8BwqISAfNTJa0o9N6h
ve4Qva4xoRGLtDT0bHqTkxUze2eTcDqfiNFExzXGitt/UudUIOcfdTf917kzaih3QBTpzsQq
PqHbHjb1eegrbYeshbQn4gsruaS6FjqHkhROvKhZ3j6ecoIrVCBnQNJFSJ90dKUlyZMIkmE/
naw0tPAmBkHx+M2r/nFaxwBH1eb7FVym4H+yMLGe5qdB6+dNuVR7dRjG55gDx/Mc8Hqz0zFQ
yHVPpeFJyiWVH9SbcpP9jcZKkZn792MbVne+lmEsNUABpWm+PtnEfpYJEObvM9rzKstNcDPm
1sDD98dNCWYijwjCEV3dMZIMVNYFZnHbpuCzm8urpEOiX2CFXUCYdHdXJq34PRQPVWBUMnQV
aGalSSJ4Vmx/1RR39jgcmbkwHqWkzXPXKfUej7/sB1uh1AhP1znM1RPsDA9nTYTdT5lFiSFC
j76cKo9+ZcVgQSXpNq+tcR2urP3ZYYQfpM6SufIFye7u1unWcef0b9V0xVD+Nu4HrCcW42AB
8fhJqPyb8fZTYnpfoEVJNVeANuwZTOGfs5xT+SREcXETVCF1+lJsiam1xdu6HPN9yTvXajrR
iX3F/x3XGcoq+N5sdGCwOiUSumfR5hj0R7D4umjf/nnQBnzBxDSoeAMlEAG4pDRnN0YmaNfb
t7JB40H/P95mY+x081CQtqtXgdzPOj6EJE1X+F+PJwjM59qiE8cjy7hyupq/0iqccnFXR6dq
f5Lrjvj1RGusktMv4qh+F4trRF6/5ACatHRE54iQ4NME+QIr1U48zZa1/kS83R34WVJsyYa4
h3JrB838BwYhzNYNaGdogSfzqcp3xVE6mBtEQ0ltF4F1H9DSN1PntWkVtLcncGvsVjxanTB+
D/h3gD8WqejbdwYCYe2rjqzMiplFDTsw1yIL7hTLRQWSCpTs/YN9IzDSRq0lSo/kOMJf2zJC
qk55Nh8Hl0Lm1C+xpfvW7Yl63zluwPYB0T2awUYyOMcaS1Bu2bqsn1B0T0cmomQdH1EOLij9
iNx4N0IUW9+a1STfs8cjLGXREghgaiDH39QGkXHQu015Kq1ISO9bhgAVo65mxHn9t9WUIu66
u70K0ifEMy5tT4XeBCK+X4qCqUi6wVZQv5gqtXQGXIcOa8cxVWvZT9ZIwJGmjYmm2Q+9cCri
GNnD8DTbNn55rdjjuEkWrYNFlCHeIk9nwL7slP/ynBeTB9suCBkk3JuxMlTW5hr6j77bRwqy
Qn2hUtv0SaSA/ewaBMtZsD6XC1UTtAsJ8eWsLiDvySVH5I9xmPPNyFM1pccaPr5TNFYxCA/x
Q5C0zRsoVPITrV1vwjyK9gJzN+7zfOQv6kiDfc+uywaZuOGBtXYAS7wmKfEWjnn+kxXzISyU
JffztZfUEp1wIoIDH5y4/0h2Zd3Vw4fNEUJ4p0Bwk179k52boJlQGox+Tx+zzwFniUKO++gs
q+7AuTaa9QWB4558rNKp7inr37iCTYRABMS9qAbWbjt21UKJ6JUQbNChaOMP3YVnJnXPXesj
KgzYO7+TrvNVzLcpnaN5zgjUnrCqin98XKkwGWgRjJxZ8vbt9vWGvezuNq5uu9Q2GUm1h8VH
7qdQdBtP1ucKFncJLkdtObQ4AT/eilP+ns3s2l8wBEoooc47pCMW9KpoGjihUUxur2ZcmieB
cNp6HaAsA1tLdaoGOQfxaDObPu4RH+AtMQrfYEk1j/lhryHlFAJnpZx8bNl66QcM+L8xPJVh
+olw4v958eTUbnVqmdi/XilHBolSfGT+BhBmT71T2PB61X/jp2RLdG5AJSv667lQ5Cs1nld8
a7Ia4LRTDs29lwqUDemIAphu0klsfzPl5UAs2UdWYWnGtue/q4twS6W0Ui0iBiDSqzMZbSbN
4fb3E0qKVg3NlcrIwS5uIsJSrAG2AhWGvy8Jel3t+dj9uwQbDI90f1H9YdRXrClYg6P4JRxQ
r5qo79djz07+/MsuGwEgwOdq1yp9yakmsc1Q5Hbl5tdU8V3dMrDWLUPUqb6s+z5gKS46Ou9w
2Ity7qp6X4yMbdJE2NrCkEPbDeXLOXPmDZuyl0BJ/aEN+gXJe9jsI72bVpm8aQFVNZma42/M
Lod4N/zRqBcvu42PSWwtwT40b88TYMt2nlSjQX49KA96FFRlQdzeok4W3Sqth5t3uHe3jMzU
CvbYmVB8EHVYOJq0HH5eD37nNGBKxbLn+qlLfgsg4T9le3utMG7HagZYeZ/9FcIqBH3yXXLD
VZWnMSdopaCGzvvmXg/7kKzy4m00GxdTKUbMiNhqq60ZqaKFEhIrc9yPD+R7pOHOH1w8deVm
/q7f6OuWj2b8PjFpP+yriZkoG60F/Ueljmw9v8SnYncsZaYTc9z1f9uuDBdajpm8EiMhPBZP
FJ0vDgVs8yd173pNtpY0m63eTQLvgqA6W2np7poNuUU4Sdy8p36hZh4ONpIYdDh1nPavIh2S
8fCkSQwb8v6LZQ0WzPwecWMsEb2O75N6pUxHA2g8E4AIfiDQ7qxsfXR7l7ZWvHdaKZ6y8Ohy
ROP486EwhuYC8Z+1+q4ctssB0erMkgmYZp/n0vIjIqZu9nS8MDvrSJcmupL/Cg2dYZAbe19a
k97ZX/8H5N6wuoJYbkV/i8SOKHZVfHXGm+nnULKmkoGWZdeEf1xlKoCwrhRLebV0IrrU4Jp4
6OaRH3CIe26/b64UXPSZcoqJ9Yw1YEeKpHHgZ0idV5QwF1sUzr39X6jdHbWDLTdon35wYUyj
xGdrUgWPCot1YrME4kGCy+sn94A8yLayurWPY+Fts6ji9ja2kITTxJtHfS1ZXsgw2vl9y+41
ZtOpbuFkvAn1m6gcKwxJXtWea1Jpl8Awyu6RbYzlFwUf8Mr82555f7K9gQ6HxtP0TJdCkCPE
z99RImcQJjC/w0SHP93HuZFHTgiz9Dg97KZsT06mioSggmmoqfDxz3HuAGLlwUs0CkqIuzcz
wonI42Jrt/A4Shm5plAq+UxZ69qwSk5wf61VPuAM5Iv1xRCGpNW7TlS7hjQgOpIu23pXtv+n
E61//KJ9xO379/yQ4I9+j87UdSt2/eX0rR3lELABskp65x4jo9yR/MF2BlMmwQM5agn1UoXf
JRHlHUyq6ebRZVZYj19D831zgquEg9XZH48xASM2suE1Rj7w/Tv/JG+B1TjUrYYAYXCyHc/2
euaJcNEg45PG02sMV8Ku6jpzWLA3rJJDTsnBAOOAkp7wGZR/mXestsiMFnS3nKnrwrT7KEFf
bn2x7kAl0wR/oqbeEYbrnJeqGZEJrVA543aDXixKe0tRGWwzIoBXCh4EjF2QpzQRmqxZMQX2
bIeJBxwkMs1DDwfZs7oyUZ34THztsn2YTt/axx+xpfnmlJEaOQzp0lq8SYShIBtpqvkkECAC
hg+HU0+541QsXpRzKZVIpeOBwKppDornOQc9YyhOIpDx5qaUhTx6ymUqAWxMpo/cBo72EBm4
B9Vn306ufNvC5Ekul2xtNc62F4aKalV4OyoylsxVs9PxReA+6tA0fVRVOUgpVXPRhMVJdeC4
5DTTX84cjhGe5vIO68dRfKT+8uK86Wf69PSPXZ+zRqTdGbqCtdezOcZD4PGpU4FyDSYapF8C
KCbxfWYh/TcdoYm+C5evkVNH5e4mAjBLWCv1ecHgc7vN8etJlSwRArBOAk7/b+TVk2GJvUMx
a8DltkrV/I2A/CvnUwKY1gHVBq1GUz3VkupPvfJLFnDB7O5mMRHhaubDFvbl7xBy/4yFPWzL
bAo9o++clFvzCm2ZBXpyLRJbwmuw446ejndQbmTbYW+pwvf+t4fM3V5+gR9x6wTZIQrj3Vgb
djcZM1n+p7n7uQRHUTcWZEkn8cEPtilpb6whwcwWLoT/UDhrKjeUG7f59+WTYNfBI7KZJqyr
OaStSet+abng+WlqPk7okPh6fSsq3Zu8FQcuL0GiWvEuFnrP+FRo3mTwADkEQPNv4neDRtCx
lMJeCOMOAB1nGEx5tSpAfhqOMOjLX8YYH49NfX86/djimTEoA227HKlwRhxIWf8Qzj6WmeMs
nGtg+JFoChlLT2d0crp8+ZSemTvkiVxV39D6toiDGj5XljfCajvGvGnrbld0O8B0QvOr4Lzc
jIcu2CFg07Fy1vzoGfFwWTfACs3TeTOva4ZLGE5RxxFrNGHuZO+ZPxexPi8fhtS0rU8C8fWh
F/fEsf9ddaobpJFFNeRJmVgLPiNT5te6qik/YjU5CwD3MHzR8anWtEfhvfJPsYNOipxnKfb3
mmR/LjCrCjy45uc0258LiK1+D9PTOvVdx+ixrkoeeZ819LPtdq6Lg7Us/om96cA1y/ftt6MR
nFUjGlpfwIT8lhvfxeADTUlIYTH8dbukYydW4UQny+2R4/Kb2tHM4j+qL7f74ElQyEqQx+D9
nlvJEnyxEAGZCmwbP/ZEgg1FNPIBH2L+XZSxQt3fw36dNz0qoSPDRTzN/yC5u9uxd1uuUEfn
RP36aAA6kdNDORGs1byfzxjx3ZjOwbW5ybq3Lb8XWqJFqf3LMZgX8+jYdQnBPFiTsv//Pj5T
HuvoWCl5SC6TG3QT0jsJoEUV/Uq8OOH1ZExcW35w6BCpOUrceQR+M7wPjLwyvBGXcl52oNZn
77f9X5LjOTKYaXyAbCWgCwEdTOxcW1rHxDL4zAIdDC3lBxBKt1PhfUyvcQT/WpNGxiUngLsR
qGqT133E6J2KAa0lBPLF5dh7J6ejYZycVu6a1mA/keeWhUKxjJt8w67hrfbRM6Xn+oQAXmq+
5qoIaCeCFstikEWinVBvcccbkRfV5IpVv1i2uGWmHNBVv4h0GmoxwenDp3y3V9pdSDX2QkL/
VXaDmhAQUKOuPGLKQ/+zNslKWx3xxx30K0CykNGMHgjIqJBI2UrqRdja4tzuP+79NvF4hors
fpFcIvtUTm/8TBXaJhPyKGQ3JhpjxaZ9pd9GremM59XCBvb7wnbmGygj8IfsN8FJYPGrrZhE
vPsLBZkI/TrmZ01JHAARBweRBmDqjWeeCcycYkniWoISYoY3UnOW/QW1UvF+6fCVv++gW1S0
70yZx5Lr1tgtxGtqPh4BCgxSLwyNq1CQUxKbJAcuE8gWw7Vx7Uf36LVNvCQzSRyGkgukMO35
3icQ0OiOL3Hie/HZNcVCQht+ch6eLH/UUVDHIcqhMgduotQAwB/IPKJyoWvOjkPw8+VSmTht
Kxivz32wHZJdftu/5a1I5AQ157VQSO11iR7f9Qjc6n0h7ybwSEyeFOtceNpKqyjt0KCIw88b
3g6UpwDcwK6Ozl6/E0QVMzkk4Hzvd59oyQIGmklGJkSppUWw403F0aU1iI2i2fvL4b9llJqD
RTFmO+4S8z0EL/2M6Nvkm8ClO4bIgbku2RDkos1K1wsLmJGArbIFi8v8LqOHBgMQTiWITaIK
ObaSLYVQro5UuMJuvqI2Pyjd+FyM562BZW4jNtuohphZuyU55dMTwXw75o1tOuSPp8ZlFL3U
wjHrFS17mQ72napK+iGrGrRm5YFewLWxo6CfHcmc4WRZ3JRzfU38sJT1cs6eQ+41K1gY4/oU
tLt3/55miWXdfctav5npNzCmmIYr37KPMzyQCPL5C2Xxp04MGYDqUZUo+tu0jmsou3KP3mkn
aZ/E3M2WTViLQ1G28cyrFtn9U6MYKsqg0iaD+6m8nKWRmYVeNR/St6wSoR+DkQ56CWVx4b7M
8zCKLOT/4uBnV4gj2ejXRgQIcgPM7CbSkUDx5ZHjGh60LVnrlaGAPfsbjFAWh7OcIrh44bRV
FIXCmIhVx8IwjoEQmvgwPua2ArmUTP4SGttaT6CsnuWwjeIUFqCCKNMRsQkZtIXCmJhQxwS+
/h0NpWlAnlcFMvpLoWBSI4e2cWxnXqA4yPgFB2HqFfp7cQf6AkJLVkCLfk2zijJRjnwWUUTs
dGmpjLqlDtF/E6dWZPTeckSemNEIhcTsAoNiue0FioB2bBgPGX83TVihNYd+WYGrPSlY6h1h
3SEPcrnoNgsXPmak9f5KvikNPXRek9AORxfKyvh5m/2maPEK5MMBa+CzQ3HOZVLABz0mDo8U
yd+Ykpq+4fn1COEbOdMiLjo5cVUIQvsrD9TeYjxPThcaJcRpAGW6OJnSphbqONxFWFlFv0tD
MjYqjISVVAmbD45YeCZ1Z0moWU21RULOZtI7JtmFNfJXriGZpZyGpQ6VyJ4CVfHGFLibWmKl
w8nfoaiMQsrJC2kFPkCQM7pdbegqhel1pF5YbTmJMkKJPsTa15+ww4OReNIC73bH4MbAtv/2
+CLLk3mLJLRjfm0ATqovhaQv5dOVzhcgntdrAESZ+JqUzAEIePw3tcbxbHSkVGan71PSE+Cl
Ln5Ciu1gFVYDyqKMhtUVW1cJD++ysXJaL0/svETndK+zzWVXH0kKpmI7d2lMcPMqtxke3DlT
hG7J1OQtiuH7Z9LFHBxAjKUgz+X61FDgemAZGa0XKvhQQiA/HAfSYWodHGjY/+fbsIPAtX8N
fPUdjUM8AiWZSse7c++whhoRVniMwrZmcLq7Tu/7Hnje/wQBHItR1ovvB/TBdy/1Nmoq+/t6
noy0eFhYArlhpvvGhkTLglE6Om+t0+CJLw5wFtix1iRhcCeJ3f3xKGStprUdTOHD7K3OqcEl
CTGklyp52rFnzWdg5z3HzTHKCQxF30nz8l5caHXLado/E8rQOjYnoPljHvZHxo8SzmueX5O6
SuNeskgR46/XwY7WcTvfiGhaZZNrUpu/z5ocn+/idSsSoEFQ5A1xg/BltSHgD/SmB0gc6gRI
LVEXfcHnI0rxvNumhUImH3M4hJK/OFIWTeMJgsrJj3//AlJ0UvSo4q3AZ162L9QG/aYm59SD
go85Eov9SdFUzAXOb/JqS0osQ3+pu7vNIFYjLs4kcoUQyuvzQRXCv6DU2rjM0CZwIjjRWtoU
Z1dzKBmmfoVz2fEBNgNdlOAwpJ+gtcXNdAFF5I2uB/Bic36L86AVSFAz+HoZb4XzQJStVTIW
1zI5BpqeEbcC608XPGhQUOXbyi/k7OwKaw9iRzndZk4Q6YooE2w0BCBJZez4J6Bb6IZaqxxI
EdQrsE/uDnADxkR2mj2aP2nqTe5MUFvlORHO21brpdPUZtlhU0PqqVM+m0ohRb6G4RvjTQ2E
wKTcopSzHatXRZv7O2LmPK0BVxl1zW4YIvgXrPk+379GG8L+V84jWTEypPrNP5K771jA8Ptt
Qb9FxkB6Ry1x9IrHcVQwKOjPlEeL8FK88Lya+vK7p53l11+S/yxVJpuY71HkZVsKFuF9zqNJ
OdwrPsQJLb97D1pqNhl2o27esU88WrPORqCCmDMGhYqbsVmK3c9gpwyOi5EOYolu+TqB0LgK
aBhK2JiJ6uZI3WNVlHOHYo4JlicERDPSB5FIhCb9Z9A1+8CWdE4RcZX8U5Si4/DaRPxaq5A/
6ECevusXzjgDCsAJEd6fkU9lVTvaiUzzqujnmUOVI8dwicjb9uGIhWVHCLCgUFvFtd53zhTA
GqDPtAoRuQvLJADuXRxiyh927Tryw6ib7j/Rhn+2mqivyHL7y4pXEgcreLytmdO8fcM4YqRV
W/pVAB7Qj7SrgkzBwe+UXP+TrRa9NsH894ez/SpWM9f2fNzb9myNaGGWeeN1Fqh6k7bpQMsa
ShgzkAe8Qxet9yY8Bi0HeiMt3XIMsPkliqpYCGujmr72uXaG83mqgKBMOt2MU7VFhDgiIy4C
LL8ie9rKBvxWJ1lfZlP2z3Gd74+LaxucMBsjkwIbUww6FRgwpdewzm0aImSlYLaLumspopOp
ICdOmjErpUBr6iXmk1112iSfLQkmKtLzZ70x8A/4dr1gzpqnZ2SpQ2VvB2Ze6x1H817yp6CE
mkbGny2wYNmgQsSjwN4rVzUamRfAFcE+FC2EJMk+M4kBAYQ8n1od3c31iUt+UX0PYVV+G7Hv
zozTK9SxjlW3Ic+iDU/RThfsJx5P1gR39Cm7Fga/Xbh7IB1TGVw18nUarahms43t9bxQdtak
/ashiGTAPe/2lr925XYOdQuJBbi9zvCj/nwphhaPa7B6ilgzlzZde1Uoe76ivd65SAPHIrkD
GMqVAe9F1QVw8yUBDSk1O1d4JvPS5dU6O0Hf5mecOuToF3IPQdl+LCvXqRFADJoZ/4Pe8dlU
ndpiAJpi50sdxPpDz60geG35ngjBarLSeVRvM47tcExBg5KzKeQQi9+fWt/NZahvMIYk60oc
/Ml8I+V665b0qbXqhQzAOvxrtrGbiBRxkzvTb9XVnpwy38WkzByl0EvY7mikZ10n1fu6IHzK
smrwc2VO/TrmYfK9/TJnrb+hE3JcrsFqZdAQUbSZzr2J8T4aM81trh5qNGui87E1avJr4FMr
mLIJTpMst54UymWjN14XYa5GS9zQymic+ztEFq+/fYW+4SXruAOFfcfPHdOmYMFypoYYgsYL
U2FXnSNs4abA484eqo5+9y1quig/zrlZZiWlxXxQpN6NrNdBCxhW/wYhMuBBzK6GhWGyIo6U
KVNCBg+SG9tInxOB1pmrlnwMer0ZTYqPx4eYrOJXprOA+PtupaXgVihFKG/EeSKQl5SaIuwx
0xx+DjYhqGRAq5QNyHrpqb7LNxT8plhqIGjd0Uk965DOKw2tw2wmwWUmverWewK5bTPhL6lk
yk8b+tzDIZeKTFvGjfs6wdUZ9YdhEX8XDdI2Lz+sSm+rIRO3KKvmLVMZzqUnOMOuHTMFu+QE
mxv7GDRZZs1qHEDXttnH2rW88lo8SbFQY6nuwQKOos85r9g17y8/ok8IOkFC9HtOWl1z0RU1
mgFi53Ogn1+A8ved3oBVGowh2D/LVarLmjD0q1/EyYBpsoKfQjEgtdiJWiXv91+JTMvI+XUz
9RUUa9FAlBFsqkxTIpwb55VoVUQ5GdZaCR6MjXZr9wT4GPykJtBFMF8RM4J9PkpI2NM5uL5x
vcZlz6xBeUu8YeqDWS62TCO//RYtheacOmxRaeS8iRARp6LTtVGrGV1/+8Y54kmldoe+PPFS
hzWd/V4xH+3YHmB/WcHqYB7K8Cx2B7g/C6Ayl5U7XE+TEgMSF+oC3xLBmtouGtD3SkoLOWTu
toy8PyZPine9g34kjxhiDGdXSJeMHF2AG9rCLS2FOBbMV4IonpygAmRLKjSAHG1TRKOJNF+q
Z45c2ZA8QXSHPChx9XtgXMO3okqUsUkpRVoinIvfpa7ypqKuUvumvAul9J44pyEvSPfzz4eV
lMTK2yDmCUmdxkqW1rA8LW9lVlrKlDlF4f9w7KTHbIg7AhI1aQT7XnFDWDCYvuatzIwwB9tX
PWsnEeEmRt27ecMecmt5N8os/0zTxH7j5F5gOwPQRMaxRVLBbpzPXH1ItmtHsHm0ARRG3O0W
QcVoS6BMAJxZNbeY49btmZVtf5wEzfBw+1Rn+CHEYGKKQyyMsz7BLGuHKqjximjvyOkdByQx
nQgBIR8mGFDgTcVDrYrbhBDAHoCHCVXbaku4gcTRpXB6OVWPMohU/4BquhMwYcQ4QClwso20
uc5HzGAFdVVMpdSzLSs42bA1IaL51NdrGbOosIKO3HRBLoOQDJy8R1WFX9wQH8F2uVr+uhJw
RHt9mUjKp4adBOGyCIYyUBf2MxEYRTvqSBEzFjzPW8Ead8JXxHMJX/K/dH3b/dk2tFDpfEMT
P8rpVy6bhNVDPhMRAstIKwJGs2YI3kOPj7kXgJFQG6x2MKwRvPlP83AbYefapJatfR0ZK2j9
W0DV34dcOTksN6BOq1puIi1fTV5ZVx1ITuu/ZZ1jVRWwKgY7sMns/bQ05vBrwp5fwoijn8N4
UQw3014YGzpA6NeYwKcVA36cyRFdt5D/6CHGp+gW4dTFEg6s1/AnA4zd3H9vWVqDPcFjdZqn
vEtxdrjAjtVG3YTP/6SYwjVCqWBLT7YR2wcBMThU2zvOeJU/hQ5cxvitzEH35YZkuCNoRxi+
Ih+FSskTUDceC2pY084t7qzDhXEDZpsBRek2jzGnRYhAvis/Nd1PWkPm4qmlVSmepoPY6c5b
tcKNfBLcbX9WyqI0HXpj+3DN/Osc2flzjbvVNWCS+u2Pw4n5p1Ov5eelKb9Pi/+Fo4+hRunP
bo/t1kK1DE6/19hxUeKYRn7KAKrMFWgi3Gtfn816RsAwlTBmE07TjIeHyNvqXFlX/y0YQpPK
IAoO0PDBU+ggRXWdB+FcszX+uTANiaX6Rli/mQXnY60YfHZoy12s21VGPXDSjy39g5ofFnTR
fUyxFWxz9qkP/mb988qklI5IbuCml38XkI6exuUQZ5NHElUam4soRNawOlgN52izVut1fDxG
6/oxNnw5vNnxg5J49SjQ4kN9sC+RB49rMu8W5Q0QYSH2mFHEhFuXO4WeFP+1a+q9/t3dwDe1
nTCyeT/Cw1mtryGferhQDUfwzWNeLRWPK9edxNcfW0coc8Y/7GEuHwXLTRf0NHeRCE463CuY
DgWvBl7c/IU+AwCA2c9NJvb+fUbE9MJUX9E2ddcJYyLbeNS8xH1Csu4HkWMpdfvsERzZvbI7
3pYxF8U9ZWuC+56j2/X7weT6sXbpM5PviKsmHUsd4i9ftSkg2nd397XEM0e9qkmrorl59COd
EztYfFMxP7PXPdFgt85b7M/ApztyPLbrQ9bnfJh/cJdWxflJp1MvEcqeVJXJOQ3eCzzxHKsM
/djA2T2n9DA4czLMH+XjCyYm4zddu6UqEz1Ug2OD4Bgavm7sNblKZnq5sByUzXSair3Xacmr
54AYBWIrB3NqbjhvySvrJeLQ7yoIaOc+wcFmUibZ1RY05sbDPd88yDjt0oMfjorp0RtKcoq1
MUFWNSdCb+dCQRLw+y5IRUMTeskFeKwGlAeEAEsQukKLMoRE/7yCCaby1Q0ko6M8zmNnVutG
k+UKCSqapE14AiMTAZSUihXy8ElGpuFZzyHL6qUMb+RprQlj2OEcB+YgxQJztcX3C/QvLuwF
XpcUCPGL/XQjN2R9CPrIVRKe21XcRtnyUAWPd8XBteTBWyK7QFl7YcEnsnAHj/ZefJyc1Kp/
vVfL5VYKbzFFcG2VQV1JvOqkbmwvzuFiOKK3lOP3mIh2/UaQleZeGa7vn66JDiafXI6LT0AJ
enPyxYuXia1tgc25mKdSou86v3iQ6oxU2DB4ilWqsQBaQ2eybVoC28OwYg7zLLieU15+d357
gUa+U1YbfKf59y1B6IAVWDIsR0WGN9Ar3hlVOeNtF5oZT/LJ+zAS3tp7Q2ng4UOqbVknn3nS
NPuVmrVs96zmfRAV/vPejRoD/E5BE0FgktP0CT2B/WtZ+Uog8B5qVlWPMyvFPHxntL3gZ0xB
05caohgkxtDeunmi4DA8vnU0F2ijzYaBJE7mYgLEuCatoVPu0UG6oomdRPoktHrq6tkvKBAM
cU1nTPJzKzE2AtA9rV7vY93M2ZTwjQ0qZQlmVu9fI1+Kj8XjauDGNuAYOPysGrgrZ9Mhd7T1
h9GH2NpwPK+uKKba1A/NCLlziwsutUqwiOeBpY1jaRuIk2onZSyvQeb46xY6cJP2mohV9G1Z
CQysLdA9fYQCXIrzswdqmxxGj2eVaswBoPNnf3y9tpXYfZoeFeUzC+Zbp4xPxQ4CeqdePEF2
RWxEXSf0t3qlSATkSVarP71UjrMddkqIN4uLOzvtK94QHriYOVyFu2JuP02FG9KDyXVdQ/vf
aS5HggOh+SFtssTtdifxE5Vm+q66r8m9MamW8VUxrypZaJkMQPWDXx1yHDlvDekd4tzLTmcB
Ty/kCsxcEKrW5tXXlfmE8CVJJ4XsWyBUAXE3aOeMg54Em9o84O0q6jKcsRYSOqfElKGiBzKi
cRNOIMWXFf6SyF7XoUDPq7GGBIiUkOzh9BmlEt5hLZ2tfSy8YLL1wYPC1JBJogdveGm7Z4Lo
ZfbjWg1zliYwywUD9Eww/zuqitD4DAPK/IshQ0oTBHf352gHY8RO5IKq7YmtZgR7IzwvZLv9
FN8n0ncW0gTdmqz6w/24fVbtkfCchnfbgaKBDx7pHIuy2pX+OC8SpUWFP+DeKpGdncn7Cm31
eWYkfZH8Ia9SREPu3VE2Qtjv3IK+8cbl+QdlJ3zxiZ0p26tyo5W9+FUh66v/zcU2PsscphQ3
D78T+FV9/r6OEE+KuXAsX4PMEFuCXaGFYv6uSrr6NqTb3ocm8tFBYkikGohLXuXfWOOTDw/p
4bBPAa2m7YowtaB1NkIY6R4GEazNcToBULwzSgsqpPPub6Mc5sMBn4jQ95WoZozaIKemAjbd
AxvVHGoToFJifWIgyNqxF2qZDyJHk2N3p+CFEMimQ2Qkg+AKWhz+PY/kOUfVUcVBtxE9pttA
sYLUL6ndPY+/vfUlYXz4FGVrAUl7KuYAbDeDGzeo+mPJ05/3U/CR/ygmXHJwZnDxwYb+vEHz
ckpok7tTTLORl9yfg6MO16kQZoHoPAlMqF/YhHaZtTCwSyr/pSxjpkuut6jNmnioLz769kTA
aoe+crR1SD+CUV7ebylrHFvFDPOBmBEvrZtcjGtV7sSOer+KeBPQsRp/CYqJsboF/HPGHLQp
nSnP7iVHxb1vAnbeGn93YoJxL8dCkFDABkB3e3opr4VYc+EBo6MdsBYjfXuqXPSZbF2DLjNr
0uGE8hnr1kp0RZAxifUzDCVVoztiVkWXy6339OI/U/U7AR/a2NIGBi9bF6WgDfq3URxkWlHH
12BE1kD9yX0rA7rbYg0M5aVnR1umOdWk7Gy2Oq9sf6ccaU55lSgCbt9R5PwZPPy4SoWpET69
rl9W/J5whyK+jv/CI8IiaWW/6hGMyKUt2DqNLr24YBILX25JJI5JlD3bSGi1VEFegJzzM9ET
qpelGFy6C8N2TNjv8OMUpGZmc+ypYYQc5kwUaXogjzcgIHwJqGJ7S2muN5kiZjY5uyuYqCed
YcISaK7vo6kF03Mvn40NJ7Q/phtJGZlfcoAoADtawTLohWIUxIUN4Ydl4fFWMlhvQvG8fHCa
9vJfrbVp7SQhF0uld/nJbu7H6sD+GE2lGQ31SrHyOZFFyCjxwydDG1h84+JOLgfGG+bzuSvG
GqwsczEpIhSpZllJ8SSExMx6SXSJx7lBqbS1twZ3utoo/bZOlFwQunELy9Y1v+iLbqmT+0+E
s7/6qR6Jdvio6U92Xh5t561SZnFdIIw9gvUhx+0I5fWMgyOBlkY+wyCY1ClFAbRePBnoLKnR
ikGiBspVi7R9IVEWYJY6hqKq147+KIdMzQ6kXSfKkFEZ6kBIJ6gNtFH/aRTbcLJsHGpgtWGM
Lhy2R+6TybTr8mnQaAFIdD954le2kGPMWsU3gfPfOQRClTLhIY1b5aS2XT3WVfl98vAvG1Ey
e+Ts+QOVeFTB25Z7n29wIDH+FAYBOA5h329sSQN0VHEGgTSMCvESZ5jw4xV7O6QR8jrCWAFI
hkeP5Ag07c7Afjh3xHrLUDvM/jhsdoD4WBh2eBompLN/JV5EqvUjvpmXI8aSMynNQOycOyFj
saPgn7bvnJPQyyA9wKUWieRsooFrE/8WYL08pzcjk4tTSHi8som0o89B/GVinAtQp1fOdzOr
lcOB3dvN6XIEbdzbuzLgoYeTV0dKIziqMg6uet8J7amo5+A51/ljjzS9+7/928GDyxiz7Tiv
4tEobF4Eh56JB97d+FVCe2Q9x8pkEQksMuJ+vG/Vim0uuLzQTdBNWOOWhFONJSF40dVnGTjB
ie+lmHAL6EfmMefbxHRC2+6glkg6vHLuhgr90K3eCXC6LHc1+UeM46kfVqwl5mj3STafnKGy
QmnQvCXTrRh1EdxBNlMiEAU0dr7KO2h/3XxFTd70hKgGNwxdU31N9+2vlLPYH2DdtjD1vxUn
WpiaRn0SI8O7d1h9YgBn8IEF4Zqxjn9T/rjkUuoy/aowA/5QA0iHE5wt4T3bRB8FDcZR9+gF
Tp9Fe3x9+S/2uX2bTlqXFur2j8CSme7frx2GNldfDkZ2le11yZ0Zj+cxQJIIUD/kD2ltKlHE
ygahi9MZ5WXzi2sus+wEQVTamUzRKdjTqJBJe0FcKqzpLNXsmBnPRskfh7TMtRfiLcmO6jb3
qzo8yNefxu/UuEskrhomSZau/66cLU1VNKp7tTxxFdVm7asga8qEkD0pCY/x7h05rk6vzltE
jxwKn3+77J0JEq7Am8BNkZvFkQ3MvqxlS0Dvvh/OMmfPPTG2IfnlY7Xk6FPxf2SQ7ae3GKjN
ArVpTizdeyAcSg9xshB7zCLGDKKZUmUuXyf31acZzf/ORjQ0JrGgMABIVFS+79lBXbr9hjGv
B0t+7B5C2RvcRsev1jbvvAPYBapGK9rP9cJ8aSijW/WhLeGQk5RR1e6Qv/YRVnLu/+fceD/Z
tCsyTtodc0YbT2DjhPywQn1OjLqmTkLe1cTK73kf9fjUAVIB9t1AosLFUuE6yavFHo80fefl
pOTPOiN1dxgpST1EfrQ/39wFIvuxf21U3rLdqv0hWVG1b1pZ3gd9gCl2yBrb9f7zCudm6o4m
iI2x+nQIZ7/dYs+z1uUI2vVW9WroG3lJLXcgcmdbUqkpP+ZUkeSFp1dg9pL1dnjCT4cIhrzJ
fEdZnI9GfVQz6lKzBxp8zz61wLlYV/PEdTxmbtIoQWlyokzyq+dGVhozCSEwpMPSQoU/k28t
BWGZPnpjeH1EiOmhxtlNelQ8s45KKNEfN5k753xd6U6BKjr6Q0krFbbh9QSoSP/5x0dKqa/x
QH2slhJ2qxfUNvdbgrzh+xWa6hiCoJ4kAFeC7CDukpY0stRxWTuQT4yKRtuw13A92EMjFPJv
lsWR/q8R1WQOaQaOsaiwFl7+mpUgB04yLX2dbG1uKHx5NmM2bZq/dwZ+WHhLOh7tZ4Jm/YTz
vbE0KFZwSgedpBTVXT85bXZGjcZP8vLKdyQ0sBnaNvTu8Pf2VOAZ7jtv0d9ayEfL7HxALCYb
HCpkpMUL6c9OFceOPd1JqimuszDR4p1YQORFeu76baixPJVg3lB1LNRI78sUfqVkGgtfM5bU
q3ChFQ1oHMhJfAJfRA+7Se2l2DtycXfsfe1zDk/OMgaFOJ/HlyAOI+E2dyJK5dWWfO+NsyvG
DCfaLxwWh+/l0+lG+vokGlGKL+J+5p4WYlVFZGzvl3itSwKeGI3odBONY/v4iD9g0PHlZ1Gm
apAz2sLawGJo4eEOszbV8vhvBNnFXp94QxAzqgaQUUYM0KHjoLG5vojWD3ZBjzMCuHyf1oVa
OdUtIoAen7bIBaGkB1IdMwUdeD3AVe10vobGFft0H8J7BfaKrSrv5yrxn2fgPWd021NAFz4C
/WfNjl1q82hQfr8Yp3g1sR/UWnjtDvWQXgYAHfAOYZyA+JrtIDmDwF+HLEubp7Na/e3Pyus+
NBaRmYYVmCdqz/ZDXM5ZkIQCeVPDx+Qp77+4AZhqSd3V/YQ1QGgQCM+DyYfqvgBZY64uFlEX
vDX6eN7f6CjHMEt0f57TDcbDSZy36ldNZagGV2Sx3/lKriQ/S/hM7qxVMVVV7vM3sHxSo/rO
btz2kKqKPK82NTYZYvQyfq+/XbgbPkEMgtHwEJIsMCwcb/tODG13CneX2BAtbe52ClWmS4ob
MuwDTRDJyBGjofMoOhNobSAEpG/58lg1s/au4LxJfkrneElsLiOn3E2h6lc5BzZtek2chri/
vpygvSdYIklUK7RulAd0FaZ/HaJF1lnHv6JsMlZ8Ydy1pEfWgor45K+rMgUsIr6mYx1yAwpO
BgOTVwZ+kKTuM/UW/2fHGRRy9ouaL6jA/Ly06ck9UVHCKMOh4yTSAUwGqs8uROKIPf5TIjB0
RlFK9xs4cmgO/mm2GUKMUaEL6Eqb7lh/YNdN3592KrEVwxSNKLqgDNY2LMFwhLpR+3ztvhVo
2XNCAKPReXqsHYsXJ7PJRr3JY9DOLrZGm43kYDc4nBki5vgj1E6r4XG2u+APN37QKQSfcxaS
WUMv9o+U1yTWVBN9hB2MhFRQU72IfTxjC9oCsbNgoCz82G6xTc2EXIwoNjXeq5OcEF9sg1h1
h79tMRSo3F5cu+Zhs6f8mpB2UpZrBDRmq7VMZPyaoX6S9YYe0+6qcIMJ/6Rbo3n5FtJpXxEd
IanVZhEmmZU4kbb0BHeY9fQOmH9meQ1+YrezKtbe6P+MifxjqoZI7t5HtaVGBvauBfEpxF3x
22B8ChzNm//0ET/9uNjjATUVTNwOpdnMihdOboWsa5GrEriu67/Rq7f+AEtHscRPMkmzqH6W
lMury/s5djpR60imwax4CaRkaASJLK4og5QeZ+JvfdL9C1+6rHFbyxuqFkONn6Qjitany9gv
ktbnfPYEl/sqGhBziP8HZuNZZW9hFmorr1frTP3b0iYvaa1J6SIaTk4QY7PIjNHgB3o1Ub2s
43ZRRB0cARR3I0xa5ikrJViJfKBS8UcQtYreQc7HX5d+u7bSSNVfzRKm/V3R/iPXb4wNSNp1
SMRjpULJhnm+Pm9RynIQ/HF9dfRBPa7oSFeZggdGL5xBe7RKEGS2VFjIA1CIrQJHNjV5FWHn
oAUcwnOXwEDjuMenXcDLf95oUs4M+dfh0rWcdSttpZcyDKeVbvYsjYxj9lwas0czmLseyYs5
uk1biCUcTEIwMcsDPsIK1tRt2vGjEVYAUtFFaQukQRacWNwx7v9WkgW+sJNONQFwpxgTI0s9
buDef5HTPH1K29aEPO97uYHHfrf17DFVcFrEw+01k1gJNfA8vQFCi2b955ONTCvXCJnP5eTq
JVu7+TSupKb9JDb4USLUoqfYRvncDLbfiRKNMGERSnkZPBVBNHRfh/avLi7G1+SheeoDwHD8
sS9Wf8TsXrBdr8VaxFW02AWArEQLmhSr8x9hlmKwlLbsaaOmXK/BdxoWExoZVSwz26VXMpsS
Pbx1QPvUj83DORv1KO0PDug85Wr9BFOkyxb6yHrUzX1XjCqhDJx5Th9Pb76rpJKU06i1oZa8
QgFOcQtepT9VULv3xAGP1owO7HDOydcfmqOH6Ypoo1Ai6ITgDCQXByOAiMIUJlIZiGbYWtdy
UKvPBaiLVolYeu+wk3a08aeUuE4WCtFTdp0V2WPgWVUrqcWADsXWW9CDYcpOKCi+RLDQgk7E
+Q1/bgOAnXzJUn2/XuGWE+itT7RjkTc2Nsu7m76y+gYW2DE+tpso9zJrIp+LFUXtSHhyIRfO
SbVsmqk1pNQEzb5j0RvXhHuR1QsO0Z+iEcqM0eML9/h4qBI2ziftJzJNdUiHIGqDoRg6iUPf
Ehxw1n9hwT1aY6s+pTGt7jF5K1lYPFwdVah9Y4mlx7foiMMscYQJomReSp3SlFtxxQKh1DXW
4NZUjCErMC3/JOxTyxkdG9hquAFkgYjdkdWnhuZxvupvUdndwLuqVaWnjfGSMXvbTFXxziGr
0aJCjKE5rb89qznFna9dAkIRRS+WteTEgeCMNpvL2mg2fqy2CtbPk56tke7PIPV+N/PIxhKF
84T5HLtz4NTJlgPTFySzubmabgwR6+yYiUaF+HBG9OjtIGN4jVZMlKU1gRjTVc1VMYcakBuy
Yp3nve6aVfzWdvp5JLchhNCA/+1dtnY4anKYVZ8iYR99pvwV9+Ol6kSzvrK+tRCEBlZkMrec
oaazuzkaRD3YBSZ2rbTQNGDS0WCXpZgUMMpHVEjMTLeDMniiWn0fd+gw+r0wrS/sablJusw3
aY3uTgWjLN+edSjVXi9RhMpORS1eVkgUHCy7L9xBRWdEdeXoOgpM8ubJSrMvRxikrZa6oFxL
o/Wq25807V5IVlictLqT27eDiU4ipdK/zmwCu1jWo/A5ydIGAcPWG+lA90XpDjWzinb4qRSJ
d9m9/2ewcA9QQmyOVYImWvftbUAiJLGE8NurFw3Je3T7lR+sUru1E3ArMYtdUcQfmO8iN1FN
+Qf5nghSyBVpujbVR4N1fevqnxXPKwYjdD1CG9fAFlQaxx/U5F4Ssk/PqWZ58sc3cH3e5ioY
cNzPOpaKsHgGqe3tcgA/11HP6eWoMC9qZOh4x6unQZTK3A8Y6pfbLlJJ6KGPBjyTPZtTov8Z
DiHuX1TeTnhQcyfW49GIQOaTqaDk0N2rIJxxMPjsIs/6VLFeOEPge4QFJwO+W+xL52Ad3fon
2iG/mmbEE7Uu4qP7mxO7OxnTwDAIlHbY0wJj87WPcTJFIxeNqjNjISukIAGFUGnMhXi9v0In
o7+/UyKOxCIuqeTYpu7CPnhu22raUz5iMvgS3MC0RKMSxjats3n5vb+Avw1V2gx/4Tnm2bMy
j/GS9Qp7Hj1hZoWm6+WteAmZrgRhvhK9vX7xx+C3/bVY5WJfUijrVFyMOSFkj5yJkfDajmxE
cCE5VtShnnd/QDcTJ2uhXwbNeboWMozMt194tWjEE8IKKjrP7SFXNOtWGPirQ1kfftG9epIV
v2LoINC45vyp8x6mrTcVL1O8F/jPnDB4otk5YS5QEzHvGsoFbaSwWHTyZeJuYaNFHatpg2Po
09NONgeI1o6O9sPAmcKJcazAVJn8wrgkQJYB2r4R/RRq5ynXtDHI5/pTvN9uHR/YGLN82ptz
y7LzOUj1JHLCTMPkrDoPGjKqODbWnDSCL63cT8eazi2Dq1AbwtI8qpGuiYus3gnrhMld6Kmk
6evuibnHbwpK7T6lM41ilqV04fuVJf3sENVmvKCSeACtlVEFiBsXL1Pnjlfl5IhG6BKtOoey
SI8Izh0ivurEIpefHNWaY+BMiTBz1jfupdKRpRqMNM3bRN5NOS5buZ+W1+t98EQjmJqhZdAC
sW9+Z/GVtrJK0X0v+huG8r/3S90dc++nqrqBFiNaTTcvm6RZ/hN53kviFNNxJv1tzaVXuN/g
xnBxAeaedumRejo4M+4e2LhGfTtxmdAyoE515kC7erneocnaTnITGiI/qkYYPFctuNqQuLtS
WeafgC29bA20HKktRscFlkJk7QRpqKSq94fHo7XQqvp6ET3oFDV6o9MnIrM99z6RAWh9ApyX
OnWaleU9nnpGFnt/4tgLeuepI328I5uUb6iG8fOMyFvuvlUNvO1iDczH/3erMuB2uqrsbL/e
I0zhjRTXGpv6h+bhr1VgVbsNIwph/+gHvnTKusl5qvE8QN/Twqg0/jSWUAfdsZZZNW8p23dM
pasGje1Yri9isuCfDCni9Kyx3U0Y0H7MIR0T1q5kRDm2EmN5PX57MFoxkXvtjjefHl7zf9yl
bT7Jax8sUJsmhzg+TB4levmx/So1cLt/EAmulIb79BFPoKanrvUIP6z6hlxkmg+HpHNtd/JH
wo08Onr+YfXP8lc1gpAKThJifiNgDnTRfGG15kIlFB6MCozpml/xk/iTtGV6aQAGBtuunZ54
T577kI3BEQex+QSiz331SqGU44g/AhUbPJ9Wu1L58ZtDgfLw5xj1gY14ZU+BtaZn16cRrd1C
XtycI0Qd1BMZAbHS77C5qMGDFT6c/zzqMvjE0c+lCA1PjH8M/bRS5UZs7882gfbQADj7xR5E
8PHqtVlYvUAB6ZIrPCKbyuI8E22YSiaXX84445zZe9c4IcpXlSkgKHuYAVLdWnKSzk2Xl0Ap
jGMaPmD5n9fuWtXt8z8pJCxowO7ASSS8KjVBJ0OVCe6g2ZU9ZOmypLYP2yyr0tjTpeQnx9qW
2MyH4QO/Sn/TN+/7ZogsUZU0gKiUNooE2LC/0nZaOHhJzwbjyNUZveUrT/g0q0vwAWBMnHy6
b8Bdc/xsyJrXAVGNe7EcMb4dRyCB/Vd33dlvq6lq4SVf5n5sjwM/3z6Gh7XW1dwkmiJMtgrf
94MfmZ7uJut+NUKkcsikdIk8xYwkw4W5B4mbwdaLbeAg+0C733eFDzPH8kUxkrRBpMO/cWUA
dDrnN9DP7on4hTlOF2ull8KIPWVVRNS1W34HDjQpEeRs0xKGmDlw82Nda4/8xl+MCan+PY6B
hlyYKrKLlkeP+Cl/GM2K1EgzXNxoyHMxNUrm9h0h70LR4o21jqttzsNCwSL/uhb7d6Fyrd6K
FGOrS+mILvrUxa8pDHdnHwRSHAFErnUbAO/yWknZw3VDLp612w50INeHg2qjbNZHBrIMd2Tc
d4RXu8c0zjQlGR7/gXtqStbcZn5RCZ+hfqr9/INFes2KxTJiPEvsDwF4nLGwykxLECEQpJxN
prjroIHeuJ79ZrmNofHfzVIs2gejnE6+SbHRv9ef7yH6ubuwThVcqmdWzs29qjaJrv0x4oF8
WV2CCG7QV6bok8CULp2pXuocARfEHpHGdqLJK3yguKrMXkjRLIKdGV6tbW3YeEYTYfNnrAgH
EZWOCzYo8+mhIBRHbC2ij1M8euuCWjIzzB5gTzXCW5f83nuQBz62RUBkzDNKXx4MUXkTd+gi
wdxkcaDs3nyMpJkQC2QiwBBra78DQiFOPedxKAZLLpqw/3bpCE6UDhC07Xl8c3fp/Mj3EhqF
MGoXCljagiCnYAeM78Rwr2/ry0M0BHP9J1gckLejZ0IPIT7j70K8lXbNVdUXYv6g66KpLpJt
RxHke2p4QigGrg2LgLH8IXtSysA+3x1xof+JDyXiDLLfbDsnw4oJyqh4gr5+26oSzdkUrASD
WdigLrdSK46r9FBi7pV/KWWwUX1UYGUoizrNExXj7ztzRd2cWxS1Hp6pjiV9Ea/qkPBA/aaQ
SV+pSPL3t2gAcigKExoH0i5l13P1x72aS2CyVDKivgEXAgw5pKvztSbUiLGmz0Pg8WvYIO64
Zqb/mOrp324V0yWUzZa2nQ7c21ifGMJqPaRfnTxwtgPtvlgSRxKs3UlpwhR3d7trO/sSTMDw
0aLAfVm6QgHMfc6RYDNGExnQAVzGfz2C/Mn+HCQsPDIDflvwarjdferPr3HtALbpxfeZ0OAN
Wjo8MVz4fl73yoAyNBWKifortb27pwBSuCpKdPz9DWGx+1VKtZkZo8vMEbak1v4jwq7T3Qnw
TjDyIXE2ElpoVjISN8EcUlpGBHcKNBmhPtzNmASoBq2kmbO+k4JB1cwzwM08gotppJxFHBOc
Q+7C3DVcaLEo9ozl3PPNlE/kgv0nPN3kg4XccVrVVQlYuiL21aMWDSdwkNvsdZgWh2oHNesY
N6uFIe6tBHmbCB41ar6IU65p4QYEEYEChYHOuU23gsYWLCNVjWvnjFjrMNk8dD+k7XsVU+df
cBYR8Xk3dSXhzopliMahEFKJNH05L9R0FHLP+sGX1oYJoq3yWez+lQ0SctcQtjZlkIxcC/fX
nQlbOTh5LYNo6aSWiihuwagEyRNMEREsjpiW+sEL0Gtuc9jwRS1peTvh0m5BbvlRp8qeroaP
Dga17r8xdmaAvpL0eTw/NjjSHO+PkYzlnaOeNNiles0PRYyKY70GBr8XuRq5zMR11PCI7hVz
dbZOBC+EtPC3hPrxTTSiju0gwE/CD72SUASIJh+wy2U9FiPirO6JC/YbKLEMvKXJ4X85oNVB
CxRBvIB0PS2l1wyVUx3ggO4WdVEz4fOD2o743OWM6vrc3H8JmE30feKZxLaFRT7wS2HcGP8l
+6cM1BuK5cfNBtpRbao13HuYbA5Mtwy19EsmXBLK32tWolBByCjgJaro6NBMMQ3hq5Xe9x1k
BZ2DCkeDT8jxAU+vuy9kSwbLqCDe10SamW0QxHsplgDfNIeaO5lbLG8sNurJ8jCoG8Hkv2dw
LyT0Zt4d+RVUJycYkTNQTX8NTcWWmAtV/85mOVo3ITJTBcnVmm7H9p6aU4wv4OsCzvNd735o
lyqYfUhiOVf5onXTvgIoqgafYIm/qEjAQBQ9qSOViqcm1K7Xr+2brmBYFWRxnsrQOL0z0SBl
w0c35yYruqaWodHDM4jBmWgjy33kZ/E3ehEMZRSSCQt0mxdH0XCIcff9mjAu9PV2emTyD9sm
yPmi7BS5iR/JMc14dpIG6SCrYA0Omy3RhXg+I7wxQ6qdixhF5CzpGotAUFpVSCuMQzyWA3m7
BTDAvZWlltexR6ujRoqs2CRwNNY7YIowKUqo0E9pNOmWeDpfjL4rTs31IcK3Dtwhh4s4MsoI
c2LOTRYG4J6eTv5hEV9c6gcX/I914hqOkeesYTjPfzpJRMc9k1A10//p6JLfqYs8aFDY4cbG
ESDLQIr5uxllJpdbAUwHFOgd5YeTi2GuLA5RiJDR6d4fJ7MfjFhxT8OOzCIFYmN0WjgxGjTb
uONUw73cHDQBB4rwrApZurYD4XWpFqvEHVwocbyjHO4eHVfyM1eHCe+g5lPKr/N/qO2iFjLD
MT3glCUPYdgUtuQ5kp0LtMCx9AidD1uCgbtx7qBsrKlbKIF+xHlAcTdeys+5XJEAKIY3Grcy
u/htDZ+TolZ8C1VAmu07n4YChQXFIguIuqdpDgx2GdnSMZ1AIl7Q7NtypSGtTNP7b1Z8ks2X
IUMDpd82jHKPY9OrNwS8R6AZjE1W7/4A+gFS072pMraHCi1shayUzWsDqPixyS0/7wg8ONhz
Xu7Q5HILAAUyAF38QchP+5XP92uV4mOYKTW/c6HtkRGjjhAnM9Avjt6wdFbCOxUSlmcXk4Us
NiPfmVUxVokqsf+wU61XiosPy25U49RvRHg5/xWNphYZeQSHfzZM6P7Z9Z6jO96AQ+oGZirE
/8QZeh3MIwuWk3TQ2Zn2zK4+bq7RpaGzgusPWQlDL+4T2eLYAlHavfxbh6SQmKFzSQFFAsQC
6L155hf3rXbcItGbEOL/ArI2bScUNtFvrmKyi5mea2YxOMNJ3AUqv/3KpnqKa5CVnAhmzgDi
enDTWWLISwhy0Xx2X6t/3pGIXQJ1yVVNMa8goHg8n5LPMiv3HtIJgccxjyai3x/dF4PXR28t
xx06w8v2hJrq5uTbzAClFJhL86WM4dd59kAJ+Qu58ER6gZxLckJlDVvpQ0ldc4TytPEPVsyz
coBD8UMq0Ny1oQBQlV6jVN6xkD0wOeoh0sJZZEMINB04wwdU26uBnQY26Q6XAcFWEnx6q/JO
5KCC63wwPe/xDvly9sSljghCN+2CZ6l4NgXF2UuHyfsQbuEvxSTNLYEjg3OtQRN+h4nR5jo8
Hc1Q3h7l1op2BWkYM25pnT38MdDtUVCPp5iTThNhSZg+Fi71Xl8Tz0X+MF16IwUutI6qAPpq
YTQ7NKsKxKdx5vqnmPzooDtCAidR9F+zRCBbcQ+C43+GEpXDkngiMpF9vqo/aKFGsCZEeBaS
2Y3ty7p3f0Pd2M7zEPqSa3gu/89wjw9tiFFg/1DSFWDG9ZB40RpPHeT/w+U16lZ1DKw0WoID
9+kW6U+oOFL/m3HJoA+8JBAPUoJMg/VXTsRFHiKP0rqoyAMcGqpgymnhABIEUNjJqC29eE6a
/7/uQoHXPjjKFdThIQvfvLXowOHpuHpH5dqzHaK5eEAkhYhAxZsKOHZUtPJ2ONi3fL0v/iIY
fw8ez8FUWog6A6mgvH08wulPj97WiPNKwomLFVbn9XPUgzT7+iRB/RTFj1TwWzO5HmqjC5M2
KEYt35y6aZ69nD3iT3rHKez7txxi39mECTeS9FDk4F+UMGacaZH7MCazYbobldlrYK+W1ZO1
rS4FbCWUyrqm8oeHgsODWk4SbxTDYREpHLrtwG0sR6CX4duq4XEa/cMo68n3sSDBHNzBCIzn
jxh2PS8EcMpoCOdKU8lT02Xj+3UyNF5fXqsD67nsANElF8RH8QbsTww4knSm+BmNHKZWaOnc
zTdHSW/C5Crbr0DYDdCUUhOBHWL/+Zu3bKPI4b+PfSCbgdBbqx9pwwbek27hMcPusn92blhK
wvYBbQibX++0wmn+10vvwdq9XBBiVN5CPEIH9A93Xl+NuqVKgtAQvGe/ZYRp90CgFaX6WIu/
ocOFwGSGR3ka6cFg37DDYReLrKzVnle8b70GJn+yLQRsQw0mx7e4vJfcX0Cbb9qGMlKnn8Tc
vqXK9fwJbMHdo3Bx82rhjnqneCN7XWkGuVigCinVlGMtGJqqHw86botOYNtKkF1GVKFPxAQ7
Rk9/9MdxRGVdRFCTlAoa4q0rTk8deVK8xEdakoTgXn+/FpRDQ4nO8n3qN8taURtknPKZE+o/
IMcblE9UhUSWT3K+GP6SYYg8U/aRnkWdAPs/DL8kWHiES5ykLT0wE1Z0Ki5Yxct6+OBFVpMR
dB9lSY4kiygtb6jYTjWup+4qzc2B5b/iQloq1p1PntbXFZfa22KxnBih+pi/Z+tvi0faqy27
CFN/bZGN4+pcEIaWcD8iShuUxnXf8UZ9Gp4UR7mYnhSAKYVTU42wOvQiZCsS6wyKtvvzkQyz
j1oSolfK06NFoLS+25sAJQHOfKeaV/2XnmjE0EXqFnMMx25HlBRua4TS+QkixahXpI0b/5qG
ovRzcRmW3jFEt+ZN6uuOoJghItZUHhr4sYZSI0lzTMH2fY8ql5i9x4zgF7fS8WxGZGddEpjn
RBIFKlSF70lwVHhZi+TrybMpxCbbLXdGbiT6sr7HbzA2VYS/7DcBU56mDlm9AVEGYAR6Bzgb
zGL5IgGF+tDdUjNpGylE6ILeU9AM9VtGGSJTNG9V5oA9XjQiDyUcM0FRfSPNLRwsr8oGwHMX
/OG0/6L8diTakDhHvKQb5bDBBuuoCoaufB5Ot43j4fAY+QpV+2zFh7G6e5hDC9kVYNtEAbMO
o8aRTOM5RKldDxnV16ZfIsmb6PeSKHobfGPiKCdBmvx2TqWwBjsuC7By5FouI2GQTNHO0GQJ
JFXDKptV6X8t6apjmxx9svaRxqO2wJ+TkM3sn5jow0FQp+zNylIzkXfqKWg/Bfk3kVfUzLFo
fC8ocZKmayzfVORaXBeyhJ+EKdX93a4RoToCHdPM/3nRRNJc5GZ9tNMi7xPmndQ51eadt0c1
+EhLCxe9/MsepOo3dmwAjZlcJm2wHovcvGUH6TH4BFwFH5HbmrBQsnmw1pTiVTOz8UAd7hAl
q0nDNSdJOPLnxSAygn6wU9xsWfxBQZTCeH6bb12MEN1ZCy4U2sYammgOBIJO8SBkS+AAV/bA
9jTMQ8YdmmDKgDgg4n6diRG4dOgyzmcnqp/SQ1y7IyWj1j6ltDTe5u0ae09gu6+KUsi+hQ2K
vJSrSwQ9mWTypG6F4qMmEhIFGxGOgsAzLyhPz7T0Bhl8MJuhDlgfbd099LTiE1NjI/ta7w7m
VtpaspE4WKSeTcFAECax1Ok9ilourspWY2Ek69i3N/qblZV75a9IsF6os0p5J6AFzRnq2SEU
Hlgy7cEmi4MjUbvHD9urx1sVtoH+CctnWruV+O6Zl7Nm9xwPe7Jna6mKvbKs1gtaoc38Nwjg
/wfNTLzGc8x0Nad+LfEQm6V1J/UUbD6sLWJaAvFGVbUgcfwXpZBakoHxLAH1sbmR8ignih2U
LqqUShbhh26sz3PaDQZftL/FINNSI0uOaYMeO5D6CdVx34I6NBU1C1vqZQt0bMeMIdPmbj6w
RF4l1qXpFMp/OsoIWEaO1dmu5fk9L0zpYUC5RpNeVbBY74GcTg46Xu3PVsAWV5JPWDvZTwjy
cOt+7vgTcedQ9q5QjXYWMD0yt4znC5Inztwtx5Df9A75ZkBh3IfUXFnwjmQK901a4qnC1Crn
6sY4uF/uQTu2o5c7a+3GSCKAHK5yfIrnsFdVkbUHjO9GhG4+ut21f3U84Ag/hg7nNLQG/1er
7bHjr/UJHzVE1dMHaGdMr+H27euQx1wEoX0E5s47h0FEUn8y5/qQ4ghiHQvUP2jY3dx1faBl
9IUU3R2CRJST4EK2CbZqHMUO22dbaTvSja4yUGEoE+2026fZcwn7B1TqCrQ9CNaKvU4OLkyz
3A3gTw8RQvNN6pS9HHQ7tCg/2rYGm8Ya10yB4zLWnIEJuWFPg1CiDCKpEhMmox82pf0oYj+3
Ts2jkjfSRt0mKY5+/IVBS64LSjGZ8VMGkviQGjD0nccqrIxzDa+J87TG8SHbvG7E5vSzgNPr
8AlD8l75yBrDps6rCMS4Kl/PVdjLTgwEa1DnhOPZGojdyZCSUrdu1S8e03wSrZbQpEOyUhWu
TTvJbKXYX73OAHxhKFdLkyTW0sj4HB+HBZi1YqqKLca92lzud2aImOWynCoNnqEUDnoZ7Rtv
9v4YyH5T4xmQKpyiMQCaCVJ+q71EWRle6+6NJbpqFUb5N1LdiE+w2g5oOzLqgipTm37lw5gl
dAxhG0IFaXFNJ2zS/oZUtnZxajDfMB0elbocNBpaSflJFJbNfvRW34e/wWSMBUTEaCFtYaaS
dmIhBLx8yvaxHLXG3envtsDiTHNg14Klv37eoV5zDOP+cFcFi/zcgvjuB8/06nfvwTnR94xk
CAC1nB78cLxav0jp30tZl2/AeOCvbtJwB9ln8qB8+AIrd27J/V2o95HNMlvOJC4mD5XqDFXw
fp13uEM1h0Opl4WsF303VT2BmjfPadpo1N56XCxkZ4mlbxTQ3WmSJ8Racf2H2/RX7EWhmg2m
LYoPVFTC038fFaDA5CMdWiRLWr51OX/7ihHr0f5HzKGTkPzmJBo4tYKmn3lfpghn3Sblb/ss
m5iOUUQwlKSricd/ePrxZ/SIentuz8wy1P4Y70PQyXgPL+lSegQ0kz1vSM0jiEX1+NsGMFoH
qTCo6meebmskLWiqx9Iaz+jyjgnIglyXulhk2kki/hNLVQdU+7Cp+9BR8mitafCBNMNMHY++
QEK+ZujMeVDhE5tlMo3cWUei7DRB0OZa0eNJmQ0juGfDDh445k0t3lyTKSwuRkmqUC5AH1qx
E+1Gnoclak69XZ9c7zIkCj0X/iP/xjUHAD/0uwkaTnHMEcC+jBdoguqFUsrvaI0Pb8t2N2Ov
cUsF1xThzvzuJXcO6uECEpffHLfr+maHnZz+Zdwfgo76c+aoOjpK/WJW/Q+xwBazyE/5rN49
jTG9Qb8MQaAkSOBcupzuMVj9mccOP0+4Dai5ZKxR/RehLQCRXrNcMsL3gpRBMtz/gr1VxEsb
TwSlwHJghOvawKP8s/U7HlFLHqD4OF5hTMRt39VJiK3ZSYEhOeN/ZDhYWYl/ZbfT9Ok27bQS
HQBdVfkE/XGI4xTeUB/N/ujKMK+zKH8ldmf0eoKCGzSDMzWGEFj7lvtrxK2n8xA+tHTPeFm0
r7aZbuFwPczxZnA4OkWRMhUfqwEBfWGFt14/aCX31irN3by8KIqTdg9OKRFZoMiO3c/azuCg
Xk7Y2Kq+XIv0e9uxqWd63jbKHjd9ueCWQ0CeblSwsRm0A5u/T3qxd6XSzV2SblKfZFDeaAio
uctxvsyh7hHd5xVdyIuaFCIeCCC1N6vUu1IipmEFNOAqs+DmgZaxmhHX9N0qwFGJo/wP16S2
dhG8Uj8PSJ9/hb+5P4clYlKcrjq7u07A25gC8yLVB1PXRrJmjFsjih0MKu4e4zAvU+bO/TiT
NKlibLhIvzzqwH7GZfmuwmf1tO3kjDV8l0QwiCs3xwrrNnl56BzeDG656KS51zY5BHdiAWxy
pa01tqRIzMH5clPck451C11+t1AeUMzEJYm4LpCSL8I2Bs0hRXkKUICDztCGKZy688D6/G03
KlttEYIzLzFIvjHPmOUXaEvSPaH9BnH41KzhCzEz/G9B/qsIaRDMJo16+lq9sRaYQGDvBxa7
j7Pvu+Fe9NhWf3Bi9UGGwWCRN2jMlb8IUIG/s3hLPH1SoIsbXAN30CGv6s3ZQs3+qeAWHbmU
1xlZfslj+f5t7xe7Nfs9JKSQDI0EoqwyJURnHss3/nc9/lR04e6qagaAyqbCiZJGMt3ctmqT
TIw84U+XSsX09VtZzrY/UmMxe+iT4Pe/Rj4T+y4WFzDn8iTTCQWs0Bv/lLnBtMCXJNmeZc2N
d+lt+NDewvzvhWOBsPxRmx07ccz5rUzrmdZjSyx56hF1KjRLTlA3zwL8eXheZK5JTSi1+ohC
EEMdkn0ZxcLoK6qQrUZr5g1wjQN0H8lZ94YKidFZuHSSvNSyR5vqyNEKdrsjDne4FYAIj1yR
6g8qiw+kjll9RpCXnllsTI8GkgzL/KbzVnoZRMRTH1mABUGJEabT5j9q9mUXOoe2JQ37cUxd
12y5h/6zf0Gz57LrgnQZN7bIzgZ1SdswC1IYCJD8i0uaj1KxTikNFGQX/Z7OMvPwl9l9HOCA
5teWCMNUnaW0m8UqvmaxliIRUbBMJ4eIydpL2Er72dEH8FHbO+saYDaHl3qtihoGx5pIIOdf
8vYY/i87bM3juCKy+hdMTgcGZvBp4O93GZbNgxwcXQjfvWDP/aKtE9Yiwl3a3CZMejyJC8ie
zalXTUwBGRq0St/FyO3tEHYaLXqlAuAKoAFFscr+H03ohjkUvZG9S7kypPnt+b1fLUBbqzRm
iQVZR4bljKZskE+SslUcjW1pYWYeeHZEnGTOp9TOMPYIrKwqcbZBbw4D84WFtmxTRq39Mg41
2fm7q4Vr2+3UffhLeTT6t+1sADBLHjIA0fdzbCAj73jlK4dPKzq01tDCRb+IhAM30NgzITtU
N3O3SwJOx3TGQi6nXnQyebg+uehN1/crWlN8e13/GyvgGdSsuwTbcCKg2TMgJuoHs5Y6yOFM
ctbWNlWwxc6iI4xoe3d0xReBUz7W3M2CcxvSUrprOsH5nwfixaSgM/dnjsVQC2IrSOf7JAOO
ncfZfZPym3wjsnB7JtXofdqb9/G8iXAEjyt0L3fJkvyYEtdpHYKAfqIvPlz1UfXIU2bMGGK5
Zny5D52Ym6oc2qtnqknN5fi7xkpsSuCxymUwuxXgzBRo8X+xUlP0E8nfTnIhZJES5kuNh22S
AKU5mC//zlaFSLGeBO11DQLHlicrPhGWyBYBNLxugql3lcOVgoDA5uGtrESq5r1PQweyMozK
ZfCARdhsv1Onn2F/p3SfEs5C5q1C26lUlTF7S7g/7j1lepna5dWx3OsPLu8gjkJ4M3X0N7VC
bGkx8N7kwgMMn772qKdHIA2zbl/q74u248xur2Hcqjm+4WFz04AiivvNzb9kl2pYl29FJ4Qm
FZucekPqLlAIbjeJ8eAFajhGN9cYe76pc+tLuqgw1f+9Z45M+7a1AVWLodry8SVkVs6RJgH8
OA1u2eFNVPfZiw6erybiIh+y0GoVVJsXYBGvlX9RadQecAlg23VPjxoBqOYfLkwYtp5cGyJW
WGLeCLO3eQAa3m9biNDBiJFHBtmXYz7wcXVZjPvMaKDdpuffI6Tv/Ofl9N7ICNMKIc6uZ+6l
otBTn4zCzIEQyF/EveGKBLs5VGZM5R453kLrSkddz060U+mRDd1wEaI0NtSQzqw4M8GNFFII
HwPwbU22nsEBZa7E0A3rc3pySaSwEHGmyhTKg94FtQA94PjOwvl9/7P1lVDZpiBqyOJxZuim
DU5f3frdj8SfXMQBqte9R/b+SYq7aiYPKf00r3Lab1OGwobL+ptmH4F5GM/KMwa4foNtGYi2
4invoODmerdJF/1ZW57Zm8JzmQrTgCrHnWURpiFXSb4gj+UmAlRX4pp/tUnqOE8uQ1cMnEf1
ggZX2j7HL5fhS/SfzTUAOa3xq16pPxr6ldaI0gBvF93rWwY5jyRWHWxcGmyV9anQvbs3Qa51
S+L3HkVqi9J+XO8US5M9WbdxP+CMnv1yegKT9bPf/CVQAlDqIy69YTh1PSyM9G4+mboed7qI
iizcaT6jySvGdadJyHUOjE3o8+QuKgnHrEkvGtr2ZLAApeyNBu9g0GUV4GQatpzQeKY+CZ0f
Sa2gkZgi/dmSSrtyOz1jRiD4MWxSNM0K5rUJRC3A7D8vG+gZhWMhT8TqkcwceyJKxHPUmZXY
2SWreR68tJKiZB3j9SkR5Jvb2WCmeIXiiLhLf1ITEDnPITh6YUFTp8lc8k1gS7azSaVACM1x
Jw0dKcUunG8dlpTsVrBV/17SoXorGlFx0ITzlJOvmrkFf0LHM7zi/FJ3uL448jrjm6Yx5t+P
e+vacrHTS7Q1m+88v87F4O6MgA0lfPqpTBPGVMNeK/qYKZrLyuUPpmDKAcYKw556fkXs2TAr
lWeeNe/1U5EqseVoeT5cQD2zGAmBhwkxas/P1II1h28DEIw7ouPYFv4XQFrDZIsSVFQLNih0
Bl9qxXP6YaT41p/q5ZzGyGQymv1Z/VegKnDv4yxywzQ0Ee+k34l+Ux4aueFlpb9VrPHDLfvx
56dYb17cmM1WpflZCdey9i4kc3Jr/mrQnPZoI796y+8uZkf5KOS4iEdOuBVk8dKJFnfbr041
S9OlowpTe6OeSZrTYYotTcX9cPYZHlksDOfYBXZoXuo+lV37NHOOBUQwhE9LWrsdfrsCkUsR
2Ap4WbIMroRikzVTUCJIMgiv4vrYWox3ftlYlEIuYF5I+61I13zb587gnl0XbB7CiIApIG8p
fn13wmboWL0+bCCfq+p4FnLMOTXBOFiJH4J1AVfCyLuIXtikJCGbo2oU86/NrqlJpQkKeGa9
P0r3/AaHV3WZ5L1i+uvpFNrLnkJRUPl4s/XBC7ygsHhCPN4frbUKL+DtgsOmMgZkikkmUrRr
dlHnQdC2sqSv5IgEjiT+7C1/I/XQwK9w86ERabZ+DsMQL1jUz4Q2nrMqulJc5rE8oy7s+rrc
2DGcqLsXcNz26PB86LyBmN4y/VOjegdNLpjWAmlDsQtHBc13WhIYIiJDWT8M97e7Mvz3LUu+
1kcwzg5RfPBbnbVNLCdu3G0JTIKIn3fabIC+fPKqfcgdK8nJEnkvr4HwA2IBIKVuht/JeTTg
VMKDTtyXfwl6rfbJSHqXyTKI15GcBGBA5dCEWOYsuYYSPGd4jqJRDr7zgLK8K7+cWyAaFgL1
N+aj8tYNeaGaXJt8f3XWicpiNr63TMw49iUhOdnD2Y2sa4eWBLGi0ewLS1vPE3sn5WP6FKU4
FSJ3EVRw26wCXAPqJh3J3zGzKDVzij5e6qB2jMJYA0KEERH7xaStiI+9CeoL5s8R2Ji1ACVG
8H48qYI7PBXgFqetszPAv8eNFhMoOw9Vw0l2ov2h3mvs+YHWxaqMQ9Lr7smzLGSWXJjRiOUM
X3xv3S8ukN2sjHQljqtAahnlsMbOGYtf0Fo6RnEammatW5+69wP9nzMi2KNpWRr3tYk56wP/
+esD1sT9jwp2nNgioz53r+WivHQqMp5ZrYPKRfw26YAfs6Df393l7xEvRaiZxh/idzFqOCsI
Kcc9h9c53g5Lb57eusa39yfXvXrrbE14OvkQ3DzdkDE1zYeAjKkshKgVOM9ltAmflshMPpl6
g87kD0rH7OclB2r45eakLOQzHue800czvuvveWZK2OB3WcQ2UY65bUfEJrxxi7Mpwot54ZOH
tenDkpUAjk93QattFxEvs+hZ87sRq9iQ5CThZIRDkjvJs51q9FXE7P0GaHX6KQ5JXIdhXATS
IwdTWWAvIEH/eAkbJsbayph30bKJJyuUVVQJajHOORJ5QqtZt8FfauttvTpTIaLRqQrqsjbc
C+JX9tuHa6m/5Y7S2cqjLb0Vmv0fioT4GFqYIWP4uV4jNhvJ2c08B/jA1zgv2EkYfBX/IIai
vADWJnpv0lOg5H/BWyzqhWhmhmwe3F2jzWCy+7I4RLeVd1J3Qpxfcqywyby6jfPWJPE2tvoB
8S77fdwT4zZDD7UClt1d1BV87Pn62MOVKKaLPT2p41H260lWCVsPdKWZJmVsiCCiyuhffWAI
I4yyM1Tc1ARaDtZe41wsx/AofHDBhcT+bvZEyHjfkKUcf+SivegB6XSelHRYU4eaQNBCRsh0
gia7PVcQuFIYMVBGZCFKlviXIBuulzYbk+Ami/mSPcKyd86CvwKz88LG0IQQh48wo2iwGAJB
iN8C85lPUALsn0bg1ubXmpdu1UYksPZFYIwP6RlcuutS69HlMPgi7zYK2O7Ud4ubFBt1z6If
0zHtSLJ0YFrscbLRC03bQZ7xLFDiViVLPGPDpCtl7Pu2KNFA1Ogj7Wuyv/3NpCgn3qyxc3sm
dDNhxUb/DrvpgQnKN8wv06mpQjWkOPwDUZ6tH4y/RUnZGQAl9+5kXdXhuK3E9EB6QOHoz9bU
qWa1y01bo7q+PAOf8WMSBF8VCfB7XwS6UI2BPtVDmKI0raKfr4PkNu1IxnyynhU/fvixsE1t
GYb4hRDQY2+EeelkGETntr1QKtOf/c5K/MUlThDp95Qr7LQD5fCM29TZa5sfoEoH+Uus+oVS
VV+p7NLNton8JHQ0YbRryllulmHjCP+usmmm0MW+8GrriDzC3sfEgd0wuU7q0eQuSfldWPOZ
elL0kvFfurRlHnp5LoCqKpWjWcmR8iH/QIJ1jUxL/oD7sNQfJ3INr5lWwlIicHWXHwoOShhC
t6RyrYv8y/EUsyrHChwNDVyrQYOLl4GuwKHK07VKFUE4Iq5IVY0CxH0TFrj27Zlu0ME0zhKY
6FB0mAYnyTCz7QNjwvkCmYspEejZM0AF9/BS7Xt6fcz9uddBZiOruvCMJCyQMZNhQm4fwI71
lc6aEWfl0aiJOCL2QflbtmUK4UZusLtAsjaDZ7gT2oLDLCzeU6SruhrN2lTbELFEnlHtunHa
K0xB/w5jOCP5x0SUF4YZkgc6HrAad6Hf3M0UP+p5x/PDLHt/676b4HwP6dm3/SEexnkRApDq
eeVnP4+jZue8BNgo9AdETlDEBR8ZFCscz5yWYuBhUpDrje5Yolu0xAZdFV1GVF52CBUODzXr
XNHZnyj/pg4/SLto8Z/yJ57bVaTlUP0GPlXR6QV4Xd2AyUJuYW4m0+6TRLvrwUF81oqLJzfg
CXZxsJ7P0YjqY3jn26kZf7ut5LcepltHvhCG5OMz/osQo0Xfdn7MkV54yzXYkQqQC0HameQA
NvGhf5gwGFTmTZ7swyA+mRuM6K8+tU6zr98TqbMszBpKQ0K+uRV2Xty2O95Md+G08qnXJrvy
76P5scd3XExh7wi2XYj7tprKyth3LwmFeu2lb/gayYyAWzoYKLK4dEw/thJoWALNdIXIXX5s
GBQG8XRcLYlq1eQ7wapGDohJ7n6anZwdQuGz7SVwv1dIRQ7rJVj4RE4AYfnaMi1dJ5UWRwD2
035RfY0mzp1iipdElRvjSQTp2E+t/s/R7g75Gol4zU/DXQ4SywQCR/sV8mbWOs1vwsEt7M8h
9djD0NmFk/MuxtO2ojaYfBe9xHNh9EEILKd0ykjX4R3Y2m60TfJP7+B3xQvwho8G1Z9uiM2p
clLBAZ/ujvQk+DFe+58C46zIev2XbksDLHet+WSsp1EpESJfsUQqI2E5wod0CR5X8rf06O9P
wM6AXZZtjCMBxWnrMn10HuuuBdzoavWygIrpTp4bBu5ItTrzkRJFohGiDG/80mnMRT/E244d
lvUGpcOy5letVUt83yEFQp0pMBZ0GJ+88ow0+9Dx6xGSQQhLcEePfmPS0Wh9NEMTqP2v488J
XsrisRfe4q4s2DugSuC/KUxsn+H3KduIDXQsnX4zIWmu/s0k8oyy12Resr+2s5wgHXCYgVOO
nTgMZCyjd+pVbY6OvllhHZCJzEAo26ujbam+ONAKvI77CIVSTKxTjGxwESG3+KeX3xwx4cqZ
Ql1m8i5ekTvidlOHVD0E8ItGZSiEFw+TQpYU5SN1+IROsP2SM1AUK99VODTjQJDHPbqCoUpi
ahJHb+jM0CbobXEJurdpAvuWPYr+T2cOJrrTx3CegFQMQY++8Kh0F7+B6Ua+MH9rshQSpmaC
4HUwx4JJN6Yn+8j6ZcMdrKBIdFSQgqKb2v8JNbFMGVh6o4HDqrlC9C5A4njDgzBIXy1LvCTW
lD/1iZwRpr86b+co8+VD6mfOIarXbW5WsSnwqIfK+c9QLRFfh3Lg3mFRLFpehe7ANNLSJus2
U3/3xs3pipqOrA3O2XVdDk9HQCk9hX75ytgTcC+//Wz+KNShsGURa3yNaAiB+Axs4oGaMUBi
WAQqeFalV/Qg/dYowmDQO4Hd2Rlt4OHusQ03x45xwpgQf+hXRrR3zwFCeQiYMwUNWuF4ZAqa
CxO8ho5nzaua2XskRCianTmLHi0ac+qB10521f4EmPeSWQQmKxLPzLNfivez0po2LHUpYCzJ
I9/mGol21Cc1Z0mu/xCZruRp1O3gHiJqxIYxnO3l8x6pUxgEq08sbA+ca7dJ3EWcfB11B2k9
4/HeRR/bComp4s1P1T71YUgA+dzpze6kM62JHSYPfgXlpVJfiPeO5avMGikunqS0SGm/DZ7i
ct3R+7Q25yvjHsjPukr3oV6rdPIwJEq0XN8qGCEJ45OdyNffr+saHzxl1mmT1Xebn0zn6igb
WseFY1lfzA8qaV4x2tttN3XfXM469INhHdK9ltZQ90DhRgXezS/Zv4XHIqE8xqFu0V3CH1oc
qy28lKHaA7T0v2PN/5dJsG6SYrjoh2Y9G/QUZFllHmUXtn3BfYkyV+IHKvDXN3wTMz1F9qIN
gAhGZ2nFeK8QwPDCkG2UqUr6cGsmSuvu87Pd2Emt9wDVRUnGW/hb70ii3/xmNGdWhVgw8K4E
g5H55zrpC99BXUk50Q1rG9h7RyG7u05o6bGM+VVOwcZ5wP+n4TWw0YZ7C6glxJv8jJjGATCv
s2nCcOFuPjqCpwlF3lTMpk9yE/2IcbCWqpmdOzibV1VvUtdJUig8sZCgVGHdnLDum1YeMLKK
4+icYp2Q8TKD8oGyxAYOBNc8E6rFe4BMBhGgmVw0ntSPM1aFky5wlo9ho2DKAIuOBEkJGyC7
Jrl9+1KBobguWURp6RGmQkKf4sY7iBX6EIK6U1sKks4/gKPF4atSzatMbAz3ZYXkh4ZzozcH
qZ8AvhMHrnpr6l7UVCxqfMdJ7JszibtnhY281Znq2DPZTPJIIiJ6OYBu3k0KeiCrzPN18Ybf
c5fChBDymwGoqu6X9OQeCgO3cpe0pheCIioktibQCVCOZ0SnnJDGLEELHNTb2wvZLixu1uv4
oLCHceU7ZYHmFEACfbej09VKDuGYJUrdxmh4boAYruQv4CUmZlzUtLRzdmrzbhJE0SLCDlyk
sR+GetAhJGsVA9YHG0OqH80INVzsFhNxFoKTYhSm/V5O8G4XJVxZ6f2JMbGed/E5ckZF8RGR
fjjR+ZR40l4iyQ5gvzvxrNsT0BKZcMKTA75Y5UxCgaA8KMciKptd3lPfUAKYmScR0GWOhq4A
ALVInnrCXZp4pA3jdDAxzcQ9rnDnrFIYyxEMlCjdCUhT3c0pPG+IcFNNM7KvwOM0n50aOY/r
UWwUn09J/POPx2s1h6r/HIb+LEg84VBe8AZlXYf9Q3o2Yl/MD2oZWfcoz6kvxm9LvhC7ZiE2
jIRFFkrPnKIqPgeypEyfnhUE3jcVQvYXRRH564hhi0N6uTJxNgQNcnzvJBABsVcfaxDgznwU
Rv2DBBBp/WVo4l1f6TinhfWbTjO7UO4okg7DZ1BESzAljiscx2+wQvHGmJG8ANdPn0OYEqFT
i7pJuDakS9qTFszuMuBAk8ZfPxUcs0qrjQuA3RLusa1UlCHNClvCIhdBPx4L2ao2j+WTOrbP
JN29hIZenD/Azj1mJFZ9Nx+y0vYv/Ynu8FF+3O7ZuvxulhYUGD9rFfjORQvycIoFGXBJBc8y
E/f7XSo6GE7QSXhJb+BVegWjDBsOmhxsEKuAl5EjWlN/uwa/6nyvXJ+qkxtjb0XiXXVmS+Tn
+wPb4frOP6FjcSbWLTu1XQE9Xg+LAC5dj0e4zmM50KKIzA3QIcbQkF34qdP5SOdFoAPPcQWN
RXnubQh2jh8i+KBQaa+kmo2iMllfXc55FrSFVVbEoLOMooLMWtyMNls9+hPS2ytHSmOHkUfO
8bZSa9r4iGX0BBLe7udOJhafj8SMIIBCBP3hhM3V1TBv5RqbgnGGFGgY1jWK6P6U6hrERIHu
o3lHnqX5W6XSD7/JzJeT4EqNXmHEdYnsXcO8EFi2K8Jg5FESid074hgSxKJL0WCA3o/KCmn4
0U4dmvJmi2l4UBEKG6CzhqGIjGU05VTaeYqdNYJJgVeXp7wANchIpBlVDEQmEU9P+plGowP4
+e0Z+ypEe6e2VqZ9UrChe0jXPFBwF20J4PyCk/+Q2I8fnRC3W+napMwAvX7EaV2rSG7d4UP9
72nOSr3FgPbhno1obNRnO5pPKu517JJvhFwqLRBzUR8kKHG0ekn5sPgeND+MzIon/k/lCyHu
QMJYAnCY52qtHh3fXeD3LJiooH4Bql7GInS/oi3YoAlaaKuUVVztN83Jh0txVEhEHvPtcIg+
fiWtEdR0q4mBF/CjaE1kN4AqdQbDSeYf8hBa1M5ZjKPmcyjtnegnNPgw2Z7tnQSGRSQvclnr
/JOVMw7fk6sCPksBEfTxfjqLIIxqr6S2EywSau36RDuJ5ga1PerZfwp6k27YGjqBZrgf8HbK
gg2lTRDzDhXb4r5/4bqgOzhGjobWcI4DtolQjNMZBFA6CaR3Enh0wC76wrVPF/pDTjAAOsft
sJz78F+EDBK1Qn3PGLATbSSi9Ja7eytm2n+Bj6zDno8qXWRQkBxuK1vMAjkmUFNEceQtfsHj
Akfm51LzHp3Oj/XhIRnYZ81V3TazMgd12yGmWO8K8gXpBKiEtKCfu3hS3aURJEBzWMV/l1Zc
AKnyyuw3/KlKEMunneEMbqB4jQ8puh6XE3qU21FjcJbyBUQAePyVmQqyIy/vRAFHdvFndWSi
4uh6YfKRoQ4o5GUNTl25mRjpCbEImaaN2AK+7puxkDo8EPmL/rjFePdELsXAJWPeP62VR57V
NMyqexRKwf/9EHfexeBKHXYavwaOdOWiREHv/ZIEsyzNY4txsY+laeqmxmFY/SQd/AYiOsh7
G2VFMQGptrMxi567OmjZz+VzRlu3Ki4nl2dtJ5LgQcu9yCVsnrZFCiL43zBasVzL9dAVDRyk
8X1zKSyptQbb8VcbplBoL+4b+jyXIhgOPkfr0D8Fxe48ZznViVKCRR3/C3j35/DI90RSg4qA
/eZnfKFwjm/CU6FOqhopLk6Zh8UguI6kDbGyXv1+wDCFgWwaF5AT1GMz9mtZkxjRvynOqe/r
G4Bp7pEm0q5KzjtO1LqHYMwGpQfUJQK46EusQWykVu3QlIVirhZNP0fox+iY57xlU1tjaHZa
SmK6oxkZ1xf4zpxM6ovTfBRhUAtDSjCujLn5ZzdEi5MSVzAKIUd9TVnB9hwwZpA1QI6OBuMQ
XOS7KX3eVuAjNebYEzmc89yduucQ2kuoNUk4+uVXP2bQjeUAMmzXklX0thh/9NVNAAi+HbkE
z/s3ZrVuvtz3djSgujYXxaJ/GYFjehfGtLTHY/zwvQo7YGUFVv3q9pXvj0WCp8PqSFcnCkSv
qesUaNX6iuWdOWfB4q4Jua6Fm4ANcOiEH5sHxCOUfofskMpALqbc02diWASenFFhRCzd9iFX
Jh9+WczW2FCPXzel+sqYSdipdEDLq+0Bp22VoDTnQ6+cTOFdpDCy1NTdvgsdHorvdyPSZayj
R/AwexbtkJYHnevdfU78XhNbpb4pkfwyAyLps+WR/hKQhxQvP8j6cWP8EywCP0ZqH2MkligR
vmWAGwqiDNChjrgNAZld5V7uAnNEPYYVComXErNFGEyGG8ehNT/LSc+r3V06/bkCo3Sf/sa+
dkpS1HRmPh1FstYEoyMCIGHimTGIfwegp82mNH+VCNsOtlJhmbtf5J2jBEcQ8YeP11BCBf0l
Qfuw/244MmwE+sQ2uFo/aa0lyQaSHD+U1Y85vKNRPM/frhgC1qzNceiyaOTU3GpUFrI/QF8P
VMh2tiCwVhYUn6wEbz7rNvCRw/lj61HS3dcHWJd8zJLL/oViX3nFZ/o3kwxOvpunZdcxXQ3+
4rpasSneDFw3p/I+k0wLFbebdRwVZPveylHcIQ/pMuud83btE0cUr2DwG7J9ExdIGgeJFMbu
K2+/vwFZrKX/s7IKGP1Z6LV0TPadonu4ofU8SDqVUjvsXtu1Z6LmSJflCMO3CFYCCXhH5BxG
9Xv1brDydKKdpOgEtd2j0AujVAfk0W44yOccgAMIYXQQUTzfH/99pOGoKMCa+NzTHYhpU9XC
CYKhP6vXaSReNvTZ0/OZ2ezzOrKPtxMfE4ncn2JuM0EN3vCrJhUVuHvzzwt9jocmP9XSRdsX
ATwEpCmadavf9xG+HNdYPJmTpXbLS/p5SEaoet2T0ihKgofaDx90GjnITYQjd9zU0hCXiR5S
QfVp/WDVfj7vWEKhGdPp+ttt7WClIO+ZY0LMt8E+6nCAmz2vLBLoVxURlm6N2S7NtMk1F1Pa
dWkZQTfyCf1nI4qV/uEhKZeGfGERHFhsM5jR2Ue4Yc/eaoNNW3J7BKSSmxTPDG/uAsj7NuvS
Hkf0Qw0HGve8hlitxiK1Z4P3Jqy1qV/Vaw/FBQWevEndaumMRhxfZEsKo9QIiEIWEgeW1Gxz
Xcl9ZkH4NPBrFi2UEYvO+UpmRQXpC/OiDNLAZTSbLcmHHGcT4/LOPK6YW5KNjdwxqWNwoav2
9INK/vS97qd8aGWI/OMIU66ewu9taKAlnQ+i7dqFYN6aDPkEnIv98cfjkoBgKOIry2gclPQj
7wCCGImP31c8gOCCqSWvrQCYm/U2vCUoIpk1vmGP8XJ6rUWwwVb25mowZpXMqAKg73MgtYBS
HW1/GN57nSfOIVvPV/aZH5B+Z5QYeyQjmjZc20iQ2YLKgNqJDNsUwDPsKBOAoeU7z2n8Cr4S
d9lbck3zfU8m3qZ0GgTqZqTjwrAxNhwaUdIPS/7botisWlGoAf/9DEeNx/kP2O+dcXYoLRC8
SufOBSkz4G5D0G9LydfGqvBR/wZR2LMfjFpLW/bYkozd6cLsT4v/e/oMHRbWVX38lmBEb2+3
ko09EGPP4rYZgkm6RWeu8hIsKsPnAoskyUzNgbN74bYuyNWAo3pHnUfMGLRLESylm6OHJFF8
2qrnJSxv6tOsi0O97xMhCLe7IM3+Rn3T0/vKP/IGIjlkI6/CqzE4apQmG/iQ01tlJwRyna2w
O61arAKwSh1kzZpDxniTsDsv/GMn2boHV4OhId6I235tSURHHi/MuOfDuXwCRvQSEMN1Dolz
axzz7EI6au5YDv298XVc8rFYGdhGMZn7fTZxLrsvtJvrONfUPo2Pw9eaVZguZQYGA++r60tl
RlQU6anpyJ7p/uI4tVraiG1HDnYlzbMHtE4jTCN8qdQpP8kTXlGevdqQOYvOXRERFyx8hk2l
AehfhIkMkTRH0wjuaxWaJyeN7uKxSU11oHCk82kMr3o34t0RUH0eCz9m+ASUslfwGmGBjhSe
DaGkoDV94OAGRXpjFpLnXbGZgBNsj+CWpyTkk14Sy8cMY/wL07JP7ztxAN5p8LQP8Nj83IMN
MGGAVF2sjsbjDRo33j3fuszwaAqqWVvzvZ9ptarMVTDZKtT10C0TLUee4k8l37cKiKhSw3xQ
sa7djNw4/6oawzC9LZCEZvMfI+MbNA2sUvEKfAhcY4g86QOJDCg+WppRaMX+n/7jd0KFg2OE
uvfy/zjHA+vSFLdrUIFhPPenALd+uoVbQIkIJqPaZw/cLx5Tb31rXgZX39iE4P95t6+luuLK
nt7rSv7oKaK9bZtX3rER+i7oTtNydRJW6/k4zjBcvDpA7/LMEZhhGsER4d2y44EJjlxtl0Kd
NsbbUKnxle3VNoxGFVEYVq3sNpLl2je6yKhhTx5fKFYgCXUn9SZzkVCqPYkghXf6zVUmKcmj
Q74HWW7go0hdUPFSHyLJ9Fd2HjUkVfa81sroPznxFKg0CHhQ0tuU3+Kv1nRsJ7OsUDRgdyfR
6pARKManISVY+zsk7vOhhUfyQwjysuJi/59F/gThYZtfyglvRtXPPD25hh/C88uCOnnRN9qL
YzqeVdUZtJVbLVbW3mM+h7cksjUecMSPYCL8qHEqHbEGYrvyTQPmmU6k6uSeviRIQkNbDIrj
kzLUk5/iSmPwR5GEWulJaDE/Xj7nmLob97dIG0bh8veTddVFq2AwNA/SGf9XDBSReQ8o5RDy
9yOP93lB1wRA6n0X8gmCiXl7pMoMvYMQ4cl2QU1y6eQJ6uR12bdp5w9LL7QbUGqkIA8FAAq6
06qc4rzJRmuYKbDOBKjyCWiW9nIB+B1TNEm0qWLvJZ0aWAyEWDoO2NQM38vjr2dxfd9cvEwm
ohobSk4neI75jll/vGW+CRVnxERCxxQSQzSlrUwBcw41zFYqgqFflO80fQz6HT+7uaXXgIbC
G1YxAD7xe73UdMzGzWKNgwHq3QVSCxUk9GJcaFr83A3nSbaU97kzXBhSGdFn4WqGDdGjf0as
jTZi7IZHf+J9bE/wd3i38ojB06Jkr3rtkYEvxjIYciHfsC2Zp6O4IYeZVkDMW8luYY1rKJW7
TCgbLQrt6zG9S+p4meIwhmVWnjbhpqt+YwHWpyYdn1xrJjFwzn9mkvLzD1HzrdxBqXShYiA/
QjEN2yUFs7k20JplvfB2znxUHzIkAkMkPsPgwP6HwHmbYf6AMZrqyXgg3MlUjxMXyEfP1qtg
i+kqJsAGaISoBgaqnuR1iK8gHGgaHSItFP5H6RPIc4xlr4mhA8P/g64JOui6wW8u2kM+xE4X
liS9zJw61CyznUQtstHC9Jg5wl0Kt1xNjaVKpu/ah2wp4qttCSY+iszIhZ31btdUUVot1LSo
DrTY8r4GP6XMwSUNNK/m29KPSU7rXNf2vrF0yMTYn0ON8xUt2ckkyHWgSVGvlf1bFs7u69X5
7JcgrTswKnqGxJJknUX2EQYa+nYQZgFIrKARIertgFru1p/IPLBBkn/sSktbL2XxQZrs2MKY
gypUtz+P30tJ6aH7/aE5CCl8CRFPSRWMvvAPDImOFjK/0sWXdUAIs/RhYRsetYdqskLuYo39
j0otYqw4jteCqoe6fpVxe7x/gsNCdmCP7lAr1SczJY/dwN82EBnvHezKfNtNeNRc5KlGWfKQ
6kvZBu0Kkni5KQhAzo8KKs1Qonfrsf4GdWhA1256okpkk2svTzwBx+MTztZhZ9OaOW+cKDiH
eKXVXslzIbbgXTBt8p6SVQBlSNZgFvX0dcnHewiNXI3Qxl36bd3/nsGXQvS2Isv/c40J5soN
hJfpqBiQX27L7oA40O20m4MgqI/9ehW9lwyjUlW0WAF5VfO7TiC3HjceKbfeG5GD8gylbl3c
no10ZUI0k7Zgv0MYMXUmHNVHv3GOTyGKNSof1IKn1pr3zURwxTUyk9yu6U2gnMztXodQlm3a
7eJTRZFbAI8Bqfa1EkWTGxgQ7geRZY0uwpt0OrrUeE8GLYkld3yL6/IvNAEVlpDUzaLSKczt
HIMiudItO2RmC3YFfkcJwdk+BCNGX3ehCw6jWM+SYrrS3fYnXzZDBBqtllC4wvIM8F9YbD8z
h0cu8YGL7AktqEYeK52BgdKnemuFPaWXo2IYQdmXB3Z1dFPGR4KWPcmz/8cMUJf1pkr/Hlrx
RDQoJLdGjHPcvjvfaNaVTltPRvaNFFuVBdDp9Y4RlTBNYhxhn9h7jQeHkjhpw6tl+0CkFydx
SO6ZMgHL57baeWp5Xk9GN9XKoozeYDdTs4NAHb1eh4sOYoXN/1B8LKxEDlR5WAKiTW9vlgKn
maQ/vLw+SMc3GMkrIww+lL6IjqBDsd9te3Rn5iSuf9SyeGcur2oJMrP4h9ZA62zbvwW1LmAu
CesI1XI/kH4kcG7QROiVhsIPdQvaHzpJVl99xn1AXLSRA5+wGzJidJC9ciQxfQOPN2K18OAs
yShWPushABEat2j3DM9zmXTjnHqD8IP97qhOJSETjEWo8+sC25LIR1dLBSucFpeKmiF/ZStI
RbnSyFPgCQ6IdIdZQsGGSK8p2mgQMwXNa8385bdQGIs8pLGVUKiBKJYAl5TcEEJeL5orF0qo
urZHU51wjgJKIAwTvJ00CJfEiJztZwfoSAVvaE31MvFvsMhm9Y0qjrykqNL8E4234MmzF35g
8Ebf3LGKljY2j920U0xBi2mt04Wsnx5A5H1wjQ3kp+07Y/RQT+2FDijWCkL25PqrQfaU7rhe
SvrsJXtw2Z0E4DLA8XjRWPxyMtWOpFnyc6D5evXKuz7yzsSlnYwu+oMjkWfwBWoKsEWSzHH2
PkfKx5/SZP8kqyeIHSOqsAMet/+ickLC/WdfR3/7mM1J/LzIcL4pyx82kExaixxW1zjhHb4F
92/JV/ZyQHMv4KcgmuwJtjeQPPMif0AOm32d/1ljVNndivNTc4HFQQP3hj1P+ocjywwlsYLA
FXxwDWDp7mnXxiyXXnQFttQlBk5KocQH2wnWb6FbfAFr3iHWU+yGLnLt4skZ0sDd1JqPCOjA
wqCGVbXKkKyZ+KreKCDvY663dTjTuZWVa4kIwM+Jtob3MhT0RS/NRhjdz3DEOsjVeUhQgDGp
N+JZen2W9mzSMvJHyk/0h032FMjpyR+fSlooQIKkafQcx5cwpE8CTmBKD4hrctw+Ll+Kry0F
VZRRWF2YtXTaWfPLbGcxFR5y2CaCT8lHcPJJi7anZil/K+jtPFZYxCLYWrjH6/TpF/02P3L7
oaFZP+ofz7RVL3uK8r6TQheAncbuS73ap6l0EykvF2eIzVnV9hMw/dXSrxqx5OSb/oAhx2df
UlDmglvc7D20kvhY/frSKpzr74WUgEf5okIMaJKtsEDwmfypHxbuc8MNJvZNFogwr3rCYCRd
xxGl7DZxjvYZ+CtrcO5XemD45jzuwf0nlK0klPhp6rEhwykvYQ4fB4n36HJZw9ikUVyPj02Y
g+6jytTNa+hSLI4xN9N7vb1URcWSickOCEWKMJaed4HqmtZKALZQ96QnFsD8ztjXlEY3nLNk
o7qtpK8nGLSvkcBsCTxj29xkYBUFzzpaLYVgZPDNVkSxmHdrSvl057N9PIh9T00nr3jqVNRo
m7+ZYYB3Twv7BaKC2w6myfMlkWdkN8TA9OJ3eWsYlzl7enTWEkPoa6b4dfeQRZLzo0xeOafw
nGx1WmQcd7j3B9CJqM8t/bws6nEFtyudSMgaS3cZ+6ybt0OqzP0j66Q3DoTnKUxV39qJGDjn
tpLbBoAgXqYrdnsk+ApZHBNoHEXf1w655P7cWBazUsctBDJsgEEouBQnNbjI432FtlCQrv+V
UR0wVWNSQX+84nFqpSMkbV4lKqXgoSEzXGsJ2cCROXV10NZd5/JYXyMqwxnNkGNCtpgG1FhG
6+zuRez1L2O4mH3nGxD6gOsvgKZ+jD9FJ5tJ1/IOhmlT8edz7XSYp82Db0z90/SDz+YntIuS
kPtlr9vMBxhDv2/6TZe8gFhftrowcHDq5c6hTN84xUWZZLHiwW9kg//fa1/Y/Jooo6z9aJeC
Xz/JV1akWUnONv5nPgd+auMe+nnth6BW4/ZmaXtjYeKBHmGed0SCt0xNUtpYswVBw7X8D0Iy
k12QDw1ZwAvmbTRm9pWMqnEx2Isue/gAGINl7QpshQ3iAf7XP0a5H/El0v28eRKlplDHnK46
OkTfz3CGREM7LLKrx+zvzc6rxgA1f7Lgoniq7za8ZZr80c4D/LMt6brfqt9bVIeKIcpgAh3t
uOPYUXIhhSuyFAJ6otWR3X4qhAs+CyClEsqXlDWmagOsgvPM6liuJG7wm4O1+BjnKgX7HmoM
y3M/JC9PmPSPibsNWSzOqo9exOkGKzcmAm8MQ9mGGWujWzs+RqDql+jLme5Y9ZZ7gXcU5SC9
yyRsEoAGA3/ouw3f08lIoYd/tn40AhFWKMNLgNyS9Cw72CdPTlHYyNcSMKJypUPdp4SK2saW
FK9mofUeTyOuwJK06C4kK9VebgvDYLi9+fEgRCdkCA2ah9ur/+SUfBYW+zUfxyLwX4ceOIHq
t96fkePjJJRFtwB4X0A0uVSG7pPHaGDxiOQEQEu+O8RK5u9g3xbtHw63ZdjAzisuF+QD4cxa
Y7KqtHMQ7vA6PB+acG6/Hk8ZZrez3Ktlo2GnJhc4ywY+XB/LgadhX+ldCb9AIqKRizBTm2ct
OYtZXRr77EEimzpd8mupv7/ur4pxJZ24dI38e/0G0mFGfeNSxXyaJqnO+Iy39n3tTw+kzXeZ
iul4lz0RjROQw9uol4jp4qa3ODM1NIqgEMOf9fEgWaTOv/bYQPmXMts5IpBxCmVGYhSnIvSt
M+4N4Z7MiMXQeVdoUYwJddSGT5My03JDzAfFB4Wl7FZ9bMCLqyJQmjY2N1GGZ6pOOrUUe2xm
5W8GEwdY6OVNutQREbGl9U6Js4sXiJ/SpZEEV40c1ae/VV5fc/qKYOa1+Ejqbg2/Y0fTndeZ
WYa7q1vzXSeGzticQCZlpl0ZMIivdJk0Q4okwKdK6bzaUYSPYv+WBlnjFRg62+GTmUWcGj9O
/CB2GbI5eLXNJRKA/D5Oaox1EFFFb79AtfO2tqOYB8dvvwv9NNN5jVnA1N6gAfHF3dYRQCe+
tQNIP7Mzv18NV3v1b10RCJlIS0VBUNm96c26ebL6YKseJNKPr8ZQsidNVx5Cu3ZMgtU6Qgps
Epxap0N7OA8+sX3S5oUAK13JXmdUK8u3jO0/OCE4oXGCc7hlOuLF2R43kqyBjxv0igN0JuM8
iZokdkEWxpGDemq1l34daeZWNk/HWCVtCFcIEoVkNP3cZpPI0sD21pf8QrtezEz2Aov4kiNP
UnhOQwCWBXI+6ZCkmChW6/oUK52wQvss7cZnbH1vi65GhUsv2EOrnPW/QnSJCWFL0atc3qsG
donTHSgBK2IEk3wFB2HhEGF8WGvoc6C4Kud1dvq2qv2DCE/Nhnvh+wAmnJ/TCGTtawh8i3kN
imH+/9QTqUcDrlSTvYWy7+5PMAUmvRV6NMttxWDJHpaRVIwTjwcffwgovKm3t3gRz1oxTDoO
oTAoqxkQ9OeAk08gGeGTxg0n0as2C3n84TUR8qNNWXkDDPiP6Rn4Vg5/xBKhf3FkqWJgRDvS
Dh2VAZ7RdddWMrfnYkZDBjDAim6B/xUS99eiTtyPSMLKHTruuayMr7nv07O+rGvLpIW24b6o
NcoMAl6fc3RizBlJNv8FCHaRy6cn0EwxkmaZc28ZbqgRryEse0QFaz78s3yV2e0Fm15kRGr4
ovJnFpZ4iV+dLIImQXBXtuLt7joY5fI9uhAFKsAQrF/xT+VGugq4P8SgW2VIY3/y/vRfxKlM
RzTSg0sW+fonaU7Vrbb8D6bgpFquNIzdwTLPu7T8v93mnAVxdHonOZ3YT7Dojh16ciCNfIGd
D8YbkQIaWrdlTNe18sGUVhqXTUbbeMxsXvLCIQ2ONEybrJC2gx714zuwEdLoXziGETjay6zc
fOavIbTZljxJdsCwfrQacafWRs5UBD9LcShI49COgIby+0+2OgK9KOX/pJtxj8lDyBiHJUAj
hyAsCriuyLNK53ONotgezGlrt7yVHyw4leRz5ZElnKQ3N9tsLkWYRMyU775fHSw+lKABk4aF
fUhznmt4VbVaookqiLJ15LZjYP+KnSDBu4r/z6ZxendV0wPopgVEsdipru/SwAhjwG8uNYPY
ySM9IR2981rsMN+NZlEhZ8TjzrkQGi0ZTRVK/cv0E3YiB5yV03VsgLIsxP7dtr9dq2t0fUtA
BMK+Qb/Jhe2yCCbfOypD19G/eXbVLo6AJzCiDJShBoFHiJSdH1VCYW+Pi4g8gg9lSmfYY6a0
jJh44SCr4+39Wjl9BpmHK3Y+5dYsZhQO1jV6S0rXl9qK/RamBjhap0yYLe/uR44blTBLajBj
hc4Z+t50sXRdw17pkm+0fGl1rOoP4rwUa3PJNaYId2d1MhMtWXKoRfDXECbUTYdjvDhKj3dv
B5BLNPNvG3m3oJM3XZu5I0H4Gs12nI5+/2umFYtEXI+8CjEKD5wxj4c2kARFJaD2lCmK8FCi
YLKns0DWKj58G5AfdRZXUqpcY/ckLt7LG0GHkIsaxS6+OevPK2FG0X0/cWUiBn57ubiIl3t7
Q9woMcoRMWDxHeFhuw4pYG8+opyrogisFU/enl1ZOX5NmvUsTjNY2YPJCpJhIipzujZeUxPD
T/jVSQXQrNygCSetOdXms8tgr2aXYTvu7GmpdgpSpmAa9ThBQAX5b/3YfXDKZZY+wkI78C/A
qiICNomxH8CIvdaW4m1Tn33sfket9e5/9Nz0wut5grYVN8a4iZp09GfEk1iEVa5QHVoUQw8S
9eXozkUNSSoAmwk1W8yLFUmYzj2QVk8c7Lj/RSTvfBoe75bYEZBcLUKecPmZXmm+ZpetTBLh
VwHhLuUcACCW735vmIC61aSFJTNsAZzopaebzjRLDmn2ZqREWWcpP2DaS5Fr32wNz8Gqfqpm
m3XAABPV4p5yOElVAV3fdTHWfWW5cBMi3yN7vd3snAmZ21PL4/jnJM0K2wS2xvJGXl5GrOcc
zdiYiQNOWefon9zGpQLq6VmCwLil/apCImObJx2IceYFl2/juxiRse9ngjrbKj3NvXGbe45g
HBVvgXmcw+bktaSNx7sFdg+3vpnvTFxejl3RCPSsN1DLH5GaJ8EUjw/DaXQrb6C1avj66oi6
x4GxBytMHVNB2vQLCxna9eqKANFUgnFXG8zVBq8zNrDowUCj8no28ylmO7ngznfdbHrjriOX
uIkQsit6tnDN3XlSUm95Uuzwcu11LRrzklhb4xaPN76AV9LjuQqpfVIAcl1D1Q0dpCG/FQsh
jm9DCyhHrtKVSWdJKhf0wIoMCpWNBlJ/tOMRiMHgRL4PP2FY05vAoqAcs4P//Ywsa1UtLCGA
IplIPDSTkF1vWIgx49nNTE0gm1PdUgc/8UtUpMIXquPMPqblhK2eITNyVz4Avj+PlK6Wc18i
japvpNeFtSZGOUQ2bWPuj1kgJBtziUhN4zxeVk9Z3GmElcMIVIak1dlUUBvB7pbpXZZSveBb
UzSguhcEqfq7HBQxVZYF9mvXN6jSXjsp1vMDDXTCTqmFaHL/fXW3g68N+16YVgMyETC8xtx+
PmC06fb1uy+xtF5P5c+rwIA5vZ9NoFdi+BRY5jX8VkPigIb13bwtlaJ9i6AgYZqRJubaFbDZ
3hHBfcnsK8XhE0r/agL2PQZ8k57VVhtyztnclRYX2BR0WPumBSw/S4+1wjV3VsgUcyFHia+E
MzhdtuvzMesV1PAsdlkFEWTAOfdx3Z45yC992baln5ttrtUXF4BdHXuFUTx18klEhgXWimCX
0WU4lS74ZLWugyDiUhicvThZaKdQ1SewqMAFPMJNIE7mBsPgNWYZLiXuGZOM+Gh4tNP7X3kd
UWq6FGmRcfVgEj5ELeSDZNoBcj1/bAEvk/P6K9RyXuexST9ya4RcJ7ag/zgtYSEUuJ+SPLlf
doB+P7+glnSdvDpEe5cs2+74+11dWZ/gJ1aRntPJ3gN0KofaNjl5QJ9d/cioqNKAJ6v1L1IF
0qThY6fM0+/3BlytlPsaTTELiJoXSefhGd1wzdfAlX+EabxCQA/dsgUN6OKqVS0zRGn1rr9Q
GZ3XYc1apbxaSU5qeuPbHKsXSecWvb5FZosOKxxTswdTh4hdEKYXAl8jKmPPaPhqKGGK9jQU
lO6PIZH+miIyOBhRFzduw6jZkAU19cWqUd25LTEck7NuRhK5GCDSbZQutgf35BEup3ZdZCIU
t/0X/9Zp5eBoxSKNcO6LtExtofyRbBwpzZjaGmHIzZVrxami47+PeWb5jQEPoHdWTKZFZtpW
MAT01cDMYhk/n0R9V5rjCN3ThdKpw6cdJiXHg42quYmtcuztVaPzqr4S9kODdCOXsJxs8vrR
+TybYnu16X/14A01Is8c9eNmYUSkCpQYZZXqnkMF6h/Bhkh9xF6R1nnTY44UpYazVE+cGRF4
VPOs4XQ+jzc4vbvrTGk6bsCa4Vh2vuB5U2MI2IO4sNxuNBwVAxsitgV3IBogQj4CM4LCHkzD
Zw3u1zUkhrSymAwp0CpH52KI/IZT63J8rtr9PEoB47tF7Zl51ZeYpjMJNtbrpZpHxV7/RwbH
ujNBOI/ipgOhJYAKcIR40TtGZ8uGT3bTIXeA8EP9fS4Yt3G8ggjidm5Xz1LRagEfr2rimZ+2
NLTSo9EIRshxmbZKvEHBYJDDfKmB6EwXQcol0uhAaG24PjaP7hNp7WEWCqtVPVWI3cVFFdna
nJtSuGpUgueu9HzkU7r1YaKIbSftdNNZYioRsedj4GVMW1bGFPJzbZ7bkWTzArGUZggb9sCb
IR25cbV49atCylarM9n4+r9CChsn4b70N4RQbp8UuQd1aXsGJYpMwfO4vsW+DqxYaqOYsrOZ
n0r4jiiRMrBIpvCTCecDNKoqv2YcF1Xr8unbnXmlzwOcJMz/3Ek/W6Gjv3ziz9XsfJP+3HAE
zP5JTeYOC/DEwwisHOqmRXbng4Qe/x1Y09zh0BBGVLv2m2/QrFS2kzqYctgTp0wA9/oci4e2
2C8jbxRZMo5i6Y1idcSqr+jZq15jqG7ezcdxbL1mVhB+/aEGQh6NFoNqokh6hPWdLm+Dbhth
BoLXUrMCvEmGjGR3iEEX+nnYlbSGC0spn8g+EoGUKgpdEP0QSTqsDAyDWRpecD6AcBi1PlRP
BbP+m0SEZyN8VxuoyiTkhxYYDuJmtxKxQLbyRng4YM7eXvhOIU47xbwstweP1omoMECdMLCE
DjYg7dDUlPgrlKKgawzNzqConBoUTAuFC84FSSUFvOY2s21jnruqLF+oaRm5SxPK7pdQrAZT
L1uGVbk/wX94a3t3hQATnKLuCui349DzdnRYWx9FPZaT59A4tQ8E2SR74feevNTJHJHcCKD5
g57JwcVm1XJqkpILtV465tyKUZvwx7xAE9ubwrudUCq1u1mdc+FTtalj5Mrx7PXSxqXAIh7h
6bULEEit3+s+Xe6rjm5fzxZObUjdCYE1gY3u6a00IUPFua5TPk+b3ICCvepFt28e30PDd0vL
eKqPlsTlYXe3GFMsivNyAh6qy7LuKC1XY3dn80+QhdY+19VcXYcaz8CUkVVyY4CxrH8lI2tI
mZv81SlkxR3+t6epPQ7ahAz1DlkaWQyV3Z8F+Ww/LQjaYaZh2D4b5YG/n8phYuIc1GixdpFC
e0xzFVcKb4X+gILxUJP8j2aNM/r/RMAGQkosR2Cfbgqq5YeSdGCpEKa6o04i5JsHodd7Dadz
51JbSa3PxSPFVa7GGixVLj4JUMBzYrS0JG/FRzsy2FG/SUm3MdYVOl09v+ZgY0BqYma+lfAs
QbbpgUY6r/NPtR49oZ/4UrxisIsh/X6mZ0bTllUYMurm7kb9+YXrr8SSncNtXlNxId5AqNi3
tA1i86e7z8yuTkgw9h3iUR128EvOAlHRk98I75zc2D3i6nRRcHKffm4aX683Qbj6ef5GExaR
NyCicM98LI3QVzJCTUtacH2r6iLa8mWTjN/S+QCjVeqXRjAYJKW/GhK25by5ndl2GtSfJATv
DvqHQEAa4OeKmKdHkW12fnIPGE3xNH/QbJF08tQKETNrIfYuyht97W+hlluLsleB1RNXd2/C
ODxDVLbQ1pNmXZnyd7HwOyAI1Hn2WwgKMY3bZPJBfqiahkb/PzGyIKNNnqlSscIfXkVJI7aT
XwHHEOCqCoYYE96xUzcFVImy5VBVYcN8F5wPA844lnx8ffG1ZdvDyemAbylSi5llx3U4YmGJ
knhgsFDV/BGpSYqmSY+3MYckvg1fzgaJpk9z66xasLcg22hH87e1NjQkXRlSgxbIkY7eYw9x
4dwEX+mykXdXFc3CyzZxPIwM1fBvMABeHsaAnUsvdWOhOTm7XlbNUZVLBa+D14GUNMl393BX
HQ0hg6hCAowVTGSb56ctr4a8dI2ldcMdZmf3dRvG16weLC4PoJa9WxijQs1HdGhoSYCNWRLA
y7kqaDc/46z8oAo2nT0eF1cnymDgaUVNPP6ijuj446HAf2E6ATz0igfBpTxQc3YeZrX86o5s
glhGD3+UdGk0yjcuWWKTLhOZBVzB2A7rURHKdP/ouQMsWfWbIwOzJmLXKtIUx2C8uQqn31O+
iROM9hKzn1aP/UejWEtXaZ+4ZkjOwwFhWvy1XH3VNFdsbAhT01IbTKF/PyDYn8IEP+AS/7UB
FwrXKRhqqOid1B8IXDQc4yNluU+LogJhqN/pm3eDyvmbY7iNsrfKHvzv4c5ujKh9RlwRB4qH
2NUETXzSZyaSQgAWn49kePsQSIZLlUfv5gUU3iuzum7a1WbxUcR3vB/7TZtkCM8YcT1QOGM1
GEbCPOV+E67oC5N0wKVQfsJFYNnx9nkIkrQRiN2dsvICCX9MnhENePsAWVCtWDHKObcY2kYj
3+sJzYveQ3gpIA8KiInWsVgFggcCnLcXAPvWWjzk5vZx/KXjPs/dqjTDBQj7zEGoTtl5druu
zegv22BrV5/3zt3O9D4fkpj1HZDqbNfXfnDXZ/O3uarVuvVolqo8a2X+sXd9hU5gOp99gT/j
mAh2RYYa11OiTiZKs8l2t24jgiZe3oRuwdFP8jEAwA/tfeK5xFJfFKmFfhDASTyEismY+MUj
IVcIbXCJ3K6h+3mdFsUOYKO0UjUQHhZA7Dwm1GKPVmVGy+5HgwdBuvF2dyPj0w0QMCAYavCx
LrqrHGkJh82afO0/g0dwqkQt4O4LbdfOOhHK8uLYCC6ety6Om2gECWgBXDBYI3QddaN7Zppa
iJe28tmoODL0RwTrkRw3HEsKymupNn8VhzZeTsYAyc3U3+rxtQe4KuYe7vpks0w9ylJ81bkd
dOLFhSdQJ348T7iUCBTHRndv636sZK2kgQ9bHWPr+A0BVT4zD7ncLrIAwQOZ+4RmC8E6f3Am
nZYknpqYxEZ1CmVOSKRosqDmclMwDxtw7MuAoZfcrqV3eYuNTe89+aZz+dD4E/pmE3BlO2Xe
ZFSFNd2jxHrjMAJmT4I91IUr13wxgBn2XOJ1bxkPeebJtRunNfnRic1up1panXkaC56r2KDt
OgcCfuhgR5ASxyE5rOGO6cXgGdjbIffgpCs1iWd4TypDirArfu1SOd7w2T2zYGjcICUijrRi
5FlkRhsum46wgukX1YZXISAlOuAmt8bWratYn3T3/OcSBMl1L/bqwSDACGxlFGfUzljbM5tB
OsDMj6qh1o2oaGcnzhV9/uYoH8xQl1sn1J9GhEPCLanB6DiJ1nMcLoXYIhEl+olTvuGuC8EB
502yKLWX6/iZMz1agQ2SOxmBr6TIsPEXfunFlpQ7OtPZosJUB2atQvpkwGA7zqoOkX80lQ0h
BttEACCYcw369qT1Ms9k4MHDkErarsxQz/h+c46i3xevgN/43RfFJP+fCjxQPSL1/hK7sXhD
oLJYAlle4bi4kLL0Ap7gJC5PFXq8DwlEAD7SGcqcYrGHnnl6hPQYMQxOwy8BR5mkhgg1dVdw
5kOrIXQqE+anEZ53+JNcsuAdVQzwQzI6h4eMThTraDhm6aVbRjtfqR+6QnR/X7989DJDi2HM
KUX1of8tuzeD2NyGmRZMaTIH1Y95UKyzz1OVCF5AR4yguexlpccH9vhcppSb3lEVIKn5827B
IyhuRu9fIeRxEjLAbPCjV0ruFZyvNWbLPat04IW1+/0HOrXWeiFVyri2vqWcFPAUEHDLDhl8
737d2zEPm+Vlw4n7LaHSBYJWtkZd5VSkuHqt4WiR0xJXpDWxQbtLr6S+ogJCG3dYgKim/LXW
bGp3PzWtmfuH54qql6eWO1Jr9A04mPRlT/uk+JcCSq0wzkLyMPNo5RpehQhhOxs2G3nOoWU4
/j0IslZhjHx1a8iFaq3Pbv2eloG5dwqn10LpVNPuwtUbt4Uu+FC0b9lxTOilxltxm9goXxW0
+M4WzlaI+C749uicqYcY5+skHWfQETvkRGJN0jMC9mz7+kNWuwdMYby/icYiqZS9/um11rTy
1I72lSmSw/Q6DKPNlRzsvLO+v1Urzu++vdkFNa95Hq6S6X1CPYFhlq/UbMHIseHrBic6r6La
konwX6QBZ+/0KZHb1URqh7n6MGGTHmKtbjT9qlscBWMqSFH4FQYyHbMsykzhMqpTZ2wcaxir
Ro6bfFPO7eUjGGPPzydCQhpttTEvoPjy0ryT9x1yloGko3jn8g+Q2iK+EJtmDHd4sKyGpXKt
YFOv7IUcEZI9GjJ5IFDoB4js8loVcSuMZZB+fOLLqYcGWPuVSd/WEXTWOr3bmGUh7yQFGj/2
C2fGIYwnIFhzu5aJDJYLM4sAdH8g/4hvfCpr5P1eGuED5R0k52R7folk02/PAqGk25dAfb8w
fSCPLTd7UpcOrL5tpfSmYZiLIoIq+pqLnL0+0fQKY9IUTaET8Gc9ow+SxpS4SsKlKpqXxFH4
tbRxJoZepvouYVenmeEfZG3jM4BGBPSjOeRP4x6DtPFHMwZ9WAoZLaG3yb14iUpbFX++HvXf
5rUuz85tc84EdFYlnncIyGtYh4boBeF4I+raHSfguMxzwYT0YHiUrkE4bsAb8p50yHsT4DAE
FyF/N5XVM2eHCeVGnutmo1H7sTxDRRpPaiKHC2Y6bZZ5jENT6nkYONLSXCHOVQ0Bt8ykgwOw
TNeE7sKstqLZ0ZV0bKzRTQr1d0Jt6pnr9NJKCXUzlkmbxnIyUmmt+q1bfN1f40JB1wfQkOHf
I6HHL+cLR+gNMAjM7ZY0FdZjqijA6Cf0yuZCuIjmSv7dt9Nzvb1G3YrXfbr+v6rtCgCWwFXg
X+726z9HKU2u2QupBFNvplVLaXsbzjg3+7rduWYvfPxpsJ1OM/8HLZJLUje/HxX+VQi8pMbO
FOLTExneZ9BR9AeTAPf8t0HVXXUUC0UYeoxClDGrbIfccZPHxo0zV77n83+v5H6z877YLh4B
qXzuJSD1Q8j9BYcN6tbwkjATfK555SIUdGKDvnPMrBffyarHgxRfGJI5U8uasxGVOf0UNjAY
hP5dFe0fskl7L68q81R+XQMk3e84yc9uyzUwxf+dN+tRUtEtU/BAmApNPUa6YAPZviPOn2ju
jzCHBJ7en5D/hLIqNHUuzK95NactRs7FumLQmE3bBo5EXLAuxZ1QwNSKmSYcgkjK2t/j+bdN
a31J3CclXRGq2FFA1Vp6elaQmO2aLuau+8rxIGyru6GEUt08HO9Uw67sh3+wJ9kg9xrUXrMx
TUtKHe40oFezkMzQ3SvidHcR1oEmobntSqySpiJDRCL+qWrYmEhEL8cfoYnD5QMRkJyE4+iq
+mVu963t917fhSnCniaPaiU08mf4TylsRKrgnjJ3/NlHYxrePpMkzLnPx67AsaoPqrrcVULg
tGe/yzTBjcS+mJlJHgJqJcNjrxztrxr65+wpHiLwTs7SN0pT0uLh5aLC4PTrI2qHYcRuLaqm
RdeG1S1KVi597WrvAQkcOZed8h2YyVThs7ba5Vl60vvPXfy4gVgMB3byc+g1j9/TWjI08QvB
Mnks/FWYrKf3kfHi6VxJ+LAsGdxCwUhowE97Cxm7oNUtN/J1OI8MNP7bjS/ZRamgwSFLKnom
8O2woQnkLMiVm2nu0TW1Zr19U+qJ9zyLXdy0Eco+Vmkfu+X1CAv+pLek+Ncn0ZaGgq9h4YER
97T+JM2E6/2eGxx7vC9EcMq+3C5OZLwZbWC5OCb6GNcYMrzAb2AT9VqEMB8Ito/kBopmosp+
lyPQPgcpcqYZbM9yNYhEQALcANdKXyCAZo2mUZirXh1yGC+a0Kd3qMt5+S6N9DtqsWjHL3Ya
RoGejA5agh0NpdcjOW+a5+AOMjow4yfpzttKKslaqdblU4nXrg15SVzojTHbMaAsl4gBCuUn
Is7Y4U34Lw4h99pMdstd/erhBwbBJWWvIWJ/XXTtm9stnWzMGVJRDjpUkPtW0pS/sbcMHuV6
UwOr3tGOSw/3ez0wz85XIJOIHK4wpFHwe/YYWIhwgu3XZavLHuU/kI9cNgSbym7pzlK0rve1
6bCy5vBgTEzaxlZHbuJOi6a3mL+G/FSTW0izTrPwmjSfvT51O6Inw9M3w33Dy9QTyOV4yjFq
g1Zx8QajWrqaXrJHU9OryCO5y+2Pu9rjwOMVPpB6LbjW4DZfn9PSVt9FkjBQ55IxA/xQKam8
7LpWVkCtz9MPv0Nd8IKe4iafPxzvfYrgyFHHseN6YfWLe19FY51jMo/Ykbpjy822MiqdXdXw
ReUsXLi+mb3IMKRvfdZH0i2FqBWBJilQGIFI11aXCnTsqgvVOLSZbCsGbtyAh8xUYpFGmD4/
S4fvgApc5HC7En2gReRaU1hMrQMP9dK87Ync4Ds5RvEzuEPyMf6xJPpGjfw3x41i7+MsCcb4
Q6tFZxynVCORrG5wSv0cbt3zyry6kzFYHD9yLIF5rcU6RMBPMxOOczR8PK4ZspvacMGOn6Us
/Gd1rNmtbr6GYzzrjZjsnjHtAeKQYdE9yyvNR6rQFBPCFkywOAxSDVYuSICjzIhEJtQ6hnR3
3weHCi0obmV6iPuNzCRpMCXRBisqvurAsn4S9gXu6rXtt4eomhuOMk/caknYgd6ceUX5clLB
eJAo6QwRvKfG0iSGrGgSwYbcELLI5AVc3K4+6pmVhSAngkjqWj+lhc52WYuXvOMfWhygL+hO
243pyFTLLqaWp29861jwQ6Weage7wX71oFCIFsQlWVpYwrlPG/B/ozK0GhfYlSyPP5faTZGF
HdsLp8ZRPqrS89NazISK23dOqU2XLSHry9LN2iRYm9m3bLfTIvU7r3KBlXVnFWJ9G6b9Vau1
7jaNAJPHAVly6YtYzmlxKFDuOI9KLrmePpBdp49lj0+NfFZjob8Z1612Ev6YQWPqahuaMh2o
P9mHi/pmWN29HHNVjLs9YiU1PU0+/z0Mr0yH9364fcRTPMRYvu8ZVCExc5WKl9lwfWmoDq5l
Mvob7Uo1rQ9NF5AsLxD6ySzSyMX6NGopTYko/p2U7pANvL/WzfrQO4FShhC/uHvxCZpX+CsG
NhibVD+CXDf00h8E1wof2ufTXq/FHlxsMa80oJdJDoNfDlMYVxx51c5ucXuZFr43cNx2HNTu
3lVDGdQ/B/zw8WW3w1M3T3baq33p4+MHxxOobAo3bF9y9JWOPtFG0b/VnNLrQgZev+cC+kHX
dcy9Dslx1ueYVn5WgIun21F1ispPLR+eZCr9mMqCa6jLl+SfX6sY3pJkiKvw11ey0J7+V1Qj
J5DZE7fsL9wM7e0TQv82BAQZNHv5iyecxiTEk28hK696tFibx3HtfvpvXVBrlBdhzE9pCuLc
hQQhTTtJM/Q/cKqJ9jQCSIMlsPaK1SCpBnsfsXMwblQAjACH6CFEghZRmpeNhjygzFWsnrNF
4K8lHRCwcGxUYqHwoS6puethrVF7nz9LeMo+P95bzmx9o0Ebuhbpvf7HQmxVQ1ZmFgPyySd9
jC7Hq0/HirpZCuHr9UGLzuj4uQKbV4776mh+UJHi17VDPvaaRz76H5W5jz+Qqst96JQM2GQe
hrSsHTzwbvDu+nu4tTKYH/bUoVGFTPEuKSXCMMzc5jipEqz7OAEsa4BjZMEBPwknMLJqqtez
KHMRYiEEQPW3UfhI/uuneBjAmasvkyenRdBelxq50z5hV0/yxeq+jxy0JuWC74U9PyQpi+oq
ztngFZVB52QzCgg7zk+mbiYQdz99vFi/TnWMy5pRlWgr2LgXBlMY+Lak0JZvsPEOfQ+guzks
jZTCfC3+Tdd/yf/M4AqJgRxgFg4SQUU7qLL7p7ivX+DseMoOHPtKg7dl14IV62U7lh1rufn4
A3lWHJg1W2FDdxHoNSKoD7sR9ZFkZP7CjuqKY/XAUXCyrS/tkPODgqkf/TOGJ/BhJ5fgdQ9H
u8N2DJ10AAmTlqrsD9G6hLguJvDbdcZh0j0U9sv1ajxgIiCH4cwD1QEUKPbiEJYEIzM54gzI
keRKQ+7GZAkPnYWYxiklHQk6ULJzgxrILZ4oVSaueREejuzacGI+Et1scGs8GAgG3IW26YY+
r46Vxgo80goHsvnzXsvXJbSUU+UkUCiqXLancL3s7J2YLMN0x7dfBc2KLXufz9bfodR28Khh
4wRwpMc5Sa71q1nWZlmdpY8QtaKjHu7YUFms8PhBHYqm11jH1crjdtQHEjme19wPRhcv1WhO
P2feQ+LPCt772d0k1aa3CEYg+c0u9jr17r1IeR3sZiOk3+OAwS5TrOFdHWdabTPtCBZn95KW
Olg8w2nFr0JzL1kBzZXEPMmHbLS0JcpN4UHyzHWzmcHgMoiyR69ctaXbYGDlkyvgFLpq+whn
5HX0eJSIMaTu6ofB0kCw3FzkcS99/98+/0zeXfuwDN8BG/VxP0UyVTfeCmvGVavRHk7swZtP
PURHMWeb30fKtH7vdoyhJY/iS1kxFg87KHwypYn1KBXruUP/f945nnp8ajnG53adKxTpXt3h
Va1/WMltCQ+5Qh7hZBnz+QRS4NATspmfqeRRakxoOZgMC+bGRzUa3g+0zqTLyVE62dZNTn7Y
mW7sBKaXtHQMucuxa59VYe6rUBwSqBAd5UivoOQgH0gBSnwMuL/tLlfcr7T/7OQ8xVgR0PJe
0Y3YfUDdZl07t2qs1AJM7EflXrs8TnJj/FIk4AXM2IMMkttGvXOJPn+XyS63eUo9J4vwnEmQ
bnSPjev3EKikWmts2HU08Rj2B4DHfv40u3Gp5yjTnYl1Mp4tA2cemq89WnY8loELzT4Kp3Iy
iV4yQAqVG1TiIZ/j3uEgVQmXcwLcmd0cnSQOsklUDU2iAHSX49btCtBSgqZ/1nbS156reHXm
EXdlUzHsQNE8G616EJK6gJHQTOnYgc+XlV+RLHvd36pNK0WaLkIiVbN5Lnz6XpG1nvhiMzwM
Zit8Bjcx0+NCqFfCakTPj1p5N68XAcy4vWQQ/ezPp0hHhCBxQ3orCBBOCXSunzkimFBAvn5r
+06LrnNCyQjzdaJ4ReWWPHWQb2ehMAXpqyeaXXaHvGZtgeU9TOm3jKd2YkxZ96hEA0HCbttK
oq8ghHPlFbE+6beFO/JwNb375sce4ig3sEMdACKWb28sS3iKsB++dlHiJcz9ODptoDRVJYqw
CJCeZdBVNvc7uCYIewG2saW4TPFvsk82pexQf75gLfts6rpIFz2x9OskTIK69Mf1r4xQ+jrE
q2Z9z4zVfohXL4LP29P2aUA8qPhlJGHa5S607QzGPdTPYlGwmCkKwJb7dBxD9jko6Y7tY4dd
LvE5BaJaZRMSlSS3kLti+zI0HaL9ahLYNwvRJT0rGI5nD4kAWnxqKzJHKCIFXXjigjXM+GJm
qnM2tBgr3Lwq670D6G8CXGsOBAwL0OzVvKcbkGWvpc5LLJ8pHtLFV4+zQZebsDYhpdR96s1V
1fpHIYYOhlWRnceuw1gca9y60vKhNNNV1hzNJ9u8DQDhR1Y/SHf0Fa8MuMdv4Bs7sHRI5SOX
fr9xDc+c69DzZMnySrw7SGxVW7nnLVCO6jXTwcKMEX4Rg/Y5JTR3Rzg+oJjyD9IMziSuIe+r
BOYWBxFdjLVbwbQvCGwqFVRGwBjI8LU1nvDuRhxe5nltfkjE3FupaDdJleLDAfVVCRrIAmzF
VvVpIsJsKFoi4pwPp63HSPLI3hZa59n/TbLSKyKhyCXNssyaiXYjt4+9rTpJrXNxEif7evt0
NAsVnKmAMf5htI9o4sdL8dzlEZAzs72ThJTjRqdjBYD0wVEgPr4MAwVJkfyxWGIL/1oRJ59x
MeQaJ7OMj7x1jaCumcjQMZ0fY6EXV7U2/PJp7GvSLsU+vJHo3HOHwyvMzPGsUBK12gwwkbL6
A8EPsl4vgIwUfup3F2YKQCHyo1k7NarS0V0sxk/Jf7Ag3YhT5ys/zrLOW+Y8bxEof0+mp0Ps
+AiXJ1JchcIkak54W0oTZEGeJ9y+7ignIEbY7UDbWyy7d0SLBnAOnpeYhAmdp1zcZCAJxHtL
SlOxPtuTV6NQJdaYo/ptbR/Y3J3LAw1NvgAYI2DVIOKr+EZ9eC8ZCAsvecI9mT/EEkLEyEvE
pWZ+8Pj9U/xGkOk6csGDgQnUcUl8BDJdbhFx98dmjf6HQ7OxCAcV6Hinpwm1eB73ObAwf/Co
RPbekA7mknSRW4gEZKyO7cnlulH/zs7vbBfsBEw8MMC+9MsG/witnt1n6QHa8U2hxl9/yw9M
1AP+mxZPddbmN8ePxmdfrG0AcXDpbPzkZgX6ziPgGYLPKN3lu/PkcKjQqIzbBWYVIfutJwFV
epu5omxJ5SLoTRUvLqwwnhtI5IlF3k24v7gIqoYX+xLPyC9/o/aHiKVXBE0KhKVTliev2KQb
xPh0PcoDV7Hvmoi+DX2uS9KF2kfkRrbUMCPFQVWkVyEDn4+7lwxPYp7IHNY7AtBsgRht3C9s
nkTwT1uyoSFM3PqHN1dmfnZqpQIw1fEWgjZBWic14iMkEy5hFS4DPiTpgaVvRs9gZR7oqcih
p9nBLarGqtlr4FfGCF0EifhHW+XS/p7U48Y08RzikrEBxHIu/RtMvl/uhzK4eVwJbiyCaRXV
0nnHRvqgS9MahUdtRbR7+fxPeOQdW5KKPwl6B+RD+lBHnJv4NgoG3igT4SHYRHT1z/PLk/E3
D6RRPmiwwEqLxWXGLi5zy4j4fA90D0DM531m/eYfDXMSNmk/mTaBX2gDBHYog8/HcQP1q2Mm
6O5vVHtFKX8Dvi4SfWMrHVzPJy3a52SWl+D4TfYyt0ML5hk654+rLSfQPM47m+YEN1z/gGQG
pbzZA6aDekmL4A2/EkGUKmBxPtzJLjDse+NSTW8iFO8FHHzcAxwUHre7hkzPKgDg7bzGbkbq
4QK25OjCuo5cOsp8WMjoKlOoMA/d5Y4BrvyKpqbsvOTly3MRjQPFyD+rgv2vLYH4Tu9HwkTE
lrtP9FDb5nBw4fIkKOF5XC0cVXkSoKY1tes6C99hmEYcExLPNE2VTeXJdo7+QY5Udo7KeGaK
qOehRb7nszZEbLD0DQqTLbdcEzqvhE9CUcYBJr4AE4stUQSEOujEmVv71PYO1wyxXeENtt0r
h1K0aiyPyJvN3WwADDG3IoKALL00IdSgO9K1oIh/vIGBJBH5eDnGSC2bDuy02BLt8AC3rnJF
G+Mi+dwR8cWQhmc76bbkHOktx5tb5opueYqOGEKaJAnOX1B5Jt8nRO8/60WEK25VlDNdKrWE
gdMp7/2Kd4A9+HG5dlBeu9jO4MZI9p8afMRCCBB8qVx3EdegoHN6dPOUHrhngpaKu8ZofLdZ
qHrxwwP1JFLzPfJB93SZrVaEDbDqhOMwrmfAV5vQJl7H7KjC3ZhbMWuL/kUx/4Bl0872FwQa
5wpAZvyKluvL73gqwrJGK0XLTX6+8iYMWb2HbOdODyjI5QMY1ZwvX1kdNej+Os1goDckcFLa
UtfVFX4nMvvtzOlvbZ4B6PRnWRyH2fPhzyFNSmt8yh0Crg9kIaniMPAaGXI/F/bQkSX3h9tj
3csPi1Ma3uRznH+4K36Tm59YNXBI7xCoBPYbtOfmhli+VzZFL1Ppmnfrd3inoJF0Rp3mOqAJ
ebrgbsIbeKoYpbfGn+8EMLzmciT/op7gwjGAHnY2b7lw7fA+y0Or3uxEDCMJ344uFAAJy6f5
AVC6s3lpUR6TSfv/QoAyCJJjIIeM+LCbnX8oWpB60vA7I5/fIu2hNLfAm2UrIciwDSCiz65O
u/Ic554S4c17t9kza3fm0TwZNVy2rHtwIL6xByxmsHsIdzSHf9x9rJOEyrJt1T+TrwIOQVE2
nzk5jYt7oKvX9PsiuaUfdUl6GhEfCIobOG6ND200W2kHcyNUp1IMBBIJv2Dblf3FgE8S7xFg
RN9z/vi6EkKp073GNqGugBwInBdCZb3T4XzZnNsJwBGA/goTYqyc5elx/CaHLkRDflcK8V3c
bbixRXl57uexkAziPG3/by+M0gJCScgpKMZT2wzOjIMKBcnf7pVdz3GYMS/wdb5AiduCafGI
691w93yCQYDLarkuIdGMejScyRqXPPfE5gu8pW4YppGvudKF25oLfOlqMHjDYCcB2HrqbiD3
9W/sYgp3oaon6nYp5dAoO1+hcJV8LB8AfjD1VrEYVK6TeViXzX4dLGurHExAK6lKGYWX4ApU
G3w1hgje46ZRMF8O0rHt0FUOdw6ILeZdGPbBQPjWOuEW8Um09s9feK1J3IWuwdVF+H+6e3Xv
fZK+rhYnxJU6DH5c+Ilr1rKwV8m+qXTeEi6pf/OEggxwTqUIDrSBpXJKVKDyv7ZZTeXYEwfh
5e8mUXeEBqAT2ZqDV2MP89MuI4kyQNiWwHqfEFd1D9NtxAXfhh7JfWfkvkUZM+/oj2nP6TDR
qGiKR4qrEC0NliDP7n0bGHdgHDKAahQrr8X8hBFkWRpBRfJIPhpE0hz+H7ESQFI+DRPpeyfi
yZWj6I3Ra8e0XBgPojtEEtrvjeU4Eqjwd1otn6/uR2kY26lMatthyLOEgkOiqytCUCbDVG+R
dnPU2crRX9DcX5lOcYaq4NnhSbj57A1Bn58cMYbUdZewAcKBiqoHadUF4yEZd5WjQY76fPoT
EihcbqWu3cfKrzxZjj39aqNDZV7UZLKFf6TPi15D15rYf3W8zOSCAzFsK2+97m4d+78ZO+S/
2dWe4juqAreKd/dTMGrMCFaOg4pvkEJ6iThVj7XOIUgBIZQZPv/87dXR65vRRmxN2CJr4WUD
cAG879wol1uqSZEuyHb8nU/dNu1qtlaec3Js+Ilm+iDFh4xG40/oFgs6cWlWYD+6NmY7HhDp
IyV3U/nG3zrEkzop5J3vYBCz7CJFvP7QBRxK8zbJjl0n46vnpUPG0ZnZfqKBy1Jv+IA4vrXi
e1dfl05Hb0sMDcDXs9aQjSggSxURg9a13HDQAU9LYSku6EzJnIy90Dndadp9LBkesNpz3ebv
y/7HRdd9FsDOvRXs53ch54RLMsParjWrsxV+dnThP4DZMqImXNximrDZm3I4iO5TpIbEVcq6
qGripHbVpfMIEJAeW2RA3uT9iyrHgUdPYEDGNarX67FtWbm/4ngFwQo9D51wcLXxAK/trpMz
7iclM7Ps9CR7O2p+FH8B50EnfBZOkjVz4M8CCSMibV/oOe6nwSBDNozNF4Zo4kjMpDIaWXF4
nwexpb3yE5jZEXAGh19qKaOJI7BH+hEbFjeiwrQbbUuTaVHTi367RZbynv/sNjQBongf7ZC0
l8Ok4bBu6T58ehrb5gtMutd/gd897FdRteY4Jrhg/O2av2m9vU0Q8d12eK6udqgR9K/Rw4Y8
OveCDWyAlF986sQ1QPCUuhO5WAyKxnzRmnen7SUaHeMgKSniMjPQZiI7PvpxXUK+Y+8wc9PQ
ELMAWLtNAcjCQf847t+a6W1QUtDh/gL5ykmtPFNnt89WmG6+eEIXFgOCLvQJw77gMonT+mYU
Jatm+kyTKfK/jHzuouvCkebPT6ORdw5scUWQdTYZv7Hm04rqBqz/ApO+9XjFhmervhCV3al3
DKjflxj4268JEO8KKNLLfAErQ4PRbVDSyikHuUGIO03SG+tkzKH/bVkle49/rSjNaImSG0R0
r+Zn3ZtmhMuACAO7J9uW+3RhlmoatVOA4OMmgo+vtbc2iFfRJFJo/+bk+b5acit0LUJ0DwOd
0IkoihSf1KbjbQHc+QU/hq8u4QDGW6ZdPjdZxgA4/puvUBgfqBcPlCR4kbUX3o04ELThTGYw
FnN7XGuDxdiVmnzAeLK+TyHFnm2/9gR2zpOTq7sKwyGdx4tsiWgmFRlt92jgqLwFc836lCix
ilDjea8zO6R+brGKYkWBE7JVak142gpULrtfg/K8YW7qN8QRcueZ1tYOfC5uM2uVWStGytk4
VQ+JStma8N2eFI4ox5iEINDwR5qsFGcBvp+dn4fsZsG0k6LcGFSF0Z5DiCCUZ2KF8VHY4fVP
ichg3RkeNFp4ZFrmN4fY7MeBMzG9wcsUns+qbe6XjloEMzhOApARb2zYlBjWrVbMLijEcbeb
L6k78ekI5UXhi2moRAN26WDSfl49wYqeQyrJXWWn/R1srix14Ia2V9gxYQ4BgOSZKygqepD8
NLkx/Dotc9TTKDH/AnZkzJnfGL1ydN+SGk+XJXiXSCfJei9hhnhA1wQpGDs8DvdQbEIS/rgI
qpmezgQeB33JKGdTJ28zyM+7KjQFBAyAdhsB/+QRNDI4HcNEHZJj8YyE80IoJ3e0Gs0zihaJ
HVTW/uEkMabB5elGgolT/S7jnc1w0eRdxCUdMMCbZhGkAUbLVy84SgMdI9HC6KJCySL9F1eH
8RvvbFsxnPvotW0OSwxfgFx0x4oakOsuGjOImJEGnFu73x99LGJ/6PO9ZHhC4qT6Psl3jmSz
TvxcoTndeqF33tZ5OBws/scRdv9Bfa0wr9Io7R4UApkwbkSE44YtBikDHtlLlbxwxn8H9qsp
MCGtbw68wfRrek/URSIgnmFxsebnsCy53vl9aULpCmwFbX6JoAPSo/ZPD7VAH4610Rtmp2yN
9+115WJNsIHMgWJTpTCnywaGn421ICsYM4ZIESAFPE1Cm1mxfgJOM57DnGhkqkPxKVm/69uU
Fks+MGUTQ0XQiyCVNX2MNzbDf5ZJsPbgV0lbX/G6/hf+JWBTdEjnOZpLPF2SG+NruaWCaPtt
NV4QxqOv1mRPU2N3JomrWcShpoa70ExyDQkJx9wSwRidWWprw79aetQK1VaQEvP/cx6Tcxm2
1BZAlcnOEP2H05mO9TbAedOYMM09L22OQtwJhqtBz24QVBRuXqVnaqwkgZTNZuPNWnt8TCGe
rR9klXvBNPnGYsXz5dsH/gtTaPodd/GaojtGS35yGfwFUt5KQLppUdqbW2s9UFu1uUJs/KNC
xq5oqxWWqJ3qNfP0FmTZLvAUD8SjkjJLwHw5ZfBVCj6T1X/cco3vRZQu2mYHzFRF+ShxF4aQ
2BF9nP11SgJxFdajcFQVdjIkcmqsIUOnTIuWNrwlrPySrD/f8mXPFl11BfW9wVX7nQx2dVaY
8Nk5qIQ8tYQR9QC6f+9tyI/vdb43aG8zoHEggtWJxAstX0e/4e/5xmLMEk9xk0fwGyZxUU3e
bk+d1R97K9hOb+2CB1W80HULFdolghOCZKV4CqOsvZjgQPuUUXfYTgVZAQsAn2er8v1b1r0s
8EcEi/hco58edIqIZm4bvvMi4L+xnHKDrTj3TStZwjcxBut50TBKyCmyQaL3nbZwY6FMAxbL
eIDmdYO69arT1kiF6M7BEGpy4A2okFSe4qZGY0q6eD6wH0QHusv2eDtjtuMDNUKUDe1e2U5m
A4A67cXDYWBP7bo7clTPyiq630WJBe7hj6lFoWv6VReeSUOEFAVA3Th0xiY17FrEFBzzA6qi
SEeM8RxU/tiB2tc++0Jhh19n81kxPy3jjnOVSSUOf44wOJAfKAdi311D1hCMu+OwvUyRQHVG
wibKNs4SZVy+MkQ9AFJKuebm9HiapTt+R6eIe/OzfIHZ9IbplccPr3uv8NYKTY/fVEu+x2+B
ZqV8wcyoXsyfhUyn3uM7auJvSvDt8qb1Ls5HlWSBF/srjN77n3RXH6iqUj2GYHnYh+BJrNhy
SYp767DogsrIDTa+kC9YZYx3wDegjO+dw2JLjLNoLb4yCFnB+dZ+mCLmwkOF11uVRHfRGJCH
FeqGCbhJGkn13MiGrk4IlBI6JolGpoaoz9sPAUm3IGmJNgwqrDzMoGU+tEX7bzj2arRLz0EG
jcjWfsXMG4cAR2Y4WNcw4m9Xgp3MirU5kxyrMwrlmdJ2JZIbLNe179cEbuZwn1fWvJEhSVdl
RYGjnZ7jJPijk5fnPcL9ckY8VOd6xIrlQ0xAxgso0qDBi9O5B8Okb7pMS1U7hd/3+htgdtXa
/lj+DJwQyj5boG+XaAd2L24BehOR8BqHSLBqeWhnk4LgwzjUuHrnH67+OqoYeAwI+rFNbzfd
pRtTah64Oib9pfICh7xmOiHfnebpzpHUrHXFPjK/IHifvx1h1AvGwIg3eTiXfaBwnTds+DPg
pj8kmG7uplOeCCWNclv4CmXs0Csk/yLOxHE09pUakA8yeOtz+3iVoMAQjQZ88Pg25vajLo61
XSZJRs/Gd6bC14rG3lvFH1ClKFd1v+wJJYyI109Wv9k4AZKPqXCGPczqVH69DWFECHMqN+uc
aaFoeEZ5ZHgNkzSUO+HLKUtWr+IYJhgYMDee8zoe8YzL11vZ2FeX5ut8DQyhHTNm811uXqlD
UwehGVNdUVYaW6CpgU3wFbJFeXCPxvDdj40yz63kfbX7uc5IPLzm/NZpL9ycuuCFnFGFCwlb
lcnH82j0YCYdfAH8G9ob6lslVLH4WucSdorvuo+YMPWgnCLnsRr9/rI0ZJ4FQEm2x3QSeZGZ
Rq4bqe9qlDwlsN1ZLItHLdjR9zYufOKNmZ6/epBuatqiteyeQqV+4IelM2dFX3qq7T7iCuxx
I6OoPBtQAtZv9c9kq+HvtM8FGEGcDNjGhb3rheIomky+142c3cCALBZ2iMuqjR3lJul9EXFR
f4CQyYAPzJLqIXtXCh19OW3rQusHSoyNn6nEovz4v29dRVs2snMVz84FavXuIoo8EDk7k2pd
3YknbdeJyHm/3vyyPzYq2E8pD+VQIghBQBwNVPdAUOS1e4mHrPB+F8cRKktiWgVBjI66g161
f3pLHWR/1QlqtkLuItL4em36EQfywNuRSub1sN1HxXJyL2pe0tJCr4myLZaXysXZvIJ+HZfI
tQa4RDvLs0alqzL4AyBkvG2JiH/f/Wj3D+JpkmIbHlJP3yo44JaIN8ad/mbPpyi+riHm2/yQ
sPQhRsxMc7B0rcP8rXN29QWUg3brUyMteM+ZLbQ37p5J/8S5keK+h7pZe1icOkA/SFRecnHr
j13NYVSTVi5+cNlqEcpR2fHN+WRdjkPpmNWmOWNlSTCg+34sJQusfN9AON7m5dmn8dW0asPt
akFMO3PyTQwSy2TYftthmWMJBzJv98C1lvE1i6l2/B/6/FHEkTbWskpagDdaXD4pcO6YV4iN
cS58wQhos2QwxF0Z4uTWfXcX3ID5hKcy5BJjBw0OUFHzly/PONVV5ZPnle1HOLkUSNrncyKy
BAl3TFWMbEnFHxlUwQBafd73PFDFPYwCd4TdVZEde032QER8hFGJMlQWZznk1Qz3b1YMLPSW
bN4F5FPyUBBO6eJASJ5kF8Jptx8LfBRjsyTNeiI3foiKPu22a7IQOE4BlhqwI0dbLzUgXPgi
/m0A4XkFPsxk0gSYbNv09kgM9DYDRUosH5jXTmMUGheAyZEwpyoxZqYnaJAApYfKdBd6oa1T
QET/cXbOiI7n7IvAQ4uug2FO2+1/ovdoizuClrAVIyYdg5737Xa8uAF3B6lc6qQGMFlkgUvG
mZPTf24KeVPy7NfBWA8awXvwnGuCrQd+wb71B1daOLTGUn8QkuGeqrknSLbUbQI/da3Gaj7b
sM6l5qZ30MaVcUtf4lY/LyCQlNyl3vDbQDBs5dKluh5sqZBOhZnZV8VZEYcQeyGAtCqGuRnv
45qaL1C+lfBjE1ZNUdQXcxZ8lnh/6/YAC9rY/SWcr0WYShSuLDXsT6K+hH9dGA88k/7yC1Rx
mydFnYQlWQ4ER6Myv8BaUiWWQ/T5ysKbDlbM07FUqkOrz1z2E2nAHS8lddNCe+hiI+1eH+jy
8XI4+VY0CcBh0XIaMuVs9OywLVILvIL8RRJqV0Ia4dhvC/y8tMsbhUUEV+0X0K9c4tfKvAZP
HwWIFA+dRs6U21EZ+er4TlCCI27mnG/N5lYdnj6FBNZSicU+DXcjGixzOFzVCMct1agajdXU
l73jtVX3tQIhTKrCAIDi9aWAWRkjctH2QopmxkBd6DdDsYSn9i1u+DOjV7L+c9Lz9PIpLRvB
8YY9pzioaFZMaXMIs3Y9JqhPO3OH4puhEPCx58wqgirlsXJijHnsa8MsBQJ6fharZwC2ZYgh
UzNJRlStzGwUtZgUhx+5NcII33s1gZ0bHYKgjeJUImpPjdjHVgucpLnLFwK00uf5+ZYXHexy
X2K6ZDrxuQ550zhPmXw3cv05OotlEBWjNpaqiiZDnI9z1UyEnIIMCOcFJSCOdTXtIEAQ6pyn
o5wCDgrwggqlr8oySnGfHlZ6sWeW0HF1y/Y/gBgpVmRvK28f4+hcRUn8Xj4KVmCBWXhNthYB
mBOqAiI5PMV/fXfKsfiNyjizUIYb9Ikp11HR8EXvjHMt2McnChYstjXg+9quEi2iwzzw+t+Z
J8l6KHWLLFtho6QYboQl0PjgfZ7UVL/Hci7lsSmuWPrsId5iz+g+/KWYYL+bxt5uSnHNE76j
3jaiIp7i/GFANq6J+E7PjbXDyUamFrVeFIam58K1znS8KhDyon/489kOkjuZ2i4+mDz0m5HT
RXBYcNBlpb7Z95rHD48wT3/DIMUYfdvpK2Bwq8gAn/e0jRz+x+6r6l7vFJ5TrI4S44Yvwd0H
fdjoOKHJTty8FDXxUaIsp90WAxNAl9N1oPsz98blSrDqw9M6BHe+w1cQeM1chP1d7ojuP0qb
8jG2Y0PIXw8wWkL+beAunoZ3tCapyYRqB8U7rXCoEgVXKSw4u1pYfsJtSGkaZ7J8Ardjwv2L
RE7AgQJyFQ0YJ+Yh4meWxH3lzJcdfqP1CFxfGD9J1dSxQlUTBuQWMuC3NDQX+JHgN2qMjlai
Y1Wwof9oFw/QIOrBITIhaAlDVYBhbTqcOPWhDYjyS7u+2RShAhk46Md04xLIEuoZ2TbWWi0l
qX4Du0oOjQ5/BRJy2QcmTqOkaLjP95H5+DfaM+2Q10hIllV26BNRd14fgvp6zphvHxWAPQ2j
+8hcHMi50RUJUOiJYfTvuf/0jjAZ5hPRQdA0fGlLtL/SGrX0tjf9irxTCtjEyzINKwqK3I2r
VIk50DzjgrMcL2b6ABxGFySPxA2k5HB/PJf8bZtOrQKW5PrZX9qij8T7uGDvR337XL2RaRLP
e++e5siW9D+4acbCE+cEHnjn0ub++ysff2txwkC37FAQPEYSugdt1DYDtuy2+oENKYMu55Zf
hGfstfg1ou0rDEGCfgAcNYtqzxM0LQ8v+j5oa/gBQjStBITt8mbBydsBxjy4p33MR+3QJ9WA
f0lsiD36WPztz3GXr/J51o3SJ6MCGW3/D8qksDwXbye374KFz/ENiS13t3adrl+C3rwwvxGr
MfwpDkppbz+lyuIEOuaw4v4IOlaRkvv9r4le7sOaryuse+NgfoTYRGE9a3D1E6yMyxKxC68c
faPJil4w/J3J3E63LNJ+a9wP+uJDBWQl8hE6Py0Y+lXjCT/FY7HDke8H2zwL4wkpWXI17l9A
NqG5ueLybnromsXC1CAZohTGah8J22E1NPxoKsGDRAzVkSjbFPN+uTCJJIQiYcQjoAOKRjsm
TAsyuKGkfoSbRoCep27RvKmbjSr7bXy0kDE+ykgMBpvYm8yXFntuYTy4pMHNVZsK8IrlNWk8
aooWbm7DJfVSED7PZWkpagud7tVAzBPMf0TWAzwFsScJoEGy75MTbkutk5gdHGio85qeO7sv
PXzAtKuajMco/goDQGgIH0clIASyIqahwQUUtC71PPHNXATuCBZ8/G2r4dk5E8m+lhSYQ8Kv
vaHDj96gnIF9/a5CcHggx7ksY+CFBLsihtkKJIn2LBoY9ck3gY1sRMM9utCCPydaDmKzPkN1
OgGpEGr+/ybWIrYwvolu1CDY/v+mRSPjBm8j8UEeDHU+iACV1TCc8X24TQEEKndrTMbw78zH
LSWyurLxXireo9EHbfItTJgwAQVCiVeCE9Y+3WfCWLGf90D6egipB/gdQCfZf75cjlYp0Gq1
EvQqDLH7gbVlk+2ANzcjfUFBRWQFRT/zifn7w9wlugXMJ9lcKUiPT9RnKL7UMlx/IQfIbps+
RFpqKzOAkfNrfj5+jqG9yQQxLzZSVdWe6tdh5f61WcngNZ3g0A62NyMquE+8QHTJHy2Msgj2
nfBYGRCuuTCQ+fS7SMQqY0IlQp+lmRfyGDMFE0bDcEfUx8cHv91Pp08EX8jiqer2AcTFkxOk
lM4tnEHAoA6f6MhzI2GeUtSIPnnksFv6LSu+rysTTHjp+cjqhxVdG97TUP+cgBxJo12YT7FK
5I+uK2zPwXJcZzyQf8AXa2pLh3jhja90eHKZpyTZlx4Jdtbd+kOgMfAYgDMWNqVLrffwdPUj
sjbwlejtJlefF9xvOJaL5HrP/3cE366QxAm3vEOH+uqD6Uk7Yox1MvpPuOumlddlrUvbU09u
NcAYHnYUwIIZwy+5qVTV/8zYcgHi6ihst1QA6fWPQ3tXGYPx5zkr7ImHXeTsDvZKOV7fKG1j
uR3Wnk8GA4k5gIXHp3ZS2uJXOU5U1GQh0CGbP08GEBELBpmzQfCBEjYMulmf0OFKHp3bHixX
yczWQZJvmV4lzpjeGYypHM7fckLdi/0WJkio9MULOEK7eLeIOcgXUj1pLI28FaputD04+Iz6
vRV5THFk/ZYISETuCiriS7AWRGbp6rXyPjWhHQnq3j/F/Li6Z4gCWndfxFpIrPVJ0MyG3NME
7uuef9DENpx+4K0Vlg9N3WXj6vRA+LlVa7Rjw8lbRuOeF/qSAM8Mvb5sCknY9vPfDDZ1z71I
eQMMlEC1lXYO8JPf6qihEIn5E74iyCW6BXxQImWQJV1SJvyamJIXB90EYqNk+ZlNaCltiVXX
BQIvat8C+0+yb7cajqjrbOvf1v+MbRFVFpex/6p5QgdOUKxwi7R4AvgDVvwPr4Q6CpK3MpLQ
mum9sayyRQtxY4hF45LxPO/bBqIG6uPDuqjqUq+zVCE2fl1XEwUmuJM3FHQjD8U8xp0n9uCl
vw/n75TyBm8ieL2n7y3z9Ozqdz33Jmg4P7fPHRYZrFzO68dMxbXBwW6vpQau3p0y2jwcfjbc
vTc6p495orpfl82cud1/pYyBYvTJB+ZNZjaG/AZfh3zr4HSN9LehFiQmQEmuSjhBIpgE5ncB
6bjcnYu5q8AtJmW6KXLFM5Fu8zkMj52TU55R0fSbXL2KeJX3K/i/ztCVihpihXO2/wqAxtmG
lh97EaLBs+Ax82SzvqhrZUrSVp/EdHeFC7FqvOXZIvWhJ4ht/BmzCzdtrEpi8o7rm7JyMfwW
iBCTHAG2WoOkOSqYm1Rjqs4CkhLlqYZQrXDHsc7dJAXaNgGLeiAf7geF9DmpTat9DVHM4NBT
aOV0ql+YDYWNQMhenhzOIxyevXuSW+oee6sBH4lwtKxR27TSLizixYlqA1Le4UCOxVHGNE0l
/kKIbYqsJJafKvorTTrj4Y7MJvCTtYYmh+bbJhkrhpkap7U6rAQQx0J1uVWX8JeqDJovHv30
ewElAmf7qGlxykLum2W5nHeV26Yv44wSxw1RtCa2T0JlpglQ0dDPW2qEafkrKFJscyVw84w6
92+T3vVcxsxwkcASHMST4ZIkYHGb1fIHZbKrk/4mdQnwB1XtrJCbNFcT3e9tZn9j4pbPrikm
AtWXc886wVpy6ri3G10kaaCbxmjApcM2tqwm5DCr/9j2iWEDdc+WXK5fx1EKC5gFA+NW1v40
YjdKhiWFnHMzXDe46Qyc07eW/DGHF1zelxMAHSQgoQjaRzKe8HDOkZrAEnvFs6SWx9AY24cs
rSw9s/S1bD9k+r3z6b1KC03kzbI+AqsoIoQ9SV/1SFTjrlg+3N7R0P8PcJpzo9ko7WSDxVfa
F709rR9jDzCr20eElti+tMtnh0R7Sq0Qv0LTZplkhikvL10FiyNDOwm3t8BLcNIKjn/24V00
KUz9sLspycQz4JZw4HjCKpjamNcYX6L67okl7e/wpo1hqOPy3ZRnij31pizcQCIziaaSCoIg
dHeWSHfp/KOfqd5chzML+qgzBKv94n34C43UdO8P4YwKfNRQxIjhtefE8PYuyPKWgyuugue6
8XmTjiNlXCq56S0sPF/modpq0Dvnuh9Fh0mVEaRayPy24uiHUmpDL5bBBv/nIhm5jmOFKkFl
8S7YML7CA3bLd5XO2BOvhAyz23T1UBC02pdywXCjan0d8XEiFR7tBeLDjbcGC2oPH4v+uoIt
kTqj0ZwxBrXtw3vgmxSofx8UZzYO+ReW2KdTyn9sKast22AarSpHu1te97/jnlUp+mc4Qa9U
1KsQYupafAkGiFLyfwVsxgSrhE0LogOGvhZOUEaLYXceJGYMK+UBqw5O3gC15aOIU7n5rTMC
O6ec1GTpqY/IbjMj6a8C1+RpXFmuvglxM8G+92OXdERBlvyAk1iBo3HaOalTB9OMJAmrho6S
2sFwyOUO9k9Mf29etttrTvQMi24K6qQIG3GySa9MXwhpDJhLtu6WTBiR1iBNdqZlhbmYRlDA
zstGZhqQOKBaGxFhmDVLUQ0MikpaFW9nJb3WzdfOR4N+lPE5t/h7+0b/6BrL3oya7QH129ED
oUP6hhJKZQBQx05XmrUOaEXiSYU4Im80WoeEg3xngwVucOHiH5usE94zaJ6yNiF9i04XRtTB
yC7EhVECdBlRYK+TIE91qbwNTTWtc/2FKGV3Y82RLEBONAl3zpZ0fyDUBWjXPV8p1dHibRB/
3NhnQEzz8E0JjuDkfhECvOdyxzh7yJQKjZkuwCd944IwskZaqw/5breu0lDGsF25IkEBYFif
zehPYyqet29cO4bzVnAjTr7u1jyERQCKxAq4L45XwRERSYWlJ+biDk+CSLRAb1if37WMd5v0
X2C8993DiUrofUU/1ytgGohAtWqCIydCusYPxrr+kQPXgR33DLqatFOtVEgh6CZzNBZnl7Iq
XcDzNl6fTQt3rkfLOPKl+DA+LBryhwo5yPPQ1Olxe8gue9ytHaEliGxkBRxFOmgGfoC+kTLU
gGIia+XinAk7X2uAXfuLCFNojdmWDBaP+5zsb8iaf/p4PNh/A+rK9S7d7Wa5iT6iEeH7bxlY
qqfS09z8KDm1qLhYqFSGBO44TSOoZ2r5P/FRyd+Km7wPY9hcxyx7Pd/wxO41+pbBXFesB5FE
FeYT3akOLDSTJCNlk/1n2u3W2+KBFM1pgK81PT7QF2uHN8Mjfj4JouoXoCP86fQnVwk+LOfa
8X4Eyz6bFmOV09y8jUKMZuSulySJ1Z2It54a1ZZMzMxQAW3ckhJDhLwoD34vkByGlTY1MACK
msvShxz3nqzeei0jdf1ze9M6PEzPM7IXEhHBTZkyPyBEgqDGbko6calVWsqMM1PNMRJ8Zmkc
hZ6HYeDbPcmuzt9yXAmJZ0Lce7Bt5Fsqgy2remQ8GWBIrlS9+MCTRQIaLYLCE2/cYGUbJGPD
eQ9BPJZWfZm1HoeWId2mErAfzo142MdXW6cjdy/LgOlhYj5mum+fINJ46BRh3pv4kOM6uSav
ZKMLmTap2IFe1bJ2cAMxjHBYirylMfTMRdN06o/cn6svxip+v9VD4MEr51pPYkIxH1Rt+sn8
BYLsvtyS9l8RZIY4/CDwOES5CPZqoKSloJZ0r6ufNdtJbWTTb6yuztUMhVKID+ctOKbENK/a
IQ6cKz5M7kPGbVr1lLfhT6hsdXu7AvYoBUMfBs9HmuCfjX4kFdrZ7Y9fZkC1rPTtAZjFBTN6
7bnlURHyfdi7cXnGY9NiU8JtHhTx9EWh/ysfazFu1i9xI0xA43mPOWI9h7ev+BnY2jDp/R2b
mY5Fhz0b/xK9TAt7u2/TtwUN1Fsi9+mY0DLnGArk/JP1n1vDJW5kMKLpVWKUU1oH8ebB/lOP
AjbTWZqOFo/pkp4qttyqeff8XvNnIaGasdAqTl5c2mcRUkX4tWDHD1W87fvyqL3RU2mvPDRU
JiH0sxPjQrl/iK9LdDA9i5Sq3zvYr1BAxze/Hj+JiZGmA1OEI52OXqZhs863qLOkMoLjfAFg
a6W8K2zvpriS6fW8BH03bUJ0McGg9QgvKWQXl2O3Z2xh+EzLSB2Q88Zt+bD48T5TZL16D3/x
KrNYN7hUBeSjHTI8DhJp/96x1xqvUSGBvjMpumzoJZR4Ser9cjtakXhkxEEhPSv5gTH5fVsu
0dU1eh4kZSRye+e5UUX8J7LRmCJ14+VcqrI32RGH4IhyL7F6zhItWwVv8aqN+kCNolkdJiOx
cRQ/QZqHhOWaehgzx6wxi35g3ZlXPLL6LrZyCM4y7LCKMahutKNTfOoyaNI38W5VkjtTg60K
58n6ok2bYyKI/Iyx1kVZ5e6CsCdPN+N1rvx3C3cOvU0fxXk4De07xstC06x5AHZYPZ5NbWBS
oeKK7dhX9ZmTvSk15UHGUte9SO5+3dS/TIRAfWhJm21Z3VPCjHhJm32uDp+pcvyFk5eL0rb8
AU1gE2R2CUpQB9dUCXuqnhHd+/Ms6c0QuIsAJrTIqj6GDW5r3ZT4+sd+W5cRBZMIW4QK8DJz
PYRZKACw9xEOSaD+5xqewZpbwJukk3hLMSLgcSWTbE9U86p0EdWDfPHssPm6EdpVbBNcyYxw
JgNpBXk+D4FmQ7d5d6GUCCn1wCNOepNeUKvDnC6nxaL5zRCFXS43auDgMRWUS2VlxPb9qDxn
+efEV2l89va0W1g0v6gOwooRVtilYKb4jC/nFkfm+OMZsWodJPwB2fAg/FZA1wrk/q00FvpZ
M3FNy5v99jhaEiBJtw5j7NoQFz62UzbMPB42iatDnyiwSlQ8O3B979H4lA/y2Zu4VwC1Xw1e
Gj/mFiaIWk3x6FffQlMp1J1IcjGczxY4/X1VGEuQA8nzT0dwVyOLhcOZyxp6CQBbREtXrP5t
Eyp8e6+gBTa8xCkCHuB3z+wT0uTuEkiZxZDbF78rtvCXuBP+9I4UH+ank6gk3ulxWhJXeiVp
v/6hzfsTSq3yUA8nmuhQccVlChLI+SqaCcA00ak1AisEhYMsTyC5dR3zA+iYNTpPtMLLp2R+
eHwFGB/6bz1ckvbrKGq4mxQ5Q5EVeNNKoiUNo2/UbTm6umz6n6AjbDrj0s1N02UFQQ3tmk6I
pjyK4mjn87JHTwZT9770ArHxez2fgc+a3Yc2hzKx32X3xVHBMjCNEw/yFfZYGgq3GLUpNJaw
X13WefHmyT9eJIr5m8T6lFCSqRzRRRDkeSUH9yASpWekJw2fgYkfyoOif633I2zSEHqiGrrm
RVtLIxF9g9LSWvu2KzMvoh0c0++72hnUwLpHfQaUA4an43lZnHk8C27di5VoOa/qzlQsgpu4
XymdcvixM2IaPV/eJtxwUVxqtLFfD3IH9NU5uwp4PyGoLYuDIRIXYVoCihrxfuq23iI5ZdrQ
chqU70l4t9kDKvneUVHYNqoJFoRGWedIzZ9fX4xZjN7ojVCu3Bytlze+pPYOfRbFhw/952Tl
s+hbU6sQssan7CirIsJFhB0IffiwTjEObi/FqD08KBZ5TADJv30pFG4xl0I69YFF/DCdAnt/
Nau31GvVIQ+LyrLme/HgeYRkA2+0bsRiehg9fLru/3TcZK6pYqK2OrR+vcNMB69lueeCV1K4
uS9VS01SFb2my5wZ5JIAAB7hhjrmGRZpIOZs/cTfYEpagjDTeDHzX82YyUQP/jeYof0BnkBn
SHZUfaWLE3G+U80h40pvilC/LdZNR1NKpBZLcejOGuTr7ezMViUFjDMQOW7qPJqu8ImqdSuh
o2loZbefvd8PjdbxOwwVi54tDPa8HbYi3HZ+TrK73a7qJIoTq4rD2PO8lMS7PrTTAZxSzILt
0hhNommq9NA/bc6VGNkTh30h1CZH2PdfgR+IJiQpRypHthxBzvoHGcejV6R4FCaxeCN7KJih
ndeOIXVLJI/4BLWamd7AX8KYJWY3HHVOnGs9INi9+KCUErmXr/at0uGPTJsQdkF4eYm5iqQH
nkoeJv5TFwOcycAzjb0GfyGgNqxlMHMjx8LXQ8JmdYjCo7frAQd3PYSbKmkNlTuXWNqoV0H9
xJc4an5FWYWLqXn5Vd8nqYz2+jUwARqnWysbBpnw7IphXi4Y6ptQnHcvizqbu5WOPty+N+Os
BzxmjtHFv4p+rX7NkeTI/zob7RxzrvD4ALbJiXVBAwBwIWKy3/vj/WXA+JVVI3HIz/MtbW0O
5IRiHKVCmGfpW2qypYxd1pj35NTf3vOmm7St2DM64K3aJaULdvjqrertnJvccx6w1F87AXuZ
BOHq0PUs3DGQJv2FV3BZ+xe7LyTe9bf+ILZlQvYm3WASf4yfK2jSiH34BsE7ZHGbQY2L7fSB
m3ecgr5xTYguRGyeVBu5G9jhc1ZKfse6gk4kLibGOo1Fu94N+oFvT4NNdUSJF6pwzVEW90e2
PiPRuxjTHRt2nmTSA9mpBFkzBvHft7PQ5/3Iz4OkFKUJzL84R9jm0sJ3BomgYClyXlHNc4H1
Ff3GDarvEeLVXGbR5LldAz/XZuadAxLeFaVArkAT0TjqTlevZY2qfBLmhxhxfP0eEoIYZhHJ
/7xV+N19OF8vvkNJaQWax+PVA+dA7XPKdua9cxMGdH0t+Xy7448UmvFWolum+mEW923VcQU4
jU8/zx8d4jMJjGTNWPW0JB/QPdC+7ns3t4FEU/swQZGm24TQ/1M3jfYox49Ytz3EKPI4o2wf
eQjm2PHzb8dhNwFGtL7Osk+9B4TEut8HxVb6u0eMg2STosdJBzDjKLFkb8cG8hXHRm85Fugj
N7mvQwrubie0eoWbFBvqed3ggioPNSkIsTwXQJ8WKyciAflKt5m1BytTsd1mgg4HaKI2SNJ2
lwqR8GhrxdjkYbYU+2ncCZay8CCgxfGXZxjARw155pwHWsFNNyPhgWQexk1RsoB2EAS8MP8K
HjgyA0MaFhRap62kf1f8QcFisGNegGgH+N06z6sHFZyIjKWGXIQfWCFzsMLC7SrWsjPkk07G
F38ulnyGDOnGbtDLuExHZgeNebAbGrMATORwAFChAznGKzPSrv1H87oh20iuJJgHHTWVdPET
1HtM2POzLNMqSImvjlLZ1yVDrf01hbuiIrVqfpjfh2/IU7rj88bl6jdha209mnNvXnyhYgmI
3ATQmw7qupUVD1yb04mhiR0jtTOpZuRgdGTgEGO2mFB4Uz3aAWnJtpbiZRab9dJiM5YhNc4y
9jM2oU4AUrjbILPOrk+Sup3WZC5XaxXNfwd/FSwXModXKVo86vVgq7MHNyDK15aXvHOaSOZs
YgM66w3bW6FId9E54zCNDC+9HLamhLZNMZ8U0pDguQCeA8LM7gV8ptDImNyDuamG1J1ACKI4
2XPlwZXTN+f+QAojF79hHLW4VlEeKA6q9S4KckIXB1pPA13rP9P17h4Ho4BafZCez2m5XvLx
apuajKyJI+CsnAmeTFAWGHEDNV1/v/5lot7CjMspCtgj8tGx+IcjxSVNWDajviTcqSxBMbEU
1RVzp9ZV1ngdDmCbzfCDYJYxsbipKz73T+XHt51GQKars/LAsQEAv3kuYwrhXMdVBfIFSrVy
4V+e43E6HO2gpQcDs/MUCJbM3xnjKZVa+PnyP2UZ0PmO83Bf3z4pWQ5Oc8Vyz/I5bVQNZOzd
VXPBbEC/gWaeiSZSLdcLDaAXMCSZZOiX7bgjD3y7XoVHI7j2h9ggD642dZKtz8L4Rqcr37c4
mH0RqOb4LcAKWv4eimgd7CWRQlaByKFUJSH02iF6YksSc+/bDfliNrRExGk4M0Xy3T3zl9+j
sDRsez+OAGu22Cd5wgT2gCWH64lhKiH/qKrcKqq2z8At4J8uLTsxURWHypdPklzFYo7oHZwB
f6Cg1I5NplY92bltnBiCNVb7H8tM7n6HwHolENi+G51ttGLa/p2Y5BLNgXx5KxoOZhHDKHcN
npNZxZL2Os4Xae+1l8W0E7Hwb0iutZrNO6SUp5QLfP6quUvwRLBRWB45m65eT38rbxotuZoU
eq9XKUqb9QDwThBwK6T3j6n2wgLZuofFnPXQ3iTGOQL/q5BGkz9Gb1uq/+jvG5vtN5YiIAmX
Sb8I7Vm2W6FQG5N0AOQ1T3X6DWVf3Cnz5gWnJKJbwbsyi0UcWM93G1BVZTzi74cszpYDGL9u
Ala65MuYzYy5xFcN2lVHzpbTr1z7brkanBusJ6IdE38Q8ohabg4HibeJTfYER2D36C1RjPGG
BjsF8I6lkLD5WqwyfLz5H++uPeuxPVnxuN7+kPVwsvTA5PqPwE6a5yZO1Lx5Dr/Qik7WuBuZ
XK02ZtuH9T1uAzBbMKGiimp1s1ceK2PaploeKVNTBowsoPos0HFv1vAfPCyY3J64D1D8vNvB
FG/qIcCBysnhzk/EP1UgQRUcAnNGNMXMgsBr5lKSbHi4DVLPPMgC1JFwmuwXE6Z1Sc+KKqci
25Uj4x1VHERB1rn8ipOFvSVxFJMtTdT5Pa9skAnv3kd7leNikoba7RC7JBgMcoASyjHZiZqm
PmhfNviv6UYgAPsl5hwF7DVSMZT01hMztnsdXmslasfWUSJR9NQEkuz9QBDZexErS0kWHv9U
DZNaQgI46YUgj/JI4+U9/dPfmk/VDOvK/LnryvbHaXeF+DKzY0c8wV1k3Fnu85PF+WejOJNz
0yd6HRBUlCULPq1j13af3K7WTsD3TrTXg93UHkJQi3GeXbaVgoCZFUUpNAn+r5Kr4CenRWEG
jW2JsjqV89k97Y+gWMguqbn8ga8Jeq0XRhoDtcUtZP+URdOpuHYDZO/tAguLGyg2Bgzoy+3g
Ij2rCpNETrrQHvkxRCzLAa2PvUpY593UX/e+62njlTdxJ+szmHV/eAhuZayAMlR0BRD/tl28
4837A0lyeUZUxcH1mFaeIy/f3V9qR0nWwIAAdy1+Cq+pIwRw2/pSJpYb193p7AE57z9SJttZ
O2qxth9iJ1wQ+HB2VK+x0nNmgGm/GTgvCvJWFgptPWuoA5ova3m+YpjJ/PB/t01HODZP1mNi
7O413zsN0S4M6qqsE+P33KykpJphymSKd/LITuRU1vT+bqtCIvgr/N/BhPEHwTfGsnv9Qblw
5dX0x3QsTkDiXczn0jRuW6OGNLlrv4N4m5uo4zO13P0SuQ1Rto/jJHagyG9eIxIA139FOHIW
HGJCa7UlMR0UHQlj+cxRjS6mfr99CNQApg2aEHojaQVo0A5OIog3mlDeZ/I+RIOAwKgGWB17
VABuwFPDbl2yxHagpc4WV2pybzhxcYMTHpSYOMJtP2ycqmezudesXruUa61mvikNJ0QzzPQ1
9CopI2cGoCIW4uJcoIMxhPUZMb0x+0dXlgMGUs9LfL43Yeup7w+zjQ8ZipsViZLXAZ4+f/Fr
TlUmR4Ed44xwFFPIDCt2mrLWrbqUqyLTzOpJkDTvmJ772tGWONMKPiNupARsHf7AFjoT31Az
q9Hj+KR+GIZzm8lKptZsXDnXWBsqv8RZEoGMyp6smwmLTt8rVF5oyUM+3Go61cCDSsymc4+k
pEXQTDI1i2uSMAboJGvESyFP32Gm9ATtcHtJOzNwk9WTYXIJNG/0+ykY7oKV7ZTFlVuhR3MK
RmRduzZQHJHeeA/BCK4YTeBtnORveGCrTixw5EjAahKsiogp7EfgY3adupsO5AWUFYNxazLc
ySjFtPkMI4J66kcpPQGqiMQOIHkjLn20VBMaokgQylXjcDNc3XB/AVWVVyBLXG/+TlRDtxpb
pE2HJDmyS4x5t76iaDUscCwvTqn4N+mOHXE1cahFtcM3sHPZLd4vfA1LBVrGaqfrYsN1Xsg+
kA6gcJi6xOdwTgcPFpEdijyQopCUpfT1atRRIHnafXcneZ2bEFKVXLlCVpoNX7kM0u2J6BNX
yD4F3/OggfYwy2h8dGBkN8xaHyhSAKpuTCVJbpckpC/Tsir2Z3et6pjGEIYfdK3pHuPpI0B6
2fJxMj1njiHEVNVHcGrmNFkR9fyXYFgt9nWsE3SuYxNU5FrCZ0mJE1+FbKfmmyGlR1hfqcbA
BoAf/gqq4RoByawLgVOXERk4iA2tTuJnL6WJurBEgDUMHrWrPpiPFWcDZaQ9AMFuDW5rVgrf
1vvktkRo6mqG2ONy9+dapPz8E+IjecKOV48NsaotHkKJqaJMCI/4Ir4eiDcuRUTvA61wlGf0
PxFcwwJUwu5nPTklia7YQNp5SH8DE9n7obIe/tMRY4n54N/SkJVWL8TBgZDiwExWiJwqENxd
v7V+TXbmutHn0m1n8Yj26+RCg/M8eCj6K3lF43Bkg265a7imsMl9cnpQTf5RySV0Gxg/3twx
XaXtewEn+Qv23bxeZpzgVLQBvfHiXm9OErCv5uHcoBSdrn1+MhsojWmVJQLv1crAEwmk0+DX
5uDGRhxMBbgCg1yze2tLaU0P7lKg063XTPWMP6WRqadntuJndz8NBIRUcconxW1254SnDkK7
Z1Xaji6vdO/kKRPX0JdU3YmB/U5P9dkF6f5W08I/uzwaFjtaEOt2uuny5wtBCb7CGl00I+ex
0C0Nikr7JC3DL82T2r5M1FgT6ZY2A68QQLcxqel9Act1wdwCB99135lfxZCbfXw+mLXq1BYV
M+7RD6xtnwa90Wn+uqQG+vV0W4QTJ2gGOhPYTVzzdQ+4brL8PDztJAjAbyf2XNNZm2P7qS2a
mIwk7ex7fejEKDVkZPnjHBxWQJPhBU2RhKbCgKsp/yBTi45dJraDeFMSJDrsuhhWfkDFovBq
A16U7V32102YP6AUCCzFZfvOTy21D9zvNAlHBK/q1aR4gmCx7AMeH76dvLxiyizscnIy+c7I
sVo2nGSAhOgeAyU9wt2kTUTNU1MCm2KK+k+wbzauPsPNXUWhfF4tNWKGfnvfmPkp4E5wYJqp
XpI1ho94/65zd4UKgqLB+rcF9VSJHe3ajRt9UgPaVMLyJc3fZH/6a53tUPp918nRC3YhzlXe
YIMYBSQ8Y7RmWqCcdGHjL0YGxvC89wVKUr8gKdEEe/GXZcaKXSNBCID71gVsK7v8XgsuEvm8
LhVkKXdUlHqT5dAHo2oqiW6XcHtXHxyFCs2sB2rsFSlcREr/v0m7mNMoQcz/P+IM8Vgs7Pss
5YWuQ/hEh7ryaJiOOejNGP9tmrvJVGg67Q36wLkAcJD0/WPZtyhPNprMOmGAQ2OBrXxoq+6I
H/b8tAbfjVPJbT/ff2frYhVOYuxv8Ukt7JDGUGSH0e6GiHU88/dG2CKzUQUFc3nGQqe6/jHU
TpWL9YbtiQv+CYaATy9y9cX0U598NUiqF9nyHklXUo+JTjHjy3NYS3sEuXgAcfpudZAz87RV
t4j+hgjkx3xgEq6WInOFmSa6oKj0zFvgXVPd5MutEgynvn/n7db6VKT86nbN1yo1r2JoWZ9N
z5UShNdJKj2X/6IlgMnqerIGjeEYDx4X4Sv1IAqCw7TYuOicdS5/g79CDof/YoFYv/DkIFl5
U1a873836D/6x7hWQpYaMPbojsxzBFaGxn0tUa0qJSYEMQNrJx3KP0KzUnMBawNhvOdqmzPH
xu1pwNgy3U0L/oqtAieuwsUMe+g44gYGF7SAlkazzjD0K1ravgRI3dKWWC4N1GtToVspCg/D
2k/kM0ePr1+sd9KSkYhnihW8FpksQBJJbhiMMEyRj0Onl7eWg39ts8LBXubJ/Tu7mM9cb2By
PlBD+g2CpbHD0vvmIEko/fAKeUj7G/NgCzdP811YtIaCiKjPkqXnon9hN9cO4Wg+/T1kvYAi
uH+e0iW72lBe4/wwoW2UccV+Ql9IdaJm+PtoR7GnPO+0Dq+iJ8I9xWhpF57zb+mgPT0r9uaR
w5qxsVF74DKU/Wl7Z1A8vVAlWPagpCkE+QfpDqEwJKawecwPKBelso5pKBmOqVP1KzuXFX43
ONuPLHSHGWf+9gNd4+EJOhFMUC/LgQe0ZQBQJPzrpyza8Y8NYMVkMVWwoTcXX1Eq6FABMBDS
l3OVYsRj8wekB8598mFl5FjGqBOzaUtq8ynsCt+Clt6jNTvN5SMLqPM2jN5n9Nb7/X3Vm9cT
zf6VVB21UMD840hjv/W4ifWqokHBiyki/QMtqoCbb7k0DcYtMmtPTKhu0oloC6a/c2bNQuNf
sjKiQpz6ZD5YYuQpzG7yZIiyyQwFv3zWG/XiNqgRULKxkvG3ZgHTjW6gRyaHhkcB0TLuKeP1
E6Y9hiWBSXu24gu4X0IUBpnrTYgO82CMto6Cci1Sgwblrxi9aysib73Iej7+NbEsNDQ+MYrb
eIG0wMmM7yfZXjThRf7YBTfjNbX8iHfiIyCUTy2/6+OY6JzAVA0N9gajU9VjXdvwrUF38YuI
cxUq8nvPrf1mNUGC3ZfzH+hdalHOR3uDlwHGLq/gTTakmh+t2L2CdxlJsPC7+Rx+GkyzMeQp
5yhZSkfalcQ5x+FKE9L3809LW44V/aBSvBaoR0duFersfzu4fZcFlYZeqzYR5C8/g2dU0T3H
rI9vt9bxLLuf6BNCVTaygb7AobmzNYyaJlGc1beOZsqNhlbTXdcXggs9LfRJvYZ6i4FMSLci
jqv0Gs4n1cuj6e9dH4rHlGCJSpTcvJiINktbz1AZzz1XvJnI0WSbByijBemo3qsGNEYu8Qh7
kIuWbsSnQDvfQ69Gkmv15v9+7nNvW2KYD3PlsQmN7L+Uqp1A1amabCiRlgam7MX7sk0M3hRn
P6SIncTvpWo35faJG5gSN8m7BsUSYnTm1k9dnYIRhzCkHU0VVn31V5RJr4NqsTxWJowYpz9Z
oHfXwiFMyZwKoiB3NmMUE79oSXrRJOTIZco1dpqmuke+StlAnE2ILca0HdXS8evbsFbmClYY
s8EPYobmZVMPyb+GVrJDJaYuWa+NrxvdQw3CFCFAqtfoaW95Wqm54eC2H8Z8N6vL2M6fIJyA
6Yy++bhoaluAGK7fLJfDBe9/cNQQ6msy4GRuuw7TrKw0n98NRSzwhHl7ei0MJ1MDdVcK4YrS
8Eu2kBVV5P7UWyWI5UpoPVkXgBYI8RQcC5NGooSDlEZBxmT5FKlGzLssKUipYGLBE6BFtpyx
roDjj4AZr883xXx8v8rEOvCQG3oi8fXE1zP301Yh4sm5VLHEiQP2YEnyGJFjLLQRKGNs7Uak
6j1Ll7XAQo+VahNM7HEMzbTP23Y48+qljlrOJ2+4LzJGI5tmOPB6W+kRNNzemU6IjZJNsji7
LD12HwluW6cRwdJfkOColY3GnCoXAKExQSjtuDUd5+1freDUXAcYeUu/hD9udmEjAiaYBbu5
r3HlBYLjQgbxM+fJ9sAAW74Jq+53CAND0hlMIPZ0wWDslqUnfRKK1BE7zA9Eeqw5shFFpjRS
oQL4FRaDN9vB4rHp6Vmw/kneVil1V+BZ7LBpExF2jV41ZndOekvjewEGQi+3rhkFSVn6VoMW
ppQ9n2EAYI1aoligSUpD8Gl3eh2/A3e25nYsaAfIiFn+1f9mHq+LT2NaUfuPXJKywkZOCd3g
qOqLLH+sC1wKngY5mPu7NpeDMr5+hpmnB6LUQfgiIY1VNbh9je1Bbs+YdA93yBhvU0p5vxiM
cnGmMVONHBMExu7eK+cEoWbfrPZ/hJijOxc2cOCF/LFV3QGhY/SHqq4eLPFoHAhEwTljva6t
HW/TH0/v7F59VKTmDxuzMoKwawvInUqn8A6V5TbT2ZtOkCnpSXbnJMxj4WWjHfR0HhkHMl6G
7dg6Dxd0uAkTHTWP+3DOMiMgXp9ob8hVjaE8k24ZL+4zSUzQyEkV4Xv7qjBL8ldCwL6DMq6E
abANI4eaE0ECwDFPSFHL4P2Py6hiZprnjJs72BnA28fCiOliXxT89QSxv0yKrKRa/9LWHqhM
tMNVrO3OyNoLKbt7mKx8i4L7fdKRzUY68qq90XfxkKQu4+3z2Z9okbjPbsdR+8Kmhw4il2A1
8iYhAZMSr044VsZNWPg9rfHjHqprAfiP/KAItJskPnMWbCgTNbiTYnuDNBdxS5LLTXrnkH4h
IG5iu7WI4uwgR6LNW1sE37NjtKjzSKvOG2KbAPMBzv/cnHiBQPgRBoWAWOyFU2VEu26ZW0Ne
Y0nT3FzI3qXNBMfxM5jKpoP7si1L0aOW8JWKwoR6zEcv6Oj2qjA0kXXdWYmQOxM4Bwr+KZgZ
S1qPVw/7iKaUOQzF5ZL0pJFQB2nM2hjbpB/1q2cyoJbi9MphFnxoRhw04blOZOkWkH1VQ1tO
+L+MknjcU2rk/3ftBmSpZvhSKHtPh1khLGoGCMNTnHg4T1pNYBOia/SIEVSkLg6N93W9sWfg
G2x3w36kvnhLirQbcXbyw/HsMjkYBPJGlvM/QirpEqBvisovxiLZAMdK9ziDaxp4hh5/iHRG
Yv7RHT6xxx0iwmACJP6DIihdPjNN5H//2cef1iXSbx329b+H4YSJEHwqg5pFalUKPfuv6AgU
nMwoMjyf8djlfr9ipB+bPrXoB6EsNTCJQHJuR3sYWm3G2y3MpWR5tIRdc+5mtvBDF2kiMK0T
es7H5GoF0kbja5quhnw3w0NmBuEherWQQfpE0UiRU7NjKhJF8d+i2Dz1Wyio9XMoPYEkd/af
BP6tfOHt/Hai7vpGygZu7cz4Y6w0+hms6xMAAkqbldnYSOPqz3CM2GaY4uaBXR0DD5OnbVnW
PVtiUagGKGYE5cDDkL5Cf5lvOcDyvykY45kaYIjT9BiN2q8dHPDGm6X5gmVUeqzuWOKMWgRT
3g6uZODktchTfjnz2/QkyBbI3Yc5cSC1HDQ/ZUW/U+H8mL078CsfS9izKG1jG93nZKs1Z2HU
Sjthu5Dll0mjCp0P5Jyg2Djzf1Dcy67P8J1zvNxU6Z+opFYshwBiXVgYTenAlCQeux4wzTi2
R2RN0ZXrdpRWJK6YRjaPPPsxq3rltdRs1EanJzzURjRPph9q1oAKZDOot+46RQmPCCly/Pkz
dCfbH/0EiMi+gUaCTfUnldy+CwWNi4wBrsI8llLpHLR8FH5GSDCGfYv77pS7SxTFC6eS/dL4
EtnsN9AHy4W2R2A2M7MfoZKycVmiuw/oyvFr1XdIKaJIh8ZfrlgXdi3dP/+TrPXVfgPZ8uOu
RRHsj6txwCO3Ac409GpGnCEPOipXyxHR4DeyYW128XBCOiGAbv3CyVAnJyAYcQc9O8XNC38P
KjkgqZvAqcRQXQAkZhGZWlWRM1hC+RZfviA5/tSPZxNf7AfuoJwQeU8qaSiCT13OgS/06njV
DCKTE8r/iG4KwSwkfrIlanyWhdFssjESTxFzb6lGDaJqdfyzmd36JoaWWLmFwBWVrQDyNyJ2
C/PUtRN2BuiIZRGFRxBv2Y6hbYTX0ArBquGxwVhcbt39thI0cFD8bzfocHq6COfPvk+91G2y
UQFz1xNIVUJprwt4XS1w3gyomAWm7B7ntYzl8BtadoTfVGNJNTFc9qtG9Srhzz6sawZFGbTa
bi/KstJO9p5UPiNMprFISQkkEWnW0i8mDUl4P9AveBxZX+a9XkTvaTeGWqGoEB0gJMDgh8N4
7CF1MmpsACfgma2ahOKzTqB1xl9gVvfrQ326ptRRRincEDtzEwdO6le0Lhf5rEw5oZlIoLN4
yEwinTJyMq5etwL3lILZCG45zCk1cT2bkgQIXASxav+9aM7fPYaGVK3OLaL2Kf43xfEeng04
1rM1fq+QSU4a1MjqcSdAHn7vA2vMDHt1JPSWcSsM38R7pTSl5uzweDRjrmPolhvnjpPZraY0
Tz99uQVTEvQ1ajj6B+s0MkSdQ7Pslj4PCFrtITYPev4XW7iqu1GudSPxARg2ULZivO/JEten
3UUnKmuhVd2l4rXPuNprqZdOa9sKdTTRbVcq7B1xMEgbsj67vkG4jNi/21jZp2nmbsJGz9iG
BmaW5wZ6W1HmtAGLygfNFgYoIzJv6CkrcUjmRT9szdMNSZ6Ec1BTPUaDg4By4BpLYU0h65vl
UCF6So8zgy+RAfZNHFUkfxmiLsKYfI/3twoSklX3ERCuE/mluKzqJEaxje5xxz+71Fitod5L
bcmx4dD6WDWHRzApqxkfFd7YPSQ4keSGhn01Mn1ArBM70hcdVJ1n3JWT+7brHhW3aQlieVmQ
SOMvpvpwud8dLW61fx+wCqBT5L11eOcRPwro1ueXxdFLHX+lfdtWQ5W1h60IrjJ4bpybgbKH
qVHaXdIT/PUPJK8YwEIrce0QVqAm1azcojRUTdgVMF+b3CLPKaTJVyandG20QYDnd0SbfBJ1
FzCyywRVPo27dw7bGBeHGNuNUH4gzEjAeJOUKko0fGMi42tGNYcM0yHapa18MXwx6MsC2QPe
ltTpKVf0Q1wOlMZppOix6iEGzxixxi0hChpbvt2JhsZjpqpOTD2vPG/BannfVHdU5lM2/Dh2
UMipeyXS4H5veCELkniCbKvUV5cQzQRJkL7k6bX0oMZItaWAkLdZuivRPnKeJODO7Rcxvylw
MdBVo4JBOnXM1SmmO8RjubD0S6jHhBCzqf+XBjuvHw/Lzvr0F71MFJqj17wJFskpRFjXyVya
smZDMMYbvgKkNVgtC17LiDiflquFmsay2Y5hfYib8lZnFlWdOIn6BRswBgSVDrU0MEjyNGSP
oE1n5Aau3Chns+7cnQIQYhGIbSL0tZLT8HndRIx7weqmyDunQ44fqRaZ8qu+oagFTxehN1AD
ycET4Peu54SigyAFC0PEtZrDFMd2Y79fxMYAPIheziXGBoXz+OCpZpr/CoV6lxjTpjWNaV+i
tDxnrcKTOIbsrgM/GbDf8vK5Kmqpb9HTMzAOHxAk8YK2s8QvGq4CWo2sV/KULzKmGNQYL918
bSwXGb2CxunBl06Gv1Jf/T8vicyoofofME247Wa782TM1rXB4rrncus7D9A/dgGEvYCxbOMa
S51+Yf44p8Cq/5syUw4e+w38D3217TztCSS3zD2RT1J495CTwVpSGk+ANFkNenIWvVW5Ka+k
KB2uOL74NSzGZNBdPrfX8DFWRKt3cPv+MqdkGxjm/1652i087DOomcmtGhi4Sjh7HiuhgsPM
xyrQktHQQfaE0BYVMK7dZ8diFiAcbdiKeXIXAAG5405SPIuqEhsoqNPEMzRdHr8xwlogWjA3
U+ZXVhYuoqVltnFDBD7wwPaXBCkBEf/4uGOGNzgM+3fRAfHq02x5rJwYV4jdnxdNNYZXmsAG
ceIOr/d2Dw8VM3mhl59XFZocmHGzsmV+ORJi4FrI6MSx2NrcKv96oajmcFpltekeYfbBmu7I
KMlgY1DzxdAj4FagXT/94yWPivTK0d0AuRISA7BikpEuIqEhvgBOsvuqljm6RC4rUC2uyLBj
PysRTtEKex62cCXc3DPlulBPxADpBvmpXtO2vfXiuq02VtiKQlmZf6Zfg/SttgwvDkSGh6qs
gKv9SEH/5BnYjkPqJ1vYrfv/qCsvzYqNOx1go+EvPP4zl1SKwCpYe4kLpgfWWubePvuP5XiS
i5J7eXqi+f1XVoA0SOagXfSrscPSr7c61oAnlg2QPE/4jE2ln2UnhIJvZDhwY4e0NytxQH0S
05ZLXFTgfPQf1X+yqec/9wkytGAeZ0BHxE54QGwIO2UFdWs/U0ZIl5qBzeLPEYj5b27pFUk8
IiowjtqoSLzwtepu6pDFsPa6RUp+zWyYjGC7vSt1fMdcS8NJbE/JiMqSWg8ihdzcjuSQuTVV
7eD9uFacQ3r3v6YDZR8oCDd+Y9Lw6ytiTetgKLT67GPvuZWKqwLt+dZjlQBou+6ocVxMe6qC
bGwKbwEnmjbZZqq9xUrs3IUJfMkht+nKX7iKwOX/AU16ksK2KDumMBLZGVEJg1YIC8FYhynE
Fvp639Sdg5SmhHneixfFYSCGgAv5zBtVU2Euq3INaaKZ85epbN+pdEy3YnY7AK99xz3JF5CN
GT5ZlpVCD5yxqa0se84mw9j/4TCeVNIiqQ0HS4uVvAm2+5sor17Mb4filXnfaprSSBnDVqrA
3CkcSWUlMphOjgwKbCaOY7yBaH5dW+GUXSSgylzLwyIhpcwZCEYuMEIEAdJ+EnCeJZc+gRKt
rmQP9mjStY9+gbEmxNGhIrWauApmvVDH4eBBHkHLjf39oUi37HD3hPVwEDotQuiG35dx2hbm
MbyxoJPizLiewilr/ua07JM/knnbyFtOobV9RZAVQtqUszOmBo8PHafjiu2SqJyojfBI0L6H
+Ik81qOiscCIti2EBDgfUh3Zq1OQcNUKb+F9GxMQPl3DZt3+sK19CBiReEMOIQkijD5RB2py
oM8wwVkc4aGqq1GeCDXHSz0rT/ETkTz6iI/feyTxnrI4JU4lDY/84jBMAeB42jBl67vlv/E8
t0bq+siWfUuPyy5FP+FM5jYsTMfLga4fS2iFzu36Mnj/TUIb8NaGJM4SrvCtUxP+kOKjUYgw
vOStT7R8x3SaiMa7rD2d+wmoUuqa2xXHB9ttQrbDD6/jFY34zzXs74IfSDHQblj6myp09vzO
Mgsf/R0SCM+GIixsD+rfEKfz4NPz1U4r82BUcS8qrKMRZi/tjjG0Pc+wJZzzYtxBrQGzCoA+
lB+WD+3kNAnkP79z/oFZ29Yhqi9WUTnzmN00lLc+OV6x8eLI1Lt25QcIibTDGPkuvb9pkpQA
8Ei/DJqGZeVBsDmAAFWv3fYHD1r7cgWgKjImrpNu24S+zseHbBkuUQWLAqD8xW5RKPEfm962
yc4/vaukUoPWTXPrkGSGBsQ9iJH2jtlHp7fNpEPfDEpvhlp/Z+JcTEDTiIHtrUcs4iBzdB5N
emSMBgeH6mgg9tllF74qHgQIkA3RjzwUMS58vML9qJ14+2tqsLfQm5qSi0I+XXZjUK+YY7EB
NF8Fa8sgEmnbq/qANknWtjM6kciKvGNu7tLEh4fK9GPD6HruhFVSBmgmB+xBPfkbpLh4EEXy
JgAKU4YlG1hG0jHuDAJrqK7mpMeiJctDM1dnq8VpBY4eDpgYdVOxUDsrvf7sqK83O1hPqGAi
wbDmW4xwr9wlax/KJ1lSIq3XWonS8ltu7sx5zdozAZvApz9lf167tTbkZ7/iXaHtldn8busG
qsLR8YIAqqHgVmwXiwvWmad6CLYAMlisv5wNMm9vqwCRHBB+94/Yr/vUv5eTydc7M6IuqaTZ
ZsiYDx4mXXPWo/0BNaQ5uv4nHzQKj0KzQR0OgGWmWgeosV0b3T857l4b1itEVIWi6/OurHBE
sZuM79VRtLnsL3kSQylJdjvRd5kJKeD/GA6HYzu3/DBidXr52VQGn/mtSD8aTyxrM9tDUn75
dAhVNS0CS1TAf3bx2iT6q5yyLHBUe8SfIzKcWNzHjt2zrWGFgfahlWXVBf9Vx0TNvpY4gkt6
LYiPASieu6wU41M9PQFnn13mDLrYdMUgwuYQEFETtJgF7qW2fVXxZtwm6BcjSUvd3zjgIF4z
3oQoXuMUL0WlotxFJCdaDCgBtcQDYQc0dDvgroO3de4RsrAoJHkZYDv/936/2bWYaz4mmWBQ
KJtTwhQyZu1a1MBjaDVut/Rq7TzWZ0bIo9VILK2eba/Qm3WFOG5uKZiQkq3A0efH7T7JgsD5
m0VAqJuyaITs0de0WmNS34H1er6vWZ2vj9xRaQfUHZPo6dcR/KET8T2X5Me1Uz0VfmBruWVk
kUSKQ2Yv2RVbSAeupvM1bGMSxrp8VUESBh4jKUg8KPBUQfMC/z6IMisX6KaijNTOe4OC0NQR
HqxzdQZnQHBIuNyNDrjv26lWPF+4pkpy0qbrS2+qWVXq27d7YFioU0aT+b0h33qKfvGQqyLl
mUbkKTgCuM9OsREkXmijSo5cHC1lHRr1+Reac4yPX4ofwBsdutKLysv2IlTUFsVFkiKhbSCu
QLA1wtgsm4xweS0zMCSH0t1SgM4xgORsmqAEY2o+LIr4flOsCH4IS9HnWxLPCX8HZeN0WerP
eZ1eQCkAfFoeG1JlDUzyytYFVQWkvEv4SQlE4evd1PKAwoZBbBZd9iYZBNoZvRdXenGZiPp7
+sINa3Gz+H9uIkkZlyTH/Ob22yFr5dmGqkr5BiMhFmceFHnYfEgfrbKxyENP//L9sriHqLQZ
RfWaZi6UiweMI9oqC7SpeNdd1fqvrk71SDwlr6Hed18L4GBPvEd9NXDmN3uq2q7GmNy+4ikn
kwpArVVkQsjlsEynYPMcUPRT7L2K57+2goJn4Ohc2FmEu7kyv6roCo3yP/Uw240yzlYFCvtY
Ww0lIvtW08lbDKciq8RMQH02DV8io10/g1TqdJYp4+0LOszeu2DgXY3Znj+olt2kCNwx20/c
pXacOLzLoaMKHdosVyTOxmWb71r3Vy7Rxm7rikByV6Uu/y+0oEcuo6IcV9WdxS7UAL0DenJt
hpz7eGhf5/oqsguO9aFRgI64NbZ4qOnBUq5HT6AdXBWWBiaWvZy2e3teuQ+Hz8P9IVCCu4jI
vX2duWUyOiygYpooOCjnQDO6mQKpjlTNMtY8NrCtkxKLxf6i9aeUxL+tdSTHy1JpAjo/Lzgj
iSofF8SpUyLXqT7zfRaI4Avm1Nfco8I+R0JTKSim2aYObIkdQrqEnYZ4UHfOHZUsf/NJIhI7
5ORVVyxj5XdrYsiAmtVfUHzpDDOBfGuRN+Js+9evkfXLWiGNzkUd/5aHcH+HtOk9L8HwAfac
TbJ+sGXPUZpytbsQi6ZBgz+U+pZj2O8aWTbjgEBuohi+BB7ABd3x2MmDjcMAwo0MdmwaszX8
p6Mr+A5ZmY/bGYNtJbmGxqsvfnTiNDP708vWG02rJTvj5Zm1johK+1LUt2w3HFHfsq0stmft
q4rDaqMBCBqHjtoUVPc96a6gbxiU8oYPYYfEqzlPrkIxZf9WUvVHnzDplBMEF9MWgCmO/6YV
nVf9GwM6fxNZYB989qjl/ytqXIjl7sDFPjxNvrLK+TnQHm6B7zWzGM+7XnYOjz0r5xeMHnar
zKIHqLg2fERCn2JjoxuC9WxZpjGbFPJaRls6diMuZElmjqhFO88OEKIZjNjsFs0vdtYObFOq
Gof6QWqhsTZya5V9l8NmcemP0RRmtVPXY9GbUzxK6Iq1Wt64EndarnOJWyEaL7zYVY1U9Ezf
RkSobioU3PP+SNK+8DywYjDBZyVuMlOPoLWoP7zMhvk2ulcbYuNOLtZJNIk4x4a6sqAuOOVn
bQxC31bXwLb4wEXYg2aC0TKW22CRRT2yZE99BLU8klX0CjJOPrOx/f7iuBMNNWzkFqJEuNY6
39BVyOTFz4YK8giiY1K75Zo54BITas0GLxZUAKMnv2Rd+73sCgYdKCcQVrjWkFUQSRkiEScd
HxaARQotMO1RhLcDNoHkxCfDSmOT4IsgFyLKGIgg7lNMAXFiMeuc/ywxspymT5m4NITEn2Kt
PiobQnIsCqzqQy6w+15c9uRD4ooCcbd1lp9rTIXNh6RkMw0LnmNfa/TPY3KTgNJfowqEv7rh
K5SIlGgOe+3/oM55MYgyf5PHVU+lczXAn3XRSNu5OBoS5KqRiaduNse5DfKySUQ0bHocfS3m
B2t2phqtGDsSjmeKcTI6eqX6kTDJTrCvkvmqvYdkiFjvjrJM/e9c3b5dcfrNE1vXFTffPs6l
8lFNQE3gic891JtdkJdlK1j3DgYpVcxj2aZw74SZK0sZvqGw60J3d2dypKTnLatRaQiCzcSl
LQzcO6z5k/idhOvEQhj3xmSkSpCf20/JQMD+RACSt5L/q/zMCzfj/SouNliEb1Pmcsi8AQOB
QGeBZjDEN2yva3JvJZt5jSiVtb5M7mf04OkdcLfwCQOkAN9UIHMmb9xRMWuXmhlp+7On/xCW
lMCP6ckirR8XvY8eHcf/d+g9J6e72HdHK8H1j/UajLjPJJ/xhRSH9zn/wsyM8y1JBkjNiBUH
c+U1C7+VAKQQKp8CkvZVn84qb6BVEfGZ+nL8T9pRFoIDGs7Lltk0pUTPHqEleyOv/2V/NDll
mgDFP8IQkFOw2sFcIwL/xwtdF2RRhSgqA7PCu6qVDynVo99Jz3DSgoTwKcHHiboAp93csLAk
7lSmhZrANy50UXABt/HbmL0LjQOByEadR43437zV0TGHvN+6inDIAXd/SP5vGbUKR8NkmvXO
kyOSCfm6UKIo3Gj1o+YqEVW7tZU4ZgtpIi5tT4B1j5i6yAOfnLn24tOcUxaI1EEMNGUF5DvS
s0HltqntRwW31b5wgkfa75LeEGINIfKpm8vNWmErTsbPqYzJMjA8pyRw+Pk3xFswGwKLGUjV
cU9pFmOIyNz7DqjnIwxmHJwBSskVp796w4CxZCV9J33UvIWS9/5wF1yhGzKV/lI+1kFcCxST
avOIXPrf2UqXC43y/kIL1eY8Sk0dfI0StBae4tvixLf5cCJohl5hir+dfqKm9JvpEDSRRQFo
mRF8dlbSUK5bxW7KdKa4UzrgSPnW4upYT7GKier0JbSA49DHT//Xl6snYrHbm/aEBfhj+A80
/3nl4/pPNtJCRK/SOx8rKea93k8WVlbW5l3aKKCG1pevx5OY/A7sUsxyE/3J3qsEBMNcD9Pe
EPKosEdmHlBHFl4ABN888Os8rgAqvYzjtTEU7Rum16w4MmkvgQx2v/cuVfyZrAgL/3NTMbId
g1nVvgS4bxpS41q9gA49eIpKumd264AoFrAMiIgDHp8o+w6E2cwEGUPOcuETuynlDGEJfaHI
nouUaIYFQAl9x+W26YCeqMNyb+eHl1xYCVDv9ltABBYmLizBRfoIRB/jYv+WN85vN94jZNbQ
+B+ClYATc8OBbWqOUZq4rhsjW1LARQSMjEBxCXEqDBt/Ib6OTb0+FqxybHbMYtYNL9DpICy3
Zdio+UsM6xm+n0ytL3CHJM0c5UWgGy6/bkut64ZJjcd/3Djn3cx2TQb9jl35+4Alevu8kq2v
EiU62XLyg2qRQowtM4yaRy9WXMQdL1wQnLGXkDWz2+Zqrsqil77Q5m+TiiGtfJCclcanY0Dk
VNr+bQUuWpj8t1S6MFGAoXFewxTJdzS9cKKJ1+RYIK4A2075aD1IaE6ja/giw8QYCG8waJoQ
eiIWJpU4o00PV9Zib7/BLZi0UfRfFZIsDJMwzbucS7ak2TV8DeGF0t7GVvtwqLr2chghfE1e
QqOKrTnJhSX3Dwz58urGk6PCH8uM0FpKJheSlEUVo/m3qGa6TagioHDG1c80H05lTRPVPEMd
bc1j9pLuDJuqr2OYYb+0F6U1CAyodigs9ckOkpvpljnsd80xj6pWVcUXvyns+r+nwp72rcRx
G3HF34pTQoqSeyfC3bFz9TMfeWu71h2Kk0wc7opn6n59l02z68epJbcXpFFMNve5eECcPL0z
66lR+uaq9UHy0bCP6nmMGaqMYhiJapT0BIETHwxj8Arl11Zd0PL3Ee0rkfl38ytHyQeaxrL7
B4J6qhzUbGtCEyReh7DDTM0C9WL/Y3khYdQdJh/QPfLGc2mPrmdbgKqqTOC3KUIthWPQnM4j
FgjiHuIWCl8C+P23bMKcI49TaBij5jt+pyFvmCtVvIffwL7BsWbv9kkF8T71LFyMT6bq5+Am
0nlj+NrerCzjqnVrSJA2NiY5XMRodEsm1VRpzmaAn80NZXaI2iwd12/TxYjF8s/k68sTLTCL
qKpssEK7iPRkQUmcUfcwn0zBGXcZqfzc2ssR8NqWDJXfRFiDnzFo+KaFNsMjgXPaGOU21dPl
DxsthqrFa8PQ9qmFy+MS2IOK0686hZ0D2BdXIXsG/pMEu4tkDYz9cJ7PGwEd3r6ZEnBFsUgn
1fCOphkhYnt3kYz0+SAnQCBvxaIMWaaFkepRug3pOaksQkQjX/MHvSZIQ6qzxv5pevCpWhXU
XKPY68r54FSrwFomVUMLvXuhFfOd8Xh019KVYaHodGGpVX3HTbtXqeHRB1Ym26XFgrtL0bYY
WldvdHPzKNa6tzKj9af2SHAIxDZLkvR8rkbqSiKyXl3eKmkiWey6QEN0ZIoijIFWHnwD9j4O
9eciWmvKvrzdtGlpsQK9GuAZdYH7n14Ims8GGBmU6Cj5UnY8QvnK7+OP0PCz/OsNJPBdG3f+
eAcmFBx5OXO5RKRFHJyJd7HKnAKxAJQDA2HwG56/aa7E6FynsIO2NMdLm8kjldMJhJhKO4t+
aQq6aE8FyzulsUAUE54QdhcAY/+msXmXRSaHP6N/qn79oyT4TuLdrD+7BlgKltJrcUBlTjtF
ZafFl5q7iUBjOWH1ADerR5AKHcoiQ/Y2fyU/cBD35vm37F+v3t7QZ6MfRRFwO/O5srlKebQS
vRtwStdzqgPXwYJqgffVZKeYxe3Af+6Id7mk7vI4tlcBJqq0OVsXTuuNJwS8ui34fQmllCLZ
snaTpwQLNliwlX8RWpVaPlTBhB4cR/QOOlQ93vQcyLmi0u1GAjqk46SbFQyHQVlZhE7X6Uwa
F87ISb2iB7f1O+r9ujyRozGolrTLRyC8GIec6YFPQrJPlbw5JY7Z8qjehMlO475A/JqkgYqP
SQFjeNpJDAdP3YlMHKE62j9saDWkHsqAGzf3Nm/b3zSu46hBYx9HUzh4x1SrVMlGVq8zV2fX
Cyov8rj9zWFDyldVRvoQEz2yV3UqR4Kc5hl4T5vC/R++UGmc79NI3hlIeX5PS5wgSr8Jg9sS
u3rCk+eQHDUouhDO2UIHSdWSJ9caxi83NGwjy5iWsHzHJZs4aoRWRPskcSc6NKGJo13AbO75
dEdPj62u9zRNOwW0nb/FKWJjg8majxUkz/Kh8Qpke1PwZtrMjeSAQSopzwLa6p+FZWDT3/9w
HaSP6bbUbhAxbFeZKZI2knRIstIrGhS+Or7PfLow+NDLP/tZOZDQ1ty29doExGft18EHwfXi
oXG7hYwlxLp1F1g8BgzSv12vEqYbCFGJytV6UzxnDr8BeJWEM0tLDznKEU3fEINquzmJTA8d
i9eGEtjtQ7zw/Hw+edLutF9TZ+3qMoIlW/ZRzCySqS02OIXuHwbrEYvhHhwXeWS84NmBvC2U
7tUEoQJhocOchY++rfUIFgOEAnQRXRK0C6dMbHig9ZzakwyqpQyFUNHeUGb8iVZT3kWHiPPH
wHFgZFTmXr2CkjtypcwyBhEAD0IqeXbnWaU5t4PBSgRvAN6hklQrkX01VnYOcA4+Nb2pRWBp
a1ARrWJmTnK65VKfBzHnFfkDmL5/N9MgV7SkFTKmBh/83QtT/Zfg8s6EUsaXvNPXqO+KwiBb
2LHcUsPZ1Ulv2xO7K89IQsvDxu857+CMUc8oa5ZmzbfgkxBtt0SOcmNKoWcVVzVBLzaWtLzq
xQpolaEklZu/VNSK74TE5dDliO0D95dx8p25WCyDmjgA7+GvOibmFYvUapPfRf4ZZIy0Ckat
o/Hb3N3xtIt15ZALx7HvlhaIQnC8ymuBoh/vVLxev5FB5kNRHAAlkNHL9X2HKXzEW6uut8D+
w0HWmMa6LPEWOenmyItRFk8ylf1WbDMwg57ArHrWomr8X+Uig7QoU0rRkF4++j7Q34jm6zFj
tBGPPWPTVJjqfmxR/Rl31G2+HcOKLQ8n0kQe7V5GtJh7JlpJlDhj8o579L7lv4hciBApHWoM
bLaP5P4D8UEPC8Qg/o0vt61/UfL+4AMzIuHmWyFE0qUbm6dj+8ISv9rCZBB6duik7eT4301S
YQucvGEJaUl32AuArObUjHpSBPiO8XgUwEEFEbxw6n/zSn1Tm4xUoCdVQ8lfn0Lhvk5TqVVd
wmyM1wogIHqoUXrmz8RGiG0t6f8hdv9dI3qpAHyS2HU6759LBnhzW21oAHZNQCHSYXuveIOY
zTKKKYQ8tC1FQP/km9QpQWZckWX41/2w4oDSaUzhHy3oFHO1UwFkkXurBT3FX2uqXEhsac/s
fvvLKBzitBgUO3dQ/gneU4gSNsuUQ5KVwTJA6f6REhNwPPMIhKkorI+gdkLbJ6Z/CeYx/PVU
22dZ/kc+y5NF2thoPLpP3917+Ryx13VYGB016M0OD1StazFAGAatbLuE56Ko1O/nhiBsNKJP
+gRHZ+EFA4Ke/Uzj8DgoxTlWA32HIl+qXn8k+S70MvYZPObQGG1UrLENNFqhDUpciKcOILaS
BzxlMWWwzcTDbEWq5SPCnW3SAIMUSISPmKmZIuVF6e+D6SFiT1ArbXPXPPkh+y3/tYDSbLy4
Jn6lX9sAJxwz78UXO6F5PkLXt8TR8TMDmzHTLKbM4KpakKhCrNCW4TNGXKQK+vS7c3blTNFO
vOPCyvt/dOc+PrQcDGCjZC78Pu9udRruUbuFyr0NJ/zmePcYDeb+MkClc+/Q2F/lGfcjPsY2
tSkJ8/LSOLkvrkOQW/IcVOmrVrWoiKZ4AwAcjOZuj2Yl0YpaFS4KhVaXKiVQy3stqLNYyP8Y
0H+u6H4lw8qxcafIY3Qv3SKXJmBJ0Pz1b9/VSVefggkM3WWO0/2THlAAfmBECU/sVeb1RsEI
qPcSyEEFf5uXb+3EoonPs4XkZAsX4E7AWsvRc9i6oXtDgZ+MSbcO+GSoOcd71q+4B4JcMzAz
LqU+ZyN7RD5Jq3daVEsEqKe/oGJvotokSdatoL67ApbkZvsqD5pysSnRkG0oNUF9euUtBldU
Z4jIiPTmmeOSlvmrGw+D4yF1GGEl2mlmullB1jqeaojHvMNhl1DRS6mMsZmpfvn62sE5BTHb
Z4BxZp8QltstTA/A7o/Ve0PM1VkI9/RO1VR2r+51PbHgoo4gea0q4y9Mj3u9PuZ9Ok4v+lWU
A/dUSYtOTL1PgYjrKWGjHA3FeGwa0wWu3Kcs83XO1hiH6ecnG5A2ozD81Z1Thb6EfEKvKiQi
MUBcAcDCkZ+eZMIgx+hnZXRhumlK5bHHOOAReCoqGA6mrthFYv2o9H1usB/O+P8xqgdLZDFz
Ss0IynBnM9F11v6OGUut/OKIRDT6caz4qdqWlf8QoC4BaBusLguXlRNN5kgXJKue5fXojwJj
WDQnWMMZMcvaImFGkt66FwwoGOKpdj8qZ+Z88S5ksW5cX1E05vQuVeJU+/w41trMjNuxV3Ds
tLm1h3YroE/2hP8/lmzS7LtqhsgDezij9XTSgWa6PqPvJm0nq4q+4FVSvurr6h+RFEUrSkH9
tKcGA/Su8K9ENdtQKZw1GXm93v05RdrnPqYUJs/L4cqcVNCHD5KBpo+Lol/OY1rUSXKhBiD/
rZeoSgIyCIyWT1p/C11hP1E/cl264DjnieZ0Q4yoC2NmOtyjtn/piMK52JB4vR3IVrWrv36E
FfcJ81vATJdofLSaCqiPgGVKL4t5YX5YvZY5x9wa+X+sEp76sq6J4g3u5SMa9iZHKQy/ONQm
ugiuwPShwYK9C/bxoGuH+FLVWZTurf5AYJrnLSCII46SDmE36yXm1xd59xx7Xq+A5r67QeAI
YwAaW3ja7GoxGpXQhsRxTYXLxYpINuoTTzXHqAxDY2PXFRDM7biJZvE32iKj6ctKuUHgw2ax
ru2GV05LOTuZDuNIcNy2QGb5Vq7I561v1LAxdIJXMDXgDpNGv8tORFilg5o9ur8Bfchnwyzl
Vj/doVTgurZEHYU7980UlkNtw46rop7WDvJsOAVvilRIlA8mIIzBseV5sEGqZI8/DRrMJ3yu
zfJi6eSYsv5K3b045ZTFxRZg7AkzYGoeE9OTYVDKsAaJEuEN6a0XB8dTiDAXbqllWfhYrp0T
lmn4JwtUOFo50tfzK7Fyi6X7FMJSdQFt5xSc497ojxR+ifdtd0zewCSi4WaM1s6btWgbFbdQ
l5L8Ybxu4k3oKWHHnBUYPOisvymJqp9ESp4/wHrDUw1jK7xRi4Yu7tesoGfguy9/23OeY15p
2hBt7xerQBCzuSPtTFvWi3sb/eXKTlE0X7N8zP/ZAJHU2UncEZ2bt5uk6AI8Zy+V+H8WbbgN
LJMv+DsuUorgdAWhbiR2LA+UtswqkoaCBOUqgeKNAMwwp5XJeJCrEf62ch2VpCKeIvg/8g1j
mZxvL6KQ2qIhPeWiVOMoB5MtlND3iDlGe/n7T/NMgCykW4ESuFnJ63u+f0A8qayYKzfImusC
mXmABgUP5tHTKweCxfvXlQE6r3BQZ8W4jzgQ5EUAO0QJpWbCnsB+srHoL7y5xI5kxox56LZz
Pchdq2UXR3dnsYeGzOhvcYMhibuu/uXA7wZNpD1uk/0YNQ7zfSDbj4/SYCab0GgpI+L+YWWy
hFDw27hV9MJiDvsnfaSrM7FLtHKoJ9kTLs6fWSBzCl1Hu73qn8xEc29zxD6nSQzSPdiTY8Yc
h5zd6AC3fNYWhBPQzJMM81/M25EQhm4HAtiIWu/9V1qqlsgIsDOCyWhbgmdrDiJweDqL39eh
XEmOuBG0KMD8Pfhs4nImYPfEdKOg/Zs5KbWC+kf6bjXvr8xyXJYlz3zye80Qj+kd//SdfFQ/
47jQjCDvaXbHNucDdXq6z2VOFbL/511IgQFkc5Vj692nyn0SaKV20TR3m9ZJGSSmLAR1V4Nm
u9tembjl0nftm1dL21qfshSLAYznZESV1cZHp2ogGYrx/oZ7jR5vitZTOX6RrmlqoG9K2s3J
5/sQrvVC/i9OgkKXM8VaSdZWpEspdS9WnBaDSsPZ2mlgCwr+xJVl/gdsQNlDpNsMmBhb9uJU
7J23J/5dKZLYgxRWtHBH9ssZWh0GPbsXEV7lgGhuOebh1OHKazfLJdF7Jk2q+BYT4SaHOxHy
we0msosoK5qplwbbm2nTGj4lnP/YT174Q6yZ7gKbDCAxNWWQVAoWpsUcQuaK8Z2DsvikYfYJ
04L59lm5MGukIyxvCo2jL+EFTXr35aR7djMt+6xlV0ZYS3MCeZcKkeHg2RQF6tKLddseD8ms
7NMj8KIcmdpfxFYvgoaR7KLdGw2PC0uA+X+BVc7e0eHi8xdzyeh/NCkKRv+sUu/AJ6NUdCt7
LbWzjReXmzdewEHFFxpjhi/KxCSXPOWwYV+QV5ad/CRU1g2a2VAeib6kBD7WPMPbR+Qb25at
r5GSB6ZjQNpuPG8+7o5dbm+ROb/PBfO9a3NUR70USouGKXEcltbzwXIZt+lmznXOPKL2msWe
onZIpRZ7bgb21AjHC7MmhENbJMse5T4081XmxkuowQRCvkhBCpYW4hdnfHlUDKX8z2N7gF4h
Jlc8aCxLcz7/T5vRR1npCH6+349Csd7xKYbdCzbuK/AqGAbLGWSnJX4OSVc0ZmrD+4jKUrO1
MGY+oC6lbFDksKo4MRX/WBTzMoIaaG/5JMBrXXk0mldUx/vXH1L4LfdGwWwOXRUzGRibWJqw
WCVv3LzvXmYrZcN7hIIE3Ut8VRt1y5DjICq2eZLIUA8xHu1JhFzaPzlJG+X+orwUGic17abW
EQC2ZatZobOPBk7CIOuG+ApgofK4zXsfoi++81FiJeNvBmkgTDsEV6nndq0D6H2Y0Ep5JK51
aoB0LtZztyCTWCRHDDX7Xkr/ovrAQSd4WY8+eXgk9DfL6SPxHj6dxgOoQApPNe/UerZLZKUd
8abWjCU41sgApMt9Rn4jPTLzOaGUKH9XClqwwq8EL/9rhEsELSC7aZPgmSDf7PjrjaIaTvzQ
DXU+0Pz63JX8sPUxjHAYyc2S0rM8XSIt5ibTqVVvcbpNxXlNaBnU2p10ndV1N8ihtwpVkOVz
OGkJUvHSNJVSsBNu7RkmaqtUH7KS9VX3/wUO2cKK8fYSYAPvMX3b92xdsp/WkmqJu+tdoCGU
ndL68h+KeNJucCpEVZKx45OPUVbJNxSf/XzVUqplKpigqSFItpJEBuGej9vqdG7yB7cU9Zns
kFBG9wrBekW6K4tzpljQsr6ct+lD0Z5R5clzZEs3gCZ3/PlIVuYsuRm18Xh5sEp1jllVjMdC
Y47TlQIYBMGhatxROtB83cwLa/JH7JwlVSeSMswDxDc3ePdY5cZwEiNfxCYlach4Jzv/ayq0
CnYdjNMcIzZS0yjS16tbBZK7C5tUSBZXBttwOaXG5BoQsqJgJteXcinOaQSVqfVWzkhYivF8
OkQ0zZc/C4L2iyYUZpKCu7BxNQxMlpwHl0PT6Hgz3mn6YP/w6pBDIV0Cq+BQa4ouDeKllbDA
2Z9MJ7GFRwT1l8BfvQmwDBTu/28xUFKH66hvBOf2iIeW9VwbsbpgworBS/KUBOagoovLWwXZ
NqtzRuQuQ8DNwdi+CLjujMunFJDBXjnXdSo2kK382T2C8V/fxIZjM+hQS/lNCi0qR5MiU7CG
Evmyf/DEJ88KfAi6Za089I37r+WDQ1Kf5W90dk+ZZn9gR2B5DefiXJLkX6i2zaXPC0ymGeOU
6wKF3287cttbxvEZBN771Lw9QPEC/yjbUey6AAD6O5FulSTTqu1kM3mutvBbiFpgeUnMLIWw
ybKJGz0oKP8yXrhrZYV1skTumHjOslyTzYCARqPLsagz1wRjhS6OhdbbKUZB64OVHWGQbBr3
vzk68On8efmHV00nMYEzQ8fCF8B6qhWxIHiFx05Ac6myX3CkdEx8m7z3wUCrc3I6BSfvs9Ms
qkxt4Oid/c8D4vZk0zsAJsiguA6P4gvJRWaJedH/bXIJg5zWi2nUm6ok6WGZKU21HR7FfkXL
L5mp8igeAxUxIaRNUpcyfd4MR/kUPk4WYDqeZGrmz8SkEJSTXVppqZTvlp+yZU2XnoSgGBVb
ATxB1SgudDlfHrxQKWrwDno+MPT/Dyf29w+5A2/N3zxy2Z0q3hbqzMgROuRlsZR9aCAn1CTx
3n5IsvhotuZ2/7cWTyIHrNE6zoSSLlHoiN5exRPR/knyIoYKJvt/l8Udez20tSBnuHlw5D52
RSm2Bbu94zQz2dOCR130xk5eiLF6Zk8g27MKBfP5VkfwAB0XFiexUOanxaaZ/nyMw4yRIB6f
N+xOxP34TCTWBqI47vg/BXvsNFHIsRxAUqyqGk1TBxMjdUtfV2MdkZ3Ppv9HTXkOBuVXBeZ8
uzRTr4p29NzcozI74a3RWUvaS2PoFAjb7peRA5Mug89xew6QVuguGyoOQO+4eCzzqv425y5E
GMgcwIhuYu9vntLQxksuA468vHmCPMCs5Upfw926mqth2nyQW22Aqmg0kVOdTJP1ffg3jMvv
Z2n5a/lvpkLwqs/JRX0TOROzWKwNILzqBJ++jdWUaQ0Zua7ZI/45jawLuDq4vlA0vwLQ3Tfw
V7G3pp4kYX6wx0XzbuLJsdgh9Mzp+79WSy5lT+KSZsF3pkTr5OW+yBJLNnY2uwh4WCk10pp/
eohGlj1IoUCnAXzMxF1AEmotGcMih1cbpnswQvMCX1gja0Rkd5pM266+Pak5zp+LkL/pmO9d
oq1rI1yU9bLZU/NaN5H/gdS/18clI1oGhA7/24WuUS6ubMO2vdgVsvqJWicEpjDniHPRV8HO
6aipw3y1Z7XTyN0JSLdIkSAf0S2tr9iLVDHtrK2K+t3RTr7qF837gnupq2u20oioiMwI48XE
FI1KDfriyVqKrCcGnTYls5Fz1LtHovy0pbwnRXLcv/Sy9iTxTNP2WdtQ7LRRU0IvhV82aCUV
BIJOZYmnnqU8Yn4wJK05k84dcy5Bm7Dz3lSICNbC5Yi4xoxCYt8HkKACS1cjKxHrG+UoGpjX
96KLngkKxAFBxA6s6paG+cozfn+p61WYE1XGS59xPTxfagP0wITJv+7tK0Ok4H1l2W+3AoMy
08DeoXEfGLxLy4Y/+g2exD3Tzv9IhNLT8tPVQNP0f5logFYCkb0/tBq882b8zQhujVnbAhV0
4zuYpAn+BftUEaL007pZ4J+fVv3a4gzSQBPtrsVHuovVeUAJqEkupsbZGrm8Aqs1FRbSoMmn
9CwZd2x3+2Que3tzxwBaHasUuoF5wQkMk06W/0MDjrUzMGWGAiCxyakIj7wjVcuYmMYUEMLN
t3Wbkg7mhmsMd+IlzXzr/Y5jwPEVy9xLrKXyeG5TJZ9HlTigXfROU1P6KLJxiWjbs6HjJNJc
EuPo1tPdmm14b35lVT99s/kNUev2aUJnUDzURnOK5RhZgzRPjp3vZdx8Rs22Fye97JqLzdvL
kXM5ytSxe7xwpmfHKuHWbFqp54LKr9hifIZBZxX9+8CntDBdkLWVqF388+D1X0sVrfWmYQws
nXH1omMfnGvUoDMSwO+vhM0BY8xVp+BU+ikFJN542TmWX+j5UHOEKKF0onXtmQ2V2AkQgE4j
QTiqk5qCQycUuCWoPWfDA87B2UpjPNzeXSR/vuOuZ/LIu5d9MVmPDlvHBDHL+ww/STAi4od/
+EMj1DOfswlX6mhL2RM9IKMF/5EjDxko/dAT+20YPI0AWl+kXg+tgFnVEuQDGTAlqsL00gDP
2RaJSfooG9VFDzH4r6Ah4w155iPMAFkjFWEJx9JTPbJIsb7qtpqNIsP1cgtbIALf0MF2qGaW
dwhq0j5HOPYu6DyZ/NmVLaLEWNZc0bRtdNRKPrRB6xv7eyBCdmiiyFlVZTBfdvCHjPd6nHW6
qjIhqVYLVCEh5iKxh2IrsqslBMQl5jcCYDyEEgX/d0ci+Zc/m4hNCxSeMWMBwbMYZ5r8l9m1
7D4aQfR5laGG3Ucw0ZLoaTo9TFdMzlyqohpPsr806kzCLCWSbkW4DxZ0wQ1IQqDrwNYV6OHR
Hzu+X0ilD+39Lo1//IWrNCV8CYuYmTeM85WoBoC0cGQ77AzGzMF4GFqvvGPtjFsJw0r8wVNW
uS5WbSUNvhzyUh4wQjjBuv3k7rb7wNHue6nUkCITgsLhEdXMV41N6CENSg/qiOkeIkpUV+dF
2S0YUDC3hXxVhXCLV75Oq5+OUpmDIMLBbbqIZpa0LyRTdvfX5u/r9kyDhgxiVmZkQZBKAeMp
7rF3Qjmkh3E8G5m/7qCzV9PyR3HA4d0anP1Cb0f3MOdiE4SgzlNViFuZOVInfVNT1ubEXrID
zJP84toWRGea2Lr+rQXi9epW65+8qMx9WEz7O05hmnM86gYLVUZMl7NeCozm3KGIPjGSvSU9
DsXnec+iIuLu4D3+q19l7dYwrbcQYbxMUPkJ2Y2Lzg9V8ALEu3hgiYNOclROtkrSCGl0gSxX
OqpJ4fCZM5spw49P/CVcgzqecWqwuJCOk+dELoy/cL4KNscvN9qK/YaHYx0csqsU8F8Wrj29
UxvfrLuB7BY5dVUhqWLmTkFJhg1OXRtpH2qmCpOd/dHwzC8MsxzgxuYxjeNCnxiMc3fXHN/O
FtopTmb+qvumN1DwSHanGafT/3uT7psZJYUVlBu5CUKjdirNYzgAKk/tcHGHzvKVR6qlHtC4
oD6PORiYHwrEwSHlJ/dd3VAuYlm7GCi8u2J9mJxOIhruUzrizfxw3gh6Z8XZEZLtHUKH/GBh
WcimAjjLKTpQPYcg/MlS2qndxirxrMUnRoQHsZoVeoLxUrT8P5xxgECEMdF97zLRFWGXdd+C
AyejzUAn5Qa0q4nJPA1NW8XMRTlo31y59QsMkKoQJ1A1kJlmnBJdiIQUxg0vhGOHbXmXy2/K
iTwX5W3ueEf8EVYTu3LlWqAUutHtbHBrMfFfsFK2T6Qqe6qj+THonEHTrv5g2JPRT4hnFeyk
8+HePtXTcoHSY62Ce9z0Jd5h7zv5azWbDNX8bZSJ7pTr8IgFScp3Th6U7iQBV294Wch5mnlg
i36K0MrqWC6f5Y3JXkfhmw6+ERPYQ56gRi3QkOu9IIfbCo2zV2FSiDb+JpkDYqoREB4Wicqd
AqQsnv3BkgzgUjVHuvc+o+UNqa3nL2RNAcMJRvVd8sDReg0ZVhGws40cGG8FW7iRUwmlLTbv
u1zGWYI5NUThGwV/QiybXw8N2oLqMFi7CuhIfSPtMccJr9fez2ClbExZyrV1/K4VhYJ3Mgzj
pchHSgJrs3F9AGaJfM/TMdT6JrXvsH7uS+W9vCOwENAzes9KO9KKaVHBunLGbC3VlIBv2h35
cnfsUmcs0eSwnBC97XQq83vue8djGHxwvvlCqCaUgimQ96Ma96nSNJxW1Dze+qLlR+NYraB7
24bsPBeyZslsHb0uxPWEgH7FGGrN3usb8qAA3vnWQ3tAbX/cdhXXTwFhhmlAvZBpxuUH87lj
dqFDxVr9eW5pSkliCCXFYi+4/m+UV6ElPaqHNGJal0OwkL+1XklqCv5K81eCyn84lj+PEt5p
T79ir8y/gkBgHPoBFBpZd8oNFcEyKtUE0E9RXXRoQSQ2uv1GuDtxyAi1uvovdUGTO1q3ov5S
Jh/fo3Js/uWMzhNryparn8FLr04FUURbs/FoOJehnf3HZXsI1ZHLWZ4jOppXrV3qAQPJDdyi
f//Zvmu/DRP9cYS2C4d676Gy1+Af+pZ/p4fXtrzORSjHlvL7SRZOT0BdlzbwYv2o9zNCmv8e
jxxplF8uuGYrsmilsUx7M2LkB2iGOrB9EnTL2ilpEmw33NC33yUSw9W7XeGIQ5ohf840gY4q
CqveDjg5lH3gEsutoPcnS7LMwiBwgzPlxrecIfmPVisoRTZV+ebsbYNJYoHFfHEjZpY5BdEP
x1v2InFE163sYsLMotko9qzyG6VDlAbo2IsVv9W29BRUQNBaG2UrxVP3YG8lNnACd6BilS41
+vPIC69Cu8EhNoy4wRDF41Gu5bp8/Ot7GCyx8sV7gWldhwmL6nm8tvEa6VG4BXJeC+GuYMeU
hI7LRtFvNWiv6e5+QayGlSf25f2VBHnu/5sLOD1PkAIX39a7eb9GghBHrzzJGnG8gVQYfvjt
W+KzjlTKhnQNRCc+25jK1sw8oPeVAlL/FnQfX9svng9GSbmpLV2avbRXX0hTFtJeuGQJJIrH
l2mRySuUEhpTuwhcD/T+DZFFY8seAjySvJzsdRlE8pmjtaIp55822MPqJcrA8UhUYGyAnAEa
KSrvJwQRQfW/3X2nPv7HglhM3s9X1CoI5K/19jvhpK5wym5S60R1n3Ph9s2olKQVeRHPE4qb
F6lFPbU8D9Ez97BkkVhYltRwcIuR8c5JtOog/KRdTsex+LNutf+5YiosSqDN9VKOSCBio7Rd
EQn5BfVBYlfaMED1Lv/CpaIPGoxpr2snuFAHw4qGbc4KoIrMXKztsK3+l9ofUeVXkORonhXf
Ulm+rZ68sbvwd3llQM0Jcy7OV0+P0AqZTHJqIIRDE2VmT2THTMQLicPUHck35SkltkJX7r1U
1XO67yC5Af3dN0f35H6NdI5S0kif2nj0Vin0YYOEvDdmE6cR6M9R4QYA4V2Vi5JT8JAw9g1J
43XvusTkSDu1ZbW2tjANZqrd2VlxBfl9zK3d49NBHDwsSsvzxENhqOhzy15+Z2/rfJwgCJ37
uHP9/+xohKLr2nX31R3aO7naGhnkzxLBU+VeiUeonsNdLlibpITTYmmwFyV/uOWXK4JeifCU
Kucx8zqwCud+/RsH/LBGNosnci3ejwLe39tlB/YYyOTtObYWOJ50LcLriPAEx1MK3vVpedR/
tQPbex039X/IP+efuYhi6z28geb3Vm275CbmivHunddH2bpPwLoAaMkYDoeWHVKOZFmD2Jkr
MkbiKQwUDHzaYExJGJnp16rQ6WURIG9mRZfLUDc8r+/lcDkQbxCfWAsn7UvbEczL+M8xhw2S
GN7lUzF6xG8j0FpQAsU3/a7XVaG9tlA2R3uwo2FK8DOZNRPjoDECA0TNWtp2EGBemPSLFI5d
fLihJunhhGTbym12LrhuEvKAu5PtFFYvCarGQ3KoSeFKgiW7rnYWqgo8f5JKxpcSTG9Pm76V
nIeHSlOxNyU5EOPw4WiudpCX2m/sWoe6ch0lV3Xx2rpDlGpBDauN1FYg59Mb2g8Uo66TjgMt
ozPvJxQeraTQPIHMrS+qAPW/mvMzLdfdqfMUeLZUw4hKzxjDdGGX1zxc5fYmGKWeT9e59c21
rjJR0I7UAppdFL6nyLy2MQVcafLHjA9N9L0Cy6cAx3XfXp3ZI+bq3uWX+KNm+z55EhZmU7I8
TQtk2E3i2hdUunwZOpVlb9Um5qssWYDp2nr5J5w8cRCH/rApBe0vP+Oj5QwvfLM6mf9pQfQy
QjHrvsJOGJOoZelLxwaozu+bWOvVmHuNqs1eOCwYt8CINITLV98mBuetEm48Z1MybigsCadZ
a8dwTXxQb+M9ulxzd8O0YCUzD1s5HUX571/SvkCkPiGI1u0FCzBUMSbuAqtBLWnKFEGK5UCa
2dLyukgClemKd1WVm4yCG8T+rEvuA7nVlSNEoq0odk4BjfvsBqe32HDjx6mZwy0t/uRzIStY
zhSQz2wKjAKt6w3IPwZobxqgofTNzE63/pbTjsRySW8k8DfvQpu2zekM6gAdN0lk3z2p+hJh
igBrn+YdmyMhXINuPxKgQT/F4D8mWbaOkibd9Hg7f5qVOr6HW1cgTF4DEXsQYQ5chO51r6jD
Su6Ugy/zQaBewpwvVEJJIzv7IeA7wzIxdZu0Fv9OuCp+GV8uM1SB3GKAKzLJezaDr6KCUJ2z
QV3cnS+3w8xbb/GbyCAAhWJQ6ic1CYMKmnzS4BYjB7ndH85oOUSpL6743nX3ATkpp7lbaNN3
h7S3oXudF1LRqH37g4HQFIbUcYMH0xuOY1OrTeUJ/EdWQAoeRwmgkChzHFOAYGifTWuvGU3G
UwzZAwPx4c/4cSp/90xQe17kB8VKUdT4I/K/tEb6ZQCmCYpj7aIQeO+ZH5h44wCdTQCxw7he
c9x2f8EdL+Zw8+PQBHN2R55b25aUyFRBtw83tZlFDqhNQokRB8hiPjdUXPq7ROJ83KqoH4Ha
9pd57+rdCWOe5+qb9kP84zfo1tp9WQchJrYG1KaYc/3XZodV1gvJPQf32OJg/4s0qaype2SJ
MWuwjjztYxCZFFR3Vhk3uGrYYZSLRAg5xJr0UOXBIYqUgHOL4edsyF68eB4ZOCnpq9tEYWg3
jTf9gCuLn8t2QxOnxadrgyb2WRQbZcyjXP1hTEHEIZcfirMe4xFejOV8WMjpjjwoP7mdaXXi
OzH/H6kR/079JYKBVjblAB/8aff/F65SoZ0GMVTpF9tWvAzlZbS8r1l4U8bGpeghPT7H6atO
DfhLYKtBszONTDo5UMWJ+kNX8jzwTd3XyIWVjCsRXUnw9Y8TPkREBBPdXecHoTOQhygYryFu
WFSbhoqFKUTBf4pGhciFo8upjX43O0bNe3ahwZsSRW594iHOeGorf0+HM0C3sAXNj6XU4pcA
PYpfbMayyGmIWH2DjdGejxU4myozjYb1oU2TI7r5Q37DrIaxHJlugMvSEPTxSSAA795OXklj
rsS7bXbi3R6+GAkkVzIvHu6yG30EvsLf4xyqCri/w9nGuIG/1D4tEVjkoyfBL+3A8yyJRJBf
IUoxIg08QNnGxP4fxnwaS7a7pqS3AAhGcLEtwO5SwFyHRMUw6aqINxfcFlooK7ve7HQvcKvs
VKtF9pinUAmt5K+JSWNL9n4PUDK2W7sR4mrwJLWhBp8fKtMWtbIN9Rn1W9PWaBE0TU1P5+hP
HYN4qW3epPf83QWvA8dF8RXYJFC/dwblzwmyu21U9AWnf5IPeB7p3MQJf3lrmiqb5K4XDbZD
mq+Hk0xJRgFqupxqAiWuVzEMPVx50l44fpX+Kax1Dhql0iasPeebnzcQdklZNencCW+LDhzR
P4kpJAeam/Ep4td/8LjcZgd9TrSG7nOvBDYAcAn8HTCE8lyLELq6nrBrLOterfHf09KqPW7P
QJPa0qEWjku3H2jdgFIgo2lDwQ+fFoO/rfJxDy+mVgeWvva4ouOP0CTthDz9fM2cr16004xh
RRymWNf0gCH3O29WxHF/GKTihtmtHKs28BPRZr0CZN3p8/cR5D5yUa4iSd6tvQfntO3C4ulR
VZaSSV1P6pkeyl7Atlav5/foxGx9SA2cbzOkMZj+kVXg3Fi8zIXIx/R9TmeXQ2IVb5Q4DU2S
12GxnR+76phUGa+lo9Fx0KYEJh3MvG5m/cZKryNnYgqBCGTntOk6uXVPw36kh5rqKvDdDKgo
k1PUsSs0n0OoETd5byxqD3CGxUGz844OFCwOnN+M3TG/Lgr9WUgDZtVC8Askw6AkMowepCOw
b98Po4D0OFq3v6YPLunFplqmshyR6OQd8XBbHUCEsIv+St3lCY2V+SOEvTg0NWxWAwjYATw9
2d4MIruqMAgqX1KozynsIUEcQimOESFJLg3w9kaZQBOLKRucvMCFxgU17xwuTrKnn/LwiUOb
3CrijWQbbGRiVGjPDlHOW/EJ5GTKLyIOImZ7+ruGD7sPvxc76M2a15LBoD6vie+4iRNgAW83
NHw6/iSC9sDDotzon7EGmF2YESrI+DuedBYS1Xa27wlpTt2ChXxryrtl8otXOQ4xdHRM1j8Y
D8njy6X+/c/s47D2qItW0ivdD3EwB9UHpfW9i4bnUjiiMf9Ausx7SPdtU+hVlCZ/MbH+nDVs
1sD1HqrROpbNvIskBMFkfmJTQjHH9Afqy/0q19NTXhs+obU22hVscweC2t/8m9t61FZH2sA6
L53mscrgr9xIC3VZxRRZigsCSainWn4UkVxswgUBGagYy1lykGWAx7oMN+K2VeD34b1pqfYZ
Sl9do0Z1ChoRUX4PXTTot9Lcgsl7kPL+yE22B+6n77X+fgZbXJg7DqogelmQQQBbWgyescMS
/2S8+2ayPr/I1I9CTztDf5mj0Jhjm6vLUMbxuLuLRVft8fj8NpFGKgWrSVZ9EbBCZXzHz03F
DNXOtNtgoP3HUu46SFNtVqApNQzIAp7Pd7xqZbl91TuuLKtSl12/yLjItaNxaeBRZlVQO5Il
+v/59ZZeC+HMmc9DOpSwZn9iNp2vM1JScrf1wwGIqNCScDrq15pFgLKO3UZOtzh+ix4CiEk9
s5BZAtU8HgwJ5tKBm2vYn8GrRuWPYTY2GqK6vxir89qN2ebc3bZA4Ue+Y37Tafz5p4y+Po/G
bQZoTmLlZQZ0rqGHmBJietjqCGaCy/QMV92K3A55iYGVs48Pb8e6a4WDGj0E2TvyqIr69wWw
BVnutZO/8sz3tqiJHxftNkpU75+7j9fQk9+acDm4+44/30jGFDrjw7pchQIYfNN+aRq+gwxt
1OsYSdLGplqSb41y7rFe6xCaQzTUWDAfLVD1YzglFPsZ7DlLMNerFkUyYdh/dDCCmxFB9zNb
uCRw1Yq3PUwCfCjYi2Ea1V68H8JUBdfJocEXFLwV5VMf05pBk9Bb80aDU0Fxr1HP4VhwnZfk
5E7HA1jy9Co3MjwZcuDLdZhb0FaZTtowogTUGJ7SHTMbmW/VxtwWJumKGrwwGUh55nUlYcyI
CWN1k6j9K/eTSg3fODB2DnFE98vTain4M3myfH8YDiOVX3TE82ZlVzoY0OzLtxWSE1TOnp+Q
+b1QFO+m0KEvZW4zhgw9PzIzcQc/S3V/ucm6RLnZ3bta/fioWOSCCzt2xiLh0zr36S4R8tji
V2KCVshgolyOZicdME/bCDVfTfp/3bNDEMqOpqv/q7jLKNR2fX2iOA4Oy9R13xErYWiXJUQf
99vL4VnJ1aTw0+f4NsQe2kW/JTHdWOyzuujyVJamxYw6hQxEkEhy/6fQNcUuMSBjTsdqShRE
YvmJPYANH0+QC0AX/kOQa4+MIzVJWizTFBdb733hczr+/QqYS5pKGnslHuOwao2YR7emi9Hw
DFr37OZqv1aoVsPeuqoWhk4BYXjdb4uhk53ZlgkQYV7ALZk94zOc+zx4pTgEdxm0ulYm1dbx
usTFkqTnwVX5zX32dyn8zAaR00P54kBijxiK7IQQ6j6d3KoeU0ZAs4aKouS30oEug3+Ty4b+
BN4rqTgEz4/40BfcF0JRQOkwhtPp7hMVARZeKPPRD21ec/Ib/PDIjFT0B//6aKCaP8woakMd
YfG58AsP8PsI3VOsiK75aPKKw0xva2edDxtXEmJQ/1G8FXazCGJeAts954wL+wfLPuEiKDSA
dP1fF3OWamfutG+PbkV+bJTIfNea2iBJgatV+A3ZR8Y8n+0n32NRvw5vsV7DgbIqqMSEpOax
ZsLDDswh9CLzVf6VbT5fIJrWDO0f1f0wW5yqYuJlLESdK9lzswmOOGz0VJwxVdZQroCG/9yu
Mtbs9/PmzsZGCX19W/ITPH0f7rJSZd/T9FRsXNFN3KItnDaf1OW0DWFS2yMRuWu4yiGM/5V2
yUfveCXm8hUR0ZpnmxoqHtCXDTCs1MqUNdKs9u/VJLLtGpY8R4TELX5px11uDe5FGlgPPLU1
v7WX7JkifxKCicZ15dCtAcGE9ewQUhO76Kvfn+K4DtdPkNeoa0TKyMvsUz8bXmW3gAS00Cb7
Cfw1lrIJAS0CjKIjuhYCXyBPhb8cIVT7ls1+8KqhvXRZ1vl3NLVIYUwP/u1Hj92b/IbHhdLX
XMy+LUIEFMtRgxK1QKY9s2QZAv9ewdMYuP/4N4VYmwSs2d/iLvz90vdcu229XfddrLE3pe6G
qSpTlKSYmxCnl/mdFxmG+8kOCuSX002nMI1XVO955TNtUPtsyBYZlvY1atNcdh/P4oudmXkc
ekYCyfFuFS2/lhDvQyIrSRTVpcgFcK4Lav+cPR/e1dDcCHkBCzBlUYMFl1VePWIEPXXUijcV
Eic+JhV8qpzj76GtesgisVt1N50dP6W7SsKx6N6/CbxV2SDgrK0P5zkWXCjeuqihO7c9JmjU
nBqXZzmdnMtvJobHOxJrOeUYWvY6h9q0BLH67tYqfNvqJZAKxtIp4ZBWBaeDrwDPpax3wdCL
9zNfX+eXquyS1DC8QgWZkdmjAw3VzWl/3cUUbSyJJXaSiqRtskvzV6nYyhUk4N1FALdm8aIn
xPbTxOGyhA4qnemzLzvDzFgV0aEkAmwz3W85pdJH/5tFBCd2icZGLFuyRCeJR5RzyIJTlixs
bze6i8V8z65WdcZmu7uH2jB1uNHqOJRbpRiFPv01KV/gfzkHOohkP+/+n6E0AFhuNdG+M+kz
OrZXulCktuN8jogrQ7O0y9oQJPNfdWdeXUO7HGbYM4MXwNIT/zhL6H+VhTZ61K4cOJuBwsae
ilihrSigyem9Ug329c+M3UykiWfuR0uthOe4jSytNKVEupUbhTrfzPFV9xqYHWH2G4abpGmN
wa2VNz2UZ4Lqr3Vhy86Xh3+Av8UzbnrlZbeB0sLUr2kvJa3Z9pGIUq36zSdAUj+Fm6Z9K4aR
xK17WrI+KEK5uwt2dvQ9OF6tlzgpOSz98b5v2en/ZhMHNQ5YEHnqSVx8CpSQZju569+UdB1o
PFRzN4xlnHr1c1liPTrJl3jfnW2kZxaFn01MAIUkrFWFe5BVKc9MCdQPVHyC11H3q+zwCe0a
h+qcuEQBAIWjz+imRcqLv/T7JDi6Im7qth8zzJDFCxTdJD6Ffb0iLl8mt87NT6CyS7irxOcr
OI/OJ8S6kmx0ck6/07W3Kd2QCuLwOKDsvEc5huzXFH+74mvWYtm8bQWp0Be8Zw/oUn8KFQYs
E0GzSqqnD870wj3SHdUOZivWRaxdxYQb2LOe5DWBuXnfMKtndjU+Avx2qkQra9B0tLGi2NKj
cObqAVFHP/r7LMyfOhXC2qkSq2lAv26ioLoqJ1LARqYQf3qhDgZ5edILTA7BBHC3vHfc8hsl
ugncsB+CouCATL4Tx3GvRX/hyfDa/SxYCyuOGFFcScTiMimFtu7Cx+CZyROjj2KkKhjBCwYH
swbHamctwFPOCmYDsUY2gnOuFCYGeybSafvretb0UCQoB5xv40qeV6yoj2NNo/yI5zfOPYnQ
2YZpYaNn/mslYN1SPI7+6qTyXO3us9lGO7+FxPlLeRuWnWoeB+3w8AfhT6Y811anBGgySCu9
tiCvUsusojZZHIp3CqwNW5kC22QtT9Qx7gxHJHewMRVL9IZl71cyhNmQwH7gMHlN4Pl5AFtA
bZAoVArgLa+lfjCMDZs4gHCyU+ZcvIagsNZKUuxsQhF57OorMiyHTp2gBHc+qFLTD3j4U5Gl
fCT6KIPLhe9I5nmEuloDyz8v8TUFy5t7gUeS1WxEcn8RaEFobHMct6PKaBsbUoRt0loT+DmY
qPkvKCIdo6Vpt58Ea62nNlJsIHNyZBWMFd+9HmEReZF8FR38MRlYM8apT4XkNihqzFntipNM
/EgZzNqiCaCBCxk9OC8AbPUdCdS+9nH3+W/nLYNahZOkgu0jsrxJy3ii9Onrl30Jmd5iG7kK
vaUSsTr1kIFSYMjx+txg9mnUPyIsUa81wgRTS+RU6fUgx80ID8ZUqzFkmWVEwNe74qP0+izc
NSvV5xuvPCPvfl4VHGNmyXAeCpu3GYxtmYvAxchJteWV+kY5Ce3jo8XOtv11g3BA4X8Mp65Q
FVuWVjGz1xiNdXfTd5A5zAhYfFeNUIwUY06ivpcYuw4YKjJkfiZtsLU4uHa0ND80SR6+83Qp
FPYZ+J/BtN39Lq3OnKxIcdj37UHA1XVQz54YI+ef9ZRXBWxAajw76/NRspiv1n6+i320aX7F
BEVvMgSGq4GTinm6VsQMAUjPhDDihLH0Hg8kSYtnUK0hb3CqGT9S5aVuUFk8VLOPXoNBQRQw
LpeM61yEPY6l1forp9W0LlNDd+W4d39HZNvbw6r8u2z4bIJ1Qnhhzu68Kh4uo9VxCEGjhMPl
Rr0yVwxVxKKGV+m8nVAJzjbH+S+NFAqyJzuBRYU7jAy7nb0Nqyw5d+nGh8pH+WhFNcHqeoaJ
IAVIlxviJIpKVPwXAMDTPOZ4W8vkxR2a26vK7qprMmNvRY9KrcpFwPYSLZ181ElOEkTVZMig
h25O0IWq4fZSmDJ2tFsb5/Weh9hbPM3Yv3W6uNmM3bMN510SXosw5It8QvgjRT5rxtvG7HuT
x5p/jZloqegMA3RGjbICeaW6xqwP5NgoyCfKJ3nN8MxcFR2FXdL0QKVdkeJMW6Pc6g0zzQl8
DholTfG+kKNv+nmToQOsl6UW0uKnU5N+qrDWeHji5FiQiXljp7lIRdwqGXnucPhIVZjxAypq
p3c1uQ9EQSsrbkiodY3WPOMCBt/qE+1aiNH92UmxJsIqw7UzbeOzLG8F1okE3F4477pVWxGo
/YF257bxFReRMA7on+z8eio7G1dJ72XCrxeoT2wk9n/ZdZxE7O4jGA+tG0OIBnUAwBReWpGj
FrKxbX40F5/B7qxImOeobmRqRwrgsfkA7dl5VDm8f+5osTHHFS6bnnDE2AYP4bkjUCpIdx40
UlLmNN/hzhDjCLq0dgAVEmADuNLMCBiwnpE70H1BAYPHM+o6kOSDoz5Vb0JIENu6iyhf2OWh
wQhSUMUAoHPd9bYNj52LlqVk6t+17HI749mO9Kw7663wRifUhfxpHN75A0+ictRIUJTu7lkw
kY4K1B1IlT880VmKt51W6P9HLrmKKVcYsGjgc77sxrEsmvdrJgMWn1Y+cmJ5Hn9uetRqBYT8
T6GfNcxtUW2lxFJt2/7RAjRq5+c0wMUdpITJBVMwKBcxojG2gmeKWaOJJwNBx5n+E0OQ8r5K
A7+6csVUzrGNz595tBMD3Nn/b2SIaoYt0Hr7mBuZy/TtSfy2ufegxYz7A4l3JVexZy/Uk1yf
rOuSbXUTN3npCJXVlYL9vzBUF4d8kGs1xgVZ3TO6jZ5hsfGgT+7mz++k0g7bZ+XtEQs5Zo1V
8sVr/X6d0AdRK4diQYaQAhasghDND7TLuQM1lhtjTkbLF4WwaqN+QGUT9LShmLkRb/oLfATW
s8yB8uB7K+eqTRjxxkeNwb2ODRc47kdHLZPmTv55n8gB46TiBZOu5H1nhx0snC35kZMuuE+x
Z3gxLPdEFUC0NjW/sM9c+yj9jWalkC48nt0TzCbEDPMDaprv9EfMEmj3fCQAP5B6C6/P0RTq
9bQ2qGlsJTbC1xuHnnoOEEdsj+B3saNTT+Z4FdcMh+UYtOjs8DSGiYODb97u1QeyuG6OUgjL
XVYjiaD9FngoWTe/Wct5L0Bh3p+QrJEk2CQJqiQ3OlTU/W5ySDqtqT6PS4iv2T0NDarCBwVL
ShsNxxtWY7W7q5lu3TsL+1paXwLUYoXQKhlc1Zwd4xhlv4XMIQ9lN9ZM+nwSC5yqEjLdxUWx
8sQyklCIlQvfEQrQaJQE62pyVpm0t+XSp47Ta6o2ZmcqY3v4Ve2lat3LyCa40BiqVyuPyCYi
//vcVnqBeNK0KXwH2Xe2Su2QH24EJlnu3vkOm4Z5t4FgcPsw2hDIO5mJcpeYMsjbRzHD+QeO
Dfbn27tf075GJ88UrsVCOtJYaylmf76N7sTdJbNUguhyFsIJ4TYnxN8nfet7ZCg5uV3tAsr9
eu3H588DM9M9cdpG42DiMhsvTwt7FMDE8+l8L3VZp4CcrY/o71U9dH0y5NAcCCZZEdSGewyS
hbf4VCknJxHZl+2AD34HhT/jOzioeNoUxyYtnqHkH0vAW7+K3Ji+LKDIuQdca2Xx3DXHKbKE
zSuH89y+Df5rQ54N67JgIAycVX4xiF3F+RycS3BNIOf4ndGJDqlg/x2LcJjWQhq56+iNrcpb
d0sD0zncsTSGMgFbo82g21jNdMdc8ySziE9RzV0PYBCERj/6BBLsbN+8svU7F4nz49WjAhKC
VBt1asDQgUep6cg0aLABpFre8DONQVRmHsoDx50nFbEI/l8W9iDVHQeqC8xu5RREQnuB7CFj
LvBxMGirK/OVf853DvOQ+56SRR4/uitZO0EBsLnFpVWipsdjU0k5pFaBLD9QxyE2VwyMf7CX
QXXILQxG6QQGChDfo6Q/CuJdYSzSFdGoupyIZOp8QqXu2+N0FeYfk2B/gpeYNtdND92XRrox
QYUJZGmWce2+ITqusf9bzi451caNxla/BlTk/5YxnGP8JzgKq3Yd9uhPkb6NcDZ8/Albw9Yx
L15S7PKVwlVJQv+f4ok+n0xSaIhQ2GlEShRRX8TdQS7gP3wXpyJJ64qlhSrk5bddW82g+0Ys
O1QgQQT2dn7CG5rtX3h8jvt1kjDyDVx7+tqERtIH/YYsOtOdMquf/gWfSFPXqTMBFOAd4VR1
VNmUFQpXvAzJyU4hmUbOIT8htDsEx4w0talpm2srL9msxr6hjjoAB7AGKB5tUUwtmvQ1yyR3
QX29iuH9kmRV/WCVXshcE/tYF5WQWjWB4gzdm+TPBKBAKiq/+B9Nz8qrBQ+hcqKiYyLcJgIn
mfvhxv9TiHPwmLVkQjx2eSrb7ALx3RBJp4ZR7TGmoSu3y3llvF/9JVGtPnTHDFIfiJLRLUqy
ItS0TW07IqHHv52TAvRIh8FUPpQMDaFWcUEqdrfc92twMPRUX+4eMU6lq0lX3CLCa9cVPqL2
89ZcLfYHhFz3lU7jqfx+kNT2to/ovnXiEx8WdWZvZZyo71Tae7i7PeSiy8YGdgacrEHOChId
Z/PN661d1SC0euj1kX7oR3mK0tv0DTSd8IV0XH9xeJnShHH4GQ2svUWabCRL6lAKOpzU7edQ
xTTPIGDKro6uVvKnv3cdw6bz2jjPKyTyc12uq8RcFWSh+dNAnzAxvUm0uyNoP4gWFBkhUdWY
nEeaIwBLScPeR67vCtUrleWinGK+PRCCl6HSI1RqTE7hBGFM8CZCAzxMc6pxe+eWYqEaw5Py
XgF7y6aqqgnJB20oZXNv964SWVMKFRbn32+92t1o1zCdthSnX6z6OBtBNyaXzO6Ysuc1pFve
cA+SXZBJb+STcP99YoIUElsxni4QSYs9TRe3HIg0AJUKTJD98gwUQlsSxAqeK2K4lnMK8eEB
zMgCOl808Bowik5ZW9Gh972rqLPr5A8XvwE/AsVQtYAlRcsLZks3bBaOMGK/+EY1Nm6TmvrY
N/XnNwVpbqqK/o3pHoYt3iT5ISRPiO+/GuQwdI1cQf125bdMuLMDyVx1q6W5gsev5Z7/Zzvf
3kb4k2yHb7bz5TpX7f5sOrsCndLirgEdyaNOVtYeUrHb1flyOxgEBlufWuywtV7+WnHv6aea
wj78jYqPno2Yt8hsHfTjOxP4pHaSrGL7CG2Z7fxwy1p2Ay6l0AePHeIYDmTSozTLIGLJJ0pn
Rm3QhQzt0Y1QghmjiaHqArl8oJzjPVsA8OtVV1HhQdUtcF0sBHtazScaZEtTeRAYIuhG8eHv
umk9zRWKhO/s1eG0wkGkEjUHS8n0vn/sN4pf5fFFz7+iU8LiGPZ2QZhQ5HOalIP4ZXWnfXJF
6pxljs5ei/+FpPTOosImqCpwtJSq3buvbQsyCRA6Hdy8VqLkauN2QgvyrLAiMbAMxPiX35JT
KZTEy7G1Fs3viXwgLgeDL28nXaX1L72FyUFTUf4Jv/lW8ExFTt65hXiIukd3tl+f51Z0FlXH
3DNaALyhof2kyxzF29WMp9+kZW+i9Eml11aFV9EyPTkQS35oMbugUadaXJC+jwsDY6PQ6Cij
65OIfMyH8Bh5xoSmK5i5qWSbv/nrPQDzlECtuQnmYzkd4spRt2vANAK6xWv2xCjvLgTjPqTX
WY0mr7b3f3uAuUzTnGWQ3jQSDWHgnsnpkzLCZFYsXzhMjYunhJaVwp+txhDoltdrMNqbFZhe
dO39Mob/s0cqrvEnfXjbVd1F/8gOKF94xC9KAuena/PNbihDBctnDmRz1r2NcesbxH+UF8rC
n+hgNj8kyOOUtumI0VssXMCIQomoVDCUp/gmD94gJ+PEwL+MYEGET4Y7KQEtzc1k0kOZtYyc
jmpBQ79+uT/Bdry2aE4OvEunyn9Sf5zQo6/ME0n0p5nWLMQ2295o211g9ylRVQ2Lsjre7Gcm
4tFhX+8xcn1Rh/F/g/+WEC3bTORE/0UrONyqACOsbT3rCZu9GhPrBTLYnwvxXttoCrxlNtvq
bNHgPgovErQQtxcE9egM5siAq8Ac8Z71sBjPgxRd4l19O20MUruysYHR3G1TORRUi8dIlCus
3ktPyN/MNpo8Stf6mfqdBR9glUoTFwlu5KTq/OzpR2zkCXD60JoCgJ7zsb7iHMJn5b7hVOtr
LFoy63Srbgs5KHy2vcrqQ8btOStzA8jGDSxCrs7LGmFHetI3L0iJKAyaC2PXpZqMPUffpfwE
yoP91PvpSCQqR5zrk6qY9K5BTDE8U3YeJMGGWpICzGvuJ0Ie9xtUhmvUS01UI5VW30Be/ujT
hSbaxxceyU6jgiT++MqIjGTByWlyeV54aiklZrMZszsJpq2ryYoKpl7r2lGEApyDDO34+9/D
MJQQmzCjTEXoLXEFd6CxVnUVJZD3Vvd0/kWgkMob/Eb/yoQo6unYAxls6b41j6NnPWDKmGU0
QaAFHxACvq7BJYJ5Q55EnOkMfW+DWLB4h0RaQ2exQMH3bphSJaR+hXI/vMfmOfrkVMtbozsS
FKa+3TOqk7ipJjdYpT3E7SY6S+3BWU2AMfnsDSCQIOn305R+4PZLgYAAgmRsqzoXbtvKRZcB
Mw/dWRdGx+WrLCRwDAS5Rm1SoAGRNF/r08fvw94iXfxRj+R0Z6ocWuEwSxrTvNe8u1uAsJSZ
M04oCvVSQADOrwNbKd6NotUQ8TPTY/EoOd/X4VpU+gB2jo2YysQf6gIo6JvL2sDrFfk4wA1l
0nzt/E9EHRkfe69VizbBiOxTofUuy6VzpiTSF4j7JTMo1L6I95rwy06H78U/2CMhkbkxp5X7
gskc+i9HC9GCa3VT/Aa0oFGr0PMPHUO7gUMmhMVXzSrAKhRpvGk6xgkBTdvK2YRTWwMNuHHl
ciziQNfYu+ppsCpfiF7VP/Jqo/pPQ3OpNk120H9GXjYI4UVmo90t+If3Lix87UekQyLpSZ5Z
oFFLZx9kT0PvQgn1Q1Q5TNHbSwtM3iIaf6HoC+9w/pNqXmKZ5XZ+i0okj++dE1uC+PShQpny
gKNPbaXRdT3XyG4KCC4or0LVSVT+60MJHohwHMHSmTuPPPh/JxSXCm++HrwMfR2f0/8vGJ6E
wPKCzf2fI/SUJnO5TLaQsMYESBA3m6/so6hR34oyZiZhlKl0xYdsUzSZi1yR+EN9u2GGP4P1
CCKNY4Mao5DCRQ1KETYmF5S3UMpVYSEgqgq/+7I1vRtHbnk9XaBka94QaVmX09YcAPI4vsIR
/5brRVt/eDBZJDJFnhDiv47rCfF64ezonbJqE/cwflZBzk5TSvqGQ3xM2wupRsf6N1UvagNV
OqQrjI98N57uFOjgu6SweaCOkYCWQmWnRrHV+LE1FGI6K1PRFXwme3guEtOMANd0B66aXPJh
vwqx5nXJK489FOCpRPf0eeSDweKLgLtZFRcr1HTnjjLyB8pjwaHG3an2GSJvAmXrC482MeXK
pLHA0jAdOhOR5BTVHkHBmqzNfB/7z28rmKnuoHrQUsHHSFaX57cP990N9bftgaFoaTPO2c4p
jVYe7VMPCaUusccfxRJwZHFxGDsKg75ukuqrzcqaq0+KUq9qMgIpYTkgenKkw3NW22F+uS1h
+H4nQ5R2fEMApWeGwb0QBTbKv5u1W1/Mps3QQD7PTiU9YdxEvYwcisc57inkau/S9pycpRZ2
W39R57PZKUaQgJfmmphTo41DpjYcgk2p5rcLak+3p3cV3EHzrekG8n6nQ7XZediKuuXgodoF
Ko0Ykc0ssVx4S3WDL8p9T33kFv91BNGMzOYfEScjaFWNrJnu+yMRwC2JvngGy2WE5Lxa6UB+
4VC4UOJTlfmEcbw2HFDAAv6wBkxxG6mao+T/ZSI9fPZXx/uvBlarWbEOXWARzlZqE3X2VSRz
polvzls2njNaUyFDeACkSg0+x71BXvnyfsWMInxemjZwPmam035ZpM8TsxQnEM0IK1hXD3Jl
7I7Fv6cJV68FW1Q5vjneWHVPRtZj1ctww2+XSwH8ePQNPIBUXBVRtYqT9QoD9JvQy5aCPVFJ
+vtIAcP68udYcuKwD98O5atpqNcwaolmzKTFBi8IWpSAiXqdfLrrLoovFTkSY3bjoysnnFLJ
Fgsh6yHWhI9MarjP8pA0sr/NYz4ncj3lAIZGCgeNhD4xEjp2RHgTUAZLyG7LwsQDNzDGU98A
zIk9WpIYwgugzdTWlx7ufWyfMQxQFPhlQAEfy/b5CeOtUQVECqCQ0Q93Jdsehzlfv/v8IfLo
4YFCw4Qja9mg+kaBp6h0xtI4I+MGVhFGIh6Cyl6aJLtEQK14L59GeBZJMBOn6GDxinl2+ErL
+bZbqz1l1KXLHsJo/pq8m93ja1lVeSTYnCmR07FtRpKE/us9Rk/uHRKp8RlacmzFoj3jJrvV
NN8Ma3fSJbTpOBnA4fZdhV3+Fg+ZHUiwxDQhpbXUupkWEQ7JzpxXH4+IJV8LxuQWvDq+WNZl
1lzhUpwOqV3EZXJZlQEXULtBC2eqTSF0EmvCrEkvlA028kDXMNVRINZhIvmgx9MNedS2GXjn
xR4fqpxJ3PFeAumwj3Ayf3JPGXs2Py3gVZ1BuRO18MUoSaUkhDINMyE87RHPVt9eaayzcD/V
qI6/hjTCF8peC1oBmiMJh7IOmHDOpHEXmEfmNFUuaEP4lPUYwPLjQ08ZIc07ikSYmYYPUmmS
d58SwTUuRjkbIre4QewqBGmG4fS4XWkh1jeZi6F6XHgEz0f2hXOojpUYJIv9e/8Curx0mwLz
HzWfdoE8peZO6ahVYgs6RjKuLyXSGLNlKArOqW/3aIl6XbAqghbIou+ySidRsgbRl93nlJqR
6nEjNeQp3vsDtyekvOj9+16/SleoGGLSMGzhxn2KWJDhig1OsrDQm8N6dBJb7GgBHAUwNqpF
yCLqEdWLmmKTlvpl0sC/+cvvZMeGGHaDOPPJlwToyEN2XLUnHJHKIUCP1raNw6ps5xSVDw6h
rr0oe4URH4VBmEIXEcdUn0GaGKL6igjazwEkpqZAGDiQ9IPZjQRWdBxsumgLxBzDk4Mh+2rv
W8ZvncBehxdVYTJNQAPu1uNWpxjx5/BNpkBJAeD+n9Ht0gtMW5btW4NJ4dyexbiR9D1lBGei
d4V3YVEbUAPad9PoRycUew6qSt632xcgUgx+yY5Cjdftc+phXeosetghhaRdO7kqwQwSA1lg
pmS8HfbGMZP4zKNeVvpp+B7KgS/I5X2/IJHn0RefdxgRyzyvbBQ0PTBm1OXasnm3XflHnTQk
heYb9B86m12apb0+be3ctYOFyDiusFZwHHeFvbcwwen9zs8KRCwypNGew0NLUgp8V2ri+TB9
L0ubAx8/xWeQZ3TO3LqNKnRv7Ix1qKvkk3LbioptoPFWVdrrgimPaZ1UmU5yR3of6vhEJzef
Y7CrFeIUPFkiAGRsrmnXwfB1aCQtPxVpYwdJ/KPqpOr6lB0earCIFx/fT4jIDqTGnMYuFdUE
W9DLysVu4wyVJRCm4SMtxACdjaKAKv9QNZX8QOili1wLRZea4XXZ0KkgLK8vCyHbxP2ZkbNu
GhRnpVzMCC4pep/8aEoWRjfL3diXif2y0SURigSXCyISaFjoJGCuelGSVTVTn0Kk2A1JqLWQ
oesC0BxVJ0rpFkULBguLedbjOFVEVUbuved8pDVju4/BFwIksA/k3TaFdhzNueVyMrMiDAOr
PZG8zwx1iWqc7KP4TXbTysVcXSH3+17bBH9v739K//dE6yT+ZprkqO5Y3R7QB6QGU0n0ZXiF
4cjTFkE8NpLxhlMPViVoMHQIP7wS9OlAN6r/4NNLUV8w8YzV1BOO8MaF+bL1ABRAmvB49qUq
Oa1ESYYBi1lqeo7gldXLxqHTMezRcSyaFZ/GIPNvXsOgsWEhJ32goTPI4FJEIPsffmkcFdAw
j6qw/GkgovLEfUalOvi5BfhL6tliNAwyiTcDF1yGY3dfPvNbIqXRF77pV6ogbbG0/U0/K05+
6KAkpIdBMoPNDUgmvKEPJrT9+rL5wDelPySRa3MH8sUNDd5vHP4lopwOe0F0E028h5MXRc8o
TxO/0SRf9n186qTT+twd7sIFPMAKToXmompABHQM8O1UuFdSnvHVk3fdJApPu46hk346cooH
ymVmhRU8c0bWJoilu9PLKQzWX9DKxViif61Ny+NqmSA9o1YlG4+cnHirdGksO8LD4aoseCSs
kzyMICoJcVGS1J7KlTl/eC4wc5RZv8W9bIeFq3wuVtW8KA+iLf1ouDAvUdcodSKR+tQmsmcy
RuoAtc+1WUgW6CmuYnBGP6LFdAvrghEKnKOZka0XeeI244MhTmCDtaSZy8mF3QjLFp9sn11p
NNwKUxqVA7vbcHtZdM5J4rYNMW/wuTVIMRc8xg6Y7p1i7vJBPDH6iq9LWtYQMqhyvnrGKkI1
hFAwHl6y5yPl/Jy+p6Hm6DzWLHuQZaTOB7rsVinteGDeNLkucYIN03AObyIfw2BS9XItGp4m
E39R1AR4Iuv4iodl+MUo9rBU2+x/Pv93kM//WdUvSYTKgPeuX5itImk3wOk33kGSz/PN7NzB
wPh6LnFTJeSwJObFmxP90EiCKmBihYgmbvVZsOyev0ZoCsZoOyg7jSoQhOAXMlOHXEmeY1av
38/dlOTl4IG0evdVX0opD7v7y7huOBwrWBOJrE5f2JjcSS9vfcT1vyEBkwFvqEFab3HD3x3c
gd5RzCbMnzA1emZl/48xn1pehvD/immd+S+HvSd+/vIDBJrk/IXOVmANCDZK7HwfePw/PnDG
2xMCQTszhC1sZ1kAGG466W/TnFcg12ZSVbd3CK/V2BG2PYDNyCAaniD+P8hArNObg5a7VQvw
MkEtH1EsvNpKMShdfgIBdJmrmirU6ZMV1yRzRquvtuaKUB2B9K7zvrTNyOoe4wYvJoks8KA/
2/S+u66ijsDCfQfxrIAPAel/X2nRNEFtdwP8s8zmpCr+4k0YZC/IMX4fXJjwqJNl9qbKD2WE
M7EoC2SPs6jCBGzvmJAKsZtI8LX9/10cMhsvTmzOGADeX3Mzbxu0KomoEPouMSJfBnsYOHRm
+JP3cD2xXLkryUQ7gzT4CqkrXtoR2O7or6pOxFJtBTZ0j8UE/55fs3/1Du/Q9b9O0FS5dxj3
APD8ukD9i/VNflzv5HRx2CDs5uCsGsRl3/qg3LTtW0zA/P/e0ZXZUy68cy1eq1MOCxa6mPq7
k1MC+ONv6Pwn6CuAiVFkC/IenVDfd7fjauyxD10GxtahIqer1EbuyVY/YDGAJIz3nGtuev+C
X1U7lqx3hyrb2ZVWXJFpFGWH/I+SxQGpKuk0t2V/DgzLm1S3b5ZIovGUQyJl26Rzdr6tBAKS
Q64acMJH59sYQJ8eTuzBNca3vDOR2XQBNXwab0YycV+1WQ3yc1erPCYAuu8a3vBH5+HZGplp
NZmHVyiKWWNakJGxMF8Xk5kEsAv9o4yCwDsPyfQ1QGlrGT5o0TDnR/YfTh7Rx/frRxewXoMq
I+pmIFcSKAx7hNH81qLURZjvn834gAxz+m9J3tgfRJP/l6IrqVMHFwWUBoTsWxzqtFTPJ6Vq
nNQOTpk+Mk5AvWeSvxhATN1wPGjMGmAr8z8wObVspLUHK+j5KzfuwhrEu6QcDnbO7vb8co74
lvJa3a6EepEDR1mOuud/ktDY5W8AZLrMRi8MKn+zl3d06YWKuS3UVGfd6xY5hBGlszPEuvcO
r6ljlmxXLPAszFH3CbSoOjjbQ0RCU3920KbBeCayUKWi0ObjJ1bEJInT9g7MkgEE7g3GTKm5
VuuefsKR/TeHxbQXYclLG6kYp/24bZQLg6Sa4gj6jSMtar+nN2FEBlv60t89VgNamnV0oCbI
/CqpRLXbCRdDLyYBes+qP18Luj1Rb3m8SPDw48LOYVwezizyBG6ELa5EggbhfbIqxJJUYDJ4
4Ya2nMNT2Tgh+xaNFy9/PChWeVwEKGSln+9lNkYGPjZNbJs2YerMi2sKDs3aQsq7N6KJsSBq
qtcRAP4wXS2bZdeZQ3lVAWd/s4sMrrqlyk4t0T6eYY6/q8n0vFWLd25JC/YDXZrE/M+eJ1XN
J2QgzpeWjgM0MsnHoP/WFecDGVikRcLZzpgSECeM0LpEM0hbItGY+C2Z5dLC2WBn1sfwoaWG
+/J8NesYRYT8fKFh6zVcxWgtB10anoqdxDeS8bxdNnPtg3VArMm5mIIfuGiyt3UEBkxtRg/i
NkF+MMD+8v/6FImaUgw28lJSt3UNuSxxlOzDCfikOtOr3Jv1zxzIz5UJ7hCni47N9TqLi0Ae
bUeLD6vc6r8wCCYsRGyhGDN1dPR0aazBic+BIFQBBdALLcRDSRZ3/13emRNZcoLOUBDh1/JZ
uC/lpRD3gZeapiNGqThD3yO2Q+BR4ycRQA4XCRD8iDCHudU0G7ScdmTIHTJZoL6Cc6O7OrP1
aQ3v3iXPRV7c6rr108jVFxj5PrQCD4Fo8jQ5SjQSpmhVoE/91LgyOeoC76PS5scHvYHPWgNa
7dFeVHjAjEykMdz4wbHJrr0cwSERI8rFaJ5FFDOsv9XYNDklbXWNZ18od2LHnLMrkZtVgHZa
TqyAKYT5rcMTH8bJl6n09B8f3JB6J4khBs+2WWyU22GLZMC5iomYXVw+nF8npYcHJjRTt+d7
R5Eqgw6EUmDolYsNyn/dL8WJgF8Hcv5m0Y1ckpogHVvJYhYvFVDIxZbWHHfkdlRp2NTXNm/Q
Yv+ke0Or/Sw6erh5B+tcadqGpNR9d4gjlevGTj2ATC4zFWRkeu10ezFnH8ATZBPdsGH2fbW4
ie0zK6xY7nj99a5n0Mvg39SBjOo8ZPXLCugmS1Q9gDwZ+tfagbsv/goB8LtFZIKux7fSGOy9
RzNQZ8uCtgYnrjWSsQu1vzKIGcg6YBn7BhWyT4Ngnn4kA6SI7g66/RFmG2b3V1a8umpoQ3/v
FJs1OIsz2LyQxi9curjaJgSi3gD2NNCx9WFiN514YoJCsv/jCSmPJ3SvT7xcHWO4SVyo9VmT
l5vn/rh67kBFB87TGB8tm2mTw2caJUyi6qW3/kTQeceXmf75OL8ySI8ZGFrhqphC6iu9PE10
zgb0nUBFyRNOrrDzBXKwmqWO4NrQJ4sgHokDzWx4gXfcB+7awLmw313/wEkY2YWnYOUxBKUQ
EQHonr2QvMrMjEEpmh0441P4yUAaJ7gyidt2YHRf6ObXJlYJaNuAVcDD+214YXsYGpn2oHkw
iEnYp1eYMnW4LsFVIbRTjOb/G5tWJWq/p+gIYt8HdXfhjYaUYPFt+XTu5yGp9ykslZY6WyVQ
oBlMpTyY1I/v7R/v2j2LfcWYHYvzJynqfND857tAuI9G05wRARzDBTWl1wF5oXYFiVtZXSpk
Pew7sT1SG29tXMm8MGMYYeUiMr43vLrNafTrTx2DgKH2Harxn73wLWmxAnko1mgubtQWHora
mizzqtqDA4TnblpJpyzaK/m13QXWpr2LT7vKi6q2y/OlBPCFS5Z77QVAswYxZ5x3/s2O9TQ/
DgpaFYBCtsRf0ozT3kepU4Baa2S7q9EKNbnT4Nsje0FV+fftP0srBgBTdOP1GGJihwRJgaeH
PuzM82YLmhMXQZDvvI09sJ77XBShWHQIi89YxjWAQ1a7Yo/EnuD/Ul5hZzArcKJzP3gslxzF
DdwfJtBNGwEANhvw+0jrXXMzcwo0ChVdhkjly5bdeoHalOt66UnGfo2q58o9+0P7dR0KffGn
AFYoxSx7DCuwqVgs3CaicRidbVILMdLKPZgQJs8Y0JELzULC9hCiG+13/XxNay0Q2EqKVzbf
R9+sRVVgP/1+vIzMAap6wZGF6Lqptf3RK90KsVLhplfdODqMcNIou9PQYxK99DJzwGAH2w4J
jmZum7gHrqEtEFsc/XKkXgzPuVHaua5MyXKJyohma+IFJtz9sahLUYkeF1x0p4ZDpdOUpLgO
KgDzhyl9UNTYYDMGPQqojf+UBmPcrGP2hKRl5gTJRuCmGDlhIaOm+IM9LG5vl/u3fyzMTDif
IvY3vyYgoRwYU1yiAjNRbFJoZFnXNYc6ZFTL6aM+Z0eU4METO40P70RAZf7xHc2H1bMpnKjx
AcD0BXA1eKz48nh2I4ElASwTragE3XuzSTU8UO1kSq2k2l9bG5F+UWEv+ZcSZ0AB5T/y3Zx9
cS0lIzXvYqsfEOdapmbsJUKTu+d/WfP9O+Md0JePDMTV/e4ARclf6yrPsO45bpnLb7yORFYS
d5HzLaEXymEHOFUYLd0Th2Mgw8ZSnAPscRkxMye6C4Lhal6/pbRWhRg30GSe2NaQoQI/qj6V
TEn2KqtsjrKyMEZ6YIan7iah5nVgb0RKVBgezUlsf0BdREguUGIsoq+7lGFPLyBfD9CFZs2P
ZAQMEWTEk2fY1Fi8KeaZdSrAfOv9Gpwc1KwbJRdz8vu0BC2JHwQyqVvPuMop2gHsX+lSIDja
wTyODGV4AjBJx4fNxacgqb7F+REB5PpbFG4llz2p1tJKG8mASLJ/N1zqnQTuoRCIrp/aGMTp
4zFGoNJIqVPcbzBoFlBKBVJBJ7yEupuHcVEEMxA0KAns0dm98FLgB2qRPkIVdmnYevs26c+d
bu1iCDcT+kRCNNZkg7KQd23+yNYRvNc542g80IH8LrD6uoSS5lfwC8oj4Yn9hpd4N9LEuVqa
pXWUf8h5bA6DKrnfdIYyb9rnkO71GzCvX7qjrTAogQHULSnrWo8x/VoWGXFKfYsIzkYlDhpJ
uTLIzAn0IQlfvt4AaqSZY3dqphRjSuSsUYmftQpYYWeJvhBXuDHlX8h66JO57Z9Ls2fatzmR
y6wLgQjKTYTgFfv7IFhU7cGIAMRA+bMTBGbR4twu8Pl47pbKbR33hXHtQhTlsPtAwafM68tq
y4Tm5UA3ATVhYmw2o+AwNkoSVqwWu3rYXrSW/2hBmK3Rrm7VSr6cg50Tubc8jxcMIfzOmHsR
sXOiJbGQgG5tZomDe8E7L1pj8c1nwrP3es9o/DgAAAAc8KoKdwOg4QABiq4I0JxiKRochbHE
Z/sCAAAAAARZWg==

--oP9at/Ymg5VWhwKB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hwsim

2018-10-28 12:00:43 export USER=root
2018-10-28 12:00:43 ./build.sh
Building TNC testing tools
Building wlantest
Building hostapd
Building wpa_supplicant
2018-10-28 12:02:49 ./start.sh
ignored_by_lkp sigma_dut_ap_cipher_ccmp_gcmp_2
ignored_by_lkp sigma_dut_ap_cipher_gcmp_128
ignored_by_lkp sigma_dut_ap_cipher_gcmp_256
ignored_by_lkp sigma_dut_ap_cipher_gcmp_256_group_ccmp
ignored_by_lkp sigma_dut_ap_dpp_pkex_responder
ignored_by_lkp sigma_dut_ap_dpp_qr
ignored_by_lkp sigma_dut_ap_dpp_qr_legacy
ignored_by_lkp sigma_dut_ap_dpp_qr_legacy_psk
ignored_by_lkp sigma_dut_ap_dpp_self_config
ignored_by_lkp sigma_dut_ap_eap
ignored_by_lkp sigma_dut_ap_eap_osen
ignored_by_lkp sigma_dut_ap_eap_sha256
ignored_by_lkp sigma_dut_ap_ent_ft_eap
ignored_by_lkp sigma_dut_ap_ft_eap
ignored_by_lkp sigma_dut_ap_ft_psk
ignored_by_lkp sigma_dut_ap_osen
ignored_by_lkp sigma_dut_ap_override_rsne
ignored_by_lkp sigma_dut_ap_owe
ignored_by_lkp sigma_dut_ap_owe_ecgroupid
ignored_by_lkp sigma_dut_ap_owe_transition_mode
ignored_by_lkp sigma_dut_ap_owe_transition_mode_2
ignored_by_lkp sigma_dut_ap_psk
ignored_by_lkp sigma_dut_ap_psk_sae
ignored_by_lkp sigma_dut_ap_psk_sha256
ignored_by_lkp sigma_dut_ap_pskhex
ignored_by_lkp sigma_dut_ap_sae
ignored_by_lkp sigma_dut_ap_sae_group
ignored_by_lkp sigma_dut_ap_sae_password
ignored_by_lkp sigma_dut_ap_suite_b
ignored_by_lkp sigma_dut_basic
ignored_by_lkp sigma_dut_dpp_incompatible_roles_init
ignored_by_lkp sigma_dut_dpp_incompatible_roles_resp
ignored_by_lkp sigma_dut_dpp_pkex_init_configurator
ignored_by_lkp sigma_dut_dpp_pkex_responder_proto
ignored_by_lkp sigma_dut_dpp_proto_initiator
ignored_by_lkp sigma_dut_dpp_proto_initiator_pkex
ignored_by_lkp sigma_dut_dpp_proto_peer_disc_req
ignored_by_lkp sigma_dut_dpp_proto_responder
ignored_by_lkp sigma_dut_dpp_proto_responder_pkex
ignored_by_lkp sigma_dut_dpp_proto_stop_at_initiator
ignored_by_lkp sigma_dut_dpp_proto_stop_at_initiator_enrollee
ignored_by_lkp sigma_dut_dpp_proto_stop_at_responder
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_1
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_2
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_3
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_4
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_5
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_6
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_7
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_both
ignored_by_lkp sigma_dut_dpp_qr_init_configurator_neg_freq
ignored_by_lkp sigma_dut_dpp_qr_init_enrollee
ignored_by_lkp sigma_dut_dpp_qr_init_enrollee_psk
ignored_by_lkp sigma_dut_dpp_qr_init_enrollee_sae
ignored_by_lkp sigma_dut_dpp_qr_mutual_init_enrollee
ignored_by_lkp sigma_dut_dpp_qr_mutual_init_enrollee_check
ignored_by_lkp sigma_dut_dpp_qr_mutual_init_enrollee_pending
ignored_by_lkp sigma_dut_dpp_qr_mutual_resp_enrollee
ignored_by_lkp sigma_dut_dpp_qr_mutual_resp_enrollee_pending
ignored_by_lkp sigma_dut_dpp_qr_resp_1
ignored_by_lkp sigma_dut_dpp_qr_resp_2
ignored_by_lkp sigma_dut_dpp_qr_resp_3
ignored_by_lkp sigma_dut_dpp_qr_resp_4
ignored_by_lkp sigma_dut_dpp_qr_resp_5
ignored_by_lkp sigma_dut_dpp_qr_resp_6
ignored_by_lkp sigma_dut_dpp_qr_resp_7
ignored_by_lkp sigma_dut_dpp_qr_resp_chan_list
ignored_by_lkp sigma_dut_dpp_self_config
ignored_by_lkp sigma_dut_hs20_assoc_24
ignored_by_lkp sigma_dut_hs20_assoc_5
ignored_by_lkp sigma_dut_open
ignored_by_lkp sigma_dut_owe
ignored_by_lkp sigma_dut_preconfigured_profile
ignored_by_lkp sigma_dut_psk_pmf
ignored_by_lkp sigma_dut_psk_pmf_bip_cmac_128
ignored_by_lkp sigma_dut_psk_pmf_bip_cmac_256
ignored_by_lkp sigma_dut_psk_pmf_bip_gmac_128
ignored_by_lkp sigma_dut_psk_pmf_bip_gmac_256
ignored_by_lkp sigma_dut_psk_pmf_bip_gmac_256_mismatch
ignored_by_lkp sigma_dut_sae
ignored_by_lkp sigma_dut_sae_password
ignored_by_lkp sigma_dut_sta_override_rsne
ignored_by_lkp sigma_dut_sta_scan_bss
ignored_by_lkp sigma_dut_suite_b
ignored_by_lkp sigma_dut_suite_b_rsa
ignored_by_lkp sigma_dut_venue_url
ignored_by_lkp sigma_dut_wps_pbc
2018-10-28 12:02:50 	./run-tests.py ssid_1_octet 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_1_octet 1/1
Test: SSID with one octet
Starting AP wlan3
Connect STA wlan0 to AP
PASS ssid_1_octet 0.469068 2018-10-28 12:02:52.353460
passed all 1 test case(s)
2018-10-28 12:02:52 	./run-tests.py ssid_32_octets 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_32_octets 1/1
Test: SSID with 32 octets
Starting AP wlan3
Connect STA wlan0 to AP
PASS ssid_32_octets 0.416617 2018-10-28 12:02:53.187065
passed all 1 test case(s)
2018-10-28 12:02:53 	./run-tests.py ssid_hex_encoded 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hex_encoded 1/1
Test: SSID configuration using hex encoded version
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
PASS ssid_hex_encoded 0.576768 2018-10-28 12:02:54.111255
passed all 1 test case(s)
2018-10-28 12:02:54 	./run-tests.py ssid_hidden 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hidden 1/1
Test: Hidden SSID
Starting AP wlan3
Connect STA wlan1 to AP
Connect STA wlan0 to AP
PASS ssid_hidden 1.619968 2018-10-28 12:02:56.141386
passed all 1 test case(s)
2018-10-28 12:02:56 	./run-tests.py ssid_hidden2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hidden2 1/1
Test: Hidden SSID using zero octets as payload
Starting AP wlan3
Connect STA wlan1 to AP
Connect STA wlan0 to AP
PASS ssid_hidden2 1.648897 2018-10-28 12:02:58.194421
passed all 1 test case(s)
2018-10-28 12:02:58 	./run-tests.py ssid_hidden_wpa2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_hidden_wpa2 1/1
Test: Hidden SSID with WPA2-PSK
Starting AP wlan3
Connect STA wlan1 to AP
Connect STA wlan0 to AP
PASS ssid_hidden_wpa2 1.69057 2018-10-28 12:03:00.312712
passed all 1 test case(s)
2018-10-28 12:03:00 	./run-tests.py ssid_printf_encoded 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_printf_encoded 1/1
Test: SSID configuration using printf encoded version
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
PASS ssid_printf_encoded 0.930009 2018-10-28 12:03:01.714338
passed all 1 test case(s)
2018-10-28 12:03:01 	./run-tests.py ssid_utf8 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START ssid_utf8 1/1
Test: SSID with UTF8 encoding
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
PASS ssid_utf8 0.750463 2018-10-28 12:03:02.908392
passed all 1 test case(s)
2018-10-28 12:03:02 	./run-tests.py sta_ap_scan_0 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_ap_scan_0 1/1
Test: Dynamically added wpa_supplicant interface with AP_SCAN 0 connection
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_ap_scan_0 1.142476 2018-10-28 12:03:04.468008
passed all 1 test case(s)
2018-10-28 12:03:04 	./run-tests.py sta_ap_scan_2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_ap_scan_2 1/1
Test: Dynamically added wpa_supplicant interface with AP_SCAN 2 connection
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_ap_scan_2 2.559885 2018-10-28 12:03:07.477257
passed all 1 test case(s)
2018-10-28 12:03:07 	./run-tests.py sta_ap_scan_2b 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_ap_scan_2b 1/1
Test: Dynamically added wpa_supplicant interface with AP_SCAN 2 operation
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_ap_scan_2b 13.738109 2018-10-28 12:03:21.630069
passed all 1 test case(s)
2018-10-28 12:03:21 	./run-tests.py sta_dynamic 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic 1/1
Test: Dynamically added wpa_supplicant interface
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_dynamic 0.721891 2018-10-28 12:03:22.758197
passed all 1 test case(s)
2018-10-28 12:03:22 	./run-tests.py sta_dynamic_down_up 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_down_up 1/1
Test: Dynamically added wpa_supplicant interface down/up
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_dynamic_down_up 1.15274 2018-10-28 12:03:24.319761
passed all 1 test case(s)
2018-10-28 12:03:24 	./run-tests.py sta_dynamic_ext_mac_addr_change 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_ext_mac_addr_change 1/1
Test: Dynamically added wpa_supplicant interface with external MAC address change
Starting AP wlan3
Create a dynamic wpa_supplicant interface and connect
Connect STA wlan5 to AP
PASS sta_dynamic_ext_mac_addr_change 1.251325 2018-10-28 12:03:26.046355
passed all 1 test case(s)
2018-10-28 12:03:26 	./run-tests.py sta_dynamic_random_mac_addr 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address
Starting AP wlan3
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr 1.363314 2018-10-28 12:03:27.829346
passed all 1 test case(s)
2018-10-28 12:03:27 	./run-tests.py sta_dynamic_random_mac_addr_keep_oui 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr_keep_oui 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address (keep OUI)
Starting AP wlan3
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr_keep_oui 1.370933 2018-10-28 12:03:29.644521
passed all 1 test case(s)
2018-10-28 12:03:29 	./run-tests.py sta_dynamic_random_mac_addr_scan 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr_scan 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address for scan
Starting AP wlan3
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr_scan 0.989996 2018-10-28 12:03:31.179899
passed all 1 test case(s)
2018-10-28 12:03:31 	./run-tests.py sta_dynamic_random_mac_addr_scan_keep_oui 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START sta_dynamic_random_mac_addr_scan_keep_oui 1/1
Test: Dynamically added wpa_supplicant interface and random MAC address for scan (keep OUI)
Starting AP wlan3
Connect STA wlan5 to AP
PASS sta_dynamic_random_mac_addr_scan_keep_oui 0.918663 2018-10-28 12:03:32.568132
passed all 1 test case(s)
2018-10-28 12:03:32 	./run-tests.py suite_b 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b 1/1
Test: WPA2/GCMP connection at Suite B 128-bit level
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b 0.931645 2018-10-28 12:03:34.052579
passed all 1 test case(s)
2018-10-28 12:03:34 	./run-tests.py suite_b_192 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192 1.121564 2018-10-28 12:03:35.753060
passed all 1 test case(s)
2018-10-28 12:03:35 	./run-tests.py suite_b_192_mic_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_mic_failure 1/1
Test: WPA2/GCMP connection at Suite B 192-bit level and MIC derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_mic_failure 0.713166 2018-10-28 12:03:37.006557
passed all 1 test case(s)
2018-10-28 12:03:37 	./run-tests.py suite_b_192_pmkid_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_pmkid_failure 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and PMKID derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_pmkid_failure 0.639846 2018-10-28 12:03:38.153704
passed all 1 test case(s)
2018-10-28 12:03:38 	./run-tests.py suite_b_192_radius 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_radius 1/1
Test: WPA2/GCMP-256 (RADIUS) connection at Suite B 192-bit level
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_radius 0.975543 2018-10-28 12:03:39.552257
passed all 1 test case(s)
2018-10-28 12:03:39 	./run-tests.py suite_b_192_radius_and_p256_cert 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_radius_and_p256_cert 1/1
Test: Suite B 192-bit level and p256 client cert
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_radius_and_p256_cert 0.976882 2018-10-28 12:03:41.032750
passed all 1 test case(s)
2018-10-28 12:03:41 	./run-tests.py suite_b_192_rsa 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa 0.848577 2018-10-28 12:03:42.511323
passed all 1 test case(s)
2018-10-28 12:03:42 	./run-tests.py suite_b_192_rsa_dhe 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_dhe 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA (DHE)
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_dhe 0.956581 2018-10-28 12:03:43.954524
passed all 1 test case(s)
2018-10-28 12:03:44 	./run-tests.py suite_b_192_rsa_dhe_radius_rsa2048_client 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_dhe_radius_rsa2048_client 1/1
Test: Suite B 192-bit level and RSA (DHE) and RSA2048 client
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_dhe_radius_rsa2048_client 0.878744 2018-10-28 12:03:45.321909
passed all 1 test case(s)
2018-10-28 12:03:45 	./run-tests.py suite_b_192_rsa_ecdhe 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_ecdhe 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA (ECDHE)
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_ecdhe 1.079896 2018-10-28 12:03:46.950174
passed all 1 test case(s)
2018-10-28 12:03:47 	./run-tests.py suite_b_192_rsa_ecdhe_radius_rsa2048_client 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_ecdhe_radius_rsa2048_client 1/1
Test: Suite B 192-bit level and RSA (ECDHE) and RSA2048 client
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_ecdhe_radius_rsa2048_client 1.131369 2018-10-28 12:03:48.617713
passed all 1 test case(s)
2018-10-28 12:03:48 	./run-tests.py suite_b_192_rsa_insufficient_dh 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_insufficient_dh 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA with insufficient DH key length
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_insufficient_dh 0.761804 2018-10-28 12:03:49.803313
passed all 1 test case(s)
2018-10-28 12:03:49 	./run-tests.py suite_b_192_rsa_insufficient_key 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_insufficient_key 1/1
Test: WPA2/GCMP-256 connection at Suite B 192-bit level and RSA with insufficient key length
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_insufficient_key 0.716303 2018-10-28 12:03:51.024431
passed all 1 test case(s)
2018-10-28 12:03:51 	./run-tests.py suite_b_192_rsa_radius 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_192_rsa_radius 1/1
Test: WPA2/GCMP-256 (RADIUS) connection at Suite B 192-bit level and RSA (ECDHE)
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_192_rsa_radius 1.294771 2018-10-28 12:03:52.864967
passed all 1 test case(s)
2018-10-28 12:03:52 	./run-tests.py suite_b_mic_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_mic_failure 1/1
Test: WPA2/GCMP connection at Suite B 128-bit level and MIC derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_mic_failure 0.853263 2018-10-28 12:03:54.271571
passed all 1 test case(s)
2018-10-28 12:03:54 	./run-tests.py suite_b_pmkid_failure 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_pmkid_failure 1/1
Test: WPA2/GCMP connection at Suite B 128-bit level and PMKID derivation failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_pmkid_failure 0.782954 2018-10-28 12:03:55.602313
passed all 1 test case(s)
2018-10-28 12:03:55 	./run-tests.py suite_b_radius 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START suite_b_radius 1/1
Test: WPA2/GCMP (RADIUS) connection at Suite B 128-bit level
Starting AP wlan4
Starting AP wlan3
Connect STA wlan0 to AP
PASS suite_b_radius 1.013984 2018-10-28 12:03:57.075159
passed all 1 test case(s)
ignored_by_lkp tdls_chan_switch
2018-10-28 12:03:57 	./run-tests.py tnc_fast 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_fast 1/1
Test: TNC FAST
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 194, in test_tnc_fast
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_fast 10.377092 2018-10-28 12:04:07.904561
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_fast
2018-10-28 12:04:07 	./run-tests.py tnc_peap_soh 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_peap_soh 1/1
Test: TNC PEAP-SoH
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 26, in test_tnc_peap_soh
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_peap_soh 10.416039 2018-10-28 12:04:18.850401
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_peap_soh
2018-10-28 12:04:18 	./run-tests.py tnc_peap_soh_errors 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_peap_soh_errors 1/1
Test: TNC PEAP-SoH local error cases
Starting AP wlan3
Connect STA wlan0 to AP
Failure not triggered
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 60, in test_tnc_peap_soh_errors
    wait_fail_trigger(dev[0], "GET_ALLOC_FAIL")
  File "/lkp/benchmarks/hwsim/tests/hwsim/utils.py", line 62, in wait_fail_trigger
    raise Exception(note)
Exception: Failure not triggered
FAIL tnc_peap_soh_errors 2.543831 2018-10-28 12:04:21.980850
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_peap_soh_errors
2018-10-28 12:04:22 	./run-tests.py tnc_ttls 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_ttls 1/1
Test: TNC TTLS
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 91, in test_tnc_ttls
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_ttls 10.453996 2018-10-28 12:04:32.939168
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_ttls
2018-10-28 12:04:33 	./run-tests.py tnc_ttls_errors 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_ttls_errors 1/1
Test: TNC TTLS local error cases
Starting AP wlan3
Connect STA wlan0 to AP
Allocation failure not triggered for: 1:eap_ttls_process_phase2_eap;eap_ttls_process_tnc_start
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 167, in test_tnc_ttls_errors
    note="Allocation failure not triggered for: %d:%s" % (count, func))
  File "/lkp/benchmarks/hwsim/tests/hwsim/utils.py", line 62, in wait_fail_trigger
    raise Exception(note)
Exception: Allocation failure not triggered for: 1:eap_ttls_process_phase2_eap;eap_ttls_process_tnc_start
FAIL tnc_ttls_errors 2.607626 2018-10-28 12:04:36.056599
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_ttls_errors
2018-10-28 12:04:36 	./run-tests.py tnc_ttls_fragmentation 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tnc_ttls_fragmentation 1/1
Test: TNC TTLS with fragmentation
Starting AP wlan3
Connect STA wlan0 to AP
Connection timed out
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_tnc.py", line 111, in test_tnc_ttls_fragmentation
    dev[0].wait_connected(timeout=10)
  File "/lkp/benchmarks/hwsim/tests/hwsim/wpasupplicant.py", line 1276, in wait_connected
    raise Exception(error)
Exception: Connection timed out
FAIL tnc_ttls_fragmentation 10.423287 2018-10-28 12:04:47.018479
passed 0 test case(s)
skipped 0 test case(s)
failed tests: tnc_ttls_fragmentation
2018-10-28 12:04:47 	./run-tests.py tspec 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec 1/1
Test: Basic addts/delts tests
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec 0.775814 2018-10-28 12:04:48.287804
passed all 1 test case(s)
2018-10-28 12:04:48 	./run-tests.py tspec_ap_fail 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_ap_fail 1/1
Test: AP failing to send tspec response
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_ap_fail 1.526823 2018-10-28 12:04:50.392410
passed all 1 test case(s)
2018-10-28 12:04:50 	./run-tests.py tspec_ap_parsing 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_ap_parsing 1/1
Test: TSPEC AP parsing tests
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_ap_parsing 0.72163 2018-10-28 12:04:51.663684
passed all 1 test case(s)
2018-10-28 12:04:51 	./run-tests.py tspec_ap_roam_open 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_ap_roam_open 1/1
Test: Roam between two open APs while having tspecs
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan4
PASS tspec_ap_roam_open 5.374646 2018-10-28 12:04:57.611491
passed all 1 test case(s)
2018-10-28 12:04:57 	./run-tests.py tspec_not_enabled 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_not_enabled 1/1
Test: addts failing if AP does not support WMM
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_not_enabled 0.731853 2018-10-28 12:04:58.814328
passed all 1 test case(s)
2018-10-28 12:04:58 	./run-tests.py tspec_protocol 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_protocol 1/1
Test: Protocol tests for addts/delts
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_protocol 1.723449 2018-10-28 12:05:01.037510
passed all 1 test case(s)
2018-10-28 12:05:01 	./run-tests.py tspec_reassoc 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START tspec_reassoc 1/1
Test: Reassociation to same BSS while having tspecs
Starting AP wlan3
Connect STA wlan0 to AP
PASS tspec_reassoc 4.699278 2018-10-28 12:05:06.226323
passed all 1 test case(s)
2018-10-28 12:05:06 	./run-tests.py wep_ht_vht 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_ht_vht 1/1
Test: WEP and HT/VHT
Starting AP wlan3
Connect STA wlan0 to AP
hostapd STATUS: {'olbc_ht': '0', 'cac_time_left_seconds': 'N/A', 'num_sta_no_short_slot_time': '1', 'olbc': '0', 'num_sta_non_erp': '0', 'supported_rates': '0c 12 18 24 30 48 60 6c', 'ht_op_mode': '0x13', 'state': 'ENABLED', 'num_sta_ht40_intolerant': '0', 'channel': '36', 'bssid[0]': '02:00:00:00:03:00', 'ieee80211n': '0', 'cac_time_seconds': '0', 'num_sta[0]': '1', 'ieee80211ac': '0', 'phy': 'phy3', 'max_txpower': '20', 'num_sta_ht_no_gf': '0', 'freq': '5180', 'num_sta_ht_20_mhz': '0', 'num_sta_no_short_preamble': '1', 'secondary_channel': '0', 'ssid[0]': 'test-vht40-wep', 'dtim_period': '2', 'beacon_int': '100', 'num_sta_no_ht': '1', 'bss[0]': 'wlan3'}
PASS wep_ht_vht 1.086451 2018-10-28 12:05:07.754182
passed all 1 test case(s)
2018-10-28 12:05:07 	./run-tests.py wep_ifdown 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_ifdown 1/1
Test: AP with WEP and external ifconfig down
Starting AP wlan3
Connect STA wlan0 to AP
PASS wep_ifdown 1.179304 2018-10-28 12:05:09.475904
passed all 1 test case(s)
2018-10-28 12:05:09 	./run-tests.py wep_open_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_open_auth 1/1
Test: WEP Open System authentication
Starting AP wlan3
Connect STA wlan0 to AP
PASS wep_open_auth 0.508769 2018-10-28 12:05:10.426938
passed all 1 test case(s)
2018-10-28 12:05:10 	./run-tests.py wep_shared_key_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_shared_key_auth 1/1
Test: WEP Shared Key authentication
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
PASS wep_shared_key_auth 0.82823 2018-10-28 12:05:11.676748
passed all 1 test case(s)
2018-10-28 12:05:11 	./run-tests.py wep_shared_key_auth_multi_key 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_shared_key_auth_multi_key 1/1
Test: WEP Shared Key authentication with multiple keys
Starting AP wlan3
Connect STA wlan0 to AP
Connect STA wlan1 to AP
Connect STA wlan2 to AP
PASS wep_shared_key_auth_multi_key 1.247324 2018-10-28 12:05:13.337600
passed all 1 test case(s)
2018-10-28 12:05:13 	./run-tests.py wep_shared_key_auth_not_allowed 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wep_shared_key_auth_not_allowed 1/1
Test: WEP Shared Key authentication not allowed
Starting AP wlan3
Connect STA wlan0 to AP
PASS wep_shared_key_auth_not_allowed 1.348489 2018-10-28 12:05:15.151311
passed all 1 test case(s)
2018-10-28 12:05:15 	./run-tests.py wext_open 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_open 1/1
Test: WEXT driver interface with open network
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_open 4.644343 2018-10-28 12:05:20.226635
passed all 1 test case(s)
2018-10-28 12:05:20 	./run-tests.py wext_pmf 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_pmf 1/1
Test: WEXT driver interface with WPA2-PSK and PMF
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_pmf 8.845238 2018-10-28 12:05:29.666662
passed all 1 test case(s)
2018-10-28 12:05:29 	./run-tests.py wext_pmksa_cache 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_pmksa_cache 1/1
Test: PMKSA caching with WEXT
Starting AP wlan3
Connect STA wlan5 to AP
Starting AP wlan4
Roam to AP2
Roam back to AP1
PASS wext_pmksa_cache 32.945808 2018-10-28 12:06:03.243617
passed all 1 test case(s)
2018-10-28 12:06:03 	./run-tests.py wext_rfkill 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_rfkill 1/1
Test: WEXT and rfkill block/unblock
Starting AP wlan3
Connect STA wlan5 to AP
rfkill block
rfkill unblock
PASS wext_rfkill 8.952556 2018-10-28 12:06:12.756213
passed all 1 test case(s)
2018-10-28 12:06:12 	./run-tests.py wext_scan_hidden 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_scan_hidden 1/1
Test: WEXT with hidden SSID
Starting AP wlan3
Starting AP wlan4
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS wext_scan_hidden 18.402832 2018-10-28 12:06:31.751499
passed all 1 test case(s)
2018-10-28 12:06:31 	./run-tests.py wext_wep_open_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wep_open_auth 1/1
Test: WEP Open System authentication
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_wep_open_auth 4.813233 2018-10-28 12:06:37.087342
passed all 1 test case(s)
2018-10-28 12:06:37 	./run-tests.py wext_wep_shared_key_auth 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wep_shared_key_auth 1/1
Test: WEP Shared Key authentication
Starting AP wlan3
Connect STA wlan5 to AP
Connect STA wlan5 to AP
PASS wext_wep_shared_key_auth 5.042088 2018-10-28 12:06:42.655147
passed all 1 test case(s)
2018-10-28 12:06:42 	./run-tests.py wext_wpa2_psk 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wpa2_psk 1/1
Test: WEXT driver interface with WPA2-PSK
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_wpa2_psk 4.706991 2018-10-28 12:06:47.905331
passed all 1 test case(s)
2018-10-28 12:06:47 	./run-tests.py wext_wpa_psk 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wext_wpa_psk 1/1
Test: WEXT driver interface with WPA-PSK
Starting AP wlan3
Connect STA wlan5 to AP
PASS wext_wpa_psk 5.769256 2018-10-28 12:06:54.220483
passed all 1 test case(s)
2018-10-28 12:06:54 	./run-tests.py wifi_display 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display 1/1
Test: Wi-Fi Display extensions to P2P
wlan0: Trying to discover peer 02:00:00:00:01:00
wlan1: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display 5.12075 2018-10-28 12:06:59.916120
passed all 1 test case(s)
2018-10-28 12:06:59 	./run-tests.py wifi_display_disable 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_disable 1/1
Test: Peer disabling Wi-Fi Display advertisement
PASS wifi_display_disable 1.498646 2018-10-28 12:07:01.917863
passed all 1 test case(s)
2018-10-28 12:07:01 	./run-tests.py wifi_display_go_invite 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_go_invite 1/1
Test: P2P GO with Wi-Fi Display inviting a client to join
wlan0: Trying to discover peer 02:00:00:00:01:00
wlan1: Trying to discover peer 02:00:00:00:00:00
Authorize invitation
Try to connect the client to the GO
wlan2: Trying to discover peer 02:00:00:00:00:00
Client connected
Invite peer to join the group
PASS wifi_display_go_invite 3.399298 2018-10-28 12:07:05.829763
passed all 1 test case(s)
2018-10-28 12:07:05 	./run-tests.py wifi_display_invalid_subelem 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_invalid_subelem 1/1
Test: Wi-Fi Display and invalid subelement parsing
PASS wifi_display_invalid_subelem 0.368611 2018-10-28 12:07:06.697400
passed all 1 test case(s)
2018-10-28 12:07:06 	./run-tests.py wifi_display_parsing 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_parsing 1/1
Test: Wi-Fi Display extensions to P2P and special parsing cases
wlan1: Trying to discover peer 02:00:00:00:00:00
wlan2: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display_parsing 2.652806 2018-10-28 12:07:09.825581
passed all 1 test case(s)
2018-10-28 12:07:09 	./run-tests.py wifi_display_persistent_group 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_persistent_group 1/1
Test: P2P persistent group formation and re-invocation with Wi-Fi Display enabled
Form a persistent group
Start GO negotiation wlan0 -> wlan1
wlan1: Trying to discover peer 02:00:00:00:00:00
wlan0: Trying to discover peer 02:00:00:00:01:00
Group formed
Terminate persistent group
Re-invoke persistent group from client
wlan1: Trying to discover peer 02:00:00:00:00:00
Terminate persistent group
Re-invoke persistent group from GO
wlan0: Trying to discover peer 02:00:00:00:01:00
Terminate persistent group
Try to connect the client to the GO
wlan2: Trying to discover peer 02:00:00:00:00:00
Client connected
wlan1: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display_persistent_group 8.358167 2018-10-28 12:07:18.734524
passed all 1 test case(s)
2018-10-28 12:07:18 	./run-tests.py wifi_display_r2 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wifi_display_r2 1/1
Test: Wi-Fi Display extensions to P2P with R2 subelems
wlan0: Trying to discover peer 02:00:00:00:01:00
wlan1: Trying to discover peer 02:00:00:00:00:00
PASS wifi_display_r2 2.029335 2018-10-28 12:07:21.294642
passed all 1 test case(s)
ignored_by_lkp wmediumd_path_rann
2018-10-28 12:07:21 	./run-tests.py wmediumd_path_simple 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmediumd_path_simple 1/1
Test: test a mesh path
PASS wmediumd_path_simple 1.785899 2018-10-28 12:07:23.579587
passed all 1 test case(s)
2018-10-28 12:07:23 	./run-tests.py wmediumd_path_ttl 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmediumd_path_ttl 1/1
Test: Mesh path request TTL
PASS wmediumd_path_ttl 10.094398 2018-10-28 12:07:34.185400
passed all 1 test case(s)
2018-10-28 12:07:34 	./run-tests.py wmediumd_simple 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmediumd_simple 1/1
Test: test a simple wmediumd configuration
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan3
Connect STA wlan0 to AP
PASS wmediumd_simple 1.282524 2018-10-28 12:07:36.029586
passed all 1 test case(s)
2018-10-28 12:07:36 	./run-tests.py wmm_disabled 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmm_disabled 1/1
Test: WMM disabled and unexpected TSPEC
Starting AP wlan3 (old add_ap argument type)
Connect STA wlan0 to AP
PASS wmm_disabled 0.563496 2018-10-28 12:07:37.129336
passed all 1 test case(s)
2018-10-28 12:07:37 	./run-tests.py wmm_element 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wmm_element 1/1
Test: hostapd FTM range request timeout
Starting AP wlan3 (old add_ap argument type)
Connect STA wlan0 to AP
Connect STA wlan0 to AP
Connect STA wlan0 to AP
PASS wmm_element 0.788016 2018-10-28 12:07:38.402345
passed all 1 test case(s)
2018-10-28 12:07:38 	./run-tests.py wnm_action_proto 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_action_proto 1/1
Test: WNM Action protocol testing
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_action_proto 0.666706 2018-10-28 12:07:39.580035
passed all 1 test case(s)
2018-10-28 12:07:39 	./run-tests.py wnm_action_proto_no_pmf 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_action_proto_no_pmf 1/1
Test: WNM Action protocol testing (PMF disabled)
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_action_proto_no_pmf 0.852016 2018-10-28 12:07:41.033369
passed all 1 test case(s)
2018-10-28 12:07:41 	./run-tests.py wnm_action_proto_pmf 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_action_proto_pmf 1/1
Test: WNM Action protocol testing (PMF enabled)
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_action_proto_pmf 0.723645 2018-10-28 12:07:42.316429
passed all 1 test case(s)
2018-10-28 12:07:42 	./run-tests.py wnm_bss_keep_alive 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_keep_alive 1/1
Test: WNM keep-alive
Starting AP wlan3
Connect STA wlan0 to AP
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=8 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=NULLFUNC POLL rx_packets=9 tx_packets=4
timeout_next=DISASSOC rx_packets=9 tx_packets=5
PASS wnm_bss_keep_alive 18.610134 2018-10-28 12:08:01.364287
passed all 1 test case(s)
2018-10-28 12:08:01 	./run-tests.py wnm_bss_tm 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm 1/1
Test: WNM BSS Transition Management
Starting AP wlan3
Connect STA wlan0 to AP
Starting AP wlan4
No neighbor list entries
Neighbor list entry, but not claimed as Preferred Candidate List
Preferred Candidate List (no matching neighbor) without Disassociation Imminent
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
Preferred Candidate List with two matches, no roam needed
Preferred Candidate List with two matches and extra frequency (160 MHz), no roam needed
PASS wnm_bss_tm 2.867458 2018-10-28 12:08:04.685365
passed all 1 test case(s)
2018-10-28 12:08:04 	./run-tests.py wnm_bss_tm_ap_proto 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_ap_proto 1/1
Test: WNM BSS TM - protocol testing for AP message parsing
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_ap_proto 0.59005 2018-10-28 12:08:05.782304
passed all 1 test case(s)
2018-10-28 12:08:05 	./run-tests.py wnm_bss_tm_connect_cmd 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_connect_cmd 1/1
Test: WNM BSS Transition Management and cfg80211 connect command
Starting AP wlan3
Starting AP wlan4
Connect STA wlan5 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_connect_cmd 1.3009 2018-10-28 12:08:07.551933
passed all 1 test case(s)
2018-10-28 12:08:07 	./run-tests.py wnm_bss_tm_country_cn 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_country_cn 1/1
Test: WNM BSS Transition Management (CN)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
PASS wnm_bss_tm_country_cn 6.351981 2018-10-28 12:08:14.444079
passed all 1 test case(s)
2018-10-28 12:08:14 	./run-tests.py wnm_bss_tm_country_fi 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_country_fi 1/1
Test: WNM BSS Transition Management (FI)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
Preferred Candidate List (no matching neighbor, unknown channels 2)
PASS wnm_bss_tm_country_fi 6.838004 2018-10-28 12:08:21.875460
passed all 1 test case(s)
2018-10-28 12:08:21 	./run-tests.py wnm_bss_tm_country_jp 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_country_jp 1/1
Test: WNM BSS Transition Management (JP)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
PASS wnm_bss_tm_country_jp 7.111868 2018-10-28 12:08:29.613278
passed all 1 test case(s)
ignored_by_lkp wnm_bss_tm_country_us
2018-10-28 12:08:29 	./run-tests.py wnm_bss_tm_errors 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_errors 1/1
Test: WNM BSS Transition Management errors
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_errors 0.725001 2018-10-28 12:08:31.074478
passed all 1 test case(s)
2018-10-28 12:08:31 	./run-tests.py wnm_bss_tm_global 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_global 1/1
Test: WNM BSS Transition Management (global)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
Preferred Candidate List (no matching neighbor, unknown channels 2)
PASS wnm_bss_tm_global 7.304235 2018-10-28 12:08:38.996287
passed all 1 test case(s)
2018-10-28 12:08:39 	./run-tests.py wnm_bss_tm_global4 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_global4 1/1
Test: WNM BSS Transition Management (global; indicate table E-4)
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, known channels)
Preferred Candidate List (no matching neighbor, unknown channels)
Preferred Candidate List (no matching neighbor, unknown channels 2)
PASS wnm_bss_tm_global4 2.79861 2018-10-28 12:08:42.269785
passed all 1 test case(s)
2018-10-28 12:08:42 	./run-tests.py wnm_bss_tm_nei_11a 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_11a 1/1
Test: WNM BSS Transition Management and 11a neighbor
Starting AP wlan3
Starting AP wlan4
AP startup failed
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 795, in test_wnm_bss_tm_nei_11a
    run_wnm_bss_tm_scan_not_needed(dev, apdev, ht=False, nei_info="115,36,4")
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 834, in run_wnm_bss_tm_scan_not_needed
    hapd2 = hostapd.add_ap(apdev[1], params)
  File "/lkp/benchmarks/hwsim/tests/hwsim/hostapd.py", line 427, in add_ap
    raise Exception("AP startup failed")
Exception: AP startup failed
FAIL wnm_bss_tm_nei_11a 10.75536 2018-10-28 12:08:53.690255
passed 0 test case(s)
skipped 0 test case(s)
failed tests: wnm_bss_tm_nei_11a
2018-10-28 12:08:53 	./run-tests.py wnm_bss_tm_nei_11b 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_11b 1/1
Test: WNM BSS Transition Management and 11g neighbor
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_nei_11b 11.615235 2018-10-28 12:09:06.070069
passed all 1 test case(s)
2018-10-28 12:09:06 	./run-tests.py wnm_bss_tm_nei_11g 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_11g 1/1
Test: WNM BSS Transition Management and 11g neighbor
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_nei_11g 11.497865 2018-10-28 12:09:18.072521
passed all 1 test case(s)
2018-10-28 12:09:18 	./run-tests.py wnm_bss_tm_nei_vht 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_nei_vht 1/1
Test: WNM BSS Transition Management and VHT neighbor
Starting AP wlan3
Starting AP wlan4
AP startup failed
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 791, in test_wnm_bss_tm_nei_vht
    run_wnm_bss_tm_scan_not_needed(dev, apdev, vht=True, nei_info="115,36,9")
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 834, in run_wnm_bss_tm_scan_not_needed
    hapd2 = hostapd.add_ap(apdev[1], params)
  File "/lkp/benchmarks/hwsim/tests/hwsim/hostapd.py", line 427, in add_ap
    raise Exception("AP startup failed")
Exception: AP startup failed
FAIL wnm_bss_tm_nei_vht 10.522934 2018-10-28 12:09:29.087800
passed 0 test case(s)
skipped 0 test case(s)
failed tests: wnm_bss_tm_nei_vht
2018-10-28 12:09:29 	./run-tests.py wnm_bss_tm_op_class_0 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_op_class_0 1/1
Test: WNM BSS Transition Management with invalid operating class
Starting AP wlan3
Connect STA wlan0 to AP
Preferred Candidate List (no matching neighbor, invalid op class specified for channels)
PASS wnm_bss_tm_op_class_0 6.003448 2018-10-28 12:09:35.580689
passed all 1 test case(s)
2018-10-28 12:09:35 	./run-tests.py wnm_bss_tm_reject 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_reject 1/1
Test: WNM BSS Transition Management request getting rejected
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_reject 5.898884 2018-10-28 12:09:41.983279
passed all 1 test case(s)
2018-10-28 12:09:42 	./run-tests.py wnm_bss_tm_req 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_req 1/1
Test: BSS Transition Management Request
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_req 3.484342 2018-10-28 12:09:45.940828
passed all 1 test case(s)
2018-10-28 12:09:46 	./run-tests.py wnm_bss_tm_req_with_mbo_ie 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_req_with_mbo_ie 1/1
Test: WNM BSS transition request with MBO IE and reassociation delay attribute
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_req_with_mbo_ie 6.640216 2018-10-28 12:09:53.133134
passed all 1 test case(s)
2018-10-28 12:09:53 	./run-tests.py wnm_bss_tm_rsn 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_rsn 1/1
Test: WNM BSS Transition Management with RSN
Starting AP wlan3
Starting AP wlan4
AP startup failed
Traceback (most recent call last):
  File "./run-tests.py", line 466, in main
    t(dev, apdev)
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_wnm.py", line 1163, in test_wnm_bss_tm_rsn
    hapd2 = hostapd.add_ap(apdev[1], params)
  File "/lkp/benchmarks/hwsim/tests/hwsim/hostapd.py", line 427, in add_ap
    raise Exception("AP startup failed")
Exception: AP startup failed
FAIL wnm_bss_tm_rsn 10.730249 2018-10-28 12:10:04.336376
passed 0 test case(s)
skipped 0 test case(s)
failed tests: wnm_bss_tm_rsn
ignored_by_lkp wnm_bss_tm_scan_needed
ignored_by_lkp wnm_bss_tm_scan_needed_e4
ignored_by_lkp wnm_bss_tm_scan_not_needed
2018-10-28 12:10:04 	./run-tests.py wnm_bss_tm_security_mismatch 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_security_mismatch 1/1
Test: WNM BSS Transition Management and security mismatch
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
Preferred Candidate List (matching neighbor for another BSS) without Disassociation Imminent
PASS wnm_bss_tm_security_mismatch 1.481285 2018-10-28 12:10:06.336375
passed all 1 test case(s)
2018-10-28 12:10:06 	./run-tests.py wnm_bss_tm_termination 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_tm_termination 1/1
Test: WNM BSS Transition Management and BSS termination
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_tm_termination 1.043985 2018-10-28 12:10:08.051759
passed all 1 test case(s)
2018-10-28 12:10:08 	./run-tests.py wnm_bss_transition_mgmt 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt 1/1
Test: WNM BSS Transition Management
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt 1.7073 2018-10-28 12:10:10.522504
passed all 1 test case(s)
2018-10-28 12:10:10 	./run-tests.py wnm_bss_transition_mgmt_oom 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt_oom 1/1
Test: WNM BSS Transition Management OOM
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt_oom 0.931991 2018-10-28 12:10:12.377147
passed all 1 test case(s)
2018-10-28 12:10:12 	./run-tests.py wnm_bss_transition_mgmt_query 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt_query 1/1
Test: WNM BSS Transition Management query
Starting AP wlan3
Starting AP wlan4
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt_query 1.334503 2018-10-28 12:10:14.345372
passed all 1 test case(s)
2018-10-28 12:10:14 	./run-tests.py wnm_bss_transition_mgmt_query_with_unknown_candidates 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_bss_transition_mgmt_query_with_unknown_candidates 1/1
Test: WNM BSS Transition Management query with unknown candidates
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_bss_transition_mgmt_query_with_unknown_candidates 0.84895 2018-10-28 12:10:15.877206
passed all 1 test case(s)
2018-10-28 12:10:16 	./run-tests.py wnm_disassoc_imminent 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_disassoc_imminent 1/1
Test: WNM Disassociation Imminent
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_disassoc_imminent 0.979628 2018-10-28 12:10:17.546748
passed all 1 test case(s)
2018-10-28 12:10:17 	./run-tests.py wnm_disassoc_imminent_fail 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_disassoc_imminent_fail 1/1
Test: WNM Disassociation Imminent failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_disassoc_imminent_fail 0.707111 2018-10-28 12:10:19.107410
passed all 1 test case(s)
2018-10-28 12:10:19 	./run-tests.py wnm_ess_disassoc_imminent 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_ess_disassoc_imminent 1/1
Test: WNM ESS Disassociation Imminent
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_ess_disassoc_imminent 0.898813 2018-10-28 12:10:20.641968
passed all 1 test case(s)
2018-10-28 12:10:20 	./run-tests.py wnm_ess_disassoc_imminent_fail 
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START wnm_ess_disassoc_imminent_fail 1/1
Test: WNM ESS Disassociation Imminent failure
Starting AP wlan3
Connect STA wlan0 to AP
PASS wnm_ess_disassoc_imminent_fail 0.852755 2018-10-28 12:10:22.162744
passed all 1 test case(s)
2018-10-28 12:10:22 ./stop.sh
2018-10-28 12:10:23 ./start.sh channels=4
2018-10-28 12:10:24 ./stop.sh

--oP9at/Ymg5VWhwKB--
