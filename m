Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729420AbeG0J4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 05:56:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 27 Jul 2018 16:35:42 +0800
From: Wen Gong <wgong@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Save sk_pacing_shift to ieee80211_hw
In-Reply-To: <201807262252.r7bjxM51%fengguang.wu@intel.com>
References: <1532589677-16428-2-git-send-email-wgong@codeaurora.org>
 <201807262252.r7bjxM51%fengguang.wu@intel.com>
Message-ID: <c687d997be0c8e85a5e1e6f09a969dba@codeaurora.org> (sfid-20180727_103549_879901_D37E927E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks,
I will add description of tx_sk_pacing_shift as below and sent next 
patch.
*
* @tx_sk_pacing_shift: The TCP stack allow more than a single ms of data
*     to be queued in the stack. The value is a bit-shift of 1 second, 
e.g. 8
*     is ~4ms of queued data. It only affects local TCP sockets.
*/

On 2018-07-26 22:52, kbuild test robot wrote:
> Hi Wen,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on mac80211-next/master]
> [also build test WARNING on v4.18-rc6 next-20180725]
> [if your patch is applied to the wrong git tree, please drop us a note
> to help improve the system]
> 
> url:
> https://github.com/0day-ci/linux/commits/Wen-Gong/Change-sk_pacing_shift-in-ieee80211_hw-for-best-tx-throughput/20180726-190055
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
> master
> reproduce: make htmldocs
> 
> All warnings (new ones prefixed by >>):
> 
>    WARNING: convert(1) not found, for SVG to PDF conversion install
> ImageMagick (https://www.imagemagick.org)
>    mm/mempool.c:228: warning: Function parameter or member 'pool' not
> described in 'mempool_init'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.ibss' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.connect' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.keys' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.ie' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.ie_len' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.bssid' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.ssid' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.default_key' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.default_mgmt_key' not described in 'wireless_dev'
>    include/net/cfg80211.h:4381: warning: Function parameter or member
> 'wext.prev_bssid_valid' not described in 'wireless_dev'
>    include/net/mac80211.h:2329: warning: Function parameter or member
> 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
>    include/net/mac80211.h:2329: warning: Function parameter or member
> 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
>>> include/net/mac80211.h:2329: warning: Function parameter or member 
>>> 'tx_sk_pacing_shift' not described in 'ieee80211_hw'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.rates' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.use_rts' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.use_cts_prot' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.short_preamble' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.skip_table' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.jiffies' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.vif' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.hw_key' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.flags' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'control.enqueue_time' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'ack' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'ack.cookie' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.rates' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.ack_signal' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.ampdu_len' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.antenna' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.tx_time' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'status.status_driver_data' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'driver_rates' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'pad' not described in 'ieee80211_tx_info'
>    include/net/mac80211.h:977: warning: Function parameter or member
> 'rate_driver_data' not described in 'ieee80211_tx_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'rx_stats_avg' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'rx_stats_avg.signal' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'rx_stats_avg.chain_signal' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.filtered' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.retry_failed' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.retry_count' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.lost_packets' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.msdu_retries' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.msdu_failed' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.last_ack' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.last_ack_signal' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.ack_signal_filled' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'status_stats.avg_ack_signal' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'tx_stats.packets' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'tx_stats.bytes' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'tx_stats.last_rate' not described in 'sta_info'
>    net/mac80211/sta_info.h:588: warning: Function parameter or member
> 'tx_stats.msdu' not described in 'sta_info'
>    kernel/sched/fair.c:3760: warning: Function parameter or member
> 'flags' not described in 'attach_entity_load_avg'
>    include/linux/device.h:93: warning: bad line: this bus.
>    include/linux/dma-buf.h:307: warning: Function parameter or member
> 'cb_excl.cb' not described in 'dma_buf'
>    include/linux/dma-buf.h:307: warning: Function parameter or member
> 'cb_excl.poll' not described in 'dma_buf'
>    include/linux/dma-buf.h:307: warning: Function parameter or member
> 'cb_excl.active' not described in 'dma_buf'
>    include/linux/dma-buf.h:307: warning: Function parameter or member
> 'cb_shared.cb' not described in 'dma_buf'
>    include/linux/dma-buf.h:307: warning: Function parameter or member
> 'cb_shared.poll' not described in 'dma_buf'
>    include/linux/dma-buf.h:307: warning: Function parameter or member
> 'cb_shared.active' not described in 'dma_buf'
>    include/linux/dma-fence-array.h:54: warning: Function parameter or
> member 'work' not described in 'dma_fence_array'
>    include/linux/gpio/driver.h:142: warning: Function parameter or
> member 'request_key' not described in 'gpio_irq_chip'
>    include/linux/iio/hw-consumer.h:1: warning: no structured comments 
> found
>    include/linux/device.h:94: warning: bad line: this bus.
>    include/linux/input/sparse-keymap.h:46: warning: Function parameter
> or member 'sw' not described in 'key_entry'
>    include/linux/regulator/driver.h:227: warning: Function parameter
> or member 'resume_early' not described in 'regulator_ops'
>    drivers/regulator/core.c:4465: warning: Excess function parameter
> 'state' description in 'regulator_suspend_late'
>    arch/s390/include/asm/cio.h:245: warning: Function parameter or
> member 'esw.esw0' not described in 'irb'
>    arch/s390/include/asm/cio.h:245: warning: Function parameter or
> member 'esw.esw1' not described in 'irb'
>    arch/s390/include/asm/cio.h:245: warning: Function parameter or
> member 'esw.esw2' not described in 'irb'
>    arch/s390/include/asm/cio.h:245: warning: Function parameter or
> member 'esw.esw3' not described in 'irb'
>    arch/s390/include/asm/cio.h:245: warning: Function parameter or
> member 'esw.eadm' not described in 'irb'
>    drivers/usb/dwc3/gadget.c:510: warning: Excess function parameter
> 'dwc' description in 'dwc3_gadget_start_config'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_pin' not described in 'drm_driver'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_unpin' not described in 'drm_driver'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_res_obj' not described in 'drm_driver'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_get_sg_table' not described in 'drm_driver'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_import_sg_table' not described in 'drm_driver'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_vmap' not described in 'drm_driver'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_vunmap' not described in 'drm_driver'
>    include/drm/drm_drv.h:610: warning: Function parameter or member
> 'gem_prime_mmap' not described in 'drm_driver'
>    drivers/gpu/drm/i915/i915_vma.h:48: warning: cannot understand
> function prototype: 'struct i915_vma '
>    drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments 
> found
>    include/drm/tinydrm/tinydrm.h:34: warning: Function parameter or
> member 'fb_dirty' not described in 'tinydrm_device'
>    drivers/gpu/drm/tinydrm/mipi-dbi.c:272: warning: Function parameter
> or member 'crtc_state' not described in 'mipi_dbi_enable_flush'
>    drivers/gpu/drm/tinydrm/mipi-dbi.c:272: warning: Function parameter
> or member 'plane_state' not described in 'mipi_dbi_enable_flush'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'dev_scratch' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'ip_defrag_offset' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'list' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'skb_mstamp' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> '__cloned_offset' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'head_frag' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> '__unused' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> '__pkt_type_offset' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'pfmemalloc' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'encapsulation' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'encap_hdr_csum' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'csum_valid' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'csum_complete_sw' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'csum_level' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'inner_protocol_type' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'remcsum_offload' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'offload_fwd_mark' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'offload_mr_fwd_mark' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'sender_cpu' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'reserved_tailroom' not described in 'sk_buff'
>    include/linux/skbuff.h:853: warning: Function parameter or member
> 'inner_ipproto' not described in 'sk_buff'
>    include/net/sock.h:238: warning: Function parameter or member
> 'skc_addrpair' not described in 'sock_common'
>    include/net/sock.h:238: warning: Function parameter or member
> 'skc_portpair' not described in 'sock_common'
>    include/net/sock.h:238: warning: Function parameter or member
> 'skc_ipv6only' not described in 'sock_common'
> 
> vim +2329 include/net/mac80211.h
> 
> 1bc0826c8f Johannes Berg    2007-09-18  2179
> 7ac1bd6aec Johannes Berg    2007-09-14  2180  /**
> 7ac1bd6aec Johannes Berg    2007-09-14  2181   * struct ieee80211_hw -
> hardware information and state
> 75a5f0ccfd Johannes Berg    2007-09-18  2182   *
> 75a5f0ccfd Johannes Berg    2007-09-18  2183   * This structure
> contains the configuration and hardware
> 75a5f0ccfd Johannes Berg    2007-09-18  2184   * information for an 
> 802.11 PHY.
> 75a5f0ccfd Johannes Berg    2007-09-18  2185   *
> 75a5f0ccfd Johannes Berg    2007-09-18  2186   * @wiphy: This points
> to the &struct wiphy allocated for this
> 75a5f0ccfd Johannes Berg    2007-09-18  2187   *	802.11 PHY. You must
> fill in the @perm_addr and @dev
> 75a5f0ccfd Johannes Berg    2007-09-18  2188   *	members of this
> structure using SET_IEEE80211_DEV()
> 8318d78a44 Johannes Berg    2008-01-24  2189   *	and
> SET_IEEE80211_PERM_ADDR(). Additionally, all supported
> 8318d78a44 Johannes Berg    2008-01-24  2190   *	bands (with channels,
> bitrates) are registered here.
> 75a5f0ccfd Johannes Berg    2007-09-18  2191   *
> 75a5f0ccfd Johannes Berg    2007-09-18  2192   * @conf: &struct
> ieee80211_conf, device configuration, don't use.
> 75a5f0ccfd Johannes Berg    2007-09-18  2193   *
> 75a5f0ccfd Johannes Berg    2007-09-18  2194   * @priv: pointer to
> private area that was allocated for driver use
> 75a5f0ccfd Johannes Berg    2007-09-18  2195   *	along with this 
> structure.
> 75a5f0ccfd Johannes Berg    2007-09-18  2196   *
> 75a5f0ccfd Johannes Berg    2007-09-18  2197   * @flags: hardware
> flags, see &enum ieee80211_hw_flags.
> 75a5f0ccfd Johannes Berg    2007-09-18  2198   *
> 75a5f0ccfd Johannes Berg    2007-09-18  2199   * @extra_tx_headroom:
> headroom to reserve in each transmit skb
> 75a5f0ccfd Johannes Berg    2007-09-18  2200   *	for use by the driver
> (e.g. for transmit headers.)
> 75a5f0ccfd Johannes Berg    2007-09-18  2201   *
> 70dabeb74e Felix Fietkau    2013-12-14  2202   *
> @extra_beacon_tailroom: tailroom to reserve in each beacon tx skb.
> 70dabeb74e Felix Fietkau    2013-12-14  2203   *	Can be used by
> drivers to add extra IEs.
> 75a5f0ccfd Johannes Berg    2007-09-18  2204   *
> 566bfe5a8b Bruno Randolf    2008-05-08  2205   * @max_signal: Maximum
> value for signal (rssi) in RX information, used
> 566bfe5a8b Bruno Randolf    2008-05-08  2206   *	only when
> @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
> 75a5f0ccfd Johannes Berg    2007-09-18  2207   *
> ea95bba41e Tomas Winkler    2008-07-18  2208   * @max_listen_interval:
> max listen interval in units of beacon interval
> ea95bba41e Tomas Winkler    2008-07-18  2209   *	that HW supports
> ea95bba41e Tomas Winkler    2008-07-18  2210   *
> 75a5f0ccfd Johannes Berg    2007-09-18  2211   * @queues: number of
> available hardware transmit queues for
> e100bb64bf Johannes Berg    2008-04-30  2212   *	data packets. WMM/QoS
> requires at least four, these
> e100bb64bf Johannes Berg    2008-04-30  2213   *	queues need to have
> configurable access parameters.
> e100bb64bf Johannes Berg    2008-04-30  2214   *
> 830f903866 Johannes Berg    2007-10-28  2215   *
> @rate_control_algorithm: rate control algorithm for this hardware.
> 830f903866 Johannes Berg    2007-10-28  2216   *	If unset (NULL), the
> default algorithm will be used. Must be
> 830f903866 Johannes Berg    2007-10-28  2217   *	set before calling
> ieee80211_register_hw().
> 32bfd35d4b Johannes Berg    2007-12-19  2218   *
> 32bfd35d4b Johannes Berg    2007-12-19  2219   * @vif_data_size: size
> (in bytes) of the drv_priv data area
> 32bfd35d4b Johannes Berg    2007-12-19  2220   *	within &struct 
> ieee80211_vif.
> 17741cdc26 Johannes Berg    2008-09-11  2221   * @sta_data_size: size
> (in bytes) of the drv_priv data area
> 17741cdc26 Johannes Berg    2008-09-11  2222   *	within &struct 
> ieee80211_sta.
> d01a1e6586 Michal Kazior    2012-06-26  2223   * @chanctx_data_size:
> size (in bytes) of the drv_priv data area
> d01a1e6586 Michal Kazior    2012-06-26  2224   *	within &struct
> ieee80211_chanctx_conf.
> ba8c3d6f16 Felix Fietkau    2015-03-27  2225   * @txq_data_size: size
> (in bytes) of the drv_priv data area
> ba8c3d6f16 Felix Fietkau    2015-03-27  2226   *	within @struct 
> ieee80211_txq.
> 870abdf671 Felix Fietkau    2008-10-05  2227   *
> 78be49ec2a Helmut Schaa     2010-10-02  2228   * @max_rates: maximum
> number of alternate rate retry stages the hw
> 78be49ec2a Helmut Schaa     2010-10-02  2229   *	can handle.
> 78be49ec2a Helmut Schaa     2010-10-02  2230   * @max_report_rates:
> maximum number of alternate rate retry stages
> 78be49ec2a Helmut Schaa     2010-10-02  2231   *	the hw can report 
> back.
> e6a9854b05 Johannes Berg    2008-10-21  2232   * @max_rate_tries:
> maximum number of tries for each stage
> 4e6cbfd09c John W. Linville 2010-07-29  2233   *
> df6ba5d80d Luciano Coelho   2011-01-12  2234   *
> @max_rx_aggregation_subframes: maximum buffer size (number of
> df6ba5d80d Luciano Coelho   2011-01-12  2235   *	sub-frames) to be
> used for A-MPDU block ack receiver
> df6ba5d80d Luciano Coelho   2011-01-12  2236   *	aggregation.
> df6ba5d80d Luciano Coelho   2011-01-12  2237   *	This is only relevant
> if the device has restrictions on the
> df6ba5d80d Luciano Coelho   2011-01-12  2238   *	number of subframes,
> if it relies on mac80211 to do reordering
> df6ba5d80d Luciano Coelho   2011-01-12  2239   *	it shouldn't be set.
> 5dd36bc933 Johannes Berg    2011-01-18  2240   *
> 5dd36bc933 Johannes Berg    2011-01-18  2241   *
> @max_tx_aggregation_subframes: maximum number of subframes in an
> 41cbb0f5a2 Luca Coelho      2018-06-09  2242   *	aggregate an HT/HE
> device will transmit. In HT AddBA we'll
> 41cbb0f5a2 Luca Coelho      2018-06-09  2243   *	advertise a constant
> value of 64 as some older APs crash if
> 41cbb0f5a2 Luca Coelho      2018-06-09  2244   *	the window size is
> smaller (an example is LinkSys WRT120N
> 41cbb0f5a2 Luca Coelho      2018-06-09  2245   *	with FW v1.0.07 build
> 002 Jun 18 2012).
> 41cbb0f5a2 Luca Coelho      2018-06-09  2246   *	For AddBA to HE
> capable peers this value will be used.
> 3a25a8c8b7 Johannes Berg    2012-04-03  2247   *
> 6e0456b545 Felix Fietkau    2016-03-03  2248   * @max_tx_fragments:
> maximum number of tx buffers per (A)-MSDU, sum
> 6e0456b545 Felix Fietkau    2016-03-03  2249   *	of 1 +
> skb_shinfo(skb)->nr_frags for each skb in the frag_list.
> 6e0456b545 Felix Fietkau    2016-03-03  2250   *
> 3a25a8c8b7 Johannes Berg    2012-04-03  2251   *
> @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
> 3a25a8c8b7 Johannes Berg    2012-04-03  2252   *	(if
> %IEEE80211_HW_QUEUE_CONTROL is set)
> ac55d2fe05 Johannes Berg    2012-05-10  2253   *
> ac55d2fe05 Johannes Berg    2012-05-10  2254   *
> @radiotap_mcs_details: lists which MCS information can the HW
> ac55d2fe05 Johannes Berg    2012-05-10  2255   *	reports, by default
> it is set to _MCS, _GI and _BW but doesn't
> b4f7f4ad42 Jani Nikula      2016-10-21  2256   *	include _FMT. Use
> %IEEE80211_RADIOTAP_MCS_HAVE_\* values, only
> ac55d2fe05 Johannes Berg    2012-05-10  2257   *	adding _BW is 
> supported today.
> 72d7872852 Arik Nemtsov     2012-05-10  2258   *
> 5164892184 Johannes Berg    2012-11-22  2259   *
> @radiotap_vht_details: lists which VHT MCS information the HW reports,
> 5164892184 Johannes Berg    2012-11-22  2260   *	the default is _GI |
> _BANDWIDTH.
> b4f7f4ad42 Jani Nikula      2016-10-21  2261   *	Use the
> %IEEE80211_RADIOTAP_VHT_KNOWN_\* values.
> 5164892184 Johannes Berg    2012-11-22  2262   *
> 41cbb0f5a2 Luca Coelho      2018-06-09  2263   * @radiotap_he: HE
> radiotap validity flags
> 41cbb0f5a2 Luca Coelho      2018-06-09  2264   *
> 99ee7cae3b Johannes Berg    2016-08-29  2265   * @radiotap_timestamp:
> Information for the radiotap timestamp field; if the
> 99ee7cae3b Johannes Berg    2016-08-29  2266   *	'units_pos' member is
> set to a non-negative value it must be set to
> 99ee7cae3b Johannes Berg    2016-08-29  2267   *	a combination of a
> IEEE80211_RADIOTAP_TIMESTAMP_UNIT_* and a
> 99ee7cae3b Johannes Berg    2016-08-29  2268
> *	IEEE80211_RADIOTAP_TIMESTAMP_SPOS_* value, and then the timestamp
> 99ee7cae3b Johannes Berg    2016-08-29  2269   *	field will be added
> and populated from the &struct ieee80211_rx_status
> 99ee7cae3b Johannes Berg    2016-08-29  2270   *	device_timestamp. If
> the 'accuracy' member is non-negative, it's put
> 99ee7cae3b Johannes Berg    2016-08-29  2271   *	into the accuracy
> radiotap field and the accuracy known flag is set.
> 99ee7cae3b Johannes Berg    2016-08-29  2272   *
> 72d7872852 Arik Nemtsov     2012-05-10  2273   * @netdev_features:
> netdev features to be set in each netdev created
> 680a0daba7 Johannes Berg    2015-04-13  2274   *	from this HW. Note
> that not all features are usable with mac80211,
> 680a0daba7 Johannes Berg    2015-04-13  2275   *	other features will
> be rejected during HW registration.
> 219c38674c Alexander Bondar 2013-01-22  2276   *
> 219c38674c Alexander Bondar 2013-01-22  2277   * @uapsd_queues: This
> bitmap is included in (re)association frame to indicate
> 219c38674c Alexander Bondar 2013-01-22  2278   *	for each access
> category if it is uAPSD trigger-enabled and delivery-
> 219c38674c Alexander Bondar 2013-01-22  2279   *	enabled. Use
> IEEE80211_WMM_IE_STA_QOSINFO_AC_* to set this bitmap.
> 219c38674c Alexander Bondar 2013-01-22  2280   *	Each bit corresponds
> to different AC. Value '1' in specific bit means
> 219c38674c Alexander Bondar 2013-01-22  2281   *	that corresponding AC
> is both trigger- and delivery-enabled. '0' means
> 219c38674c Alexander Bondar 2013-01-22  2282   *	neither enabled.
> 219c38674c Alexander Bondar 2013-01-22  2283   *
> 219c38674c Alexander Bondar 2013-01-22  2284   * @uapsd_max_sp_len:
> maximum number of total buffered frames the WMM AP may
> 219c38674c Alexander Bondar 2013-01-22  2285   *	deliver to a WMM STA
> during any Service Period triggered by the WMM STA.
> 219c38674c Alexander Bondar 2013-01-22  2286   *	Use
> IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
> 2475b1cc0d Max Stepanov     2013-03-24  2287   *
> 2475b1cc0d Max Stepanov     2013-03-24  2288   * @n_cipher_schemes: a
> size of an array of cipher schemes definitions.
> 2475b1cc0d Max Stepanov     2013-03-24  2289   * @cipher_schemes: a
> pointer to an array of cipher scheme definitions
> 2475b1cc0d Max Stepanov     2013-03-24  2290   *	supported by HW.
> 167e33f4f6 Ayala Beker      2016-09-20  2291   * @max_nan_de_entries:
> maximum number of NAN DE functions supported by the
> 167e33f4f6 Ayala Beker      2016-09-20  2292   *	device.
> 7ac1bd6aec Johannes Berg    2007-09-14  2293   */
> f0706e828e Jiri Benc        2007-05-05  2294  struct ieee80211_hw {
> f0706e828e Jiri Benc        2007-05-05  2295  	struct ieee80211_conf 
> conf;
> 75a5f0ccfd Johannes Berg    2007-09-18  2296  	struct wiphy *wiphy;
> 830f903866 Johannes Berg    2007-10-28  2297  	const char
> *rate_control_algorithm;
> f0706e828e Jiri Benc        2007-05-05  2298  	void *priv;
> 30686bf7f5 Johannes Berg    2015-06-02  2299  	unsigned long
> flags[BITS_TO_LONGS(NUM_IEEE80211_HW_FLAGS)];
> f0706e828e Jiri Benc        2007-05-05  2300  	unsigned int 
> extra_tx_headroom;
> 70dabeb74e Felix Fietkau    2013-12-14  2301  	unsigned int
> extra_beacon_tailroom;
> 32bfd35d4b Johannes Berg    2007-12-19  2302  	int vif_data_size;
> 17741cdc26 Johannes Berg    2008-09-11  2303  	int sta_data_size;
> d01a1e6586 Michal Kazior    2012-06-26  2304  	int chanctx_data_size;
> ba8c3d6f16 Felix Fietkau    2015-03-27  2305  	int txq_data_size;
> ea95bba41e Tomas Winkler    2008-07-18  2306  	u16 queues;
> ea95bba41e Tomas Winkler    2008-07-18  2307  	u16 max_listen_interval;
> f0706e828e Jiri Benc        2007-05-05  2308  	s8 max_signal;
> e6a9854b05 Johannes Berg    2008-10-21  2309  	u8 max_rates;
> 78be49ec2a Helmut Schaa     2010-10-02  2310  	u8 max_report_rates;
> e6a9854b05 Johannes Berg    2008-10-21  2311  	u8 max_rate_tries;
> 41cbb0f5a2 Luca Coelho      2018-06-09  2312  	u16 
> max_rx_aggregation_subframes;
> 41cbb0f5a2 Luca Coelho      2018-06-09  2313  	u16 
> max_tx_aggregation_subframes;
> 6e0456b545 Felix Fietkau    2016-03-03  2314  	u8 max_tx_fragments;
> 3a25a8c8b7 Johannes Berg    2012-04-03  2315  	u8 
> offchannel_tx_hw_queue;
> ac55d2fe05 Johannes Berg    2012-05-10  2316  	u8 radiotap_mcs_details;
> 5164892184 Johannes Berg    2012-11-22  2317  	u16 
> radiotap_vht_details;
> 99ee7cae3b Johannes Berg    2016-08-29  2318  	struct {
> 99ee7cae3b Johannes Berg    2016-08-29  2319  		int units_pos;
> 99ee7cae3b Johannes Berg    2016-08-29  2320  		s16 accuracy;
> 99ee7cae3b Johannes Berg    2016-08-29  2321  	} radiotap_timestamp;
> 72d7872852 Arik Nemtsov     2012-05-10  2322  	netdev_features_t
> netdev_features;
> 219c38674c Alexander Bondar 2013-01-22  2323  	u8 uapsd_queues;
> 219c38674c Alexander Bondar 2013-01-22  2324  	u8 uapsd_max_sp_len;
> 2475b1cc0d Max Stepanov     2013-03-24  2325  	u8 n_cipher_schemes;
> 2475b1cc0d Max Stepanov     2013-03-24  2326  	const struct
> ieee80211_cipher_scheme *cipher_schemes;
> 167e33f4f6 Ayala Beker      2016-09-20  2327  	u8 max_nan_de_entries;
> c03233ae8c Wen Gong         2018-07-26  2328  	u8 tx_sk_pacing_shift;
> f0706e828e Jiri Benc        2007-05-05 @2329  };
> f0706e828e Jiri Benc        2007-05-05  2330
> 
> :::::: The code at line 2329 was first introduced by commit
> :::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add
> mac80211 wireless stack.
> 
> :::::: TO: Jiri Benc <jbenc@suse.cz>
> :::::: CC: David S. Miller <davem@davemloft.net>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology 
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel 
> Corporation
