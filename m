Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f12.google.com ([209.85.217.12]:52995 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYLKAci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 19:32:38 -0500
Received: by gxk5 with SMTP id 5so212053gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 16:32:37 -0800 (PST)
Message-ID: <646765f40812101632u76847935l2405482aabe1c1f8@mail.gmail.com> (sfid-20081211_013241_317065_A9EE03DA)
Date: Thu, 11 Dec 2008 11:32:37 +1100
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] b43: rework rfkill code
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228922997.15837.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081210150935.GA10927@srcf.ucam.org>
	 <1228922997.15837.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 02:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2008-12-10 at 15:09 +0000, Matthew Garrett wrote:
>
>> The final change is that I removed the code for changing the wireless
>> state in response to the txpower configuration in mac80211. Right now, I
>> can't see any way for this to work correctly - if the user disables the
>> radio via rfkill, mac80211 doesn't flag the radio as disabled. As a
>> result, the next time the configuration callback is called, b43
>> reenables the radio again, even though the user has explicitly disabled
>> it. I don't think any of the other drivers handle this case, so I'm not
>> really sure what the best way to handle this in future is. The current
>> situation certainly seems broken.
>
> We're going to have to integrate rfkill with mac80211, but nobody cares.

What strikes me, watching this from the outside - is that rfkill and
power saving seem to be doing essentially the same thing: temporarily
powering down the radio / card.

If we're going to integrate rfkill and mac80211 or rewrite rfkill, why
not hook it into power saving too?

Just my $0.01

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
