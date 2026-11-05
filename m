Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793865329;
	b=TCH+mJAMmKAab1weFL69ReowWbvRZtBEQ9HC+wFpDYdmo6JIa7LxKNs7wTQ9ToZw4IVZ
	 1L9HX1CQi89zdji5hV6zH/03od3L+38rIm+Aht6LUtFk9h4PykQ5pu29c/tsAAZ6byzhQ
	 hHdVEjQxtZCf3xrq78mEZzOAIyKnL4V3fGz8QTuqfzbtnCIYDXL7wGN8MxRqp6sZWShHe
	 9j09BFLBUUJ48siHr9a8p09N6GawjOX7JTfVBtTL0XNu/sR5hpo4z1EtFPxuV/aH+P1+S
	 7RV9jiHdYYKxMZp6Me7/2zUxiqEfaD6wqXdDT8znQ7ORyjcKF63kJyZ5FdWIMYrOd+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865329;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=mmARHlsIGfzhWBrHs5uyp7YjbJRvxLskZHt57iWd4Nc=;
	b=gw5jZTRqJibXHiRRX+ro98zVz6c/2gA5UTa+Jchkvwwhn/Rg43WESSvqRV3ANWFi320r
	 iQeiuLOSkywOtcykUTBM6sK0jgatSan4qyUCeRBDrZL7N3uxsVNsHy8xtXyeM6pPUooZ8
	 bCyBCiA/A4qNKvfpWUg+g/vrAtkphJpd99Or/RaRSTE4vxv4LoBSGZYD3HWv9ytcFwt35
	 1TEVo/kUsLB8KDr7hwrz/CUUJMlCQc8kAQd3M2Q/m5TSe5BCM03ZcB6hZAA0rUx9voAQL
	 e5Wrg+uq94JZPb05IkRShqOjeQa60OTYl2UU7x2RlQupZWcq3Mf0GVgRjDRkoR5V4pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=Vfbu1lae;
	arc=none smtp.remote-ip=212.77.101.9
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A2606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF5A2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=Vfbu1lae
Received: (wp-smtpd smtp.wp.pl 20316 invoked from network); 5 Nov 2026 08:55:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793865320; bh=mmARHlsIGfzhWBrHs5uyp7YjbJRvxLskZHt57iWd4Nc=;
          h=From:To:Cc:Subject;
          b=Vfbu1laeYrFbQ+YPz3gZ65pZnp5dKfZ41gKugMaQgxoXvveOFRzs3CAfzqqFYw7rW
           B4k72DAcz4CuPyrRJzoNZ2WSsUT3mzVbFhxJPH7MSOM596xOmXrg/sbwJJmwq0ei+1
           CE7U1TOrg9dvDzbWPmt2oOqwMIOOHPCstbWUs3rhqljlh0Uw18rue2nifqWm98dn/w
           FS+M/Wrybq4sc+ZAT43SDw5thUG4pIEU37fefffuILdE5/yuLxSioAFJERUPX6tswT
           1QgFaWZUG+wz67W1TTGDpFM8HVUj7SDZzA+trAPSKKURIP2VsWTLUtgX7klSupAd3z
           kLmuqWsMBe6ug==
Received: from localhost (77-236-11-168.static.play.pl [77.236.11.168])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 5 Nov 2026 08:55:20 +0100
Date: Thu, 5 Nov 2026 08:55:19 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 5/7] wifi: rt2800: support A-MSDU in
 A-MPDU
Message-ID: <20261105075519.GE64923@wp.pl>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
 <20261031165117.2868671-6-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031165117.2868671-6-hjf3108@gmail.com>
X-WP-MailID: 90887f92947aa644a390cd2f533f82ea
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [wdM0]                               

On Sun, Nov 01, 2026 at 12:51:12AM +0800, Ho Jie Feng wrote:
> Set SUPPORTS_AMSDU_IN_AMPDU, which can increase throughput.

Did you verify this works ? 

Regards
Stanislaw

> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 1301bc24d9413..83d349a238428 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -11861,6 +11861,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
>  	ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
> +	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_AMSDU_IN_AMPDU);
>  
>  	/*
>  	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
> -- 
> 2.53.0
> 
