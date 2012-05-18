Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33162 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967137Ab2ERT6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 15:58:14 -0400
Date: Fri, 18 May 2012 12:58:12 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@vger.kernel.org, Touko Korpela <touko.korpela@iki.fi>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 3.2.y, 3.3.y] brcm80211: smac: fix endless retry of
 A-MPDU transmissions
Message-ID: <20120518195812.GE4874@kroah.com> (sfid-20120518_215818_742640_EDD033DF)
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
 <1330018703-2472-2-git-send-email-arend@broadcom.com>
 <20120516222824.GA11009@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120516222824.GA11009@burratino>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2012 at 05:28:25PM -0500, Jonathan Nieder wrote:
> From: Arend van Spriel <arend@broadcom.com>
> Date: Thu, 9 Feb 2012 21:08:58 +0100
> 
> commit 5e379203c7788b7af01150bfadbc74d2797a2ef4 upstream.
> 
> The A-MPDU code checked against a retry limit, but it was using
> the wrong variable to do so. This patch fixes this to assure
> proper retry mechanism.
> 
> This problem had a side-effect causing the mac80211 flush callback
> to remain waiting forever as well. That side effect has been fixed
> by commit by Stanislaw Gruszka:
> 
> commit f96b08a7e6f69c0f0a576554df3df5b1b519c479
> Date:   Tue Jan 17 12:38:50 2012 +0100
> 
>     brcmsmac: fix tx queue flush infinite loop
> 
>     Reference:
>     https://bugzilla.kernel.org/show_bug.cgi?id=42576
> 
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Alwin Beukers <alwin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
> ---
> Hi Ben and Greg,
> 
> Please consider
> 
>   5e379203c778 brcm80211: smac: fix endless retry of A-MPDU
>                transmissions
> 
> for application to the 3.2.y and 3.3.y stable trees.  It is the real
> fix to the bug worked around by f96b08a7e6f6 (brcmsmac: fix tx queue
> flush infinite loop, 2012-01-17).  The remaining symptom after that
> workaround was an assertion failure (WARNING at
> drivers/net/wireless/brcm80211/brcmsmac/main.c:8241).
> 
> Touko Korpela (cc-ed) tested the patch against 3.2.17 + "brcm80211:
> smac: pass missing argument to 'brcms_b_mute'" and found it to
> work[1]:

It doesn't apply to the 3.3-stable tree, so it's a bit hard for me to
apply it...

thanks,

greg k-h
