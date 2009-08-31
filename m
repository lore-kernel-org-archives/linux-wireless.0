Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZHaUOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 16:14:14 -0400
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187:
 Implement 	rfkill support)
From: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890908311225r3b0d80bcqcb3e3e11d81a255e@mail.gmail.com>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	 <43e72e890908261528m23b8fe78w209e305f27e68fa1@mail.gmail.com>
	 <3ace41890908261555g339e65d1n6627cc3d1713287e@mail.gmail.com>
	 <43e72e890908261645n24a040cds84f012095a40c15b@mail.gmail.com>
	 <1251357267.20531.4.camel@johannes.local>
	 <3ace41890908270243i7c1d8ddav322a35c566d2c010@mail.gmail.com>
	 <3ace41890908311143q697898a3mcbc681d3941b45c9@mail.gmail.com>
	 <43e72e890908311154x51fd9481iea5e10fc5515af80@mail.gmail.com>
	 <3ace41890908311215u378951e8j3283037ec6794764@mail.gmail.com>
	 <43e72e890908311225r3b0d80bcqcb3e3e11d81a255e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 13:13:20 -0700
Message-Id: <1251749600.5165.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-31 at 13:25 -0600, Luis R. Rodriguez wrote:

> OK not so bad except for:
> 
> > kernel/net/wimax/wimax.ko
> 
> That's touching another subsystem but we could technically merge wimax
> into compat-wireless if Inaky thinks that's a good idea. the point
> here is to unify anything that uses rfkill for backport usage.

Oh boy, can of worms

I have my own compat-wimax already, which already handles things for
backwards compat (many #ifdef hacks to simplify life) and which is
heavily used internally. 

I don't really know how much worth it might be and I know I don't have
resources to support both.

> > If everything that depends on rkill is bundled with
> > compat-wireless, there is probablt no need for the symbol and sysfs
> > renaming hacks.
> 
> Right which is why I think this may be reasonable to do. Any thoughts Inaky?
>   Luis

-- 
-- Inaky


