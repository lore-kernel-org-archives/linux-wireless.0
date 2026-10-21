Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792605302;
	b=dxN4NEQ2gJu1uT/x/t1yyVRRU/YhmACQZiYrzRKiOXg48N/XyZ9M1oVl5+Ok921yeq0N
	 zYqz+odQHDDNUIvlCER70ZSrw+lcRtVFE4pFc+yTYBbFW5DUA0vGV8RbT+oCa4i25OlmZ
	 jRGSbxjHYDrHARwshL/j997+M184xVUx9d8iWC41Xy4F1l4JVL1uSb7F4HRN8j/yeV5kH
	 5dmVdSjfMAe4HFlorPNNSDvlJ/srPPkiNiEMMkxLVsU3isXYz7Vdvw/ne4f4pVagaDjw7
	 3XDibRXSG3erwq590iws0iGsdWEIdlK4u9uggrnsf2ea3LfWi7GM2D8JkLg5IT1vkew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605302;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:CC:Date:Message-ID:In-Reply-To:
	 References:User-Agent:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=gWh1QTQenprqzbn4sAjRMzDY/y3t0ccto3JdAdHhT4s=;
	b=tXQcwQQgHpkHLN7cU6F9TxorKmmGd9yx6b66dmA4b9mkhNCPnhs7dViE/G2hTsPN71fI
	 0alp47t2cSAF2IvSADQ7u0pb1wTo5toOjdtvqqtf2bj3deIhZR++uiKULY42BiuomkfB8
	 6nseVOsYH45nZH7H6nPN/lkkjxdp44UEDMPhcNBXYQWMMTYa8+KYWUF//vndzPPdmBpPR
	 dvopE/wvezalDa/76bHoA/CqvBZU4gGLmLR53bfoiRqADvSaiE8ezFJN7Qig62ibcuwwC
	 2CKvLXOteOJ3KY3pQQeUol1ogeJrw2yqG+Z5nHYo5Npm6P4WRRqC0TcqaJekjO1D/Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QuI3DJNl;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490BE606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 17:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 490BE606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QuI3DJNl
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-398b3c37877so720030a91.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605301; x=1793210101;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gWh1QTQenprqzbn4sAjRMzDY/y3t0ccto3JdAdHhT4s=;
        b=OBO0z9RgkAL39Sih27XsCZcd7iCQf1FPg1Kn1W34ZG4QZ5GvBVGVamTXXyxS/DEHfd
         dQqLnt/Sxrofa19JTxVgw0JEFOtq9dYQlrEX7O7WKtGzKQP2lUA9uoprW4JO6aOGbFUt
         D1AZciGO+4FKDLXm1n5/MxTraX8OS/zddTGjNXyqOWqT4Ybk36S1+7nPTR4d4CAuG7zi
         QZrX9ITYGFf1vJU9cQCrfYaVB0dpqTsG+Ig0JQm17NUvvOc1aMG1ACw8w7ns4beqdpoG
         NmHYYXydMj2qwmWAFguB4YsNHHt6a15FTKaJpeuc3OdR/RFTKigkgi5CbVSCE1ntoFNb
         52uQ==
X-Forwarded-Encrypted: i=1; AKwUvBx8v4qC6lNG2OvathEJjGfmqmZmaKVF0YzHHOYcmdo2CSCCCMkmM4g5ldLXracLiYno4MCKWPG6wbERvVIh6A==@vger.kernel.org
X-Gm-Message-State: AFq9FYL7CgLNIfocqer8P7RLGKYROXNYLX3fr+kSBZMpsBipwRzj9xLL
	ALNy3rTEAC0PCu8Y5CqpeWSAVmkxKs/fM0PKzvJPa4i+ZeQAfUTlEem8CTVtFIIt8uQt+9CF0eh
	VeSWjIqUwZmwvT/PonQG8ik6W04j+QMHKXMRM2eNk1ma9YURtQGUKKsHRKJe0Am46isMO0QORcf
	CQSg9DYutv4QGEvrNM/6Lwny0IG9MjOsn+Qygfw5Qg+h2DNuRK30P7gSQdGu2XIxj1q+EfSwYyh
	RzcN1wklwFW9cG0xGX+KOhW5iFz
