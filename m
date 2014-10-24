Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39149 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbaJXMku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 08:40:50 -0400
Received: by mail-wi0-f169.google.com with SMTP id q5so1066266wiv.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2014 05:40:49 -0700 (PDT)
Date: Fri, 24 Oct 2014 14:40:40 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: minstrel_ht: do not always skip ht rates
 vht_only is true
Message-ID: <20141024124040.GA5323@magnum.frso.rivierawaves.com> (sfid-20141024_144054_111970_1BEBAB14)
References: <1414152061.1934.2.camel@jlt4.sipsolutions.net>
 <1414154089-5185-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1414154089-5185-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2014 at 02:34:49PM +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When CONFIG_MAC80211_RC_MINSTREL_VHT is set, the module param
> minstrel_vht_only tells minstrel_ht whether to allow the mix of ht rates
> with vht rates.
> ATM, minstrel_ht skips ht rates when minstrel_vht_only is true, but it does
> that even if vht is not supported, which makes the sta rates fallback to
> legacy as no ht rate gets enabled.
> 
> Fixes: 9208247d74bc ("mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz")
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---

This sneaked in between v4 and v5 when reformatting the code for 80ch.
v5:
- fix some checkpatch complaints this, leaves 2 false positives
  "ERROR: Macros with complex values should be enclosed in parenthesis"
      in array initialization
 
Karl
