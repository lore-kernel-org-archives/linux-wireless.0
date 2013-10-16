Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:51960 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3JPP5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 11:57:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 7/8] ath10k: fix device initialization routine
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
	<20131016134617.25095.10581.stgit@localhost6.localdomain6>
	<CA+BoTQkqkuf-=a4giyJHeYdXZ2T3deU7nmuQOxpFcKSzWjGb3Q@mail.gmail.com>
Date: Wed, 16 Oct 2013 18:57:20 +0300
In-Reply-To: <CA+BoTQkqkuf-=a4giyJHeYdXZ2T3deU7nmuQOxpFcKSzWjGb3Q@mail.gmail.com>
	(Michal Kazior's message of "Wed, 16 Oct 2013 08:44:32 -0700")
Message-ID: <87ppr55hun.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_175729_028616_E301F3EA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> +       /* disable pending irqs */
>> +       ath10k_pci_core_write32(ar, PCIE_INTR_ENABLE_ADDRESS, 0);
>> +       ath10k_pci_core_write32(ar, PCIE_INTR_CLR_ADDRESS, ~0);
>
> These use SOC_CORE_BASE_ADDRESS as the suffix, not the RTC_SOC_BASE_ADDRESS.

But I am using SOC_CORE_BASE_ADDRESS, right?

static inline u32 ath10k_pci_core_read32(struct ath10k *ar, u32 addr)
{
	return ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS + addr);
}

static inline void ath10k_pci_core_write32(struct ath10k *ar, u32 addr, u32 val)
{
	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS + addr, val);
}

-- 
Kalle Valo
