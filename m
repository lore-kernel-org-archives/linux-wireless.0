Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:51970 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3LPSfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 13:35:32 -0500
Received: by mail-qc0-f177.google.com with SMTP id m20so3965525qcx.36
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 10:35:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387200253.4665.32.camel@jlt4.sipsolutions.net>
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
 <1387198425.4665.28.camel@jlt4.sipsolutions.net> <1387200253.4665.32.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <twpedersen@gmail.com>
Date: Mon, 16 Dec 2013 10:35:12 -0800
Message-ID: <CAHmEv841yO7NDdD4wan9CAOZL4Z19M3cu1vRgNZ2Q3_=NMvhCw@mail.gmail.com> (sfid-20131216_193535_904484_2C00D7B6)
Subject: Re: [PATCH 1/3] mac80211_hwsim: fix duplicate beacons on TSF adjust
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 16, 2013 at 5:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-12-16 at 13:53 +0100, Johannes Berg wrote:
>> On Sun, 2013-12-15 at 13:14 -0800, Thomas Pedersen wrote:
>> > From: Thomas Pedersen <thomas@cozybit.com>
>> >
>> > There was some bug when rescheduling the next beacon from
>> > the beacon tasklet after adjusting TSF which would cause
>> > the beacon timer to trigger twice. Beaconing at "old" TBT
>> > (previously scheduled interface TBTT) with new timestamp
>> > was incorrect anyway.
>> >
>> > Instead, reschedule the beacon straight away when
>> > adjusting TSF.
>>
>> Applied.
>
> Nope, never mind - this caused the wpa_s test cases to crash the kernel.

OK sorry about that, I'll give it a run through those.

Thanks,
Thomas
