Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:36899 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYKCIBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 03:01:16 -0500
Received: by el-out-1112.google.com with SMTP id z25so1129480ele.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 00:01:15 -0800 (PST)
Message-ID: <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com> (sfid-20081103_090121_231477_C77FAC7E)
Date: Mon, 3 Nov 2008 00:01:15 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>, tim.gardner@canonical.com,
	mick@madwifi.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1225698867.3619.31.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4908B754.1050400@tpi.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	 <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
	 <20081102184146.GA6065@hash.localnet>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 <1225698867.3619.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 11:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-11-02 at 23:51 -0800, Luis R. Rodriguez wrote:
>> On Sun, Nov 2, 2008 at 11:34 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sun, 2008-11-02 at 23:29 -0800, Luis R. Rodriguez wrote:
>> >
>> >> >> Not sure I agree with the WARN_ON() if the driver's mac80211 config()
>> >> >> callback fails. In our case when we tune to a different channel we
>> >> >> have to clear any DMA operations first and then we reset the chip.
>> >> >> Reseting the chip can fail for whatever strange hw issue cases. The
>> >> >> patch fixes the complaint but is the complaint sane?
>> >> >
>> >> > What's mac80211 to do when it fails?
>> >>
>> >> How about a shiny new nl80211 event?
>> >
>> > And wtf would userspace do?
>>
>> If multiple configuration attempts fail perhaps stop trying, and
>> inform the user?
>
> But you're saying it's "normal" to get this failure,

No, I'm just sayings its possible, right now mac80211 assumes its not
and if it does its because we somehow lied to mac80211 of our
capabilities.

> so wouldn't it
> always do that sooner or later and always say your hw is broken?

Nope

> Also,
> that's a bad thing to do in userspace, imho.

What should we do with these rare failures then?

> Why can it fail here
> anyway?

Look at all the reasons for which a hw reset can fail for ath9k and ath5k.

> hw borked is one obvious case, but it shouldn't happen enough
> for this to be a problem yet.

This I agree with. It is rare, its just possible, right now mac80211
assumes it never will.

  Luis
