Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58268 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759191AbZKYVix (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 16:38:53 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 13:39:00 -0800
Date: Wed, 25 Nov 2009 13:38:57 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Gabor Juhos <juhosg@openwrt.org>
CC: John Linville <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: enable 2GHz band only if the
	device supports it
Message-ID: <20091125213857.GM5006@tux>
References: <1259180955-2145-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1259180955-2145-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 12:29:15PM -0800, Gabor Juhos wrote:
> Currently, the 2GHz band is enabled unconditionally, even if the device
> does not support it.

This is true, but we don't have any 11n 5 GHz only devices,
The patch is fine too though but it'd be better if you fail
with a proper ath_print ATH_DBG_FATAL message if neither band
has been marked as supported.

  Luis
