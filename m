Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35819 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbcDFIof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:44:35 -0400
Message-ID: <1459932268.17504.31.camel@sipsolutions.net> (sfid-20160406_104439_997227_90AED768)
Subject: Re: [PATCHv3 RESEND 04/11] cfg80211: allow the user space to change
 current NAN configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 10:44:28 +0200
In-Reply-To: <1459244109-16038-4-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-4-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:
> Some NAN configuration paramaters 

parameters

>  /**
> + * enum cfg80211_nan_conf_changes - indicates changed fields in nan
> configuration

again, NAN please

> + *
> + * @CFG80211_NAN_CONF_CHANGED_PREF: master preference
> + * @CFG80211_NAN_CONF_CHANGED_DUAL: dual band operation
> + */
> +enum cfg80211_nan_conf_changes {
> +	CFG80211_NAN_CONF_CHANGED_PREF = BIT(0),
> +	CFG80211_NAN_CONF_CHANGED_DUAL = BIT(1),
> +};

I also think this enum should be declared next to struct
cfg80211_nan_conf, not far later in the file.

> + * @nan_change_conf: changes NAN configuration. The changed
> parameters must
> + *	be specified in @changes. All other parameters must be
> ignored.

This is misleading. "The changed parameters are specified by the bitmap
@changes (using &enum cfg80211_nan_conf_changes); all other parameters
must be ignored" or so. You should always write this for driver
authors.

>   * @NL80211_ATTR_NAN_MASTER_PREF: the master preference to be used
> by
> - *	&NL80211_CMD_START_NAN. Its type is u8 and it can't be 0.
> + *	&NL80211_CMD_START_NAN and optionally with
> + *	&NL80211_CMD_CHANGE_NAN_CONFIG. Its type is u8 and it
> can't be 0.

I didn't notice this before, but generally the & is wrong. That will
try to link to that as a struct/enum/union name, which clearly isn't
the case here. You can use @, perhaps, or just % for a constant.

>   *	Also, values 1 and 255 are reserved for certification
> purposes and
>   *	should not be used during a normal device operation.
>   * @NL80211_ATTR_NAN_DUAL: NAN dual band operation config (see
>   *	&enum nl80211_nan_dual_band_conf). This attribute is used 

Here the & is correct.

> - *	&NL80211_CMD_START_NAN.
> + *	&NL80211_CMD_START_NAN and optionally with
> + *	&NL80211_CMD_CHANGE_NAN_CONFIG.

Here it's wrong again.

johannes
