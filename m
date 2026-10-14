Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF722511E90
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982993; cv=none; b=jn9D6VupS9gtlimu4ZjNrGXzQPG2LPMgaOEuE8c7GnkVcedVcGRMORF1KIQ+eAKeFpUwNliHaoCntDryGo8AnzwjM6FHy8JOIJ3bK+w36AFuwXV6tJPrvkZl4M+xK4g/6WK4GuVsb/VFddul4mcstxgtP5e9BbyILex5ISKHGLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982993; c=relaxed/simple;
	bh=5rv38UcrwbFqOl8kIRBBDnFFUd9jARG6P+ogvn4XWwQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=M4ubzTjqhm2vcGp4x3jQTZZFJBPQ4oykztQPz+cWF7/MzLprFq6brVdKh9nmrme/sNS4rGn/hHmwy5Y5F90sycbDSExcylPyDadcClFsN+S1Z1UN4MYcY01KAHP1xylZXNsj747+zrgtyaOs8DF+C+AFydwqTzKMyzGlm639hjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oe4NkxUL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CyJb7u1z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oe4NkxUL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CyJb7u1z"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EBXDMJ2685285
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WNkD0orYO1VTH788P7bOUsG3azMo3cwZxLA2xjcYEo0=; b=oe4NkxULPhYmP4R3
	jjYVZUtI4jpqFim/4jUCj2gLjvlbUnQS0LKUo8HPcm1OkZ0kFuCfTV1rlB+TC6nM
	uIQhrHPlsSkyrr/I2F1p/F3JSg5Qgfys5vVji05MGvjYDD87O/UlsUVLOhKhxG0R
	HnNziXKX6WX5y3rn1oGqfdpez3+XXS+C2C2xRidIUF8VOCtSKLPwkr0a34iV1bq1
	J1bz9zqi7QsyQpkPKy7PU22G+or+0G8dLeNqACTMl/tbb+viTzwwx644zEZ6S0ki
	Bwf98/h/53jQPqsbLfOmMfeQHPX+TMCWvWX3YM5eopZ5IXoFnjX5ULECT+A4NWuV
	bdEdgw==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha46u1nrx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:07 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c7c0d2b0aaso1727655e0c.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 06:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791982987; x=1792587787; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WNkD0orYO1VTH788P7bOUsG3azMo3cwZxLA2xjcYEo0=;
        b=CyJb7u1zVJhyVHM8dh1RS05wkr8oh/59ObKY4IBQYeUMT33PCcEW0Y/b/UjlnwRrmp
         KhPf1LdatugO85d+ovC+ztR5QvU/3CNBv/OfX5HxX2kDjdRaFAY6HDAL+ggsIH7ow6md
         8+bI64DGqdVXBAOtDXOoI/xgfixQqFe8u+uZfqR0dQY7zbtGy92eHru94c7vd012MaX8
         QBYh81sj+Z2HBygS+4Nd9puhSgdGRzpPTge2maL5nIHONmwwIWZx1YrrRNvArlHRoZE6
         tgoMMgR1ZWYuZs1PKQj7X9qPWav07LaJI+aBiRpAz+QIXEKw7f4fqKnA4JCKufhDWDAW
         /OHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791982987; x=1792587787;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WNkD0orYO1VTH788P7bOUsG3azMo3cwZxLA2xjcYEo0=;
        b=GShk7KALP9vnOLMpjJIspgej1jYWpI5eZ1efX7kCszQe+7YyKUDhEmaJkoMcnV3b97
         F72386bUmBZP7F2qCNWgzmc09/tsF1etJbRPmSvYPXPtSAI9XsiVN0KdQWkp4FRu1YWj
         Qy9Wmf3DVjGq8l/uwywGxQcAw3chOwCEF4AF9qzpQmXBY60OzNfNuuCg1PDGYXJ2nX7z
         K4oxw4Z4w1JbbKH6mIpzGEYnTi0ksjhHYvU1IuuXIHRPYT37GwfVyl/NiOJNYG5kdJoc
         sIIglyqQwkiAdLvXfGTZpQGTGIAm1sVgRU+PkT407nOEO3FgQTGqP2tPP19cpHE309m5
         hkRg==
