Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53867 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3HAIEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 04:04:13 -0400
Received: by mail-wi0-f179.google.com with SMTP id hr7so1512085wib.12
        for <linux-wireless@vger.kernel.org>; Thu, 01 Aug 2013 01:04:11 -0700 (PDT)
Date: Thu, 1 Aug 2013 09:56:49 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2] mac80211: report some VHT radiotap infos for tx status
Message-ID: <20130801075649.GA30476@magnum.frso.rivierawaves.com> (sfid-20130801_100421_250651_7B8A29E9)
References: <1374918424-1305-1-git-send-email-karl.beldan@gmail.com>
 <1375342554.8608.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1375342554.8608.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 01, 2013 at 09:35:54AM +0200, Johannes Berg wrote:
> On Sat, 2013-07-27 at 11:47 +0200, Karl Beldan wrote:
> 
> > +		/* required alignment from rthdr */
> > +		pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);
> 
> This is bad, it potentially leaks a byte of kernel data, please
> explicitly clear the padding, like
> 
> if ((pos - (u8 *)rthdr) & 1)
>   *pos++ = 0;
> 
I don't see what's wrong.
The whole radiotap space is already zeroed, as for the 'leaks' I don't
see how it could leak either.
Though, if you prefer, I can replace
	pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);
with:
	if ((pos - (u8 *)rthdr) & 1)
		pos++;

-- 
Karl
