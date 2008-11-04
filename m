Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:51250 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYKDMhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 07:37:11 -0500
Received: by rv-out-0506.google.com with SMTP id k40so3248974rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 04:37:10 -0800 (PST)
Message-ID: <b6c5339f0811040437h4da7f3a1v3b606145c0702243@mail.gmail.com> (sfid-20081104_133717_832536_982372B3)
Date: Tue, 4 Nov 2008 07:37:10 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] ath5k: enable RXing beacons
Cc: "Dan Williams" <dcbw@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <b6c5339f0811030717mfa8ac56hdd58c367563ed931@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
	 <1225676353.13684.2.camel@localhost.localdomain>
	 <b6c5339f0811021810w229d1d9al2b27bdf4144cde69@mail.gmail.com>
	 <43e72e890811022043t5525d924vcb776569a7bebbc8@mail.gmail.com>
	 <43e72e890811022049l386789f5qf8bde98eedcd4d2c@mail.gmail.com>
	 <43e72e890811022052n8c5e7d3ic722caa65c711481@mail.gmail.com>
	 <b6c5339f0811030717mfa8ac56hdd58c367563ed931@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 3, 2008 at 10:17 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sun, Nov 2, 2008 at 11:52 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>>>> Sorry, my fault, this was a direct result of
>>>>> 60c7e22196fb4230b76db1f5fb283e811b8f3fb3 "ath5k: honor
> [...]
>> OK Vasanth confirmed this is correct, and ath9k actually has incorrect
>> behavior so we have to fix that there as well. If stable got the ath5k
>> changes to the filter then yes we should push it there too.

BTW perhaps we should still look at the filter for ath5k since, once
associated, we still get beacons from every AP in the world instead of
just those with our BSSID.

     FIF_BCN_PRBRESP_PROMISC

     This flag is set during scanning to indicate to the hardware
     that it should not filter beacons or probe responses by BSSID.
     Filtering them can greatly reduce the amount of processing
     mac80211 needs to do and the amount of CPU wakeups, so
     you should honour this flag if possible.

Right now with ath5k there's basically no difference between having or
not having that flag in station mode, even though we do set the bssid
in ath5k_hw_set_associd AFAICT.

-- 
Bob Copeland %% www.bobcopeland.com
