Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD0A45C71C
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 12:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389774; cv=none; b=CuEY5DEywL+C/KL76v2L6ffAuQO5uisblEfGwAbCM4cfBmNw30HgWaaLI9syOERzffNMjLomdXMafndIvAD93/hRqeysLVXfDv5L12tcYUmoYRRtZz312j87qeoNtj6aV140sFr72PktDhAw1RxMZr/PdAqsw3jAiGZs0dvloGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389774; c=relaxed/simple;
	bh=dc7qfUCGinU/jXBn9ESkvIIgl7jAIyH0P4s83OYdxig=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tr4RaD7n1m3kNVmXNi3/DllCHDW1eZByVd/8zupSaBXxPrSxBrRy2HZRMin1a6Sc8dRAd9Ki/ZTOzPhsWhL9MjU6wa0/lvXOKJGkx5ZlkI7ZlJu9wjFXYF/KGj0jdEox17A18KU5Vw+tmq10Q3SM0opm9ZJ3VIgY3bKl8CDH/p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czsxPUgg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czsxPUgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789389769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OKyE0RyPZJDROQv+G/STJ1PfSljKvjBFENS3C/wePIw=;
	b=czsxPUggOFROUovCltykh9PdNEoJS7joPDP1oD68cIxwjRcd6zADBRXYpdXOIt59TjgA83
	Kc/Hyre/jQubvCiuLvTyFtq5RYsJYDoCLO9Obwp2oOT6SuzVhMPAq8HHNM3Ey93ZA/s0sH
	Qxj3fJwbNNk5Z008ZaUAn7uZWIlVqxU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-fV9zwhI7Mryf4I95byjVBQ-1; Mon,
 14 Sep 2026 08:42:44 -0400
X-MC-Unique: fV9zwhI7Mryf4I95byjVBQ-1
X-Mimecast-MFC-AGG-ID: fV9zwhI7Mryf4I95byjVBQ_1789389763
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A181019560BE;
	Mon, 14 Sep 2026 12:42:42 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50157426;
	Mon, 14 Sep 2026 12:42:29 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 14 Sep 2026 14:41:54 +0200
Subject: [PATCH 1/3] firmware: qcom: scm: pass qcom_scm to internal helpers
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-scm-device-api-v1-1-3573e2596c51@redhat.com>
References: <20260914-scm-device-api-v1-0-3573e2596c51@redhat.com>
In-Reply-To: <20260914-scm-device-api-v1-0-3573e2596c51@redhat.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Russell King <linux@armlinux.org.uk>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, 
 Christian Loehle <christian.loehle@arm.com>, 
 Maximilian Luz <luzmaximilian@gmail.com>, 
 Bartosz Golaszewski <brgl@kernel.org>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, Sean Paul <sean@poorly.run>, 
 Akhil P Oommen <akhilpo@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, 
 Vikash Garodia <vikash.garodia@oss.qualcomm.com>, 
 Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>, 
 Bryan O'Donoghue <bod@kernel.org>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, 
 Srinivas Kandagatla <srini@kernel.org>, 
 Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>, Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jeff Johnson <jjohnson@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
 Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, 
 Brian Norris <briannorris@chromium.org>, 
 Govind Singh <govinds@codeaurora.org>, 
 Niklas Cassel <niklas.cassel@linaro.org>, Kalle Valo <kvalo@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org, 
 iommu@lists.linux.dev, linux-media@vger.kernel.org, 
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-gpio@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Maxime Ripard <mripard@kernel.org>, 
 Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789389733; l=47695;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=dc7qfUCGinU/jXBn9ESkvIIgl7jAIyH0P4s83OYdxig=;
 b=DL3mup/H++Sxr62g+wgEOdccI7Ww6gWxtXCf/txFazNuBRRTP5rNtXdL4uI4yZ78f6AaTRLap
 TebkdtG9gaFAhpla2rhHyTD0RYearL1UkgEgIky06bUlWSp4pRMMebJ
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Thread struct qcom_scm through the driver's internal helpers
instead of reaching into the __scm singleton. Recover the
instance from the SCM device where a callback only provides
struct device or reset_controller_dev.

