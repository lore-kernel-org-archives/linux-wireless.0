Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53037 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab1HJUax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 16:30:53 -0400
Received: by mail-bw0-f53.google.com with SMTP id 1so598618bkd.12
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 13:30:51 -0700 (PDT)
Subject: Re: [PATCH 30/40] wl12xx: AP-mode - configure HT rate support to
 the FW
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-31-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-31-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 23:30:48 +0300
Message-ID: <1313008248.2407.747.camel@cumari> (sfid-20110810_223056_655143_1EC1E889)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> From: Arik Nemtsov <arik@wizery.com>
> 
> Unconditionally configure HT rate support to the FW on all ACs
> when starting the AP.
> 
> When 11n support is disabled by usermode (hostapd), each STA joining
> the AP will appear as a non-HT STA. This will stop us from accidentally
> transmitting using MCS rates.

Can we really trust this? I'd rather make sure we don't do anything
wrong in the driver itself.

Or is all this actually handled in userspace? I'm not very familiar with
how AP works, but is there any risk that someone tells us not to use 11n
but still don't change the STAs so that they appear as non-HT?

-- 
Cheers,
Luca.

