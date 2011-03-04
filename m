Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46484 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886Ab1CDR0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 12:26:20 -0500
Received: by fxm17 with SMTP id 17so2363276fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 09:26:19 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] mac80211: Shortcut minstrel_ht rate setup for non-MRR capable devices
Date: Fri, 4 Mar 2011 18:23:03 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <1299241892-6719-1-git-send-email-helmut.schaa@googlemail.com> <1299241892-6719-2-git-send-email-helmut.schaa@googlemail.com> <4D711C04.8030309@openwrt.org>
In-Reply-To: <4D711C04.8030309@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103041823.04001.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 4. März 2011 schrieb Felix Fietkau:
> On 2011-03-04 1:31 PM, Helmut Schaa wrote:
> > Devices without multi rate retry support won't be able to use all rates
> > as specified by mintrel_ht. Hence, we can simply skip setting up further
> > rates as the devices will only use the first one.
> > 
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> > 
> > has_mrr is true if the device is able to make use of at least four rates. Not
> > sure if we might want to consider further special cases for devices with for
> > example a maximum of two rates.
> I think we should add a special case for handling a maximum of two
> rates. Right now this is being used by brcm80211, so applying this patch
> might make things worse there.

John, please drop this patch then.

Felix, currently minstrel_ht uses a maximum of 3 rates as far as I can see.

In the sampling case it's
	sample_rate -> highest_tp_rate -> highest_prob_rate
and in the default case it's
	highest_tp_rate -> second_highest_tp_rate -> highest_prob_rate

For devices with just one possible rate it would be either the sample_rate
or the highest_tp_rate.

And for devices with two rates it might make sense to change the logic to
something like
	sample_rate -> highest_prob_rate
and
	highest_tp_rate -> highest_prob_rate

Does that sound reasonable?

Thanks,
Helmut
