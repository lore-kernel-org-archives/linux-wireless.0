Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:18360 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYLPO6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 09:58:23 -0500
Received: by an-out-0708.google.com with SMTP id d40so1308035and.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 06:58:21 -0800 (PST)
Message-ID: <b6c5339f0812160658y5ed2ceb4qdbb4b2ddf1fe07a5@mail.gmail.com> (sfid-20081216_155826_911157_CE1A0E9E)
Date: Tue, 16 Dec 2008 09:58:21 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
In-Reply-To: <b6c5339f0812150916k521fa7a4l4fc3aa560d08c1db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081118044037.GA18983@hash.localnet>
	 <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
	 <1229357080.12163.47.camel@localhost.localdomain>
	 <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com>
	 <b6c5339f0812150916k521fa7a4l4fc3aa560d08c1db@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 12:16 PM, Bob Copeland <me@bobcopeland.com> wro=
te:
> On Mon, Dec 15, 2008 at 11:12 AM, Stefanik G=E1bor
> <netrolller.3d@gmail.com> wrote:
>> That is not the problem - aireplay-ng operates on a monitor interfac=
e
>> that is already up. Likely this patch somehow misses monitor
>> interfaces.
>
> Agreed, that is probably the case.  Reverting that hunk makes it come=
 up
> with the eeprom mac without adding any interface.  Looking at the
> add_interface() code, it 'should' program the mac for monitor interfa=
ces
> too, so offhand I'm not sure, will take a look tonight.

Okay, so that I understand the problem a bit better: what used to happe=
n
and what does not happen now?  Is the ath5k device not sending ACKs, or
not passing any frames back to the host?

The code, for mac address setting at least, looks to be working as
designed: the mac address is only set up at add_interface time to avoid
automatically acking packets before an interface is brought up (see the
kerneldoc comments in mac80211 on add/remove_interface).

The ath5k rx filter for unicast frames requires mac addresses to match =
in
order to accept or ack frames.  However, in monitor mode, mac80211 will
never call add_interface().  Instead, it should configure the filter to
put the card in promiscuous mode which then should enable all packets
to be passed back to the host.

Does the fragmentation attack also work with e.g. b43 (which also only
sets up the mac at add_interface time)?

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
