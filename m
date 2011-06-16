Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab1FPPg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 11:36:27 -0400
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom  reservation
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Thu, 16 Jun 2011 17:36:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <20110616102707.GB24458@hertz.marvell.com>
References: <20110616102138.GA24447@hertz.marvell.com>
 <20110616102707.GB24458@hertz.marvell.com>
Message-ID: <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 16 Jun 2011 15:57:08 +0530, Yogesh Ashok Powar wrote:
> Following warning was observed after the commit
> aac6af5534fade2b18682a0b9efad1a6c04c34c6
>
>>WARNING: at net/mac80211/wpa.c:397 ccmp_encrypt_skb+0xc4/0x1f0
>
> Consider a scenario where reserving skb tailroom is skipped
> because software encryption is not enabled. SW encryption
> can be disabled because of a) All the keys are hardware
> planted b) No key has been created.  But, before actual
> transmit if hardware encryption is disabled or software
> encryption is started, there will not be enough tailroom
> space to accommodate the sw crypto's MMIC or IV and
> WARN_ON will be hit.
>
> This race between updations of hw keys and skipping & using
> tailroom, is fixed by protecting critical regions (code
> accessing crypto_tx_tailroom_needed_cnt and code from
> tailroom skipping to skb_put for IV or MMIC) with the
> spinlock.

Haha, good joke. You've got to be kidding. NACK. No inserting spinlocks 
into the TX/RX paths.

johannes
