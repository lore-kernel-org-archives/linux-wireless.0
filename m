Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535B9ECAAD5
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Sep 2022 15:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbiIEPiM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Sep 2022 11:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbiIEPiL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2022 11:38:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BA040E11
        for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2022 08:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C22061333
        for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2022 15:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F34C433D6;
        Mon,  5 Sep 2022 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662392289;
        bh=PeCsSW6Rg9COMHN8zA9YWGw5SLOlsrE0l/ZWNDchsjk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=rTCex0NJUdrb3wscud7/3xlxIFNZv7k+N5xGruYFG4uTrIJ7BLx9iUiFOVLzqI3xw
         S3K9PtUY2UwxWkYn88gSo6+Qf8g/az5MJVh/qxqvdo9R2zjz8FnIq9iER6pNiwy9VZ
         mBAbJk0OJ3TfOFYwGuuary3JZzGSoWIM7IjL6LHIINYqDSteadfALPQLdBlqFjDMk0
         PeG2aJG29Nic2LZQKks+++dxgGZHafS4OkXmTsKgOJ78UvFg0lky4Wlxshq5hzUBvm
         yNdBGOyDy+5NIuMN7m3Ut9i7V5znGVrhxf/90etlIib+X1CvtiuEEDosAagx0fA36W
         kS53XPzLdOHdw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 02/12] wifi: ipw2x00: fix array of flexible structures warnings
References: <20220904212910.8169e8c9090c.I0357e80cc86be2d4ac6205d1f53568444dcf7c9b@changeid>
        <20220904212910.645346411660.I471e8fadce54ea262920828f25b8e84545bcd07e@changeid>
Date:   Mon, 05 Sep 2022 18:38:05 +0300
In-Reply-To: <20220904212910.645346411660.I471e8fadce54ea262920828f25b8e84545bcd07e@changeid>
        (Johannes Berg's message of "Sun, 4 Sep 2022 21:29:02 +0200")
Message-ID: <87y1uxde76.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> There are a number of these here, fix them by using
> appropriate casts. No binary changes.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/libipw.h    | 13 ++++++-------
>  drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 10 +++++-----
>  2 files changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/ipw2x00/libipw.h b/drivers/net/wireless/intel/ipw2x00/libipw.h
> index 7964ef7d15f0..bec7bc273748 100644
> --- a/drivers/net/wireless/intel/ipw2x00/libipw.h
> +++ b/drivers/net/wireless/intel/ipw2x00/libipw.h
> @@ -405,7 +405,7 @@ struct libipw_auth {
>  	__le16 transaction;
>  	__le16 status;
>  	/* challenge */
> -	struct libipw_info_element info_element[];
> +	u8 variable[];

Why u8 is better?

> --- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
> +++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
> @@ -1329,8 +1329,8 @@ static int libipw_handle_assoc_resp(struct libipw_device *ieee, struct libipw_as
>  	network->wpa_ie_len = 0;
>  	network->rsn_ie_len = 0;
>  
> -	if (libipw_parse_info_param
> -	    (frame->info_element, stats->len - sizeof(*frame), network))
> +	if (libipw_parse_info_param((void *)frame->variable,
> +				    stats->len - sizeof(*frame), network))

To me this look worse as we need to add an extra cast, and casts are
always problematic.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
