Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:46738 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYBYUsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 15:48:06 -0500
Received: by wr-out-0506.google.com with SMTP id c48so2700010wra.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 12:48:02 -0800 (PST)
Subject: Re: [PATCH 07/13 v2] o11s: changes to ieee80211_sta
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203697317.7082.68.camel@johannes.berg>
References: <47be773d.22b38c0a.2fbf.ffffb131@mx.google.com>
	 (sfid-20080222_074745_247391_EDD9C862)  <1203697317.7082.68.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 12:49:40 -0800
Message-Id: <1203972580.6929.74.camel@localhost> (sfid-20080225_204809_197216_D9B98B8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 17:21 +0100, Johannes Berg wrote:
> > +	atomic_inc(&bss->users);
> > +	atomic_inc(&bss->users);
> 
> ?
> That was just allocated, shouldn't it just be atomic_set() then? And why
> two anyway?

I was following the behavior in ieee80211_rx_bss_add(), where the same
thing is done. It is needed to to avoid the bss being freed on the next
ieee80211_rx_bss_put(), works as a reference count. Agree that
atomic_set() would be better.


> > +			memset(&iwe, 0, sizeof(iwe));
> > +			iwe.cmd = IWEVCUSTOM;
> > +			sprintf(buf, "Mesh network (version %d)\n"
> > +			"\t\t\tPath Selection Protocol ID: 0x%02X%02X%02X%02X\n"
> > +			"\t\t\tPath Selection Metric ID: 0x%02X%02X%02X%02X\n"
> > +			"\t\t\tCongestion Control Mode ID: 0x%02X%02X%02X%02X\n"
> > +			"\t\t\tChannel Precedence: 0x%02X%02X%02X%02X",
> 
> Maybe we should add separate items for this to make it easier to parse
> them?

Ok, will include that too.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


