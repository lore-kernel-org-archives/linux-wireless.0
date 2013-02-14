Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:62812 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3BNSKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 13:10:23 -0500
Received: by mail-bk0-f49.google.com with SMTP id w11so1206487bku.22
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 10:10:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360840730.8210.1.camel@jlt4.sipsolutions.net>
References: <1360786461-30107-1-git-send-email-thomas@cozybit.com>
 <1360786461-30107-2-git-send-email-thomas@cozybit.com> <1360840730.8210.1.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 14 Feb 2013 10:10:01 -0800
Message-ID: <CAG6hwVNVGgJF3DnGKRbfE1+Bm17+5JKFt_Qn+xbDPushCXwE3w@mail.gmail.com> (sfid-20130214_191029_222469_96F2E8E0)
Subject: Re: [PATCH v2 2/3] mac80211: cache mesh beacon
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 14, 2013 at 3:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-02-13 at 12:14 -0800, Thomas Pedersen wrote:
>> Previously, the entire mesh beacon would be generated each
>> time the beacon timer fired. Instead generate a beacon
>> head and tail (so the TIM can easily be inserted when mesh
>> power save is on) when starting a mesh or the MBSS
>> parameters change.
>>
>> Also add a mutex for protecting beacon updates and
>> preventing leaks.
>
> And I dropped the patch again due to a sparse warning (with RCU sparse
> enabled in Kconfig):

That's handy, I'll keep it enabled in the future.

> net/mac80211/mesh.c:836:9: warning: incorrect type in argument 1 (different address spaces)
> net/mac80211/mesh.c:836:9:    expected struct callback_head *head
> net/mac80211/mesh.c:836:9:    got struct callback_head [noderef] <asn:4>*<noident>
>
> (btw, should there be locking there in that function?)

I think all timers, work, etc. should be stopped at that point, but I
guess it couldn't hurt.

-- 
Thomas
