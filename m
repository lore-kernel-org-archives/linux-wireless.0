Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33432 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbcGSQB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 12:01:56 -0400
Received: by mail-qk0-f173.google.com with SMTP id p74so19985539qka.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 09:01:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160719134355.GA1833@localhost>
References: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
 <20160719124456.GD11996@localhost> <AE1C82FB3D0EC64DB1F752C81CBD110139206115@DFRE01.ent.ti.com>
 <20160719134355.GA1833@localhost>
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Wed, 20 Jul 2016 00:01:54 +0800
Message-ID: <CAEFj987V0r3aVn+JhQOX-40bheKyEJdrppF75OCaLXhU=skmNw@mail.gmail.com> (sfid-20160719_180159_626793_49E31728)
Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
To: Bob Copeland <me@bobcopeland.com>
Cc: "Machani, Yaniv" <yanivma@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2016 at 9:43 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Jul 19, 2016 at 01:02:13PM +0000, Machani, Yaniv wrote:
>> On Tue, Jul 19, 2016 at 15:44:56, Bob Copeland wrote:
>> > > IEEE 802.11-2012 has defined dot11MeshHWMPpreqMinInterval attribute
>> > > to specify the minimum interval of time during which a mesh STA can
>> > > send only one Action frame containing a PREQ element. This is to
>> > > avoid flooding of broadcast PREQ frame especially when the number of
>> > > mesh STA is increased.
>> >
>> > Good point, according to 13.10.9.3, conditions for sending PREQ include:
>> >
>> > "The mesh STA has not sent a PREQ element for the target mesh STAs
>> > less than dot11MeshHWMPpreqMinInterval TUs ago. If this is the case,
>> > the transmission of the PREQ has to be postponed until this condition becomes true."
>> >
>>
>> As I see it, the key point here is "for the target meh STA",
>> Today, the code will not send a PREQ to ANY target if
>> dot11MeshHWMPpreqMinInterval didn't passed.
>> The information is saved in the 'ifmsh->last_preq', and not per path.
>
> The standard also says (which Chun-Yeow partially quoted):
>
> dot11MeshHWMPpreqMinInterval OBJECT-TYPE
> SYNTAX Unsigned32 (1..65535)
> MAX-ACCESS read-write
> STATUS current
> DESCRIPTION
> "This is a control variable.
> It is written by an external management entity.
> Changes take effect as soon as practical in the implementation.
> This attribute specifies the minimum interval of time (in TUs) during
> which a mesh STA can send only one Action frame containing a PREQ element."
> DEFVAL { 100 }
> ::= { dot11MeshHWMPConfigEntry 4}
>
> This wording seems to indicate that it is not per path.  Perhaps this
> should be clarified in the standard.  (If the intent turns out to be per
> path, then I guess we should fix it by storing last_preq per path instead.)
>
>
> Ignoring the standard for a second, let's explore this: can you give
> some idea on how many stations are in your target network, how frequently
> a given pair of nodes unpeer, what sort of improvements you see with the
> patch?  It should then be pretty easy to run some simulations to see the
> scenarios where this helps and where it hurts.
>

In addition to Bob's comment, you probably can try to reduce the
dot11MeshHWMPpreqMinInterval to 1 TU (1ms) instead of sticking to
default value 10 TUs. Besides, you can also reduce the
mesh_path_refresh_time which is currently default to 1000 ms and check
whether you can improve on your network scenarios.

When you mentioned "next hop peer disconnect", it could also be the
time taken to re-established the mesh peering before your mesh STA can
transmit the data to your peer mesh STA.

---
Chun-Yeow
