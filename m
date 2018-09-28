Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73350C43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 22:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22B61206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 22:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RWr+qs1s";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NI6dYJF0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22B61206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbeI2Ex0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 00:53:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbeI2Ex0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 00:53:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0682A60214; Fri, 28 Sep 2018 22:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538173656;
        bh=PwTcjj4pJ1fEAyVnVH7sFrSiwbFJ3aFcis2Obwh24mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RWr+qs1sXBKG8yg/yIM70qt5icqPmz2oGVWKPwFS8WgbBwo1zd6WzuGBYqdDvi4CW
         8+rVeWFV0THsYoQcSy82VAF7wRHwSB7ek0+L8wkpLYAcyWcHv4vGOoc9eNFaOPb0qH
         JgumAiBbphvW0imvYkA9BEu/+zU+IeH9adqOC9AI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 9D97660128;
        Fri, 28 Sep 2018 22:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538173655;
        bh=PwTcjj4pJ1fEAyVnVH7sFrSiwbFJ3aFcis2Obwh24mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NI6dYJF0xT5XLGG3SANfheBt/CYly8hqPhkGxKddD0uQGsAfEBCgzGV6bZ52YK/ph
         PY75zB5ybr88VHTUEznUyP0jyF1lpvclSynoj/h1kl7cioKhNjcRQUz4rRUXdJg/BL
         UkIjorrzOVsUB7sgrny6RKU9/u7Lw9oub2wUorI8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 28 Sep 2018 15:27:35 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rg?= =?UTF-8?Q?ensen?= 
        <toke@toke.dk>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 1/2] ath10k: migrate to mac80211 txq scheduling
In-Reply-To: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
References: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
Message-ID: <2548421a777c2223b5b31459222fe1e1@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-26 17:41, Rajkumar Manoharan wrote:
> @@ -4293,32 +4281,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw 
> *hw,
>  static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
>  					struct ieee80211_txq *txq)
>  {
> -	struct ath10k *ar = hw->priv;
> -	struct ath10k_txq *artxq = (void *)txq->drv_priv;
> -	struct ieee80211_txq *f_txq;
> -	struct ath10k_txq *f_artxq;
> -	int ret = 0;
> -	int max = HTC_HOST_MAX_MSG_PER_TX_BUNDLE;
> -
> -	spin_lock_bh(&ar->txqs_lock);
> -	if (list_empty(&artxq->list))
> -		list_add_tail(&artxq->list, &ar->txqs);
> -
> -	f_artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
> -	f_txq = container_of((void *)f_artxq, struct ieee80211_txq, 
> drv_priv);
> -	list_del_init(&f_artxq->list);
> -
> -	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
> -		ret = ath10k_mac_tx_push_txq(hw, f_txq);
> -		if (ret < 0)
> -			break;
> -	}
> -	if (ret != -ENOENT)
> -		list_add_tail(&f_artxq->list, &ar->txqs);
> -	spin_unlock_bh(&ar->txqs_lock);
> -
> -	ath10k_htt_tx_txq_update(hw, f_txq);
> -	ath10k_htt_tx_txq_update(hw, txq);
> +	ath10k_mac_schedule_txq(hw, txq->ac);
>  }
> 
With below change I were able to fix the performance impact in 
multiclient scenario.
Will fold them in next version.

diff --git a/drivers/net/wireless/ath/ath10k/mac.c 
b/drivers/net/wireless/ath/ath10k/mac.c
index 6da64412cc14..965aaa731f04 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4473,7 +4473,26 @@ static void ath10k_mac_op_tx(struct ieee80211_hw 
*hw,
  static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
                                         struct ieee80211_txq *txq)
  {
-       ath10k_mac_schedule_txq(hw, txq->ac);
+       u8 ac = txq->ac;
+       int ret = 0;
+
+       ieee80211_txq_schedule_start(hw, ac);
+       txq = ieee80211_next_txq(hw, ac);
+       ieee80211_txq_schedule_end(hw, ac);
+       if (!txq)
+               return;
+
+       while (ath10k_mac_tx_can_push(hw, txq)) {
+               ret = ath10k_mac_tx_push_txq(hw, txq);
+               if (ret < 0)
+                       break;
+       }
+       if (ret == -EBUSY) {
+               ieee80211_txq_schedule_start(hw, ac);
+               ieee80211_return_txq(hw, txq);
+               ieee80211_txq_schedule_end(hw, ac);
+       }
+       ath10k_htt_tx_txq_update(hw, txq);
  }

-Rajkumar
