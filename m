Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652F8C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B48520879
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="nCtQvdQs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfCYOeq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:34:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35930 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfCYOeq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 10:34:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id r124so6693394pgr.3
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 07:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I9vBCyjfANpsWkFDVseR5/3nUOvNBHoi3o5TEJQbQfI=;
        b=nCtQvdQseoRMhD3LWldKrvXtnHNJf+YYgmjhwDbfPs4sKElAT5OZvQN9HSZPNLQtw4
         /LpbR443PUCA8C+FuRv953Ek1H0lY4Yd/zUo85zZhKA+u7I1jAZisG6SnKqFR7Zo+zPg
         mqnTX78kHJOfGBSMdq/L686b/JA2hHyVCJf/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I9vBCyjfANpsWkFDVseR5/3nUOvNBHoi3o5TEJQbQfI=;
        b=WCHTXBzuxS4KUku7LS+pdMK/tEyw4FYso7usSJkIRG5/PVBqxsk73K74q8eOgDFImU
         4BdI7z0rgw052MfM8U2eVShNqifT60Ia8fkFQOdhu5XgdTBfVoNLYSx3pzfS/aKq9MTh
         sSsrpYl/NqwNrt/4XoxbhY0HvZd9i8ThGlaz830yJmWv9KvAWPCs/FvMfNlCWVR0EpMN
         uAdahf4nY5l15JV9aAJqCTe7MgFgfitc9WfQulo2J3T2IH9Vg/qdloyxwG4kxmbXeaFz
         XJrOIVIL4IPOAChPsdB7T8nI4XRRK7u9hxaCVIQRLXvlaxFQqxfcRZ0AC9u+FCLjEjZ6
         tPkw==
X-Gm-Message-State: APjAAAUa+bF0CCSglrnnLSS/FVlH6p0Tk8TTM1vCEBiutHES7IF/s50a
        x3N1+LAgR552R35G6mgMWJXsmg==
X-Google-Smtp-Source: APXvYqyWkdjNpS5PazUnWj9fmP863yltuwtEWV/DIOf2dlg9U8bFBN/v43CTZZLK6Nr1U4odQgYDFg==
X-Received: by 2002:a63:4383:: with SMTP id q125mr22129295pga.370.1553524485434;
        Mon, 25 Mar 2019 07:34:45 -0700 (PDT)
Received: from penguin (189.8.197.35.bc.googleusercontent.com. [35.197.8.189])
        by smtp.gmail.com with ESMTPSA id i72sm28740915pfj.147.2019.03.25.07.34.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:34:44 -0700 (PDT)
Date:   Mon, 25 Mar 2019 14:34:39 +0000
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        sgruszka@redhat.com, pkshih@realtek.com, tehuang@realtek.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH v8 03/14] rtw88: hci files
Message-ID: <20190325143439.pxe2sppqssdad4in@penguin>
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
 <1552450443-351-4-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552450443-351-4-git-send-email-yhchuang@realtek.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Mar 13, 2019 at 12:13:52PM +0800, yhchuang@realtek.com wrote:
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> new file mode 100644
> index 0000000..cf3bffb
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -0,0 +1,1211 @@
...
> +static u8 ac_to_hwq[] = {
> +	[0] = RTW_TX_QUEUE_VO,
> +	[1] = RTW_TX_QUEUE_VI,
> +	[2] = RTW_TX_QUEUE_BE,
> +	[3] = RTW_TX_QUEUE_BK,
> +};

I don't want to dig up and repeat the details of my comments, but I
think you missed my earlier suggestion here: you should use the
ieee80211_ac_numbers enum instead of bare 0-3 indexing.

> +static u8 rtw_hw_queue_mapping(struct sk_buff *skb)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	__le16 fc = hdr->frame_control;
> +	u8 q_mapping = skb_get_queue_mapping(skb);
> +	u8 queue;
> +
> +	if (unlikely(ieee80211_is_beacon(fc)))
> +		queue = RTW_TX_QUEUE_BCN;
> +	else if (unlikely(ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)))
> +		queue = RTW_TX_QUEUE_MGMT;
> +	else
> +		queue = ac_to_hwq[q_mapping];

It also seems wise to be defensive about the values of 'q_mapping', so
we don't accidentally overstep the array if for some reason the
implementation details of mac80211 change some day. e.g.:

	else if (WARN_ON_ONCE(q_mapping >= ARRAY_SIZE(ac_to_hwq)))
		// Pick a default.

Brian

> +
> +	return queue;
> +}
> +
