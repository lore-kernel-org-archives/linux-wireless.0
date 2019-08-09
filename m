Return-Path: <SRS0=3RVz=WF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF511C433FF
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Aug 2019 23:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A59F82086A
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Aug 2019 23:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dFinRMHm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dFinRMHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfHIXXS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Aug 2019 19:23:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55702 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHIXXS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Aug 2019 19:23:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 97A786074F; Fri,  9 Aug 2019 23:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565392997;
        bh=Z/uToZHand0AZYw/yT7Itox+SNXuy+UT3stslmnahKg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dFinRMHmePSY/ESAaBDE5a3sS14GwXaLunluxLRoj2F1zHaeTQiHEQr1YZKwCiDde
         +vMpVVRKkdtEjCZUMRqW2ZqJWafkNCJrST3NhN60N0WsPqltA36Ocl2c2i0Z13oj5P
         KMnT+gqvyQVEKyHBULwG6hwra4JQGz5748UWeGZ8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0FB5360128;
        Fri,  9 Aug 2019 23:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565392997;
        bh=Z/uToZHand0AZYw/yT7Itox+SNXuy+UT3stslmnahKg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dFinRMHmePSY/ESAaBDE5a3sS14GwXaLunluxLRoj2F1zHaeTQiHEQr1YZKwCiDde
         +vMpVVRKkdtEjCZUMRqW2ZqJWafkNCJrST3NhN60N0WsPqltA36Ocl2c2i0Z13oj5P
         KMnT+gqvyQVEKyHBULwG6hwra4JQGz5748UWeGZ8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 09 Aug 2019 16:23:16 -0700
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     John Crispin <john@phrozen.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Subject: Re: [PATCH 6/6] ath11k: switch to using ieee80211_tx_status_ext()
In-Reply-To: <20190714154419.11854-7-john@phrozen.org>
References: <20190714154419.11854-1-john@phrozen.org>
 <20190714154419.11854-7-john@phrozen.org>
Message-ID: <2dc32161ae3cf25deae0542c72941dc4@codeaurora.org>
X-Sender: pradeepc@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> @@ -431,12 +434,18 @@ static void ath11k_dp_tx_complete_msdu(struct 
> ath11k *ar,
> -	ieee80211_tx_status(ar->hw, msdu);
> +	spin_lock_bh(&ab->data_lock);
> +	peer = ath11k_peer_find_by_id(ab, ts->peer_id);
> +	arsta = (struct ath11k_sta *)peer->sta->drv_priv;
Hi John,

Accesing sta when peer is deleted is causing null pointer dereference 
issue.

Thanks
Pradeep
