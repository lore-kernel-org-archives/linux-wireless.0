Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793916055;
	b=hv/r9Ivmxao7D58pe/2IOR8DtLsYcDTpztVEJ/+wfVtklhi9VDJ4g9u/2QUANcWjVQlL
	 9gg0TCPH+z5XJ/eixqLWGmDBPE4Pt5d9BVscVzn6R+n1TjVSBWc7AK3m6djQw16tLhLAq
	 HbFmfD8tg0Mm6n2vE9kfFLJ4HpugYf/Tq/yYEDcw1SbM66aQfJKhSn712kX0K8BTv95lG
	 238dRCdKGYgm1V6SrtYv1/lPtKf7Ob1ixo2uPpuqzYrMJWM3g2dBpTzg5p81YebUkZrih
	 c1SsU/DgY+lAYNNcEUHMyZk5iGZmlwSbuyIcAcfd8DvIpJ2WQoIiQk7pMprmzOXPctA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793916055;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MKfWIAkpQQcvlzsGiHXUHQerg55g/nZSDN/398RwIAM=;
	b=n4G5Zq6p01w43NeiBoxxdHfjzPdndCkN5oDB1XBCi+wNifEt6ouiGutLduD/e5gtPM2K
	 uM/b8C79d+RSPPPNZ7Bm7GU09AqUV3fXApfsj6ezf8rhg7dXp8kzsfQMnVKNwKhgXsvd7
	 z4ya/T/XPPPdUQqJldz1AyKU3cLJ4xxxOsCEIzj5vGgG9GdVnb906ovwgF4beu/QGXsuK
	 JiGUA/iTIZ+lauCRjTBsA2/kLvG1vazL/eoP275ufewFEnQ2YPKdmjlg9bAkscd6fqz4J
	 Uw4tW6Shw8IHFHD8dVUmOvgF+I9CKuKnoruCufatc3ixHbYi9jG4ihEpugWphyEG/dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ks6XVGnG;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B418606A329
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 22:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B418606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ks6XVGnG
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-492690dd5daso32541f8f.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 14:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793916054; x=1794520854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MKfWIAkpQQcvlzsGiHXUHQerg55g/nZSDN/398RwIAM=;
        b=Ks6XVGnGhqUthyL+fWQXPPYmo2IXVqv8KPLYZR8rI1NTlYdacn0pwPMRFC+J+2CVno
         gxLWuYn4mKomNbdXH8CA29bvY6TxOqvVbX4WP+FixDnvZp9HpClVXXVMI0gY/+uRVaXk
         QmgdduJL3TfViH/AAxqX3Xo8vbRxTlbQjnXesqtVMrXthCw7UeFwwk/wzrDgMhd7YVRm
         Oy9jk3QTzgnqsWc/fWbN6fSTWBUBZZ68xKj98ubMzhdDXQHG9lobsYQTkyb/N5wnDNuY
         h5Z4KzWDE1PjYR+tRNlsmFNyO2Hrn03WjiGFZILVHV0jW15FwZWzk4mQzhBu5uVBmTxz
         m6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793916054; x=1794520854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MKfWIAkpQQcvlzsGiHXUHQerg55g/nZSDN/398RwIAM=;
        b=lDByOe/3fKdDjpTWqLJEJ73rHgRaOdcitQte+zpcQuUhri1u6TKLB438ODDg8CpYlJ
         Hr2Md5yrosJmQBM5f38vImQI+bNMV5nleOxrMEEjtt5PIHLNDLjOt8XO0+tnvgN0Xtcc
         KEq3MxK8WSn4wKcCvOBaIMQ+5Knc/pBfTLIyTQAkJ9/BviFlxG08iLgPx63UL31KRepW
         PPsiBCg6/4iiiPDd3PIU+2zTHTH5/YlsqAjTeH0J8E5J1WwTmZ5Cu7bW4g60pTnzMZ6m
         DKOnHgXEn4a1lsFYwxfjc7oHPs5GECiDAjJHGln5tC2t3yM25o+I4ODTG8XZo9y+WVM5
         2xxw==
X-Gm-Message-State: APuU4Z/zlHC1sg55imji0HW8KX/Scrr0lAMLsSNboyRB6ZZbEk2DUAkp
	0RKGqOS5vjtwJUrcOFAESAjCaBr15VDGR9xajifoIevw1+aQHl/g0X8dHcle2uc07Yk=
