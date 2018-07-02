Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35550 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932254AbeGBHVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 03:21:36 -0400
Date: Mon, 2 Jul 2018 10:21:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Pkshih <pkshih@realtek.com>,
        "briselec@gmail.com" <briselec@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>
Subject: Re: New realtek 11ac driver
Message-ID: <20180702072115.5gg2t7ey57bulbd2@mwanda> (sfid-20180702_092224_917681_1806193E)
References: <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw>
 <20180427224156.GA18163@thinktank.home.org>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BEBFD30@RTITMBSV07.realtek.com.tw>
 <CABPxzYKfZVA8RTADEG5TCu0SXRSVEGWEn+Ym6AkMuFzHC5iSVg@mail.gmail.com>
 <1526371717.12375.8.camel@realtek.com>
 <871sebkcad.fsf@codeaurora.org>
 <1526646826.1942.1.camel@realtek.com>
 <87bmd5ihm1.fsf@codeaurora.org>
 <1528162350.2800.3.camel@realtek.com>
 <87h8lmf0n5.fsf_-_@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87h8lmf0n5.fsf_-_@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 29, 2018 at 11:38:22AM +0300, Kalle Valo wrote:
> (Was "Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac",
> changing the title to reflect what we are discussing)
> 
> Pkshih <pkshih@realtek.com> writes:
> 
> > On Thu, 2018-05-24 at 11:27 +0300, Kalle Valo wrote:
> >> 
> >> You are missing my point: I don't even have time to review huge rtlwifi
> >> patches when they are not even ready for upstream. I cannot start
> >> working on cleaning up rtlwifi code and doing multiple iterations of
> >> reviews on these kind of huge patchsets. Either you need to
> >> significantly scale down the size of patchsets (especially LOC) or you
> >> need to get review help from someone else. But the current way of
> >> working is not doable for me.
> >> 
> >
> > Is there a proper way to look for "someone else" you mentioned?
> 
> I don't know, I think there might a project somewhere which helps with
> patch review for new people but not sure about that. Adding Dan in case
> he has some ideas.

It's just heart breaking to look at that driver.  It's over 64k line of
code.  As a reviewer, it's easy to glance at the first few lines and say
get rid of halmac_ret_status and use normal kernel return codes instead
but just implementing that small thing would take months because there
is so much code.

It doesn't even look like terrible code, it's just not linux code.

There is no way I'm touching these patches because it's just miles and
miles of sadness.

> > We plan to rewrite a new driver excluding agnostic OS layer to support 
> > new generation 11AC chips, because they're very different from the chips
> > existed in rtlwifi and rtl8xxxu. 

That's good news.

The OS layer was a failed experiment.  It was supposed to give us one
driver for everything but instead of that we have at least 7 drivers
just within the Linux kernel.  We abstracted the wrong thing.

regards,
dan carpenter
