Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:56732 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab1B0Jnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 04:43:50 -0500
Date: Sun, 27 Feb 2011 11:43:44 +0200
From: Jouni Malinen <j@w1.fi>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] [mac|nl]80211: SAE mesh and userspace
 authentication
Message-ID: <20110227094344.GA7835@jm.kir.nu>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 25, 2011 at 05:32:35PM -0800, Thomas Pedersen wrote:
> This patch series introduces support for userspace SAE (Simultaneous
> Authentication of Equals) daemons through nl80211 and mac80211. This
> authentication scheme is documented in IEEE 802.11s section 8.2a.1. 

While the SAE mechanism is specified in IEEE 802.11s, it is not in any
way specific to mesh. Some of these patches looked generic, but at least
the one touching ieee80211_default_mgmt_stypes addressed only the mesh
point iftype. Do you have plans on making this more generic to allow SAE
to be used in station mode interface with WPA2-Personal? I would assume
that AP side can already be handled in hostapd without kernel changes,
but it would be useful to allow wpa_supplicant to implement SAE for the
station interface even if there is no use of mesh in the network.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
