Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:44235 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447AbYLKWub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 17:50:31 -0500
Received: by wf-out-1314.google.com with SMTP id 27so974681wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 14:50:29 -0800 (PST)
Message-ID: <b6c5339f0812111450h7a886e7dwa7285b6b91117773@mail.gmail.com> (sfid-20081211_235038_621571_ADE318C6)
Date: Thu, 11 Dec 2008 17:50:29 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] [PATCH] ath5k : Fix correct padding
Cc: "Benoit PAPILLAULT" <benoit.papillault@free.fr>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Patrick McHardy" <kaber@trash.net>
In-Reply-To: <1229033262.8081.89.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <49418D23.8060905@free.fr> <1229033262.8081.89.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/12/11 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2008-12-11 at 22:58 +0100, Benoit PAPILLAULT wrote:
>> Padding the 802.11 header to a multiple of 4 bytes needs to be done only
>> for DATA frames. This fixes a bug where 2 bytes were missing in monitor
>> mode for ACK frames.
>
> That's the wrong way around, you're not padding anything, you're
> unpadding it.
>

Agreed, does the hardware really care for control frames if there's
a padding on the TX side?

Also, Patrick already posted a patch:

http://marc.info/?l=linux-wireless&m=122888546315200&w=2


-- 
Bob Copeland %% www.bobcopeland.com
