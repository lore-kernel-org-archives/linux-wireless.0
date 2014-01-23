Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38991 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaAWNme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 08:42:34 -0500
Received: by mail-ie0-f173.google.com with SMTP id e14so1096460iej.32
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 05:42:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D56A24@HASMSX103.ger.corp.intel.com>
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
	<1390394079.4334.30.camel@jlt4.sipsolutions.net>
	<20140122130924.GA18365@magnum.frso.rivierawaves.com>
	<CAGXE3d_V2vST4nkFLUeXgTwbzB_GfPYM3HzBC1QjLuG_=LP2Kw@mail.gmail.com>
	<20140122152845.GB18365@magnum.frso.rivierawaves.com>
	<CAGXE3d8_qukp_gb4P0PnJkQJT8MtsypYgzPojE+RqpzEK_R62Q@mail.gmail.com>
	<20140122164122.GC18365@magnum.frso.rivierawaves.com>
	<1390416713.4334.46.camel@jlt4.sipsolutions.net>
	<20140122191610.GD18365@magnum.frso.rivierawaves.com>
	<1390418495.4334.49.camel@jlt4.sipsolutions.net>
	<970cacf7-158d-4f3f-8a7e-c77a43f3185b@email.android.com>
	<0BA3FCBA62E2DC44AF3030971E174FB303D56A24@HASMSX103.ger.corp.intel.com>
Date: Thu, 23 Jan 2014 14:42:33 +0100
Message-ID: <CAGXE3d_VJ=QPTv4f6LfKror3H0dyQsVio5urkbVKUyKmZSoDYQ@mail.gmail.com> (sfid-20140123_144239_020994_371639A8)
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 23, 2014 at 7:08 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>> >> So, I guess you are taking what I sent ?
>> >
>> >Haven't really made up my mind yet ... I think it's more correct, so I
>> >should, but I also don't really want to break the ralink drivers over
>> >what seems to me to be a fairly small issue.
>>
>> I think I'm fine with this now. Let's just see if someone experiences any
>> issues ...
>>
>>  Furthermore I think i even remember that you can force ralink HW to stop a
>> BA session. But all in all lets better comply with the spec ...
>
> Well - you need to see what "stop a BA session" mean. If you are able to tell the HW no AMPDUs anymore *now*, then ok - but you still have the out-of-order TX problem. Unless you use the same TX queue for AMPUs and non-AMPDUs and don't fear reordering issues

We shouldn't have reordering issues in rt2x00 since AMPDUs and MPDUs
go through the same hw queue.
However, at the moment the hw will keep on sending AMPDUs that are in
the TX queue even after we received a DELBA.
But this is an issue with the ralink drivers ...

Helmut
