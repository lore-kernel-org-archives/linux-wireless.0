Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755322AbYJPV55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 17:57:57 -0400
Date: Thu, 16 Oct 2008 14:54:07 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: stable@kernel.org, steven@uplinklabs.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [stable] [PATCH] ath9k: fix oops on trying to hold the wrong
	spinlock
Message-ID: <20081016215407.GA17091@kroah.com> (sfid-20081016_235802_406818_3DE024F4)
References: <20081016111255.GA5899@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081016111255.GA5899@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 16, 2008 at 04:12:55AM -0700, Luis R. Rodriguez wrote:
> This fixes on oops when you get try to send a BA to an 11n AP.
> The oops occurred because we were trying to aquire an incorrect
> spinlock.
> 
> We were trying to hold the wrong spinlock due to a typo
> on IEEE80211_BAR_CTL_TID_S's definition. We use this to
> compute the tid number and then hold this this tid number's
> spinlock.
> 
> Tested-by: Steven Noonan <steven@uplinklabs.net>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> 
> I don't see this queue'd yet for 2.6.27.2

Is it in Linus's tree?  If so, do you have a git commit id?

thanks,

greg k-h
