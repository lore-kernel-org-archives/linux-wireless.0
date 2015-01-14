Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58014 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbbANI3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 03:29:44 -0500
Message-ID: <1421224180.1950.10.camel@sipsolutions.net> (sfid-20150114_093002_750611_6AFEA3D5)
Subject: Re: [PATCHv4] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>
Date: Wed, 14 Jan 2015 09:29:40 +0100
In-Reply-To: <CAA2SeNL76Pd3ft4biBsHD9oTA4JOpD7oa5E+5ajk37irSDPhtw@mail.gmail.com> (sfid-20150108_120711_878615_1424844D)
References: <1420566070-25336-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1420639929.3407.18.camel@sipsolutions.net>
	 <CAA2SeN+KZqXcBpOuW=J_vyznOn03NceuH8RDdmcB30-7-9xyQw@mail.gmail.com>
	 <1420703288.2029.4.camel@sipsolutions.net>
	 <CAA2SeNL76Pd3ft4biBsHD9oTA4JOpD7oa5E+5ajk37irSDPhtw@mail.gmail.com>
	 (sfid-20150108_120711_878615_1424844D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry ...

On Thu, 2015-01-08 at 12:07 +0100, Lorenzo Bianconi wrote:

> Sounds good, now I have clearer vision :)
> I will overwrite bss_conf nl80211_tx_power_setting value in
> ieee80211_set_tx_power() when txpower type is set to
> NL80211_TX_POWER_AUTOMATIC from userspace. Moreover should we set
> nl80211_tx_power_setting to NL80211_TX_POWER_LIMITED in
> ieee80211_handle_pwr_constr() when the station receives a power
> constraint in beacon frames? What do you think?

Isn't it basically always only valid to have LIMITED and FIXED? I don't
see much value in fixed really though, but if the user requested
that ...

johannes

