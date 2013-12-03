Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3LCMre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 07:47:34 -0500
Message-ID: <1386074851.4393.8.camel@jlt4.sipsolutions.net> (sfid-20131203_134737_641541_F8D5ECF5)
Subject: Re: [PATCH 2/2 V3] mac80211: Update opmode during adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Dec 2013 13:47:31 +0100
In-Reply-To: <1386061500-5750-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131203_100534_968939_7F496576)
References: <1386061500-5750-1-git-send-email-marek.kwaczynski@tieto.com>
	 <1386061500-5750-2-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20131203_100534_968939_7F496576)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 10:05 +0100, Marek Kwaczynski wrote:

> -void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
> -				 struct sta_info *sta, u8 opmode,
> -				 enum ieee80211_band band, bool nss_only)
> +int ieee80211_vht_recalc_handle_opmode(struct ieee80211_sub_if_data *sdata,
> +				       struct sta_info *sta, u8 opmode,
> +				       enum ieee80211_band band, bool nss_only,
> +				       u32 *changed)

Err, why don't you just return a u32 with the change flags?

johannes

