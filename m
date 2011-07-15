Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56956 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1GOSt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 14:49:29 -0400
Received: by wwg11 with SMTP id 11so1578886wwg.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 11:49:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310720854.4164.5.camel@jlt3.sipsolutions.net>
References: <1310600747-9583-5-git-send-email-thomas@cozybit.com>
	<1310691023-31844-1-git-send-email-thomas@cozybit.com>
	<1310720854.4164.5.camel@jlt3.sipsolutions.net>
Date: Fri, 15 Jul 2011 11:49:28 -0700
Message-ID: <CAG6hwVNG6UDEiYxO5oxFqQDByn+W9C5Z0ibRokcP86EyHk_+yg@mail.gmail.com> (sfid-20110715_204933_026522_D77268D1)
Subject: Re: [PATCH v2 4/5] mac80211: move RSN IE to tail of mesh beacon
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 2:07 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-07-14 at 17:50 -0700, Thomas Pedersen wrote:
>> The mesh specific beacon IEs go right before the vendor IEs. Add a
>> filter that checks for custom IEs (currently just the RSN IE), which
>> belong after the TIM, but before HT. Also, ensure we don't add any
>> custom IEs twice in mesh_mgmt_ies_add().
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>
>> v2:
>>       Ensure room for custom IEs in transmitted beacon (Johannes).
>>       We'll be allocating twice as much space as needed for some IEs
>>       (in tail_len and again ie_len), but it shouldn't be a big deal.
>
> Not that I like allocating twice as much, but I don't really care
> either.
>
> Maybe you should be doing the cleanups in mesh_mgmt_ies_add()
> separately? I'm having a hard time following these changes.

OK, I can factor the changes in this into a single patch.
>
>> +               noffset = ieee80211_ie_split_vendor(ifmsh->ie, ifmsh->ie_len,
>> +                                                   offset);
>> +               if (noffset != offset) {
>
> isn't offset always 0 here? So wouldn't it make more sense to put 0
> explicitly?
>

Sure.

> johannes
>
>
