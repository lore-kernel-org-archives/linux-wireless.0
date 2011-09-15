Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab1IOJSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:18:07 -0400
Subject: Re: [PATCH] cfg80211: add cfg80211_find_vendor_ie() function
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEeLcXCdk7LBBNqqCeQJ84v0Fxv1JqtOUcBU8CBHjipMHw@mail.gmail.com> (sfid-20110915_111007_676383_67DD6DD3)
References: <1316076781-12580-1-git-send-email-eliad@wizery.com>
	 <1316077390.3992.1.camel@jlt3.sipsolutions.net>
	 <CAB3XZEeLcXCdk7LBBNqqCeQJ84v0Fxv1JqtOUcBU8CBHjipMHw@mail.gmail.com>
	 (sfid-20110915_111007_676383_67DD6DD3)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 11:18:05 +0200
Message-ID: <1316078285.3992.2.camel@jlt3.sipsolutions.net> (sfid-20110915_111810_984280_2BBA993E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 12:09 +0300, Eliad Peller wrote:
> On Thu, Sep 15, 2011 at 12:03 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> +const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
> >> +                               const u8 *ies, int len)
> >> +{
> >> +     struct ieee80211_vendor_ie *ie;
> >> +     const u8 *pos = ies, *end = ies + len;
> >> +     int ie_oui;
> >> +
> >> +     while (pos < end) {
> >> +             pos = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, pos,
> >> +                                    end - pos);
> >> +             if (!pos)
> >> +                     return NULL;
> >> +
> >> +             if (end - pos < sizeof(*ie))
> >> +                     return NULL;
> >> +
> >> +             ie = (struct ieee80211_vendor_ie *)pos;
> >> +             ie_oui = ie->oui[0] << 16 | ie->oui[1] << 8 | ie->oui[2];
> >> +             if (ie_oui == oui && ie->oui_type == oui_type)
> >> +                     return pos;
> >> +
> >> +             pos += 2 + ie->len;
> >
> > I think it should also check that the whole IE including ie->len (not
> > just sizeof(*ie) fits into the buffer, before returning it. That is, add
> > something like
> >
> > if (end - pos < 2 + ie->len)
> >        return NULL;
> >
> > after the sizeof(*ie) check.
> >
> cfg80211_find_ie() already checks for it.

Oh, good point. Sorry for the interruption :)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

