Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55987 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759486Ab3BXWb0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 17:31:26 -0500
Message-ID: <512A94B3.4020205@hauke-m.de> (sfid-20130224_233128_775393_099621A3)
Date: Sun, 24 Feb 2013 23:31:15 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: [RFC 00/13] brcmsmac: add AP mode
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>  <A47087626F2942499CF47E79803E771E0431BF4D@SJEXCHMB13.corp.ad.broadcom.com>  <5129FBB8.1080505@hauke-m.de> (sfid-20130224_123852_665943_7C5D7E9A) <1361726563.8129.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361726563.8129.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2013 06:22 PM, Johannes Berg wrote:
> On Sun, 2013-02-24 at 12:38 +0100, Hauke Mehrtens wrote:
> 
>> Yes this needs some review and more testing, I hope this also works with
>> power saving stations and so on.
> 
> I doubt it will. I know it's not really a major thing, but due to the
> way aggregation is handled you definitely need to implement
> "release_buffered_frames". "allow_buffered_frames" might not be
> necessary if the device doesn't track station's powersave mode by
> itself? Not sure how that's supposed to work, too long since I worked on
> Broadcom stuff.

Ok, I have to read how power saving exactly works and look how brcmsmac
currently does aggregation and so on.

>> probe response offload
> 
> See also enum nl80211_probe_resp_offload_support_attr; probe response
> offload is a bit tricky because e.g. for WPS you absolutely need
> userspace, not the firmware, to respond. So if the firmware can't tell
> the difference between regular and WPS probe requests, you can't support
> WPS.
> 
> If you can, I'd probably just turn off the response offload. It's likely
> not worth the effort. If you wanted to make that turning off conditional
> we'd have to come up with a bunch of new API to let the driver know what
> kind of AP it's running.

Ok, I will turn it off, this driver is mostly used on devices without a
battery, or a big one, so the energy saving by offloading is not needed
and the performance improvement is probably not that big.

Hauke
