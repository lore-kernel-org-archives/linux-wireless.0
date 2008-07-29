Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:52161 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbYG2LQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:16:01 -0400
Received: by rv-out-0506.google.com with SMTP id k40so4970806rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 04:16:01 -0700 (PDT)
Message-ID: <1ba2fa240807290416l7c489b50yca9efe637895725b@mail.gmail.com> (sfid-20080729_131605_897094_754562A4)
Date: Tue, 29 Jul 2008 14:16:01 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1217323749.10489.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 <1217320089.15381.25.camel@johannes.berg>
	 <1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com>
	 <1217322974.10489.0.camel@johannes.berg>
	 <1ba2fa240807290226n19ab0944u8e27f40cb688cfcc@mail.gmail.com>
	 <1217323749.10489.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 12:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> PS setting is rather global NIC state and should be set as user
>> preference rather then per application ... socket. If I understand
>> correctly what you mean by application.
>> What user actually selects is performance/power consumption trade off.
>
> yes, but what we also pointed out was that the user isn't able to make a
> good trade-off, and PS isn't necessarily linear anyway. Therefore,
> making the default be based on letting applications set what sort of
> latency/quality guarantees they set makes sense for a good user
> experience with maximum power saving that doesn't affect applications,
> if the user wants to go higher maybe we can later allow that in some
> way, but the default should be based on what performance apps expect.

I think the path of enabling user to control this through iw(nl) or
wext is closer to
come to usability as to relay on any application to implement it in
next half a year.
You need single API anyway since there have to be single point of
decision as there are many applications
running over single NIC e.g. VoIP and web browser have different requirements.

What I would actually start with is to get notification about dc or
battery supply. I don't think that class
implements notification chain though.

Tomas
