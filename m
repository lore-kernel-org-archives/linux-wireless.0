Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48264 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752485AbdC2LA2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 07:00:28 -0400
Message-ID: <1490785225.13345.8.camel@coelho.fi> (sfid-20170329_130244_272663_381B9D15)
From: Luca Coelho <luca@coelho.fi>
To: "Artem S. Tashkinov" <t.artem@lycos.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 14:00:25 +0300
In-Reply-To: <910ef9cb656db856dd78a919803860b8@lycos.com>
References: <910ef9cb656db856dd78a919803860b8@lycos.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Please release/publish iwlwifi-7265D-26.ucode
 iwlwifi-7265D-25.ucode iwlwifi-7265D-24.ucode iwlwifi-7265D-23.ucode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-03-27 at 16:53 +0500, Artem S. Tashkinov wrote:
> Hi,
> 
> New versions of iwlwifi require the firmware files which have never been 
> released by Intel.
> 
> Please fix this bummer.
> 
> iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-26.ucode 
> failed with error -2
> iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-25.ucode 
> failed with error -2
> iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-24.ucode 
> failed with error -2
> iwlwifi 0000:02:00.0: Direct firmware load for iwlwifi-7265D-23.ucode 
> failed with error -2
> iwlwifi 0000:02:00.0: loaded firmware version 22.361476.0 op_mode iwlmvm

We always keep our mainline driver very close to our development trees. 
In the development trees we are updating the versions periodically and
we don't know which ones we are going to release publicly.

If we don't try to load newer versions when a kernel version is
released, and later decide to publish the newer firmware versions, it
won't work.  This is the explanation. :)

And actually, we try to load these newer firmwares, but if they are not
present, we fall back to the older one.  You can see that we correctly
loaded version 22 (the last line in your traces).

Now, these error messages to look annoying.  But fortunately Luis
Rodriguez is already attempting to fix that in another patch series.

HTH.

--
Cheers,
Luca.
