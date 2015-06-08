Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33835 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbbFHIHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 04:07:35 -0400
Received: by oigz2 with SMTP id z2so24877142oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 01:07:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Jun 2015 16:07:35 +0800
Message-ID: <CAEFj986CCryd1fK6NpoQYOmCiu+KRjq8RsSgvWqQOvLBPvFoeg@mail.gmail.com> (sfid-20150608_100739_893536_7D774138)
Subject: Re: [PATCH] mac80211: Fix a case of incorrect metric used when
 forwarding a PREQ
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Alexis Green

I just take a look back on the code before implementing the Proactive
PREQ for PREP. For the case of reply and forward (target_flags &
MP_F_RF), the previous metric used is the one which resolved from
mpath->metric.

Refer here: https://github.com/o11s/open80211s/blob/o11s-0.4.2/net/mac80211/mesh_hwmp.c

But to say that, I cannpt confirm whether this is correct. The
standard 802.11-2012 has no longer specified bit-1 MP_F_RF (Refer
section 8.4.2.115 per target flag). So maybe it is not relevant
anymore. We may need to remove as well.

----
Chun-Yeow
