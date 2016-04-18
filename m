Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38184 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbcDRNg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 09:36:26 -0400
Received: by mail-wm0-f49.google.com with SMTP id u206so124527015wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 06:36:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460982672.10638.111.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-3-git-send-email-michal.kazior@tieto.com>
	<1460845384.2075.27.camel@sipsolutions.net>
	<1460845552.2075.28.camel@sipsolutions.net>
	<CA+BoTQmuTAjR-cSuJmsAm5Ms3sTrtPT8HxE_tYf1EGOMGeHVcw@mail.gmail.com>
	<1460982672.10638.111.camel@edumazet-glaptop3.roam.corp.google.com>
Date: Mon, 18 Apr 2016 15:36:24 +0200
Message-ID: <CA+BoTQkSj788jcdB78XdeXTZdCGoCAKedpg0XnK7bjtuqaAWMA@mail.gmail.com> (sfid-20160418_153636_975319_915FA7E1)
Subject: Re: [Codel] [PATCHv3 2/5] mac80211: implement fair queueing per txq
From: Michal Kazior <michal.kazior@tieto.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	codel@lists.bufferbloat.net, Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 April 2016 at 14:31, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Mon, 2016-04-18 at 07:16 +0200, Michal Kazior wrote:
>
>>
>> I guess .h file can give the compiler an opportunity for more
>> optimizations. With .c you would need LTO which I'm not sure if it's
>> available everywhere.
>>
>
> This makes little sense really. Otherwise everything would be in .h
> files.
>
> include/net/codel.h is an include file because both codel and fq_codel
> use a common template for codel_dequeue() in fast path.
>
> But net/mac80211/fq.h is included once, so should be a .c

FWIW cfg80211 drivers might become another user of the fq/codel stuff
in the future.

Arguably I should make include/net/codel.h not be qdisc specific as it
is now (and hence re-usable by mac80211) and submit fq.h to
include/net/. Would that be better (it'll probably take a lot longer
to propagate over trees, no?)


>
> Certainly all the code in control plan is not fast path and does not
> deserve being duplicated.

Good point. The fq init/reset stuff is probably a good example.

However if I were to put fq.h into include/net/ where should I put the
init/reset stuff then? net/core/?


Michał
