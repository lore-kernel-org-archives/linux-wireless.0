Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3HAIHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 04:07:52 -0400
Message-ID: <1375344469.8608.14.camel@jlt4.sipsolutions.net> (sfid-20130801_100800_043374_B4CD52CC)
Subject: Re: [PATCH v2] mac80211: report some VHT radiotap infos for tx
 status
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 01 Aug 2013 10:07:49 +0200
In-Reply-To: <20130801075649.GA30476@magnum.frso.rivierawaves.com> (sfid-20130801_100412_489490_6D30564D)
References: <1374918424-1305-1-git-send-email-karl.beldan@gmail.com>
	 <1375342554.8608.4.camel@jlt4.sipsolutions.net>
	 <20130801075649.GA30476@magnum.frso.rivierawaves.com>
	 (sfid-20130801_100412_489490_6D30564D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-01 at 09:56 +0200, Karl Beldan wrote:
> On Thu, Aug 01, 2013 at 09:35:54AM +0200, Johannes Berg wrote:
> > On Sat, 2013-07-27 at 11:47 +0200, Karl Beldan wrote:
> > 
> > > +		/* required alignment from rthdr */
> > > +		pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);
> > 
> > This is bad, it potentially leaks a byte of kernel data, please
> > explicitly clear the padding, like
> > 
> > if ((pos - (u8 *)rthdr) & 1)
> >   *pos++ = 0;
> > 
> I don't see what's wrong.
> The whole radiotap space is already zeroed, as for the 'leaks' I don't
> see how it could leak either.

Oh, I didn't see that, I'll apply the patch then.

johannes

