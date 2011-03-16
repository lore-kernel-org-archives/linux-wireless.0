Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1CPJz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 05:55:59 -0400
Received: by pzk9 with SMTP id 9so241869pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 02:55:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinH1DykLDu5=Sd+p-PugEC1bOayG=ojaAscJKBB@mail.gmail.com>
References: <1300268390.3761.14.camel@jlt3.sipsolutions.net>
	<AANLkTi=r-iktQVn8b1=iCh0PFDDP=mSVBUeqBfxa5e_B@mail.gmail.com>
	<AANLkTinH1DykLDu5=Sd+p-PugEC1bOayG=ojaAscJKBB@mail.gmail.com>
Date: Wed, 16 Mar 2011 11:55:58 +0200
Message-ID: <AANLkTi=q2BYKkj9Ao+HT5maZok_U-_6oT+y18EF-OHBf@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix comment regarding aggregation buf_size
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 11:51, Daniel Halperin
<dhalperi@cs.washington.edu> wrote:
> That last line should really be:
>
>>> + *     Note that the following is also illegal because it will violate buffering assumptions if frame 1 is lost again

agreed - the Txer cannot send any frame with seqNum greater than SSN
from last BA reponse + window size. In this case, the SSN of last BA
is 0, so you cannot send 8 and any further frame until you get the BA
response for 1.

>>> + *      - TX:         189.....
>>
>> Dan
>>
>
