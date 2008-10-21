Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYJUUPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 16:15:16 -0400
Subject: Re: [RFC] libertas: iwpriv commands to configure fine grained
	wake-on-(w)lan
From: Dan Williams <dcbw@redhat.com>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Jeff Garzik <jeff@garzik.org>
In-Reply-To: <48fe2917.131e640a.7efb.7d0b@mx.google.com>
References: <48fe2917.131e640a.7efb.7d0b@mx.google.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 16:13:47 -0400
Message-Id: <1224620028.15561.10.camel@localhost.localdomain> (sfid-20081021_221522_306586_24B9F113)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 16:49 -0700, Anna Neal wrote:
> View README for new API.
> 
> This patch implements the userspace interface for fine-grained configuration of
> wake-on-(w)lan.  We are aware that iwpriv's are discouraged, but this is a
> vendor-specific feature that's currently being used in the OLPC project.
> 
> We are aware that all iwprivs were removed from this driver.  These used the old
> API for iwprivs.  We've implemented this iwpriv as a private handler which relies
> on wireless extensions to do bounds checking and copying to/from user memory.
> Specific suggestions on how to make this more palatable for upstream inclusion
> are welcome.  If iwprivs are completely unacceptable then this can serve as a
> public reference for interfacing with these features.

IMHO we should be adding the functionality where's it's needed, which is
that ethtool, which doesn't have a verbose enough syntax for it's WOL
support.  If ethtool's existing WOL got fixed up to support these
use-cases, then we wouldn't need iwpriv commands, we wouldn't have
duplicate functionality running around, and everyone gets a pony.  Lets
kick off that discussion...

Jeff: could something like this syntax be added to ethtool, or maybe
discreet commands instead of one?  Thoughts?

Dan


