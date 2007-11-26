Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:57781 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217AbXKZQuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:50:44 -0500
Received: by ug-out-1314.google.com with SMTP id z38so965060ugc
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 08:50:42 -0800 (PST)
Message-ID: <474AF95E.1070608@gmail.com> (sfid-20071126_165114_712766_2DC09D23)
Date: Mon, 26 Nov 2007 17:50:38 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
References: <47494851.4070504@gmail.com>	 (sfid-20071125_100303_057404_A213DFC8) <1195987773.4149.214.camel@johannes.berg>	 <474955E1.30603@gmail.com>	 (sfid-20071125_110054_527140_84EF41E2)  <1196079245.4149.255.camel@johannes.berg>	 <1196093064.4202.46.camel@localhost.localdomain> <1196093663.4149.285.camel@johannes.berg>
In-Reply-To: <1196093663.4149.285.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> Because in the case of hidden SSIDs, wpa_supplicant pretty much says to
>> use ap_scan=2.
>>
>> There are a few problems here:
>>
>> 1) Historically, some drivers worked better with ap_scan=1 (madwifi),
>> others worked better with ap_scan=2 (many fullmac drivers)
>>
>> 2) scan_ssid=1 hasn't worked consistently on all drivers because it's
>> pretty new and many drivers don't support it yet.  This is supposed to
>> make the driver/firmware send out probe request for the SSID in
>> question.
>>
>> So basically, we're up shit creek without a paddle.  You have to use
>> ap_scan=2 on some cards because they don't support specific-ssid
>> scanning (with scan_ssid=1) to find the BSS you want to connect to, but
>> some cards can handle ap_scan=1+scan_ssid=1 OK.
>>     
>
> Fun. I'm pretty sure mac80211 handles ap_scan=1/scan_ssid=1 fine,
> sending probe requests for that specific SSID.
>
>   
yes it does an work fine that way. but ap_scan=2 = no go.
I can get some logs tomorrow for you.
If I remeber correctly wpa_supplicant just says "Got X scan results" and 
never find the ssid asked for.
>> NM has logic to cache the BSSIDs of APs you've connected to before, and
>> to match those up with an SSID when it sees them in the scan list if the
>> AP isn't broadcasting the SSID.  Unfortunately, that information isn't
>> available to wpa_supplicant because wpa_supplicant doesn't have an
>> interface to handle that sort of thing.  Therefore, when faced with an a
>> request to connect to a hidden network, wpa_supplicant must rely
>> _entirely_ on the driver Doing The Right Thing with scan_ssid=1 or
>> ap_scan=2, and that almost never works due to inconsistency in driver
>> implementation.
>>     
>
> Who invented hidden SSIDs anyway? Well, I guess I can actually test this
> now that I finally have a second mac80211-based wireless card, although
> iwl4965 is special wrt. scanning. I guess the trick will be to make
> ap_scan=2 work although ap_scan=1/scan_ssid=1 works much better :(
>
>   
well a "fix" would be for nm to try ap_scan=2 when it fails fall back to 
ap_scan=1 + scan_ssid=1 bt thats nothing more than a hack.
> We can fix that in nl80211 by making sure that scan_ssid is implemented
> right away and whoever has nl80211 support needs to support that so that
> we can rely on it...
>   
yes that should finally fix it ... but until then we need something that 
works.

