Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f48.google.com ([209.85.215.48]:34453 "EHLO
	mail-ew0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1IVFh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 01:37:26 -0400
Received: by ewy20 with SMTP id 20so832638ewy.7
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 22:37:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316589900.2157.392.camel@cumari>
References: <20110921070525.GD4999@elgon.mountain> <1316589900.2157.392.camel@cumari>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 22 Sep 2011 08:29:28 +0300
Message-ID: <CA+XVXffsb52crZcqQEa6u8GKjXuak-dMH7vd+TUSE771T7XNUg@mail.gmail.com> (sfid-20110922_073729_197992_4C95033C)
Subject: Re: wl12xx: support up to 8 stations in AP-mode
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 10:25, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2011-09-21 at 00:05 -0700, Dan Carpenter wrote:
>> Hi Arik,
>>
>> Smatch complains about c47e8229fa56 "wl12xx: support up to 8 stations
>> in AP-mode"
>>
>> drivers/net/wireless/wl12xx/main.c +832 wl12xx_irq_update_links_status(22)
>>       error: buffer overflow 'status->tx_lnk_free_pkts' 8 <= 10
>>
>>    828          for (hlid = WL1271_AP_STA_HLID_START; hlid < AP_MAX_LINKS; hlid++) {
>>                                                              ^^^^^^^^^^^^

Again, good catch there Dan. We'll verify the fix internally before
releasing it (as it changes the host-fw interface).
I'll also add a BUILD_BUG_ON so this won't happen again.

Arik
