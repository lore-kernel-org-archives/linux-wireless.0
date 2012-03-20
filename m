Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2CTHId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 03:08:33 -0400
Subject: Re: [PATCH] cfg80211: warn if db.txt is empty with
 CONFIG_CFG80211_INTERNAL_REGDB
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: sfr@canb.auug.org.au, linux-wireless@vger.kernel.org,
	Youngsin Lee <youngsin@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	Senthil Kumar Balasubramanian <senthilb@qca.qualcomm.com>,
	Vipin Mehta <vipimeht@qca.qualcomm.com>,
	yahuan@qca.qualcomm.com, jjan@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, henrykim@qualcomm.com,
	jouni@qca.qualcomm.com, athiruve@qca.qualcomm.com,
	cjkim@qualcomm.com, philipk@qca.qualcomm.com,
	sunnykim@qualcomm.com, sskwak@qualcomm.com, kkim@qualcomm.com,
	mattbyun@qualcomm.com, ryanlee@qualcomm.com, simbap@qualcomm.com,
	krislee@qualcomm.com, conner@qualcomm.com, hojinkim@qualcomm.com,
	honglee@qualcomm.com, johnwkim@qualcomm.com
In-Reply-To: <CAB=NE6WGdK0YJfi8hrWTqYr2zdUc5yEhV9VUbidi36fd==nEig@mail.gmail.com> (sfid-20120320_080102_002254_C5C4A14A)
References: <1332192901-2500-1-git-send-email-mcgrof@frijolero.org>
	 <1332223323.3329.0.camel@jlt3.sipsolutions.net>
	 <CAB=NE6WGdK0YJfi8hrWTqYr2zdUc5yEhV9VUbidi36fd==nEig@mail.gmail.com>
	 (sfid-20120320_080102_002254_C5C4A14A)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 08:08:27 +0100
Message-ID: <1332227307.3329.2.camel@jlt3.sipsolutions.net> (sfid-20120320_080836_909984_F010A1D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-20 at 00:00 -0700, Luis R. Rodriguez wrote:

> >>  net/wireless/reg.c |   12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>
> >> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> >> index e9a0ac8..85f51b3 100644
> >> --- a/net/wireless/reg.c
> >> +++ b/net/wireless/reg.c
> >> @@ -388,7 +388,18 @@ static void reg_regdb_query(const char *alpha2)
> >>
> >>       schedule_work(&reg_regdb_work);
> >>  }
> >> +
> >> +/* Feel free to add any other sanity checks here */
> >> +static void reg_regdb_size_check(void)
> >> +{
> >> +#ifdef CONFIG_CFG80211_REG_DEBUG
> >> +     BUILD_BUG_ON(!reg_regdb_size);
> >> +#else
> >> +     WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
> >> +#endif
> >
> > That ifdef seems a bit pointless? If anything I would have expected it
> > the other way around since the BUILD_BUG_ON compiles to nothing?
> 
> As I tested it, the BUILD_BUG_ON() forces a compile failure.

Right. Why would you not want that always?

johannes

