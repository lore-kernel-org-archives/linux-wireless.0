Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3JQLKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 07:10:46 -0400
Message-ID: <1382008241.14391.3.camel@jlt4.sipsolutions.net> (sfid-20131017_131057_033516_ED55BCA7)
Subject: Re: [PATCH 3.12] mac80211: disable WMM with invalid parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@meshcoding.com>
Date: Thu, 17 Oct 2013 13:10:41 +0200
In-Reply-To: <CAB3XZEff+Xguf_Bk7p4S2N3j03dT1tB0u1u8enP4cd8NtD2jnA@mail.gmail.com> (sfid-20131017_114158_553482_DD73D54A)
References: <1381995881-16935-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEff+Xguf_Bk7p4S2N3j03dT1tB0u1u8enP4cd8NtD2jnA@mail.gmail.com>
	 (sfid-20131017_114158_553482_DD73D54A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 11:41 +0200, Eliad Peller wrote:

> > +               do {
> > +                       wp = cfg80211_find_vendor_ie(0x0050F2, 2, start, len);
> > +                       start = wp;
> > +                       len -= wp[1];
> you might NULL deref here.
> but i don't really see how this calculation makes sense anyway (you
> should probably increase start and take care of the  ie's id+len (i.e.
> wp[1] + 2) as well)?

Yeah, that loop was pretty bogus ...

while (true) {
        wp = cfg80211_find_vendor_ie(
                WLAN_OUI_MICROSOFT,
                WLAN_OUI_TYPE_MICROSOFT_WMM,
                start, len);
        if (!wp)
                break;
        start = wp;
        len -= wp[1] + 2;
        /* if this IE is too short, try the next */
        if (wp[1] <= 4)
                continue;
        /* if this IE is WMM params, we found what we wanted */
        if (wp[6] == 1)
                break;
}

is better, I think?

johannes

