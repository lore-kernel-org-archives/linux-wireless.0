Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2CWIhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 04:37:16 -0400
Message-ID: <1332491831.3506.1.camel@jlt3.sipsolutions.net> (sfid-20120323_093727_320460_7F632E3A)
Subject: Re: [RFC 03/12] mac80211: prepare ieee80211_frame_duration to
 per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2012 09:37:11 +0100
In-Reply-To: <5bd587b9-bc1e-4b91-b4a7-37db67681946@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154013_005213_D7DD082B)
References: <5bd587b9-bc1e-4b91-b4a7-37db67681946@FIVLA-EXHUB02.eu.tieto.com>
	 (sfid-20120320_154013_005213_D7DD082B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 09:39 +0100, Michal Kazior wrote:
> In preparation for multi-channel operation.
> 
> Ath5k driver needs to be fixed. It uses
> ieee80211_generic_frame_duration() through ath5k_hw_get_frame_duration()
> which itself and it's parent callers have no access (except
> bss_info_changed handler) to sdata pointer.
> 
> This requires us to preserve ieee80211_local pointer in the argument
> list of ieee80211_generic_frame_duration.
> 
> I think we should get rid of ieee80211_local pointer eventually from
> here, but to do that we need to deal with ath5k first.

I think we should just pass the band instead of the local pointer. Then
ath5k would be trivial to fix too (band info is part of TX info).

johannes

