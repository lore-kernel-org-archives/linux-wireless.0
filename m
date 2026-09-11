Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17144235BE2;
	Fri, 11 Sep 2026 03:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789096019; cv=none; b=UI0M/c3BgytlseaOUB+X8Y/VBS/l59NjQ3DtOX6MsvK1NoN3z8Z7mkK4SbCDCbbYVy5619JyLHS8RJk2nnu8nMqv0oa9zGyShKZFrXLhf0uACEifh4uB1Zk7ab8MK+Jb8A0EaqedgG2O7+vjFdTgmxaCHAppe4zgl0HInhJ8iGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789096019; c=relaxed/simple;
	bh=e3N52camSpbrbd9Lazc3PO5rOzbLbivpGj6w5lEHN4o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qxcRFFa35xGsXGdJisKIKhKfzzwkTzQT51CLpgNkjWZArjn5Kp251zHx5vQXPS87D7IxcyZDEYzJKGHFs1hN6XyJoQEeHh2vaWOAb6W0GiuvStWKAzShONkNRIXVR5rpt6l+6rkreQ+dDEz92CE6MW2CTxmZ4Di3Avj2IxMxFcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQrwlCke; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQrwlCke"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789096017; x=1820632017;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=e3N52camSpbrbd9Lazc3PO5rOzbLbivpGj6w5lEHN4o=;
  b=eQrwlCkeE9pvO1JxvAJ+m6Y58htFzSOpwNwXMRR1A0BHHMY+57mJuOn5
   ziYmnCUHRSBKmNcOvFXLiq44OubOrF2gfhB6pxmPvN6JYGR1XDcytRONC
   L2+ut/tiyyb3Rf3JFgqvgAI1lp7IP/wuMQnPziyzw5opfOtv1evL4VJ8P
   ckUQOCLY4GInHmBhpjIl7DCicJ4Esot2NIWiozbvDQFSl2eooWjtj1/ai
   CtRdN9/PhXnw2GxX0E9jR+g+P0xqoT3A7I5L9tr6Ql0S4LFSuvdoIhYI4
   If9iDOEgyTiTPb07wjiRgEjEZA5am/34bid6W/7J6QYMPunMfaNurcGJO
   w==;
X-CSE-ConnectionGUID: WYdW6fAQSI6bKHsoFnqsQw==
X-CSE-MsgGUID: jriaIVZFRnKP+58WC5hJXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89429442"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="89429442"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 20:06:56 -0700
X-CSE-ConnectionGUID: TRo74acOSVef9oko2DY/ZQ==
X-CSE-MsgGUID: fjFM+kLASb6uc+o2tBLw5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="273742228"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 20:06:55 -0700
Date: Fri, 11 Sep 2026 11:06:51 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, yi1.lai@intel.com
Subject: [linux-next:master] [wifi]  d25ba7909b:
 hwsim.uhr_mld_sae_single_link.fail
Message-ID: <202609110354.fc495fe8-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Hello,

kernel test robot noticed "hwsim.uhr_mld_sae_single_link.fail" on:

