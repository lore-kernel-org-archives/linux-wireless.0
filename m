Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaJaICy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 04:02:54 -0400
Message-ID: <1414742568.2918.11.camel@jrissane-mobl.ger.corp.intel.com> (sfid-20141031_090259_318570_C6152EC8)
Subject: Re: [PATCH] mac80211-hwsim:  add frequency attribute to netlink pkts
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Fri, 31 Oct 2014 10:02:48 +0200
In-Reply-To: <1414447486-10385-1-git-send-email-greearb@candelatech.com>
References: <1414447486-10385-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben & Johannes,

while rebasing my hwsim patches on top of Ben's patches, I noticed that
the freq attribute is not mentioned in hwsim_genl_policy struct. The
same applies also to radio name and vif attributes. Just wondered should
they be mentioned in the policy struct like the other attributes?


On ma, 2014-10-27 at 15:04 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Add frequency attribute when sending to user-space over
> netlink socket.  The frequency is currently ignored when
> receiving from user-space.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 7 +++++++
>  drivers/net/wireless/mac80211_hwsim.h | 4 +++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 270f8cd..b40435c 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -906,6 +906,9 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
>  	if (nla_put_u32(skb, HWSIM_ATTR_FLAGS, hwsim_flags))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(skb, HWSIM_ATTR_FREQ, data->channel->center_freq))
> +		goto nla_put_failure;
> +
>  	/* We get the tx control (rate and retries) info*/
>  
>  	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
> @@ -2421,6 +2424,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
>  	int frame_data_len;
>  	void *frame_data;
>  	struct sk_buff *skb = NULL;
> +	u32 freq;
>  
>  	if (info->snd_portid != wmediumd_portid) {
>  		printk(KERN_DEBUG "mac80211-hwsim: port-id mismatch: %d %d\n",
> @@ -2468,6 +2472,9 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
>  
>  	/* A frame is received from user space */
>  	memset(&rx_status, 0, sizeof(rx_status));
> +	/* TODO: Check ATTR_FREQ if it exists, and maybe throw away off-channel
> +	 * packets?
> +	 */
>  	rx_status.freq = data2->channel->center_freq;
>  	rx_status.band = data2->channel->band;
>  	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
> diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> index e614a20..85da35a 100644
> --- a/drivers/net/wireless/mac80211_hwsim.h
> +++ b/drivers/net/wireless/mac80211_hwsim.h
> @@ -60,7 +60,7 @@ enum hwsim_tx_control_flags {
>   * space, uses:
>   *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_ADDR_RECEIVER,
>   *	%HWSIM_ATTR_FRAME, %HWSIM_ATTR_FLAGS, %HWSIM_ATTR_RX_RATE,
> - *	%HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
> + *	%HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE, %HWSIM_ATTR_FREQ (optional)
>   * @HWSIM_CMD_TX_INFO_FRAME: Transmission info report from user space to
>   * kernel, uses:
>   *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_FLAGS,
> @@ -113,6 +113,7 @@ enum {
>   *	single channel is supported
>   * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
>   * @HWSIM_ATTR_NO_VIF:  Do not create vif (wlanX) when creating radio.
> + * @HWSIM_ATTR_FREQ: Frequency at which packet is transmitted or received.
>   * @__HWSIM_ATTR_MAX: enum limit
>   */
>  
> @@ -137,6 +138,7 @@ enum {
>  	HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE,
>  	HWSIM_ATTR_RADIO_NAME,
>  	HWSIM_ATTR_NO_VIF,
> +	HWSIM_ATTR_FREQ,
>  	__HWSIM_ATTR_MAX,
>  };
>  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)


Cheers,
Jukka



