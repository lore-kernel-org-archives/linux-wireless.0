Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:30413 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbXLRNqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:46:11 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2065102fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 05:46:11 -0800 (PST)
Message-ID: <c85cb4470712180546x42217cbdjb7cb6457884b55fe@mail.gmail.com> (sfid-20071218_134617_820733_4CC8519D)
Date: Tue, 18 Dec 2007 15:46:10 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 7/8] mac80211: A-MPDU Rx handling DELBA requests
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197915987.4885.95.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070791111-git-send-email-ron.rindjunsky@intel.com>
	 <1197915987.4885.95.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +
> > +     if (initiator == WLAN_BACK_INITIATOR)
> > +             ieee80211_sta_stop_rx_BA_session(dev, sta->addr, tid,
> > +                                              WLAN_BACK_INITIATOR, 0);
>
> Does this intentionally ignore the other cases, and if so, why?
>

yes, i am handling only Rx A-MPDU, so only initiator of the session
can send us delBA
