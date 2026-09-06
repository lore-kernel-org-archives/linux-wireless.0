Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6132C026C
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 10:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788691458; cv=none; b=SNMyqq31DIc5YtwvESywyjuuCiHj7vxK+h2hD1nM8YwKa/N8JQpZFEfa3qQ3iDup3O1fMspfMxMSgjLS/OKTHjNmFLm5mDst6Rgt/nVWuqGiZkFK6uawjFIDeVu+gX1ydGnscPtxfXGMNr7D9P2YaiSWWCtqOPqzLUsZqw/K3Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788691458; c=relaxed/simple;
	bh=Zxbr/MyJJe9YJZaEM1Cq3zqovEChybWZAlK04d4Du2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jy6j5rvKdU6mHJsg9Jplz+zsa75T5+Thy0rFbG9QcIP9ARRk3NfnAvm7nE4YuGpQgJuQEBOjrhCWVkL6KQv3NHtYf4qa1agUfF7nd0ZA58FPLUEOVB4h2Ki4FINfvfKo6CvlAyym6jQqgu0dV/xN3sOVvf6ANtMzQhYAVQTJhf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evFPVG3w; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evFPVG3w"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48436216a98so1602373f8f.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 03:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788691454; x=1789296254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x0/+wqBmIy7IfhisO1aQJ97wf2sAIX1/xLpRpUIc4gE=;
        b=evFPVG3wQ+UFQ8w7g9579d+7c01ZdLhq53tSB/Gto78WGim0KF3pAxMUYyIVCVYvWO
         rj+dWQbkRUl+CI591LjrDZNDPza5PLVyshElm+pui0SlZtHYYeVajF7R6AJwCeXJqduc
         x34HiLN65nUuto1jqMuN91OlvyMhpHgoBV5jHuFtwF2WtOAihnAAHhrlJXwiyn3Vs8ps
         P6BioTUdeKYhZudBvvpOGGpLYpVUUfiTy3suK60FyzKPw9CCn3H4vk/jCQyVMSxhWeqj
         ToThq2bbQC59nS8/qVzhAgdGBBh2UXQi92Ke2GNU1GO+h4kSQgLnJsowFUHxQIZbhGHC
         L+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788691454; x=1789296254;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x0/+wqBmIy7IfhisO1aQJ97wf2sAIX1/xLpRpUIc4gE=;
        b=leL7HwsBidMC2+JQqqVlit5g7EZNKNwWR8Q9jkGFc5zcuMxu1mRUIUziui3CBc2qX4
         TXenlEp537TtrlYitBVw/eRYPM/HBY5yV0Whdag32QuX0rAFf/tWZa5SYYxAO4+CuWm7
         kejygN5Kp0dPFdXEcg5mXFFTpIW82ZcltXSfPz6lFHwuPY+S7mjayXsa6u2TIl9fEdFO
         h7Ugw2f0PVRYFvAdHKlDNjfYhV6pLWET9O151Dlmo1YKcr6PaiFm4YmqDM126cUo8kKd
         7kpeqjvKLOgwZdjBi4t7qVHj9FYT2AvCqAQ95zbneOPcmC28IxDaK8+/L1GpMxzPsVrM
         MghQ==
X-Forwarded-Encrypted: i=1; AKwUvBzMsf5w0S7DY2Q/El3PLag4LRzMkVyLiQK4N0HHDm/2wyIZSLjPn8s7DmQBc3tHBtTsVjVBn8+yhdCogDJOUQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mhsxKcZzDq8cSkGhkJ0d8tX1oCrDOKjQOnev90Uxb/l4QrfATO
	f7xhedpTR3tRD0uHACQr4Sikp+xVTXW/NM0zB7SFKWX/Rbj/5zAAIPsI
X-Gm-Gg: AYBFou214LChf8EsH8Il2EwXL29DV1nt+Y20QvPf3U4gpix3wP1bQTVdw0Z5u1ihtew
	mEfuvDpLwXNXdKgeQ+LlwUOa98Rs2YKceof2EyaW1eUyeXVjX3YBVAgmWA66NDfNg1yBoFrbqJH
	JOvlixqMvSCeTsl5VUqlFG9CPlJv1Deb7eWgRXavZTfPVlXMufDRCpeGIOkvjzJlgeCVPUNPnzz
	vG2M0G79HvMvhDNsXhyJ9F30JSCYPB2qCXyemiciGZ9nd0EG5zK5QkWgF1mG0nYOhtVdsWLB91e
	eTat12OaV2pUpTtg6qBXtYWJoqiLrT24lZyrzEzEBJ32Fs4By7chZKDIDecmoSPKee5RSO5uNru
	OqplIamrKwrUEs502p97vOIO1AQIrLEM5zqO+FJOFWlTDgQ3KXMgaZiDNjeURbJ29y0O0BAJOiE
	XiTajuQteUVNWYctb+liOVMOFMvQFA2RQyh1oOihuDldSrkaWAV7ZXq2M2DzLii9pCmOIYgV1bv
	YZxGt2GjjXfNBFOufBX4AdgCIXrWKS4wamgZCSMe2nS/hiiKp74F+Oi7tH6iTcQA/k=
