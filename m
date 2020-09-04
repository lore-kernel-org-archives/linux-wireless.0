Return-Path: <SRS0=XMVh=CN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDC7C433E2
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Sep 2020 11:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E85320791
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Sep 2020 11:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DSl/tRbW";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="iiO4hH4u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgIDLwe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:52:34 -0400
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:55590
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728588AbgIDLwd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Sep 2020 07:52:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599220352;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=vT5h/v5J0boAtMF9/EBSpMpw2HFatyj+FNVX7BRQRCA=;
        b=DSl/tRbW6fWdb/RfM3MdWN0vkRfhLz+gbLD5PWvuRxy/iSagWn6G7AXHxcdcGUqX
        crmt1yop5VjpwentwT4mlnOnnNS5Cp5MkO4SnyV48BjdAapf1/IofV6Re/R8gOt8v5m
        3Wa1952WT+wcGGJZE8/xRcBCZ9PGKc2ir3lzFWkI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599220352;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=vT5h/v5J0boAtMF9/EBSpMpw2HFatyj+FNVX7BRQRCA=;
        b=iiO4hH4uThW14BxVhLjIFVkSvVbjwYjFh4259ZR6iYchkK1F6PT/K5oTJHUj/m6F
        LRyMjnLW1J6BIVlKSnv7LYv48qz7QN3CGNLGVDTGsjZVvqGrR/Q7ozPZUNJ3yVjkCYP
        gQO0PbIF5WDN6Pycvuhz0JGUIVqtG6hy4XI2tvOk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 4 Sep 2020 11:52:32 +0000
From:   Wen Gong <wgong@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Tova Mussai <tova.mussai@intel.com>,
        linux-wireless-owner@vger.kernel.org, ath11k@lists.infradead.org
Subject: Re: [PATCH v2 24/24] nl80211/cfg80211: support 6 GHz scanning
In-Reply-To: <20200528213443.1b4cb4ffc82b.I9d94ae093e08fb15b6c8f8fb7406b316778c6a5f@changeid>
References: <20200528213443.993f108e96ca.I0086ae42d672379380d04ac5effb2f3d5135731b@changeid>
 <20200528213443.1b4cb4ffc82b.I9d94ae093e08fb15b6c8f8fb7406b316778c6a5f@changeid>
Message-ID: <0101017458f60592-c5929631-8d22-4c20-908f-8bc02d85a84a-000000@us-west-2.amazonses.com>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2020.09.04-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-05-29 03:34, Johannes Berg wrote:
> From: Tova Mussai <tova.mussai@intel.com>
> 
> Support 6 GHz scanning, by
>  * a new scan flag to scan for colocated BSSes advertised
>    by (and found) APs on 2.4 & 5 GHz
>  * doing the necessary reduced neighbor report parsing for
>    this, to find them
>  * adding the ability to split the scan request in case the
>    device by itself cannot support this.
> 
> Also add some necessary bits in mac80211 to not break with
> these changes.
> 
> Signed-off-by: Tova Mussai <tova.mussai@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/cfg80211.h       |  29 ++-
>  include/uapi/linux/nl80211.h |   3 +
>  net/mac80211/scan.c          |   9 +-
>  net/wireless/core.c          |   4 +-
>  net/wireless/core.h          |   5 +-
>  net/wireless/nl80211.c       |  11 +-
>  net/wireless/scan.c          | 482 ++++++++++++++++++++++++++++++++++-
>  7 files changed, 527 insertions(+), 16 deletions(-)
...
Is this patch have interface for application such as iw, wpa_supplicant?
