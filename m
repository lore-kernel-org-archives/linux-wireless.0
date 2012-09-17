Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab2IQPY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:24:29 -0400
Message-ID: <1347895505.4975.10.camel@jlt4.sipsolutions.net> (sfid-20120917_172436_068812_67BAA885)
Subject: Re: [RFC V2] cfg80211/nl80211: Notify connection request failure in
 AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Sep 2012 17:25:05 +0200
In-Reply-To: <1347881834-31615-1-git-send-email-c_ppitch@qca.qualcomm.com>
References: <1347881834-31615-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-17 at 17:07 +0530, Pandiyarajan Pitchaimuthu wrote:
> In AP mode, when a station requests connection to an AP and if the
> request is failed for particular reason, userspace is notified about the
> failure through NL80211_CMD_CONN_FAILED command. Reason for the failure
> is sent through the attribute NL80211_ATTR_CONN_FAILED_REASON.
> 
> Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
> ---
>  include/linux/nl80211.h |   19 +++++++++++++++++++
>  include/net/cfg80211.h  |   19 +++++++++++++++++++
>  net/wireless/mlme.c     |   11 +++++++++++
>  net/wireless/nl80211.c  |   34 ++++++++++++++++++++++++++++++++++
>  net/wireless/nl80211.h  |    5 +++++
>  5 files changed, 88 insertions(+)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 2f38788..55c01d0 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -565,6 +565,11 @@
>   *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
>   *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
>   *
> + * @NL80211_CMD_CONN_FAILED: connection request to an AP failed; used to
> + *	notify userspace that AP has rejected the connection request from a
> + *	station, due to particular reason. %NL80211_ATTR_CONN_FAILED_REASON
> + *	is used for this.
> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -708,6 +713,8 @@ enum nl80211_commands {
>  
>  	NL80211_CMD_CH_SWITCH_NOTIFY,
>  
> +	NL80211_CMD_CONN_FAILED,
> +
>  	/* add new commands above here */
>  
>  	/* used to define NL80211_CMD_MAX below */
> @@ -1251,6 +1258,10 @@ enum nl80211_commands {
>   *	was used to provide the hint. For the different types of
>   *	allowed user regulatory hints see nl80211_user_reg_hint_type.
>   *
> + * @NL80211_ATTR_CONN_FAILED_REASON: The reason for which AP has rejected
> + *	the connection request from a station. nl80211_connect_failed_reason
> + *	enum has different reasons of connection failure.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -1506,6 +1517,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_USER_REG_HINT_TYPE,
>  
> +	NL80211_ATTR_CONN_FAILED_REASON,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -3023,4 +3036,10 @@ enum nl80211_probe_resp_offload_support_attr {
>  	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
>  };
>  
> +/* AP mode - sta's connection request failed reasons */
> +enum nl80211_connect_failed_reason {

Kernel-doc descriptions here would be nice.

Otherwise looks fine, thanks.

johannes

