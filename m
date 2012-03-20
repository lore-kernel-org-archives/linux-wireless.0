Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36622 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab2CTHNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 03:13:55 -0400
Received: by iagz16 with SMTP id z16so10603577iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 00:13:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332227307.3329.2.camel@jlt3.sipsolutions.net>
References: <1332192901-2500-1-git-send-email-mcgrof@frijolero.org>
 <1332223323.3329.0.camel@jlt3.sipsolutions.net> <CAB=NE6WGdK0YJfi8hrWTqYr2zdUc5yEhV9VUbidi36fd==nEig@mail.gmail.com>
 <1332227307.3329.2.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Mar 2012 00:13:34 -0700
Message-ID: <CAB=NE6UFLKvozoTX89k=XP1JoKCYdip_eSx-5FVRGje=6vnRvQ@mail.gmail.com> (sfid-20120320_081359_266484_350E2461)
Subject: Re: [PATCH] cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB
To: Johannes Berg <johannes@sipsolutions.net>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2012 at 12:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-03-20 at 00:00 -0700, Luis R. Rodriguez wrote:
>
>> >>  net/wireless/reg.c |   12 ++++++++++++
>> >>  1 file changed, 12 insertions(+)
>> >>
>> >> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> >> index e9a0ac8..85f51b3 100644
>> >> --- a/net/wireless/reg.c
>> >> +++ b/net/wireless/reg.c
>> >> @@ -388,7 +388,18 @@ static void reg_regdb_query(const char *alpha2)
>> >>
>> >>       schedule_work(&reg_regdb_work);
>> >>  }
>> >> +
>> >> +/* Feel free to add any other sanity checks here */
>> >> +static void reg_regdb_size_check(void)
>> >> +{
>> >> +#ifdef CONFIG_CFG80211_REG_DEBUG
>> >> +     BUILD_BUG_ON(!reg_regdb_size);
>> >> +#else
>> >> +     WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
>> >> +#endif
>> >
>> > That ifdef seems a bit pointless? If anything I would have expected it
>> > the other way around since the BUILD_BUG_ON compiles to nothing?
>>
>> As I tested it, the BUILD_BUG_ON() forces a compile failure.
>
> Right. Why would you not want that always?

Ah well that is a question for you, John and Stephen. I didn't use
that *always* given that it would break random build testing whenever
CFG80211_INTERNAL_REGDB was enabled, given that it requires a manual
cp of db.txt from wireless-regdb. With this it would only break build
testing with debugging cfg80211 regulatory, both
CFG80211_INTERNAL_REGDB and CONFIG_CFG80211_REG_DEBUG enabled. If you
guys are happy with it then so am I -- I prefer it, just didn't want
any surprises or anyone reporting an unexpected build breakage later.

  Luis
