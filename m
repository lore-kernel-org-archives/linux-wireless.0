Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15224 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbZIAAKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 20:10:22 -0400
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187:
 Implement 	rfkill support)
From: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890908311634y5643818ate9d1b28cbbefa2b2@mail.gmail.com>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	 <3ace41890908311143q697898a3mcbc681d3941b45c9@mail.gmail.com>
	 <43e72e890908311154x51fd9481iea5e10fc5515af80@mail.gmail.com>
	 <3ace41890908311215u378951e8j3283037ec6794764@mail.gmail.com>
	 <43e72e890908311225r3b0d80bcqcb3e3e11d81a255e@mail.gmail.com>
	 <1251749600.5165.1.camel@localhost.localdomain>
	 <1251751251.1266.16.camel@localhost.localdomain>
	 <43e72e890908311445q60c703a3ha8ef8e599e3e712@mail.gmail.com>
	 <43e72e890908311605m368f3703vfd8a25694e69072e@mail.gmail.com>
	 <1251760232.5165.28.camel@localhost.localdomain>
	 <43e72e890908311634y5643818ate9d1b28cbbefa2b2@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 17:09:28 -0700
Message-Id: <1251763768.5165.41.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-31 at 17:34 -0600, Luis R. Rodriguez wrote:
> On Mon, Aug 31, 2009 at 4:10 PM, Inaky
> Perez-Gonzalez<inaky.perez-gonzalez@intel.com> wrote:
> > On Mon, 2009-08-31 at 17:05 -0600, Luis R. Rodriguez wrote:
> >> On Mon, Aug 31, 2009 at 2:45 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> >> > On Mon, Aug 31, 2009 at 1:40 PM, Marcel Holtmann<marcel@holtmann.org> wrote:
> >> >> Hi Luis,
> >> >>
> >> >>> > OK not so bad except for:
> >> >>> >
> >> >>> > > kernel/net/wimax/wimax.ko
> >> >>> >
> >> >>> > That's touching another subsystem but we could technically merge wimax
> >> >>> > into compat-wireless if Inaky thinks that's a good idea. the point
> >> >>> > here is to unify anything that uses rfkill for backport usage.
> >> >>>
> >> >>> Oh boy, can of worms
> >> >>>
> >> >>> I have my own compat-wimax already, which already handles things for
> >> >>> backwards compat (many #ifdef hacks to simplify life) and which is
> >> >>> heavily used internally.
> >> >>>
> >> >>> I don't really know how much worth it might be and I know I don't have
> >> >>> resources to support both.
> >> >>
> >> >> for the wireless-compat tree, I would just remove the RFKILL support for
> >> >> WiMAX. It is really not worth to support it.
> >> >
> >> > Works for me, we then still need to address (if we really care) the
> >> > platform stuff. If someone is interested feel free to send patches to
> >> > add those, I figure as long we get down to the latest supported stable
> >> > kernel it should be good. The latest supported stable kernel is always
> >> > on display on kernel,org, today being 2.6.27.
> >>
> >> BTW inaky -- this is actually up to you, are you wiling to live with
> >> no rfkill for compat?
> >
> > I don't really mind -- but it could be a problem for anyone trying to
> > use it.
> 
> Hm sure and there is still also the issue of users of wimax enabled on
> older kernels and using rfkill there. That is, users not using
> compat-wimax but using just compat-wireless and expecting rfkill to
> work smoothly between wimax and compat-wireless.
> 
> I am not sure of the details of the platform rfkill drivers or how
> wimax or wireless drivers use these.. Perhaps there are no issues, I
> haven't really cared to look into it.
> 
> > Not that I recommend not being able to switch the radio off :)
> > however, the WiMAX stack has APIs for it too, so at least there is a
> > workaround.
> 
> You mean a way to rfkill without rfkill?

the wimax_rfkill() call at the end gets at the same point as the rfkill
call to toggle the radio.

> > But remember, I won't be able to support it at all.
> 
> To support what specifically?

non-trivial bug reports. I always love to hear them, but I am really up
to my neck. I just don't want to create the wrong expectations from
users.

-- 
-- Inaky