X-Gm-Gg: AYBFou0MVM+ivJu5jD0A44V2E6Wtc/BESGGAynpoJDvxY1qZZh3/CWYFhgROlaTv679
	N3tSR4jt/wOFUNMvB9uWBSuhRJKrSfHTegoCx8P4zo77L1xtbVzD/i4mzXSnSpQpYhzXdffNZA5
	3nr6oawo8olxlwag+rNU35+CzKdSGaXUwYka0IJWlcSiJl/F9pyuPUvC5/HA/Q4q/3SCo1I7MC4
	bqugQFdUdwGVsk0c29AzEL8bH9900cmNw1DldX9j2w+zs6eWiw29hr4+dgqFujWq2Wbpass7z3y
	Udczv82irUhus0rtf9IPeflYQgbyvvkVqKNhRXPVbGOH1AZ1KsD8vgCVl02QjCkbO93KwAKVSJI
	zXuzkAidn4EnHnpCEV9X9AvWkMN64u+wMS+BFirkZrfPpk3W7d2Uq2a5ulrhCPBOqaJv7xhErFU
	ayqdn45vFr991eIFBMYUaOkbk7ZzWkoFuGHOrazRmzzXpgrggG3dayyy7CgDS0ZhndrHL5Tsl8C
	LjL40WPidI+7bs16W7+cn79GYR/YrvG+phX6NrUDoW9ymvHO7BtnItaWnSl7iCmssd0l4tGk5Pd
	AP42Z3hmVluBRD+fgHwKf5VorjazWVSG/ZaK1YDNZao2/sK87Zs58/IRI4TFyCm6DeLlb75/uax
	yPpPqFrrH
X-Received: by 2002:a05:6000:2913:b0:48f:88ad:7b54 with SMTP id ffacd0b85a97d-492760da7a2mr1778649f8f.19.1793916053781;
        Thu, 05 Nov 2026 14:00:53 -0800 (PST)
Received: from soeren-MS-7A32.tail37253f.ts.net ([2001:a61:13ae:e301:329c:23ff:fea4:379])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda203b6sm11922212f8f.48.2026.11.05.14.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:00:52 -0800 (PST)
From: Soeren Coremans <sorencoremans@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	Soeren Coremans <sorencoremans@gmail.com>
Subject: [PATCH wireless-next 2/3] wifi: brcmfmac: pcie: bound memdump to the mapped TCM window
Date: Thu,  5 Nov 2026 22:59:53 +0100
Message-ID: <20261105215954.184290-3-sorencoremans@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105215954.184290-1-sorencoremans@gmail.com>
References: <20261105215954.184290-1-sorencoremans@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

brcmf_chip_get_raminfo() reports "RAM size is incorrect" on a dead
device but leaves the bogus value in ci->ramsize. A following
brcmf_fw_crashed() then dumps that many bytes from the TCM mapping,
which is only as large as BAR2, and faults in ioread32():

  memdump 0x00200000+15728640 exceeds TCM window 0x800000

Remember the BAR2 size and refuse dumps that do not fit. Only builds
with CONFIG_BRCMDBG create the memdump, so only they are affected.

Found and written with the help of an AI coding assistant (Claude Opus
5.5); the cover letter describes how.

Fixes: ff4445a8502c ("brcmfmac: expose device memory to devcoredump subsystem")
Signed-off-by: Soeren Coremans <sorencoremans@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 02c58de67b82..5abc85013110 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -343,6 +343,7 @@ struct brcmf_otp_params {
 
 struct brcmf_pciedev_info {
 	enum brcmf_pcie_state state;
+	resource_size_t tcm_size;
 	bool in_irq;
 	struct pci_dev *pdev;
 	char fw_name[BRCMF_FW_NAME_LEN];
@@ -1669,6 +1670,12 @@ static int brcmf_pcie_get_memdump(struct device *dev, void *data, size_t len)
 	struct brcmf_pciedev_info *devinfo = buspub->devinfo;
 
 	brcmf_dbg(PCIE, "dump at 0x%08X: len=%zu\n", devinfo->ci->rambase, len);
+	if (devinfo->ci->rambase > devinfo->tcm_size ||
+	    len > devinfo->tcm_size - devinfo->ci->rambase) {
+		brcmf_err(bus_if, "memdump 0x%08X+%zu exceeds TCM window %pa\n",
+			  devinfo->ci->rambase, len, &devinfo->tcm_size);
+		return -EINVAL;
+	}
 	brcmf_pcie_copy_dev_tomem(devinfo, devinfo->ci->rambase, data, len);
 	return 0;
 }
@@ -2145,6 +2152,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 
 	devinfo->regs = ioremap(bar0_addr, BRCMF_PCIE_REG_MAP_SIZE);
 	devinfo->tcm = ioremap(bar1_addr, bar1_size);
+	devinfo->tcm_size = bar1_size;
 
 	if (!devinfo->regs || !devinfo->tcm) {
 		brcmf_err(bus, "ioremap() failed (%p,%p)\n", devinfo->regs,
-- 
2.53.0

