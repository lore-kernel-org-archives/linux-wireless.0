Return-Path: <SRS0=rhGe=VT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA9EC76194
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jul 2019 23:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19EDB2199C
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Jul 2019 23:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563838832;
	bh=K78YHNG372a/LgE1EDhdw9kNZDFzuVgqDnyQrgmFWAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UWCkkhV3mQJf8N7YYewZeUdujBQ8IZVmzbN64wH45Lhe4HOd50ujzzIEEaN+xuMBX
	 205jNjZqujfHABPr/iRh/c7rVqJrFndmB5d1gwG6vi2xy2NRz0vuHXTSxRVubFqbzQ
	 zvJfU3hiseVU7pM3tm1XnCAWdUiyZy6ATx2UXyc4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbfGVXkb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Jul 2019 19:40:31 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43398 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfGVXkb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jul 2019 19:40:31 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so77834059ios.10;
        Mon, 22 Jul 2019 16:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5kbmdtyoIqqv6CwHcDBtSAQ4GBxL50XX+ghk096nEbg=;
        b=TF0qpkeYbCxmzaVItclX0SVoNZktLO8hu2zadlTMnWkPYkEddriuLkSXZ5hBi+YorI
         42teF/L/O9QerUOMQazCpN/ZUUnICeJ3S4HTUXJHFosmfFaeBfnqtJ0nAq6NPx9fzK0P
         TiRSFxvYvwZHh6DsOOzuLVyrsZZRu2api/j6qqYLoWq3nmARX1Lg4qGrq/KdHJ0Yc1fK
         FIMyDd6CfXJQYyIEuSA6de1rBWqvoGFz9e8XGzGhooQc820++tWF8Omkxj0B/7eVag/t
         eyOqHKK87QbnvZe0v//jR9cTUONbdCYkTh+6GC6QOMKqjRNg8BRNdgrkspNHYtuj6X29
         5PQw==
X-Gm-Message-State: APjAAAUlxkBsIVy7H3RkpJaWm4B09JfFumPouwIUM0WcWgtOmQ0dqGe8
        0abOnUbqQt3FhmccpihhtmRSu1A=
X-Google-Smtp-Source: APXvYqy62yyWeiDelOvsPn92v9VPMA8T01uWGBXpV51/F9WWhSRt1TyGUnsdb2HOGw4UOR09ewfkmA==
X-Received: by 2002:a5d:9711:: with SMTP id h17mr66640433iol.280.1563838830268;
        Mon, 22 Jul 2019 16:40:30 -0700 (PDT)
Received: from localhost ([64.188.179.254])
        by smtp.gmail.com with ESMTPSA id j23sm33872892ioo.6.2019.07.22.16.40.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 16:40:29 -0700 (PDT)
Date:   Mon, 22 Jul 2019 17:40:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: Re: [PATCH 1/3] dt: bindings: update compatible dt properties for
 WCN3990 wifi node
Message-ID: <20190722234028.GA9986@bogus>
References: <20190703035711.25592-1-govinds@codeaurora.org>
 <20190703035711.25592-2-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703035711.25592-2-govinds@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed,  3 Jul 2019 09:27:09 +0530, Govind Singh wrote:
> update compatible dt properties for WCN3990 wifi node to be
> compatible across different MSM platforms.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
