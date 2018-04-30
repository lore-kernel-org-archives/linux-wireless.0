Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49664 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbeD3MpT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 08:45:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: Franky Lin <franky.lin@broadcom.com>, kbuild-all@01.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [wireless-drivers-next:master 62/66] drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2740:49: sparse: Using plain integer as NULL pointer
References: <201804302035.O3QSzOim%fengguang.wu@intel.com>
Date: Mon, 30 Apr 2018 15:45:14 +0300
In-Reply-To: <201804302035.O3QSzOim%fengguang.wu@intel.com> (kbuild test
        robot's message of "Mon, 30 Apr 2018 20:39:37 +0800")
Message-ID: <878t94278l.fsf@codeaurora.org> (sfid-20180430_144524_124492_E3AC5981)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding linux-wireless)

kbuild test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> head:   f56324baf329bc9362a52ad77a4a1a0f3356d1bc
> commit: 7742fce4c007141617dab9bcb90034b3c0fe2347 [62/66] brcmfmac: reports boottime_ns while informing bss
> reproduce:
>         # apt-get install sparse
>         git checkout 7742fce4c007141617dab9bcb90034b3c0fe2347
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1379:20: sparse: expression using sizeof(void)
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1968:20: sparse: expression using sizeof(void)
>>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2740:49:
>> sparse: Using plain integer as NULL pointer
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:6488:34: sparse: expression using sizeof(void)
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:6488:34: sparse: expression using sizeof(void)
>
> vim +2740 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>
>   2726	
>   2727	static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
>   2728					   struct brcmf_bss_info_le *bi)
>   2729	{
>   2730		struct wiphy *wiphy = cfg_to_wiphy(cfg);
>   2731		struct cfg80211_bss *bss;
>   2732		struct ieee80211_supported_band *band;
>   2733		struct brcmu_chan ch;
>   2734		u16 channel;
>   2735		u32 freq;
>   2736		u16 notify_capability;
>   2737		u16 notify_interval;
>   2738		u8 *notify_ie;
>   2739		size_t notify_ielen;
>> 2740		struct cfg80211_inform_bss bss_data = { 0 };
>   2741	
>   2742		if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
>   2743			brcmf_err("Bss info is larger than buffer. Discarding\n");
>   2744			return 0;
>   2745		}
>   2746	
>   2747		if (!bi->ctl_ch) {
>   2748			ch.chspec = le16_to_cpu(bi->chanspec);
>   2749			cfg->d11inf.decchspec(&ch);
>   2750			bi->ctl_ch = ch.control_ch_num;
>   2751		}
>   2752		channel = bi->ctl_ch;
>   2753	
>   2754		if (channel <= CH_MAX_2G_CHANNEL)
>   2755			band = wiphy->bands[NL80211_BAND_2GHZ];
>   2756		else
>   2757			band = wiphy->bands[NL80211_BAND_5GHZ];
>   2758	
>   2759		freq = ieee80211_channel_to_frequency(channel, band->band);
>   2760		bss_data.chan = ieee80211_get_channel(wiphy, freq);
>   2761		bss_data.scan_width = NL80211_BSS_CHAN_WIDTH_20;
>   2762		bss_data.boottime_ns = ktime_to_ns(ktime_get_boottime());
>   2763	
>   2764		notify_capability = le16_to_cpu(bi->capability);
>   2765		notify_interval = le16_to_cpu(bi->beacon_period);
>   2766		notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
>   2767		notify_ielen = le32_to_cpu(bi->ie_length);
>   2768		bss_data.signal = (s16)le16_to_cpu(bi->RSSI) * 100;
>   2769	
>   2770		brcmf_dbg(CONN, "bssid: %pM\n", bi->BSSID);
>   2771		brcmf_dbg(CONN, "Channel: %d(%d)\n", channel, freq);
>   2772		brcmf_dbg(CONN, "Capability: %X\n", notify_capability);
>   2773		brcmf_dbg(CONN, "Beacon interval: %d\n", notify_interval);
>   2774		brcmf_dbg(CONN, "Signal: %d\n", bss_data.signal);
>   2775	
>   2776		bss = cfg80211_inform_bss_data(wiphy, &bss_data,
>   2777					       CFG80211_BSS_FTYPE_UNKNOWN,
>   2778					       (const u8 *)bi->BSSID,
>   2779					       0, notify_capability,
>   2780					       notify_interval, notify_ie,
>   2781					       notify_ielen, GFP_KERNEL);
>   2782	
>   2783		if (!bss)
>   2784			return -ENOMEM;
>   2785	
>   2786		cfg80211_put_bss(wiphy, bss);
>   2787	
>   2788		return 0;
>   2789	}
>   2790	
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

-- 
Kalle Valo
