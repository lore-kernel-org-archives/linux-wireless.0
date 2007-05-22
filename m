Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:5694 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756657AbXEVXNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 19:13:49 -0400
Message-ID: <465365B3.4090408@linux.intel.com>
Date: Tue, 22 May 2007 14:50:43 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH v3]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com>
In-Reply-To: <464B7B7C.5080800@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An updated full patch (v3) to add the driver is available at:
	
	http://intellinuxwireless.org/iwlwifi/0001-v3-Add-iwlwifi-wireless-drivers.patch

And if interested, here is the diff between the first version and this version:

	http://intellinuxwireless.org/iwlwifi/iwlwifi-v1_to_v3.patch

The short log since the first submission:

Hong Liu (8):
      remove param_channel module parameter
      rename queueId to queue in iwl_hw_txq_ctx_stop
      remove unused callback reset set_multicast_list
      remove CONFIG_IWLWIFI_MONITOR and CONFIG_IWLWIFI_RADIOTAP in iwl4965_handle_data_packet
      set RX_FLAG_RADIOTAP in iwl_handle_data_packet_monitor
      ieee80211chan2mhz is defined in ieee80211_radiotap.h
      reformat iwl4965_rx_reply_rx
      remove unnecessary in_interrupt() checks according to the ieee80211_ops comments

James Ketrenos (38):
      Fixed Kconfig help indentation to be {tab}{sp}{sp}
      Fixed indentation of non-case labels
      Updated some function kernel-doc info; removed usage of /** for non kdoc
      Fixed up some usage of magic numbers to #defines, etc.
      Removed is_broadast_ether_addr redundancy with is_multicast_ether_addr
      Updated block comments to conform to kernel style
      Removed // style comments
      Fixed indentation in is_duplicate_packet
      Comment typo adwances -> advances
      Whitespace, some 80-column, kernel doc, and other non-functional changes
      Trailing whitespace cleanup
      Fix > 80 column problems in .c files (still have to do it in .h files)
      Removed usage of IWL_NOP and IWL_NOP_RET
      Converted existing comment blocks into kernel-doc format
      Add missing linebreak in pci_driver declrataion for suspend/resume
      Removed inline on non-trivial (>~3 lines) functions
      Modified tune sysfs attribute to show/store a single value.
      Removed unused static function iwl4965_toggle_antennta from iwl-4965.c
      Change show_power_level to not prefix text before the power_level attr.
      Fixed trailing whitespace (again)
      Set check to BUILD_BUG_ON(sizeof(priv->eeprom) != IWL_EEPROM_IMAGE_SIZE)
      u16, u32, u64 -> __le16, __le32, __le64 in iwl-4965-hw.h (hardware/uCode API
      Moved struct iwl_txpower_comp_entry out of iwl-4965-hw.h
      Fixed iwl4965_get_dma_hi_address to work on all architectures
      Whitespace fixups.
      Fixed printk() w/out KERN_ level
      Removed several unnecessary variable initializers.
      Whitespace and added line to todo
      Added comments to BUG_ON code, and removed two BUG_ONs
      Changed iwl_send_cmd BUG_ONs to printk errors and return -EINVAL.
      Fixed build for CONFIG_IWL4965=m
      Removed all direct bitfield usage
      Removed several deprecated CFG_ and CAP_ declarations and use
      Removed CONFIG_IWLWIFI_QOS blocks until they are buildable.
      Replace flush_scheduled_work in d_stop with flush_workqueue
      Removed Tx cmd message spam on iwl4965
      Fixed a couple > 80 column width lines
      Set CONFIG_IWL4965 to default to =m.  Disabled =y configurations.

Yi Zhu (1):
      Fix volatile usage
