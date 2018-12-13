Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E763C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0407E204FD
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q4AkNPgd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PpJRapya"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0407E204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbeLMJZm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:25:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbeLMJZl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 04:25:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 560916013C; Thu, 13 Dec 2018 09:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544693141;
        bh=1FeO307oOSvhX6U4BB6tEqEY0vZrN6pIOqf+V3ZL3d0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Q4AkNPgdv2YCQFZihWmrRHRJNbhzvTLNPVmHvn8AtLZTW+BWWtcQF5TUEiYTdsmUc
         fdJGhrpXcZwzPxYqBFmWIchHFsBwG7ojU8u3vTZGI4Mvh2slvGYeB6HSJjIjE2mKfO
         qaIkIM2yQCXKgAUl0+YegQJfkGWYPrW+6jub1BM8=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 64378601E7;
        Thu, 13 Dec 2018 09:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544693140;
        bh=1FeO307oOSvhX6U4BB6tEqEY0vZrN6pIOqf+V3ZL3d0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PpJRapyaoVsLlTcN4xaKbr0XeE7EOsNF2UiA5Q1ZKQMrLvCJdM8Au2C2sGKGHoKIa
         Sh8oz2oOHSsPNEPU3TkCMinl2D0xgYwUyZS1/SCKXOykPV827bom0BNDnWnOJ9uHIs
         yztN9ScgRzeoi3lvw6wPhR2v+ffLx+f2IjCW/YeY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 64378601E7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1] cfg80211/nl80211: add support for AID assignment by driver
References: <20181212180928.42117-1-sarada.prasanna.garnayak@intel.com>
Date:   Thu, 13 Dec 2018 11:25:38 +0200
In-Reply-To: <20181212180928.42117-1-sarada.prasanna.garnayak@intel.com>
        (Sarada Prasanna Garnayak's message of "Wed, 12 Dec 2018 23:39:28
        +0530")
Message-ID: <87bm5p93sd.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com> writes:

> Add support for getting and free association ID if the station
> association ID management handled by the WLAN driver/firmware.
>
> Add cfg80211 driver ops and nl80211 API and CMD to request
> the WLAN driver to assign an AID for a station during association
> and release the AID of the station from the WLAN driver/firmware
> station database on disassociation from the AP.
>
> Signed-off-by: Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com>

[...]

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3183,6 +3183,12 @@ struct cfg80211_ftm_responder_stats {
>   *
>   * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
>   *	Statistics should be cumulative, currently no way to reset is provided.
> + * @get_sta_aid: Get an AID for the station from the driver if AID assignment
> + *	is managed by the WLAN driver/hardware/firmware.
> + *
> + * @free_sta_aid: Release the AID of the station from the station database
> + *	on disassociation from the AP if AID assignment is managed by
> + *	the WLAN driver/hardware/firmware.
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> @@ -3492,6 +3498,11 @@ struct cfg80211_ops {
>  	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
>  				struct net_device *dev,
>  				struct cfg80211_ftm_responder_stats *ftm_stats);
> +
> +	int (*get_sta_aid)(struct wiphy *wiphy, struct net_device *dev,
> +			   u16 *sta_aid, const u8 *mac_addr);

If I'm reading this patch correctly it looks like sta_aid or mac_addr
(or even both?) can be NULL? How should the driver handle that? I didn't
see any mentions of this in the document.

-- 
Kalle Valo
