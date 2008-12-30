Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:65483 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYL3KmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 05:42:06 -0500
Received: by ti-out-0910.google.com with SMTP id b6so8035094tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 02:42:04 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18777.64102.60878.194252@localhost.localdomain> (sfid-20081230_114212_248154_D4315B76)
Date: Tue, 30 Dec 2008 16:09:34 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jouni.malinen@atheros.com
Subject: Re: [RFC v2] mac80211: Add 802.11h CSA support
In-Reply-To: <1230633305.3850.2.camel@johannes>
References: <18777.63336.140527.717269@localhost.localdomain>
	<1230633305.3850.2.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> We already have a bss pointer here, would it be better to pass that in,
> avoid the bss lookup, and do the bss lookup manually in the action frame
> case, to avoid a double lookup here?
> 

We don't have a bss pointer in ieee80211_rx_h_action(), where CSA
action frames are handled too.

> Didn't you want to put this into the workqueue?

Calling ieee80211_hw_config() from the timer was problematic since
drivers might use a mutex, this won't matter.
But if it makes things clearer, I can add it to the workqueue here too.

Sujith
