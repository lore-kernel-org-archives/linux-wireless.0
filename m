Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:37613 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731968AbeGMI06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 04:26:58 -0400
Date: Fri, 13 Jul 2018 10:13:08 +0200
From: Dominique Martinet <asmadeus@codewreck.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] wireless/ti: change strncpy+truncation to strlcpy
Message-ID: <20180713081308.GC9638@nautica> (sfid-20180713_101335_129283_43A111EA)
References: <1531444483-17338-1-git-send-email-asmadeus@codewreck.org>
 <1531445149-19607-1-git-send-email-asmadeus@codewreck.org>
 <20180713073810.GA31984@kroah.com>
 <5B485917.7090102@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5B485917.7090102@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote on Fri, Jul 13, 2018:
> The patch adding that script contains a good motivation, but I would want to
> see that in commit message of every patch or at least the gist of
> it.

In retrospect, I definitely agree - I was happy I got coccinelle to work
and a bit too tired to make rationale decisions when I sent the serie as
it's not a kind of thing I'm used to.

For the patch you ack'd, in particular, there would be no gcc warning in
the first place because the source string's size is not known at compile
time and for some reason gcc does not mind silent truncation in that
case, so the usefulnes of the patch is fairly limited in the first
place (it's possibly simpler/good to aim for consistency but that's
about it). I however didn't take the time to make that analysis for all
the patches.

> especially as that script is not in the kernel tree yet.

I did think about that, but wasn't sure what was appropriate in this
case.
I now think it would have been better to save everyone a dozen of mails
and wait for the coccinelle patch to land first; but it's a bit late for
regret :)
I'll only catter after the coccinelle script until it lands, so if
anyone is inclined to take one of the rest as they are, great, but
otherwise feel free to ignore them for now.
(In particular, this very patch should not remove the first comment
here, as pointed out by Himanshu Jha in reply to the first patch)


Thanks for taking the time to give feedback,
-- 
Dominique Martinet
