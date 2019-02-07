Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C559C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C40822084D
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 09:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SnNgYw84";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EW3Mdabh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfBGJdK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:33:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfBGJdJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 04:33:09 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C5D966090B; Thu,  7 Feb 2019 09:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549531988;
        bh=7rhVudjBtbE0VPO2ETCz8TxS7n/jtdn0qv32HEduZ3k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SnNgYw84XjabAv9JDef+tVUlrzyQbIJOcjd/owtHzRXhrgXwaZt8XtiqytSUffEW8
         ULoOY7QwpfzyvRyjR+ZJwPNRij1ePi1fzed6uvRA7FJlSL78+xUzcNCmhDIXK3fSE1
         +8jiEr6usTQt2qsDA4eNFfvdKErAU7T4Law/NPWE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8A512607DF;
        Thu,  7 Feb 2019 09:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549531987;
        bh=7rhVudjBtbE0VPO2ETCz8TxS7n/jtdn0qv32HEduZ3k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EW3MdabhrZIHVut1aRfBeepMDfNwShC9Rc9pomXSyayLPi/Z9l0zYLdo6jSZosQGO
         C2gu70p0YDxW0mpriX/U6o6g8Ijv9MQgHaRCtyC+nf/mmzfy+P2WgAi6wQhenYGkA+
         7SFXzoR5XgaXYngTO6/T6pubJMWjxRgfnt6bRmik=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8A512607DF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 07/21] iwlwifi: mvm: add HE TB PPDU SIG-A BW to radiotap
References: <20190131202206.15903-1-luca@coelho.fi>
        <20190131202206.15903-8-luca@coelho.fi>
        <875ztwss5s.fsf@purkki.adurom.net>
        <1b42081df8509e04046c3c0923a3319101852c5e.camel@sipsolutions.net>
Date:   Thu, 07 Feb 2019 11:33:04 +0200
In-Reply-To: <1b42081df8509e04046c3c0923a3319101852c5e.camel@sipsolutions.net>
        (Johannes Berg's message of "Wed, 06 Feb 2019 20:05:36 +0100")
Message-ID: <87d0o49c4v.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2019-02-06 at 20:11 +0200, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > From: Johannes Berg <johannes.berg@intel.com>
>> > 
>> > Expose the trigger-based PPDU SIG-A bandwidth to radiotap in
>> > the newly defined bits thereof.
>> > 
>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> 
>> [...]
>> 
>> > --- a/include/net/ieee80211_radiotap.h
>> > +++ b/include/net/ieee80211_radiotap.h
>> > @@ -291,6 +291,12 @@ enum ieee80211_radiotap_he_bits {
>> >  
>> >  	IEEE80211_RADIOTAP_HE_DATA6_NSTS		= 0x000f,
>> >  	IEEE80211_RADIOTAP_HE_DATA6_DOPPLER		= 0x0010,
>> > +	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_KNOWN	= 0x0020,
>> > +	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW		= 0x00c0,
>> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_20MHZ	= 0,
>> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_40MHZ	= 1,
>> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_80MHZ	= 2,
>> > +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_160MHZ	= 3,
>> >  	IEEE80211_RADIOTAP_HE_DATA6_TXOP		= 0x7f00,
>> >  	IEEE80211_RADIOTAP_HE_DATA6_MIDAMBLE_PDCTY	= 0x8000,
>> >  };
>> 
>> Johannes, as you wrote the patch I take it that you are ok to push this
>> via wireless-drivers-next?
>
> Oops, maybe I should've split that, but it doesn't really matter much.

IMHO splitting does not make any sense, we had four changes to
ieee80211_radiotap.h last year so the chance of conflicts is low :) Just
wanted to make sure you are ok with this.

> Sure, take it.

Great, thanks. I'll pull this now.

-- 
Kalle Valo
