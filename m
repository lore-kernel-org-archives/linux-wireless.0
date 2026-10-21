Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602252;
	b=fUTOebK+eB97+mCAYBZpU7JwKzK1Z5gRe6UIFMIH+zHV1Eu2lacsZPWvS6otmFiw8VuO
	 hzsFzn1HQ4SKuEIOQIj8D0kF1sOdEy6C1UlBlhh47bYWf0wPXQ3XAUYyNSgyajzbXKG26
	 TVuZxFKvhyC56QeKouKwNQVMcCaCsmiSfEa+9l7S2WF23WM3+v38W7hNZYvHntdNNraha
	 YQdbt0CyxO1V1k8dQhxiLDbqne9eN9BZIWCvUYDKAxPitOQvZlY3XkNgF/lJI2oQUspAq
	 S5Kr5w2u6pVzZ2Pktmw81z0T5XlJ6EKJ5AgFYoZhS8t8A/AQc6fUDgUtXtQIJEWwFFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602252;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:CC:Subject:User-Agent:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qfsFhryTTz4RhXxObQ1YZegBdEDgfWhPId1rtPYAN/0=;
	b=U1+LE0GUgjfY133OqWitFJS09YA4dMhUVZCJ+PRUSGVLw/VU3B+J0NC460ua6EgUsi/+
	 hC3CZlVwEwl0va3DtuFnZ4JCKJAPJmCaK68b/i/WyBUm6IV5XB1TD9cWwlMEOfaS5sSXm
	 RmtVIK9A26usBG8cWPQUX5ohCn/N8/kMr+LaiwUtZI70g5DHkmEPJbevspMDc49SaGMhU
	 UD6m4eKj68e01ooU3tYhkeweJZZ0tvicu4Hfv6mA8CWqfDmkr+uTMUYORKWeMVKAv+bGH
	 JOl0PzpHYBRPFlMrr9ek/1R2hpHamj1iikvbt6akLmtZH/aZoP/ny1WDk0pVTEH78rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VINDnsOR;
	arc=none smtp.remote-ip=74.125.224.44
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563C5606A336
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 17:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 563C5606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VINDnsOR
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6798eb0d13fso1152121d50.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792602251; x=1793207051; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qfsFhryTTz4RhXxObQ1YZegBdEDgfWhPId1rtPYAN/0=;
        b=VINDnsORSUIvFQadjq4cHPlHqnlHeF8K26mLp+HZfwbjThWvtefsS3wsktL0Av3X2R
         6Grz5GHz2hrYp5WExp+PBvIxE6uNI+WwZCKy7AgidYmmR3oUNu/6dVaEHbf9rfPRh1W8
         iDw9x7nHt57ek0II/Xo4S6xts0wUDf36N/IQAYpKTaBVdOiio01ikpdERxw/zZeRMiJ+
         J7oDEFvwfYsYcGnrpehTZgd+qptKONooqiBRe4PlI4kr38aimjghFyzjfh+tq13Nay3P
         3OBTjY5gRLYo+S+MRees024+y3eKnU1/n58duXy+MxWjN1EZ70j2cwnElWf3AMROU8sv
         Mzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792602251; x=1793207051;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qfsFhryTTz4RhXxObQ1YZegBdEDgfWhPId1rtPYAN/0=;
        b=pzlDY2HO76MIA02h+UzRBpybUtWHdEO+4wAgI3gz5pWmWmvIk2rh7P3WyZvwLFwjuQ
         mDTDhTeApHrfP+EfSNRRF+OjmiHk24yp2DjbDftFZe4gcecpLGHfJXWhylFMhUwMYesO
         JCCRYtmoCOT6brZmKEYyXa89rXjp45U+QMohLcNOmE7LSRx+ciA2l8Icv8THs4vN6uAv
         CiXiLoB7QsNiD6xJGXeEtfAMwrQxBSjD3p1lKK74XvdD+mX88vXE3LpBY9IsWYgW8DRi
         0HT3lWSwltT6D6zToRksvdAruA4RodKcLffQlgYhgv4hoyYLKNtCP8chUx0PgxxW1JY+
         znjQ==
X-Forwarded-Encrypted: i=1; AKwUvBzBxZCrvp5nzOKe+ZOOpMYpLF8F54D6fL+Oer9x8lR6VMTQeAezRxu18qjt/FKPHPEr9K5Fr06tEAeARZf94Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJL9YdOSwtfIce7sW1EhLqA+HII9parBtym2yBFkqgTIUT1ESmo
	NXDQNmaiFqBrD4uYYzLpGNV6zDRgeUYVvBqs0Ft/EFWeTsalKKVBQxN2
