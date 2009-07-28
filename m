Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:4775 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbZG1Q2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:28:02 -0400
Received: by ey-out-2122.google.com with SMTP id 9so42669eyd.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 09:28:01 -0700 (PDT)
Message-ID: <4A6F270A.7030002@gmail.com>
Date: Tue, 28 Jul 2009 17:27:54 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	orinoco-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] orinoco: enable cfg80211 "set_channel" operation
References: <200907281634.26104.hs4233@mail.mn-solutions.de>
In-Reply-To: <200907281634.26104.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Cool.

> +	if (orinoco_lock(priv, &flags) != 0)
> +		return -EBUSY;
> +
> +	priv->channel = channel;
> +	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
> +		/* Fast channel change - no commit if successful */
> +		hermes_t *hw = &priv->hw;
> +		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
> +					    HERMES_TEST_SET_CHANNEL,
> +					channel, NULL);
> +	}
> +	orinoco_unlock(priv, &flags);
> +
> +	return err;
> +}

Looks right for monitor mode (as you tested), but for ad-hoc the channel
change would be delayed until the next SIOCSIWCOMMIT. Which for cfg80211
is currently only on change_vif.

Adding a call to orinoco_commit(priv) in the ad-hoc case should push the
change to the card. I think we'll end up with this call in each of the
orinoco cfg80211 functions. Otherwise we have to work out how to do the
changes incrementally across the different hw/fw.

You can also eliminate orinoco_ioctl_setfreq from wext.c with this change.


Thanks,

Dave.
