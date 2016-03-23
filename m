Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57485 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbcCWAPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 20:15:43 -0400
Message-ID: <56F1E003.4000900@codeaurora.org> (sfid-20160323_011546_948512_F4F6307B)
Date: Tue, 22 Mar 2016 17:14:59 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: kbuild test robot <lkp@intel.com>, Peter Oh <poh@qca.qualcomm.com>
CC: kbuild-all@01.org, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: parse Rx MAC timestamp in mgmt frame for FW
 10.4
References: <201603230727.oL9ihH6E%fengguang.wu@intel.com>
In-Reply-To: <201603230727.oL9ihH6E%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 03/22/2016 04:14 PM, kbuild test robot wrote:
> Hi Peter,
>
> [auto build test WARNING on wireless-drivers-next/master]
> [also build test WARNING on v4.5 next-20160322]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Peter-Oh/ath10k-parse-Rx-MAC-timestamp-in-mgmt-frame-for-FW-10-4/20160323-064843
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: x86_64-randconfig-x000-201612 (attached as .config)
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
>
> All warnings (new ones prefixed by >>):
>
>     In file included from include/linux/linkage.h:4:0,
>                      from include/linux/kernel.h:6,
>                      from include/linux/skbuff.h:17,
>                      from drivers/net/wireless/ath/ath10k/wmi.c:18:
>     drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_10_4_op_pull_mgmt_rx_ev':
>     drivers/net/wireless/ath/ath10k/wmi.c:2236:33: error: 'WMI_RX_STATUS_EXT_INFO' undeclared (first use in this function)
it seems the warning is false report. I could see WMI_RX_STATUS_EXT_INFO 
is defined in wmi.h.
Moreover this check command doesn't claim any warning/error make 
M=drivers/net/wireless/ath/ath10k C=2 CF="-D__CHECK_ENDIAN__"
>       if (le32_to_cpu(arg->status) & WMI_RX_STATUS_EXT_INFO) {
>                                      ^
>     include/linux/compiler.h:147:30: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
>                                   ^
>>> drivers/net/wireless/ath/ath10k/wmi.c:2236:2: note: in expansion of macro 'if'
>       if (le32_to_cpu(arg->status) & WMI_RX_STATUS_EXT_INFO) {
>       ^
>     drivers/net/wireless/ath/ath10k/wmi.c:2236:33: note: each undeclared identifier is reported only once for each function it appears in
>       if (le32_to_cpu(arg->status) & WMI_RX_STATUS_EXT_INFO) {
>                                      ^
>     include/linux/compiler.h:147:30: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p(!!(cond)) ? !!(cond) :   \
>                                   ^
>>> drivers/net/wireless/ath/ath10k/wmi.c:2236:2: note: in expansion of macro 'if'
>       if (le32_to_cpu(arg->status) & WMI_RX_STATUS_EXT_INFO) {
>       ^
>     drivers/net/wireless/ath/ath10k/wmi.c:2239:14: error: 'struct wmi_mgmt_rx_ev_arg' has no member named 'ext_info'
>        memcpy(&arg->ext_info, ext_info,
>                   ^
>     drivers/net/wireless/ath/ath10k/wmi.c:2240:17: error: invalid application of 'sizeof' to incomplete type 'struct wmi_mgmt_rx_ext_info'
>               sizeof(struct wmi_mgmt_rx_ext_info));
>                      ^
>
> vim +/if +2236 drivers/net/wireless/ath/ath10k/wmi.c
>
>    2220	
>    2221		if (skb->len < pull_len)
>    2222			return -EPROTO;
>    2223	
>    2224		skb_pull(skb, pull_len);
>    2225		arg->channel = ev_hdr->channel;
>    2226		arg->buf_len = ev_hdr->buf_len;
>    2227		arg->status = ev_hdr->status;
>    2228		arg->snr = ev_hdr->snr;
>    2229		arg->phy_mode = ev_hdr->phy_mode;
>    2230		arg->rate = ev_hdr->rate;
>    2231	
>    2232		msdu_len = __le32_to_cpu(arg->buf_len);
>    2233		if (skb->len < msdu_len)
>    2234			return -EPROTO;
>    2235	
>> 2236		if (le32_to_cpu(arg->status) & WMI_RX_STATUS_EXT_INFO) {
>    2237			len = ALIGN(le32_to_cpu(arg->buf_len), 4);
>    2238			ext_info = (struct wmi_mgmt_rx_ext_info *)(skb->data + len);
>    2239			memcpy(&arg->ext_info, ext_info,
>    2240			       sizeof(struct wmi_mgmt_rx_ext_info));
>    2241		}
>    2242	
>    2243		/* Make sure bytes added for padding are removed. */
>    2244		skb_trim(skb, msdu_len);
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