Exported function signatures are unchanged; the wrappers still
use __scm internally.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 drivers/firmware/qcom/qcom_scm.c | 416 +++++++++++++++++++++++++--------------
 1 file changed, 263 insertions(+), 153 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 3eaa4c9ccf3c..eac779f4855d 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -176,69 +176,69 @@ static const char * const download_mode_name[] = {
 
 static struct qcom_scm *__scm;
 
-static int qcom_scm_clk_enable(void)
+static int qcom_scm_clk_enable(struct qcom_scm *scm)
 {
 	int ret;
 
-	ret = clk_prepare_enable(__scm->core_clk);
+	ret = clk_prepare_enable(scm->core_clk);
 	if (ret)
 		goto bail;
 
-	ret = clk_prepare_enable(__scm->iface_clk);
+	ret = clk_prepare_enable(scm->iface_clk);
 	if (ret)
 		goto disable_core;
 
-	ret = clk_prepare_enable(__scm->bus_clk);
+	ret = clk_prepare_enable(scm->bus_clk);
 	if (ret)
 		goto disable_iface;
 
 	return 0;
 
 disable_iface:
-	clk_disable_unprepare(__scm->iface_clk);
+	clk_disable_unprepare(scm->iface_clk);
 disable_core:
-	clk_disable_unprepare(__scm->core_clk);
+	clk_disable_unprepare(scm->core_clk);
 bail:
 	return ret;
 }
 
-static void qcom_scm_clk_disable(void)
+static void qcom_scm_clk_disable(struct qcom_scm *scm)
 {
-	clk_disable_unprepare(__scm->core_clk);
-	clk_disable_unprepare(__scm->iface_clk);
-	clk_disable_unprepare(__scm->bus_clk);
+	clk_disable_unprepare(scm->core_clk);
+	clk_disable_unprepare(scm->iface_clk);
+	clk_disable_unprepare(scm->bus_clk);
 }
 
-static int qcom_scm_bw_enable(void)
+static int qcom_scm_bw_enable(struct qcom_scm *scm)
 {
 	int ret = 0;
 
-	if (!__scm->path)
+	if (!scm->path)
 		return 0;
 
-	guard(mutex)(&__scm->scm_bw_lock);
+	guard(mutex)(&scm->scm_bw_lock);
 
-	if (!__scm->scm_vote_count) {
-		ret = icc_set_bw(__scm->path, 0, UINT_MAX);
+	if (!scm->scm_vote_count) {
+		ret = icc_set_bw(scm->path, 0, UINT_MAX);
 		if (ret < 0) {
-			dev_err(__scm->dev, "failed to set bandwidth request\n");
+			dev_err(scm->dev, "failed to set bandwidth request\n");
 			return ret;
 		}
 	}
-	__scm->scm_vote_count++;
+	scm->scm_vote_count++;
 
 	return 0;
 }
 
-static void qcom_scm_bw_disable(void)
+static void qcom_scm_bw_disable(struct qcom_scm *scm)
 {
-	if (!__scm->path)
+	if (!scm->path)
 		return;
 
-	mutex_lock(&__scm->scm_bw_lock);
-	if (__scm->scm_vote_count-- == 1)
-		icc_set_bw(__scm->path, 0, 0);
-	mutex_unlock(&__scm->scm_bw_lock);
+	mutex_lock(&scm->scm_bw_lock);
+	if (scm->scm_vote_count-- == 1)
+		icc_set_bw(scm->path, 0, 0);
+	mutex_unlock(&scm->scm_bw_lock);
 }
 
 enum qcom_scm_convention qcom_scm_convention = SMC_CONVENTION_UNKNOWN;
@@ -252,7 +252,7 @@ struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(void)
 	return __scm->mempool;
 }
 
-static enum qcom_scm_convention __get_convention(void)
+static enum qcom_scm_convention __get_convention(struct device *dev)
 {
 	unsigned long flags;
 	struct qcom_scm_desc desc = {
@@ -294,7 +294,7 @@ static enum qcom_scm_convention __get_convention(void)
 	 * early calls into the firmware on these SoCs so the device pointer
 	 * will be valid here to check if the compatible matches.
 	 */
-	if (of_device_is_compatible(__scm ? __scm->dev->of_node : NULL, "qcom,scm-sc7180")) {
+	if (of_device_is_compatible(dev ? dev->of_node : NULL, "qcom,scm-sc7180")) {
 		forced = true;
 		goto found;
 	}
@@ -332,7 +332,7 @@ static int qcom_scm_call(struct device *dev, const struct qcom_scm_desc *desc,
 			 struct qcom_scm_res *res)
 {
 	might_sleep();
-	switch (__get_convention()) {
+	switch (__get_convention(dev)) {
 	case SMC_CONVENTION_ARM_32:
 	case SMC_CONVENTION_ARM_64:
 		return scm_smc_call(dev, desc, res, false);
@@ -357,7 +357,7 @@ static int qcom_scm_call_atomic(struct device *dev,
 				const struct qcom_scm_desc *desc,
 				struct qcom_scm_res *res)
 {
-	switch (__get_convention()) {
+	switch (__get_convention(dev)) {
 	case SMC_CONVENTION_ARM_32:
 	case SMC_CONVENTION_ARM_64:
 		return scm_smc_call(dev, desc, res, true);
@@ -381,7 +381,7 @@ static bool __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
 	struct qcom_scm_res res;
 
 	desc.arginfo = QCOM_SCM_ARGS(1);
-	switch (__get_convention()) {
+	switch (__get_convention(dev)) {
 	case SMC_CONVENTION_ARM_32:
 	case SMC_CONVENTION_ARM_64:
 		desc.args[0] = SCM_SMC_FNID(svc_id, cmd_id) |
@@ -400,7 +400,7 @@ static bool __qcom_scm_is_call_available(struct device *dev, u32 svc_id,
 	return ret ? false : !!res.result[0];
 }
 
-static int qcom_scm_set_boot_addr(void *entry, const u8 *cpu_bits)
+static int qcom_scm_set_boot_addr(struct qcom_scm *scm, void *entry, const u8 *cpu_bits)
 {
 	int cpu;
 	unsigned int flags = 0;
@@ -420,10 +420,10 @@ static int qcom_scm_set_boot_addr(void *entry, const u8 *cpu_bits)
 	desc.args[0] = flags;
 	desc.args[1] = virt_to_phys(entry);
 
-	return qcom_scm_call_atomic(__scm ? __scm->dev : NULL, &desc, NULL);
+	return qcom_scm_call_atomic(scm ? scm->dev : NULL, &desc, NULL);
 }
 
-static int qcom_scm_set_boot_addr_mc(void *entry, unsigned int flags)
+static int qcom_scm_set_boot_addr_mc(struct qcom_scm *scm, void *entry, unsigned int flags)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_BOOT,
@@ -439,10 +439,10 @@ static int qcom_scm_set_boot_addr_mc(void *entry, unsigned int flags)
 	};
 
 	/* Need a device for DMA of the additional arguments */
-	if (!__scm || __get_convention() == SMC_CONVENTION_LEGACY)
+	if (!scm || __get_convention(scm->dev) == SMC_CONVENTION_LEGACY)
 		return -EOPNOTSUPP;
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 
 /**
@@ -454,9 +454,11 @@ static int qcom_scm_set_boot_addr_mc(void *entry, unsigned int flags)
  */
 int qcom_scm_set_warm_boot_addr(void *entry)
 {
-	if (qcom_scm_set_boot_addr_mc(entry, QCOM_SCM_BOOT_MC_FLAG_WARMBOOT))
+	struct qcom_scm *scm = __scm;
+
+	if (qcom_scm_set_boot_addr_mc(scm, entry, QCOM_SCM_BOOT_MC_FLAG_WARMBOOT))
 		/* Fallback to old SCM call */
-		return qcom_scm_set_boot_addr(entry, qcom_scm_cpu_warm_bits);
+		return qcom_scm_set_boot_addr(scm, entry, qcom_scm_cpu_warm_bits);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_warm_boot_addr);
@@ -467,9 +469,11 @@ EXPORT_SYMBOL_GPL(qcom_scm_set_warm_boot_addr);
  */
 int qcom_scm_set_cold_boot_addr(void *entry)
 {
-	if (qcom_scm_set_boot_addr_mc(entry, QCOM_SCM_BOOT_MC_FLAG_COLDBOOT))
+	struct qcom_scm *scm = __scm;
+
+	if (qcom_scm_set_boot_addr_mc(scm, entry, QCOM_SCM_BOOT_MC_FLAG_COLDBOOT))
 		/* Fallback to old SCM call */
-		return qcom_scm_set_boot_addr(entry, qcom_scm_cpu_cold_bits);
+		return qcom_scm_set_boot_addr(scm, entry, qcom_scm_cpu_cold_bits);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_cold_boot_addr);
@@ -484,6 +488,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_set_cold_boot_addr);
  */
 void qcom_scm_cpu_power_down(u32 flags)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_BOOT,
 		.cmd = QCOM_SCM_BOOT_TERMINATE_PC,
@@ -492,11 +498,11 @@ void qcom_scm_cpu_power_down(u32 flags)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	qcom_scm_call_atomic(__scm ? __scm->dev : NULL, &desc, NULL);
+	qcom_scm_call_atomic(scm ? scm->dev : NULL, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_cpu_power_down);
 
-static int qcom_scm_disable_sdi(void)
+static int qcom_scm_disable_sdi(struct qcom_scm *scm)
 {
 	int ret;
 	struct qcom_scm_desc desc = {
@@ -509,17 +515,17 @@ static int qcom_scm_disable_sdi(void)
 	};
 	struct qcom_scm_res res;
 
-	ret = qcom_scm_clk_enable();
+	ret = qcom_scm_clk_enable(scm);
 	if (ret)
 		return ret;
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return ret ? : res.result[0];
 }
 
-static int __qcom_scm_set_dload_mode(struct device *dev, bool enable)
+static int __qcom_scm_set_dload_mode(struct qcom_scm *scm, bool enable)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_BOOT,
@@ -531,10 +537,11 @@ static int __qcom_scm_set_dload_mode(struct device *dev, bool enable)
 
 	desc.args[1] = enable ? QCOM_SCM_BOOT_SET_DLOAD_MODE : 0;
 
-	return qcom_scm_call_atomic(__scm->dev, &desc, NULL);
+	return qcom_scm_call_atomic(scm->dev, &desc, NULL);
 }
 
-static int qcom_scm_io_rmw(phys_addr_t addr, unsigned int mask, unsigned int val)
+static int qcom_scm_io_rmw(struct qcom_scm *scm, phys_addr_t addr,
+			   unsigned int mask, unsigned int val)
 {
 	unsigned int old;
 	unsigned int new;
@@ -554,11 +561,11 @@ static void qcom_scm_set_download_mode(struct qcom_scm *scm, u32 dload_mode)
 	int ret = 0;
 
 	if (scm->dload_mode_addr) {
-		ret = qcom_scm_io_rmw(scm->dload_mode_addr, QCOM_DLOAD_MASK,
+		ret = qcom_scm_io_rmw(scm, scm->dload_mode_addr, QCOM_DLOAD_MASK,
 				      FIELD_PREP(QCOM_DLOAD_MASK, dload_mode));
 	} else if (__qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_BOOT,
 						QCOM_SCM_BOOT_SET_DLOAD_MODE)) {
-		ret = __qcom_scm_set_dload_mode(scm->dev, !!dload_mode);
+		ret = __qcom_scm_set_dload_mode(scm, !!dload_mode);
 	} else if (dload_mode) {
 		dev_err(scm->dev,
 			"No available mechanism for setting download mode\n");
@@ -607,23 +614,24 @@ static int __qcom_scm_pas_init_image(struct device *dev, u32 pas_id,
 		.args[0] = pas_id,
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	int ret;
 
-	ret = qcom_scm_clk_enable();
+	ret = qcom_scm_clk_enable(scm);
 	if (ret)
 		return ret;
 
-	ret = qcom_scm_bw_enable();
+	ret = qcom_scm_bw_enable(scm);
 	if (ret)
 		goto disable_clk;
 
 	desc.args[1] = mdata_phys;
 
 	ret = qcom_scm_call(dev, &desc, res);
-	qcom_scm_bw_disable();
+	qcom_scm_bw_disable(scm);
 
 disable_clk:
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return ret;
 }
@@ -632,12 +640,13 @@ static int qcom_scm_pas_prep_and_init_image(struct device *dev,
 					    struct qcom_pas_context *ctx,
 					    const void *metadata, size_t size)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	struct qcom_scm_res res;
 	phys_addr_t mdata_phys;
 	void *mdata_buf;
 	int ret;
 
-	mdata_buf = qcom_tzmem_alloc(__scm->mempool, size, GFP_KERNEL);
+	mdata_buf = qcom_tzmem_alloc(scm->mempool, size, GFP_KERNEL);
 	if (!mdata_buf)
 		return -ENOMEM;
 
@@ -698,7 +707,9 @@ static int __qcom_scm_pas_init_image2(struct device *dev, u32 pas_id,
 int qcom_scm_pas_init_image(u32 pas_id, const void *metadata, size_t size,
 			    struct qcom_scm_pas_context *ctx)
 {
-	return __qcom_scm_pas_init_image2(__scm->dev, pas_id, metadata, size,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_init_image2(scm->dev, pas_id, metadata, size,
 					  (struct qcom_pas_context *)ctx);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_init_image);
@@ -716,7 +727,9 @@ static void __qcom_scm_pas_metadata_release(struct device *dev,
 
 void qcom_scm_pas_metadata_release(struct qcom_scm_pas_context *ctx)
 {
-	__qcom_scm_pas_metadata_release(__scm->dev,
+	struct qcom_scm *scm = __scm;
+
+	__qcom_scm_pas_metadata_release(scm->dev,
 					(struct qcom_pas_context *)ctx);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_metadata_release);
@@ -724,6 +737,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_pas_metadata_release);
 static int __qcom_scm_pas_mem_setup(struct device *dev, u32 pas_id,
 				    phys_addr_t addr, phys_addr_t size)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	int ret;
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_PIL,
@@ -736,26 +750,28 @@ static int __qcom_scm_pas_mem_setup(struct device *dev, u32 pas_id,
 	};
 	struct qcom_scm_res res;
 
-	ret = qcom_scm_clk_enable();
+	ret = qcom_scm_clk_enable(scm);
 	if (ret)
 		return ret;
 
-	ret = qcom_scm_bw_enable();
+	ret = qcom_scm_bw_enable(scm);
 	if (ret)
 		goto disable_clk;
 
 	ret = qcom_scm_call(dev, &desc, &res);
-	qcom_scm_bw_disable();
+	qcom_scm_bw_disable(scm);
 
 disable_clk:
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return ret ? : res.result[0];
 }
 
 int qcom_scm_pas_mem_setup(u32 pas_id, phys_addr_t addr, phys_addr_t size)
 {
-	return __qcom_scm_pas_mem_setup(__scm->dev, pas_id, addr, size);
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_mem_setup(scm->dev, pas_id, addr, size);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_mem_setup);
 
@@ -764,6 +780,7 @@ static void *__qcom_scm_pas_get_rsc_table(struct device *dev, u32 pas_id,
 					  size_t input_rt_size,
 					  size_t *output_rt_size)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_PIL,
 		.cmd = QCOM_SCM_PIL_PAS_GET_RSCTABLE,
@@ -776,7 +793,7 @@ static void *__qcom_scm_pas_get_rsc_table(struct device *dev, u32 pas_id,
 	void *output_rt_tzm;
 	int ret;
 
-	output_rt_tzm = qcom_tzmem_alloc(__scm->mempool, *output_rt_size, GFP_KERNEL);
+	output_rt_tzm = qcom_tzmem_alloc(scm->mempool, *output_rt_size, GFP_KERNEL);
 	if (!output_rt_tzm)
 		return ERR_PTR(-ENOMEM);
 
@@ -818,6 +835,7 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 					   size_t input_rt_size,
 					   size_t *output_rt_size)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	struct resource_table empty_rsc = {};
 	size_t size = SZ_16K;
 	void *output_rt_tzm;
@@ -825,11 +843,11 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 	void *tbl_ptr;
 	int ret;
 
-	ret = qcom_scm_clk_enable();
+	ret = qcom_scm_clk_enable(scm);
 	if (ret)
 		return ERR_PTR(ret);
 
-	ret = qcom_scm_bw_enable();
+	ret = qcom_scm_bw_enable(scm);
 	if (ret)
 		goto disable_clk;
 
@@ -843,7 +861,7 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 		input_rt_size = sizeof(empty_rsc);
 	}
 
-	input_rt_tzm = qcom_tzmem_alloc(__scm->mempool, input_rt_size, GFP_KERNEL);
+	input_rt_tzm = qcom_tzmem_alloc(scm->mempool, input_rt_size, GFP_KERNEL);
 	if (!input_rt_tzm) {
 		ret = -ENOMEM;
 		goto disable_scm_bw;
@@ -879,10 +897,10 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 	qcom_tzmem_free(input_rt_tzm);
 
 disable_scm_bw:
-	qcom_scm_bw_disable();
+	qcom_scm_bw_disable(scm);
 
 disable_clk:
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return ret ? ERR_PTR(ret) : tbl_ptr;
 }
@@ -892,7 +910,9 @@ struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm_pas_context *c
 						  size_t input_rt_size,
 						  size_t *output_rt_size)
 {
-	return __qcom_scm_pas_get_rsc_table2(__scm->dev,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_get_rsc_table2(scm->dev,
 					     (struct qcom_pas_context *)ctx,
 					     input_rt, input_rt_size,
 					     output_rt_size);
@@ -901,6 +921,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_pas_get_rsc_table);
 
 static int __qcom_scm_pas_auth_and_reset(struct device *dev, u32 pas_id)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	int ret;
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_PIL,
@@ -911,26 +932,28 @@ static int __qcom_scm_pas_auth_and_reset(struct device *dev, u32 pas_id)
 	};
 	struct qcom_scm_res res;
 
-	ret = qcom_scm_clk_enable();
+	ret = qcom_scm_clk_enable(scm);
 	if (ret)
 		return ret;
 
-	ret = qcom_scm_bw_enable();
+	ret = qcom_scm_bw_enable(scm);
 	if (ret)
 		goto disable_clk;
 
 	ret = qcom_scm_call(dev, &desc, &res);
-	qcom_scm_bw_disable();
+	qcom_scm_bw_disable(scm);
 
 disable_clk:
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return ret ? : res.result[0];
 }
 
 int qcom_scm_pas_auth_and_reset(u32 pas_id)
 {
-	return __qcom_scm_pas_auth_and_reset(__scm->dev, pas_id);
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_auth_and_reset(scm->dev, pas_id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_auth_and_reset);
 
@@ -964,7 +987,9 @@ static int __qcom_scm_pas_prepare_and_auth_reset(struct device *dev,
 
 int qcom_scm_pas_prepare_and_auth_reset(struct qcom_scm_pas_context *ctx)
 {
-	return __qcom_scm_pas_prepare_and_auth_reset(__scm->dev,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_prepare_and_auth_reset(scm->dev,
 						     (struct qcom_pas_context *)ctx);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_prepare_and_auth_reset);
@@ -990,12 +1015,15 @@ static int __qcom_scm_pas_set_remote_state(struct device *dev, u32 state,
 
 int qcom_scm_set_remote_state(u32 state, u32 id)
 {
-	return __qcom_scm_pas_set_remote_state(__scm->dev, state, id);
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_set_remote_state(scm->dev, state, id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_remote_state);
 
 static int __qcom_scm_pas_shutdown(struct device *dev, u32 pas_id)
 {
+	struct qcom_scm *scm = dev_get_drvdata(dev);
 	int ret;
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_PIL,
@@ -1006,26 +1034,28 @@ static int __qcom_scm_pas_shutdown(struct device *dev, u32 pas_id)
 	};
 	struct qcom_scm_res res;
 
-	ret = qcom_scm_clk_enable();
+	ret = qcom_scm_clk_enable(scm);
 	if (ret)
 		return ret;
 
-	ret = qcom_scm_bw_enable();
+	ret = qcom_scm_bw_enable(scm);
 	if (ret)
 		goto disable_clk;
 
 	ret = qcom_scm_call(dev, &desc, &res);
-	qcom_scm_bw_disable();
+	qcom_scm_bw_disable(scm);
 
 disable_clk:
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return ret ? : res.result[0];
 }
 
 int qcom_scm_pas_shutdown(u32 pas_id)
 {
-	return __qcom_scm_pas_shutdown(__scm->dev, pas_id);
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_shutdown(scm->dev, pas_id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_shutdown);
 
@@ -1052,7 +1082,9 @@ static bool __qcom_scm_pas_supported(struct device *dev, u32 pas_id)
 
 bool qcom_scm_pas_supported(u32 pas_id)
 {
-	return __qcom_scm_pas_supported(__scm->dev, pas_id);
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_pas_supported(scm->dev, pas_id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_supported);
 
@@ -1075,16 +1107,16 @@ static struct qcom_pas_ops qcom_pas_ops_scm = {
  *
  * Returns true if PAS is available, otherwise false.
  */
-static bool qcom_scm_is_pas_available(void)
+static bool qcom_scm_is_pas_available(struct qcom_scm *scm)
 {
-	if (!__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_PIL,
+	if (!__qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_PIL,
 					  QCOM_SCM_PIL_PAS_AUTH_AND_RESET))
 		return false;
 
 	return true;
 }
 
-static int __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
+static int __qcom_scm_pas_mss_reset(struct qcom_scm *scm, bool reset)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_PIL,
@@ -1097,7 +1129,7 @@ static int __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
 	struct qcom_scm_res res;
 	int ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 
 	return ret ? : res.result[0];
 }
@@ -1105,19 +1137,23 @@ static int __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
 static int qcom_scm_pas_reset_assert(struct reset_controller_dev *rcdev,
 				     unsigned long idx)
 {
+	struct qcom_scm *scm = container_of(rcdev, struct qcom_scm, reset);
+
 	if (idx != 0)
 		return -EINVAL;
 
-	return __qcom_scm_pas_mss_reset(__scm->dev, 1);
+	return __qcom_scm_pas_mss_reset(scm, 1);
 }
 
 static int qcom_scm_pas_reset_deassert(struct reset_controller_dev *rcdev,
 				       unsigned long idx)
 {
+	struct qcom_scm *scm = container_of(rcdev, struct qcom_scm, reset);
+
 	if (idx != 0)
 		return -EINVAL;
 
-	return __qcom_scm_pas_mss_reset(__scm->dev, 0);
+	return __qcom_scm_pas_mss_reset(scm, 0);
 }
 
 static const struct reset_control_ops qcom_scm_pas_reset_ops = {
@@ -1127,6 +1163,8 @@ static const struct reset_control_ops qcom_scm_pas_reset_ops = {
 
 int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_IO,
 		.cmd = QCOM_SCM_IO_READ,
@@ -1138,7 +1176,7 @@ int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val)
 	int ret;
 
 
-	ret = qcom_scm_call_atomic(__scm->dev, &desc, &res);
+	ret = qcom_scm_call_atomic(scm->dev, &desc, &res);
 	if (ret >= 0)
 		*val = res.result[0];
 
@@ -1148,6 +1186,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_io_readl);
 
 int qcom_scm_io_writel(phys_addr_t addr, unsigned int val)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_IO,
 		.cmd = QCOM_SCM_IO_WRITE,
@@ -1157,7 +1197,7 @@ int qcom_scm_io_writel(phys_addr_t addr, unsigned int val)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	return qcom_scm_call_atomic(__scm->dev, &desc, NULL);
+	return qcom_scm_call_atomic(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_io_writel);
 
@@ -1169,13 +1209,17 @@ EXPORT_SYMBOL_GPL(qcom_scm_io_writel);
  */
 bool qcom_scm_restore_sec_cfg_available(void)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_MP,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_MP,
 					    QCOM_SCM_MP_RESTORE_SEC_CFG);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_restore_sec_cfg_available);
 
 int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_RESTORE_SEC_CFG,
@@ -1187,7 +1231,7 @@ int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare)
 	struct qcom_scm_res res;
 	int ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 
 	return ret ? : res.result[0];
 }
@@ -1197,13 +1241,17 @@ EXPORT_SYMBOL_GPL(qcom_scm_restore_sec_cfg);
 
 bool qcom_scm_set_gpu_smmu_aperture_is_available(void)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_MP,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_MP,
 					    QCOM_SCM_MP_CP_SMMU_APERTURE_ID);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_gpu_smmu_aperture_is_available);
 
 int qcom_scm_set_gpu_smmu_aperture(unsigned int context_bank)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_CP_SMMU_APERTURE_ID,
@@ -1215,12 +1263,14 @@ int qcom_scm_set_gpu_smmu_aperture(unsigned int context_bank)
 		.owner = ARM_SMCCC_OWNER_SIP
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_gpu_smmu_aperture);
 
 int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_IOMMU_SECURE_PTBL_SIZE,
@@ -1231,7 +1281,7 @@ int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size)
 	struct qcom_scm_res res;
 	int ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 
 	if (size)
 		*size = res.result[0];
@@ -1242,6 +1292,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_iommu_secure_ptbl_size);
 
 int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_IOMMU_SECURE_PTBL_INIT,
@@ -1254,7 +1306,7 @@ int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare)
 	};
 	int ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(scm->dev, &desc, NULL);
 
 	/* the pg table has been initialized already, ignore the error */
 	if (ret == -EPERM)
@@ -1266,6 +1318,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_iommu_secure_ptbl_init);
 
 int qcom_scm_iommu_set_cp_pool_size(u32 spare, u32 size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_IOMMU_SET_CP_POOL_SIZE,
@@ -1275,7 +1329,7 @@ int qcom_scm_iommu_set_cp_pool_size(u32 spare, u32 size)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_iommu_set_cp_pool_size);
 
@@ -1283,6 +1337,8 @@ int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
 				   u32 cp_nonpixel_start,
 				   u32 cp_nonpixel_size)
 {
+	struct qcom_scm *scm = __scm;
+
 	int ret;
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
@@ -1297,7 +1353,7 @@ int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
 	};
 	struct qcom_scm_res res;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 
 	return ret ? : res.result[0];
 }
@@ -1347,6 +1403,8 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 			const struct qcom_scm_vmperm *newvm,
 			unsigned int dest_cnt)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_current_perm_info *destvm;
 	struct qcom_scm_mem_map_info *mem_to_map;
 	phys_addr_t mem_to_map_phys;
@@ -1367,7 +1425,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	ptr_sz = ALIGN(src_sz, SZ_64) + ALIGN(mem_to_map_sz, SZ_64) +
 			ALIGN(dest_sz, SZ_64);
 
-	void *ptr __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *ptr __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 							ptr_sz, GFP_KERNEL);
 	if (!ptr)
 		return -ENOMEM;
