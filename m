Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50069 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYJaRlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 13:41:24 -0400
Subject: Re: Guidelines regarding separate directory
From: Pavel Roskin <proski@gnu.org>
To: Richard Farina <sidhayn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dave <kilroyd@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <490B3AAC.1000803@gmail.com>
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com>  <1225399481.7931.5.camel@dv>
	 <1225399682.3690.82.camel@johannes.berg>  <490B3AAC.1000803@gmail.com>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 13:41:07 -0400
Message-Id: <1225474867.23627.4.camel@dv> (sfid-20081031_184128_969302_7A16A810)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-31 at 13:04 -0400, Richard Farina wrote:
> Johannes Berg wrote:
> >>> orinoco_pci.c
> >>>       
> >> orinoco_pci.c is a good candidate for removal.  It only supports the
> >> hardware that is already supported by hostap_pci.
> >>     
> >
> > Wait wait. I think everybody would rather see hostap go than orinoco
> > since hostap is a huge complex thing and quite buggy.
> >
> >   
> I really disagree with this statement.  Until kernel version 2.6.21 the 
> hostap driver was used very widely by the wifi security community 
> because of it's great abilities for monitor mode and frame injection.  
> In kernel 2.6.21 there was a change that made the injection patches not 
> work and my ability is insufficient to fix this regression, however, the 
> orinoco driver has always had morbid issues with simple things such as 
> monitor mode.

The only issue I know in the monitor mode in orinoco is lack of radiotap
headers.  That should not be hard to add.  Issues with Agere firmware
are irrelevant since hostap doesn't support it.  Are there any other
issues you have in mind?

> I understand that hostap needs some work, and it would be nice if 
> someone volunteered to help fix the packet injection, but removing this 
> driver in favor of orinoco_cs would be a serious regression.

At this point, I agree.  It's better that we concentrate on fixing known
issues rather than on choosing which driver to remove.

-- 
Regards,
Pavel Roskin
