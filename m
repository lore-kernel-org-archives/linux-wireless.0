Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbXLWLfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 06:35:18 -0500
Message-ID: <20071223123517.17ds9zttxc4goo00@imap.suse.de> (sfid-20071223_113525_741406_FE8CAA3D)
Date: Sun, 23 Dec 2007 12:35:17 +0100
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Restore rx.fc before every invocation of
	ieee80211_invoke_rx_handlers
References: <200712211516.35731.hschaa@suse.de>
	(sfid-20071221_141215_108356_0F4BE6F7)
	<1198401880.4116.6.camel@johannes.berg>
In-Reply-To: <1198401880.4116.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am So 23 Dez 2007 10:24:39 CET schrieb Johannes Berg  
<johannes@sipsolutions.net>:

>
> On Fri, 2007-12-21 at 15:16 +0100, Helmut Schaa wrote:
>> This patch fixes a problem with rx handling on multiple interfaces.  
>>  Especially
>> when using hardware-scanning and a wireless driver (i.e. iwlwifi) which is
>> able to receive data while scanning.
>
> Can you explain how you even got multiple interfaces with iwlwifi? The
> patch looks (superficially) correct, but I'm a bit confused.

I was only referring to wmaster0 and wlan0 as two interfaces. While a scan
is in progress the master interface (wmaster0) processes all frames related
to scanning and it happened to me that data-frames got dropped on wmaster0
(which is obviously correct) and due to the frame control being modified
wlan0 was not able to process the frame correctly anymore.

Helmut
