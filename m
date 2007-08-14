Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47339
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765634AbXHNQtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 12:49:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] the recently discussed flags patch
Date: Tue, 14 Aug 2007 18:48:57 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>
References: <1187108515.4037.3.camel@johannes.berg>
In-Reply-To: <1187108515.4037.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708141848.57809.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 August 2007 18:21:55 Johannes Berg wrote:
> +/*
> + * flags for change_filter_flags()
> + *
> + * Note that e.g. if PROMISC_IN_BSS is unset then
> + * you should still do MAC address filtering if
> + * possible even if OTHER_BSS is set to indicate
> + * no BSSID filtering should be done.
> + */
> +#define FIF_PROMISC_IN_BSS	0x01
> +#define FIF_ALLMULTI		0x02
> +#define FIF_FCSFAIL		0x04
> +#define FIF_PLCPFAIL		0x08
> +#define FIF_CONTROL		0x10
> +#define FIF_OTHER_BSS		0x20

Please some more comments on what they actually mean
and what's usually to do when the flag is set.

> +	/* Change filter flags, see above for FIF_* constants.
> +	 *
> +	 * Must be atomic due to running under the tx lock.
> +	 * This callback is required.
> +	 */
> +	void (*change_filter_flags)(struct ieee80211_hw *hw,
> +				    int changed_flags, int total_flags);

Better use unsigned int.

What does changed_flags and total_flags mean?
I thought we'd like to have a pointer here, to the driver
can clear what's not supported.

-- 
Greetings Michael.
