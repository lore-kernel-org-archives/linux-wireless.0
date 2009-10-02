Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.netcomga.sk ([217.118.103.2]:1865 "EHLO netcomga.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754749AbZJBWBI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 18:01:08 -0400
Message-ID: <4AC67144.5060508@netcomga.sk>
Date: Fri, 02 Oct 2009 23:31:48 +0200
From: Trepak Vilmos <trepo@netcomga.sk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: driver_nl80211 broken again
References: <1251117161.22951.4.camel@maxim-laptop>	<1251122885.12007.12.camel@johannes.local>	<1251144381.9374.4.camel@maxim-laptop>	<1251147515.20161.3.camel@johannes.local>	<1252116503.2398.26.camel@maxim-laptop>	<1252423769.3806.4.camel@johannes.local>	<1252443260.16422.5.camel@maxim-laptop>	<1254273569.4499.8.camel@maxim-laptop>	<20090930221353.GB11052@jm.kir.nu> <1254386786.3959.18.camel@johannes.local>
In-Reply-To: <1254386786.3959.18.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2009-10-01 at 01:13 +0300, Jouni Malinen wrote:
>> To me, this looks broken. When wpa_supplicant requests a
>> disassociastion, it is _only_ asking for disassociation, not
>> deauthentication. cfg80211/mac80211 may not currently handle that, but
>> as far as I can tell, it sounds like an issue there and not in
>> wpa_supplicant. Johannes may disagree with this, though.
>
> cfg80211/mac80211 _do_ handle that. If you ask for disassociation, it
> stays authenticated, and later expects you to still remember that and
> refuses authentication since you're already authenticated.
>
>> I don't think either of those options would be acceptable for
>> wpa_supplicant and the correct fix is to make cfg80211/mac80211 be able
>> to handle authentication to a STA that is already authenticated. If
>> that is not acceptable, this hack needs to be hidden in driver_nl80211.c
>> instead of polluting core wpa_supplicant code which is supposed to be
>> driver independent. In other words, make driver_nl80211.c deauth if auth
>> fails and then try auth again. I don't really like that much, but if
>> this needs to be worked around in wpa_supplicant, that is the most
>> likely place where such a change could be considered.
>
> I still don't see how it makes sense to authenticate while still being
> authenticated.

The client might have lost state info (rebooted, etc.). Let it redo the
auth if it wants to, deauth if it fails.
~will~

