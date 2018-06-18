Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933182AbeFRNWe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 09:22:34 -0400
Date: Mon, 18 Jun 2018 15:22:31 +0200
From: Greg KH <greg@kroah.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Omer Efrat <omer.efrat@tandemg.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 5/5] staging: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
Message-ID: <20180618132231.GA15122@kroah.com> (sfid-20180618_152237_552011_6CD50C05)
References: <1529230056-18004-1-git-send-email-omer.efrat@tandemg.com>
 <20180617102424.GA5705@kroah.com>
 <87wouwa6xk.fsf@purkki.adurom.net>
 <20180618074018.GA17683@kroah.com>
 <87zhzsdyso.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87zhzsdyso.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 18, 2018 at 04:11:51PM +0300, Kalle Valo wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Mon, Jun 18, 2018 at 10:29:43AM +0300, Kalle Valo wrote:
> >> Greg KH <greg@kroah.com> writes:
> >> 
> >> > On Sun, Jun 17, 2018 at 01:07:36PM +0300, Omer Efrat wrote:
> >> >> The BIT macro uses unsigned long which some architectures handle as 32 bit
> >> >> and therefore might cause macro's shift to overflow when used on a value
> >> >> equals or larger than 32 (NL80211_STA_INFO_RX_DURATION and afterwards).
> >> >> 
> >> >> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> >> >> should be used with all NL80211_STA_INFO_* attribute types instead of BIT
> >> >> to prevent future possible bugs when one will use BIT macro for higher
> >> >> attributes by mistake.
> >> >> 
> >> >> This commit cleans up all usages of BIT macro with the above field
> >> >> in cfg80211 by changing it to BIT_ULL instead.
> >> >> 
> >> >> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
> >> >
> >> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> 
> >> Via which tree is this supposed to go?
> >
> > Not mine :)
> >
> > Have fun with it!
> 
> Hehe :)
> 
> But I don't see why this patch 5 should go either to mac80211 or
> wireless-drivers trees as there's no dependency or anything like that,
> AFAIK it's just cleanup. So it would simplest to get this patch 5 to
> staging tree, less conflicts that way.

Sorry, I thought it was dependant on the previous patches, given that
the first time I tried to apply it, it failed.

Omer, can you just resend this single patch to me and I will be glad to
apply it to the staging tree, if it really is stand-alone.

thanks,

greg k-h
