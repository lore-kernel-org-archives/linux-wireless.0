Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZFKQIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 12:08:40 -0400
Subject: Re: [PATCH v2] mac80211: Do not try to associate with an empty SSID
From: reinette chatre <reinette.chatre@intel.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090611151945.GA17284@jm.kir.nu>
References: <20090611105411.GA13825@jm.kir.nu>
	 <20090611151945.GA17284@jm.kir.nu>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 09:15:30 -0700
Message-Id: <1244736930.20900.431.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-11 at 08:19 -0700, Jouni Malinen wrote:
> It looks like some programs (e.g., NM) are setting an empty SSID with
> SIOCSIWESSID in some cases. This seems to trigger mac80211 to try to
> associate with an invalid configuration (wildcard SSID) which will
> result in failing associations (or odd issues, potentially including
> kernel panic with some drivers) if the AP were to actually accept this
> anyway).

I think this behavior was recently changed in NM. See
http://cgit.freedesktop.org/NetworkManager/NetworkManager/commit/?id=01a1bafc1d8abee153a8aca0495c77292f4f07e3

This is just fyi as this change is still needed for all the other NM
versions out there.

Reinette



