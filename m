Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:42251 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbXIUWAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 18:00:47 -0400
Received: by py-out-1112.google.com with SMTP id u77so1791670pyb
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 15:00:46 -0700 (PDT)
Message-ID: <43e72e890709211500k741e7a8ai21f2de12eec81926@mail.gmail.com>
Date: Fri, 21 Sep 2007 18:00:46 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/5] Add central regulatory domain agent - Patchset I
Cc: "Dan Williams" <dcbw@redhat.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Daniel Drake" <dsd@gentoo.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <1190411390.18521.174.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070921204606.GD31768@pogo>
	 <1190410796.14368.17.camel@xo-3E-67-34.localdomain>
	 <1190411390.18521.174.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/21/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-09-21 at 17:39 -0400, Dan Williams wrote:
>
> > Also, if you could make sure this stuff is completely separate
> > conceptually and architecturally from mac80211 itself, but have mac80211
> > _rely_ on it, then we can rip the bits out of the fullmac drivers that
> > do regdomain stuff and plug them into this framework too.  I think
> > that's a real win.
>
> Yeah, I think that's the plan. In fact, I always consider mac80211 to be
> on the the same level like fullmac _drivers_ and mac80211-based drivers
> somewhere below that (at a level that with fullmac drivers doesn't
> exist)

Correct, the only way this touches mac80211 is ripping common wireless
stuff out from it and putting it into a wireless_common.h. other than
that all of this so far is 100% independent of mac80211.

In fact, you can apply each patch, one by one, and compile the kernel
and all modules and you should have no issues independently. However
each subsequent patch depends on the previous patch. The idea with
this was to try to get this regulatory work into the 'everything'
wireless-dev branch so we can address any small issues before we start
hacking away on mac80211 and its drivers.

At first I wanted to send all of the patches together but this was
just taking too long... My hope now was to speed the development
process up by separating the required work into two patches series.

  Luis
