Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B7B388E44
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411389; cv=none; b=rY1kSgf0h/S4M2SiITFAg8dhH3gPXmQyfJ1Z8XweX/2osB8qR3601jgzq8u7j4A047U+VpS1VryfiOIxTCBOcrtA2HKL5lo8klQj4QZ1qH8+e25K2lj1L0TfwEPytBYDlQasimO5/wvASJ2AkJkQvLgXnVKmOfHmpHbYERaxsUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411389; c=relaxed/simple;
	bh=VLY1Umk1yU84Icqq1PhsKQcaMi/Ow7hXTIZ5IR8tK0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrqeQxZZniZbjUvkdUxvRX2WG1GNpgTy1kDzJKVER8ZPCcPRDrseWTLhquhd3msD09HphV+UHpJiWcOc7z0rCY/zvuIbQsVi+mM69zDqpxCt177yulju4L6U/4u+/KDkH/xenmU+lDuANawqhyTg6NqgvD0wJ2qAX22eVwJFDUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OvDfRVAN; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OvDfRVAN"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2dd020a2e44so33815615ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789411387; x=1790016187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QZHVxUjP7ai7HQXDh9w3LrC0rVTP6eIyhyn5Gf7ApeE=;
        b=RVIRokYbMdNuw37kKVhO9qOmefof8G72N296D5/SEW3a0au9qjNci9X4Vv+h/0PAdJ
         NwN07/b4aO0b5ThygBHtm1NJyI0ha5mUqMjKs6GtwhphyTgPScqRhgBp3wFGQYkElCme
         hzsAG8XSWqq/jKHNKPxgHLv54lIx6ZKDsDRyff660bV+BtuUwqzi+foDjFSEKclFpCq+
         RWxGZ7m351JaBydAPd6ECpg12nhcwJp1Sl/rsm606bVybcMSOMlEPwc5pSF6wTr0cmfW
         lAPK4QFvjNO/fAQ0DJomk3QJ2tloWxAc6OIzG3UtOmXV2dBYp9br8dMEcYXzjT3zsAph
         GEEA==
X-Forwarded-Encrypted: i=1; AKwUvBzI29N18TXPsbu7yWtA0LVl5Sok7nyl9lnqq9Z9ZSsuEbq+l5NsIx+dsPmkvIxmB7+PCm/WhFLFtLLULTILrA==@vger.kernel.org
X-Gm-Message-State: AFuF++niHgywgx8DnmP7caI/qgr6XMiGIWnqvMKGKQoNsTQlmn7grcGH
	M6NVy7wR8mJH4jt1PmzMcdhtRwlf6yg/mL+CA2MZQEbbd3jv/9baLvxf+JKtu5Rp0zBVzzgJ3Q5
	7ZxMWf0PzznvTW+C9SmA7dn/CJLjg4TS9LZDv9b2ztVH596RIBcNoBkSSHKk1tgmP3Ce7gwUpPQ
	7KOBZ1XFnVpLmAjg6YnGLSfTJOJuTCRd2pZjUwInE3Xvb9sDbTcp99kVE/tc36s6riap2eeDKWb
	msy+MPCxetrtdXT/SUyMWDFwQe8pek=
X-Gm-Gg: AYBFou1dUELJ66lNot8GMQbVdlLPyo/UK2Yzmhz71C4Nm35oJSiiFv9gQPOs06b6lJv
	uTEHbEXkke4BBtbkVAGWfc24uImUqQ3hThpsaGIHdmSFaRJFLvHYLmYsxRA8tZ3vk2poPdpyf/O
	88/3XHptwvmoGaVJsbsBOsrczn3KAp6+8t3pWC3jQxsh5HUBDvQiZN9BCwZcv2UYNCFS1z5OEy0
	SQTJ1Z6ZdddzNAmvbVgc/+ZbPVMWbKv7XtkgZoeYgFF1S89feTlaxvO/ETM/mkvhnPB4nZzpLyE
	G3DrJj7DCLeRa6ztVCQNI+qYwtdUBeggb2VUFlzqOFo3YWuP0v4UDm3Tcf7tYgBN9Ikwij6ykwc
	03h3XOnTD8fqNiPfjeVS+BmO1UMD48mXsH+J+V8OfCOj/Q8SLi0y8YasiOC6gh2oTfJtrnDKriM
	+wjUhaBs6EsDgXA2QLv3ku4vBppGirx/vy7oU9DVg=
X-Received: by 2002:a17:903:2b0e:b0:2db:5052:fd6f with SMTP id d9443c01a7336-2dd6c70b250mr77654245ad.17.1789411386596;
        Mon, 14 Sep 2026 11:43:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-77.dlp.protect.broadcom.com. [144.49.247.77])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2dd2cfcb276sm4590925ad.10.2026.09.14.11.43.06
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:43:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso4179696a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789411385; x=1790016185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QZHVxUjP7ai7HQXDh9w3LrC0rVTP6eIyhyn5Gf7ApeE=;
        b=OvDfRVANx8XpXTrhcuZR/30PxAB2tal/PkoTjJw4lgIuHiQGpx9y/Hy21dhpSYylqZ
         vZMoWL1qpH4eMxRmW519dQV4Z6BFmZ780m6bnJS+PgUW2cQR3hiwJXk0/Ryk96VoLto9
         WO2fwIlzTNdTUBzaOEDtaWmJZHpyJD6DyOPOw=
X-Forwarded-Encrypted: i=1; AKwUvBzH09CxjvX3ji5oYKk3biIecou15Z7tqQuQ3erqb8yYDPXlRblTfvaZV2UHyJ6RrGNhXQdCynloSqXTmLSMeA==@vger.kernel.org
X-Received: by 2002:a17:90b:5850:b0:39d:fcbe:fdcf with SMTP id 98e67ed59e1d1-39dfcbf80a3mr1839044a91.1.1789411384890;
        Mon, 14 Sep 2026 11:43:04 -0700 (PDT)
X-Received: by 2002:a17:90b:5850:b0:39d:fcbe:fdcf with SMTP id 98e67ed59e1d1-39dfcbf80a3mr1838993a91.1.1789411384448;
        Mon, 14 Sep 2026 11:43:04 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e52a60sm27509723eec.6.2026.09.14.11.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:43:03 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Markuss Broks <markuss.broks@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next v3] wifi: brcmfmac: Add support for BCM4361 PCIe chipset
Date: Mon, 14 Sep 2026 20:42:59 +0200
Message-ID: <20260914184259.1466535-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260820-broadcom-staging-v3-1-7d5741e37efb@gmail.com>
References: <20260820-broadcom-staging-v3-1-7d5741e37efb@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Thu, 20 Aug 2026 20:59:01 +0300, Markuss Broks wrote:
> Those are the required changes for the BCM4361 PCIe chipset support.
> BCM4361 is a dual band 2.4GHz and 5GHz WiFi + Bluetooth combo chipset,
> installed on several mobile devices, such as Samsung Galaxy S9.
>
> Tested on Samsung Galaxy S9 (SM-G960F), where it's connected by PCIe link.

[...]

> +#define BRCM_PCIE_4361_DEVICE_ID	0x441f
> +#define BRCM_PCIE_4361_2G_DEVICE_ID	0x4420
> +#define BRCM_PCIE_4361_5G_DEVICE_ID	0x4421

The 2G and 5G device IDs are defined here but not added to
brcmf_pcie_devid_table[] in pcie.c. I might have been clearer
on that, but it seemed obvious to me. Please add them as well.
Refer to 43602 device which has similar device IDs.

Regards,
Arend
