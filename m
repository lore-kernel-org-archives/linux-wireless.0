Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:64887 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0A0Ri0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 12:38:26 -0500
Received: by pzk28 with SMTP id 28so2112851pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 09:38:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B5BAFC3.7000807@openwrt.org>
References: <4B5BAFC3.7000807@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 27 Jan 2010 09:38:06 -0800
Message-ID: <43e72e891001270938q4bba2a08wa02c8db858ee5954@mail.gmail.com>
Subject: Re: [PATCH] ath9k: improve max rate retry handling
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2010 at 6:26 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> ath9k currently forces hw->max_rate_tries to 4 to work around rate
> control inefficiencies. This has some negative side effects, such as
> rate_control_send_low also using a maximum of 4 tries, which could
> negatively affect reliability of unicast management frames.
> This patch pushes the retry limit to the rate control instead, and
> allows it to use more tries on the last stage to prevent unnecessary
> packet loss.

If this is not merged yet and if its not too much trouble, would you
mind splitting this into two separate patches, one which increases the
MRR segment retry count, and the other which does what the current
commit log says? Reason is increasing the MRR segment retry count
might be useful as a cherry pick for older kernels.

  Luis
