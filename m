Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590837;
	b=huTAzwGnVU6NjWPEfAKK/eXv/UHrwVaAC7SShBpicC0Y8CNwMm/XBzWa/M8G/nEf5F3b
	 uXtoQtPUMMyU6mOzS8VyfVZOvSH7dER0uS1xRl8B2MgboZqNkxJGL4VNVoecKi4OLS7bA
	 91xwPiJ8zCJyfUUz55spZsQa9FzHgq96Bjvw5TdZJSDuJW3JihaZ6MrAaQyiMo7xx+FTj
	 qg8XvSn/4TQkolPq5jdanVapu4gDFJqbjpcoV+m682cu4ty0yr7y1UnLdS/Mh19zvVFAD
	 KOb+r/HFC4PdJb7Wkxqkiw93aMcHGQWritiFmw2jymFhMAZhfXY5K+DpfkH+nYZnCAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590837;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:CC:Subject:User-Agent:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HVdfobikX7vFrw+sXsu570+snU46eClKPnzChHPF63s=;
	b=WpTv7G9g5NWXVvmPqjdSDoLaX0BYSxwge0Dt31I1umqRDXvgGiTI7kG0sXHNlAvqDveV
	 M4L/rAG2lkjRlxODgn49V1PZf06cjnj7BzZBKRehQwdOyr0EPzXAzOgkDH47dPByKShrn
	 epmzsor9++w1SzpdPNHZPCwP788iNiPywHZKCWNYDFSBQrpDgTxpXdj/1MQQcLd7t35M0
	 s+l97Kq8CySxO8f6dttrQpb+MSs498JtcQkcjl8B/e6w36DzUVWYSRdK0Jrat3g9Rh7cm
	 Y945SfGxBIa008P/3PuU95vvnXIZEUTMVFDTOLJHw4hc8DJkbfv7WGnmuTmHetVlK3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="lGvTD/ZO";
	arc=none smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7467606A327
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7467606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lGvTD/ZO
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8ab43af5e97so8649667b3.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792590836; x=1793195636; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HVdfobikX7vFrw+sXsu570+snU46eClKPnzChHPF63s=;
        b=lGvTD/ZOF27Vz6zPTLabd9DneHxvPjb3ZVravUc1MXeeiPI7O2uvKXMdIIdbRgeg0h
         s2R2TwVTqwKWIGvf9X3Z1QjCGvUC/eVHwAUg6WusC2XOVmpH803wfD1b3O7BjmrIYIOO
         m9K0Ron7X0/erlSSmIUABNA1evRjqn+RPWUZwun8558rzWvfisqjw8N701VhC9Evkwy/
         HUJdL8SK0cXt9Fbx+vfgfP1dHspBQptyNvY9kxo3fEJMIp8iOcy4MnqDPI/yk4fh71KH
         kNBtB4E5qWO8wz7e1WW1ZyJt47Q94s0sPer6OlJLEuDQSVkbdkuP9aoPPtqLVJe4zvDd
         vu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792590836; x=1793195636;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:user-agent:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HVdfobikX7vFrw+sXsu570+snU46eClKPnzChHPF63s=;
        b=pxiEn/YsbHFjsqMqCtRi485Jn6R79qZ3ODXu86OI0iVjKpFSo0jOVC36j7yUONw5Qe
         17eO4XISwNL31XNHpcI1qEwkzktoyyzY6n9NNPiEyycO78c4hQmPtywksIs8YZmua3As
         soqDSaJkB6SkFuxv2lsB+Cm6oYwWE6q40JeP5VsbGWTrepn94TgWEDbOZCnvOSEv7R/T
         WAp4wM6aJRNYRlcD1FW+odVrAZNPzg23wMDqTPRXtlIhrcNUU9WPjyXojE75xZPWdkKu
         wTu/yR3XZSmo1a7EkHxCi2wdks1EkSobcRwqzC2PrdFyvXksCmVuuQUOf5KdWci989r6
         c9lA==
X-Forwarded-Encrypted: i=1; AKwUvBzpsIvpSUkWXHpV69F8OkWMhnvhcSEi0xXgifEusbQ772G/ymEurq77/y0vT1hxEMXm9xQ5pFdnKk/2w+QQkA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKviPzD8ot8yRDTljLAbYodvc6n+legfx0HVMDcEDYIsSkXMYkr
	Y8/+NUkx7rcjXZHyirOZdwwAFSNRWmK+cMvYZwqvRegdl4VFqq5hPVty
