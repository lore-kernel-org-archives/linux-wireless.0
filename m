Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:46401 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbXLYOlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 09:41:51 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1911681rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2007 06:41:50 -0800 (PST)
Message-ID: <c85cb4470712250641x5ce48795we77243c082bd1314@mail.gmail.com> (sfid-20071225_144156_582903_1DFFCC1E)
Date: Tue, 25 Dec 2007 16:41:50 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8 v2] mac80211: A-MPDU Rx handling aggregation reordering
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198587069.4103.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435613464-git-send-email-ron.rindjunsky@intel.com>
	 <1198170867.16241.56.camel@johannes.berg>
	 <c85cb4470712250208y29318fb6w2d140d00c3e02933@mail.gmail.com>
	 <1198579169.4103.51.camel@johannes.berg>
	 <c85cb4470712250335h4548d8acwfd99c6df27122300@mail.gmail.com>
	 <1198587069.4103.65.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > what about list_for_each_entry sta inside ieee80211_stop to stop the
> > session?  i tried it and it worked really well.
>
> Sounds about right, you just need to make sure that you have the right
> locks and only tear down sessions for the virtual interface that's being
> stopped, not all if you have sessions on different virtual interfaces
> (say on a multi-BSS AP when one BSS is stopped)

ok. i not sure i got it all the way right, but it is in the patch.
As i don't want to hold the whole series any more, i am sending the
series over, and if this specific issue is not well i'll issue only a
patch for it.
thanks
ron

>
> johannes
>
>
