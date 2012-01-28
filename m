Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51514 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2A1T2t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 14:28:49 -0500
Message-ID: <4F244C6D.3060304@openwrt.org> (sfid-20120128_202852_805542_F666B47A)
Date: Sat, 28 Jan 2012 20:28:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <1327735027-30121-2-git-send-email-lindner_marek@yahoo.de> <4F23F753.8070405@openwrt.org> <201201290243.47953.lindner_marek@yahoo.de> <4F2443BB.3000602@openwrt.org> <CALSq=BahchLsgVVeFei+_FQAchMAAg2yU1drmpZTgt0pVoJbJg@mail.gmail.com>
In-Reply-To: <CALSq=BahchLsgVVeFei+_FQAchMAAg2yU1drmpZTgt0pVoJbJg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-28 8:17 PM, Daniel Halperin wrote:
> (BUT @Felix: maybe max_tp_rate2 shouldn't use RTS/CTS---it's still
> trying to be aggressive, whereas max_prob_rate is the one where you
> *really* want the packet to get through. So maybe the first half of
> Marek's patch is worth keeping, though it *should* be a marginal
> difference in normal operating environments.)
I thought about this as well, but decided to keep it even for
max_tp_rate2, since with long A-MPDUs, the extra time needed by RTS/CTS
compared to the A-MPDU transmission time isn't that much, and
max_prob_rate is usually quite a bit slower.

- Felix
