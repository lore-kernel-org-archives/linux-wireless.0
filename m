Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11261 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbeHPARQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 20:17:16 -0400
Date: Thu, 16 Aug 2018 05:23:04 +0800
From: kbuild test robot <lkp@intel.com>
To: Wen Gong <wgong@codeaurora.org>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: support NET_DETECT WoWLAN feature
Message-ID: <201808160528.6RYbuvHS%fengguang.wu@intel.com> (sfid-20180815_232328_744332_1E9EE4CD)
References: <1534214568-25226-1-git-send-email-wgong@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534214568-25226-1-git-send-email-wgong@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ath6kl/ath-next]
[also build test WARNING on v4.18 next-20180814]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Wen-Gong/ath10k-support-NET_DETECT-WoWLAN-feature/20180814-174257
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath10k/wow.c:321:3-6: alloc with no test, possible model on line 324

vim +321 drivers/net/wireless/ath/ath10k/wow.c

   282	
   283	static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
   284					      struct cfg80211_wowlan *wowlan)
   285	{
   286		int ret, i;
   287		unsigned long wow_mask = 0;
   288		struct ath10k *ar = arvif->ar;
   289		const struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
   290		int pattern_id = 0;
   291	
   292		/* Setup requested WOW features */
   293		switch (arvif->vdev_type) {
   294		case WMI_VDEV_TYPE_IBSS:
   295			__set_bit(WOW_BEACON_EVENT, &wow_mask);
   296			 /* fall through */
   297		case WMI_VDEV_TYPE_AP:
   298			__set_bit(WOW_DEAUTH_RECVD_EVENT, &wow_mask);
   299			__set_bit(WOW_DISASSOC_RECVD_EVENT, &wow_mask);
   300			__set_bit(WOW_PROBE_REQ_WPS_IE_EVENT, &wow_mask);
   301			__set_bit(WOW_AUTH_REQ_EVENT, &wow_mask);
   302			__set_bit(WOW_ASSOC_REQ_EVENT, &wow_mask);
   303			__set_bit(WOW_HTT_EVENT, &wow_mask);
   304			__set_bit(WOW_RA_MATCH_EVENT, &wow_mask);
   305			break;
   306		case WMI_VDEV_TYPE_STA:
   307			if (wowlan->disconnect) {
   308				__set_bit(WOW_DEAUTH_RECVD_EVENT, &wow_mask);
   309				__set_bit(WOW_DISASSOC_RECVD_EVENT, &wow_mask);
   310				__set_bit(WOW_BMISS_EVENT, &wow_mask);
   311				__set_bit(WOW_CSA_IE_EVENT, &wow_mask);
   312			}
   313	
   314			if (wowlan->magic_pkt)
   315				__set_bit(WOW_MAGIC_PKT_RECVD_EVENT, &wow_mask);
   316	
   317			if (wowlan->nd_config) {
   318				struct wmi_pno_scan_req *pno;
   319				int ret;
   320	
 > 321				pno = kzalloc(sizeof(*pno), GFP_KERNEL);
   322				ar->nlo_enabled = true;
   323	
 > 324				ret = ath10k_wmi_pno_check(ar, arvif->vdev_id,
   325							   wowlan->nd_config, pno);
   326				if (!ret) {
   327					ath10k_wmi_wow_config_pno(ar, arvif->vdev_id, pno);
   328					__set_bit(WOW_NLO_DETECTED_EVENT, &wow_mask);
   329				}
   330	
   331				kfree(pno);
   332			}
   333			break;
   334		default:
   335			break;
   336		}
   337	
   338		for (i = 0; i < wowlan->n_patterns; i++) {
   339			u8 bitmask[WOW_MAX_PATTERN_SIZE] = {};
   340			u8 ath_pattern[WOW_MAX_PATTERN_SIZE] = {};
   341			u8 ath_bitmask[WOW_MAX_PATTERN_SIZE] = {};
   342			struct cfg80211_pkt_pattern new_pattern = {};
   343			struct cfg80211_pkt_pattern old_pattern = patterns[i];
   344			int j;
   345	
   346			new_pattern.pattern = ath_pattern;
   347			new_pattern.mask = ath_bitmask;
   348			if (patterns[i].pattern_len > WOW_MAX_PATTERN_SIZE)
   349				continue;
   350			/* convert bytemask to bitmask */
   351			for (j = 0; j < patterns[i].pattern_len; j++)
   352				if (patterns[i].mask[j / 8] & BIT(j % 8))
   353					bitmask[j] = 0xff;
   354			old_pattern.mask = bitmask;
   355			new_pattern = old_pattern;
   356	
   357			if (ar->wmi.rx_decap_mode == ATH10K_HW_TXRX_NATIVE_WIFI) {
   358				if (patterns[i].pkt_offset < ETH_HLEN)
   359					ath10k_wow_convert_8023_to_80211(&new_pattern,
   360									 &old_pattern);
   361				else
   362					new_pattern.pkt_offset += WOW_HDR_LEN - ETH_HLEN;
   363			}
   364	
   365			if (WARN_ON(new_pattern.pattern_len > WOW_MAX_PATTERN_SIZE))
   366				return -EINVAL;
   367	
   368			ret = ath10k_wmi_wow_add_pattern(ar, arvif->vdev_id,
   369							 pattern_id,
   370							 new_pattern.pattern,
   371							 new_pattern.mask,
   372							 new_pattern.pattern_len,
   373							 new_pattern.pkt_offset);
   374			if (ret) {
   375				ath10k_warn(ar, "failed to add pattern %i to vdev %i: %d\n",
   376					    pattern_id,
   377					    arvif->vdev_id, ret);
   378				return ret;
   379			}
   380	
   381			pattern_id++;
   382			__set_bit(WOW_PATTERN_MATCH_EVENT, &wow_mask);
   383		}
   384	
   385		for (i = 0; i < WOW_EVENT_MAX; i++) {
   386			if (!test_bit(i, &wow_mask))
   387				continue;
   388			ret = ath10k_wmi_wow_add_wakeup_event(ar, arvif->vdev_id, i, 1);
   389			if (ret) {
   390				ath10k_warn(ar, "failed to enable wakeup event %s on vdev %i: %d\n",
   391					    wow_wakeup_event(i), arvif->vdev_id, ret);
   392				return ret;
   393			}
   394		}
   395	
   396		return 0;
   397	}
   398	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