@@ -1400,10 +1458,10 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 		next_vm |= BIT(newvm->vmid);
 	}
 
-	ret = __qcom_scm_assign_mem(__scm->dev, mem_to_map_phys, mem_to_map_sz,
+	ret = __qcom_scm_assign_mem(scm->dev, mem_to_map_phys, mem_to_map_sz,
 				    ptr_phys, src_sz, dest_phys, dest_sz);
 	if (ret) {
-		dev_err(__scm->dev,
+		dev_err(scm->dev,
 			"Assign memory protection call failed %d\n", ret);
 		return ret;
 	}
@@ -1418,7 +1476,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_assign_mem);
  */
 bool qcom_scm_ocmem_lock_available(void)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_OCMEM,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_OCMEM,
 					    QCOM_SCM_OCMEM_LOCK_CMD);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ocmem_lock_available);
@@ -1435,6 +1495,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_lock_available);
 int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset, u32 size,
 			u32 mode)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_OCMEM,
 		.cmd = QCOM_SCM_OCMEM_LOCK_CMD,
@@ -1445,7 +1507,7 @@ int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset, u32 size,
 		.arginfo = QCOM_SCM_ARGS(4),
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ocmem_lock);
 
@@ -1459,6 +1521,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_lock);
  */
 int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_OCMEM,
 		.cmd = QCOM_SCM_OCMEM_UNLOCK_CMD,
