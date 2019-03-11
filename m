Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE7AC10F06
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9249222EB
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfCKNbG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:31:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfCKNbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:31:03 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A5AD3091782;
        Mon, 11 Mar 2019 13:31:03 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1F441001E69;
        Mon, 11 Mar 2019 13:31:00 +0000 (UTC)
Date:   Mon, 11 Mar 2019 14:30:59 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH 1/4] mt76: move mt76x02_insert_hdr_pad in mt76-core module
Message-ID: <20190311133058.GC6089@redhat.com>
References: <cover.1552306908.git.lorenzo@kernel.org>
 <0ec618f40f6308f4da8c6a766519dfd66fa5ad57.1552306908.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ec618f40f6308f4da8c6a766519dfd66fa5ad57.1552306908.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 11 Mar 2019 13:31:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 01:35:23PM +0100, Lorenzo Bianconi wrote:
> +static inline int mt76_insert_hdr_pad(struct sk_buff *skb)
> +{
> +	int len = ieee80211_get_hdrlen_from_skb(skb);
> +
> +	if (len % 4 == 0)
> +		return 0;
> +
> +	skb_push(skb, 2);
> +	memmove(skb->data, skb->data + 2, len);
> +
> +	skb->data[len] = 0;
> +	skb->data[len + 1] = 0;
> +	return 2;
> +}
<snip>
> @@ -165,7 +165,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
>  	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
>  	txwi->pktid = pid;
>  
> -	ret = mt76x02_insert_hdr_pad(skb);
> +	ret = mt76_insert_hdr_pad(skb);
>  	if (ret < 0)
>  		return ret;

Since you modify this you can make mt76_inser_hdr_pad() return
void since we do not return error any longer.

Stanislaw
