Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36672 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966629AbXFHC44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 22:56:56 -0400
Message-ID: <4668C577.4030008@lwfinger.net>
Date: Thu, 07 Jun 2007 21:56:55 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706071819.45603.flamingice@sourmilk.net>
In-Reply-To: <200706071819.45603.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 07 June 2007 17:43, Larry Finger wrote:
>> +	if (sdata->type == IEEE80211_IF_TYPE_STA) {
>> +		sta = sta_info_get(local, sdata->u.sta.bssid);
>> +		if (sta) {
>> +			sta->txrate = sdata->u.ap.max_ratectrl_rateidx;
> This is automatically set as soon as the next frame is TXed, as said before in 
> the previous review.

When I leave this part out, the rate _NEVER_ gets set, no matter what you say. My experiments say 
that it is needed.

Larry
