Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab0C3Fbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 01:31:35 -0400
Subject: Re: [RFC] mac80211: Send deauth/disassoc prior to dropping STA
 entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100330020025.GA18080@jm.kir.nu>
References: <20100330020025.GA18080@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 07:31:31 +0200
Message-ID: <1269927091.3927.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 19:00 -0700, Jouni Malinen wrote:
> Does this look fine or would there be better solution for reordering
> disconnections calls in a way that would allow us to maintain the keys
> needed to protect the deauth/disassoc frame?
> 
> 
> When management frame protection (IEEE 802.11w) is used, the
> deauthentication and disassociation frames must be protected whenever
> the encryption keys are configured. We were removing the STA entry and
> with it, the keys, just before actually sending out these frames which
> meant that the frames went out unprotected. The AP will drop them in
> such a case. Fix this by reordering the operations a bit so that
> sta_info_destroy_addr() gets called only after
> ieee80211_send_deauth_disassoc().

 
> -static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata)
> +static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
> +				   int remove_sta)

bool?

Other than that I think it looks fine, although I'm having second
thoughts about the _existing_ ordering of the driver config calls there,
but that's not something that this patch affects now, so it should be
fine until we find out in the future that it's bad for some driver and
we need to fix it, in which case we'll have to come up with an idea
then :)

johannes

