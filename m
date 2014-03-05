Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbaCER6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 12:58:19 -0500
Message-ID: <1394042296.5275.45.camel@jlt4.sipsolutions.net> (sfid-20140305_185824_269698_56A0D8B7)
Subject: Re: [PATCH 3.14.0-rc5 v3 3/10] rsi: Adding core and main files
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fathima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 18:58:16 +0100
In-Reply-To: <-1822952301-40502@mail.redpinesignals.com>
References: <-1822952301-40502@mail.redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[please don't send HTML emails, the list will drop those]

> In our code, we do fill in skb->priority field as you have seen. Once
> the pkt comes over to my driver, I thought I could over-write the
> priority field as I don't see this field being used again by the
> mac80211 stack. Even in case there is a failure and I call the
> ieee80211_free_txskb( ), I don't see that field being used.
> Considering this, can I not re-use the field within my driver or am I
> missing something in here?

No, I guess you can do that. However, there are cases where the packet
could potentially be reprocessed by mac80211, notably in the AP-side
code for handling powersave clients (ieee80211_sta_ps_deliver_response).
These code paths aren't executed for your driver right now, so this
isn't really a concern, but if you plan on adding AP/GO support then it
might be worth using a field inside skb->cb instead where you already
have other fields.

IOW, it's fine right now, but if you extend your code in the future you
may run into hard to debug issues with it.

johannes

