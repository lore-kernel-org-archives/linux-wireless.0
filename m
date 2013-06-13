Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34232 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842Ab3FMRpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 13:45:13 -0400
Date: Thu, 13 Jun 2013 13:32:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: Regression in 9390ace brcmfmac: free net device when
 registration fails
Message-ID: <20130613173213.GD3246@tuxdriver.com> (sfid-20130613_194521_813762_82A5FD66)
References: <51AD1F22.2080004@wwwdotorg.org>
 <51ADE47D.50700@broadcom.com>
 <51B0FAC0.4080709@broadcom.com>
 <51B100C2.8070905@wwwdotorg.org>
 <51B8E5FA.9040400@wwwdotorg.org>
 <51B97E56.4030701@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51B97E56.4030701@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 13, 2013 at 10:09:58AM +0200, Arend van Spriel wrote:
> On 06/12/2013 11:19 PM, Stephen Warren wrote:
> >On 06/06/2013 03:36 PM, Stephen Warren wrote:
> >>On 06/06/2013 03:10 PM, Arend van Spriel wrote:
> >>>On 06/04/13 14:58, Arend van Spriel wrote:
> >>>>On 06/04/2013 12:56 AM, Stephen Warren wrote:
> >>>>>(John, note that this commit is part of the pull request you sent to
> >>>>>Dave today)
> >>>>>
> >>>>>Arend,
> >>>>>
> >>>>>Commit 9390ace "brcmfmac: free net device when registration fails"
> >>>>>causes a regression.
> >>>>>
> >>>>>I had the BCM4330 firmware present in my root fs, whereas my HW is a
> >>>>>BCM4329. With this patch applied, I get a kernel panic on boot. With it
> >>>>>reverted, I see that no issues of that nature. This is true in
> >>>>>next-20130531 (and also 5/30 and 6/1 but not earlier). A bisect of
> >>>>>Linus's tree followed by a merge of John's wireless pull request from
> >>>>>today pointed at this same commit.
> >>>>
> >>>>Thanks, Stephen
> >>>>
> >>>>I will look into this.
> >>>
> >>>Hi Stephen,
> >>>
> >>>Can you try the attached patch? If it does not solve the issue, could
> >>>you provide a log.
> >>
> >>Yes, that works great, thanks.
> >>
> >>Tested-by: Stephen Warren <swarren@nvidia.com>
> >
> >Did this patch get applied anywhere? I was hoping it'd go into 3.10-rc*
> >given it's a user-triggerable backtrace introduced in 3.10-rc*.
> 
> Hi Stephen,
> 
> The patch went into the wireless-next tree. Given recent events with
> our patch series I am a bit more carsful to tag patches for 3.10.
> Your issue is user-triggerable but the scenario to get there can be
> avoided. But you are right it was introduced in the 3.10-rc cycle. I
> leave it to John to decide.
> 
> Regards,
> Arend

I've just applied it to the wireless tree.  I doubt if it will make
-rc6, but it might make the final 3.10.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
