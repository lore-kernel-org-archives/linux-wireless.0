Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349D0EEC0;
	Tue, 30 Jun 2026 07:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782804211; cv=none; b=CChUNtnniLVZy2M7B1RhNeldXjQmRxyzXLTOTt0JVXjnDLOgx6s171wt651zRPI76NjXkX2ZpmbLzdMTxbahjV+dqhPw8A/ESh+PRnn5/pATLoSasiHx5eovso9tz3i0F7fiWhVPWTIxg9p/AIIfmUheaNkxUxR6/3f22CpQbiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782804211; c=relaxed/simple;
	bh=gcpD36piaqh1fJLonFOyo9H6g3yDxK12PS8DlNgUfJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j6BfAFUSo1nBIXl/AV1XKKnxY/306LfHF0cqo3ttqmVvoz6prpfxdK0w8DK+LuBW9s+zxVMBGNIjfUpq5duyZ7eiGknJGmCHpuHSFtq0kSMjde3IAe7MqqZwVcWIAIdAWhTu2JTGaNsplGB+oNuak+cTf4GeNQQ4v+7VryLNifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from 0020-wifi-iwlwifi-validate-UEFI-reduced-power-SKU-TLV-length.eml (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowADXYQXvbkNqqWIkFg--.48592S2;
	Tue, 30 Jun 2026 15:23:28 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: "open list:INTEL WIRELESS WIFI LINK iwlwifi" <linux-wireless@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] wifi: iwlwifi: validate UEFI reduced-power SKU TLV length
Date: Tue, 30 Jun 2026 15:22:41 +0800
Message-ID: <2026063008051412.5-ccfa108-0020-wifi-iwlwifi-validate-UEFI--pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADXYQXvbkNqqWIkFg--.48592S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWDWw4xKF45CF1ftFyrJFb_yoWDtFX_Cr
	1rAFn5G34jkw1SvrZrCrW7Z39Yyryv93Z5uw1Dt3sIgayUZr9rWryfurn8trWUKr40yF9r
	Ar17CF18J3sYvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbFAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxC2
	0s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
	0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
	14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUj9a97UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

iwl_uefi_reduce_power_parse() reads three SKU words from
IWL_UCODE_TLV_PNVM_SKU TLVs after only checking the generic TLV length.

Add the same type-specific minimum payload length check before reading
the SKU words.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 2ef0a7a..747df65 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -248,6 +248,12 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
 			IWL_DEBUG_FW(trans,
 				     "Got IWL_UCODE_TLV_PNVM_SKU len %d\n",
 				     tlv_len);
+			if (tlv_len < 3 * sizeof(__le32)) {
+				IWL_ERR(trans, "invalid PNVM SKU TLV len: %u\n",
+					tlv_len);
+				return -EINVAL;
+			}
+
 			IWL_DEBUG_FW(trans, "sku_id 0x%0x 0x%0x 0x%0x\n",
 				     le32_to_cpu(tlv_sku_id->data[0]),
 				     le32_to_cpu(tlv_sku_id->data[1]),

