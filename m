Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33182 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbcCJS5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 13:57:36 -0500
MIME-Version: 1.0
In-Reply-To: <CA+BoTQk+3jhwK57_fDw0scNCGzu_Edqp9-Beeppz8xj9kSQcoQ@mail.gmail.com>
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
	<CAA93jw4XsEnp3jTgPL7OKWTJP-83VwRaCdb+foc8nCuqxk3WZA@mail.gmail.com>
	<CA+BoTQk+3jhwK57_fDw0scNCGzu_Edqp9-Beeppz8xj9kSQcoQ@mail.gmail.com>
Date: Thu, 10 Mar 2016 10:57:35 -0800
Message-ID: <CAA93jw47wtioiUUD8ZTm4hFSVL7Uc8ubpSG5urHtWQhfAo1nmQ@mail.gmail.com> (sfid-20160310_195742_606283_FAB4CB62)
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
From: Dave Taht <dave.taht@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Tim Shepard <shep@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> regular fq_codel uses 1024 and there has not been much reason to
>> change it. In the case of an AP which has more limited memory, 256 or
>> 1024 would be a good setting, per station. I'd stick to 1024 for now.
>
> Do note that the 4096 is shared _across_ station-tid queues. It is not
> per-station. If you have 10 stations you still have 4096 flows
> (actually 4096 + 16*10, because each tid - and there are 16 - has it's
> own fallback flow in case of hash collision on the global flowmap to
> maintain per-sta-tid queuing).

I have to admit I didn't parse this well - still haven't, I think I
need to draw. (got a picture?)

Where is this part happening in the code (or firmware?)

" because each tid - and there are 16 - has it's
 own fallback flow in case of hash collision on the global flowmap to
 maintain per-sta-tid queuing"

"fallback flow - hash collision on global flowmap" - huh?

> With that in mind do you still think 1024 is enough?

Can't answer that question without understanding what you said above.

I assembled a few of the patches to date (your fq_codel patch, avery's
and tims ath9k stuff) and tested them, to no measurable effect,
against linus's tree a day or two back. I also acquired an ath10k card
- would one of these suit?

http://www.amazon.com/gp/product/B011SIMFR8?psc=1&redirect=true&ref_=oh_aui_detailpage_o08_s00
