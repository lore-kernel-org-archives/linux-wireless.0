Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:2111 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab0CCImh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 03:42:37 -0500
Received: by fg-out-1718.google.com with SMTP id l26so193429fgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 00:42:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100303081835.GA1637@jm.kir.nu>
References: <20100302025158.9527.43764.stgit@void> <20100302094238.GA24391@jm.kir.nu>
	<201003031010.49887.br1@einfach.org> <20100303081835.GA1637@jm.kir.nu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 3 Mar 2010 09:42:16 +0100
Message-ID: <69e28c911003030042t540a13a8i145682f3b163975c@mail.gmail.com>
Subject: Re: [PATCH v2] ath5k: fix injection in monitor mode
To: Jouni Malinen <j@w1.fi>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	benoit.papillault@free.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 3, 2010 at 9:18 AM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Mar 03, 2010 at 10:10:49AM +0900, Bruno Randolf wrote:
>> On Tuesday 02 March 2010 18:42:38 Jouni Malinen wrote:
>> > If we want to have an option to prevent hardware from touching the frame
>> > payload, that really should be an option (a radiotap and TX control
>> > flags, etc.), not default functionality for monitor interface.
>
>> yes, we use it for testing IBSS mode (merging, TSF updates) by injecting
>> custom beacons. i guess other packet injectors would also assume that their
>> packets go out untouched.
>
> Like I said, not all packet injectors do and hostapd certainly depends
> on the injected packet being updated (both for contents and for
> selecting a suitable TX rate and also to encrypt the frame when a key is
> set for this).
>
>> so what would be a way to support that properly?
>> what about a monitor mode flag?
>
> My preference is shown in the quoted text above, i.e., a new radiotap
> (per packet, not per monitor interface) flag and then internally in
> mac80211--driver a new TX control flag to indicate that the frame is not
> to be updated.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
>

Shouldn't making this depend on COOK_FRAMES not being set be enough? A
while ago, the consensus was that injectors that don't set COOK_FRAMES
(should) expect packets to be transmitted unmodified.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
