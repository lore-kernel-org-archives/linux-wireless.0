Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75244456DE6
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 07:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790839026; cv=none; b=UNfQInouCJ9cFOrjimCePwv9C0ymMjzzzPxY3mtjqmQpHx6QVL05VBS/cWw3UR0lvspd/nr1oQOZL36LmwjI69PdCOxYTeFgpfFeCbqCkQ4myQL0t1KeNC81llxGi+qlmYSpFyNTiURP2DYNBVLTnvGT4H+s7DQich1Cj1toJpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790839026; c=relaxed/simple;
	bh=5ONaKtwCsrMAYKtTppGb6lZliXkZCnHoiIE1DiweM7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3Ewu+Bg+gVsPV/aPVcn2JM9M/nLeodjdHRyMXTQ1ArWJXZLyTnJed2R1p/q9H5pD1XekknV42exBV7Slyt05hZ1MhjBiWY10DEfADlpWmVDtF1atFd6uSpyXBChkeSJyLLDY3f1BU+VUSJSonZog/lSjzOkGonIGAVG0NyrOaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xnPLPcVv; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xnPLPcVv"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5ONaKtwCsrMAYKtTppGb6lZliXkZCnHoiIE1DiweM7E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790839017; v=1; x=1791443817;
 b=xnPLPcVvkM56kZs3RvkiNT5oDc7n2xAfRaCzEBXGuDWqRC1PbsZrBtD3vaYEzEvO3SP/refR
 LVPCtnp7G86hNcPJ1gXMg/AKFR4tt7F4wvEPC2goKla0urDZVG3Lop4gCgQ2WIvBVLqgo2OrWFv
 wkfBNwj741YPPVWeRzYDiu90=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a18b7bcd28f59343;
	Thu, 01 Oct 2026 07:16:57 +0000
X-Mizu-Trace-ID: a18b7bcd28f59343
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	mehmet.fide@screeningeagle.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH v2 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Thu,  1 Oct 2026 07:16:56 +0000
Message-ID: <20261001071656.16499-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930074444.1991223-2-mehmet.fide@gmail.com>
References: <20260930074444.1991223-2-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026, Mehmet Fide wrote:

> -		if (page == 0)
> +		if (page == 0) {
>  			page += rtw_len_to_page(rsvd_pkt->skb->len +
>  						                  tx_desc_sz, page_size);
> +			/* the caller downloads it once more on its own */
> +			*beacon = rsvd_pkt->skb;
> +		} else {
[...]
>   free:
> +	dev_kfree_skb(beacon);
>  	kfree(buf);

beacon is written in that branch only, and the caller declares it without an
initialiser while the free at the end frees whatever it holds. The first page
always takes that branch today, but the caller cannot see that, so a later
change in the build would free a stack value. Would you mind initialising it to
NULL?

> @@ -2345,7 +2353,7 @@ int rtw_hw_scan_offload(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
>  out:
>  	if (rtwdev->ap_active) {
> -		ret = rtw_download_beacon(rtwdev);
> +		ret = rtw_download_beacon(rtwdev, NULL);
>  		if (ret)
>  			rtw_err(rtwdev, "HW scan download beacon failed\n");

The cover says this path is compile tested only. The feature comes from the
firmware header rather than from the chip:

	fw->feature = feature & FW_FEATURE_SIG ? feature : 0;

so another firmware for the same hardware can reach it, and this is the path
that v1 got wrong. Can it be run once on a device whose firmware has scan
offload?

Best regards,
Luka Gejak
