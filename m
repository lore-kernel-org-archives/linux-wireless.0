Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33458 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab0A0Tpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 14:45:36 -0500
Date: Wed, 27 Jan 2010 14:43:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: improve max rate retry handling
Message-ID: <20100127194351.GI2962@tuxdriver.com>
References: <4B5BAFC3.7000807@openwrt.org> <43e72e891001270938q4bba2a08wa02c8db858ee5954@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001270938q4bba2a08wa02c8db858ee5954@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 27, 2010 at 09:38:06AM -0800, Luis R. Rodriguez wrote:
> On Sat, Jan 23, 2010 at 6:26 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> > ath9k currently forces hw->max_rate_tries to 4 to work around rate
> > control inefficiencies. This has some negative side effects, such as
> > rate_control_send_low also using a maximum of 4 tries, which could
> > negatively affect reliability of unicast management frames.
> > This patch pushes the retry limit to the rate control instead, and
> > allows it to use more tries on the last stage to prevent unnecessary
> > packet loss.
> 
> If this is not merged yet and if its not too much trouble, would you
> mind splitting this into two separate patches, one which increases the
> MRR segment retry count, and the other which does what the current
> commit log says? Reason is increasing the MRR segment retry count
> might be useful as a cherry pick for older kernels.

It's already merged...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