@@ -1468,7 +1532,7 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
 		.arginfo = QCOM_SCM_ARGS(3),
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
 
@@ -1480,9 +1544,11 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
  */
 bool qcom_scm_ice_available(void)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
-		__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+		__qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
@@ -1501,6 +1567,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
  */
 int qcom_scm_ice_invalidate_key(u32 index)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd = QCOM_SCM_ES_INVALIDATE_ICE_KEY,
@@ -1509,7 +1577,7 @@ int qcom_scm_ice_invalidate_key(u32 index)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
 
@@ -1537,6 +1605,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
 int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd = QCOM_SCM_ES_CONFIG_SET_ICE_KEY,
@@ -1552,7 +1622,7 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 
 	int ret;
 
-	void *keybuf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *keybuf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 							   key_size,
 							   GFP_KERNEL);
 	if (!keybuf)
@@ -1560,7 +1630,7 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 	memcpy(keybuf, key, key_size);
 	desc.args[1] = qcom_tzmem_to_phys(keybuf);
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(scm->dev, &desc, NULL);
 
 	memzero_explicit(keybuf, key_size);
 
@@ -1570,13 +1640,15 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
 
 bool qcom_scm_has_wrapped_key_support(void)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_DERIVE_SW_SECRET) &&
-	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	       __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_GENERATE_ICE_KEY) &&
-	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	       __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_PREPARE_ICE_KEY) &&
-	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	       __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_IMPORT_ICE_KEY);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
@@ -1600,6 +1672,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
 int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
 			      u8 *sw_secret, size_t sw_secret_size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd = QCOM_SCM_ES_DERIVE_SW_SECRET,
