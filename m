Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56644 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab1F3IiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 04:38:08 -0400
Received: by wwe5 with SMTP id 5so2004447wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 01:38:07 -0700 (PDT)
Date: Thu, 30 Jun 2011 11:37:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 017/119] staging: brcm80211: change FOREACH_BSS macro to
 remove checkpatch error
Message-ID: <20110630083700.GK14591@shale.localdomain> (sfid-20110630_103817_259224_6099493F)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-18-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1309391303-22741-18-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 04:46:41PM -0700, Franky Lin wrote:
>  #define FOREACH_BSS(wlc, idx, cfg) \
> -	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
> -		if ((cfg = (wlc)->bsscfg[idx]))
> +	for (idx = 0, cfg = (wlc)->bsscfg[idx]; \
> +	     idx < WLC_MAXBSSCFG; cfg = (wlc)->bsscfg[++idx]) \
> +		if (cfg)
>  

That's pretty ugly.  Better to leave the original in and ignore the
checkpatch warning.  Or maybe do something like this:

	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) { \
		cfg = (wlc)->bsscfg[idx];		  \
		if (!cfg)				  \
			continue;			  \

Then #define END_FOREACH_BSS() }

Btw, this patchset has over 100 patches so unless there is something
drastically wrong lets just apply it as is and fix up any complaints
that people have in later patches.  It sucks when people resend huge
patchsets and we have to review everything again.

regards,
dan carpenter
