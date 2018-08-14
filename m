Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:58757 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731985AbeHNQxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 12:53:18 -0400
Date: Tue, 14 Aug 2018 22:05:06 +0800
From: kbuild test robot <lkp@intel.com>
To: Wen Gong <wgong@codeaurora.org>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: support NET_DETECT WoWLAN feature
Message-ID: <201808142153.ufdfzApi%fengguang.wu@intel.com> (sfid-20180814_160603_532472_9CF2132C)
References: <1534214568-25226-1-git-send-email-wgong@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534214568-25226-1-git-send-email-wgong@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ath6kl/ath-next]
[also build test WARNING on v4.18 next-20180813]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Wen-Gong/ath10k-support-NET_DETECT-WoWLAN-feature/20180814-174257
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/slab.h:631:13: sparse: undefined identifier '__builtin_mul_overflow'
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:2700:19: sparse: expression using sizeof(void)
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3461:30: sparse: expression using sizeof(void)
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3464:33: sparse: expression using sizeof(void)
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3477:22: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] vdev_id @@    got unsignerestricted __le32 [usertype] vdev_id @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3477:22:    expected restricted __le32 [usertype] vdev_id
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3477:22:    got unsigned char [unsigned] [usertype] vdev_id
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3478:20: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] flags @@    got e] flags @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3478:20:    expected restricted __le32 [usertype] flags
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3478:20:    got int
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3481:32: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] active_dwell_time @@    got unsignrestricted __le32 [usertype] active_dwell_time @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3481:32:    expected restricted __le32 [usertype] active_dwell_time
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3481:32:    got unsigned int [unsigned] [usertype] active_max_time
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3482:33: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] passive_dwell_time @@    got unsignrestricted __le32 [usertype] passive_dwell_time @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3482:33:    expected restricted __le32 [usertype] passive_dwell_time
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3482:33:    got unsigned int [unsigned] [usertype] passive_max_time
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3485:28: sparse: invalid assignment: |=
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3485:28:    left side has type restricted __le32
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3485:28:    right side has type int
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3487:31: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] fast_scan_period @@    got unsignrestricted __le32 [usertype] fast_scan_period @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3487:31:    expected restricted __le32 [usertype] fast_scan_period
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3487:31:    got unsigned int [unsigned] [usertype] fast_scan_period
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3488:31: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] slow_scan_period @@    got unsignrestricted __le32 [usertype] slow_scan_period @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3488:31:    expected restricted __le32 [usertype] slow_scan_period
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3488:31:    got unsigned int [unsigned] [usertype] slow_scan_period
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3489:35: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] fast_scan_max_cycles @@    got unsignerestricted __le32 [usertype] fast_scan_max_cycles @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3489:35:    expected restricted __le32 [usertype] fast_scan_max_cycles
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3489:35:    got unsigned char [unsigned] [usertype] fast_scan_max_cycles
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3490:31: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] delay_start_time @@    got unsignrestricted __le32 [usertype] delay_start_time @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3490:31:    expected restricted __le32 [usertype] delay_start_time
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3490:31:    got unsigned int [unsigned] [usertype] delay_start_time
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3492:28: sparse: invalid assignment: |=
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3492:28:    left side has type restricted __le32
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3492:28:    right side has type int
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3501:28: sparse: expression using sizeof(void)
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3501:26: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] no_of_ssids @@    got e] no_of_ssids @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3501:26:    expected restricted __le32 [usertype] no_of_ssids
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3501:26:    got int
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3504:20: sparse: restricted __le32 degrades to integer
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3509:28: sparse: restricted __le32 degrades to integer
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3515:40: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] valid @@    got e] valid @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3515:40:    expected restricted __le32 [usertype] valid
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3515:40:    got int
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3517:17: sparse: incorrect type in argument 3 (different base types) @@    expected unsigned long [unsigned] [usertype] len @@    got d long [unsigned] [usertype] len @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3517:17:    expected unsigned long [unsigned] [usertype] len
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3517:17:    got restricted __le32 [usertype] ssid_len
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3524:53: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] valid @@    got e] valid @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3524:53:    expected restricted __le32 [usertype] valid
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3524:53:    got int
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3525:52: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] rssi @@    got signed int [signed] [urestricted __le32 [usertype] rssi @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3525:52:    expected restricted __le32 [usertype] rssi
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3525:52:    got signed int [signed] [usertype] [explicitly-signed] rssi_threshold
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3528:49: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] valid @@    got e] valid @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3528:49:    expected restricted __le32 [usertype] valid
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3528:49:    got int
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3529:57: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] bcast_nw_type @@    got unsignrestricted __le32 [usertype] bcast_nw_type @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3529:57:    expected restricted __le32 [usertype] bcast_nw_type
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3529:57:    got unsigned int [unsigned] [usertype] bcast_nw_type
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3533:19: sparse: restricted __le32 degrades to integer
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3536:32: sparse: expression using sizeof(void)
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3536:30: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] num_of_channels @@    got e] num_of_channels @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3536:30:    expected restricted __le32 [usertype] num_of_channels
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3536:30:    got int
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3541:20: sparse: restricted __le32 degrades to integer
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3545:28: sparse: restricted __le32 degrades to integer
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3580:20: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] flags @@    got e] flags @@
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3580:20:    expected restricted __le32 [usertype] flags
   drivers/net/wireless/ath/ath10k/wmi-tlv.c:3580:20:    got int
   include/linux/slab.h:631:13: sparse: call with no type!