X-Gm-Gg: AYBFou1ItvDHJbzj2KcfuljscHQw69hGg6DsSBXvePNWdcaxNm621ImG1TpHEsgPFsC
	r4VsAmEueiBfQsMkjWuMa0Kpt+uznMQulhtq+X09CcMs4fkF68xpT4OPYf38Vexqo3LdGuRS3u1
	xuSCaKVp/zPfHavJIxJ6avKG9Bwesp0DVDTQbc1NpncyXV458RC6Iyfh+W5HZYk4Lqv8CR2byQQ
	huTs4328Puu/MHyJbHJDWjuQXlvFgMg88ASMWLpAZY5C2rmbNxxa0Gy1i39SkvwcFHM+2Z7CCCx
	gKpzsU3J4/BxJERxn8wNY+uxc2zVDYdeo4/paYxX9A/7jUWzciFF+9ID6fTLEXxipjxxpcpU4eA
	ouEhuv/UOG6pyoKp+B6yi5AcIa41t/+YqMbK3SkVJqp6AFiafTkay2JZogBrwRFrG0G4o1y3w6+
	TeZ/aJHTC649/l0y/DcBPUCflQ4r2vLEpiz5+W3FkJfH6mfRLuY10R4/SQ6rNUDk6hvKW7mvO6e
	1wiBHC8j/bz6aAHcC04AnrDcSigCb8pXStLmZYz7yMQM5l8njZMjgn1STVvWqGSAe2fS/Cu5UPZ
	6N4CF9xZIfDLEZsv2ystRFJkF8wt30ZY6D8v71SJXa2ylOkp5bsdFXsYjWzsirNJwEH0SHFndzc
	lrW0qk2d3Kmet1Z49V57cVrb0GWNGTXTlmpdIQTU8PV+ly3RZeVMZ2xSKxP5/I/M=
X-Received: by 2002:a05:690c:a0a9:20b0:8b0:ce9f:29a5 with SMTP id 00721157ae682-8b133cff2camr7680127b3.18.1792590835386;
        Wed, 21 Oct 2026 06:53:55 -0700 (PDT)
Received: from ehlo.thunderbird.net (212.153.88.200.l.sta.codetel.net.do. [200.88.153.212])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b13014b813sm11517467b3.38.2026.10.21.06.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 06:53:53 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:53:50 -0400
From: Jason Perlow <jperlow@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Aditya Garg <aditya.garg@linux.dev>,
 dwmw2@infradead.org
CC: iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
 linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_intel-iommu=3A_DMAR_PTE_Read_fault?=
 =?US-ASCII?Q?_crash-loops_a_PCIe_wifi_device=2C_v7=2E?=
 =?US-ASCII?Q?3-rc7_-=3E_v7=2E3_final_regression=2C_repr?=
 =?US-ASCII?Q?oduces_on_one_unit_out_of_five_tested?=
User-Agent: Thunderbird for Android
In-Reply-To: <40118d49-2e79-45c7-8e50-58e05a44d24d@broadcom.com>
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com> <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com> <74570358-8085-4767-BF76-D865CA95853E@gmail.com> <40118d49-2e79-45c7-8e50-58e05a44d24d@broadcom.com>
Message-ID: <EDE0E273-27FD-4069-9129-FCBB48D12ABB@gmail.com>
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



> Thanks for the pointer=2E
>
>The only DMA related commit that I could think of was indeed the DMA dire=
ction change=2E Hope restoring DMA_BIDIRECTIONAL fixes it=2E
>
>Regards,
>Arend


Restoring DMA_BIDIRECTIONAL for the RX pool fixes it=2E

v7=2E3 plus the change below, intel_iommu=3Don (05:00=2E0 in a DMA-FQ
domain), MacBookPro16,1 / BCM4364/4: 15 minutes of traffic, 7=2E25 GB
received, 899/899 pings, 0 DMAR faults, 0 firmware crashes=2E Without
it the faults start within seconds of attach=2E

-	msgbuf->rx_pktids =3D brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
-						     DMA_FROM_DEVICE);
+	msgbuf->rx_pktids =3D brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
+						     DMA_BIDIRECTIONAL);

TX stays DMA_TO_DEVICE; no faults on it=2E I can send this as a proper
patch with Fixes: f0ba5fd51ff2 and Cc stable, unless you'd rather
revert the whole commit=2E
