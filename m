Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19335C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 19:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D90D82075C
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 19:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfBFTFp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 14:05:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60420 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBFTFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 14:05:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1grSVu-0005e3-Jn; Wed, 06 Feb 2019 20:05:38 +0100
Message-ID: <1b42081df8509e04046c3c0923a3319101852c5e.camel@sipsolutions.net>
Subject: Re: [PATCH 07/21] iwlwifi: mvm: add HE TB PPDU SIG-A BW to radiotap
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>, Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 06 Feb 2019 20:05:36 +0100
In-Reply-To: <875ztwss5s.fsf@purkki.adurom.net> (sfid-20190206_191207_006680_B30CBFD8)
References: <20190131202206.15903-1-luca@coelho.fi>
         <20190131202206.15903-8-luca@coelho.fi> <875ztwss5s.fsf@purkki.adurom.net>
         (sfid-20190206_191207_006680_B30CBFD8)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-06 at 20:11 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Expose the trigger-based PPDU SIG-A bandwidth to radiotap in
> > the newly defined bits thereof.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> [...]
> 
> > --- a/include/net/ieee80211_radiotap.h
> > +++ b/include/net/ieee80211_radiotap.h
> > @@ -291,6 +291,12 @@ enum ieee80211_radiotap_he_bits {
> >  
> >  	IEEE80211_RADIOTAP_HE_DATA6_NSTS		= 0x000f,
> >  	IEEE80211_RADIOTAP_HE_DATA6_DOPPLER		= 0x0010,
> > +	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_KNOWN	= 0x0020,
> > +	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW		= 0x00c0,
> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_20MHZ	= 0,
> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_40MHZ	= 1,
> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_80MHZ	= 2,
> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_160MHZ	= 3,
> >  	IEEE80211_RADIOTAP_HE_DATA6_TXOP		= 0x7f00,
> >  	IEEE80211_RADIOTAP_HE_DATA6_MIDAMBLE_PDCTY	= 0x8000,
> >  };
> 
> Johannes, as you wrote the patch I take it that you are ok to push this
> via wireless-drivers-next?

Oops, maybe I should've split that, but it doesn't really matter much.
Sure, take it.

johannes

