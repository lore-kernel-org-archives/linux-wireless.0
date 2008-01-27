Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:35604 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYA0RY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 12:24:58 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1428003rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 09:24:57 -0800 (PST)
Message-ID: <c85cb4470801270924n647e83f4s6ac56154ef36dee8@mail.gmail.com> (sfid-20080127_172503_199737_EFB3CB4F)
Date: Sun, 27 Jan 2008 19:24:57 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 01/12] mac80211: A-MPDU Tx add session's and low level driver's API
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1201166631.3454.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163391152-git-send-email-ron.rindjunsky@intel.com>
	 <1201166631.3454.57.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >       int (*ampdu_action)(struct ieee80211_hw *hw,
> >                           enum ieee80211_ampdu_mlme_action action,
> > -                         const u8 *ra, u16 tid, u16 ssn);
> > +                         u8 *addr, u16 tid, u16 *ssn);
>
> Any reason you're removing the "const"?
>
> > +int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid);
>
> Maybe the other functions should instead use a const u8 *ra?
>

just because this touches many functions I'll check if this can be
done easily. even if not i can change it, leave a warning for const
type, and do a patch on top of this series to fix it.

> I don't have much to say about this patch really :)
>
> johannes
>
>
