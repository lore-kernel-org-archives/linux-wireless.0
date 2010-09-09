Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35517 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0IICaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 22:30:07 -0400
Received: by bwz11 with SMTP id 11so735782bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 19:30:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283988519-44671-1-git-send-email-steve@cozybit.com>
References: <1283988519-44671-1-git-send-email-steve@cozybit.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 12:29:46 +1000
Message-ID: <AANLkTimrfBjaQH3gQKJjiir24cKFoj_0rrFHdNSvbuv7@mail.gmail.com>
Subject: Re: [PATCH] libertas_tf_usb: fix libertas_tf_usb to match structural
 changes in libertas_tf
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 09:28, Steve deRosier <steve@cozybit.com> wrote:
> The development of the libertas_tf_sdio driver introduced structural
> changes in libertas_tf.  Most notably, firmware loading and starting
> was needed in the probe stage due to the requirement that mac80211
> have the MAC address set before the starting of mac80211 in add_card.
> This patch fixes libertas_tf_usb to match these structural changes
> as needed.
>
> Signed-off-by: Steve deRosier <steve@cozybit.com>

I'm not sure if the usb part of this driver is still functional, but
even if it isn't, it may be nicer (bisectability, etc.) to re-order
your patches like so:
1. Make the structural changes (and clean ups) in the base code and usb driver
2. Introduce the sdio driver in a single patch, taking advantage of
these changes.

It will also mean that the sdio driver will be introduced to the
kernel in a working state, rather than introduced in a partially
working state, then fixed over several commits.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