X-Received: by 2002:a05:6000:2c0a:b0:482:d94e:f33b with SMTP id ffacd0b85a97d-48586e2ea8cmr18284958f8f.0.1788691454427;
        Sun, 06 Sep 2026 03:44:14 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883be709sm21162225f8f.21.2026.09.06.03.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 03:44:13 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x3AM8-000000007UR-3W69;
	Sun, 06 Sep 2026 12:44:12 +0200
Message-ID: <d739eb56-b37d-4056-abf2-c3a4c9ba8662@gmail.com>
Date: Sun, 6 Sep 2026 12:44:12 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: fix typos in comments
To: Hemanth Selam <hemanth.selam@gmail.com>,
 Jeff Johnson <jjohnson@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
 Nick Kossifidis <mickflemm@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Arend van Spriel <arend.vanspriel@broadcom.com>,
 Stanislav Yakovlev <stas.yakovlev@gmail.com>,
 Stanislaw Gruszka <stf_xl@wp.pl>, Michael Buesch <m@bues.ch>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 b43-dev@lists.infradead.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, libertas-dev@lists.infradead.org
References: <20260904124353.6183-1-hemanth.selam@gmail.com>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260904124353.6183-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/26 2:43 PM, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Sure, for the p54 and carl9170 parts:

Acked-by: Christian Lamparter <chunkeey@gmail.com>

Does anyone know what ever happened to the trivial-patches?
https://www.kernel.org/pub/linux/kernel/people//rusty/trivial/template-index.html
Is this still going?

> ---
>   drivers/net/wireless/ath/carl9170/fwcmd.h                 | 2 +-
>   drivers/net/wireless/ath/carl9170/main.c                  | 8 ++++----
>   drivers/net/wireless/broadcom/b43/b43.h                   | 8 ++++----
>   drivers/net/wireless/intersil/p54/p54pci.c                | 2 +-
> 
> diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
> index e5bcc364f088..40554e4bd149 100644
> --- a/drivers/net/wireless/ath/carl9170/fwcmd.h
> +++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
> @@ -69,7 +69,7 @@ enum carl9170_cmd_oids {
>   	CARL9170_CMD_FREQ_START		= 0x23,
>   	CARL9170_CMD_PSM		= 0x24,
>   
> -	/* Asychronous command flag */
> +	/* Asynchronous command flag */
>   	CARL9170_CMD_ASYNC_FLAG		= 0x40,
>   	CARL9170_CMD_WREG_ASYNC		= (CARL9170_CMD_WREG |
>   					   CARL9170_CMD_ASYNC_FLAG),
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index 61c7a1288743..21d8798dedb5 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -575,7 +575,7 @@ static int carl9170_init_interface(struct ar9170 *ar,
>   	 * NOTE: If the previous main interface has already
>   	 * disabled hw crypto offload, we have to keep this
>   	 * previous disable_offload setting as it was.
> -	 * Altough ideally, we should notify mac80211 and tell
> +	 * Although ideally, we should notify mac80211 and tell
>   	 * it to forget about any HW crypto offload for now.
>   	 */
>   	ar->disable_offload |= ((vif->type != NL80211_IFTYPE_STATION) &&
> @@ -677,12 +677,12 @@ static int carl9170_op_add_interface(struct ieee80211_hw *hw,
>   	if (old_main) {
>   		/* We end up in here, if the main interface is being replaced.
>   		 * Put the new main interface at the HEAD of the list and the
> -		 * previous inteface will automatically become second in line.
> +		 * previous interface will automatically become second in line.
>   		 */
>   		list_add_rcu(&vif_priv->list, &ar->vif_list);
>   	} else {
> -		/* Add new inteface. If the list is empty, it will become the
> -		 * main inteface, otherwise it will be slave.
> +		/* Add new interface. If the list is empty, it will become the
> +		 * main interface, otherwise it will be slave.
>   		 */
>   		list_add_tail_rcu(&vif_priv->list, &ar->vif_list);
>   	}
> diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
> index 6588f5477762..68e929fa213c 100644
> --- a/drivers/net/wireless/intersil/p54/p54pci.c
> +++ b/drivers/net/wireless/intersil/p54/p54pci.c
> @@ -534,7 +534,7 @@ static void p54p_firmware_step2(const struct firmware *fw,
>   		/*
>   		 * This will indirectly result in a call to p54p_remove.
>   		 * Hence, we don't need to bother with freeing any
> -		 * allocated ressources at all.
> +		 * allocated resources at all.
>   		 */
>   		device_release_driver(&pdev->dev);
>   
