Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:27685 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbZJSJTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 05:19:03 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] libertas: remove unused 11d code
Date: Mon, 19 Oct 2009 11:18:39 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <200910190940.52830.hs4233@mail.mn-solutions.de> <43e72e890910190136s21703864i3002f2a31f940111@mail.gmail.com>
In-Reply-To: <43e72e890910190136s21703864i3002f2a31f940111@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910191118.39975.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Is the countryinfo->countrycode not usable for
> regulatory_hint_11d() ? 

I guess so, but the libertas+cfg80211 patch hasn't yet landed.

And if it lands, it will have a WAY simpler 11d coding than 
before:

1. get the region code out of the EEPROM, convert it, call call 
regulatory_hint_11d().

2. no need to parse the scan result IE for a WLAN_EID_COUNTRY, 
because cfg80211 does this for us

3. no need to parse the association response either, because 
cfg80211 does this for us

4. no need to store special channel settings, because cfg80211 
does this for us


At least this is how I understand it based on my current 
region-handling knowledge of cfg80211, which isn't too deep.

-- 
http://www.holgerschurig.de
