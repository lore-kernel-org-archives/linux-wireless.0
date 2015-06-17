Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46828 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbbFQIyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:54:35 -0400
Message-ID: <1434531270.1884.15.camel@sipsolutions.net> (sfid-20150617_105521_103285_4869D810)
Subject: Re: [PATCH] mac80211: upgrade BW of TDLS peers when possible
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Wed, 17 Jun 2015 10:54:30 +0200
In-Reply-To: <1433958083-27918-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1433958083-27918-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 20:41 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Define a station chandef, to be used for wider-bw TDLS peers. When both
> peers support the feature, upgrade the channel bandwidth to the maximum
> allowed by both peers and regulatory. Currently widths up to 80MHz are
> supported in the 5GHz band.
> 
> When a TDLS peer connects/disconnects recalculate the channel type of the
> current chanctx.
> Make the chanctx width calculation consider wider-bw TDLS peers and
> similarly fix the max_required_bw calculation for the chanctx min_def.
> Since the sta->bandwidth is calculated only later on, take
> bss_conf.chandef.width as the minimal width for station interface.
> 
> Set the upgraded channel width in the VHT-operation set during TDLS setup.

Applied.

johannes

