Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:45697 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbaFAMdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2014 08:33:06 -0400
Date: Sun, 1 Jun 2014 15:26:33 +0300
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: P2P GO operating channel width
Message-ID: <20140601122633.GB22695@w1.fi> (sfid-20140601_143312_136427_D58A60BF)
References: <5370CBFF.8060206@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5370CBFF.8060206@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2014 at 03:26:23PM +0200, Arend van Spriel wrote:
> I was wondering how to configure the bandwidth of the operating
> channel in P2P-GO scenario. In nl80211.c I do see the use of
> .set_ap_chanwidth() callback. Reading the spec it seems the
> operating channel is exchanged during GO negotiation, but I do not
> see any reference about the bandwidth. It does exchange the
> operating class and I found some info in p2p_supplicant.c (see
> below). I am just not sure how this is configured to the driver, ie.
> what nl80211 commands will be used.

In theory, operating class could be used to negotiate channel bandwidth
during GO Negotiation. In practice, though, most implementations do not
do this. Instead, the device that becomes the GO can just decide to
enable 40 MHz (or 80/80+80/160 MHz for VHT) on its own regardless of
which operating class was used. This should still be done in a way that
the primary channel ends up being where indicating during GO Negotiation
to allow the P2P Client to find the GO more easily.

-- 
Jouni Malinen                                            PGP id EFC895FA
