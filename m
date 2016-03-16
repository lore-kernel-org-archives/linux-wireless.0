Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fbr01-uk.csee.siteprotect.eu ([81.3.27.131]:40042 "EHLO
	fbr01-uk.csee.siteprotect.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932327AbcCPJxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 05:53:19 -0400
Received: from smtpauth01-uk.csee.siteprotect.eu (unknown [192.168.22.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "smtp.securepod.com", Issuer "RapidSSL SHA256 CA - G3" (not verified))
	by fbr01-uk.csee.siteprotect.eu (Postfix) with ESMTPS id E42DF417F3
	for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 10:53:15 +0100 (CET)
Received: from Authenticated sender: roger@beardandsandals.co.uk
	by smtpauth01-uk.csee.siteprotect.eu (Postfix) with ESMTPSA id C864B40622
	for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 10:53:15 +0100 (CET)
To: linux-wireless@vger.kernel.org
From: Roger James <roger@beardandsandals.co.uk>
Subject: Re: The mac80211 softmac driver subsystem and handling of monitor
 interfaces
Message-ID: <56E92D0A.9090905@beardandsandals.co.uk> (sfid-20160316_105322_529591_4414BB8B)
Date: Wed, 16 Mar 2016 09:53:14 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 Mar 2016 13:08, Johannes Berg <johannes@sipsolutions.net> wrote:
 >
 > On Tue, 2016-03-15 at 13:01 +0000, Roger James wrote:
 > >
 > > roger@dragon:~/linux-mainline$ find . -name "*.[ch]" -exec grep -n
 > > IEEE80211_HW_WANT_MONITOR_VIF {} \; -print
 > > 1851: * @IEEE80211_HW_WANT_MONITOR_VIF: The driver would like to be
 > > informed of
 > > 1928:    IEEE80211_HW_WANT_MONITOR_VIF,
 > > ./include/net/mac80211.h
 > >
 > > Is that what you meant. Nobody seems to be using it. Even mac80211
 > > itself. Or am I being stupid again :-)
 > >
 >
 > There are macros generating the checks and setting it, so you want to
 > grep without the IEEE80211_HW_ prefix
 >
 > johannes
 > --


Thanks guys I have got it now.

However that only accounts for the ath10k, iwldvm, and iwlmvm drivers. I 
realise that there is a lot of history here, but is what the remaining 
drivers doing in any way deprecated? Also can anyone give me a heads up 
on what the architectural difference is between hooking the monitor 
config change and and setting the want monitor flag. Is one way 
preferable to the other? Both seem to inform the driver that there is a 
transition between having no monitor virtual interfaces and having one 
or more.

Cheers,

Roger
