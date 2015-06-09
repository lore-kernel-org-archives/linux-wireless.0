Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54886 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbbFIUIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:08:43 -0400
Message-ID: <1433880520.1892.23.camel@sipsolutions.net> (sfid-20150609_220846_740600_AD02C8C9)
Subject: Re: [PATCH V3] mac80211: minstrel_ht: Handle Dynamic SMPS state of
 the peer.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Tue, 09 Jun 2015 22:08:40 +0200
In-Reply-To: <1433355732-7604-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150603_202236_334025_F60E3C28)
References: <1433355732-7604-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20150603_202236_334025_F60E3C28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-03 at 23:52 +0530, Chaitanya T K wrote:
> In case of Dynamic SMPS enable RTS/CTS for all rates.

> +	/* Enable RTS/CTS for below cases.
> +	 * 1) Handle STA's SMPS State, if Nss > 1.
> +	 *    a. Use RTS_CTS, if STA is in Dynamic SMPS Mode
> +	 *    b. Mark Nss > 1 as unsupported, if STA is in static SMPS mode
> +	 * 2) 2nd and 3rd Rates, as 1st Rate Failed.
> +	 */
> +	if ((mi->sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
> +	     group->streams > 1) ||
> +	     offset > 0) {

Indent still isn't right - the line starting with "offset" should be
indented one less. Might also be worthwhile to just reorder the
condition to first check for offset > 0?

I was about to do that and apply this, but it seems the comment doesn't
make sense since you're not doing 1b. afaict?

johannes

