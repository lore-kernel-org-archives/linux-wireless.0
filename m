Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:21251 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYLRBiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 20:38:50 -0500
Received: by ti-out-0910.google.com with SMTP id b6so63084tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 17:38:48 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18761.43312.692142.691266@localhost.localdomain> (sfid-20081218_023854_369275_3D83E369)
Date: Thu, 18 Dec 2008 07:06:48 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	jouni.malinen@atheros.com
Subject: Re: [RFC] Handle Channel Switch Announcement
In-Reply-To: <1229537272.4268.7.camel@localhost>
References: <18761.4838.509784.281821@localhost.localdomain>
	<1229537272.4268.7.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I agree with Jouni, this is probably not a good idea, especially since
> this flag would be shared between hardware for those drivers that have
> the channel structs allocated statically. We should probably just stick
> a struct ieee80211_channel *switch_from; pointer somewhere into the
> sdata struct or so.

Ok.

> I think I'd like to have them dropped to monitor for !station here,
> instead of silently in the processing function.

Ok.

> That should probably be removed or be more specific & protected by some
> debug #ifdef.

That just slipped through, I'll remove it.

> Can you rebase this on top of Kalle's patch that adds the "stop reasons"
> for each queue? As it is now, the driver could wake up the queues again
> if one was full.

Ok, I will.

Sujith
