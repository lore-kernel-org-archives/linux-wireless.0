Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60487 "EHLO
	sipsolutions.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305Ab3FJG4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 02:56:53 -0400
Message-ID: <1370847386.8535.0.camel@jlt4.sipsolutions.net> (sfid-20130610_085656_698103_82279521)
Subject: Re: [PATCH 2/2] mac80211: update mesh beacon on workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Mon, 10 Jun 2013 08:56:26 +0200
In-Reply-To: <CAG6hwVPbc=-airtoDSMmhzYQ+X64Qv42F+mnEQ5vbHjxC5wCew@mail.gmail.com> (sfid-20130610_044207_513100_0453AE65)
References: <1370301943-13867-1-git-send-email-thomas@cozybit.com>
	 <1370301943-13867-2-git-send-email-thomas@cozybit.com>
	 <CAG6hwVPbc=-airtoDSMmhzYQ+X64Qv42F+mnEQ5vbHjxC5wCew@mail.gmail.com>
	 (sfid-20130610_044207_513100_0453AE65)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-06-09 at 19:41 -0700, Thomas Pedersen wrote:

> > +static void mesh_bss_info_changed(struct ieee80211_sub_if_data *sdata)
> > +{
> > +       struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> > +#define TEST_CHANGED_BIT(bit) \
> > +       test_and_clear_bit(bit, &ifmsh->mbss_changed)
> > +
> > +       u32 changed = TEST_CHANGED_BIT(BSS_CHANGED_BEACON) |
> > +                     TEST_CHANGED_BIT(BSS_CHANGED_HT) |
> > +                     TEST_CHANGED_BIT(BSS_CHANGED_BASIC_RATES) |
> > +                     TEST_CHANGED_BIT(BSS_CHANGED_BEACON_INT);
> > +#undef TEST_CHANGED_BIT
> 
> Uhhh we should read all the bits here. Will fix and resubmit as v2.

Now that you're quoting it I'd also say that the macro isn't really
best, does removing it really make the code so much worse?

johannes

