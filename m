Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28746 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbcFNOk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:40:29 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix potential null dereference bugs
Date: Tue, 14 Jun 2016 14:39:52 +0000
Message-ID: <87d1njzvew.fsf@kamboji.qca.qualcomm.com> (sfid-20160614_164033_186092_3C2EDE18)
References: <1465563164-783-1-git-send-email-me@bobcopeland.com>
	<CA+BoTQkg+uea_YzUgrVBPhA8uRxNpd29Kd1y1tvt0a-JyOSLQw@mail.gmail.com>
	<1465808939.2434.1.camel@sipsolutions.net>	<20160613130507.GA11074@localhost>
	<1465823880.10050.3.camel@sipsolutions.net>
	<87shwf3mlh.fsf@kamboji.qca.qualcomm.com>	<20160614141606.GA713@localhost>
In-Reply-To: <20160614141606.GA713@localhost> (Bob Copeland's message of "Tue,
	14 Jun 2016 10:16:06 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

>> > However, with all this, I think I'd simply not take any chances - the
>> > patch isn't exactly invasive and in some cases (for example the first
>> > hunk of the patch) will even improve the code to the point where the
>> > compiler could warn about uninitialized usage of the pointer when the
>> > code gets modified to use it in case of !txq->sta.
>> >
>> > I'd take it, but I guess it's Kalle's decision :)
>> 
>> Yeah, I'm leaning towards Johannes. These are not really invasive.
>
> Thanks, and sorry about the checkpatch -- I did run checkpatch on it but
> for some reason my version only complained about some of them.

I actually have a custom script which enables (and disables) various
checkpatch checks, most likely that's why you didn't see it.

https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-check

-- 
Kalle Valo