X-Gm-Gg: AYBFou2g5uFm7T2Hv3Yk69UfQm0c9b2yWy9shesdzpDJT1LrGhrHQBu8DzsCRjmTsto
	pgS+UpBX901TrVQ1W5wpvkVvYa460bLVS7vm8yUClZNCSwqce6qp3Vn4zXtqXJTS78RKMs/4k0Z
	5AGw0IKlJZsnACIYA4e97ysDeJ6x9WXZmo1xyGIrZahZLftElWpXoMlUZZG1Mqtnq5nYYZ/sI+v
	2SOwgSIum8OEBc5EnhzH5JNQd0AhAP1umg1Hy7nLphO8IfgJgMg/sdilnYMwBYdJ8wA+T5R6m6D
	/8SjDAmVnP+a7jHEFxhFg+zPkOTmEgu7Ycc0AiZmp4WGqZW/RajXWTsC6pQUzMSAcPs26Igq4pt
	o36xZQZKLHw0WILw11WReuA+RHUH5ugDCFbRKYh31hkdWlmNxXtunn0jd0aD3iVF5ICpSYdE3QJ
	ZIoy50YLv1l0bo7bCpOBnbrtQR1j3mIzaucbCZ/Rc=
X-Received: by 2002:a17:90b:164c:b0:39e:59a0:46b5 with SMTP id 98e67ed59e1d1-3ad86ce7678mr2641785a91.24.1792605301319;
        Wed, 21 Oct 2026 10:55:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-17.dlp.protect.broadcom.com. [144.49.247.17])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ada48e6250sm208842a91.8.2026.10.21.10.55.00
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2026 10:55:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e0389d6f9so598516f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792605299; x=1793210099; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gWh1QTQenprqzbn4sAjRMzDY/y3t0ccto3JdAdHhT4s=;
        b=QuI3DJNl7NrQMocDzM8j8JuCFUt6gmHEX0Gd3zYnpKfbNr0DVcCTYJibUgT11Op4bP
         dBI10QEtuu127d8tf6GM2HCN5OfOYzMUmkqqiJmWXyV4Esgre6Uvju1NfjW9LltEi4Pe
         Dq3RKgGHtOOHFB/YZ9ikVe08j8X1A/C/NAuAE=
X-Forwarded-Encrypted: i=1; AKwUvBwoxzoYmNHivakbgvYLIegI++QThmKhzCmpVzmyurNuJm30n2PqFw/lIFLjeaXFIl/SmQnIq9VZTOdQYn3Lqw==@vger.kernel.org
X-Received: by 2002:adf:e009:0:20b0:48e:cd3:64ee with SMTP id ffacd0b85a97d-48e264ca114mr4341026f8f.18.1792605299434;
        Wed, 21 Oct 2026 10:54:59 -0700 (PDT)
X-Received: by 2002:adf:e009:0:20b0:48e:cd3:64ee with SMTP id ffacd0b85a97d-48e264ca114mr4340994f8f.18.1792605299030;
        Wed, 21 Oct 2026 10:54:59 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828cd1sm6791359f8f.22.2026.10.21.10.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 10:54:58 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Aditya Garg <aditya.garg@linux.dev>, Johannes Berg <johannes@sipsolutions.net>
CC: <iommu@lists.linux.dev>, Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <linux-wireless@vger.kernel.org>, Jason Perlow <jperlow@gmail.com>
Date: Wed, 21 Oct 2026 19:54:57 +0200
Message-ID: <1a15f9a1968.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20261021172238.10004-1-aditya.garg@linux.dev>
References: <20261021172238.10004-1-aditya.garg@linux.dev>
User-Agent: AquaMail/2.7.0 (build: 200700061)
Subject: Re: [PATCH] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 21 oktober 2026 19:23:05 schreef Aditya Garg <aditya.garg@linux.dev>:

> From: Jason Perlow <jperlow@gmail.com>
>
> Commit f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf
> packet IDs") maps the RX packet ID buffers DMA_FROM_DEVICE. The
> BCM4364 firmware also reads posted RX buffers, so with VT-d
> translation enabled every such read faults ("PTE Read access is not
> set") and the firmware crashes and resets in a loop.
>
> Map the RX pool DMA_BIDIRECTIONAL again, as before that commit. TX
> keeps DMA_TO_DEVICE.
>
> Fixes: f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf packet IDs")
> Cc: stable@vger.kernel.org

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Jason Perlow <jperlow@gmail.com>
> Signed-off-by: Aditya Garg <aditya.garg@linux.dev>
> ---
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)



