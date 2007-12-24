Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:51196 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXLXLtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 06:49:55 -0500
Message-ID: <20071224124952.mg253hxu888ocw4s@imap.suse.de> (sfid-20071224_115016_858975_14B84139)
Date: Mon, 24 Dec 2007 12:49:52 +0100
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
References: <200712211516.35731.hschaa@suse.de>
	(sfid-20071221_141215_108356_0F4BE6F7)
	<1198401880.4116.6.camel@johannes.berg>
	<20071223123517.17ds9zttxc4goo00@imap.suse.de>
	<1198417706.4000.1.camel@johannes.berg>
	<1198467294.3065.180.camel@debian.sh.intel.com>
	<1198491831.4103.17.camel@johannes.berg>
In-Reply-To: <1198491831.4103.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mo 24 Dez 2007 11:23:51 CET schrieb Johannes Berg  
<johannes@sipsolutions.net>:

>
>> The patch looks fine to me. Hardware scanning is a trigger that makes
>> the condition more likely to happen, the patch itself fixes the more
>> general problem for multiple interfaces.
>
> Yeah, I think so too.
>
>> An off-topic question: should wmaster0 continue to execute more rx
>> handlers (i.e ieee80211_rx_h_remove_qos_control) even if it knows it
>> will drop them finially?
>
> I don't think it does, does it? In prepare_for_handlers frames aren't
> sent to the master device while not scanning.

It does so only during a scan. In that case the frame gets first
dropped in ieee80211_rx_h_data on the master device.

Helmut
