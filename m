Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42078 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab2CGLHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 06:07:11 -0500
Message-ID: <4F57415B.9070103@openwrt.org> (sfid-20120307_120716_605334_1F667CCF)
Date: Wed, 07 Mar 2012 12:07:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: cfg80211 dump_survey - what is it supposed to measure?
References: <CAMLZHHSgOf9JcEBLxhgkFuM3SEvJUbH=VkDB3pyzPy61HO+mWg@mail.gmail.com>
In-Reply-To: <CAMLZHHSgOf9JcEBLxhgkFuM3SEvJUbH=VkDB3pyzPy61HO+mWg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-05 10:59 PM, Daniel Drake wrote:
> Hi,
> 
> I'm working on a bug in libertas. It looks like NetworkManager (or
> something related) is calling dump_survey, before a connection has
> been established.
> 
> libertas does:
> 
> 	survey->channel = ieee80211_get_channel(wiphy,
> 		ieee80211_channel_to_frequency(priv->channel,
> 					       IEEE80211_BAND_2GHZ));
> 
> 	ret = lbs_get_rssi(priv, &signal, &noise);
> 	if (ret == 0) {
> 		survey->filled = SURVEY_INFO_NOISE_DBM;
> 		survey->noise = noise;
> 	}
> 
>         return ret;
> 
> lbs_get_rssi() only works when the card is associated. It then returns
> the signal/noise of the last received beacon from the AP. If the card
> is not associated (as is true here), lbs_get_rssi returns error 1,
> which is then returned to cfg80211, and this looks to cause userspace
> to retry the survey request in a seemingly infinite loop.
> 
> I'm wondering if dump_survey is intended to return the RSSI of a
> specific network in the way that libertas does it, or if it is
> supposed to look more generally at the interference on a channel?
> 
> In other words, given that libertas hardware doesn't seem to offer
> functionality to measure the overall signal level on a channel, I'm
> wondering if the correct solution here is to drop the dump_survey
> handler altogether.
cfg80211 survey is supposed to show the noise value for the current
channel, and - if possible - for other channels as well.

The noise level is not specific to a particular network - I don't think
the libertas hw is measuring it while it's receiving packets. It's
usually measured while there is no transmission on the channel, so aside
from the return code issue the code is probably correct.

- Felix
