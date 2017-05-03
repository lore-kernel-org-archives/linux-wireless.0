Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60948 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdECFtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 01:49:11 -0400
Message-ID: <1493790549.2602.5.camel@sipsolutions.net> (sfid-20170503_074917_275915_7CA0FCD3)
Subject: Re: [PATCH 0/9] nl80211: add support for PTK/GTK handshake offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 03 May 2017 07:49:09 +0200
In-Reply-To: <1493728949-10797-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493728949-10797-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-02 at 13:42 +0100, Arend van Spriel wrote:
> Another change is the
> addition of the flag ATTR_WANT_1X_OFFLOAD that user-space has to pass
> in CONNECT request. Some drivers may need to be aware before the PMK
> is programmed through SET_PMK request.

That naming seems a bit questionable - WANT_1X_4WAY_HS or so might be
better? We don't (want to) offload the 1X handshake after all, so that
name is a bit confusing IMHO.

> This series also comes with driver implementation in brcmfmac
> although it does not use the authorized flag in the ROAM event (yet).
> 
> The series applies to the master branch of the mac80211-next
> repository.

Cool.

> One remaining open issue is regarding DEL_PMK. The wpa_supplicant
> patches posted on hostap list do not use it and the .del_pmk() is
> also not used within cfg80211. Should it be called in
> __cfg80211_disconnected() just to be sure?

I don't really think so - once you disconnect surely the PMK for the
connection is no longer valid. IMHO it's reasonable to require ensuring
that from drivers, where necessary (mostly, I assume firmware would
throw away the data anyway)

johannes
