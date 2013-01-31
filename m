Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3AaPUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:20:30 -0500
Message-ID: <1359645648.8415.77.camel@jlt4.sipsolutions.net> (sfid-20130131_162033_622785_0548F676)
Subject: Re: [PATCH 5/7] mac80211: Expand powersave configuration flag to be
 two bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Arend van Spriel <arend@broadcom.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@lists.ath9k.org,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Date: Thu, 31 Jan 2013 16:20:48 +0100
In-Reply-To: <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
	 <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:

> +static inline bool ieee80211_is_ps_disabled(struct ieee80211_conf *conf)

> +static inline bool ieee80211_is_ps_enabled(struct ieee80211_conf *conf)

Huh, is that worth the confusion? It seems !enabled should be the same
as disabled, but it's not quite the same, which might be confusing.

> +/**
> + * ieee80211_set_ps_state - set device powersave state
> + *
> + * Sets the powersave state in the supplied device configuration to the
> + * specified state.
> + *
> + * @conf: device configuration
> + * @state: new powersave state. Must be one of the IEEE80211_CONF_PS_*
> + *	flags from enum ieee80211_conf_flags.
> + */
> +static inline void ieee80211_set_ps_state(struct ieee80211_conf *conf,
> +					  u32 state)
> +{
> +	conf->flags = (conf->flags & ~IEEE80211_CONF_PS_MASK) |
> +		      (state & IEEE80211_CONF_PS_MASK);
> +}

I don't think the driver should do this, so the inline shouldn't be
here?

johannes