@@ -1609,13 +1683,13 @@ int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
 	};
 	int ret;
 
-	void *eph_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *eph_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 								eph_key_size,
 								GFP_KERNEL);
 	if (!eph_key_buf)
 		return -ENOMEM;
 
-	void *sw_secret_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *sw_secret_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 								  sw_secret_size,
 								  GFP_KERNEL);
 	if (!sw_secret_buf)
@@ -1627,7 +1701,7 @@ int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
 	desc.args[2] = qcom_tzmem_to_phys(sw_secret_buf);
 	desc.args[3] = sw_secret_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(scm->dev, &desc, NULL);
 	if (!ret)
 		memcpy(sw_secret, sw_secret_buf, sw_secret_size);
 
@@ -1650,6 +1724,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
  */
 int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_GENERATE_ICE_KEY,
@@ -1658,7 +1734,7 @@ int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
 	};
 	int ret;
 
-	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 							       lt_key_size,
 							       GFP_KERNEL);
 	if (!lt_key_buf)
@@ -1667,7 +1743,7 @@ int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
 	desc.args[0] = qcom_tzmem_to_phys(lt_key_buf);
 	desc.args[1] = lt_key_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(scm->dev, &desc, NULL);
 	if (!ret)
 		memcpy(lt_key, lt_key_buf, lt_key_size);
 
