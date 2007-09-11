Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:44262 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938AbXIKRhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 13:37:41 -0400
Received: by an-out-0708.google.com with SMTP id d31so219057and
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2007 10:37:40 -0700 (PDT)
Message-ID: <1ba2fa240709111037u1d48ef25ndf9583ee7dd7635e@mail.gmail.com>
Date: Tue, 11 Sep 2007 20:37:40 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189506221.6161.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1189076408.28781.49.camel@johannes.berg>
	 <1189146702.16788.103.camel@debian.sh.intel.com>
	 <1189172436.28781.148.camel@johannes.berg>
	 <1189390172.24707.36.camel@debian.sh.intel.com>
	 <1189420954.4506.37.camel@johannes.berg>
	 <1ba2fa240709100720k5156e11v775a5faa50144990@mail.gmail.com>
	 <1189506221.6161.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/11/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-10 at 17:20 +0300, Tomas Winkler wrote:
>
> > It is my best intention yet first we need native interface which make
> > in turn problems in eb tables. So it is a long shot.
>
> Ok. We've managed long enough without it so I guess we can wait :)
>
> > I wouldn't appreciate this at all. 11n is major feature of our NIC.
> > Major obstacle in finally pushing 11n is constant  code base change of
> > iwlwifi. This is already 4th  code base. The latest was because the
> > driver didn't look nice enough, what an engineering   reason! In the
> > bottom line we are hunting our own tail for wrong reasons
>
> Well, I believe that there are bad layering violations in your current
> driver, namely looking at the packets mac80211 sends, doing 11N
> manipulations and everything in the driver and duplicating the sta_info
> stuff because mac80211 happens to be missing a few hooks. If you think
> those are "wrong reasons" that's fine with me.

There is no doubt that what you currently see is ugly, we reworked the
code and added these few hooks the problem is that they don't apply
anymore  to recent code, since I'm stabilizing basic flows after each
code base in the middle of development.
I know I'm not 'release often' complained but I really test the code
that I'm publishing, it takes time.
I prefer to have stable driver and fix it step by step then releasing
30 patches that nobody have time to consume and review in addition it
just kills the functionality. Don't know maybe I'm too old for Linux
:)

>
> Personally, I'm just raising these points and marking them down as
> "against merging as-is". If others don't care about them, that's ok with
> me.
>
After all it is functional driver. It gets ~60Mps in TCP even more.

> johannes
>
>
