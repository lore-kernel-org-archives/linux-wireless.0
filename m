Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD4BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 18:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C806520870
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 18:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TMY/9kv2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C806520870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbeJKBnr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 21:43:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37991 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbeJKBnr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 21:43:47 -0400
Received: by mail-pg1-f196.google.com with SMTP id f8-v6so2894725pgq.5
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yNLXc3iVhOJyB04HuAAZiLWd2kTCaI4POOJZElAQ23w=;
        b=TMY/9kv2cllOVMpbbaJhv1ZlcwgsJw07PcH6/woO3zcr1bTJyHFAlc3wQChEcxB/4O
         maqvPzzk4v3FXo3eHcjjMVJXbsXVuhOt+eV+Fi1JiVkiQAbL1Ld9mr05Zm/E/GMbpJq/
         NKYM6L000nuJSkS6CL5hCm+0g6bFWCoBjuVaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yNLXc3iVhOJyB04HuAAZiLWd2kTCaI4POOJZElAQ23w=;
        b=a07on0wuYknZepEiRWdtn9yYpESAHLQRiAyk1jhpRUDFor/G4iUtcWWUQv2GOpG+yT
         NlWa6fE5rCkpDduKiihZCdmvPCMlNMBVusKpEwdLVzkgw2ncApyuPkYNvxSmrDxJTIvs
         92Z/u3L9e9IuK0y+Q+O+Io1yTvgbrZH9H3vGvt5Xogq15a6xWSYiJ1nGo0frSjX31VQh
         CRpQdEYhvulpitNiGwJ3p1nr3HBOZeVHK1tsdrz28+PaNMg4pQqSssngpUWvYLrruL4r
         EytEKoD9cZdiq2NL3OKH9aqe/oOeE6EH/IliWxDpYBED2ooKdfywK+F48/9VdAttAp4f
         /bsA==
X-Gm-Message-State: ABuFfoiUugP4TOJlHdJ1gtybE2kVqOTQ28+V0GZKaa3ZiOeQ+qVRQtnf
        Y/oBczJGYa5Y0GkqcxGJXVXfcQ==
X-Google-Smtp-Source: ACcGV63O85MDTODohvoFv3A+UB8jMj3vt9OBMKkmBlotXy+TTelRrYGjFtS8JGk13aKlKmy6AEYpaA==
X-Received: by 2002:a62:c60a:: with SMTP id m10-v6mr35222967pfg.15.1539195628341;
        Wed, 10 Oct 2018 11:20:28 -0700 (PDT)
Received: from ban.mtv.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id a86-v6sm35027314pfg.106.2018.10.10.11.20.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Oct 2018 11:20:26 -0700 (PDT)
Date:   Wed, 10 Oct 2018 11:20:25 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Carl Huang <cjhuang@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ath10k: allocate small size dma memory in
 ath10k_pci_diag_write_mem
Message-ID: <20181010182023.GA26746@ban.mtv.corp.google.com>
References: <1539171269-23944-1-git-send-email-cjhuang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539171269-23944-1-git-send-email-cjhuang@codeaurora.org>
User-Agent: Mutt/1.10.1+48 (1f3a9df87d11) (2018-07-22)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Carl,

On Wed, Oct 10, 2018 at 07:34:29PM +0800, Carl Huang wrote:
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1071,10 +1071,9 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
>  	struct ath10k_ce *ce = ath10k_ce_priv(ar);
>  	int ret = 0;
>  	u32 *buf;
> -	unsigned int completed_nbytes, orig_nbytes, remaining_bytes;
> +	unsigned int completed_nbytes, alloc_nbytes, remaining_bytes;
>  	struct ath10k_ce_pipe *ce_diag;
>  	void *data_buf = NULL;
> -	u32 ce_data;	/* Host buffer address in CE space */
>  	dma_addr_t ce_data_base = 0;
>  	int i;
>  

...

> @@ -1128,7 +1127,7 @@ int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
>  		 * Request CE to send caller-supplied data that
>  		 * was copied to bounce buffer to Target(!) address.
>  		 */
> -		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)ce_data,
> +		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)ce_data_base,

The (u32) cast isn't necessary, is it? ath10k_ce_send_nolock() takes a
dma_addr_t for the 3rd argument.

Incidentally, that'd probably help if you start supporting PCI devices
with >32-bit addressing.

Brian

>  					    nbytes, 0, 0);
>  		if (ret != 0)
>  			goto done;
...
