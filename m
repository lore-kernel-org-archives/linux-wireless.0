Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:36509 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1ITCqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 22:46:00 -0400
Received: by vws10 with SMTP id 10so161093vws.11
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 19:46:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E77C0BF.50108@openwrt.org>
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org>
	<1316453903-75710-2-git-send-email-nbd@openwrt.org>
	<CAB=NE6XvanRQ6Yje_qHhkfzbLmZn9o5Q+5y1NobJwCyuMLFEvg@mail.gmail.com>
	<4E77AAFB.1080805@openwrt.org>
	<CAB=NE6XgSz7zz_ZXaPQEsaue307ipd7Qnzgi5QWr8Y4SS1j=Lg@mail.gmail.com>
	<4E77B25D.9070907@openwrt.org>
	<CAB=NE6XLdftXKg5-wvme8Vg7BjGi-TpxQ3G6m=7VnEw89YzXoA@mail.gmail.com>
	<CAB=NE6XQDqG+En2KWOyKGUVT1SWm1rwMwOxMjpE8CjYfvwvOqw@mail.gmail.com>
	<4E77BC58.7040204@openwrt.org>
	<CAB=NE6Vi2sun6vJy=yZSJ9HjHxD17FO-GmXtYybcjLVPSt9+wA@mail.gmail.com>
	<CAB=NE6UzRhp=51QacoRzMPad0vO1qkNxK3=rayPuYXdjA3ZOJQ@mail.gmail.com>
	<4E77C0BF.50108@openwrt.org>
Date: Tue, 20 Sep 2011 10:45:59 +0800
Message-ID: <CAJ-Vmonu2TJgZVEjHrd3UG+_MLzowPUJ=LPQZbG8DPyuwPkyug@mail.gmail.com> (sfid-20110920_044605_694221_986FB6F4)
Subject: Re: [PATCH v2 2/4] ath9k_hw: clean up tx power handling
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IIRC, the TP Scale stuff dates back to the previous NICs which
(reportedly, from madwifi list/tickets) didn't implement TPC right, or
Madwifi never ran TPC correctly on them.

So instead of per-packet TPC being done as driven by the net80211
stack (which I bet would be needed for hostap mode, to use per-node TX
power levels), it was likely done as a way for STA's to select a power
limit, and maybe for coarse grained hostap operation (ie, if all STA's
are close, use a lower TPC scale.)

I bet Sam would know why.

I agree with Felix; nothing in ath9k/mac80211 currently uses it, so
why keep it around. All of the ath9k supported NICs should implement
correct per-packet TPC anyway, right?



Adrian
