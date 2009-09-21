Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp149.mail.ukl.yahoo.com ([77.238.184.80]:29784 "HELO
	smtp149.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750933AbZIUQLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 12:11:43 -0400
Message-ID: <4AB7A5BB.1050300@yahoo.es>
Date: Mon, 21 Sep 2009 18:11:39 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: Problems with "cfg80211: fix SME connect" commit
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com> <200909210845.51247.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909210845.51247.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
> Can you try "[PATCH] cfg80211: don't overwrite privacy setting" 
> from [1]?
> 
> [1] http://marc.info/?l=linux-wireless&m=125323296617306&w=2
> 
> 
> And can you use the mailing list archives?  This is now the third 
> time this poppep up, I just copied Sedat's mail for you.
> 

Hi,

Thanks for the information.

Adding back "cfg80211: fix SME connect" and applying "cfg80211: don't overwrite privacy setting" fixes the connection issue, but with a introduces a small difference vs the previous working version.
There is now an extra "deauthenticating by local choice (reason=3)" message in the logs.

* master-20090914

[   13.222940] b43-phy0 debug: Chip initialized
[   13.291359] b43-phy0 debug: PIO initialized
[   13.330116] b43-phy0 debug: QoS disabled
[   13.861636] b43-phy0 debug: Wireless interface started
[   13.969153] b43-phy0 debug: Adding Interface type 2
[   16.679249] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
[   16.700998] wlan1 direct probe responded
[   16.707013] wlan1: authenticate with AP 00:12:17:15:e7:79 (try 1)
[   16.720205] wlan1: authenticated
[   16.726261] wlan1: associate with AP 00:12:17:15:e7:79 (try 1)
[   16.740697] wlan1: RX AssocResp from 00:12:17:15:e7:79 (capab=0x431 status=0 aid=1)
[   16.758042] wlan1: associated

* master-20090916 + "cfg80211: don't overwrite privacy setting"

[   12.849778] b43-phy0 debug: Chip initialized
[   12.865561] b43-phy0 debug: PIO initialized
[   12.872482] b43-phy0 debug: QoS disabled
[   13.053373] b43-phy0 debug: Wireless interface started
[   13.218613] b43-phy0 debug: Adding Interface type 2
[   15.832582] wlan1: deauthenticating by local choice (reason=3)
[   16.131599] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)
[   16.145589] wlan1 direct probe responded
[   16.154501] wlan1: authenticate with AP 00:12:17:15:e7:79 (try 1)
[   16.175640] wlan1: authenticated
[   16.181829] wlan1: associate with AP 00:12:17:15:e7:79 (try 1)
[   16.198990] wlan1: RX AssocResp from 00:12:17:15:e7:79 (capab=0x431 status=0 aid=1)
[   16.210791] wlan1: associated

Any comments on this?

Thanks,
Albert
