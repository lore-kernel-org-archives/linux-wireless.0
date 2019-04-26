Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66325C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455902077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfDZHqi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfDZHqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 03:46:37 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11BC180F83;
        Fri, 26 Apr 2019 07:46:37 +0000 (UTC)
Received: from localhost (unknown [10.40.205.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A31D5D71A;
        Fri, 26 Apr 2019 07:46:34 +0000 (UTC)
Date:   Fri, 26 Apr 2019 09:46:33 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Roy Luo <royluo@google.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: fix endianness sparse warnings
Message-ID: <20190426074632.GA3568@redhat.com>
References: <865a5eb36f295fc81e3dcbe95929dcfce4956897.1556203212.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865a5eb36f295fc81e3dcbe95929dcfce4956897.1556203212.git.ryder.lee@mediatek.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 26 Apr 2019 07:46:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 25, 2019 at 10:42:01PM +0800, Ryder Lee wrote:
> Fix many warnings with incorrect endian assumptions.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7603/mac.c |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> index 2f2961ee0a92..af5769d05e6f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> @@ -627,7 +627,7 @@ mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb)
>  	status->aggr = unicast &&
>  		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
>  	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
> -	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
> +	status->seqno = IEEE80211_SEQ_TO_SN(__le16_to_cpu(hdr->seq_ctrl));
>  
>  	return 0;
>  }
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> index 1bf3e7b5f6a7..4b934b0f5a39 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> @@ -235,7 +235,7 @@ int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
>  	status->aggr = unicast &&
>  		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
>  	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
> -	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
> +	status->seqno = IEEE80211_SEQ_TO_SN(__le16_to_cpu(hdr->seq_ctrl));

Is there any reason to use underscored version instead of standard le16_to_cpu() ?

Stanislaw
