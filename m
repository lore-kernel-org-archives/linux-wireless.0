Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8289 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbdESJvW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 05:51:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add configurable debugging.
Date: Fri, 19 May 2017 09:51:17 +0000
Message-ID: <87k25duqct.fsf@kamboji.qca.qualcomm.com> (sfid-20170519_115126_322092_50E9992A)
References: <20170510211925.17468-1-adrian@freebsd.org>
In-Reply-To: <20170510211925.17468-1-adrian@freebsd.org> (Adrian Chadd's
        message of "Wed, 10 May 2017 14:19:25 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> This adds a few configurable debugging options:
>
> * driver debugging and tracing is now configurable per device
> * driver debugging and tracing is now configurable at runtime
> * the debugging / tracing is not run at all (besides a mask check)
>   unless the specific debugging bitmap field is configured.
>
> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>

Oops, I accidentaly replied to the wrong version of the patch. This is a
perfect example why adding version to the subject is so important:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#patch_version_missing

But anyway, this is what I wrote in v1:

ath10k-check found some trivial whitespace problems:

drivers/net/wireless/ath/ath10k/debug.h:207: return is not a function,
parentheses are not required
drivers/net/wireless/ath/ath10k/debug.h:209: return is not a function,
parentheses are not required
drivers/net/wireless/ath/ath10k/debug.h:210: return is not a function,
parentheses are not required
drivers/net/wireless/ath/ath10k/debug.h:214: Alignment should match open pa=
renthesis
drivers/net/wireless/ath/ath10k/debug.h:218: Alignment should match open pa=
renthesis
drivers/net/wireless/ath/ath10k/debug.c:2430: code indent should use
tabs where possible
drivers/net/wireless/ath/ath10k/debug.c:2430: please, no spaces at the star=
t of a line
drivers/net/wireless/ath/ath10k/debug.c:2431: code indent should use
tabs where possible
drivers/net/wireless/ath/ath10k/debug.c:2431: please, no spaces at the star=
t of a line
drivers/net/wireless/ath/ath10k/debug.c:2464: code indent should use
tabs where possible
drivers/net/wireless/ath/ath10k/debug.c:2464: please, no spaces at the star=
t of a line
drivers/net/wireless/ath/ath10k/debug.c:2465: code indent should use
tabs where possible
drivers/net/wireless/ath/ath10k/debug.c:2465: please, no spaces at the star=
t of a line
drivers/net/wireless/ath/ath10k/debug.c:2493: Please don't use multiple bla=
nk lines
drivers/net/wireless/ath/ath10k/debug.c:2525: Symbolic permissions
'S_IRUSR' are not preferred. Consider using octal permissions '0400'.
drivers/net/wireless/ath/ath10k/debug.c:2527: Symbolic permissions
'S_IRUSR' are not preferred. Consider using octal permissions '0400'.
drivers/net/wireless/ath/ath10k/debug.c:2620: Alignment should match open p=
arenthesis
drivers/net/wireless/ath/ath10k/debug.c:2640: Alignment should match open p=
arenthesis

I fixed those in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3Dp=
ending&id=3Dbd8c3bdce70adc201037b2eb7eda0a83911ef375

I'll look at this more closely later.

--=20
Kalle Valo=
