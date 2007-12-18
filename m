Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:26196 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbXLRNlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:41:45 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2063298fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 05:41:43 -0800 (PST)
Message-ID: <c85cb4470712180541l3427454ek94c66b14bb26cb4f@mail.gmail.com> (sfid-20071218_134150_560440_F036FC13)
Date: Tue, 18 Dec 2007 15:41:43 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/8] mac80211: A-MPDU Rx add MLME structures
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197914893.4885.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782201-git-send-email-ron.rindjunsky@intel.com>
	 <1197914893.4885.76.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> > +     struct sta_ampdu_mlme ampdu_mlme;
> > +     int timer_to_tid[STA_TID_NUM];  /* convert timer id to tid */
>
> Since you only use that as an identity mapping it can well be a u8
> array. Not that I like the trick used, but I don't see any good way to
> avoid it either.
>

yes... that was quite an irritating issue, had to use this kind of
mechanism here.
i will check changing type to u8 (need to exmine if it will cause any
addresses problems)
