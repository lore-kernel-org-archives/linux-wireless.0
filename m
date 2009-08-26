Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:42046 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbZHZMrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 08:47:10 -0400
Received: by pzk30 with SMTP id 30so99856pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 05:47:12 -0700 (PDT)
Message-ID: <4A952E80.4040306@lwfinger.net>
Date: Wed, 26 Aug 2009 07:45:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
References: <950315.98615.qm@web23105.mail.ird.yahoo.com>	 <1251192477.10667.3.camel@johannes.local>	 <3ace41890908251943n4affc955n61768e2ce98d0c94@mail.gmail.com> <1251277063.10667.10.camel@johannes.local>
In-Reply-To: <1251277063.10667.10.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-08-26 at 03:43 +0100, Hin-Tak Leung wrote:
> 
>> The rfkill event hard just goes 1 and 0 whenever I slide the switch,
>> regardless of what NM does . e.g. NM set to disable networking has no
>> effect on the 1/0 switch (it happens just depending on the slide
>> switch and nothing else), and nothing changes when NM noticed
>> rfkill'ed if down & decided to if'up and reassociate.
> 
> Right, I just wanted to make sure the switch could be correctly read
> while the interface is down.
> 
>> Basically the rfkill event state just depends on the slide switch,
>> regardless of NM (if it is set to enable wireless networking, it just
>> if up the device again; if it is set to disable, it just stayed
>> disable & the device stay down, but the event state continues to
>> respond to the slide switch).
> 
> Ok. But this isn't making a lot of sense to me, since cfg80211 should
> refuse to UP the device when it's rfkilled.
> 
> Or wait ... are you using compat-wireless?

Yes he is.

