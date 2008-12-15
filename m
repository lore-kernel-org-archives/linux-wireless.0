Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:48336 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbYLORQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 12:16:38 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1146839ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 09:16:37 -0800 (PST)
Message-ID: <b6c5339f0812150916k521fa7a4l4fc3aa560d08c1db@mail.gmail.com> (sfid-20081215_181643_278900_C938CEB4)
Date: Mon, 15 Dec 2008 12:16:37 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
In-Reply-To: <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081118044037.GA18983@hash.localnet>
	 <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
	 <1229357080.12163.47.camel@localhost.localdomain>
	 <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 11:12 AM, Stefanik G=E1bor
<netrolller.3d@gmail.com> wrote:
> That is not the problem - aireplay-ng operates on a monitor interface
> that is already up. Likely this patch somehow misses monitor
> interfaces.

Agreed, that is probably the case.  Reverting that hunk makes it come u=
p
with the eeprom mac without adding any interface.  Looking at the
add_interface() code, it 'should' program the mac for monitor interface=
s
too, so offhand I'm not sure, will take a look tonight.

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
