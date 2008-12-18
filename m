Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34093 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYLREC7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 23:02:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 20:02:59 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18761.51883.237457.147053@gargle.gargle.HOWL> (sfid-20081218_050302_968577_94DF536E)
Date: Thu, 18 Dec 2008 09:29:39 +0530
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [RFC] Handle Channel Switch Announcement
In-Reply-To: <18761.43079.702658.733757@localhost.localdomain>
References: <18761.4838.509784.281821@localhost.localdomain>
	<20081217162017.GA28712@jm.kir.nu>
	<18761.43079.702658.733757@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith wrote:
> Jouni Malinen wrote:
> > Why is this flag needed? Or well, the better question: Why is the
> > channel disabled? CSA may request the STA to stop transmitting _within
> > the BSS_ until the AP has changed channels (i.e., it could be possible
> > to use other BSSes even on the same channel). This notification can be
> > used for other things than just reporting a radar on the channel (e.g.,
> > the AP could move to a channel that has less traffic on it).
> >
> 
> Ok, agreed. I'll remove this flag.
> 
> But after receiving a CSA on the current frequency, and having moved to the new
> advertised frequency, can the STA send out probe requests in the earlier frequency ?
> (In case of a scan run or something)

If that is the case, then we should probably check for CSA received on a frequency
and not send out probe requests in that frequency during a scan run.

Something like:

	case SCAN_SEND_PROBE:
		next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
		local->scan_state = SCAN_SET_CHANNEL;

		if (local->scan_channel->flags & (IEEE80211_CHAN_PASSIVE_SCAN |
						  IEEE80211_CHAN_CSA_DISABLED))
			break;
		ieee80211_send_probe_req(sdata, NULL, local->scan_ssid,
					 local->scan_ssid_len);
		next_delay = IEEE80211_CHANNEL_TIME;
		break;

But am not sure what constraints are imposed on the station on reception of a CSA.

Sujith
