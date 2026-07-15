Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A0E367B94;
	Wed, 15 Jul 2026 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784124762; cv=none; b=GCI8KtEhBSJKqOF3vAkYZiApHTsWqCBdmF/a8D2GWQhU67necaCEf0mUkc3RRVXdTdBp35Oh0LQ7tpHGepayiS7IAywlCUWJQWUagKTMC9AdcCnX2Tfhwd3tHUJK0Bd3V6vUJRon1q81meSpYRF+GDICBvwzt6dpX012efdWjPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784124762; c=relaxed/simple;
	bh=gg1zaIrUmgq50fNEggpWUFxxx42Oc7MwkbuAHF63Ap8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=N49PSnq7Z6NppwXRN/eUB4naYWxAZSYskAquRc5z+OefOKPGj2rZWi5k5LKhBf7yfXC6B/E/OLtd4t7m+gOEvM62Gyzs4dE/Sl/pBiiTlr7WQsqStn0+RjavMt3SwWpLbuWkIduDgaiq0Jimcf07S5YJdCWclJKWHcQ7tqVdu84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from 0002-iwlwifi-uefi-v2.eml (unknown [111.196.245.140])
	by APP-03 (Coremail) with SMTP id rQCowADXo0FVlVdqsTsCAA--.2549S2;
	Wed, 15 Jul 2026 22:12:37 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2] wifi: iwlwifi: validate UEFI reduced-power SKU TLV length
Date: Wed, 15 Jul 2026 21:57:50 +0800
Message-ID: <20260715135916.24417-2-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:rQCowADXo0FVlVdqsTsCAA--.2549S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4kKr4rtw18GFyUury7Awb_yoW8GFyfpF
	4jgF12gFs8Xw47ua40yF4fCF9Yga15K39xuFyqqwn09rZaqry5ArWUuFW2qw15Jr48G34Y
	krWUAF4UGr90gFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyS14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxC2
	0s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
	0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
	14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8
	Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdEfOUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

iwl_uefi_reduce_power_parse() reads an iwl_sku_id from an
IWL_UCODE_TLV_PNVM_SKU payload after only checking that the generic TLV
payload is present.

A short type-specific payload can therefore make the three data[] reads
extend beyond the TLV. Reject SKU TLVs shorter than the structure before
accessing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v1: https://lore.kernel.org/all/2026063008051412.5-ccfa108-0020-wifi-iwlwifi-validate-UEFI--pengpeng@iscas.ac.cn/
- use sizeof(*tlv_sku_id) as requested by Miri Korenblit
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 2ef0a7a..4cd36b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -248,6 +248,12 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
 			IWL_DEBUG_FW(trans,
 				     "Got IWL_UCODE_TLV_PNVM_SKU len %d\n",
 				     tlv_len);
+			if (tlv_len < sizeof(*tlv_sku_id)) {
+				IWL_ERR(trans, "invalid PNVM SKU TLV len: %u\n",
+					tlv_len);
+				return -EINVAL;
+			}
+
 			IWL_DEBUG_FW(trans, "sku_id 0x%0x 0x%0x 0x%0x\n",
 				     le32_to_cpu(tlv_sku_id->data[0]),
 				     le32_to_cpu(tlv_sku_id->data[1]),
-- 
2.50.1 (Apple Git-155)