commit: d25ba7909b2781c827f8b2928f201307c3ad6e44 ("wifi: update UHR to Draf=
t_P802.11bn D1.5")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master c68a982815dcce5464e3bf2a31ac94f5146c04ca]

in testcase: hwsim
version: hwsim-x86_64-b9562516f-1_20260824
with following parameters:

	test: group-21

config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 16 threads Intel(R) Core(TM) i7-13620H (Raptor Lake) with 32G=
 memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202609110354.fc495fe8-lkp@intel.com

2026-09-10 10:26:26 ./run-tests.py uhr_mld_sae_single_link
DEV: wlan0: 02:00:00:00:00:00
DEV: wlan1: 02:00:00:00:01:00
DEV: wlan2: 02:00:00:00:02:00
APDEV: wlan3
APDEV: wlan4
START uhr_mld_sae_single_link 1/1
Test: UHR MLD AP with MLD client SAE H2E connection using single link
Adding link on: ifname=3Dwlan7
Connect STA wlan8 to AP
hostapd STATUS: {'state': 'ENABLED', 'phy': 'phy16', 'freq': '2412', 'num_s=
ta_non_erp': '0', 'num_sta_no_short_slot_time': '0', 'num_sta_no_short_prea=
mble': '0', 'olbc': '0', 'num_sta_ht_no_gf': '0', 'num_sta_no_ht': '0', 'nu=
m_sta_ht_20_mhz': '0', 'num_sta_ht40_intolerant': '0', 'olbc_ht': '0', 'ht_=
op_mode': '0x0', 'hw_mode': 'g', 'cac_time_seconds': '0', 'cac_time_left_se=
conds': 'N/A', 'channel': '1', 'edmg_enable': '0', 'edmg_channel': '0', 'se=
condary_channel': '0', 'ieee80211n': '1', 'ieee80211ac': '0', 'ieee80211ax'=
: '1', 'ieee80211be': '1', 'ieee80211bn': '1', 'beacon_int': '100', 'dtim_p=
eriod': '2', 'eht_oper_chwidth': '0', 'eht_oper_centr_freq_seg0_idx': '0', =
'num_links': '1', 'link_id': '0', 'link_addr': '02:00:00:db:32:cc', 'ap_mld=
_type': 'STR', 'he_oper_chwidth': '0', 'he_oper_centr_freq_seg0_idx': '0', =
'he_oper_centr_freq_seg1_idx': '0', 'ht_caps_info': '000c', 'ht_mcs_bitmask=
': 'ffff0000000000000000', 'supported_rates': '02 04 0b 16 0c 12 18 24 30 4=
8 60 6c', 'max_txpower': '20', 'bss[0]': 'wlan7', 'bssid[0]': '02:00:00:db:=
32:cc', 'ssid[0]': 'mld_ap_sae_single_link', 'num_sta[0]': '1', 'mld_addr[0=
]': '02:00:00:00:10:00', 'mld_id[0]': '0', 'mld_link_id[0]': '0'}
hostapd STA: {'addr': '02:00:00:00:11:00', 'flags': '[AUTH][ASSOC][AUTHORIZ=
ED][SHORT_PREAMBLE][WMM][MFP][HT][HE][EHT]', 'aid': '1', 'capability': '0x4=
30', 'listen_interval': '5', 'supported_rates': '02 04 0b 16 0c 12 18 24 30=
 48 60 6c', 'timeout_next': 'NULLFUNC POLL', 'auth_alg': '3', 'dot11RSNASta=
tsSTAAddress': '02:00:00:00:11:00', 'dot11RSNAStatsVersion': '1', 'dot11RSN=
AStatsSelectedPairwiseCipher': '00-0f-ac-4', 'dot11RSNAStatsTKIPLocalMICFai=
lures': '0', 'dot11RSNAStatsTKIPRemoteMICFailures': '0', 'wpa': '2', 'AKMSu=
iteSelector': '00-0f-ac-8', 'hostapdWPAPTKState': '11', 'hostapdWPAPTKGroup=
State': '0', 'hostapdMFPR': '1', 'rx_packets': '6', 'tx_packets': '5', 'rx_=
bytes': '627', 'tx_bytes': '916', 'inactive_msec': '7', 'signal': '-50', 'r=
x_rate_info': '10', 'tx_rate_info': '0', 'ht_mcs_bitmask': 'ffff00000000000=
00000', 'connected_time': '0', 'sae_group': '19', 'sae_rejected_groups': ''=
, 'supp_op_classes': '5151525354737475767778797a7b7c7d7e7f8081008280', 'he_=
capab': '0178c81a400002bfce0000000000000000fafffaff', 'eht_capab': '07007c0=
000feffff0f01008888880000', 'ht_caps_info': '0x13fe', 'ext_capab': '04004a0=
2014000400001', 'peer_addr[0]': '16:ef:b1:22:6a:65', 'max_simul_links': '0'}
valid_links=3D0x1

active_links=3D0x1

hostapd STATUS: {'state': 'ENABLED', 'phy': 'phy16', 'freq': '2412', 'num_s=
ta_non_erp': '0', 'num_sta_no_short_slot_time': '0', 'num_sta_no_short_prea=
mble': '0', 'olbc': '0', 'num_sta_ht_no_gf': '0', 'num_sta_no_ht': '0', 'nu=
m_sta_ht_20_mhz': '0', 'num_sta_ht40_intolerant': '0', 'olbc_ht': '0', 'ht_=
op_mode': '0x0', 'hw_mode': 'g', 'cac_time_seconds': '0', 'cac_time_left_se=
conds': 'N/A', 'channel': '1', 'edmg_enable': '0', 'edmg_channel': '0', 'se=
condary_channel': '0', 'ieee80211n': '1', 'ieee80211ac': '0', 'ieee80211ax'=
: '1', 'ieee80211be': '1', 'ieee80211bn': '1', 'beacon_int': '100', 'dtim_p=
eriod': '2', 'eht_oper_chwidth': '0', 'eht_oper_centr_freq_seg0_idx': '0', =
'num_links': '1', 'link_id': '0', 'link_addr': '02:00:00:db:32:cc', 'ap_mld=
_type': 'STR', 'he_oper_chwidth': '0', 'he_oper_centr_freq_seg0_idx': '0', =
'he_oper_centr_freq_seg1_idx': '0', 'ht_caps_info': '000c', 'ht_mcs_bitmask=
': 'ffff0000000000000000', 'supported_rates': '02 04 0b 16 0c 12 18 24 30 4=
8 60 6c', 'max_txpower': '20', 'bss[0]': 'wlan7', 'bssid[0]': '02:00:00:db:=
32:cc', 'ssid[0]': 'mld_ap_sae_single_link', 'num_sta[0]': '1', 'mld_addr[0=
]': '02:00:00:00:10:00', 'mld_id[0]': '0', 'mld_link_id[0]': '0'}
hostapd STA: {'addr': '02:00:00:00:11:00', 'flags': '[AUTH][ASSOC][AUTHORIZ=
ED][SHORT_PREAMBLE][WMM][MFP][HT][HE][EHT]', 'aid': '1', 'capability': '0x4=
30', 'listen_interval': '5', 'supported_rates': '02 04 0b 16 0c 12 18 24 30=
 48 60 6c', 'timeout_next': 'NULLFUNC POLL', 'auth_alg': '3', 'dot11RSNASta=
tsSTAAddress': '02:00:00:00:11:00', 'dot11RSNAStatsVersion': '1', 'dot11RSN=
AStatsSelectedPairwiseCipher': '00-0f-ac-4', 'dot11RSNAStatsTKIPLocalMICFai=
lures': '0', 'dot11RSNAStatsTKIPRemoteMICFailures': '0', 'wpa': '2', 'AKMSu=
iteSelector': '00-0f-ac-8', 'hostapdWPAPTKState': '11', 'hostapdWPAPTKGroup=
State': '0', 'hostapdMFPR': '1', 'rx_packets': '7', 'tx_packets': '5', 'rx_=
bytes': '753', 'tx_bytes': '916', 'inactive_msec': '112', 'signal': '-50', =
'rx_rate_info': '10', 'tx_rate_info': '0', 'ht_mcs_bitmask': 'ffff000000000=
0000000', 'connected_time': '0', 'sae_group': '19', 'sae_rejected_groups': =
'', 'supp_op_classes': '5151525354737475767778797a7b7c7d7e7f8081008280', 'h=
e_capab': '0178c81a400002bfce0000000000000000fafffaff', 'eht_capab': '07007=
c0000feffff0f01008888880000', 'ht_caps_info': '0x13fe', 'ext_capab': '04004=
a02014000400001', 'peer_addr[0]': '16:ef:b1:22:6a:65', 'max_simul_links': '=
0'}
Exception during test execution: Missing STA flag: UHR
Traceback (most recent call last):
  File "/lkp/benchmarks/hwsim/tests/hwsim/./run-tests.py", line 635, in main
    t(dev, apdev)
    ~^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_uhr.py", line 180, in test_u=
hr_mld_sae_single_link
    run_uhr_mld_sae_single_link(dev, apdev)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_uhr.py", line 174, in run_uh=
r_mld_sae_single_link
    uhr_verify_status(wpas, hapd0, is_ht=3DTrue)
    ~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/lkp/benchmarks/hwsim/tests/hwsim/test_uhr.py", line 60, in uhr_ver=
ify_status
    raise Exception("Missing STA flag: UHR")
Exception: Missing STA flag: UHR
FAIL uhr_mld_sae_single_link 0.42002 2026-09-10 10:26:27.104099
passed 0 test case(s)
skipped 0 test case(s)
failed tests: uhr_mld_sae_single_link

The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260911/202609110354.fc495fe8-lkp@=
intel.com

--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

