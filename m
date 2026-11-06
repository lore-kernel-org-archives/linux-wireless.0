Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.248.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975782;
	b=Yb0WLPiLtlRfVDY+HCI1yMWoP9NYgxUmgQuFDGfs+VSjgC23ja1Q9kvCgm1BXtXipQyh
	 kCixzHGoJ9eFr3Ld8g/DOYjP/ka4n9/W1PhEdxr5TZ6By4Dpz8g6EXz8B9eFtFPlyVAEe
	 Ys0X6HhKeV6pY50a45GxGezxkVOaDKAZOVrwNAsCYOH64I8O7loV0kAvWjxm3WvvJD1EJ
	 qR3+8V5VApNw+fDXdAH1jNVEZN6OwsIegIkXCWx7P4sWXJUrqSUPUDHNCB0akkZXm7hm/
	 8514RONvwyRa59yjG2RVm3AAxW97J7RWHYvd/5X46fC8hC8lma4NmBOIr2UMqXk2CZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975782;
	h=DMARC-Filter:Date:X-Lima-ML-UUID:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:Organization:X-Mailer:In-Reply-To:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=rawHr2YVl/H9jkwI+2q/ek0LKfKPSyS72kN0JSTFTe8=;
	b=4aBjvkcJcuwnzSiSuQWX0NQhv4wHys/n/vGwVdJAWJZoGd3L026ThiQRtLIk9I3Skg7b
	 OE7Tc6p95/IPUR+7UfbW9XDZhyQoyObVWewNXUV3pJ63jOdD+xFMDn750zMwAbMZPnjqI
	 m6MMR73v4LBFDA2vWcTwlj4wzoycCkh4KvOn/l25xG2gBtrxggZAvhK48eUxv2Os4pVxa
	 hF7+4dhkYa7DTcV2x7kqr1A/ZEsuMfN4ayNolCGy39v6lrR7T8t0d9fI0wmMWLeF/Buop
	 Ld5sOUrHW4IBI4MrPcZSAatps0h1B68SvfRgMg3vM0RDLc/uqZyyMrrJGCLrw9hpZhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=deq.rocks;
	spf=none smtp.mailfrom=deq.rocks;
	dkim=pass header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=hbL8du9u;
	arc=none smtp.remote-ip=91.216.248.207
Received: from mx5.mail-out.lima-city.de (mx5.mail-out.lima-city.de [91.216.248.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214B8606D802;
	Fri,  6 Nov 2026 14:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 214B8606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=hbL8du9u
Date: Fri, 6 Nov 2026 15:36:12 +0100
X-Lima-ML-UUID: cf184ba6-36c4-4d0a-b5d8-4034eb89d686
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1793975777;
	bh=cUspOtuWmA7XJYb4jzXp/qPVPvu+wOcxUbKsynPaRnI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=hbL8du9ufctCpUaLovUKKJcVq8POlp8KcWQKZ9pM6Cz0SzgdYKd9suBVx2OddI3H/
	 Id9XxKNVG5QeAwS0DN+SrQl26rLWR5MzDtbgLSpUbvyNgJKznk2EAIvcaZ+aTacwQt
	 Fir7WRTxEM5RYI0yFqaiNOSVeVwpGhDXTEo7hiL2vuVzKI0XZdqXCLpk41G08K4YvO
	 9VVyIPqQrEy5TBvn/T6kQIpF8gX4GWscaifQVJDo3HN8U8U6rl45lcQ1/wrVzeoZxi
	 GccCRnRcWxojEofWtHTATz+6wi9bGtp0wcYn1JH3Zd0uBvIefOXApecdUwJxcNjZZe
	 LWqVUxCkSja4Q==
From: =?UTF-8?B?QW5kcsOp?= Eikmeyer <dev@deq.rocks>
To: arend.vanspriel@broadcom.com
Cc: asahi@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 brcm80211@lists.linux.dev, dberlin@dberlin.org, frankyl@broadcom.com,
 gustavoars@kernel.org, j@jannau.net, kees@kernel.org, kvalo@kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, marcan@marcan.st, meuleman@broadcom.com,
 michael.reeves077@gmail.com, pieterpg@broadcom.com, vanhoefm@gmail.com
Subject: Re: [PATCH 05/13] wifi: brcmfmac: Negotiate PCIe mailbox transport
 with firmware
Message-ID: <20261106153612.2aadef2a@kait2en-mbp15-1>
Organization: KaiT2en
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
In-Reply-To: <20261103135856.3676311-7-arend.vanspriel@broadcom.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Michael,

I tested 01, 04 and 05 on a T2 Macbook Air 9,1 (BCM4377/4). IIRC should be 
the same chip as on T2 Macbook 15,4.

Arend, with the patch we get D3 ACK on s2idle and s3. So this basically
renders the D3 ACK WoWL workaround patch obsolete, you recently acked.
So it will suspend now without refusing d3cold transition, but BT is still
dead on resume, which is a separate issue. Just mentioning... 

Anyways Michael, the patch as acked now will fail on resume with

  brcmf_pcie_send_mb_data: Failed to send H2D mailbox data (-5)

brcmf_pcie_pm_leave_D3() sends D0_INFORM while devinfo->state is still
DOWN, hence we get an -EIO, so the driver falls back to remove and 
re-probe. The Asahi tree sets the state before D0_INFORM. With that
change my 4377 resumes without reset.


--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2838,10 +2838,10 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
        /* Check if device is still up and running, if so we are ready */
        if (brcmf_pcie_read_pcie32(devinfo, devinfo->reginfo->intmask) != 0) {
                brcmf_dbg(PCIE, "Try to wakeup device....\n");
+               devinfo->state = BRCMFMAC_PCIE_STATE_UP;
                if (brcmf_pcie_send_mb_data(devinfo, BRCMF_H2D_HOST_D0_INFORM))
                        goto cleanup;
                brcmf_dbg(PCIE, "Hot resume, continue....\n");
-               devinfo->state = BRCMFMAC_PCIE_STATE_UP;
                brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
                brcmf_bus_change_state(bus, BRCMF_BUS_UP);
                brcmf_pcie_intr_enable(devinfo);
@@ -2851,6 +2851,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
        }

 cleanup:
+       devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
        brcmf_chip_detach(devinfo->ci);
        devinfo->ci = NULL;
        pdev = devinfo->pdev;

Feel free to fold it into v2, or I can send it as a follow-up if the
series is already applied.

Andre
