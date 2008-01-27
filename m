Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:35604 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYA0RZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 12:25:48 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1428003rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 09:25:47 -0800 (PST)
Message-ID: <c85cb4470801270925g49203959l7fd7b35f472d9e73@mail.gmail.com> (sfid-20080127_172550_566081_C9EA53C5)
Date: Sun, 27 Jan 2008 19:25:47 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 03/12] mac80211: A-MPDU Tx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1201167281.3454.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163393182-git-send-email-ron.rindjunsky@intel.com>
	 <1201167281.3454.65.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +     /* Will put all the packets in the new SW queue */
> > +     /* ieee80211_requeue(local, ieee802_1d_to_ac[tid]); */
> > +     spin_unlock_bh(&local->mdev->queue_lock);
> > +
> > +     /* We have most probably almost emptied the legacy queue */
> > +     /* ieee80211_wake_queue(local_to_hw(local), ieee802_1d_to_ac[tid]); */
>
>
> Can't you re-order the patches instead? Or, if it simply doesn't work,
> I'd much prefer them to go into the tree as a single patch. (You also
> introduced leading whitespace in the patches removing the comment marks)
>

No problems, i'll make patches 0003 and 0006 consequent, but i think
it is better they will stay a part for better reading, as they touch
different parts in the code, and patch 0003 is big enough as it is.
I'll remove the whitespaces.

> johannes
>
>
