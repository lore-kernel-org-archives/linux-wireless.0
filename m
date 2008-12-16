Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:56210 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYLPUaJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 15:30:09 -0500
To: "Bob Copeland" <bcopeland@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k + AP mode?
References: <m3skopuq6t.fsf@maximus.localdomain>
	<b6c5339f0812160933q1670f646iab25dff161450ef9@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 16 Dec 2008 21:27:40 +0100
In-Reply-To: <b6c5339f0812160933q1670f646iab25dff161450ef9@mail.gmail.com> (Bob Copeland's message of "Tue\, 16 Dec 2008 12\:33\:27 -0500")
Message-ID: <m3skon27cz.fsf@maximus.localdomain> (sfid-20081216_213014_549365_D8A76083)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <bcopeland@gmail.com> writes:

> It's probably worth taking a look at hostapd to see what exactly is failing.
> We should be able to create an IFTYPE_AP interface with your above patch
> applied.  No telling whether the rest works.

So the problem is:
- hostapd requests master mode on "wlan0" using netlink,
- it gets to nl80211_set_interface(), drv->ops->change_virtual_intf(),
  ieee80211_change_iface() and then to ieee80211_if_change_type().

Then it fails with -EOPNOTSUPP.

int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
			     enum nl80211_iftype type)
{
	ASSERT_RTNL();

	if (type == sdata->vif.type)
		return 0;

	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)
		return -EOPNOTSUPP;
                ^^^^^^^^^^^^^^^^^^^

The flags are set to 6 = IEEE80211_CHAN_NO_IBSS |
                         IEEE80211_CHAN_PASSIVE_SCAN

Unfortunately I don't know what does the above mean, except that
I don't want ad-hoc mode, I want AP instead.

Ideas?
-- 
Krzysztof Halasa
