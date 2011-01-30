Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57953 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1A3WTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 17:19:34 -0500
Received: by yib18 with SMTP id 18so1731597yib.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 14:19:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110130183721.GA28252@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295869283.3639.7.camel@jlt3.sipsolutions.net> <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
 <20110126140444.GA30373@jm.kir.nu> <AANLkTi=AWanc8+JK7hQnRMpPEC+2hK0aTn0xenru7Ryw@mail.gmail.com>
 <20110130183721.GA28252@jm.kir.nu>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 31 Jan 2011 00:19:18 +0200
Message-ID: <AANLkTinF62aVqcU_5YBieLTy9BrQWdFswbCg3nreA6Tr@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 20:37, Jouni Malinen <j@w1.fi> wrote:
>
> That sounds reasonable. Though, it would be useful to indicate the
> no-probe-req-notifications or well, document that flag to mean that
> Probe Request processing is pretty much black box with now visibility to
> the host.

Will do.

>
> As far as the pass-don't-reply mode is concerned, how would that be
> selected (once implemented)? Would that add a new capability flag and
> configuration option, so that hostapd could decide to configure it if
> the configuration is enabling WPS and not use it if WPS is disabled?

I was thinking hostapd would simply not configure a probe-resp
template when offloading is disabled. In essence probe-resp offloading
will be disabled by default, and can be enabled only by pushing the
probe resp template.
Upon seeing the probe-resp template change notification, the low level
driver will enable offloading.

>
>> Should hostapd reply to probe requests when offloading is configured?
>> This is a moot point for wl12xx since probe-requests are not passed
>> up. Do you have a preference here?
>
> So far, hostapd is prepared for the driver taking care of Probe Request
> handling mainly in the case that all of MLME operations, i.e., including
> authentication and association, are done in the firmware/driver. In this
> case, there is a driver wrapper event (EVENT_RX_PROBE_REQ) that
> indicates the received Probe Request frames for WPS processing without a
> response coming back. If the Probe Request frame is indicated in a same
> way as other management frames (monitor interface currently with
> mac80211, but that is subject to change at some point), as response will
> be sent. As such, this decision could be done in mac80211 (e.g., add a
> new nl80211 event for notification-only-RX-probe-req which would be
> mapped into EVENT_RX_PROBE_REQ).
>

Does indicate-up-and-reply make sense from a power-save perspective?
The main goal of probe-resp offloading is not to wake up the host. If
the host is woken up by the indication, it might as well answer the
probe request.
This intermediate case is not currently implemented in wl12xx. Is
there a good reason to implement it?

Also with current wl12xx FW there's no way to test this code (probe
requests are never passed up). Perhaps we can start with the hostapd
rejecting probe requests in probe-resp offloading mode, and implement
the intermediate case later on?

Arik
