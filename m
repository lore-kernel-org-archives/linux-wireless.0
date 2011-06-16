Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4607 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab1FPBg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 21:36:27 -0400
Date: Wed, 15 Jun 2011 18:36:16 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg Dietsche" <Gregory.Dietsche@cuw.edu>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: return false if not a broadcom
 board
Message-ID: <20110616013615.GA14700@broadcom.com> (sfid-20110616_033646_826536_E46396B0)
References: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
In-Reply-To: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 15, 2011 at 03:25:09PM -0700, Greg Dietsche wrote:
> This code looks wrong to me. I think it meant to return false
> if the board's vendor id isn't Broadcom's.
> 
> Compile tested only.
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> index 4534926..ee13238 100644
> --- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> +++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> @@ -1943,7 +1943,7 @@ static bool wlc_validboardtype(struct wlc_hw_info *wlc_hw)
>  	}
>  
>  	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
> -		return goodboard;
> +		goodboard = false; 
>  
>  	return goodboard;
>  }

Actually, the original code is correct.

For boards with the Broadcom ID, this function checks that the boardrev is
sane. Dev boards that aren't properly configured may have invalid info, so this
check is mainly to catch that problem.

For boards with any other vendor, we don't have any sanity checks that we know
should be done, so the board info is always considered good.

The device ID is of course always checked.

- Henry

