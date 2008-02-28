Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:42388 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYB1Wu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:50:56 -0500
Received: by wr-out-0506.google.com with SMTP id c48so5477277wra.23
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2008 14:50:55 -0800 (PST)
Message-ID: <43e72e890802281450x42b44929q1a2e2cd518c2bbc6@mail.gmail.com> (sfid-20080228_225059_755531_014AD054)
Date: Thu, 28 Feb 2008 17:50:53 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [PATCH 7/8] ath5k: Minor code review to match regdumps
In-Reply-To: <20080224043141.GF4426@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224043141.GF4426@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 23, 2008 at 11:31 PM, Nick Kossifidis <mick@madwifi.org> wrote:
>
>   * Make some changes to follow register dumps.
>
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
>  ---
>  diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>  index cd640ed..adcce6f 100644
>  --- a/drivers/net/wireless/ath5k/hw.c
>  +++ b/drivers/net/wireless/ath5k/hw.c
>  @@ -727,15 +727,23 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                 /*
>                  * Write some more initial register settings
>                  */
>  -               if (ah->ah_version > AR5K_AR5211){ /* found on 5213+ */
>  +               if (ah->ah_version == AR5K_AR5212){

We should probably just move this to a helper. Will send a patch based on this.

  Luis
