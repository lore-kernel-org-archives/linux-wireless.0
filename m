Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:39806 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAKOQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 09:16:07 -0500
Received: by mail-la0-f52.google.com with SMTP id hs14so21230382lab.11
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 06:16:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54B273E1.6030306@googlemail.com>
References: <54B272F0.70307@googlemail.com>
	<54B273E1.6030306@googlemail.com>
Date: Sun, 11 Jan 2015 16:16:04 +0200
Message-ID: <CANUX_P2PiGUBaw89Rb2zSuy2x8=GJN=o6XgcasdVMtvoy6kmAQ@mail.gmail.com> (sfid-20150111_151616_228726_61E8EB58)
Subject: Re: IWLWIFI - 3.18-stable
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chris,

thank you for you analysis, it is very helpful

> Doh! Cut and paste error ...
>
> On 01/11/15 12:56, Chris Clayton wrote:
> > Hi Kalle,
> >
> > Having recently bought a new laptop, I've just started using the iwlwifi driver for wireless networking. I found both
> > 3.18.x and the current development tree to be very unreliable due to frequent disconnections from the router.
> >
> > Before you merged them into your tree, I grabbed the latest fixes from iwlwifi-fixes tree and applied them to the
> > development kernel. Since I did that I've had no problems at all with dropped connections. I then looked at each patch
> > to see whether it might be applicable to 3.18 and found that two of them looked as if they should be useful. They are:
> >
> > c93edc639392df733c7d72db4376a9add775d18a - iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it
>
> The above should have been:
>
> c93edc639392df733c7d72db4376a9add775d18a - iwlwifi: mvm: fix Rx with both chains
>
> >
> > a9dc5060bf3a32ac3dad472f15416054b92dc5b5 - iwlwifi: mvm: fix out of bounds access to tid_to_mac80211_ac
> >
> > With those two applied, I've had stable wireless networking on 3.18.2 and, more recently, 3.18.2. Consequently, they
> > seem appropriate for tagging for 3.18-stable, but, as far as I can see, they haven't been tagged for stable. Apologies,
> > if I'm mistaken, but if I'm not, could you consider submitting the two patches for inclusion in 3.18, please? Of course,
> > they may be appropriate to earlier kernels too - I haven't looked.
> >

The first one (c93edc639392df733c7d72db4376a9add775d18a) is tagged for stable.
Are you using bluetooth?
Are you able to tell me which of the two really helps?
Unless I am missing something, the first one
(c93edc639392df733c7d72db4376a9add775d18a) should help only if you
disabled power save. Is that the case?
