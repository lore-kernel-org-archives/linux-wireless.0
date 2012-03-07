Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40105 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab2CGOrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 09:47:08 -0500
Received: by vbbff1 with SMTP id ff1so5494541vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 06:47:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F57415B.9070103@openwrt.org>
References: <CAMLZHHSgOf9JcEBLxhgkFuM3SEvJUbH=VkDB3pyzPy61HO+mWg@mail.gmail.com>
	<4F57415B.9070103@openwrt.org>
Date: Wed, 7 Mar 2012 08:47:06 -0600
Message-ID: <CAMLZHHTHAH-u_pxUCG_SovYRA1Z2dE1K=Uj6TYa1H7iLJaOmRg@mail.gmail.com> (sfid-20120307_154712_617259_53E8E845)
Subject: Re: cfg80211 dump_survey - what is it supposed to measure?
From: Daniel Drake <dsd@laptop.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

Thanks for the response.

On Wed, Mar 7, 2012 at 5:07 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> The noise level is not specific to a particular network - I don't think
> the libertas hw is measuring it while it's receiving packets. It's
> usually measured while there is no transmission on the channel, so aside
> from the return code issue the code is probably correct.

The docs suggest strongly that the signal is measured based on the
most recent beacon.

"The SNR field in the response provides the SNR in the most recently
received beacon. The NoiseFloor field in the response provides the
absolute value of the noise floor in the most recently received
beacon."

and given that it only gives values when you are associated (i.e. it
only looks at the beacons for the one network that you are connected
to), I think I can believe this.

Does this change your recommendation?

Thanks,
Daniel
