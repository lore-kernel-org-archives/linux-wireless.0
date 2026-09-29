Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D30A36195B
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 19:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790709101; cv=none; b=BK1WxhgtOqAFkaHoNoI3b8J5WjDbVAyrcLbaZ1E2iwDuohC6FRZrBMMMM7b9J6zYmx2UJ9Hxd6KWx44/4xNB9tfk7gV9NGc30rLTVYHm8SGL3KptE228XN5vRXJ4vsVz9P/r0TbXvgPN4ucngz/aCFMBHKXL3SwsvROT/UjFVy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790709101; c=relaxed/simple;
	bh=JfVPwfuojVZMZlRIrq/IrnSUzs93t53tkFi/otplTA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFqX+2Rng3x99oBFD7i7EqEkuUq2uweP2x1A7nCHc93/fqcQovAN8e0Hj0aimJmY7NmFqfWZAjsh115LdwD2ohZ1clIGPIYb9E/jyO3WvRtdYDDGNQzhqD7iL7LEWEgI59WVp2fKcQC44A2Ph8LLrhKZfHS4dcM4FLPDbBez5WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QXzeglYC; arc=none smtp.client-ip=91.218.175.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QXzeglYC"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JfVPwfuojVZMZlRIrq/IrnSUzs93t53tkFi/otplTA0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790709097; v=1; x=1791313897;
 b=QXzeglYCDJNMJJNUY3qmqsWhJAJzmkoAuSJGv4/MeMjbn+2RqsMcmpjNJSfX3PqETnjmvxoy
 Ce6BXrXX0I9c9lsPZTMRcN1FJHxsVZl9kw6KM2lTYzSvBVGMnMW7T0gsgp+n3tqfjBC/BFZNE20
 8s/qzqUnTLB6l2Rv21Rhwn0Q=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a126e1739c00e298;
	Tue, 29 Sep 2026 19:11:37 +0000
X-Mizu-Trace-ID: a126e1739c00e298
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com,
	Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH rtw-next 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Tue, 29 Sep 2026 19:11:36 +0000
Message-ID: <20260929191136.1315-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929124400.3856049-2-mehmet.fide@gmail.com>
References: <20260929124400.3856049-2-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026, Mehmet Fide wrote:

> Besides the extra work, every beacon fetch advances the DTIM count and,
> while a channel switch is announced, the CSA countdown; doing it twice
> per update lets a countdown that starts at 2 reach 0, which mac80211
> warns about. Keep the beacon skb from the page build and download that.
[...]
> @@ -1744,25 +1745,25 @@ static int rtw_download_beacon(struct rtw_dev *rtwdev)
>  		return -EINVAL;
>  	}
>  
> -	skb = rtw_get_rsvd_page_skb(hw, rsvd_pkt);
> +	/* the beacon kept by rtw_build_rsvd_page() */
> +	skb = rsvd_pkt->skb;
>  	if (!skb) {
>  		rtw_err(rtwdev, "failed to get beacon skb\n");
> -		return -ENOMEM;
> +		return -ENOENT;
>  	}
>  
>  	ret = rtw_download_drv_rsvd_page(rtwdev, skb->data, skb->len);
>  	if (ret)
>  		rtw_err(rtwdev, "failed to download drv rsvd page\n");
>  
> -	dev_kfree_skb(skb);
> -
>  	return ret;
>  }
>  
[...]
> @@ -1791,6 +1792,12 @@ int rtw_fw_download_rsvd_page(struct rtw_dev *rtwdev)
>  free:
>  	kfree(buf);
>  
> +	/* free the beacon kept by rtw_build_rsvd_page() */
> +	rsvd_pkt = list_first_entry(&rtwdev->rsvd_page_list,
> +				    struct rtw_rsvd_page, build_list);
> +	kfree_skb(rsvd_pkt->skb);
> +	rsvd_pkt->skb = NULL;
> +
>  	return ret;
>  }

This breaks hardware scan offload while an AP is active.

rtw_download_beacon() no longer fetches a beacon of its own. It reads
rsvd_pkt->skb, and rtw_fw_download_rsvd_page() clears that skb right
before it returns:

	if (rtwdev->ap_active) {
		ret = rtw_download_beacon(rtwdev);
		if (ret)
			rtw_err(rtwdev, "HW scan download beacon failed\n");
	}

rtw_hw_scan_offload() takes that branch without building a reserved page
first, so nothing repopulates the skb. Since the store has already run from
BSS_CHANGED_BEACON when the AP started, rsvd_pkt->skb is NULL by the time a
scan begins and rtw_download_beacon() returns -ENOENT:

	skb = rsvd_pkt->skb;
	if (!skb) {
		rtw_err(rtwdev, "failed to get beacon skb\n");
		return -ENOENT;
	}

rtw_ops_hw_scan() then treats the error as a failed scan and aborts it.

Before this patch the scan path worked because rtw_download_beacon() called
rtw_get_rsvd_page_skb() itself.

Could the scan path fetch its own beacon, or could the retained skb be
released only after the standalone download, with care taken to not
advance the CSA countdown twice?

Best regards,
Luka Gejak
