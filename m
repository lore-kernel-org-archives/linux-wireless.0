Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:41178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYKMJQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 04:16:30 -0500
Message-ID: <491BF062.4050705@suse.de> (sfid-20081113_101636_701704_DA90178E)
Date: Thu, 13 Nov 2008 10:16:18 +0100
From: Frank Seidel <fseidel@suse.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, yi.zhu@intel.com,
	reinette.chatre@intel.com, ipw2100-devel@lists.sourceforge.net,
	hschaa@suse.de
Subject: Re: Problem with Kernel Oops in ipw2200
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de> <20081112213350.GJ2411@tuxdriver.com>
In-Reply-To: <20081112213350.GJ2411@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

John W. Linville schrieb:
> On Thu, Nov 06, 2008 at 04:46:59PM +0100, Frank Seidel wrote:
>> Frank Seidel schrieb:
>>> Ever suggestion is very appreciated.
>> My first search through the ipw2200 logs pointed
>> me to Davids last commit (521c4d96e0840ecce25b956e00f416ed499ef2ba)
>> and really after reverting it the problem disappeared here.
>> The patch from my last post was the smallest subset of
>> the revertion that still works for me here.
>> Any comments?
> 
> I think it would be better to make sure that ipw2200 (and/or
> ieee80211) is properly using netif_carrier_{on,off}() instead?

Thanks for your answer. But i am not sure i understand you correctly.
Do you propose to let the patch in place like it is?
The problem is that before this patch ipw2200 didn't have that problem
and now with it is constantly on various machines is running in
a kernel oops at ipw_tx_skb called by ipw_net_hard_start_xmit.
So imho that patch introduced the bug somehow and even partly reverting
it fixes the problem here on my testmachine.

Thanks for any help,
Frank
