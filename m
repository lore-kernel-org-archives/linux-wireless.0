Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:1066 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbYAQRwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 12:52:45 -0500
Received: by py-out-1112.google.com with SMTP id u52so1060888pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 09:52:44 -0800 (PST)
Message-ID: <43e72e890801170952q23ff6550s7214bee32a2860f7@mail.gmail.com> (sfid-20080117_175249_756642_CF62C408)
Date: Thu, 17 Jan 2008 12:52:43 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [FYI] hostapd status
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Bas Hulsken" <bhulsken@zonnet.nl>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <1200520735.8007.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1200520735.8007.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 16, 2008 4:58 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> I just took the time to adjust hostapd to the new nl80211-based hardware
> capabilities exporting (patch I recently posted) and it "works" again.
>
> The todo list now pretty much is:
>
>  * bring Michael Wu's "cooked" monitor patches to a suitable shape for
>    merging and write iw(1) support for monitor flags; the cooked monitor
>    hook shouldn't be in the RX handlers to allow seeing frames that
>    other handlers dropped
>  * remove 802.1X setting, 802.1X need never be disabled on an AP because
>    it can be completely managed by hostapd
>  * allow hostapd to set the 'basic' and 'supported' rate sets
>  * allow hostapd to set QoS queue parameters
>  * allow hostapd to set ERP parameters:
>    - RTS/CTS protection
>    - preamble
>    - slot time
>  * make kernel send events via nl80211 (TKIP MMIC, key threshold, ...)
>  * make hostapd deal with such kernel events by using libnl properly
>    with an ops list
>  * implement regulatory domain control kernel/userspace API
>  * make hostapd use that API, it wants to be in control of regulatory
>    compliance rather than relying on an external daemon

Well we need regulatory daemon of some sort for non-AP hosts. I was
considering throwing this as part of wpa_supplicant/hostapd code. I
guess we'll see.

> I hope Luis will work on the last two items, and I personally want to
> handle only the first two items. All others on the list are up for
> grabs.

ACK -- I will.

  Luis
