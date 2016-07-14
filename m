Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38230 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbcGNNEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2016 09:04:16 -0400
Received: by mail-wm0-f51.google.com with SMTP id o80so112419312wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2016 06:04:15 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: Re: [PATCH 0/4 v1] Refactoring ieee80211_iface_work
Date: Thu, 14 Jul 2016 16:04:11 +0300
Message-ID: <2007551.3LXcTUKepp@shurik> (sfid-20160714_151215_285839_03A4C549)
In-Reply-To: <ecb3e937-7fa9-f530-1b23-b793b86b1514@broadcom.com>
References: <1468441196-23503-1-git-send-email-br.shurik@gmail.com> <ecb3e937-7fa9-f530-1b23-b793b86b1514@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Thank you for suggestions!
I will definitely collapse the two commits you suggested.

Could you please elaborate on your naming suggestion.
In your opinion, should it be something like 
mac80211_is handled_by_pkt_type? Or something entirely different?

Also, I have two more concerns about the suggested changes:
1. Necessity - whether these changes really improve readability of the code.
2. Precision - whether the code was split in logical manner.


On Thursday, July 14, 2016 09:56:19 AM Arend Van Spriel wrote:
> On 13-7-2016 22:19, Alex Briskin wrote:
> > Hi All,
> > This is my first patch(s).
> 
> Hi Alex,
> 
> As these patches are touching mac80211 it would be good to use
> 'mac80211: ' prefix.
> 
> > I've decided to refactor ieee80211_iface_work function and break it down
> > to smaller better defined function.
> > 
> > I think these changes make the code much more readable and do not impose
> > no overhead.
> > 
> > I've tested these patches with sparse and checkpatch.pl
> > 
> > Function names might not be descriptive enough.
> > Hope you find this useful.
> > 
> > Alex Briskin (4):
> >   0) [28e464b19aaaba90c8946fb979b58709d55dffcf]
> > 	
> > 	Added new function ieee80211_is_skb_handled_by_pkt_type and moved
> > 	some code from ieee80211_iface_work to reduce complexity and
> > 	improve readability
> > 	
> >   1) [486e3d5abb4dc6361cdd923254a2b68d43dcdaba]
> > 	
> > 	Refactored code in ieee80211_is_skb_handled_by_pkt_type.
> > 	"if () {} else if ()" replaced by switch case.
> 
> I would collapse these two patches in one patch.
> 
> >   2) [9ef2eab8e831420bc6748a4466ffa6b7a99bf447]
> > 	
> > 	Added new function ieee80211_is_handled_by_frame_control and moved
> > 	some code from ieee80211_iface_work to it.
> > 	
> >   3) [1de8cdf9a0c05c6a21d9e43e5b55862f6efcf450]
> > 	
> > 	Added new function ieee80211_handle_by_vif_type with code from
> > 	ieee80211_iface_work.
> > 	
> > 	At this point ieee80211_iface_work seems to me much more readable
> > 	and better understood.
> 
> You are allowed to have an opinion :-) The function naming of the three
> functions could be more consistent as you seem to drop a bit in every
> patch, ie. is_skb_handled_by -> is_handled_by -> handle_by.
> 
> Regards,
> Arend
> 
> >  net/mac80211/iface.c | 264
> >  +++++++++++++++++++++++++++++---------------------- 1 file changed, 150
> >  insertions(+), 114 deletions(-)

