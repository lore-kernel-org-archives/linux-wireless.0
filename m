Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fbr02-uk.csee.siteprotect.eu ([81.3.27.132]:38396 "EHLO
	fbr02-uk.csee.siteprotect.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbcCONB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 09:01:27 -0400
Received: from smtpauth02-uk.csee.siteprotect.eu (unknown [192.168.22.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "smtp.securepod.com", Issuer "RapidSSL SHA256 CA - G3" (not verified))
	by fbr02-uk.csee.siteprotect.eu (Postfix) with ESMTPS id 45FFA40EFA
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2016 14:01:24 +0100 (CET)
Received: from Authenticated sender: roger@beardandsandals.co.uk
	by smtpauth02-uk.csee.siteprotect.eu (Postfix) with ESMTPSA id 2BD6B405F4
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2016 14:01:24 +0100 (CET)
Subject: Re: The mac80211 softmac driver subsystem and handling of monitor
 interfaces
To: linux-wireless@vger.kernel.org
References: <56E7E707.2050900@beardandsandals.co.uk>
 <1458044118.2871.1.camel@sipsolutions.net>
From: Roger James <roger@beardandsandals.co.uk>
Message-ID: <56E807A3.4010907@beardandsandals.co.uk> (sfid-20160315_140130_234604_B5549BBB)
Date: Tue, 15 Mar 2016 13:01:23 +0000
MIME-Version: 1.0
In-Reply-To: <1458044118.2871.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/03/16 12:15, Johannes Berg wrote:
> On Tue, 2016-03-15 at 10:42 +0000, Roger James wrote:
>
>> ath/ath10k ath/ath9k (both ath9k and ath9k_htc) cw1200
>> brcm80211/brcmsmac
>>
>> All the others seem to be doing things with NL80211_IFTYPE_MONITOR in
>> the vif structure. This seems contradictory.
>>
> You should look into the WANT_MONITOR flag. :)
>
> johannes
> --
>
Hmm...

roger@dragon:~/linux-mainline$ find . -name "*.[ch]" -exec grep -n 
IEEE80211_HW_WANT_MONITOR_VIF {} \; -print
1851: * @IEEE80211_HW_WANT_MONITOR_VIF: The driver would like to be 
informed of
1928:    IEEE80211_HW_WANT_MONITOR_VIF,
./include/net/mac80211.h

Is that what you meant. Nobody seems to be using it. Even mac80211 
itself. Or am I being stupid again :-)



Roger
