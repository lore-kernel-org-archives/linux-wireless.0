Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaBUJzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 04:55:38 -0500
Message-ID: <1392976535.4346.46.camel@jlt4.sipsolutions.net> (sfid-20140221_105543_945352_4EA62A42)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	John Linville <linville@tuxdriver.com>
Date: Fri, 21 Feb 2014 10:55:35 +0100
In-Reply-To: <CALhHN=ovcEvFsYSjc_dZSS0j0Zmiq-y6y2Kwo5RK1Qpb456MbQ@mail.gmail.com> (sfid-20140221_104707_819431_E0E761C3)
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1392972748.4346.37.camel@jlt4.sipsolutions.net>
	 <CALhHN=ovcEvFsYSjc_dZSS0j0Zmiq-y6y2Kwo5RK1Qpb456MbQ@mail.gmail.com>
	 (sfid-20140221_104707_819431_E0E761C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 10:47 +0100, Janusz Dziedzic wrote:
> On 21 February 2014 09:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:
> >
> >> +++ b/include/net/regulatory.h
> >> @@ -155,6 +155,7 @@ struct ieee80211_reg_rule {
> >>       struct ieee80211_freq_range freq_range;
> >>       struct ieee80211_power_rule power_rule;
> >>       u32 flags;
> >> +     u32 dfs_cac_ms;
> >>  };
> >
> > Does that really have to be per channel? That's a significant investment
> > into bss size since we have a lot of channel structs.
> >
> This seems easiest way to handle ETSI VHT80/40 case for channels with
> different CAC time (eg):
> VHT80:
> - 116 (60s)
> - 120 (600s)
> - 124 (600s)
> - 128 (600s)
> 
> VHT40/HT40:
> - 132 (600s)
> - 136 (60s)

Huh, but you don't distinguish between channel widths in this whole
patchset?

johannes

