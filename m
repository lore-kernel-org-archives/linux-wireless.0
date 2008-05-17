Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52917 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbYEQQuk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 12:50:40 -0400
Message-ID: <20080517185038.6w1m4n5n6s88ckgw@imap.suse.de> (sfid-20080517_185049_147497_B451CD53)
Date: Sat, 17 May 2008 18:50:38 +0200
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: NULL pointer in mac80211:ieee80211_associate
References: <482DFC63.7050908@lwfinger.net>
	<1210974434.6381.60.camel@johannes.berg> <482E1344.7080808@lwfinger.net>
	(sfid-20080517_010547_496161_3AD36B80)
	<1210979397.3827.4.camel@johannes.berg>
In-Reply-To: <1210979397.3827.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Sa 17 Mai 2008 01:09:57 CEST schrieb Johannes Berg  
<johannes@sipsolutions.net>:

>> > Can you try to find out what code this corresponds to?
>>
>>  From objdump with line numbers, it occurs at "for (i = 0; i <
>> bss->supp_rates_len; i++) {" in ieee80211_compatible_rates, which I think is
>> entered from ieee80211_send_assoc. It seems that bss is NULL. For testing, I
>> have placed a WARN_ON(!bss) statement just before the for loop.
>
> That looks plausible. Helmut, any ideas how to avoid this? Skip the
> compatible rates test completely and use all rates in this situation?

Yes, that's most likely the best solution for it. If we do not have a  
bss at this point we cannot adjust the rates anyway. Should I prepare  
a patch?

Helmut
