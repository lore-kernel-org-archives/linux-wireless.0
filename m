Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:34888 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957AbYEES3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 14:29:20 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1137841nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 11:29:19 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Don't encrypt beacons
Date: Mon, 5 May 2008 20:36:07 +0200
Cc: linux-wireless@vger.kernel.org
References: <200805051841.51408.IvDoorn@gmail.com> <1210005414.8245.40.camel@johannes.berg>
In-Reply-To: <1210005414.8245.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805052036.07862.IvDoorn@gmail.com> (sfid-20080505_202910_580934_814D0BA5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 May 2008, Johannes Berg wrote:
> Hi,
> 
> > This patch is intended to for your experimental patch:
> > 	019-mac80211-tx-info-skb-cb.patch
> > 
> > Beacons shouldn't be encryped, so mac80211 should set
> > the IEEE80211_TX_CTL_DO_NOT_ENCRYPT flag in tx info flags.
> > Otherwise the driver will cause a NULL pointer dereference
> > when it tries to access the info->control.hw_key which isn't
> > configured.
> 
> Shouldn't this apply before that change as well? I'll happily roll it
> into the skb->cb/txinfo patch, but it seems it should be there w/o that
> too.

Hmm, your absolutely right, I hadn't checked the wireless-testing code yet. :)
I only noticed this bug since a user had hostapd running on rt2x00.git with
rt61pci HW crypto enabled.
I'll respin the patch to apply for wireless-testing ;)

Ivo
