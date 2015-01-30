Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53151 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760071AbbA3JaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:30:07 -0500
Message-ID: <1422610205.1919.5.camel@sipsolutions.net> (sfid-20150130_103023_620124_4D6C5137)
Subject: Re: cfg80211_ops: deauthentication & disassociation
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: wim torfs <wtorfs@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 30 Jan 2015 10:30:05 +0100
In-Reply-To: <CACna6rzXoVdf_7sD4Fio5793kXco5so7=wRisfCcbWt+U2CLKQ@mail.gmail.com> (sfid-20150130_091741_165664_1EE1B66C)
References: <CACna6rykYmq6ucTHJ40vcySOFYs3qeim_ZOpNQsNGzyFo=w-aQ@mail.gmail.com>
	 <54CB2338.2070502@gmail.com>
	 <CACna6rzXoVdf_7sD4Fio5793kXco5so7=wRisfCcbWt+U2CLKQ@mail.gmail.com>
	 (sfid-20150130_091741_165664_1EE1B66C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 09:17 +0100, Rafał Miłecki wrote:

> > In hostapd, there is a routine that monitors such netlink messages,
> > process_global_event, which eventually parses the CMD_DEL_STATION event in
> > nl80211_del_station_event, where a call is made to drv_event_disassoc if the
> > current device is indeed in AP mode.
> > So eventually, it is the hostapd that triggers the transmission of the
> > disassociation packet.
> 
> I indeed missed the way cfg80211_del_sta works and hostapd's event
> handler for this. That explains a lot.
> 
> I've checked ath6kl, brcmfmac and mwifiex and they don't seem to call
> cfg80211_del_sta. AFAIU it's because they handle sending
> disassoc/deauth packet on their own (and the don't want e.g. hostapd
> to do this), is that correct?

There are two ways - AP SME in firmware, and AP SME in hostapd.

They work differently - in the former case (firmware) the AP station is
added there and hostapd gets notifications about it.

In the latter case, hostapd adds/removes all the stations.

johannes