@@ -1692,6 +1768,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
 int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 			     u8 *eph_key, size_t eph_key_size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
@@ -1701,13 +1779,13 @@ int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 	};
 	int ret;
 
-	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 							       lt_key_size,
 							       GFP_KERNEL);
 	if (!lt_key_buf)
 		return -ENOMEM;
 
-	void *eph_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *eph_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 								eph_key_size,
 								GFP_KERNEL);
 	if (!eph_key_buf)
@@ -1719,7 +1797,7 @@ int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 	desc.args[2] = qcom_tzmem_to_phys(eph_key_buf);
 	desc.args[3] = eph_key_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(scm->dev, &desc, NULL);
 	if (!ret)
 		memcpy(eph_key, eph_key_buf, eph_key_size);
 
@@ -1745,6 +1823,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
 int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
 			    u8 *lt_key, size_t lt_key_size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_IMPORT_ICE_KEY,
@@ -1754,13 +1834,13 @@ int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
 	};
 	int ret;
 
-	void *raw_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *raw_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 								raw_key_size,
 								GFP_KERNEL);
 	if (!raw_key_buf)
 		return -ENOMEM;
 
-	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 							       lt_key_size,
 							       GFP_KERNEL);
 	if (!lt_key_buf)
@@ -1772,7 +1852,7 @@ int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
 	desc.args[2] = qcom_tzmem_to_phys(lt_key_buf);
 	desc.args[3] = lt_key_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(scm->dev, &desc, NULL);
 	if (!ret)
 		memcpy(lt_key, lt_key_buf, lt_key_size);
 
@@ -1789,16 +1869,18 @@ EXPORT_SYMBOL_GPL(qcom_scm_import_ice_key);
  */
 bool qcom_scm_hdcp_available(void)
 {
+	struct qcom_scm *scm = __scm;
+
 	bool avail;
-	int ret = qcom_scm_clk_enable();
+	int ret = qcom_scm_clk_enable(scm);
 
 	if (ret)
 		return ret;
 
-	avail = __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_HDCP,
+	avail = __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_HDCP,
 						QCOM_SCM_HDCP_INVOKE);
 
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return avail;
 }
