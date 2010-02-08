Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:57062 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0BHTdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 14:33:42 -0500
Received: by pzk2 with SMTP id 2so197065pzk.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 11:33:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265620089.3783.2.camel@johannes.berg>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <20100205165726.GA1496@holoscopio.com>
	 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
	 <1265446793.4041.2.camel@johannes.local>
	 <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
	 <1265620089.3783.2.camel@johannes.berg>
Date: Mon, 8 Feb 2010 11:25:37 -0800
Message-ID: <445f43ac1002081125i61bb53dap5b9df374b3116ba9@mail.gmail.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh mode
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org,
	Andrey Yurovsky <yurovsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thadeu, Johannes,

On Mon, Feb 8, 2010 at 1:08 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2010-02-07 at 11:51 -0800, Andrey Yurovsky wrote:
>> On Sat, Feb 6, 2010 at 12:59 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > I do wonder though, the commit (155cc9e4b1d60161ee53) I referenced was
>> > yours, and now you're asking the same question as I am -- "why even
>> > allow adding stations?"
>>
>> It was supported for automated testing and experimentation (you could
>> then force certain topologies).  I can't think of any other reason to
>> do it.  I suppose that the same thing goes for mpaths and the mesh
>> portal tables.
>
> So would you prefer to fix it (however we would do that, I don't think
> that the patch here is correct since it leaves the station struct with
> no usable rates afaict), or just disallow it?

After reviewing our mesh test suite, I would vote for disallowing mesh
point addition via iw.  We currently force topologies by 1. turning
auto peering off, 2. waiting for neighbors to be discovered and 3.
controlling peering with 'iw ... station set <MAC address>
plink_action <open|block>'

Thadeu, would this approach work for you?

Javier



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
