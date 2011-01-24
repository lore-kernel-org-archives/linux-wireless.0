Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48271 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1AXVWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:22:00 -0500
Received: by gyb11 with SMTP id 11so1451467gyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 13:21:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295869283.3639.7.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com> <1295869283.3639.7.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 24 Jan 2011 23:21:44 +0200
Message-ID: <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 13:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:
>> Support passing SSID and probe-response template to drivers.
>> This data can be used to offload the beacon -> probe-req -> probe-resp
>> process to HW.
>
> I still think you should add a wiphy flag and advertise it in nl80211 to
> advertise and request this behaviour. That will allow hostapd (and
> mac80211 in IBSS mode) to not reply to probe requests when they aren't
> filtered out by the device, and will allow hostapd/wpa_s to also
> restrict its operation to non-P2P etc. as Jouni pointed out. For P2P
> then that will have to be extended more I guess, and the firmware
> functionality be improved -- or even disabled.
>

Well a wiphy flag won't do here. Probe requests may be filtered in
some modes (AP-mode) but needed in others (p2p?).
I think flexibility is a nice added bonus here. A FW can decide to
handle most standard probe-requests and simply not pass them up.
Others ("complicated" ones) it can pass up to hostapd and expect it to reply.

The current patches leave this policy in the hands of the driver/fw.

Regards,
Arik