--
>> drivers/net/wireless/ath/ath10k/wow.c:207:50: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] ssid_len @@    got unsignerestricted __le32 [usertype] ssid_len @@
   drivers/net/wireless/ath/ath10k/wow.c:207:50:    expected restricted __le32 [usertype] ssid_len
   drivers/net/wireless/ath/ath10k/wow.c:207:50:    got unsigned char [unsigned] [usertype] ssid_len
>> drivers/net/wireless/ath/ath10k/wow.c:211:44: sparse: restricted __le32 degrades to integer
   drivers/net/wireless/ath/ath10k/wow.c:242:52: sparse: restricted __le32 degrades to integer
>> drivers/net/wireless/ath/ath10k/wow.c:246:56: sparse: incorrect type in argument 3 (different base types) @@    expected unsigned long [unsigned] [usertype] <noident> @@    got d long [unsigned] [usertype] <noident> @@
   drivers/net/wireless/ath/ath10k/wow.c:246:56:    expected unsigned long [unsigned] [usertype] <noident>
   drivers/net/wireless/ath/ath10k/wow.c:246:56:    got restricted __le32 [usertype] ssid_len
   drivers/net/wireless/ath/ath10k/wow.c: In function 'ath10k_wow_op_resume':
   drivers/net/wireless/ath/ath10k/wow.c:451:6: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
      if (ret) {
         ^
   drivers/net/wireless/ath/ath10k/wow.c:421:6: note: 'ret' was declared here
     int ret;
         ^~~

vim +3477 drivers/net/wireless/ath/ath10k/wmi-tlv.c

  3437	
  3438	/* Request FW to start PNO operation */
  3439	static struct sk_buff *ath10k_wmi_tlv_op_gen_config_pno_start
  3440					(struct ath10k *ar,
  3441					u32 vdev_id,
  3442					struct wmi_pno_scan_req *pno)
  3443	{
  3444		struct wmi_tlv_wow_nlo_config_cmd *cmd;
  3445		struct wmi_tlv *tlv;
  3446		struct sk_buff *skb;
  3447		struct nlo_configured_parameters *nlo_list;
  3448		u32 *channel_list;
  3449		void *ptr;
  3450		size_t len;
  3451		u32 i;
  3452	
  3453		len = sizeof(*tlv) + sizeof(*cmd) +
  3454		      sizeof(*tlv) +
  3455		      /* TLV place holder for array of structures
  3456		       * nlo_configured_parameters(nlo_list)
  3457		       */
  3458		      sizeof(*tlv);
  3459		      /* TLV place holder for array of uint32 channel_list */
  3460	
  3461		len += sizeof(u32) * min_t(u8, pno->a_networks[0].channel_count,
  3462					   WMI_NLO_MAX_CHAN);
  3463		len += sizeof(struct nlo_configured_parameters) *
  3464					min_t(u8, pno->uc_networks_count, WMI_NLO_MAX_SSIDS);
  3465	
  3466		skb = ath10k_wmi_alloc_skb(ar, len);
  3467		if (!skb)
  3468			return ERR_PTR(-ENOMEM);
  3469	
  3470		ptr = (void *)skb->data;
  3471		tlv = ptr;
  3472		tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_NLO_CONFIG_CMD);
  3473		tlv->len = __cpu_to_le16(sizeof(*cmd));
  3474		cmd = (void *)tlv->value;
  3475	
  3476		/* wmi_tlv_wow_nlo_config_cmd parameters*/
> 3477		cmd->vdev_id = pno->vdev_id;
> 3478		cmd->flags = WMI_NLO_CONFIG_START | WMI_NLO_CONFIG_SSID_HIDE_EN;
  3479	
  3480		/* Current FW does not support min-max range for dwell time */
> 3481		cmd->active_dwell_time = pno->active_max_time;
> 3482		cmd->passive_dwell_time = pno->passive_max_time;
  3483	
  3484		if (pno->do_passive_scan)
> 3485			cmd->flags |= WMI_NLO_CONFIG_SCAN_PASSIVE;
  3486		/* Copy scan interval */
> 3487		cmd->fast_scan_period = pno->fast_scan_period;
> 3488		cmd->slow_scan_period = pno->slow_scan_period;
> 3489		cmd->fast_scan_max_cycles = pno->fast_scan_max_cycles;
> 3490		cmd->delay_start_time = pno->delay_start_time;
  3491		if (pno->enable_pno_scan_randomization) {
> 3492			cmd->flags |= WMI_NLO_CONFIG_SPOOFED_MAC_IN_PROBE_REQ |
  3493					WMI_NLO_CONFIG_RANDOM_SEQ_NO_IN_PROBE_REQ;
  3494			ether_addr_copy(cmd->mac_addr.addr, pno->mac_addr);
  3495			ether_addr_copy(cmd->mac_mask.addr, pno->mac_addr_mask);
  3496		}
  3497		ptr += sizeof(*tlv);
  3498		ptr += sizeof(*cmd);
  3499	
  3500		/* nlo_configured_parameters(nlo_list) */
> 3501		cmd->no_of_ssids = min_t(u8, pno->uc_networks_count, WMI_NLO_MAX_SSIDS);
  3502		tlv = ptr;
  3503		tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
> 3504		tlv->len = __cpu_to_le16
  3505			(cmd->no_of_ssids * sizeof(struct nlo_configured_parameters));
  3506	
  3507		ptr += sizeof(*tlv);
  3508		nlo_list = ptr;
  3509		for (i = 0; i < cmd->no_of_ssids; i++) {
  3510			tlv = (struct wmi_tlv *)(&nlo_list[i].tlv_header);
  3511			tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_BYTE);
  3512			tlv->len = __cpu_to_le16
  3513				(sizeof(struct nlo_configured_parameters) - sizeof(*tlv));
  3514			/* Copy ssid and it's length */
> 3515			nlo_list[i].ssid.valid = true;
  3516			nlo_list[i].ssid.ssid.ssid_len = pno->a_networks[i].ssid.ssid_len;
> 3517			memcpy(nlo_list[i].ssid.ssid.ssid,
  3518			       pno->a_networks[i].ssid.ssid,
  3519			       nlo_list[i].ssid.ssid.ssid_len);
  3520	
  3521			/* Copy rssi threshold */
  3522			if (pno->a_networks[i].rssi_threshold &&
  3523			    pno->a_networks[i].rssi_threshold > -300) {
> 3524				nlo_list[i].rssi_cond.valid = true;
> 3525				nlo_list[i].rssi_cond.rssi = pno->a_networks[i].rssi_threshold;
  3526			}
  3527	
  3528			nlo_list[i].bcast_nw_type.valid = true;
> 3529			nlo_list[i].bcast_nw_type.bcast_nw_type =
  3530				pno->a_networks[i].bcast_nw_type;
  3531		}
  3532	
  3533		ptr += cmd->no_of_ssids * sizeof(struct nlo_configured_parameters);
  3534	
  3535		/* Copy channel info */
> 3536		cmd->num_of_channels = min_t(u8, pno->a_networks[0].channel_count,
  3537					     WMI_NLO_MAX_CHAN);
  3538	
  3539		tlv = ptr;
  3540		tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_UINT32);
  3541		tlv->len = __cpu_to_le16(cmd->num_of_channels * sizeof(u_int32_t));
  3542		ptr += sizeof(*tlv);
  3543	
  3544		channel_list = (u32 *)ptr;
  3545		for (i = 0; i < cmd->num_of_channels; i++)
  3546			channel_list[i] = pno->a_networks[0].channels[i];
  3547	
  3548		ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv start pno config vdev_id %d\n", vdev_id);
  3549		return skb;
  3550	}
  3551	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