X-Gm-Gg: AYBFou1GMbeQeIXItbGwfCg/ItTNy9QSnmgZLmQIFMb22Tg/xXsh0SQOfdSQ2y7vaOA
	EVMk8RDpv09DwZBn/4Y1vWDfxBkOXyazPfiB+GlxkXzN7Ch84kVt4JTUsfMdUwaFvt7nhHUEGVC
	3YIFXIXL7J0SPm2ATLw/n7IF/6pPTRl1Pq3xfMH5dYcAKgTTOGqQSJtCPsqJGM2Vema07LmNMaI
	0gGm6mi1id73VFscQGeeZ5dL2PgotoQw/ZLJLxz/VFoOejJ+hYajIWuX+0oDFgufca0UmpmEz/Q
	ogDn7iwL7GskZg+gEoEYCXGqqU7AAV5CvjEsgHogLtuyRV1cuap4RxXxv2cmhTowBX6HEoR6f2z
	ntNnlJXg37wQ4pEzJ1hKNqTcJmP9ewMQ3g9hgK+8GHEmpG5c6Ne/OmTb9SJFdO9g5kEvOlLcA7Q
	sVI8OiFVcLkgkj6CXsm4hddnNtofKJ8fqfakVb4kBgzXCVxq1Fo1CNZ9XaM+IT/wLo9LmsVMulc
	cg+gQ1sw1Fg7v90Q+QINnqaXBSwJp3/VKrlWTk7ytcVsBes/sV6TMZrg3EmUh3YILQHqfcRku38
	Pv0wQVNzf14ilNnAaiv/wcptG1A+ZtaPUaPwB2jnksvaJ2/6AhEqRWtInAC8kqWEL5BM5p2AtVC
	v9dkohAlG6tfI6swjH2mY55osbzPOvdQy1PJGLjnWbke00V5JHqNZdn/RF6B0/ww=
X-Received: by 2002:a05:690e:1512:b0:679:cbd7:b72b with SMTP id 956f58d0204a3-67a0e56be30mr733933d50.131.1792602250958;
        Wed, 21 Oct 2026 10:04:10 -0700 (PDT)
Received: from ehlo.thunderbird.net (212.153.88.200.l.sta.codetel.net.do. [200.88.153.212])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e491a8dsm1417854d50.8.2026.10.21.10.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 10:04:09 -0700 (PDT)
Date: Wed, 21 Oct 2026 13:04:04 -0400
From: Jason Perlow <jperlow@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Aditya Garg <aditya.garg@linux.dev>,
 dwmw2@infradead.org
CC: iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
 linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
 johannes@sipsolutions.net
Subject: =?US-ASCII?Q?Re=3A_intel-iommu=3A_DMAR_PTE_Read_fault?=
 =?US-ASCII?Q?_crash-loops_a_PCIe_wifi_device=2C_v7=2E?=
 =?US-ASCII?Q?3-rc7_-=3E_v7=2E3_final_regression=2C_repr?=
 =?US-ASCII?Q?oduces_on_one_unit_out_of_five_tested?=
User-Agent: Thunderbird for Android
In-Reply-To: <1a15f52cf68.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com> <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com> <74570358-8085-4767-BF76-D865CA95853E@gmail.com> <40118d49-2e79-45c7-8e50-58e05a44d24d@broadcom.com> <EDE0E273-27FD-4069-9129-FCBB48D12ABB@gmail.com> <1a15f52cf68.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Message-ID: <20F90036-F53C-4490-B27A-DFD055DB22E8@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable




>
>I would prefer the above in proper patch, but it's up to Johannes=2E
>
>Regards,
>Arend
>
>
>
Patch below=2E

-- >8 --
Subject: [PATCH] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional

Commit f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf
packet IDs") maps the RX packet ID buffers DMA_FROM_DEVICE=2E The
BCM4364 firmware also reads posted RX buffers, so with VT-d
translation enabled every such read faults ("PTE Read access is not
set") and the firmware crashes and resets in a loop=2E

Map the RX pool DMA_BIDIRECTIONAL again, as before that commit=2E TX
keeps DMA_TO_DEVICE=2E

Fixes: f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf packet =
IDs")
Cc: stable@vger=2Ekernel=2Eorg
Tested-by: Jason Perlow <jperlow@gmail=2Ecom>
Signed-off-by: Jason Perlow <jperlow@gmail=2Ecom>
---
drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf=2Ec | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf=2Ec b=
/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf=2Ec
index 069ba70=2E=2Eff47d48 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf=2Ec
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf=2Ec
@@ -1639,7 +1639,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr=
)
if (!msgbuf->tx_pktids)
goto fail;
msgbuf->rx_pktids =3D brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
- DMA_FROM_DEVICE);
+ DMA_BIDIRECTIONAL);
if (!msgbuf->rx_pktids)
goto fail;

