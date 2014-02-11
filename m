Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKL6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 06:58:32 -0500
Message-ID: <1392119905.4128.0.camel@jlt4.sipsolutions.net> (sfid-20140211_125834_987333_A978044E)
Subject: Re: [PATCH] mac80211: reset probe_send_count also in
 HW_CONNECTION_MONITOR case
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Tue, 11 Feb 2014 12:58:25 +0100
In-Reply-To: <1392114618-26573-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392114618-26573-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-11 at 12:30 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> In case of beacon_loss with IEEE80211_HW_CONNECTION_MONITOR
> device, mac80211 probes the ap (and disconnects on timeout)
> but ignores the ack.
> 
> If we already got an ack, there's no reason to continue
> disconnecting. this can help devices that supports
> IEEE80211_HW_CONNECTION_MONITOR only partially (e.g. take
> care of keep alives, but does not probe the ap.
> 
> In case the device wants to disconnect without probing,
> it can just call ieee80211_connection_loss.

Applied.

johannes

