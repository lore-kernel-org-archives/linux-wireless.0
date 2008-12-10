Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:51804 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbYLJQPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 11:15:30 -0500
Received: by ewy10 with SMTP id 10so806733ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 08:15:27 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] b43: rework rfkill code
Date: Wed, 10 Dec 2008 17:15:24 +0100
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
References: <20081210150935.GA10927@srcf.ucam.org> <1228922997.15837.6.camel@johannes.berg>
In-Reply-To: <1228922997.15837.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812101715.25060.IvDoorn@gmail.com> (sfid-20081210_171537_406698_36F13A82)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 December 2008, Johannes Berg wrote:
> On Wed, 2008-12-10 at 15:09 +0000, Matthew Garrett wrote:
> 
> > The final change is that I removed the code for changing the wireless 
> > state in response to the txpower configuration in mac80211. Right now, I 
> > can't see any way for this to work correctly - if the user disables the 
> > radio via rfkill, mac80211 doesn't flag the radio as disabled. As a 
> > result, the next time the configuration callback is called, b43 
> > reenables the radio again, even though the user has explicitly disabled 
> > it. I don't think any of the other drivers handle this case, so I'm not 
> > really sure what the best way to handle this in future is. The current 
> > situation certainly seems broken.
> 
> We're going to have to integrate rfkill with mac80211, but nobody cares.

It's on the rt2x00 todo list since quite some time already in the hope to
find a volunteer who was willing to do it.
I can't promise any patches for at least a month in this area, but I'll see if
I can take a shot at this in a couple of weeks time.

Ivo
