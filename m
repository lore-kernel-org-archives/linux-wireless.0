Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp29.msg.oleane.net ([62.161.4.29]:35536 "EHLO
	smtp29.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3GBN25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 09:28:57 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Felix Fietkau'" <nbd@openwrt.org>
Cc: <linux-wireless@vger.kernel.org>
References: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr> <51CF3EC9.3000707@openwrt.org>
In-Reply-To: <51CF3EC9.3000707@openwrt.org>
Subject: RE: [RFC v2] mac80211: Use libnl-configurable values for retry counts
Date: Tue, 2 Jul 2013 15:28:53 +0200
Message-ID: <000001ce7728$18b07de0$4a1179a0$@acksys.fr> (sfid-20130702_152900_780794_52FBC8F9)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

> -----Message d'origine-----
> De : Felix Fietkau [mailto:nbd@openwrt.org]
> > ---
> > What I am seeking with this patch:
> > I believe the configuration of the retries will help making recovery
> > much faster when an AP (in infrastructure mode) or a peer (in mesh
> > mode) suddenly disappears.
> I'm all for reducing retries, but I think the way you're applying the
> limit is problematic.
> If minstrel decides to use many retries for a high rate and you're
> simply cutting off all retries that exceed the configured limit, you're
> potentially inviting quite a bit of unnecessary packet loss.
> I'm planning to remove the use of retry rate slot 4 (fallback to lowest
> rate) from minstrel, since max_prob_rate should already provide quite
> decent reliability.

Well, on one hand, people who want to reduce retries are more concerned with
low latency and jitter than with reliable delivery of data.
On another hand the code should work for any rate control plugin, not just
minstrel.
Finally this code is executed for each frame, and I don’t want to bloat it
more than necessary...

I am thinking of trimming only the largest retry count in the table, but not
below 2 (one try and one retry). I'll test this today.

Do you feel this is a good path ?
Or should I just wait for the slot 4 removal ?

I could also split the trimming between 2 rates, the largest count and the
next-to-largest. Or I could use a minimum of 1 instead of 2.
> 
> - Felix

Jean-Pierre

