Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41622 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbbAPMSa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 07:18:30 -0500
Message-ID: <1421410704.9214.10.camel@sipsolutions.net> (sfid-20150116_131833_191959_4565E6E2)
Subject: Re: [RFCv2 6/6] mac80211: IBSS setup correctly BW for VHT
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Jan 2015 13:18:24 +0100
In-Reply-To: <CALhHN=pkvz9qiQNWvXF6xwfhpmmhbUaW0PVnOWDhgWYT0nVY=w@mail.gmail.com> (sfid-20150116_130825_163251_43ACF8D0)
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421404724-32326-6-git-send-email-janusz.dziedzic@tieto.com>
	 <1421405703.9214.4.camel@sipsolutions.net>
	 <CALhHN=pkvz9qiQNWvXF6xwfhpmmhbUaW0PVnOWDhgWYT0nVY=w@mail.gmail.com>
	 (sfid-20150116_130825_163251_43ACF8D0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-16 at 13:08 +0100, Janusz Dziedzic wrote:
> On 16 January 2015 at 11:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2015-01-16 at 11:38 +0100, Janusz Dziedzic wrote:
> >
> >> +                             /* we both use VHT */
> >> +                             struct ieee80211_vht_cap vhtcap_ie;
> >> +                             struct ieee80211_sta_vht_cap vht_cap = sta->sta.vht_cap;
> >> +
> >> +                             ieee80211_vht_oper_to_chandef(channel,
> >> +                                                           elems->vht_operation,
> >> +                                                           &chandef);
> >
> > Ok maybe I'm missing something - but can't this erroneously configure
> > the local HW to 160 MHz when it doesn't even support it, or so?
> >
> I will check this more. But seems chandef (sta chandef) is a local
> variable here, not used by the way.
> So, our chandef is form cfg80211 (sdata->u.ibss.chandef) and we don't
> change this.
> Orginaly this sta chandef was used to compare with ibss->chandef.
> 
> -                       if (chandef.center_freq1 !=
> -                           sdata->u.ibss.chandef.center_freq1)
> -                               htcap_ie.cap_info &=
> -
> cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
> 
> But for me this check seems as not needed, eg.
> We support VHT80 and other ibss have only HT40 support - so we will
> have different center_freq1 - but still could operate, while sta_add
> and correct rates for sta configured.
> One I think we could check here is, if our chandef and sta chandef overlap.
> 
> Anyway, I am not sure I understand your question correctly, you mean eg.
> we work in VHT80 mode and other ibss join in VHT160 mode? Does it
> really matter while we will use sta_add for this new V160 "station"
> and configure supported rates for this station?

Well like I said - I might not understand this correctly. But the
ieee80211_vht_oper_to_chandef() function doesn't - iirc - take into
account local capabilities. As a consequence, if a VHT160 station joins
the chandef might be 160 while we're only supporting 80?

But anyway - I see that at least what I originally thought was wrong -
this code isn't concerned with picking up the channel from the peer to
join the networks together, I guess. That's what I was worried about.
That code I haven't seen and checked though - so perhaps you can look
there if it correctly handles trying to form a network when the peer has
higher capabilities than the local hw.

johannes

