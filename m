Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:52302 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYGBNQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 09:16:22 -0400
Received: by yx-out-2324.google.com with SMTP id 8so79699yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2008 06:16:20 -0700 (PDT)
Date: Wed, 2 Jul 2008 09:16:15 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Message-ID: <20080702091315.ZZRA012@mailhub.coreip.homeip.net> (sfid-20080702_151626_755447_A4844177)
References: <20080701225207.GB4292@khazad-dum.debian.net> <1214952993.3462.14.camel@johannes.berg> <20080701235747.GG4292@khazad-dum.debian.net> <1214983270.3462.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214983270.3462.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 02, 2008 at 09:21:10AM +0200, Johannes Berg wrote:
> 
> > So, please accept my appologies on the tone of the last email.  Please
> > reconsider reading that email in full, and please try to ignore the rantness
> > smell in it.  I did try to explain the technical reasons why some changes
> > would be needed in b43.
> 
> Ok. I actually did read it but decided not to reply to most things. I
> don't think it's that everybody needs to be educated on the input layer
> (I've written real input drivers before) but rather that nobody really
> knows how userspace/kernel interaction wrt. rfkill should work.
> 

I guess I just need to re-iterate that using input layer to propagate
state change was not the best idea, because at any moment userspace
can issue EVIOCGRAB on the event device preventing anyone from getting
such event. I think I mentioned this to Michael once before.

-- 
Dmitry
