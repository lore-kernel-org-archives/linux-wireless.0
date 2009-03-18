Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:57398 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671AbZCRNbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 09:31:49 -0400
Received: by ewy9 with SMTP id 9so41376ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 06:31:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 mesh support
Date: Wed, 18 Mar 2009 14:31:42 +0100
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903181348.51609.IvDoorn@gmail.com> <1237381972.5100.21.camel@johannes.local>
In-Reply-To: <1237381972.5100.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903181431.43048.IvDoorn@gmail.com> (sfid-20090318_143210_583519_B93D54BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 18 March 2009, Johannes Berg wrote:
> On Wed, 2009-03-18 at 13:48 +0100, Ivo van Doorn wrote:
> 
> > Excellent thanks. :)
> > 
> > Johannes, my previous assumption is apparently correct,
> > The following is happening:
> > 
> > ieee80211_open()
> > 	-> ops->add_interface()
> > 	-> ieee80211_start_mesh()
> > 		->  ieee80211_if_config()
> > 			-> ops->config_interface()
> > 	-> ieee80211_hw_config()
> > 		-> ops->config()
> > 
> > Because config_interface() is called before config() the radio
> > is not enabled at the moment config_interface() is called and
> > the call to config() will effectively disable beaconing.
> 
> Ah. I thought you were saying ->start() came after ->config_interface(),

Yeah that was my first guess :)

> ->config() coming after it makes no sense either but we haven't even
> tried to avoid that so far... In fact, it is perfectly legal for
> ->config() to be called after ->config_interface() when, for example,
> you change the channel. Not that I disagree -- we should be setting the
> beacon interval before enabling beaconing...

True, the problem however is that when enabling the radio it is possible/likely
that a lot of settings will be lost. For rt2x00 we must reset almost all registers
to make sure everything is set correctly again.

> What exactly is the problem here? The fact that we don't enable the
> radio until after having configured beaconing? I'm not sure how to solve
> this, to be honest.

Neither do I, perhaps we should make sure that a call to config() when
the enabled_radio field has changed should trigger additional reconfigurations
as well. But I don't really like such a solution.. :(

Perhaps should check if a beacon was provided while the radio was off,
and either request a new beacon or upload the previously provided beacon when
the radio is being enabled.

Ivo
