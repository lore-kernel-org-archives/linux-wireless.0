Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1GNKIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 06:08:36 -0400
Subject: Re: [RFC 1/3] mac80211: Add 20/40 BSS coexistence management frame
 format
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110713_142434_262323_C456F32D)
References: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com>
	 (sfid-20110713_142434_262323_C456F32D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 12:08:32 +0200
Message-ID: <1310638112.3874.5.camel@jlt3.sipsolutions.net> (sfid-20110714_120839_980251_089BD959)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 17:54 +0530, Rajkumar Manoharan wrote:
> Add 20/40 BSS coexistence and intolerant channel report IEs.

Can you make the subject "wireless" or "ieee80211" instead of
"mac80211"?

> +/**
> + * struct ieee80211_2040_bss_coex_ie
> + *
> + * This structure refers to "20/40 BSS Coexistence information element"
> + */

That documentation is incomplete.

> +struct ieee80211_2040_bss_coex_ie {
> +	u8 element_id;
> +	u8 length;
> +#define IEEE80211_2040_BC_INFO_REQ		0x01
> +#define IEEE80211_2040_BC_40MHZ_INTOL		0x02
> +#define IEEE80211_2040_BC_20MHZ_WIDTH_REQ	0x04
> +#define IEEE80211_2040_BC_OBSS_SCAN_EXMPT_REQ	0x08
> +#define IEEE80211_2040_BC_OBSS_SCAN_EXMPT_GRNT	0x10

Please don't define them inside the struct, the docbook processing
doesn't like that. Also BIT() would be nice to be more readable, and
maybe make them an enum so they can have docs?

> +/**
> + * struct ieee80211_2040_intol_chan_report
> + *
> + * This structure refers to "20/40 BSS Intolerant Channel Report"
> + */

Again incomplete docs. Come to think of it, maybe give pointers to the
spec?

> +struct ieee80211_2040_intol_chan_report {
> +	u8 element_id;
> +	u8 length;
> +	u8 reg_class;
> +	u8 variable[0];
> +} __packed;

Does that variable[] really belong to the report? Didn't check now.

johannes

