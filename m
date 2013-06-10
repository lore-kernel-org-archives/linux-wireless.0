Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:40257 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3FJSNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 14:13:05 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so2914831bkh.12
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jun 2013 11:13:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370847386.8535.0.camel@jlt4.sipsolutions.net>
References: <1370301943-13867-1-git-send-email-thomas@cozybit.com>
 <1370301943-13867-2-git-send-email-thomas@cozybit.com> <CAG6hwVPbc=-airtoDSMmhzYQ+X64Qv42F+mnEQ5vbHjxC5wCew@mail.gmail.com>
 <1370847386.8535.0.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 10 Jun 2013 11:12:43 -0700
Message-ID: <CAG6hwVO=PfsKC-m35oGUAD2Pi9fCgYz2h7NJZCLgRSmKatB3TA@mail.gmail.com> (sfid-20130610_201309_332969_FC206884)
Subject: Re: [PATCH 2/2] mac80211: update mesh beacon on workqueue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 9, 2013 at 11:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2013-06-09 at 19:41 -0700, Thomas Pedersen wrote:
>
>> > +static void mesh_bss_info_changed(struct ieee80211_sub_if_data *sdata)
>> > +{
>> > +       struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>> > +#define TEST_CHANGED_BIT(bit) \
>> > +       test_and_clear_bit(bit, &ifmsh->mbss_changed)
>> > +
>> > +       u32 changed = TEST_CHANGED_BIT(BSS_CHANGED_BEACON) |
>> > +                     TEST_CHANGED_BIT(BSS_CHANGED_HT) |
>> > +                     TEST_CHANGED_BIT(BSS_CHANGED_BASIC_RATES) |
>> > +                     TEST_CHANGED_BIT(BSS_CHANGED_BEACON_INT);
>> > +#undef TEST_CHANGED_BIT
>>
>> Uhhh we should read all the bits here. Will fix and resubmit as v2.
>
> Now that you're quoting it I'd also say that the macro isn't really
> best, does removing it really make the code so much worse?

No, it won't be there in v2. Thanks.

--
Thomas
