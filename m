Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A01AC2F441
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 16:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A0B220663
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 16:51:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="MYFAuSqL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbfAUQvr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 11:51:47 -0500
Received: from mail.toke.dk ([52.28.52.200]:45837 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbfAUQvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 11:51:46 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1548089505; bh=KQ/tcdtTr7DtI1/bxd8J/JVBRZ35X46rbjowDG2uFIA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MYFAuSqLEF0Yi5a6qqOGU+MbAQUi9LHQhsoQ9dNokKQhpMaGguJYyGgDVWFi1ZBeQ
         pB5stgycOnJ/KXVj7fKSZX+7DikXMR0QN/sff4T4hzh9uVFL3B1uqBjrh8FedhpYKs
         utzdIT0Wma8Kkg26xI0pSt/752xjdoxGcrxfKgv2WzrCbLusgVf+ludOeUVmO/cwV5
         gHc7xIWOl8VikaHiolhNj5q3FS0uo6RxTeAb+Z36KvpHZgV97otWfcj39KuH261mjv
         4/Smh4E8XUAZnj9q50OZbJRDlMp0Dp7RHONgEJZPlYVRK6CaOxY7bwROV4FsXovECR
         0EKKnCVbcpeBQ==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH v5 4/6] ath9k: Switch to mac80211 TXQ scheduling and airtime APIs
In-Reply-To: <1545181331-5288-5-git-send-email-rmanohar@codeaurora.org>
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org> <1545181331-5288-5-git-send-email-rmanohar@codeaurora.org>
Date:   Mon, 21 Jan 2019 17:51:44 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pnsqkl7j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Just discovered this while working on my follow-up:

>  void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
>  {
> -	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
> -	struct ath_chanctx *ctx = avp->chanctx;
> -	struct ath_acq *acq;
> +	struct ieee80211_txq *queue =
> +		container_of((void *)tid, struct ieee80211_txq, drv_priv);
>  
> -	if (!ctx || !list_empty(&tid->list))
> -		return;
> -
> -	acq = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
> -	spin_lock_bh(&acq->lock);
> -	__ath_tx_queue_tid(sc, tid);
> -	spin_unlock_bh(&acq->lock);
> +	ieee80211_return_txq(sc->hw, queue);
>  }

After we evolved the API, this is now wrong, as ieee80211_return_txq()
should only be called while holding the right lock. I'll post a fixed
version tomorrow.

-Toke
