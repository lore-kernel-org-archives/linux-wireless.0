Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:38599 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbbCCKHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 05:07:30 -0500
Received: by labgf13 with SMTP id gf13so11719195lab.5
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2015 02:07:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425377192.2450.34.camel@sipsolutions.net>
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
 <1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com>
 <1425041427.1960.1.camel@sipsolutions.net> <CA+XVXfchZ+L1iH47S=rM04vJbjBSKA4O8TYuhEkfZuLpNb9QDA@mail.gmail.com>
 <1425374299.2450.18.camel@sipsolutions.net> <CA+XVXffHENxD3z9dTn_LC9c7Ot0Q4FgyEoHLjdeiDTFWQGuF9w@mail.gmail.com>
 <1425377192.2450.34.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 3 Mar 2015 12:07:13 +0200
Message-ID: <CA+XVXfdu2fCLXBP1VkMOX9nnoqCiH+h=pwzGAQ2KkBrf-H9MCQ@mail.gmail.com> (sfid-20150303_110738_580680_12562200)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for tdls station
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 3, 2015 at 12:06 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2015-03-03 at 12:02 +0200, Arik Nemtsov wrote:
>> On Tue, Mar 3, 2015 at 11:18 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sun, 2015-03-01 at 10:21 +0200, Arik Nemtsov wrote:
>> >
>> >> > Arik, you have a similar patch handling only NSS. Does this one look
>> >> > fine to you, and would it solve the problem your other patch solved?
>> >>
>> >> Well currently iwlmvm requires the NSS to be set before
>> >> IEEE80211_STA_ASSOC (earlier), so this doesn't help directly.
>> >> I could change mvm a bit to make it work, but I don't really see a
>> >> good reason for it :)
>> >>
>> >> The patch looks good. Shouldn't introduce new issues (at least for iwlwifi).
>> >
>> > Ok, thanks. Do you think it would be possible to move all of this before
>> > ASSOC?
>>
>> We can probably move his rate_control_rate_init() to assoc, since we have this:
>
> And doing so would also address the nss problem, right? IIRC that's done
> in the rate control init inline.

Right.

Arik
