Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64938 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLONki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 08:40:38 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so9073771wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 05:40:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418646586.5731.4.camel@sipsolutions.net>
References: <1417429814-9618-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1418387190.2470.28.camel@sipsolutions.net>
	<CAA2SeNJ6oiVRJmZS54Z6dSQDsEM10dCBqSGVmKe+QDaqLzgdWQ@mail.gmail.com>
	<1418646586.5731.4.camel@sipsolutions.net>
Date: Mon, 15 Dec 2014 14:40:36 +0100
Message-ID: <CAA2SeN+71_ZR_H-Mkb5+PLwVe6dhCoknh8puWUjFXf73Ab1MnA@mail.gmail.com> (sfid-20141215_144045_461090_6732D0E3)
Subject: Re: [PATCHv2] mac80211: enable TPC through mac80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org, haim.dreyfuss@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, 2014-12-12 at 15:16 +0100, Lorenzo Bianconi wrote:
>
>> In multi-vif scenario, TPC could be enabled just on given interfaces,
>> but driver TPC registers should be configured anyway (so I used a glob
>> flag). However I can move that logic in driver code, what do you
>> suggest?
>
> It seems strange that a driver would look at both bss_conf and hw conf
> for the same thing - so seems it might be more understandable if it was
> in the driver?
>

In pending driver (ath9k) patches TPC related info in hw conf and
bss_conf are not used for the same purpose. The first one is used to
configure HW TPC registers, since TPC should be enabled in hw if there
is at least one interface where TPC has been configured, whereas the
latter it use to figure out if the transmitted frame belongs to a vif
where TPC has been previously enabled. If I do not set TPC info in hw
conf I have to loop over all vif every time TPC configuration is
applied from mac80211, since ath9k uses just hw conf structure to set
TX power info. Maybe that solution is a little bit tricky. What do you
think? Sorry if in previous emails I was not so clear :)

> johannes
>

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
