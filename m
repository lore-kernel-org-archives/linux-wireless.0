Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:35217 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0DMJOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 05:14:10 -0400
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout
 configuration
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ylalehto Janne (Nokia-D/Tampere)" <janne.ylalehto@nokia.com>
In-Reply-To: <87sk6zoh4x.fsf@purkki.valot.fi>
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271061120.3877.6.camel@jlt3.sipsolutions.net>
	 <1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
	 <1271063175.3877.13.camel@jlt3.sipsolutions.net>
	 <1271065535.10120.1191.camel@wimaxnb.nmp.nokia.com>
	 <871vekpexo.fsf@purkki.valot.fi>
	 <1271143746.10120.1232.camel@wimaxnb.nmp.nokia.com>
	 <87wrwboirr.fsf@purkki.valot.fi>
	 <1271148573.10120.1257.camel@wimaxnb.nmp.nokia.com>
	 <87sk6zoh4x.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 12:10:02 +0300
Message-ID: <1271149802.10120.1262.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-13 at 11:07 +0200, ext Kalle Valo wrote:
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> 
> >> > The problem here is that the latency at least cannot be used in any
> >> > simple and/or general way I can think of to control the dynamic PS
> >> > timeout.
> >> 
> >> Can't you do something like this:
> >> 
> >> pm_qos >= 1000 -> timeout 0 ms (aka. full power save)
> >> pm_qos <= 100 -> timeout 100 ms
> >> pm_qos <= 50 -> timeout 300 ms
> >> 
> >> That is, just some arbitrary numbers but which affect dynamic ps
> >> timeout. I haven't thought about the numbers at all, but they actually
> >> don't matter because it's easy to change them inside mac80211.
> >
> > Theoretically I could, but I'm pretty sure whatever values I would
> > choose would be unacceptable by others, as they would be tuned for a
> > specific use.
> 
> I don't see a problem with that. The current use of pm_qos is very
> limited, I think it's all positive if we start using it more.
> 
> > Also, although AFAIK barely anyone uses the DTIM interval which is
> > determined based on th pm_qos, adding arbitrary rules like this to the
> > side risks breaking something for someone.
> 
> AFAIK the pm_qos values are not set in stone in any. Applications just
> request something and kernel can do whatever it wants, even ignore it.
> So I don't see any harm if we change how mac80211 uses pm_qos values.
> And most probably this will change many times in the future.
> 

Ok, you convinced me. I will send a RFC patch with the above, and will
sub-sequentially be flamed to death ;)

Be sure to look into that bug in wl1251 at some point, so I don't break
it with this, if by chance I get this to go through ;)

-Juuso

