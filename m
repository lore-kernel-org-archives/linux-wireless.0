Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab1EUPlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2011 11:41:00 -0400
Received: by vws1 with SMTP id 1so3264674vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 May 2011 08:40:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2eafee5b7a180c891df4a9ca53e90d7d@secure.sipsolutions.net>
References: <1305917869.4640.15.camel@jlt3.sipsolutions.net>
 <1305917949.4640.16.camel@jlt3.sipsolutions.net> <BANLkTikjDhdYMssyivgRxAyB5-_FctQbSg@mail.gmail.com>
 <2eafee5b7a180c891df4a9ca53e90d7d@secure.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 21 May 2011 08:40:32 -0700
Message-ID: <BANLkTim+boto9xStdaAyWeTR1+Fw=ADjwA@mail.gmail.com> (sfid-20110521_174104_139637_549C4C24)
Subject: Re: netlink reverts
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 21, 2011 at 1:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 20 May 2011 17:05:12 -0700, Javier Cardona wrote:
>>
>> Don't shoot me, please, it really _was_ a merge issue.  My patch did
>> not insert anything in the middle:
>> https://patchwork.kernel.org/patch/752292  and it was sent a day
>> before you sent the patch adding WoWLAN support:
>> https://patchwork.kernel.org/patch/753772/
>
> Yeah, my mistake, sorry :( I spent half an hour trying to figure out why
> wowlan was just not doing anything and got really confused...
>
> I wonder what we can do to fix it. Reverting it doesn't really help anyone
> either. I have WoWLAN committed in iw and it suddenly fails working in
> mysterious ways because of the added attribute. I suppose you have the same
> problem somewhere with the mesh tools though? Maybe we can just move the
> plink attribute? iw's master branch already has the wowlan code ... But I
> could just as well update nl80211.h in iw I suppose since it's all not
> released anyway, thoughts?

It's ok to move the plink_state attribute.  There are only a handful
of users of the secured mesh at this point.

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
