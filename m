Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D7E3CE4A7
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 23:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788735639; cv=none; b=FUPAYT90oWPXD/8Nvx2HcqvXZh2pIzRx7dJEttKCURYguHjA0zyiPEUkTd0VzXkrX0VmSFDOE49CJihTHXqnIGcKKmp4wUP7g65Nq/GQLI27GDn2HGSH9QlgetPRvtAxDLWTN4jirXtEFBgJi/mlo1aGpilBStkgKxVqVJxUxU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788735639; c=relaxed/simple;
	bh=OoqW51NcndbaQSGiIVU8Ya5rJKCis+Gi9XY3OSSexvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltxv53oq3qyeZRMRD+C6zQX8JEpNi8oI4rZyH6VfIt3FlfPkeaLi76c7Qo4KYEztyKa4lMsmIXUcluxAPCdotBh/gxti43jlQ3N4SxqQtAYZJKl3hUlGwzLsqGjZulmxvq7V2Isy2I8N4km4BgvV4J0Cb1DdW7QK2+BdSHbx+xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hi7r48zZ; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hi7r48zZ"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396672b2569so251651a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 16:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788735636; x=1789340436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OoqW51NcndbaQSGiIVU8Ya5rJKCis+Gi9XY3OSSexvk=;
        b=hi7r48zZBbppeJY0dLrbZ7V7YozEdTXzeP4lcedoX5gmfTemT+NPFB/uXp5KYy93xu
         34rgD8BNPoTBdh9V3XS03iRq4a5mLGYYdgEuAjJGlr7/JtQs4uMeXtsukyJydh/0E95b
         MV3vegNMA9r/QoZLDtF9/SJft6xuZXIM8p7l0FeAyvimRftjWttLW1IFKEif+gedQdOC
         y6aKFVd0F1y+m2SlKRwhXpDmCoWjUq2ThCNFzL0QBtkEXdjYVTe350sh3a1agSzGbS96
         BVYOf/pZS/Kxsi3SgIMPbgiIVyC/1lxlLsnFXSshVjFR1MMVejo43T0RVXchD75gRkD/
         yulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788735636; x=1789340436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OoqW51NcndbaQSGiIVU8Ya5rJKCis+Gi9XY3OSSexvk=;
        b=pve6JkHnNWD6hNcwl4LgulVfXQ3o/g3wUaT60TZRLT5VfouDiYN+fotJHD4BU6KXAI
         jnhsHzCadHocCD8SgR95mZttJk9wWbqN2oVMZn+gENAouyi1zLh8TNIl0tt5aiji5uKV
         j4+3jSRsss0re/Q1dAebpAudJIGeq3dPbjaeef+vqINsZ6xIREV3z+xZHDkgSuNupEtF
         T9ZqEVdtfvmhUfdj+6UWSDBEI6pqK+hzSM4Hg41NRA5h0tMX0uXg+UZ6wgmLYPLf/bLM
         gR2eg54HpBrk4WqDv5ndM+tEma7O53t4ZEsW57RzigbqQqDMpHw6Nts9zgiThJcKbfAS
         V1RQ==
X-Gm-Message-State: AFuF++lFgg+F2kcXlihrjp1razV6nSeFASUgjS5g7KpKgpBteZxRx8zo
	QuH4WLiq0vJjxi4tceCioQKi6GEpZaiDYRnDjk4MWls7tdosjOzyO/bM7UBB2KExZws=
X-Gm-Gg: AYBFou3FZoNMM4a5k2999RaMnnjPAH9vv8gwZKxG5jnugqM5BnMS7/pcf2hbEmFW52e
	VeqazyIOm0amkH3QZoRj8nC9KqD3ripZk+1CBLm8aSLNJAqByAmw11nYDeNrw7ugdPWhdaqibH4
	iCPYX5LFvTDV/1ekWEwTL4gKYGovd3bnDeJzmfuyKIvgaF+1uXjSOyPq4qOd170BcJ6snGo52Cj
	SnNzi7GLq+TrzvtHuUXNMER67W0h6/prdMvoSMMohQiSkKky9ezcDeQqepo1NKKszscw6kNmmZP
	HL1A//cHwIJHo2z1jF4LoIFYswCxx0xUyN8JsDcMWuV2Yep8Xg6paY3G7c/z9+lRyMRJRACgWpT
	DLo6tTrXGDQ89vTOSbkawiTj11AGo5YW6OViSMXepVSHAjSyv/kob945DORozTFERjWq95Jsh+r
	hep0oFhswkrYKzwBkZ0AmFPwTQTp6Wu1RVyKusPDkzry6bB8Q8epIWFXitCweRl/X6fhe3utEBP
	CuWDfQlFZMigg0slYeJE3mw5NxtoA==
X-Received: by 2002:a17:90b:2786:b0:395:4df3:8800 with SMTP id 98e67ed59e1d1-39b3d3eb82fmr11742650a91.0.1788735636298;
        Sun, 06 Sep 2026 16:00:36 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.108])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-333c9db92b1sm22359551eec.9.2026.09.06.16.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 16:00:34 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: linux-wireless@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Nika Krasnova <nika@nikableh.moe>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless v2 1/3] wifi: iwlwifi: pcie: don't infer CSME presence from a failed read
Date: Mon,  7 Sep 2026 04:30:22 +0530
Message-ID: <20260906230022.148733-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <1a2c11d47b27dfd8a246300ac158d25cef5abf35.camel@sipsolutions.net>
References: <20260831130332.323549-1-navonjohnlukose@gmail.com> <20260831130332.323549-2-navonjohnlukose@gmail.com> <20260901154828.GA1879052@bhelgaas> <20260901161736.GA1883420@bhelgaas> <1a2c11d47b27dfd8a246300ac158d25cef5abf35.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2026-09-01 at 19:02 +0200, Johannes Berg wrote:
> I believe the hardware itself never generates ~0, so yes, it probably
> should use that.

I'll switch the tests this series adds to PCI_POSSIBLE_ERROR(); drv.c and
trans.c already include linux/pci.h. There's no non-PCI transport to
worry about: Kconfig depends on PCI, and iwl_trans_ops went away in
0d91a2bfc3dc.

I'd be more careful with the helper itself. iwl_trans_pcie_read_mem() and
its _no_grab variant run it over dwords they're copying out of SRAM, and
~0 is a value the driver writes as data (FW_CTXT_INVALID fills unused
binding and quota slots). iwl_dump_ini_dbgi_sram_iter() is the sharp
case: it gives up on a single hit, so one all-ones dword fails a whole
region. I haven't seen it happen, it's just what the value means.
Widening the helper and taking the SRAM paths off it would work, but
that's more churn than belongs here. Your call.

Separately, the test at the top of iwl_pcie_irq_handler() (rx.c:1948)
looks unreachable: inta has just been masked with at most
CSR_INI_SET_MASK (0xBA00008F). I'd move it above the mask, unless you'd
rather drop it. I'll send that and the PCI_POSSIBLE_ERROR() conversions
separately.

Thanks,
Navon
