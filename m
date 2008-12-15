Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:18166 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYLOQMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 11:12:51 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1281122wah.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 08:12:49 -0800 (PST)
Message-ID: <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com> (sfid-20081215_171255_065620_92B58C8B)
Date: Mon, 15 Dec 2008 17:12:49 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH] ath5k: set mac address in add_interface
Cc: "Bob Copeland" <me@bobcopeland.com>, maximlevitsky@gmail.com,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <1229357080.12163.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081118044037.GA18983@hash.localnet>
	 <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
	 <1229357080.12163.47.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 5:04 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2008-12-15 at 16:47 +0100, Stefanik G=E1bor wrote:
>> This patch regressed support for aireplay-ng's "fragmentation attack=
" feature!
>>
>> Prior to the landing of this patch (as commit
>> caeb36d73b23b52a0ea2a8368502ef8230fa67b3), applying the patch @
>> http://patches.aircrack-ng.org/mac80211_2.6.28-rc4-wl_frag+ack_v2.pa=
tch
>> allowed aireplay-ng's fragmentation attack to work with almost all
>> mac80211 drivers, including ath5k. After the landing of this patch,
>> the attack fails with "No answer, repeating...". (Regression found
>> using git bisect, and verified by local backout of commit
>> caeb36d73b23b52a0ea2a8368502ef8230fa67b3.)
>
> Unless I misunderstand...  but not all drivers will report their MAC
> address until they have opened the device (ie, add_interface time),
> because not all devices load firmware until the interface is opened, =
and
> thus some cannot read their MAC address until that time.
>
> So aireplay-ng is broken if it relies on the device having a valid ma=
c
> address before the device is opened.
>
> Dan
>

That is not the problem - aireplay-ng operates on a monitor interface
that is already up. Likely this patch somehow misses monitor
interfaces.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
