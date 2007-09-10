Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbXIJCQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 22:16:14 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189172436.28781.148.camel@johannes.berg>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1189076408.28781.49.camel@johannes.berg>
	 <1189146702.16788.103.camel@debian.sh.intel.com>
	 <1189172436.28781.148.camel@johannes.berg>
Content-Type: text/plain; charset=GB2312
Date: Mon, 10 Sep 2007 10:09:32 +0800
Message-Id: <1189390172.24707.36.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-09-07 at 15:40 +0200, Johannes Berg wrote:
> But you need to have another place where this flag is set based on th=
e
> equivalent mac80211 flag, so this is not necessary.

OK. Will use mac80211's indication if mac80211 already takes care about
the "trick".

> > BTW=A3=AC the whole 802.11 qdisc hack will be removed with
> > the multiqueue supported in .24. =20
>=20
> Yeah, is anybody working on that? I have to admit I didn't look into
> that yet.

If nobody will work on that, we Intel will do. I remembered Tomas
promised John in this OLS ;)

> > We have the HT AGG support in our mac80211. Will submit the patch f=
or
> > review when we are ready.
>=20
> Yeah I gathered that much from what Tomas said, but why do you keep
> pushing for including this driver when you know it's not the right th=
ing
> to do?
>=20
> > > iwl4965_sign_extend can be implemented a lot better like such:
> > >=20
> > > static inline s32 sign_extend(u32 value, u8 bits)
> > > {
> > > 	u8 shift =3D 32 - bits;
> > >=20
> > > 	return (s32)(value << shift) >> shift;
> > > }
> >=20
> > Really? Are you sure this work?
>=20
> Hmm? Of course, shift it up and then do a signed shift down.

It should be 31, not 32 (shift =3D 31 - bits). Will use your suggestion=
=2E

> You still haven't fixed the issues we pointed out in the 11N
> deaggregation code. And maybe we missed some things too. Also, I
> personally only recently started working on mac80211 and Jiri seems t=
o
> have vanished completely.

OK. Let me remove the 11N stuff in iwlwifi for .24 and then we do
another round of mac80211 11N patches submission/review later. I believ=
e
you can do a better job than Jiri did.

> In any case, let's get back to more productive things. I apologise fo=
r
> anything I might have said that offended you, I didn't mean to. All t=
he
> code that superficially looks like workarounds around mac80211 stuff
> made me not like the code and I suppose that showed.
>=20
> Can you post patches against the iwlwifi currently included in
> wireless-dev? Currently, it seems that I have to either dig in your
> repository or through your patches to figure out the current state of
> things I commented on, which is suboptimal because I don't even get t=
o
> see the fixes to things I pointed out. I'd like to have iwlwifi in
> wireless-dev be essentially the same as is merged into mainline, modu=
lo
> the bits that depend on things like HT deaggregation that are not in
> mainline yet.

I thought John would take my .24 iwlwifi patch to wireless-dev GIT
directly since he just rebased the tree (at that time) and all the
commits for iwlwifi were merged into one big patch. Anyway, I will
repost it explicitly for wireless-dev next time: iwlwifi driver + HT
features for the iwlwifi (or everything) branch; and iwlwifi driver
without HT features for pending-upstream branch. We can work on iwlwifi
driver to make it in .24 first and sort out HT things in .25.

> Incidentally, I currently have just about as much a hard time getting
> things changed in mac80211 as you do because nobody wants to review t=
hat
> code. Hence, it would even help if you could review the patches I pos=
ted
> and maybe look if that is easy/possible to support with iwlwifi and
> possibly even adapt iwlwifi and test so that John feels more confiden=
t
> in merging patches. Conversely, I promise I'll review and test any
> patches you make to mac80211 as time permits.

I totally agree with you.

Thanks,
-yi
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
