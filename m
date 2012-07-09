Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40569 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854Ab2GIKn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 06:43:28 -0400
Message-ID: <4FFAB5CF.6080400@net.t-labs.tu-berlin.de> (sfid-20120709_124331_977674_415BD219)
Date: Mon, 09 Jul 2012 12:43:27 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add transmit power control support (TPC)
References: <1341766968-29570-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  (sfid-20120708_190314_897831_DE794B3E) <1341826631.4455.24.camel@jlt3.sipsolutions.net>  (sfid-20120709_113745_588565_D68A59A8) <1341828786.4455.31.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341828786.4455.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:

> On Mon, 2012-07-09 at 11:37 +0200, Johannes Berg wrote:
> 
>>> (6) restructure tx-path of all effected drivers
>>> Restructure tx-path of all effected drivers to respect new TPC support in
>>> mac80211. TPC support is added to mac80211 by restructuring of struct
>>> ieee80211_tx_info. Therfore the tx-path of all effected drivers is modified
>>> to receive struct sta from the stack and respect the new ieee80211_tx_info
>>> struct. List of modified driver:
>> again, separate these patches.
> 
> Oh and I don't mean split it per driver. Just split up the patch into
> the logical API evolutions, like first removing the sta pointer and
> introducing the tx_control struct. (Where, btw, you lost an important
> comment about it being NULL along the way)


Hi Johannes,

>From the comments so far, I will split this patch into:

-keeping the brcmsmac patch that was send earlier (I thought it is as
single patch out of context if not combined with the goal to add tpc)

-send one single new patch to remove the sta pointer from ieee_tx_info
including all driver changes to respect this. (as each patch should not
break a kernel build, I guess all of this must come in one patch)

-after that introduce the TPC stuff in a separate patch series (where I
address the comments that where already given)

Greetings Thomas
