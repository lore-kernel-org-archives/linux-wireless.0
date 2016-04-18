Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33527 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbcDRMbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 08:31:15 -0400
Received: by mail-pf0-f176.google.com with SMTP id 184so80990259pff.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 05:31:14 -0700 (PDT)
Message-ID: <1460982672.10638.111.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20160418_143123_594293_0FAFCF2A)
Subject: Re: [Codel] [PATCHv3 2/5] mac80211: implement fair queueing per txq
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	codel@lists.bufferbloat.net, Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 18 Apr 2016 05:31:12 -0700
In-Reply-To: <CA+BoTQmuTAjR-cSuJmsAm5Ms3sTrtPT8HxE_tYf1EGOMGeHVcw@mail.gmail.com>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-3-git-send-email-michal.kazior@tieto.com>
	 <1460845384.2075.27.camel@sipsolutions.net>
	 <1460845552.2075.28.camel@sipsolutions.net>
	 <CA+BoTQmuTAjR-cSuJmsAm5Ms3sTrtPT8HxE_tYf1EGOMGeHVcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-18 at 07:16 +0200, Michal Kazior wrote:

> 
> I guess .h file can give the compiler an opportunity for more
> optimizations. With .c you would need LTO which I'm not sure if it's
> available everywhere.
> 

This makes little sense really. Otherwise everything would be in .h
files.

include/net/codel.h is an include file because both codel and fq_codel
use a common template for codel_dequeue() in fast path.

But net/mac80211/fq.h is included once, so should be a .c

Certainly all the code in control plan is not fast path and does not
deserve being duplicated.



