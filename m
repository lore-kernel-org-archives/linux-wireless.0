Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AVM5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 07:57:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TxdQF-0006Q2-5l
	for linux-wireless@vger.kernel.org; Tue, 22 Jan 2013 13:57:51 +0100
Message-ID: <1358859496.4807.16.camel@jlt4.sipsolutions.net> (sfid-20130122_135800_388459_6FCC7181)
Subject: Re: [RFC] cfg80211/mac80211: support reporting wakeup reason
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 22 Jan 2013 13:58:16 +0100
In-Reply-To: <1358859390-22617-1-git-send-email-johannes@sipsolutions.net> (sfid-20130122_135614_662448_AAD00569)
References: <1358859390-22617-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130122_135614_662448_AAD00569)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-22 at 13:56 +0100, Johannes Berg wrote:

> + * @NL80211_WOWLAN_TRIG_WAKEUP_PACKET: For wakeup reporting only, contains the
> + *	packet, if any, that caused the wakeup. This is an 802.3 packet for
> + *	the data matching wakeup reasons (magic packet, pattern match) or an
> + *	802.11 packet (e.g. deauth). The packet may be truncated, the attribute
> + *	@NL80211_WOWLAN_TRIG_WAKEUP_PACKET_LEN contains the original length.
> + * @NL80211_WOWLAN_TRIG_WAKEUP_PACKET_LEN: Original length of the packet, might
> + *	be longer than the length of the @NL80211_WOWLAN_TRIG_WAKEUP_PACKET
> + *	attribute if the packet was truncated.

I have a feeling I should split this into separate attributes for an
802.3 and 802.11 packet to make it easier for userspace, thoughts?

johannes

