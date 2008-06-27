Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:58469 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760539AbYF0Xdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 19:33:50 -0400
Received: by rv-out-0506.google.com with SMTP id k40so791701rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 16:33:49 -0700 (PDT)
Message-ID: <1ba2fa240806271633o20ef74f4k72807f85a072df83@mail.gmail.com> (sfid-20080628_013353_591828_A7FFE348)
Date: Sat, 28 Jun 2008 02:33:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Cc: "Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Joonwoo Park" <joonwpark81@gmail.com>,
	JMF <tolas_feup@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1214593935.5507.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <20080528004100.GG7779@tuxdriver.com> <20080615164617.GA27699@tp64>
	 <1ba2fa240806150953t4b61b213y3488940ef05b762e@mail.gmail.com>
	 <1213605989.3803.24.camel@johannes.berg>
	 <20080627152843.GA16003@tuxdriver.com>
	 <1214582853.10355.28.camel@localhost.localdomain>
	 <1ba2fa240806270922u3975220ehb122f33497a69607@mail.gmail.com>
	 <1214590219.24579.7.camel@localhost.localdomain>
	 <1214593935.5507.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 27, 2008 at 10:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > >> Strawman patch below...
>> > >
>> > > You need to allow 0 through, since you can just set the transmit key
>> > > index via ENCODE without setting the key.  So the legal values are 0, 5,
>> > > and 13.  Add 'case 0: /* just setting TX index */' or something and I'll
>> > > definitely ack it.
>
>> > >> +     switch (erq->length) {
>> > >> +     case KEY_SIZE_WEP40:
>> > >> +     case KEY_SIZE_WEP104:
>> > >> +             break;
>> > >> +     default:
>> > >> +             return -EINVAL;
>> > >> +     }
>> > >> +
>> > >>       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> > >>
>> > >>       idx = erq->flags & IW_ENCODE_INDEX;
>> > >> --
>> > >> 1.5.5.1
>> >
>> > I'm not against this patch just I thought we agreed to support the
>> > weird WEP keys in the  software. We fixed this in the driver with
>> > similar check so now it falls back to software encryption in mac80211.
>>
>> I thought we agreed to ignore > 104/128-bit WEP keys [1][2] until enough
>> people yelled about it (I've heard from 1 or 2 people in the past three
>> years about this for NetworkManager).
>
> I agree, who wants to write the support for that in mac80211. I said
> that we don't want to catch it in wext itself like an early patch did
> because some fullmac drivers might support it.
>
Fair enough. Actually have a similar patch in my stock. I will send it out.
Tomas
