Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.214.180]:53651 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab0LMRjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 12:39:47 -0500
Received: by iwn37 with SMTP id 37so9636053iwn.11
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 09:39:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292261649.3539.38.camel@jlt3.sipsolutions.net>
References: <20101213114351.47df9333@gotham.conectiva> <AANLkTinnhSj=50agjC3mVDKF1Z7-rMdZ4oqZvwmitmmE@mail.gmail.com>
 <1292261649.3539.38.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Dec 2010 09:39:26 -0800
Message-ID: <AANLkTik6oj8LSqRcTiXCxLP1nz=y7QbUSfs=0yJa6CLY@mail.gmail.com>
Subject: Re: [PATCH] mac80211: avoid calling ieee80211_work_work unconditionally
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 9:34 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-12-13 at 09:29 -0800, Luis R. Rodriguez wrote:
>> On Mon, Dec 13, 2010 at 5:43 AM, Herton Ronaldo Krzesinski
>> <herton@mandriva.com.br> wrote:
>> > On suspend, there might be usb wireless drivers which wrongly trigger
>> > the warning in ieee80211_work_work. If an usb driver doesn't have a
>> > suspend hook, the usb stack will disconnect the device. On disconnect,
>> > a mac80211 driver calls ieee80211_unregister_hw, which calls dev_close,
>> > which calls ieee80211_stop, and in the end calls ieee80211_work_purge->
>> > ieee80211_work_work.
>> >
>> > The problem is that this call to ieee80211_work_purge comes after
>> > mac80211 is suspended, triggering the warning even when we don't have
>> > work queued in work_list (the expected case when already suspended),
>> > because it always calls ieee80211_work_work.
>> >
>> > So, just call ieee80211_work_work in ieee80211_work_purge if we really
>> > have to abort work. This addresses the warning reported at
>> > https://bugzilla.kernel.org/show_bug.cgi?id=24402
>> >
>> > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>>
>> Cc: stable@kernel.org ?
>
> It's just a warning, do we really want to bother?

Why not, it pollutes logs.

  Luis
