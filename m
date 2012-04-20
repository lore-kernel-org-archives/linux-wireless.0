Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2DTR22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 13:28:28 -0400
Message-ID: <1334942902.5122.2.camel@jlt3.sipsolutions.net> (sfid-20120420_192832_068552_836B21D4)
Subject: Re: [PATCH v3 1/1] mac80211: declare ieee80211_ave_rssi as EXPORT
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 20 Apr 2012 19:28:22 +0200
In-Reply-To: <1334939913-9787-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120420_184322_245950_94B6B16E)
References: <1334939913-9787-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20120420_184322_245950_94B6B16E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-20 at 09:38 -0700, Wey-Yi Guy wrote:
> ieee80211_ave_rssi need to be declare as export for driver to use it.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  net/mac80211/util.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 89c1e5b..4a8cd29 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1794,6 +1794,14 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
>  	return 0;
>  }
>  
> +/**
> + * ieee80211_ave_rssi - report the average rssi for the specified interface
> + *
> + * @vif: the specified virtual interface
> + *
> + * This function return the average rssi value for the requested interface.
> + * It assumes that the given vif is valid.
> + */
>  int ieee80211_ave_rssi(struct ieee80211_vif *vif)

The documentation should be in the header file.

johannes

