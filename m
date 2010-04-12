Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0DLMfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 08:35:20 -0400
Subject: Re: Frame aggregation size configuration in 802.11n
From: Johannes Berg <johannes@sipsolutions.net>
To: Sneha Aggarwal <snehaatpec@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20100412T140919-620@post.gmane.org>
References: <loom.20100412T140919-620@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 14:35:16 +0200
Message-ID: <1271075716.23799.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 12:11 +0000, Sneha Aggarwal wrote:

> I am studying the effect of frame aggregation size on throughput for my project.
> Is there any direct command to change the aggregation size like iwconfig/iwpriv
> or something?

No.

> I have gone through the kernel code of aggregation from the file agg-tx.c from
> the linux-2.6.32.7 
> and the exact path is linux-2.6.32.7/net/mac80211/agg-tx.c
> The function which I have recognized to change the aggregation size is:
> ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata, const u8 *da,
> u16 tid, u8 dialog_token, u16 start_seq_num, u16 agg_size, u16 timeout)
> 
> I am wondering if this is the right place to change the parameter or not. 

No, it is not. This will just tell the peer what the max is that we
might send, I think.

> Or is
> there any other way to change this parameter without changing the kernel file
> directly? 

No.

> and where all I have to change this parameter to get the desired output?

That depends on your driver. In iwlwifi, you have to tell the microcode
what to do -- I'm not sure off hand how to (I know there is a parameter
that controls the number of frames in an aggregate, I'm not sure about
the max size but I would think it exists)

In ath9k you should be able to change it in the driver but I have no
idea how to.

> And I am planning to write of a piece of code to make this parameter available
> to the user to configure.

That will be interesting due to what I said above ...

johannes

