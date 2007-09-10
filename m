Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:55286 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbXIJOUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 10:20:06 -0400
Received: by an-out-0708.google.com with SMTP id d31so153675and
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2007 07:20:05 -0700 (PDT)
Message-ID: <1ba2fa240709100720k5156e11v775a5faa50144990@mail.gmail.com>
Date: Mon, 10 Sep 2007 17:20:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Cc: "Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189420954.4506.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1189076408.28781.49.camel@johannes.berg>
	 <1189146702.16788.103.camel@debian.sh.intel.com>
	 <1189172436.28781.148.camel@johannes.berg>
	 <1189390172.24707.36.camel@debian.sh.intel.com>
	 <1189420954.4506.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/10/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-10 at 10:09 +0800, Zhu Yi wrote:
> > On Fri, 2007-09-07 at 15:40 +0200, Johannes Berg wrote:
> > > But you need to have another place where this flag is set based on the
> > > equivalent mac80211 flag, so this is not necessary.
> >
> > OK. Will use mac80211's indication if mac80211 already takes care about
> > the "trick".
>
> If not I'd consider it a bug. But I don't see a "trick" there anyhow.
> What's non-standard in this behaviour? Almost every unicast packet is
> expected to be acknowledged.
>
> > > > BTW， the whole 802.11 qdisc hack will be removed with
> > > > the multiqueue supported in .24.
>
> > If nobody will work on that, we Intel will do. I remembered Tomas
> > promised John in this OLS ;)
>
> :)
> Sounds good. Do you guys have contact to whoever wrote it? ISTR it came
> from Intel in the first place.
>
It is my best intention yet first we need native interface which make
in turn problems in eb tables. So it is a long shot.

> > It should be 31, not 32 (shift = 31 - bits). Will use your suggestion.
>
> Huh. /me double-checks. Am I doing this bit-calculation totally wrong? I
> thought you had a "bits"-bit number that included the sign in the bit
> "bits-1" (if you number 0 through "bits-1"). Then you have to shift up
> by "32 - bits" so that the "bits" bits including the sign live in the
> upper "bits" bits of the 32-bit number, and then shift down again by the
> same amount to do the sign extension. I wonder if there's a good way to
> ask gcc to do this :)
>
> > OK. Let me remove the 11N stuff in iwlwifi for .24 and then we do
> > another round of mac80211 11N patches submission/review later.
>
> That would be much appreciated. We really also should have rate control
> be able to influence that generically and lots more things that have to
> be figured out but that are quite hard to work with when the 802.11n
> drafts are not available to many.

I wouldn't appreciate this at all. 11n is major feature of our NIC.
Major obstacle in finally pushing 11n is constant  code base change of
iwlwifi. This is already 4th  code base. The latest was because the
driver didn't look nice enough, what an engineering   reason! In the
bottom line we are hunting our own tail for wrong reasons

> > I believe
> > you can do a better job than Jiri did.
>
> Thanks. I'm not sure I can live up to that though; for example I'll have
> to mostly disappear for the next 10 days or so to prepare for an exam.
> I'll be around, but not patching quite as much ;)
>
> > I thought John would take my .24 iwlwifi patch to wireless-dev GIT
> > directly since he just rebased the tree (at that time) and all the
> > commits for iwlwifi were merged into one big patch.
>
> Ah ok.
>
> > Anyway, I will
> > repost it explicitly for wireless-dev next time: iwlwifi driver + HT
> > features for the iwlwifi (or everything) branch; and iwlwifi driver
> > without HT features for pending-upstream branch. We can work on iwlwifi
> > driver to make it in .24 first and sort out HT things in .25.
>
> Sounds good. I'll take another look then.
>
> Thanks,
> johannes
>
>
