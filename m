Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3214 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab1LNUHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 15:07:39 -0500
Message-ID: <4EE901FB.8040303@broadcom.com> (sfid-20111214_210741_873826_98A8D92E)
Date: Wed, 14 Dec 2011 21:07:23 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Strange code in routine wlc_phy_radio_init_2057()
References: <4EDD7026.9000308@lwfinger.net>
In-Reply-To: <4EDD7026.9000308@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2011 02:30 AM, Larry Finger wrote:
> In looking at the support code for Type 2057 radios in brcmsmac, I noticed the 
> following routine:
> 
> static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
> {
>          struct radio_20xx_regs *regs_2057_ptr = NULL;
> 
>          if (NREV_IS(pi->pubpi.phy_rev, 7)) {
>                  regs_2057_ptr = regs_2057_rev4;
>          } else if (NREV_IS(pi->pubpi.phy_rev, 8)
>                     || NREV_IS(pi->pubpi.phy_rev, 9)) {
>                  switch (pi->pubpi.radiorev) {
>                  case 5:
>                          if (pi->pubpi.radiover == 0x0)
>                                  regs_2057_ptr = regs_2057_rev5;
>                          else if (pi->pubpi.radiover == 0x1)
>                                  regs_2057_ptr = regs_2057_rev5v1;
>                          else
>                                  break;
>                  case 7:
>                          regs_2057_ptr = regs_2057_rev7;
>                          break;
>                  case 8:
>                          regs_2057_ptr = regs_2057_rev8;
>                          break;
>                  default:
>                          break;
>                  }
>          }
>          wlc_phy_init_radio_regs_allbands(pi, regs_2057_ptr);
> }
> 
> I do not think that the code for phy revisions 8 or 9, and radio revision 5 is 
> correct. When the radio version is 0, or 1, the case statement will fall through 
> to the radio revision 7 case, thereby negating the logic that sets regs_2057_ptr 
> for case 5.

You are right.

> 
> I think the following patch will fix it:
> 
> Index: wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
> +++ wireless-testing-new/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
> @@ -19996,8 +19996,8 @@ static void wlc_phy_radio_init_2057(stru
>                                  regs_2057_ptr = regs_2057_rev5;
>                          else if (pi->pubpi.radiover == 0x1)
>                                  regs_2057_ptr = regs_2057_rev5v1;
> -                       else
> -                               break;
> +
> +                       break;
> 
>                  case 7:
> 
> 
> Larry
> 

It is an improvement for sure, but it needs to be slightly different. I
will create a patch for this. Thanks for pointing us at this.

Gr. AvS

