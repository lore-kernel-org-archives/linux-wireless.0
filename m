Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:54975 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbYKCIkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 03:40:02 -0500
Received: by yx-out-2324.google.com with SMTP id 8so921985yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 00:40:01 -0800 (PST)
Message-ID: <43e72e890811030040r6b090f7ai4b8aa9fc55b4f78c@mail.gmail.com> (sfid-20081103_094008_534362_751B1E22)
Date: Mon, 3 Nov 2008 00:40:01 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>, tim.gardner@canonical.com,
	mick@madwifi.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1225701024.3619.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4908B754.1050400@tpi.com> <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 <1225698867.3619.31.camel@johannes.berg>
	 <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com>
	 <1225699482.3619.34.camel@johannes.berg>
	 <43e72e890811030026t319c551cp91807318f9a6b838@mail.gmail.com>
	 <1225701024.3619.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 3, 2008 at 12:30 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-11-03 at 00:26 -0800, Luis R. Rodriguez wrote:
>
>> >> What should we do with these rare failures then?
>> >
>> > print an error message? ignore them? try again?
>>
>> I'd prefer a simple error print than a WARN_ON().
>
> Just so you don't get blamed on kerneloops.org? :)

No because like I said a hw reset can fail and don't think software
should be blamed. Right now we do that.

>> >> > hw borked is one obvious case, but it shouldn't happen enough
>> >> > for this to be a problem yet.
>> >>
>> >> This I agree with. It is rare, its just possible, right now mac80211
>> >> assumes it never will.
>> >
>> > It's _always_ assumed that by ignoring the return value, now it's just
>> > noisy about it because clearly it doesn't like when the driver fails to
>> > do what it wants since then the hw and sw states get out of sync. I
>> > really don't see what to do other than retry maybe, but that might well
>> > be done in the driver instead.
>>
>> As can be seen from the patch suggested what some drivers will end up
>> doing is just ignoring failures but I guess that can be up to the
>> drivers to deal with as you are suggesting. I'd be inclined to try to
>> disable the device in case of a few failed resets to be specific with
>> ath5k. Would mac80211 want to be informed of that through the return
>> value? Is the WARN still appropriate?
>
> I think the warning is appropriate, yes, since mac80211 has no concept
> of failing hardware configuration. You're free to add such a concept,
> but I really don't know what mac80211 would be supposed to do when
> things fail, just try to stop/start? panic()? Instruct the user to
> reboot? to swap hardware? See?

Sure, OK then the error will be "deal with".

  Luis
