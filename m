Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbbJEJxJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 05:53:09 -0400
Date: Mon, 5 Oct 2015 17:52:00 +0800
From: kbuild test robot <lkp@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
	dimitrysh@google.com
Subject: Re: [PATCH] nl80211: allow BSS data to include CLOCK_BOOTTIME
 timestamp
Message-ID: <201510051729.3ahBWuwE%fengguang.wu@intel.com> (sfid-20151005_115313_634912_3856E88F)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <1444037643-22359-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dmitry,

[auto build test WARNING on v4.3-rc4 -- if it's inappropriate base, please ignore]

reproduce: make htmldocs

All warnings (new ones prefixed by >>):

>> include/net/cfg80211.h:3984: warning: No description found for parameter 'mgmt'
>> include/net/cfg80211.h:3984: warning: No description found for parameter 'len'
>> include/net/cfg80211.h:4058: warning: No description found for parameter 'data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'rx_channel' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'scan_width' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'signal' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:3984: warning: No description found for parameter 'mgmt'
>> include/net/cfg80211.h:3984: warning: No description found for parameter 'len'
>> include/net/cfg80211.h:4058: warning: No description found for parameter 'data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'rx_channel' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'scan_width' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'signal' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:3984: warning: No description found for parameter 'mgmt'
>> include/net/cfg80211.h:3984: warning: No description found for parameter 'len'
>> include/net/cfg80211.h:4058: warning: No description found for parameter 'data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'rx_channel' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'scan_width' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:4058: warning: Excess function parameter 'signal' description in 'cfg80211_inform_bss_data'
>> include/net/cfg80211.h:3984: warning: No description found for parameter 'mgmt'
>> include/net/cfg80211.h:3984: warning: No description found for parameter 'len'

vim +/mgmt +3984 include/net/cfg80211.h

  3978	 * Or %NULL on error.
  3979	 */
  3980	struct cfg80211_bss * __must_check
  3981	cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
  3982				       struct cfg80211_inform_bss *data,
  3983				       struct ieee80211_mgmt *mgmt, size_t len,
> 3984				       gfp_t gfp);
  3985	
  3986	static inline struct cfg80211_bss * __must_check
  3987	cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
  3988					struct ieee80211_channel *rx_channel,
  3989					enum nl80211_bss_scan_width scan_width,
  3990					struct ieee80211_mgmt *mgmt, size_t len,
  3991					s32 signal, gfp_t gfp)
  3992	{
  3993		struct cfg80211_inform_bss data = {
  3994			.chan = rx_channel,
  3995			.scan_width = scan_width,
  3996			.signal = signal,
  3997		};
  3998	
  3999		return cfg80211_inform_bss_frame_data(wiphy, &data, mgmt, len, gfp);
  4000	}
  4001	
  4002	static inline struct cfg80211_bss * __must_check
  4003	cfg80211_inform_bss_frame(struct wiphy *wiphy,
  4004				  struct ieee80211_channel *rx_channel,
  4005				  struct ieee80211_mgmt *mgmt, size_t len,
  4006				  s32 signal, gfp_t gfp)
  4007	{
  4008		struct cfg80211_inform_bss data = {
  4009			.chan = rx_channel,
  4010			.scan_width = NL80211_BSS_CHAN_WIDTH_20,
  4011			.signal = signal,
  4012		};
  4013	
  4014		return cfg80211_inform_bss_frame_data(wiphy, &data, mgmt, len, gfp);
  4015	}
  4016	
  4017	/**
  4018	 * enum cfg80211_bss_frame_type - frame type that the BSS data came from
  4019	 * @CFG80211_BSS_FTYPE_UNKNOWN: driver doesn't know whether the data is
  4020	 *	from a beacon or probe response
  4021	 * @CFG80211_BSS_FTYPE_BEACON: data comes from a beacon
  4022	 * @CFG80211_BSS_FTYPE_PRESP: data comes from a probe response
  4023	 */
  4024	enum cfg80211_bss_frame_type {
  4025		CFG80211_BSS_FTYPE_UNKNOWN,
  4026		CFG80211_BSS_FTYPE_BEACON,
  4027		CFG80211_BSS_FTYPE_PRESP,
  4028	};
  4029	
  4030	/**
  4031	 * cfg80211_inform_bss_width - inform cfg80211 of a new BSS
  4032	 *
  4033	 * @wiphy: the wiphy reporting the BSS
  4034	 * @rx_channel: The channel the frame was received on
  4035	 * @scan_width: width of the control channel
  4036	 * @ftype: frame type (if known)
  4037	 * @bssid: the BSSID of the BSS
  4038	 * @tsf: the TSF sent by the peer in the beacon/probe response (or 0)
  4039	 * @capability: the capability field sent by the peer
  4040	 * @beacon_interval: the beacon interval announced by the peer
  4041	 * @ie: additional IEs sent by the peer
  4042	 * @ielen: length of the additional IEs
  4043	 * @signal: the signal strength, type depends on the wiphy's signal_type
  4044	 * @gfp: context flags
  4045	 *
  4046	 * This informs cfg80211 that BSS information was found and
  4047	 * the BSS should be updated/added.
  4048	 *
  4049	 * Return: A referenced struct, must be released with cfg80211_put_bss()!
  4050	 * Or %NULL on error.
  4051	 */
  4052	struct cfg80211_bss * __must_check
  4053	cfg80211_inform_bss_data(struct wiphy *wiphy,
  4054				 struct cfg80211_inform_bss *data,
  4055				 enum cfg80211_bss_frame_type ftype,
  4056				 const u8 *bssid, u64 tsf, u16 capability,
  4057				 u16 beacon_interval, const u8 *ie, size_t ielen,
> 4058				 gfp_t gfp);
  4059	
  4060	static inline struct cfg80211_bss * __must_check
  4061	cfg80211_inform_bss_width(struct wiphy *wiphy,

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--OgqxwSJOaUobr8KG
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ubBVQvALqFHBO0ZVAAA=

--OgqxwSJOaUobr8KG--
