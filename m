Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53212 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbaGUKCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:02:03 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so3737514wiv.15
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 03:02:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405936026.32255.6.camel@jlt4.sipsolutions.net>
References: <CALhHN=ofbPoy6z+Bj2L4vTroYDde+2+VWY6f6FVgzrY9ZC+xEA@mail.gmail.com>
	<1405936026.32255.6.camel@jlt4.sipsolutions.net>
Date: Mon, 21 Jul 2014 12:02:01 +0200
Message-ID: <CA+BoTQmK5z45fPtGAVedJa+pgL13pf9_OP0LeBQed4iUdp+vkQ@mail.gmail.com> (sfid-20140721_120212_555855_D010CF48)
Subject: Re: mac80211: A-MPDU reordering issue when RX_FLAG_AMSDU_MORE
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 July 2014 11:47, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-07-09 at 10:16 +0200, Janusz Dziedzic wrote:
>> Hello Johannes,
>>
>> Seems current mac80211 A-MPDU reordering implementation don't work
>> correctly with drivers that prefer to report separate A-MSDU subframes
>> instead of one huge frame (using RX_FLAG_AMSDU_MORE). Seems there is a
>> table where index is a sequence number (ampdu sn), so don't work
>> correctly while we report few A-MSDU frames with the same SN.
>>
>> We see this problem with ath10k driver. As I understand correctly, we
>> will have to change/rewrite mac80211 reordering code to support
>> correctly A-MSDU packets with RX_FLAG_AMSDU_MORE?
>>
>> Or
>>
[...]
>> What do you think?
>
> Looks like Michal did the former in the meantime? I was moving so was
> out for a while ...

Correct. I've posted `mac80211: fix Rx reordering with
RX_FLAG_AMSDU_MORE` which makes rx reordering work with sk_buff_head
instead of sk_buff *.


Michał
