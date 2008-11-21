Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58973 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbYKUTCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 14:02:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: What should wireless drivers do under -ENOMEM
Date: Fri, 21 Nov 2008 20:01:46 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <43e72e890811211055x19882fa1l5ced86b6a031a203@mail.gmail.com>
In-Reply-To: <43e72e890811211055x19882fa1l5ced86b6a031a203@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811212001.46336.mb@bu3sch.de> (sfid-20081121_200214_093066_D8EA6618)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 November 2008 19:55:12 Luis R. Rodriguez wrote:
> Under heavy stress you can sometimes run into -ENOMEM and you inform
> the callers. Now ath5k/ath9k both require dev_alloc_skb()'ing some
> buffers when RXing. Right now we simply move on, but I think it'd be
> nicer to inform mac80211 and let mac80211 decide. If the system is


Well, what should mac80211 decide?
If you are under such heavy load that memory allocations fail, we really have
only one chance. That is drop the network traffic until memory allocation
works again.
I don't see anything else we can do.


-- 
Greetings Michael.
