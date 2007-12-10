Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:52292 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbXLJFAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 00:00:43 -0500
Date: Sun, 9 Dec 2007 20:59:55 -0800
From: Jouni Malinen <j@w1.fi>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com, yi.zhu@intel.com
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
Message-ID: <20071210045955.GN5698@jm.kir.nu> (sfid-20071210_050050_505357_7A755920)
References: <11972036221022-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <11972036221022-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 09, 2007 at 02:33:42PM +0200, Ron Rindjunsky wrote:

> +/* IEEE 80211.11 minimal headers length */
> +#define IEEE80211_HDR_MIN_LEN_CTRL 16

Where does this value 16 come from? It is likely the shortest length one
would receive from hardware/firmware in normal mode, but it is not the
shortest length for a valid IEEE 802.11 control frame. Both CTS and ACK
frames have only 10 octets in the header (just one address). Having
IEEE80211_HDR_MIN_LEN_CTRL defined to 16 would be a bit confusing.. CTS
and ACK frames are received at least in monitor mode, so these frames
with 10 octet headers will need to be processed in some cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
