Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56109 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab1CYI1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 04:27:16 -0400
Received: by bwz15 with SMTP id 15so729987bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2011 01:27:15 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Fri, 25 Mar 2011 09:25:26 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <201103232358.29966.helmut.schaa@googlemail.com> <1300987930.26265.6.camel@jlt3.sipsolutions.net> <AANLkTi=mFbtLbQwNX6ZnzW9_xn_CYUBvv98z3-ZT9uf0@mail.gmail.com>
In-Reply-To: <AANLkTi=mFbtLbQwNX6ZnzW9_xn_CYUBvv98z3-ZT9uf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103250925.26216.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 24. März 2011 schrieb Emmanuel Grumbach:
> The originator tried to send data and this data didn't get acked. In
> this case a BAR should be sent regardless the reason why this frame
> didn't get acked.
> This is done by reporting IEEE80211_TX_STAT_AMPDU_NO_BACK to mac80211.
> Can it be that the rt2800 doesn't report properly the xmit failure ?

Good point. During "normal" operation rt2800 correctly sets
IEEE80211_TX_STAT_AMPDU_NO_BACK on a failure, so it _should_ have done
this in the above example but I'll add some more debug output and verify
this again.

Helmut
