Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53776 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001Ab1IVHPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:15:17 -0400
Received: by mail-bw0-f48.google.com with SMTP id zu5so3341990bkb.21
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:15:16 -0700 (PDT)
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Luciano Coelho <coelho@ti.com>
To: victorg@ti.com
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4E7ADFFC.8080903@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>
	 <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>
	 <20110921153102.GA32374@jm.kir.nu> <1316619903.2157.546.camel@cumari>
	 <4E7A109C.2010701@ti.com> <1316623133.3940.55.camel@jlt3.sipsolutions.net>
	 <4E7AD88C.4020806@ti.com> <1316674177.2157.563.camel@cumari>
	 <4E7ADFFC.8080903@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 10:15:12 +0300
Message-ID: <1316675712.2157.565.camel@cumari> (sfid-20110922_091520_477999_60BD97EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 10:13 +0300, Victor Goldenshtein wrote: 
> On 22/09/2011 09:49, Luciano Coelho wrote:
> 
> > I guess what Johannes meant is that you can send the genl message in
> > atomic context, so you don't need to save stuff and use the event work.
> > You can just send it immediately when cfg80211_inform_bss() and
> > cfg80211_inform_bss_frame() are called.
> >
> > I'm not really sure you can send genl messages while atomic, I think I
> > had problems with that earlier, but you can try. ;)
> >
> 
> ;)
> 
> Well I already did, and it's not working, when you"ll try to send genl 
> messages while atomic, you will get kernel warning regarding "sleeping 
> function called from invalid context".

That's what I thought.  Johannes?

-- 
Cheers,
Luca.