@@ -1814,6 +1896,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_hdcp_available);
  */
 int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp)
 {
+	struct qcom_scm *scm = __scm;
+
 	int ret;
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_HDCP,
@@ -1838,14 +1922,14 @@ int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp)
 	if (req_cnt > QCOM_SCM_HDCP_MAX_REQ_CNT)
 		return -ERANGE;
 
-	ret = qcom_scm_clk_enable();
+	ret = qcom_scm_clk_enable(scm);
 	if (ret)
 		return ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 	*resp = res.result[0];
 
-	qcom_scm_clk_disable();
+	qcom_scm_clk_disable(scm);
 
 	return ret;
 }
@@ -1853,6 +1937,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_hdcp_req);
 
 int qcom_scm_iommu_set_pt_format(u32 sec_id, u32 ctx_num, u32 pt_fmt)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMMU_PROGRAM,
 		.cmd = QCOM_SCM_SMMU_PT_FORMAT,
@@ -1863,12 +1949,14 @@ int qcom_scm_iommu_set_pt_format(u32 sec_id, u32 ctx_num, u32 pt_fmt)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_iommu_set_pt_format);
 
 int qcom_scm_qsmmu500_wait_safe_toggle(bool en)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMMU_PROGRAM,
 		.cmd = QCOM_SCM_SMMU_CONFIG_ERRATA1,
@@ -1879,13 +1967,15 @@ int qcom_scm_qsmmu500_wait_safe_toggle(bool en)
 	};
 
 
-	return qcom_scm_call_atomic(__scm->dev, &desc, NULL);
+	return qcom_scm_call_atomic(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_qsmmu500_wait_safe_toggle);
 
 bool qcom_scm_lmh_dcvsh_available(void)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_LMH, QCOM_SCM_LMH_LIMIT_DCVSH);
+	struct qcom_scm *scm = __scm;
+
+	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_LMH, QCOM_SCM_LMH_LIMIT_DCVSH);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_lmh_dcvsh_available);
 
@@ -1927,6 +2017,8 @@ int qcom_scm_shm_bridge_create(u64 pfn_and_ns_perm_flags,
 			       u64 ipfn_and_s_perm_flags, u64 size_and_flags,
 			       u64 ns_vmids, u64 *handle)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_SHM_BRIDGE_CREATE,
@@ -1942,7 +2034,7 @@ int qcom_scm_shm_bridge_create(u64 pfn_and_ns_perm_flags,
 	struct qcom_scm_res res;
 	int ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 
 	if (handle && !ret)
 		*handle = res.result[1];
@@ -1953,6 +2045,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_create);
 
 int qcom_scm_shm_bridge_delete(u64 handle)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_SHM_BRIDGE_DELETE,
@@ -1961,12 +2055,14 @@ int qcom_scm_shm_bridge_delete(u64 handle)
 		.arginfo = QCOM_SCM_ARGS(1, QCOM_SCM_VAL),
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_delete);
 
 int qcom_scm_lmh_profile_change(u32 profile_id)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_LMH,
 		.cmd = QCOM_SCM_LMH_LIMIT_PROFILE_CHANGE,
@@ -1975,13 +2071,15 @@ int qcom_scm_lmh_profile_change(u32 profile_id)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_lmh_profile_change);
 
 int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
 		       u64 limit_node, u32 node_id, u64 version)
 {
+	struct qcom_scm *scm = __scm;
+
 	int ret, payload_size = 5 * sizeof(u32);
 
 	struct qcom_scm_desc desc = {
@@ -1996,7 +2094,7 @@ int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	u32 *payload_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	u32 *payload_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 							       payload_size,
 							       GFP_KERNEL);
 	if (!payload_buf)
@@ -2010,7 +2108,7 @@ int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
 
 	desc.args[0] = qcom_tzmem_to_phys(payload_buf);
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(scm->dev, &desc, NULL);
 
 	return ret;
 }
@@ -2018,6 +2116,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_lmh_dcvsh);
 
 int qcom_scm_gpu_init_regs(u32 gpu_req)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_GPU,
 		.cmd = QCOM_SCM_SVC_GPU_INIT_REGS,
@@ -2026,7 +2126,7 @@ int qcom_scm_gpu_init_regs(u32 gpu_req)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(scm->dev, &desc, NULL);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_gpu_init_regs);
 
@@ -2084,7 +2184,8 @@ static int qcom_scm_find_dload_address(struct device *dev, u64 *addr)
 /* Lock for QSEECOM SCM call executions */
 static DEFINE_MUTEX(qcom_scm_qseecom_call_lock);
 
