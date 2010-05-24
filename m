Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51028 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0EXFWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 01:22:35 -0400
Subject: Re: [RFC PATCH 1/1] cfg80211: Fix user-space crda query stall
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87eih4hvzd.fsf@purkki.valot.fi>
References: <1274438539-11259-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274438539-11259-2-git-send-email-juuso.oikarinen@nokia.com>
	 <87eih4hvzd.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 08:23:34 +0300
Message-ID: <1274678614.5277.40.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-22 at 16:06 +0200, ext Kalle Valo wrote:
> Moi Juuso,
> 
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> 
> > The userspace crda utility can fail to respond to kernel requests in (at least)
> > two scenarios: it is not runnable for any reason, or it is invoked with a
> > country code not in its database.
> >
> 
> [...]
> 
> > +	printk(KERN_INFO "cfg80211: Call crda daemon timed out for country: "
> > +	       "%c%c\n", last_request->alpha2[0], last_request->alpha2[1]);
> 
> I would prefer to mention in the print that kernel will revert back to
> world domain. Nicer for the users.
> 

That actually happens, because as the code forces the change to the
world domain, there will that "world reg domain updated" trace.

I could also adjust this trace to indicate, what is going to happen.

-Juuso

