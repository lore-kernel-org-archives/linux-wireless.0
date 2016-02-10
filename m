Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbcBJQx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 11:53:29 -0500
Message-ID: <1455123205.19821.34.camel@redhat.com> (sfid-20160210_175351_578851_9C8F9184)
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Wed, 10 Feb 2016 10:53:25 -0600
In-Reply-To: <1455120444.4991.1.camel@sipsolutions.net>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
	 <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
	 <1454947887.5325.8.camel@redhat.com>
	 <1455120444.4991.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-10 at 17:07 +0100, Johannes Berg wrote:
> On Mon, 2016-02-08 at 10:11 -0600, Dan Williams wrote:
> > I'd like to clarify a bit, so tell me if I'm correct or not.  Using
> > RFKILL_OP_AIRPLANE_MODE_CHANGE does not actually change any device
> > state. It's just an indicator with no relationship to any of the
> > registered rfkill switches, right?
> 
> Yes. I'm not sure I'm totally happy with this userspace API.
> 
> > I wonder if setting RFKILL_OP_AIRPLANE_MODE_CHANGE(true) shouldn't
> > also
> > softblock all switches, otherwise you can set airplane mode all day
> > long with RFKILL_OP_AIRPLANE_MODE_CHANGE and it doesn't actually
> > enable
> > airplane mode at all?
> 
> No, this is kinda the point that you could implement your policy in
> userspace now.

Yeah, I get that now.  It's just that to me, something called
"AIRPLANE_MODE_CHANGE" seems like it should actually change airplane
mode on/off, which implies killing radios.  I wouldn't have had the
problem if it was named AIRPLANE_MODE_INDICATOR_CHANGE, which makes it
clear this is simply an indicator and has no actual effect on anything
other than a LED.

Dan
