Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34580 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754422AbeBGUVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 15:21:37 -0500
Message-ID: <1518034894.3124.9.camel@sipsolutions.net> (sfid-20180207_212142_361291_02E1CE11)
Subject: Re: [PATCH v2] ieee80211: Increase the PMK maximum length to 64
 bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Srinivas Dasari <dasaris@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, jouni@codeaurora.org
Date: Wed, 07 Feb 2018 21:21:34 +0100
In-Reply-To: <5A7B54E9.8070805@broadcom.com> (sfid-20180207_203508_852301_520027C6)
References: <1518020451-8743-1-git-send-email-dasaris@codeaurora.org>
         <5A7B54E9.8070805@broadcom.com> (sfid-20180207_203508_852301_520027C6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-02-07 at 20:35 +0100, Arend van Spriel wrote:
> On 2/7/2018 5:20 PM, Srinivas Dasari wrote:
> > This is needed to cover the case of DPP with the NIST P-521 and
> > brainpoolP512r1 curves which derive a PMK that is longer than the
> > previously used limit.
> 
> So how are driver supposed to deal with this longer PMK. Maybe if you 
> could elaborate on what DPP stands for in this context it would become 
> more clear. 

device provisioning protocol, I guess? But longer curves and longer PMK
is kinda obvious, whichever way that ends up getting used.

> Can we stick with PMK_MAX_LEN or does it need to be more 
> fine-grained per use-case? If existing drivers only support 48 bytes PMK 
> and trust nl80211 code to check that limit it may screw them up. Not?

Yeah I'm concerned about this too - and regardless of that issue, we
probably need those drivers that do support it to advertise support for
the new curves, and then allow the longer PMK length only for those that do?

johannes
