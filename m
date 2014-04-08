Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDHKGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 06:06:24 -0400
Message-ID: <1396951582.5936.20.camel@jlt4.sipsolutions.net> (sfid-20140408_120628_052668_12125BC2)
Subject: Re: [RFCv2 6/6] cfg80211: implement cfg80211_get_station cfg80211
 API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 08 Apr 2014 12:06:22 +0200
In-Reply-To: <1396211704-4677-7-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
	 <1396211704-4677-7-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-30 at 22:35 +0200, Antonio Quartulli wrote:

>  /**
> + * cfg80211_get_station - retrieve information about a given station
> + * @dev: the device where the station is supposed to be connected to
> + * @mac_addr: the mac address of the station of interest
> + * @sinfo: pointer to the structure to fill with the information
> + *
> + * Returns 0 on success or a negative error code otherwise.
> + */
> +int cfg80211_get_station(struct net_device *dev, u8 *mac_addr,
> +			 struct station_info *sinfo);

mac_addr should be const

Any thoughts about clearing/filling/partially filling *sinfo when
returning an error?

johannes

