Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49927 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYKMQQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 11:16:19 -0500
Date: Thu, 13 Nov 2008 11:03:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, yi.zhu@intel.com,
	reinette.chatre@intel.com, ipw2100-devel@lists.sourceforge.net,
	hschaa@suse.de
Subject: Re: Problem with Kernel Oops in ipw2200
Message-ID: <20081113160349.GA9827@tuxdriver.com> (sfid-20081113_171625_699392_A511B2B2)
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de> <20081112213350.GJ2411@tuxdriver.com> <491BF062.4050705@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <491BF062.4050705@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2008 at 10:16:18AM +0100, Frank Seidel wrote:
> Hi,
> 
> John W. Linville schrieb:
> > On Thu, Nov 06, 2008 at 04:46:59PM +0100, Frank Seidel wrote:
> >> Frank Seidel schrieb:
> >>> Ever suggestion is very appreciated.
> >> My first search through the ipw2200 logs pointed
> >> me to Davids last commit (521c4d96e0840ecce25b956e00f416ed499ef2ba)
> >> and really after reverting it the problem disappeared here.
> >> The patch from my last post was the smallest subset of
> >> the revertion that still works for me here.
> >> Any comments?
> > 
> > I think it would be better to make sure that ipw2200 (and/or
> > ieee80211) is properly using netif_carrier_{on,off}() instead?
> 
> Thanks for your answer. But i am not sure i understand you correctly.
> Do you propose to let the patch in place like it is?
> The problem is that before this patch ipw2200 didn't have that problem
> and now with it is constantly on various machines is running in
> a kernel oops at ipw_tx_skb called by ipw_net_hard_start_xmit.
> So imho that patch introduced the bug somehow and even partly reverting
> it fixes the problem here on my testmachine.

Well, what I am suggesting is that it would be better to fix the
intended purpose of the original patch rather than to partially
revert it, thereby partially reintroducing the problem it was trying
to fix. :-)

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
