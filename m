Return-Path: <SRS0=rxFU=5K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5754C43331
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 867B520775
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585145301;
	bh=IZo1J1tevLNsIVqc+ZMKpxYPLZwg2d+od6g/WWkLoCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YS1Ar53ABD+E8SvrPGVdnb05Xd3iFllRYFuaKTOP12DJYHwyQc0VgD6wt20K7O9iT
	 CA8akbxvpDfqeYETNGkCml6vidi94B+IQXo+mUeNmA7taPhlQX0dR2hv9b5+hyCqW5
	 A7sULrsapHBwa66gjfLVB1441w0pz48FN13MUsUs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgCYOIU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Mar 2020 10:08:20 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37513 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgCYOIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Mar 2020 10:08:20 -0400
Received: by mail-qk1-f196.google.com with SMTP id x3so2620261qki.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2020 07:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gLSZ7fPqkgn6QHp6A0IK7+8N0/dOWjDHh8xnnRpQyfQ=;
        b=AYaCWvVt38yBDRN45Z20bEn0OMXIdEXOra06m/cWmu5wvloKjb9fce9DfgT7/I3Sb0
         FfInJwD6bm1srmNEKUtuuMZUNfOWKX1/BjsOSpKTf/dLEtYLFLL8drimyvQNficXVxU2
         wydaw98r9YzZ4NpuY5VPp7VkqaXdZxPp785kWgPdtlwBy7cDcRebW+IAT/l+Ne7mMqO6
         AvKQdIvvk2Vnq8eS6UoKvJjvp9OYlu/lK93QyyiIsGAQRrpVSM2KJrzT1gKHjjk0EDt7
         QfJvCXoj33yspYs1zNM8uAv1rO8RzgmfQmNAAcK/zvr4LGMXnuvaItigxjaqUitE49tP
         xnmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=gLSZ7fPqkgn6QHp6A0IK7+8N0/dOWjDHh8xnnRpQyfQ=;
        b=eWu9HfLBPl7qi6YrYpIeAvhmtUidsEMCL/gJlR6IvNJ7tWuXQ/ypVQWcJG5sUNcid5
         eeE/TxKS3Aw35A1uIEaPI5y2IZYYXNFl4rYjsuIYNOJ4ULC9WCOYJH7bawD/mW9Y5WpX
         I0L9tQg3GTh0Ok2cASlbhrOK5qR7b51dJ7yaGyngIZ/5rhKgzVht0MZ8ZBh1Vc5D9fN9
         boMOAF9KM80/yumDnpOVKIwFXrZWypW8ohd+Ki8ENR3MeWVujuvdrfQ0MOq2pHOaYqWO
         FzbZVuAeiRDi7+thkUfPpZuuGgSFsu9BrsSz/2Gqa2gg3vZFScT4ehDUNtvkxROvArnB
         0kTg==
X-Gm-Message-State: ANhLgQ1e0pBuVK6fWC6S0r/s5ujXMWfwzXYKSuyn/SG/970vrfkzj/q0
        6fO0UFAeHgwi1S9L4NKO4hI=
X-Google-Smtp-Source: ADFU+vuMbNQjVMv7X3yQKObkHs1d8H3okyztFZzXT4pho3TiCcyo9fVSFX2rw+k4zniWxumCPPxAyw==
X-Received: by 2002:a37:aa4c:: with SMTP id t73mr3036253qke.300.1585145297567;
        Wed, 25 Mar 2020 07:08:17 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::d8d4])
        by smtp.gmail.com with ESMTPSA id w4sm14721156qkc.122.2020.03.25.07.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:08:15 -0700 (PDT)
Date:   Wed, 25 Mar 2020 10:08:14 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Wright Feng <wright.feng@cypress.com>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 3/3] brcmfmac: make setting SDIO workqueue WQ_HIGHPRI a
 module parameter
Message-ID: <20200325140814.GI162390@mtj.duckdns.org>
References: <1584604406-15452-1-git-send-email-wright.feng@cypress.com>
 <1584604406-15452-4-git-send-email-wright.feng@cypress.com>
 <40e33702-d37f-085d-a5a7-7f09ae9e2629@broadcom.com>
 <241fd81b-a252-ed86-b93e-6796cf1bce23@cypress.com>
 <20200324182358.GD162390@mtj.duckdns.org>
 <02b42d9f-7ba3-bb7e-36a6-5e141d37d75d@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b42d9f-7ba3-bb7e-36a6-5e141d37d75d@cypress.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 25, 2020 at 12:29:44PM +0800, Wright Feng wrote:
> If that's incorrect, would you please give me a hint how to set
> __WQ_ORDERED(internal use flag) and WQ_HIGHPRI flags at the same time?

Wouldn't alloc_ordered_workqueue(NAME, WQ_HIGHPRI, ...) do what you want?

Thanks.

-- 
tejun
