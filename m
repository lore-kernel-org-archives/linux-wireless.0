Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:62783 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbXEJWZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 18:25:00 -0400
Received: by ug-out-1314.google.com with SMTP id 44so699992uga
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2007 15:24:58 -0700 (PDT)
Message-ID: <1ba2fa240705101524x2676a09eyeff3b71ed2542478@mail.gmail.com>
Date: Fri, 11 May 2007 01:24:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Benc" <jbenc@suse.cz>
Subject: Re: Specifing rate control algorithm?
Cc: jketreno <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <20070510212355.6c13cde8@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <464253CE.2030504@linux.intel.com>
	 <20070510132756.2ca660a0@midnight.suse.cz>
	 <46434596.6010908@linux.intel.com>
	 <20070510194233.335004b7@griffin.suse.cz>
	 <46437DC8.2060805@linux.intel.com>
	 <20070510212355.6c13cde8@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/10/07, Jiri Benc <jbenc@suse.cz> wrote:
> On Thu, 10 May 2007 13:17:12 -0700, jketreno wrote:
> > > Please send your rate control algorithm first so we can know why are
> > > you requesting this.
> >
> > I told you the reason why I am requesting this.  Do you think I'm lying
> > or trying to trick you?
>
> I'm not convinced your request is reasonable. But as Jouni pointed out,
> there _could be_ some specific circumstances under which it could make
> sense. I'm not aware of any such circumstance now.
>
> You said you have a code. Show it. I can assure you that if it turns
> out from the code that your request is valid, you will have no problems
> with your patch.
>
> We're opensource. Please keep that in mind. If you need to prove
> something, send a code.

The code is available why should it be paste it to the email.

> > Generic algorithms aren't as capable as hardware specific algorithms
> > when you factor performance, latency, system utilization, power
> > consumption, etc.  Optimal algorithms are written to take advantage of
> > the capabilities exposed by the hardware.
>
> You said the same about hardware scanning. Michael showed you that's
> not true.
>
Michael has shortened the dwell time on the channel, while hw scanning
has shorten switching time from the channel to channel and no the time
you are listening on the channel
I wouldn't call it an optimization. Did he measured the power consumption ?

> > The 3945, as an example, let's you configure the hardware with a set of
> > rates, retries per rate, and a fallback order.  You submit one Tx
> > request to the hardware and it then performs all the retries,
> > fallbacks, etc without host interaction over overhead.
>
> I don't see anything fundamentally different from other hardware.
>
The God is in the details

> > The rate control algorithm needs to be aware of the attempts made by
> > the hardware.  The specific mechanism by which the 3945 sets up those
> > rates is device specific.  The mechanism by which the results are
> > reported back are device specific.  The functions related to selecting
> > the Tx rate are called twice for *EVERY PACKET*.  Anything you can do
> > to make that code-path faster and leaner for the specific device it is
> > using is a win.  Hardware specific beats generic.
>
> Okay, show the code. Maybe we will be able to find a better way to deal
> with that.
>
> > Might other hardware devices also support some type of rate fallback or
> > automatic retries?  Maybe.
>
> They do.
>
> > Do they all do it the same way?  No.
>
> That's valid for almost everything in the stack. Yet we have (and want
> to have) one stack and don't want each driver to implement its parts on
> their own.
>
> > Is it worth slowing down hot code paths in the name of "generic
> > software"? Absolutely not.
>
> If the slowdown is not big, yes, it is. Unifying things almost always
> means you need to accept some trade-offs.

Clean API gives you the ability to enjoy from the both worlds. WiFi is
about mobility power saving and therefore hw offloading is essential.
What worth the few more lines of the code that gives you this ability
this is also a trade-off.

> > PS.  You're free to download the 3945 specific rate control algorithm
> > if you want.  It has been part of the GPL ipw3945 driver for over a
> > year at http://ipw3945.sf.net.  You can also find it refactored in
> > iwlwifi at http://intellinuxgraphics.org.
>
> Could you send just the rate control algorithm (or an excerpt of it)
> to this list so more people will look at it?
>
> Thanks.
>
>  Jiri
>
> --
> Jiri Benc
> SUSE Labs
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