X-Forwarded-Encrypted: i=1; AKwUvBy/80gdNzHDMntcwCmaaW/0hGMl/CqmS+n6Lu11GoOmNfhux754sDMFosfn6MNwbW//4Fkb6SAFDLkRNXrGrA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKHgcx4TFETgUvwkWpOV7A6oOb7zCS6Z4rpha9vctm0n4XzONsT
	P/i6/UbO+aoAwJc4fevF3Id7IxNm2PwcYdDKsBt5vuJzW0FKYfk5Eq6HkWzwB7S5PTAcVG5Cy4Q
	MDXaqG/P+X02ih7Of46ELLUO1Ks0IGrHA8d6oH7FScwpbUtKVBl1EMOSiEZghOpJ1TyMPdg==
X-Gm-Gg: AYBFou3ad0H5kYsvW/S6daxRO2CslEVyJf3mVQ95ZG7cxMeSsp3k3uY13xsX65V8FYM
	ym26YJ/vXzyvW0glWYuxQpb2dAeMpKDsz8o0N48lWwdRtDFIuzRzDcwbJOdr8E361bY9VDA/nsL
	IEgDto+zju7Lui+cf5/37ivBWm3qiY/TRQ3k63x4G/I0IgSC7Nsw689ZcSCtGaV0w4aCU3z71Af
	Tay3WkMAFenTT2Cp/HaIoUdrdjPnWJ5xcX0KH1bg/7o8wbZdeACjKgql530TxXiARDPgZxmDHGc
	EiNVCOFCRTRmiIYKkqVCOWN9d/CrbcSDbVbbF3WWElkj8vExrfKqgy+hoRfPVHlsnx1dize0ma8
	HXzxxEu43LQ==
X-Received: by 2002:a05:6122:2896:b0:5cf:6f75:ff68 with SMTP id 71dfb90a1353d-5e91f250b62mr4861024e0c.1.1791982985909;
        Wed, 14 Oct 2026 06:03:05 -0700 (PDT)
X-Received: by 2002:a05:6122:2896:b0:5cf:6f75:ff68 with SMTP id 71dfb90a1353d-5e91f250b62mr4860885e0c.1.1791982983517;
        Wed, 14 Oct 2026 06:03:03 -0700 (PDT)
