Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:58599 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbZJSXuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 19:50:00 -0400
Received: by iwn8 with SMTP id 8so2585332iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 16:50:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910191118.39975.hs4233@mail.mn-solutions.de>
References: <200910190940.52830.hs4233@mail.mn-solutions.de>
	<43e72e890910190136s21703864i3002f2a31f940111@mail.gmail.com>
	<200910191118.39975.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 20 Oct 2009 08:49:45 +0900
Message-ID: <43e72e890910191649m4ad89af9u4860a6d32d4ba154@mail.gmail.com>
Subject: Re: [PATCH] libertas: remove unused 11d code
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2009 at 6:18 PM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
>> Is the countryinfo->countrycode not usable for
>> regulatory_hint_11d() ?
>
> I guess so, but the libertas+cfg80211 patch hasn't yet landed.
>
> And if it lands, it will have a WAY simpler 11d coding than
> before:
>
> 1. get the region code out of the EEPROM, convert it, call call
> regulatory_hint_11d().
>
> 2. no need to parse the scan result IE for a WLAN_EID_COUNTRY,
> because cfg80211 does this for us
>
> 3. no need to parse the association response either, because
> cfg80211 does this for us
>
> 4. no need to store special channel settings, because cfg80211
> does this for us
>
>
> At least this is how I understand it based on my current
> region-handling knowledge of cfg80211, which isn't too deep.

Sounds right.

  Luis
