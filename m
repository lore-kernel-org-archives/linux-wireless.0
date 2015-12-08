Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33278 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbbLHQDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 11:03:23 -0500
Received: by vkca188 with SMTP id a188so17561287vkc.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2015 08:03:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449590307.4154.13.camel@sipsolutions.net>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
 <1449583479-26658-7-git-send-email-emmanuel.grumbach@intel.com>
 <CABPxzYK=RdZo0WB7Tt4PO19n23+9rgAypj=OEDZE8GJ6cV_gXw@mail.gmail.com>
 <1449589374.4154.11.camel@sipsolutions.net> <CABPxzYJd+9kq8w9zz549F1EEHhWgKhCsDeRUR1MzZ=LbizMJbw@mail.gmail.com>
 <1449590039.4154.12.camel@sipsolutions.net> <CABPxzYL7h8ToceTfx8cV5VUtrr13Y1QZiPphWzznh2pitt457w@mail.gmail.com>
 <1449590307.4154.13.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 8 Dec 2015 21:33:03 +0530
Message-ID: <CABPxzYJPf2uk0AVFEj_TkfRHnBTfH92191jPhx1SYaqHqkgPNA@mail.gmail.com> (sfid-20151208_170326_555156_11EC79CE)
Subject: Re: [PATCH 6/9] mac80211: handle width changes from opmode
 notification IE in beacon
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2015 at 9:28 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-12-08 at 21:25 +0530, Krishna Chaitanya wrote:
>> On Tue, Dec 8, 2015 at 9:23 PM, Johannes Berg <johannes@sipsolutions.
>> net> wrote:
>> > On Tue, 2015-12-08 at 21:17 +0530, Krishna Chaitanya wrote:
>> > >
>> > > > If the rate control algorithm doesn't look at sta->sta.rx_nss
>> > > > then
>> > > > that's their bug.
>> > >
>> > > Yes, it looks like it. Only BW is handled, not the NSS change,
>> > > and
>> > > without this patch OP MODE IE in beacon updates neither NSS nor
>> > > BW.
>> > >
>> > > For Action frame OP MODE IE, NSS will be updated.
>> Typo BW will be updated.
>
> Ok.
>
>> > I don't see how that would happen - they end up in exactly the same
>> > code path.
>>
>> As nss_only is false, BW will be update in case of action frame.
>
> Well, this patch removes that since the whole concept of nss_only was
> wrong.
>
> So basically you're just saying that minstrel should be fixed to look
> at rx_nss (and the relevant change bit, perhaps)...
>
Exactly :-).
