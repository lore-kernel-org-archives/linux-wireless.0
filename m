Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51433 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab2GCN0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 09:26:16 -0400
Date: Tue, 3 Jul 2012 08:26:08 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] brcmsmac: fix brcms_c_regd_init() which crashed after
 11ad patch
Message-ID: <20120703132608.GA5626@thinkpad-t410> (sfid-20120703_152620_537069_C8460958)
References: <1341321280-6136-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341321280-6136-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 03, 2012 at 03:14:40PM +0200, Arend van Spriel wrote:
> This patch fixes an OOPS in brcmsmac driver, which was introduced
> by the 11ad patch 'cfg80211: add 802.11ad (60gHz band) support'.
> The value IEEE80211_NUM_BANDS increased, which was used in the
> brcms_c_regd_init() function.
> 
> Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Acked-by: Seth Forshee <seth.forshee@canonical.com>

Just one minor nit ...

> +		if (band_idx == BAND_2G_INDEX) {
> +			sband = wiphy->bands[IEEE80211_BAND_2GHZ];
> +		} else {
> +			sband = wiphy->bands[IEEE80211_BAND_5GHZ];
> +		}

No need for braces here.

Cheers,
Seth

