Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:47370 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbaBYOOA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 09:14:00 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v1 2/6] mac80211: move flag IEEE80211_TX_CTL_FIRST_FRAGMENT into info->control.flags
From: =?windows-1252?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1393244741.4190.10.camel@jlt4.sipsolutions.net>
Date: Tue, 25 Feb 2014 15:13:54 +0100
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Message-Id: <E84199A1-4743-47E5-AD95-D86998FD8DEA@net.t-labs.tu-berlin.de> (sfid-20140225_151404_272716_F267E029)
References: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1393164527-13800-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <1393244741.4190.10.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> On Sun, 2014-02-23 at 15:08 +0100, Thomas Huehn wrote:
>> Flag IEEE80211_TX_CTL_MORE_FRAMES is only used within the tx path while
>> ieee80211_tx_info->control is valid. Therefore this patch moves this flag
>> from info->flags structure into the info->control.flags and renames it to
>> IEEE80211_TX_CTRL_FIRST_FRAGMENT. Define new IEEE80211_TX_TEMPORARY_CTRL_FLAGS
>> to clear all temporary flags that are shifted to info->control.flags.
> 
> Similar to before... this can't be right, you have to assume
> info->control.flags is cleared when you get status data, which is in
> fact a problem in the first patch already, but here the clearing of
> „temporary" flags is quite wrong.

ok… will send v2

> At least temporary flags don't suffer from the 'getting lost' problem as
> in the first patch.
> 
> I'll also note that this flag is treated wrongly in software retry
> scenarios anyway, but it won’t really matter I guess.

Do you mean the case when fragments after the first one get retransmitted by software ?

Greetings Thomas