-static int __qcom_scm_qseecom_call(const struct qcom_scm_desc *desc,
+static int __qcom_scm_qseecom_call(struct qcom_scm *scm,
+				   const struct qcom_scm_desc *desc,
 				   struct qcom_scm_qseecom_resp *res)
 {
 	struct qcom_scm_res scm_res = {};
@@ -2096,7 +2197,7 @@ static int __qcom_scm_qseecom_call(const struct qcom_scm_desc *desc,
 	 */
 	lockdep_assert_held(&qcom_scm_qseecom_call_lock);
 
-	status = qcom_scm_call(__scm->dev, desc, &scm_res);
+	status = qcom_scm_call(scm->dev, desc, &scm_res);
 
 	res->result = scm_res.result[0];
 	res->resp_type = scm_res.result[1];
@@ -2118,7 +2219,8 @@ static int __qcom_scm_qseecom_call(const struct qcom_scm_desc *desc,
  *
  * Return: Zero on success, nonzero on failure.
  */
-static int qcom_scm_qseecom_call(const struct qcom_scm_desc *desc,
+static int qcom_scm_qseecom_call(struct qcom_scm *scm,
+				 const struct qcom_scm_desc *desc,
 				 struct qcom_scm_qseecom_resp *res)
 {
 	int status;
@@ -2130,15 +2232,15 @@ static int qcom_scm_qseecom_call(const struct qcom_scm_desc *desc,
 	 */
 
 	mutex_lock(&qcom_scm_qseecom_call_lock);
-	status = __qcom_scm_qseecom_call(desc, res);
+	status = __qcom_scm_qseecom_call(scm, desc, res);
 	mutex_unlock(&qcom_scm_qseecom_call_lock);
 
-	dev_dbg(__scm->dev, "%s: owner=%x, svc=%x, cmd=%x, result=%lld, type=%llx, data=%llx\n",
+	dev_dbg(scm->dev, "%s: owner=%x, svc=%x, cmd=%x, result=%lld, type=%llx, data=%llx\n",
 		__func__, desc->owner, desc->svc, desc->cmd, res->result,
 		res->resp_type, res->data);
 
 	if (status) {
-		dev_err(__scm->dev, "qseecom: scm call failed with error %d\n", status);
+		dev_err(scm->dev, "qseecom: scm call failed with error %d\n", status);
 		return status;
 	}
 
@@ -2165,7 +2267,7 @@ static int qcom_scm_qseecom_call(const struct qcom_scm_desc *desc,
  *
  * Return: Zero on success, nonzero on failure.
  */
-static int qcom_scm_qseecom_get_version(u32 *version)
+static int qcom_scm_qseecom_get_version(struct qcom_scm *scm, u32 *version)
 {
 	struct qcom_scm_desc desc = {};
 	struct qcom_scm_qseecom_resp res = {};
@@ -2178,7 +2280,7 @@ static int qcom_scm_qseecom_get_version(u32 *version)
 	desc.arginfo = QCOM_SCM_ARGS(1, QCOM_SCM_VAL);
 	desc.args[0] = feature;
 
-	ret = qcom_scm_qseecom_call(&desc, &res);
+	ret = qcom_scm_qseecom_call(scm, &desc, &res);
 	if (ret)
 		return ret;
 
@@ -2200,6 +2302,8 @@ static int qcom_scm_qseecom_get_version(u32 *version)
  */
 int qcom_scm_qseecom_app_get_id(const char *app_name, u32 *app_id)
 {
+	struct qcom_scm *scm = __scm;
+
 	unsigned long name_buf_size = QSEECOM_MAX_APP_NAME_SIZE;
 	unsigned long app_name_len = strlen(app_name);
 	struct qcom_scm_desc desc = {};
@@ -2209,7 +2313,7 @@ int qcom_scm_qseecom_app_get_id(const char *app_name, u32 *app_id)
 	if (app_name_len >= name_buf_size)
 		return -EINVAL;
 
-	char *name_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+	char *name_buf __free(qcom_tzmem) = qcom_tzmem_alloc(scm->mempool,
 							     name_buf_size,
 							     GFP_KERNEL);
 	if (!name_buf)
@@ -2224,7 +2328,7 @@ int qcom_scm_qseecom_app_get_id(const char *app_name, u32 *app_id)
 	desc.args[0] = qcom_tzmem_to_phys(name_buf);
 	desc.args[1] = app_name_len;
 
-	status = qcom_scm_qseecom_call(&desc, &res);
+	status = qcom_scm_qseecom_call(scm, &desc, &res);
 
 	if (status)
 		return status;
@@ -2262,6 +2366,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_qseecom_app_get_id);
 int qcom_scm_qseecom_app_send(u32 app_id, void *req, size_t req_size,
 			      void *rsp, size_t rsp_size)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_qseecom_resp res = {};
 	struct qcom_scm_desc desc = {};
 	phys_addr_t req_phys;
@@ -2283,7 +2389,7 @@ int qcom_scm_qseecom_app_send(u32 app_id, void *req, size_t req_size,
 	desc.args[3] = rsp_phys;
 	desc.args[4] = rsp_size;
 
-	status = qcom_scm_qseecom_call(&desc, &res);
+	status = qcom_scm_qseecom_call(scm, &desc, &res);
 
 	if (status)
 		return status;
@@ -2363,7 +2469,7 @@ static int qcom_scm_qseecom_init(struct qcom_scm *scm)
 	 * be safe as downstream sources indicate that the version query is
 	 * neither blocking nor reentrant.
 	 */
-	ret = qcom_scm_qseecom_get_version(&version);
+	ret = qcom_scm_qseecom_get_version(scm, &version);
 	if (ret)
 		return 0;
 
@@ -2420,6 +2526,8 @@ int qcom_scm_qtee_invoke_smc(phys_addr_t inbuf, size_t inbuf_size,
 			     phys_addr_t outbuf, size_t outbuf_size,
 			     u64 *result, u64 *response_type)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMCINVOKE,
 		.cmd = QCOM_SCM_SMCINVOKE_INVOKE,
@@ -2434,7 +2542,7 @@ int qcom_scm_qtee_invoke_smc(phys_addr_t inbuf, size_t inbuf_size,
 	struct qcom_scm_res res;
 	int ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 	if (ret)
 		return ret;
 
@@ -2462,6 +2570,8 @@ EXPORT_SYMBOL(qcom_scm_qtee_invoke_smc);
 int qcom_scm_qtee_callback_response(phys_addr_t buf, size_t buf_size,
 				    u64 *result, u64 *response_type)
 {
+	struct qcom_scm *scm = __scm;
+
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMCINVOKE,
 		.cmd = QCOM_SCM_SMCINVOKE_CB_RSP,
@@ -2473,7 +2583,7 @@ int qcom_scm_qtee_callback_response(phys_addr_t buf, size_t buf_size,
 	struct qcom_scm_res res;
 	int ret;
 
-	ret = qcom_scm_call(__scm->dev, &desc, &res);
+	ret = qcom_scm_call(scm->dev, &desc, &res);
 	if (ret)
 		return ret;
 
@@ -2902,9 +3012,9 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	 */
 	smp_store_release(&__scm, scm);
 
-	__get_convention();
+	__get_convention(scm->dev);
 
-	if (qcom_scm_is_pas_available()) {
+	if (qcom_scm_is_pas_available(scm)) {
 		qcom_pas_ops_scm.dev = scm->dev;
 		qcom_pas_ops_register(&qcom_pas_ops_scm);
 	}
@@ -2920,7 +3030,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	 * Disable SDI if indicated by DT that it is enabled by default.
 	 */
 	if (of_property_read_bool(pdev->dev.of_node, "qcom,sdi-enabled") || !download_mode)
-		qcom_scm_disable_sdi();
+		qcom_scm_disable_sdi(scm);
 
 	/*
 	 * Initialize the QSEECOM interface.

-- 
2.55.0

