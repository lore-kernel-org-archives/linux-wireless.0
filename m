Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:5732 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935273AbXHOSJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 14:09:40 -0400
Received: by nf-out-0910.google.com with SMTP id g13so2861nfb
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2007 11:09:38 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211 & drivers: remove IEEE80211_HW_HOST_GEN_BEACON
Date: Wed, 15 Aug 2007 20:16:07 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <1187134461.31200.32.camel@johannes.berg>
In-Reply-To: <1187134461.31200.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708152016.07188.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 15 August 2007, Johannes Berg wrote:
> This flag is unused and not useful either since the driver just calls
> ieee80211_beacon_get() if it needs a beacon.

I assume that mac80211 will always provide a beacon to the driver when needed?
I mean during config_interface a beacon is supplied for master interfaces and this
will kick the beacon handler for rt2x00. (which also assures ieee80211_beacon_get() 
will be called when the beacon has been send).
But for adhoc this will still be properly supplied through rt2x00pci_beacon_update() ?

Ivo