Received: from [127.0.1.1] ([86.121.170.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bcece106sm567795e9.9.2026.10.14.06.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:03:02 -0700 (PDT)
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 16:02:40 +0300
Subject: [PATCH RFC 2/5] nvmem: Add UEFI variable NVMEM provider
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-nvmem-efivar-v1-2-187c85f65018@oss.qualcomm.com>
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
To: Srinivas Kandagatla <srini@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10650;
 i=abel.vesa@oss.qualcomm.com; h=from:subject:message-id;
 bh=5rv38UcrwbFqOl8kIRBBDnFFUd9jARG6P+ogvn4XWwQ=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBqz316x6zE77o29K16W8GQeRXAUZw8XA0NlXE05
 xLeEpWHFMyJAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCas99egAKCRAbX0TJAJUV
 Vl87D/9NfvV/4e2YcUFqjHfGpWTcxR7Ls9exA+J9kR1SHt3Z7DMobqt+8WvE9sOXKFnFdOC9nTW
 uO5dS8dXSBDy8fZy1GhyhBH3dHkscrChNfqIgD4ps/nudqxje2krtD99/OOgoAvCserWj4BzZ48
 b+Qf1tqHgLjFNLmGXrieQQ36SdoH9dUfKkV6qLWZ7uROkPgZKbyMDA9nTmnubnLRUcJ3SLY2n7t
 aFaaWQaMPxuT8tKDUf9TabvFcbD1BiSJVqjT/Rs2obc2O1xjkTjqxanVhw+X/C7wFVpHx5FC0g5
 JGzEBBjBRw4+pJ99V0IrpyqhwSfqL06jtPCP9PksZRjWmqTZ7KFeGuhFNVBTjHtPcLXhuHMfgsO
 XZSo9+L6K1pDMmY22352mimIE3MmfJD2NIJolEg1HHhJb0CI6TsJHulmnYgaCWu33u5rsLmpBjB
 n/AZzYHygZrVFGOApx3RgDZGEfvrBsjdGSpmI5EQVVkvuBLMhMi8lnwCXDPgNLpee2ufY75Y2aE
 RP7MKWCi/dicXiDCf5fPvE4GKBoMLcXk4s2a25DoWwd79SiYCudK6XP7cQuGaLi2YnVK6lGz3Tu
 1no/9/bVt9fB8EkWuW7KW6s4E4nFw2Er2oDy38Xm33JOKIbTLiE//OPILaqCxuXWLTPL90v9t4G
 QeCiNuXyCCigbxA==
X-Developer-Key: i=abel.vesa@oss.qualcomm.com; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA1MSBTYWx0ZWRfX/hMUxDv+Wm4y
 lxvK6JkbifY9JE5pMxbVB6iF3kllQbRe5CZLyrC2SteDAMsAZGVW5Pl8uCY/CwE7ZXgYhO1Qb2x
 IVz5awnHEukKxO8ZAikoaTTG22yqg04=
X-Proofpoint-GUID: rtKBQohE5qLCuRSMevkNUH9NgpFI1xTF
X-Authority-Analysis: v=2.4 cv=Y6ttIReN c=1 sm=1 tr=0 ts=6acf7d8b cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=Rt3kCFFBWhWisHNmluDamg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=4iBj1q6bK3updTuR3M4A:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA1MSBTYWx0ZWRfX0oENXMy/onx8
 y2wk7rJwI6RvpGrf5wQzMwV7ci67ThYKDzs2ClKHShcczF9JatOQOE8IMifEJlsFTk0lVMHAgD2
 OejYVvwiXCh4WeDZ6M2Zm0f9iB4oKh5pvMZj6nmtnYA7E8kOwNf9KVnNDU309unKrZUVI65J5fr
 T5NmApeW/g0JcRt8KJlphYbj8P1EhCUe6Z+PS2NCvTzQHu3btfQn5REhZZ5Stfq7bdnDG1Npb6A
 TUrT+05LAj+YTJNnW/2GSQ8PDWhGgTqlKZMxzJgUCWOFqsIiBaLzyAF6HzleNGj75e3KctW41QK
 7T1nKN+ZtZfN72c/GqeO4zWxZ8j2RTAYp8a//Hszn/Y4oNWPPPqdHPg2VVhr90nfyI5UOchWb0a
 rrGnt3OVlilNhlWpy8udDBDc1yD3gqolWG2bGYi8PWCFS2oxI+HEKTe1j5jKRniH6HqkuG3at9P
 dsZDVqV6D/7AmlHQ5Hg==
X-Proofpoint-ORIG-GUID: rtKBQohE5qLCuRSMevkNUH9NgpFI1xTF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140051

Add a provider that reads a UEFI variable via the EFI runtime
GetVariable service and publishes its bytes as a read-only NVMEM device.
NVMEM cells are described as device-tree child nodes and can be
referenced by consumers through nvmem-cells / nvmem-cell-names.

The vendor GUID is optional: when it is not provided, the variable is
located by name by enumerating the variable store. This keeps working
on platforms where GetVariable is emulated by firmware (e.g. the
Qualcomm uefisecapp backend) and where direct flash access is
unavailable to the non-secure world, in particular when Linux boots at
EL2.

If the variable has not been provisioned yet, the device is still
registered, sized to cover the described cells and filled with zeroes,
the same way an erased EEPROM would read. This keeps consumers probing
and falling back to their default addresses.

Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
---
 drivers/nvmem/Kconfig  |  12 +++
 drivers/nvmem/Makefile |   2 +
 drivers/nvmem/efivar.c | 273 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 287 insertions(+)

diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
index 083a5e528960..3f619dfa1cf7 100644
--- a/drivers/nvmem/Kconfig
+++ b/drivers/nvmem/Kconfig
@@ -185,6 +185,18 @@ config NVMEM_BRCM_NVRAM
 	  This driver provides support for Broadcom's NVRAM that can be accessed
 	  using I/O mapping.
 
+config NVMEM_EFIVAR
+	tristate "UEFI variable NVMEM provider"
+	depends on EFI || COMPILE_TEST
+	help
+	  Say y here to expose the contents of a UEFI variable as an NVMEM
+	  device. This allows the kernel to consume data provisioned in a UEFI
+	  variable, referenced from consumers via the standard nvmem-cells
+	  bindings.
+
+	  This driver can also be built as a module. If so, the module will
+	  be called nvmem-efivar.
+
 config NVMEM_IMX_IIM
 	tristate "i.MX IC Identification Module support"
 	depends on ARCH_MXC || COMPILE_TEST
diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
index 5e70bad9f0f9..038d3d9ee95c 100644
--- a/drivers/nvmem/Makefile
+++ b/drivers/nvmem/Makefile
@@ -27,6 +27,8 @@ obj-$(CONFIG_NVMEM_BCM_OCOTP)		+= nvmem-bcm-ocotp.o
 nvmem-bcm-ocotp-y			:= bcm-ocotp.o
 obj-$(CONFIG_NVMEM_BRCM_NVRAM)		+= nvmem_brcm_nvram.o
 nvmem_brcm_nvram-y			:= brcm_nvram.o
+obj-$(CONFIG_NVMEM_EFIVAR)		+= nvmem-efivar.o
+nvmem-efivar-y			:= efivar.o
 obj-$(CONFIG_NVMEM_IMX_IIM)		+= nvmem-imx-iim.o
 nvmem-imx-iim-y				:= imx-iim.o
 obj-$(CONFIG_NVMEM_IMX_OCOTP)		+= nvmem-imx-ocotp.o
diff --git a/drivers/nvmem/efivar.c b/drivers/nvmem/efivar.c
new file mode 100644
index 000000000000..699b1d67aea4
--- /dev/null
+++ b/drivers/nvmem/efivar.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * nvmem-efivar - expose the contents of a UEFI variable as an NVMEM device
+ *
+ * Lets the kernel consume data provisioned in a UEFI variable through the
+ * standard NVMEM cell bindings.  The variable is read at probe time through
+ * the EFI runtime GetVariable service, which also works on platforms where
+ * the variable store is emulated by firmware (for example the Qualcomm
+ * uefisecapp backend) and where direct flash access is not available to the
+ * non-secure world.  The variable contents are published as a read-only
+ * NVMEM device, with cells described as child nodes in the device tree and
+ * referenced by consumers through the standard "nvmem-cells" /
+ * "nvmem-cell-names" properties.
+ *
+ * If the variable has not been provisioned yet, the device is still
+ * registered, sized to cover the described cells and filled with zeroes,
+ * the same way an erased EEPROM would read.  Consumers are expected to
+ * validate the data they read so such systems keep working with their
+ * defaults.
+ *
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#include <linux/efi.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/nvmem-provider.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/property.h>
+#include <linux/slab.h>
+#include <linux/ucs2_string.h>
+#include <linux/uuid.h>
+
+struct efivar_nvmem {
+	void	*data;
+	size_t	size;
+};
+
+static int efivar_nvmem_reg_read(void *priv, unsigned int offset,
+				 void *val, size_t bytes)
+{
+	struct efivar_nvmem *p = priv;
+
+	if (offset >= p->size || offset + bytes > p->size)
+		return -EINVAL;
+
+	memcpy(val, p->data + offset, bytes);
+	return 0;
+}
+
+/* Size needed to cover all cells described as child nodes. */
+static size_t efivar_nvmem_cells_extent(struct device *dev)
+{
+	struct device_node *child;
+	size_t extent = 0;
+	u32 reg[2];
+
+	for_each_child_of_node(dev->of_node, child) {
+		if (of_property_read_u32_array(child, "reg", reg, 2))
+			continue;
+		extent = max_t(size_t, extent, (size_t)reg[0] + reg[1]);
+	}
+
+	return extent;
+}
+
+/*
+ * Find the vendor GUID of a variable given only its (UCS-2) name, by
+ * enumerating the variable store.  Used when no 'efivar-guid' is provided.
+ */
+static int efivar_nvmem_find_guid(const efi_char16_t *want, efi_guid_t *out)
+{
+	unsigned long max = 512; /* in UCS-2 chars; variable names are short */
+	efi_char16_t *name;
+	efi_guid_t vendor = {};
+	efi_status_t status;
+	int ret = -ENODEV;
+
+	name = kcalloc(max, sizeof(*name), GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+	name[0] = 0;
+
+	for (;;) {
+		unsigned long name_size = max * sizeof(*name);
+
+		status = efivar_get_next_variable(&name_size, name, &vendor);
+		if (status == EFI_BUFFER_TOO_SMALL) {
+			efi_char16_t *tmp;
+
+			max = name_size / sizeof(*name) + 1;
+			tmp = krealloc_array(name, max, sizeof(*name), GFP_KERNEL);
+			if (!tmp) {
+				ret = -ENOMEM;
+				break;
+			}
+			name = tmp;
+			continue;
+		}
+		if (status != EFI_SUCCESS) /* EFI_NOT_FOUND ends the walk */
+			break;
+
+		if (!ucs2_strncmp(name, want, ucs2_strlen(want) + 1)) {
+			*out = vendor;
+			ret = 0;
+			break;
+		}
+	}
+
+	kfree(name);
+	return ret;
+}
+
+static int efivar_nvmem_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const char *name, *guid_str;
+	struct nvmem_config cfg = {};
+	struct efivar_nvmem *priv;
+	struct nvmem_device *nvmem;
+	efi_char16_t *name16;
+	efi_guid_t guid;
+	guid_t g;
+	unsigned long size;
+	efi_status_t status;
+	u32 attr;
+	int i, len, ret;
+	void *buf;
+
+	/*
+	 * The EFI variable service may not be a native EFI runtime service;
+	 * backends such as the Qualcomm uefisecapp driver register the
+	 * efivars operations asynchronously.  Wait for them.
+	 */
+	if (!efivar_is_available())
+		return -EPROBE_DEFER;
+
+	ret = device_property_read_string(dev, "efivar-name", &name);
+	if (ret)
+		return dev_err_probe(dev, ret, "missing 'efivar-name'\n");
+
+	/* ASCII variable name -> UCS-2 as expected by the EFI service */
+	len = strlen(name);
+	name16 = kcalloc(len + 1, sizeof(*name16), GFP_KERNEL);
+	if (!name16)
+		return -ENOMEM;
+	for (i = 0; i < len; i++)
+		name16[i] = name[i];
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		kfree(name16);
+		return -ENOMEM;
+	}
+
+	/*
+	 * The vendor GUID is optional: if it is not provided, look the
+	 * variable up by name across the whole store.  A variable that has
+	 * not been provisioned yet is reported as not found and handled
+	 * below like an erased EEPROM.
+	 */
+	if (!device_property_read_string(dev, "efivar-guid", &guid_str)) {
+		ret = guid_parse(guid_str, &g);
+		if (ret) {
+			kfree(name16);
+			return dev_err_probe(dev, ret, "invalid 'efivar-guid'\n");
+		}
+		memcpy(&guid, &g, sizeof(guid));
+		status = EFI_SUCCESS;
+	} else {
+		ret = efivar_nvmem_find_guid(name16, &guid);
+		if (ret && ret != -ENODEV) {
+			kfree(name16);
+			return dev_err_probe(dev, ret,
+					     "failed to look up variable '%s'\n",
+					     name);
+		}
+		status = ret ? EFI_NOT_FOUND : EFI_SUCCESS;
+	}
+
+	/* First attempt with a modest buffer; grow if the firmware asks. */
+	size = 512;
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf) {
+		kfree(name16);
+		return -ENOMEM;
+	}
+
+	if (status == EFI_SUCCESS) {
+		status = efivar_get_variable(name16, &guid, &attr, &size, buf);
+		if (status == EFI_BUFFER_TOO_SMALL) {
+			kfree(buf);
+			buf = kzalloc(size, GFP_KERNEL);
+			if (!buf) {
+				kfree(name16);
+				return -ENOMEM;
+			}
+			status = efivar_get_variable(name16, &guid, &attr,
+						     &size, buf);
+		}
+	}
+	kfree(name16);
+
+	if (status == EFI_NOT_FOUND) {
+		/*
+		 * Variable not provisioned yet: behave like an erased
+		 * EEPROM so that consumers still probe and fall back to
+		 * their defaults.
+		 */
+		kfree(buf);
+		size = efivar_nvmem_cells_extent(dev);
+		if (!size)
+			return dev_err_probe(dev, -ENODEV,
+					     "variable '%s' not found and no cells described\n",
+					     name);
+		buf = kzalloc(size, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+		dev_info(dev, "variable '%s' not provisioned, reading as zeroes\n",
+			 name);
+	} else if (status != EFI_SUCCESS) {
+		kfree(buf);
+		return dev_err_probe(dev, -ENODEV,
+				     "GetVariable('%s') failed: 0x%lx\n",
+				     name, status);
+	} else {
+		dev_dbg(dev, "variable '%s' attr=0x%x size=%lu\n",
+			name, attr, size);
+	}
+
+	priv->data = devm_kmemdup(dev, buf, size, GFP_KERNEL);
+	kfree(buf);
+	if (!priv->data)
+		return -ENOMEM;
+	priv->size = size;
+
+	cfg.dev			= dev;
+	cfg.name		= "efivar";
+	cfg.id			= NVMEM_DEVID_AUTO;
+	cfg.owner		= THIS_MODULE;
+	cfg.type		= NVMEM_TYPE_OTP;
+	cfg.read_only		= true;
+	cfg.word_size		= 1;
+	cfg.stride		= 1;
+	cfg.size		= priv->size;
+	cfg.reg_read		= efivar_nvmem_reg_read;
+	cfg.priv		= priv;
+	cfg.of_node		= dev->of_node;
+	cfg.add_legacy_fixed_of_cells = true;
+
+	nvmem = devm_nvmem_register(dev, &cfg);
+	return PTR_ERR_OR_ZERO(nvmem);
+}
+
+static const struct of_device_id efivar_nvmem_of_match[] = {
+	{ .compatible = "nvmem-efivar" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, efivar_nvmem_of_match);
+
+static struct platform_driver efivar_nvmem_driver = {
+	.probe = efivar_nvmem_probe,
+	.driver = {
+		.name = "nvmem-efivar",
+		.of_match_table = efivar_nvmem_of_match,
+	},
+};
+module_platform_driver(efivar_nvmem_driver);
+
+MODULE_DESCRIPTION("NVMEM provider backed by a UEFI variable");
+MODULE_IMPORT_NS("EFIVAR");
+MODULE_LICENSE("GPL");

-- 
2.54.0

