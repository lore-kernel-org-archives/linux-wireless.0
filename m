Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:48959 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZF1J0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jun 2009 05:26:09 -0400
Received: by ewy6 with SMTP id 6so4718841ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 28 Jun 2009 02:26:11 -0700 (PDT)
Message-ID: <4A473730.3000409@gmail.com>
Date: Sun, 28 Jun 2009 10:26:08 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 00/11] cfg80211 connect API + wireless extension move
References: <20090624120745.239294066@sipsolutions.net>	 <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>	 <4A43E002.2060309@gmail.com> <1246047520.21314.67.camel@johannes.local>
In-Reply-To: <1246047520.21314.67.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Yes. Mind you, I was not only talking about iwpriv, but also about
> things like orinoco's spy support or get/set sensitivity. The latter we
> don't quite understand -- can you tell us what it actually does? Spy
> support should just be removed, I think.

I've had a closer look at this.

The sensitivity basically controls the roaming threshold when handled by
firmware. It is a firmware setting, though the Agere driver also
validates the multicast rates based on it. The drivers/firmware use
terms like system scale, AP density, distance between APs.

There are 3 valid values:

3 - high density of APs. Maintain 11Mbps by roaming.
2 - medium density of APs. Maintain 2Mbps.
1 - low density. Maintain 1Mbps.

Although the values are defined in terms of the usable bitrate, the
(Intersil) documentation states that the implementation is based on SNR.



Dave.
