Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:15216 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXLYLfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 06:35:41 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1875036rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2007 03:35:40 -0800 (PST)
Message-ID: <c85cb4470712250335h4548d8acwfd99c6df27122300@mail.gmail.com> (sfid-20071225_113546_970070_D746C157)
Date: Tue, 25 Dec 2007 13:35:40 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8 v2] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198579169.4103.51.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435613464-git-send-email-ron.rindjunsky@intel.com>
	 <1198170867.16241.56.camel@johannes.berg>
	 <c85cb4470712250208y29318fb6w2d140d00c3e02933@mail.gmail.com>
	 <1198579169.4103.51.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > No, and it should be done.
> > were would you recommend to put this tear down? i need a flow were i
> > can be sta specific, and is called only once per ifdown.
> > sta_info_release related flow, were i thought to put it, is risking me
> > with endless loops of kref_put calls.
>
> That's actually an interesting question. We should, like with keys,
> remove all STA info from the driver when the corresponding interface is
> down. I'd think it should happen at the same time. I guess you'll have
> to add some sort of loop to tear down stations to the down code, I don't
> really see any easy way right now.
>

what about list_for_each_entry sta inside ieee80211_stop to stop the
session?  i tried it and it worked really well.

> johannes
>
>