> Signed-off-by: Anna Neal <anna@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  drivers/net/wireless/libertas/README |   71 ++++++++
>  drivers/net/wireless/libertas/wext.c |  323 ++++++++++++++++++++++++++++++++++
>  2 files changed, 394 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
> index d860fc3..6eb30a3 100644
> --- a/drivers/net/wireless/libertas/README
> +++ b/drivers/net/wireless/libertas/README
> @@ -28,6 +28,77 @@ DRIVER LOADING
>  
>  		insmod usb8388.ko [fw_name=usb8388.bin]
>  
> +=====================
> +IWPRIV COMMAND
> +=====================
> +
> +Wake On Lan Commands:
> +
> +	The Wake On Lan (wol) commands are used to configure wol rules outside
> +	of the constraints of ethtool. the following commands are supported:
> +
> +
> +	iwpriv ethX set_wol_rule
> +	iwpriv ethX get_wol_rule
> +	iwpriv ethX reset_wol_rule
> +
> +
> +set_wol_rule
> +
> +	Usage:
> +
> +	    $iwpriv msh0 set_wol_rule "<b|m|u> 0x<signature>{.<mask>}@<offset>"
> +
> +
> +	1. The first digit is the traffic type:
> +		b - broadcast
> +		m - multicast
> +		u - unicast
> +
> +	2. The pattern signature used for comparison to the incoming frame.
> +	   This can be from 1-4 bytes and must be in the standard hex format
> +	   with a leading '0x'.
> +
> +	3. An optional '.' may be added to specify a mask you wish to use. By
> +	   default it will be 0xf for the length of your signature.
> +
> +	4. An offset after the '@' is mandatory this will specify the offset
> +	   into the payload of an 802.3 frame at which the signature will be
> +	   compared.
> +
> +	5. In addition, you may 'and' multiple rules separated by '&&' in the
> +	   same call.
> +
> +	Note:
> +		Every iwpriv, as shown above, will add new wol rules and 'or'
> +		them to any previous rules entered.
> +		At most 16 rules may be applied.
> +
> +	Examples:
> +
> +	1. Wake from an arp request received over the mesh at 192.168.0.1.
> +
> +		iwpriv msh0 set_wol_rule "b 0x0806@06 && 0xC0A80001@16"
> +
> +	2. Set to wake from any arp request or any multicast traffic from
> +	   192.168.0.1.
> +
> +		iwpriv eth0 set_wol_rule "b 0x0806@06"
> +		iwpriv eth0 set_wol_rule "m 0xC0A80001@16"
> +
> +	3. Set to wake from an arp or IPv4 broadcast (ethertypes 0x0806 and
> +	   0x0806)
> +
> +		iwpriv eth0 set_wol_rule "b 0x0800.fff9@06"
> +
> +get_wol_rule
> +
> +	This will return a list of all the wol rules set.
> +
> +reset_wol_rule
> +
> +        This will delete/reset any rules entered using this interface.
> +
>  =========================
>  ETHTOOL
>  =========================
> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> index 82c3e5a..90032a9 100644
> --- a/drivers/net/wireless/libertas/wext.c
> +++ b/drivers/net/wireless/libertas/wext.c
> @@ -2135,6 +2135,301 @@ static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
>  	return ret;
>  }
>  
> +/**
> + * ascii_to_be32() - Convert an hex ascii string into a be32 integer.
> + * @dst:        Pointer to destination big endiand 32 bit integer.
> + * @pptr:       Input string. On exit points past the last converted character.
> +*
> + * Returns the number of converted characters.
> + **/
> +static int ascii_to_be32(__be32 *dst, unsigned char **pptr)
> +{
> +	uint32_t value;
> +	unsigned char *start;
> +	int char_count;
> +
> +	start = *pptr;
> +	if (**pptr == '0' && tolower(*(*pptr+1)) == 'x')
> +		start += 2;
> +	value = simple_strtoul((char *)*pptr, (char **) pptr, 16);
> +	*dst = cpu_to_be32(value);
> +
> +	char_count = (*pptr - start);
> +
> +	return (char_count > 8) ? -EINVAL : char_count;
> +}
> +
> +static int set_wol_rule_type(unsigned char *ptr, struct wol_config
> +		*wol_rule)
> +{
> +	if (tolower(*ptr) == 'b')
> +		wol_rule->pattern |= WOL_RULE_ADDR_TYPE_BCAST;
> +	else if (tolower(*ptr) == 'm')
> +		wol_rule->pattern |= WOL_RULE_ADDR_TYPE_MCAST;
> +	else if (tolower(*ptr) == 'u')
> +		wol_rule->pattern |= WOL_RULE_ADDR_TYPE_UCAST;
> +	else
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int config_set_wol_rule(unsigned char *ptr, struct wol_config *rules)
> +{
> +	unsigned short sig_offset;
> +	int sig_len, msk_len;
> +	int n, ret;
> +
> +	ptr = strstrip(ptr);
> +	if (*ptr == '\0')
> +		return -EINVAL;
> +
> +	ret = set_wol_rule_type(ptr, rules);
> +	if (ret)
> +		return ret;
> +
> +	lbs_deb_ioctl("Received WOL pattern %X\n", rules->pattern);
> +	ptr++;
> +
> +	for (n = 0; *ptr != '\0' || n < MAX_WOL_RULES; ptr++, n++) {
> +
> +		ptr = strstrip(ptr);
> +		if (*ptr == '\0')
> +			return -EINVAL;
> +
> +		rules->rule[n].rule_no = n;
> +		sig_len = ascii_to_be32(&rules->rule[n].signature, &ptr);
> +
> +		if (sig_len <= 0)
> +			return -EINVAL;
> +
> +		/* No signature mask, build a default one */
> +		if (*ptr == '@') {
> +			uint32_t defmask;
> +			defmask = (0xffffffff >> 4*(8-sig_len));
> +			rules->rule[n].sig_mask = cpu_to_be32(defmask);
> +			msk_len = sig_len;
> +		} else if (*ptr == '.') {
> +			ptr++;
> +			msk_len = ascii_to_be32(&rules->rule[n].sig_mask, &ptr);
> +			if (msk_len <= 0)
> +				return -EINVAL;
> +		} else
> +			return -EINVAL;
> +
> +		if (*ptr == '@')
> +			ptr++;
> +		else
> +			return -EINVAL;
> +
> +		/* assume a prefix of zeroes if mask is bigger than signature */
> +		if (sig_len < msk_len)
> +			sig_len = msk_len;
> +
> +		rules->rule[n].sig_length = cpu_to_le16((__u16)
> +				(sig_len + 1)/2);
> +		sig_offset = (uint16_t) simple_strtoul(ptr, (char **)&ptr, 16);
> +
> +		if (sig_offset > (IEEE80211_DATA_LEN - 4))
> +			return -EINVAL;
> +
> +		rules->rule[n].sig_offset = cpu_to_le16(sig_offset);
> +
> +		ptr = strstrip(ptr);
> +		if (*ptr == '\0') {
> +			rules->rule[n].rule_ops = WOL_RULE_OP_INVALID;
> +			n++;
> +			break;
> +		}
> +
> +		if ((*ptr == '&') && (*(ptr+1) == '&')) {
> +			rules->rule[n].rule_ops = WOL_RULE_OP_AND;
> +			ptr += 2;
> +		} else
> +			return -EINVAL;
> +
> +	}
> +	rules->no_rules_in_cmd = n;
> +	return 0;
> +}
> +
> +
> +static int lbs_wol_set_config_ioctl(struct net_device *dev,
> +				    struct iw_request_info *info,
> +				    union iwreq_data *u, char *data)
> +{
> +	int ret;
> +	struct wol_config wol_rule;
> +	struct wol_config *wol_ptr;
> +	struct lbs_private *priv = dev->priv;
> +
> +	wol_ptr = &wol_rule;
> +	memset(&wol_rule, 0, sizeof(struct wol_config));
> +
> +	lbs_deb_enter(LBS_DEB_IOCTL);
> +
> +	if (dev == priv->mesh_dev)
> +		wol_rule.pattern |= WOL_RULE_NET_TYPE_MESH;
> +	else
> +		wol_rule.pattern |= WOL_RULE_NET_TYPE_INFRA_OR_IBSS;
> +
> +	ret = config_set_wol_rule(data, wol_ptr);
> +	if (ret)
> +		goto error;
> +
> +	wol_rule.action = CMD_ACT_SET_WOL_RULE;
> +	lbs_deb_ioctl("Sending wol_set_rule for pattern %02x with %03d rules\n",
> +			wol_rule.pattern, wol_rule.no_rules_in_cmd);
> +	ret = lbs_host_sleep_cfg(priv, 0, &wol_rule);
> +	switch (wol_rule.result) {
> +	case WOL_RESULT_VALID_CMD:
> +		break;
> +	case WOL_RESULT_NOSPC_ERR:
> +		ret = -ENOSPC;
> +		break;
> +	case WOL_RESULT_EEXIST_ERR:
> +		ret = -EEXIST;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +error:
> +	lbs_deb_leave(LBS_DEB_IOCTL);
> +	return ret;
> +}
> +
> +static unsigned char *sprint_get_wol_result(unsigned char *ptr,
> +				struct wol_config *wol_rule, int ret)
> +{
> +	struct host_wol_rule *p_rule;
> +	int i;
> +	unsigned short sig_len;
> +
> +	if (wol_rule) {
> +		switch (wol_rule->pattern & 0x0F) {
> +		case WOL_RULE_ADDR_TYPE_BCAST:
> +			ptr += sprintf(ptr, "\nBroadcast Rules\n");
> +			break;
> +		case WOL_RULE_ADDR_TYPE_MCAST:
> +			ptr += sprintf(ptr, "\nMulticast Rules\n");
> +			break;
> +		case WOL_RULE_ADDR_TYPE_UCAST:
> +			ptr += sprintf(ptr, "\nUnicast Rules\n");
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	if (wol_rule->result) {
> +		ptr += sprintf(ptr, " No rules found.\n");
> +		return ptr;
> +	}
> +
> +	ptr += sprintf(ptr, "Total %d Rules  found for",
> +			wol_rule->no_rules_in_cmd);
> +	switch (wol_rule->pattern & 0xF0) {
> +	case WOL_RULE_NET_TYPE_INFRA_OR_IBSS:
> +		ptr += sprintf(ptr, " Infra or Ibss\n");
> +		break;
> +	case WOL_RULE_NET_TYPE_MESH:
> +		ptr += sprintf(ptr, " Mesh\n");
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	ptr += sprintf(ptr, "Signature\tSig Mask\t");
> +	ptr += sprintf(ptr, "Offset\tRule Op\n");
> +	wol_rule->no_rules_in_cmd = min(wol_rule->no_rules_in_cmd,
> +			(uint8_t) MAX_WOL_RULES);
> +
> +	for (i = 0; i < wol_rule->no_rules_in_cmd; i++) {
> +		p_rule = &wol_rule->rule[i];
> +		sig_len = le16_to_cpu(p_rule->sig_length);
> +		ptr += sprintf(ptr, "0x%08x", be32_to_cpu(p_rule->signature));
> +		ptr += sprintf(ptr, "\t");
> +		ptr += sprintf(ptr, "0x%08x", be32_to_cpu(p_rule->sig_mask));
> +		ptr += sprintf(ptr, "\t0x%03x\t",
> +				le16_to_cpu(p_rule->sig_offset));
> +
> +		if (p_rule->rule_ops == 2)
> +			ptr += sprintf(ptr, "OR\n");
> +		else if (p_rule->rule_ops == 1)
> +			ptr += sprintf(ptr, "AND\n");
> +		else
> +			ptr += sprintf(ptr, "LAST\n");
> +	}
> +	return ptr;
> +}
> +
> +static int lbs_wol_get_config_ioctl(struct net_device *dev,
> +				    struct iw_request_info *info,
> +				    union iwreq_data *u, char *data)
> +{
> +	int ret;
> +	struct wol_config wol_rule;
> +	struct wol_config *wol_ptr;
> +	struct lbs_private *priv = dev->priv;
> +	char *ptr = data;
> +
> +	wol_ptr = &wol_rule;
> +	memset(&wol_rule, 0, sizeof(struct wol_config));
> +
> +	if (dev == priv->mesh_dev)
> +		wol_rule.pattern |= WOL_RULE_NET_TYPE_MESH;
> +	else
> +		wol_rule.pattern |= WOL_RULE_NET_TYPE_INFRA_OR_IBSS;
> +
> +	wol_rule.action = CMD_ACT_GET_WOL_RULE;
> +	wol_rule.pattern |= WOL_RULE_ADDR_TYPE_BCAST;
> +	lbs_deb_ioctl("Sending get_wol_rule, pattern %02x\n", wol_rule.pattern);
> +	ret = lbs_host_sleep_cfg(priv, 0, &wol_rule);
> +	ptr = sprint_get_wol_result(ptr, wol_ptr, ret);
> +	if (ret)
> +		goto done;
> +
> +	wol_rule.pattern &= ~WOL_RULE_ADDR_TYPE_BCAST;
> +	wol_rule.pattern |= WOL_RULE_ADDR_TYPE_MCAST;
> +	lbs_deb_ioctl("Sending get_wol_rule, pattern %02x\n", wol_rule.pattern);
> +	ret = lbs_host_sleep_cfg(priv, 0, &wol_rule);
> +	ptr = sprint_get_wol_result(ptr, wol_ptr, ret);
> +	if (ret)
> +		goto done;
> +
> +	wol_rule.pattern &= ~WOL_RULE_ADDR_TYPE_MCAST;
> +	wol_rule.pattern |= WOL_RULE_ADDR_TYPE_UCAST;
> +	lbs_deb_ioctl("Sending get_wol_rule, pattern %02x\n", wol_rule.pattern);
> +	ret = lbs_host_sleep_cfg(priv, 0, &wol_rule);
> +	ptr = sprint_get_wol_result(ptr, wol_ptr, ret);
> +
> +	u->data.length = strlen(data);
> +done:
> +	lbs_deb_leave(LBS_DEB_IOCTL);
> +	return ret;
> +}
> +
> +static int lbs_wol_reset_config_ioctl(struct net_device *dev,
> +				      struct iw_request_info *info,
> +				      struct iw_point *u, char *data)
> +{
> +	int ret;
> +	struct wol_config wol_rule;
> +	struct lbs_private *priv = dev->priv;
> +
> +	memset(&wol_rule, 0, sizeof(struct wol_config));
> +
> +	lbs_deb_enter(LBS_DEB_IOCTL);
> +	wol_rule.action = CMD_ACT_RESET_WOL_RULE;
> +	lbs_deb_ioctl("Sending wol_reset command\n");
> +	ret = lbs_host_sleep_cfg(priv, 0, &wol_rule);
> +	if (!ret && wol_rule.result)
> +		ret = -EIO;
> +
> +	lbs_deb_leave(LBS_DEB_IOCTL);
> +	return ret;
> +}
> +
>  /*
>   * iwconfig settable callbacks
>   */
> @@ -2253,14 +2548,42 @@ static const iw_handler mesh_wlan_handler[] = {
>  	(iw_handler) lbs_get_encodeext,/* SIOCGIWENCODEEXT */
>  	(iw_handler) NULL,		/* SIOCSIWPMKSA */
>  };
> +
> +#define LBS_SET_WOL_RULE 	SIOCIWFIRSTPRIV
> +#define LBS_GET_WOL_RULE 	(SIOCIWFIRSTPRIV+1)
> +#define LBS_RESET_WOL_RULE 	(SIOCIWFIRSTPRIV+2)
> +
> +static const iw_handler lbs_private_handler[] = {
> +	(iw_handler) lbs_wol_set_config_ioctl,   /* LBS_SET_WOL_RULE */
> +	(iw_handler) lbs_wol_get_config_ioctl,	 /* LBS_GET_WOL_RULE */
> +	(iw_handler) lbs_wol_reset_config_ioctl, /* LBS_RESET_WOL_RULE */
> +
> +};
> +
> +#define CHAR1024_PARAM		   (IW_PRIV_TYPE_CHAR | 1024)
> +static const struct iw_priv_args lbs_private_args[] = {
> +	/* { cmd, set_args, get_args, name } */
> +	{ LBS_SET_WOL_RULE, CHAR1024_PARAM, 0, "set_wol_rule"},
> +	{ LBS_GET_WOL_RULE, 0, CHAR1024_PARAM, "get_wol_rule"},
> +	{ LBS_RESET_WOL_RULE, 0, 0, "reset_wol_rule"},
> +};
> +
>  struct iw_handler_def lbs_handler_def = {
>  	.num_standard	= ARRAY_SIZE(lbs_handler),
> +	.num_private	= ARRAY_SIZE(lbs_private_handler),
>  	.standard	= (iw_handler *) lbs_handler,
> +	.private	= (iw_handler *) lbs_private_handler,
>  	.get_wireless_stats = lbs_get_wireless_stats,
> +	.num_private_args = ARRAY_SIZE(lbs_private_args),
> +	.private_args	= lbs_private_args,
>  };
>  
>  struct iw_handler_def mesh_handler_def = {
>  	.num_standard	= ARRAY_SIZE(mesh_wlan_handler),
> +	.num_private	= ARRAY_SIZE(lbs_private_handler),
>  	.standard	= (iw_handler *) mesh_wlan_handler,
> +	.private	= (iw_handler *) lbs_private_handler,
>  	.get_wireless_stats = lbs_get_wireless_stats,
> +	.num_private_args = ARRAY_SIZE(lbs_private_args),
> +	.private_args	= lbs_private_args,
>  };

