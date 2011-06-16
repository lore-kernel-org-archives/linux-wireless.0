Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4941 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591Ab1FPXhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 19:37:48 -0400
Date: Thu, 16 Jun 2011 16:37:36 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg Dietsche" <gregory.dietsche@cuw.edu>
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
Message-ID: <20110616233736.GA2344@broadcom.com> (sfid-20110617_013806_722110_CA7D38FC)
References: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <20110616013615.GA14700@broadcom.com> <4DF96F22.5070508@cuw.edu>
MIME-Version: 1.0
In-Reply-To: <4DF96F22.5070508@cuw.edu>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 15, 2011 at 07:49:06PM -0700, Greg Dietsche wrote:
> 
> 
> On 06/15/2011 08:36 PM, Henry Ptasinski wrote:
> > On Wed, Jun 15, 2011 at 03:25:09PM -0700, Greg Dietsche wrote:
> >    
> >> This code looks wrong to me. I think it meant to return false
> >> if the board's vendor id isn't Broadcom's.
> >>
> >> Compile tested only.
> >>
> >> Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
> >> ---
> >>   drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    2 +-
> >>   1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> >> index 4534926..ee13238 100644
> >> --- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> >> +++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
> >> @@ -1943,7 +1943,7 @@ static bool wlc_validboardtype(struct wlc_hw_info *wlc_hw)
> >>   	}
> >>
> >>   	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
> >> -		return goodboard;
> >> +		goodboard = false;
> >>
> >>   	return goodboard;
> >>   }
> >>      
> > Actually, the original code is correct.
> >
> > For boards with the Broadcom ID, this function checks that the boardrev is
> > sane. Dev boards that aren't properly configured may have invalid info, so this
> > check is mainly to catch that problem.
> >
> > For boards with any other vendor, we don't have any sanity checks that we know
> > should be done, so the board info is always considered good.
> >
> > The device ID is of course always checked.
> >
> > - Henry
> >
> >    
> Hi Henry,
> Thanks for the explanation - I'm still a little confused on this... 
> probably more because of how the code reads. Let me explain:
> 
> The part that threw me off in this code when I originally read it is 
> that it always returns goodboard. It doesn't actually matter what the 
> vendor id is. So my first thought was "what did they really mean to code 
> here...?" That's why I sent the patch. So if the patch isn't necessary, 
> then great! :) But it seems like we could/should just drop the check for 
> vendor id?

How's this for a somewhat clearer implementation:

static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
{
        bool goodboard = true;
        uint boardrev = wlc_hw->boardrev;

        if (wlc_hw->sih->boardvendor == PCI_VENDOR_ID_BROADCOM) {
                /* validate boardrev */
                if (boardrev == 0)
                        goodboard = false;
                else if (boardrev > 0xff) {
                        /* 4 bits each for board type, major, minor, and tiny
                        version numbers */
                        uint brt = (boardrev & 0xf000) >> 12;
                        uint b0 = (boardrev & 0xf00) >> 8;
                        uint b1 = (boardrev & 0xf0) >> 4;
                        uint b2 = boardrev & 0xf;

                        if ((brt > 2) || (brt == 0) || (b0 > 9) || (b0 == 0)
                                || (b1 > 9) || (b2 > 9))
                                goodboard = false;
                }
        }

        return goodboard;
}


If that's agreeable, I'll add it to a series of cleanup patches that I've got
in progress.

- Henry

