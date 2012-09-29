Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27291 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030298Ab2I2BUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 21:20:25 -0400
Date: Sat, 29 Sep 2012 09:20:55 +0800
From: Yuanhan Liu <yuanhan.liu@intel.com>
To: Hante Meuleman <meuleman@broadcom.com>
Cc: wfg@linux.intel.com, Yuanhan Liu <yuanhan.liu@intel.com>,
	kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [wireless-testing:master 229/238]
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:4185:2: warning:
 format '%d' expects argument of type 'int', but argument 4 has type 'size_t'
Message-ID: <20120929012055.GF29576@yliu-dev.sh.intel.com> (sfid-20120929_032031_257422_9C5E0708)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hante,

FYI, there are new compile warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git master
head:   96df9f3dca2428ac1e0b46d378b6f68ff64db67b
commit: 1a87334239757b69eb9885979c32bbf871b3ec88 [229/238] brcmfmac: add hostap supoort.
config: powerpc-allmodconfig

All warnings:

drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c: In function 'brcmf_cfg80211_start_ap':
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:4185:2: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' [-Wformat]

vim +4185 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c

1a873342 (Hante Meuleman 2012-09-27  4169) 			struct cfg80211_ap_settings *settings)
1a873342 (Hante Meuleman 2012-09-27  4170) {
1a873342 (Hante Meuleman 2012-09-27  4171) 	s32 ie_offset;
1a873342 (Hante Meuleman 2012-09-27  4172) 	struct brcmf_tlv *ssid_ie;
1a873342 (Hante Meuleman 2012-09-27  4173) 	struct brcmf_ssid_le ssid_le;
1a873342 (Hante Meuleman 2012-09-27  4174) 	s32 ioctl_value;
1a873342 (Hante Meuleman 2012-09-27  4175) 	s32 err = -EPERM;
1a873342 (Hante Meuleman 2012-09-27  4176) 	struct brcmf_tlv *rsn_ie;
1a873342 (Hante Meuleman 2012-09-27  4177) 	struct brcmf_vs_tlv *wpa_ie;
1a873342 (Hante Meuleman 2012-09-27  4178) 	struct brcmf_join_params join_params;
1a873342 (Hante Meuleman 2012-09-27  4179) 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
1a873342 (Hante Meuleman 2012-09-27  4180) 	s32 bssidx = 0;
1a873342 (Hante Meuleman 2012-09-27  4181) 
1a873342 (Hante Meuleman 2012-09-27  4182) 	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
1a873342 (Hante Meuleman 2012-09-27  4183) 		 settings->channel_type, settings->beacon_interval,
1a873342 (Hante Meuleman 2012-09-27  4184) 		 settings->dtim_period);
1a873342 (Hante Meuleman 2012-09-27 @4185) 	WL_TRACE("ssid=%s(%d), auth_type=%d, inactivity_timeout=%d\n",
1a873342 (Hante Meuleman 2012-09-27  4186) 		 settings->ssid, settings->ssid_len, settings->auth_type,
1a873342 (Hante Meuleman 2012-09-27  4187) 		 settings->inactivity_timeout);
1a873342 (Hante Meuleman 2012-09-27  4188) 
1a873342 (Hante Meuleman 2012-09-27  4189) 	if (!test_bit(WL_STATUS_AP_CREATING, &cfg_priv->status)) {
1a873342 (Hante Meuleman 2012-09-27  4190) 		WL_ERR("Not in AP creation mode\n");
1a873342 (Hante Meuleman 2012-09-27  4191) 		return -EPERM;
1a873342 (Hante Meuleman 2012-09-27  4192) 	}
1a873342 (Hante Meuleman 2012-09-27  4193) 

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu, Yuanhan Liu                              Intel Corporation
