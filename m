Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C5D45198E
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 12:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389793; cv=none; b=gxEZSxVZn0R5+4mDUCgfVOukRvnZFDCcr8NTry4DQlKyzIGwriDamzjjeesXkBReEdAHVhiiHpvqM1zFpwDCklQMKf1meLOK30E5Ba5K3/sTnGY2sgiGCo9a/MDl9oGw4lQ9Ev/qexakoj7zROLxSXO4lnTXYcWXANYbXPkqbIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389793; c=relaxed/simple;
	bh=/av17qe0d0U4usHE68CHTblJhli4nK+FjK6SFaC+57A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NQ23m/EmEbptlL2e2uR0fGpHZiCZq+sNxoQplL9PCxJo6mM3b9ybbrB4XKN0m8epz3lXI2PPCPevrRKIpW6d1Q/X9t3lHpWn9t5+6Lwn6ALerjMKJXiTVNZ0k87HM9CqNFP1dJXwgOoyjXDWH0cDjhQwGy4yIWLvM7outKdag/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aaLj2vjq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaLj2vjq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789389784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Lwl0ctOk1+nQIiNUmeFa1JcIPb1MD1ICPzP3MncOkI=;
	b=aaLj2vjq3hnSd9XMEQ5p47kfo4pflTX+XvW6y9sI06aM6wsf8eikD/bxsRUOu6CNnRZEEO
	+gP7zyoiWHJVmx3kNzKz1Ic6qefct2cwYyNNwjfIF8jNKs9RcwYy9RCJFX/GTULyasj386
	T5aW479IG1JaxL8cFvZPi2+Yt5nV7QE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-X4MEY2T5MC2g6snPceGAbQ-1; Mon,
 14 Sep 2026 08:42:57 -0400
X-MC-Unique: X4MEY2T5MC2g6snPceGAbQ-1
X-Mimecast-MFC-AGG-ID: X4MEY2T5MC2g6snPceGAbQ_1789389776
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04A1A180134E;
	Mon, 14 Sep 2026 12:42:56 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 019B6427;
	Mon, 14 Sep 2026 12:42:42 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 14 Sep 2026 14:41:55 +0200
Subject: [PATCH 2/3] firmware: qcom: scm: pass qcom_scm through the
 exported API
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-scm-device-api-v1-2-3573e2596c51@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789389733; l=88464;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=/av17qe0d0U4usHE68CHTblJhli4nK+FjK6SFaC+57A=;
 b=UQ44gaCG55Q500deSMob+leIkVtpDSno0ae7SBkPzZW8X09YPBeJIRWFH4VlbByvo28pyx8hk
 i4y5jPHnVhZCCRHY77mlf54zO0xyZ+2q8FFzF/DVtCgp3hWzXsY0pS/
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Give exported SCM calls an explicit struct qcom_scm handle
instead of implying the global singleton.

Children of the SCM device (qseecom, tzmem, qcomtee) recover
the instance with dev_get_drvdata(). Other in-tree users call
qcom_scm_get(), which finds the bound platform device and
returns NULL until probe has published the instance.

__scm remains only for probe publication and module
parameters; the next patch removes it.

Assisted-by: LLM
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 arch/arm/mach-qcom/platsmp.c                     |   3 +-
 drivers/cpuidle/cpuidle-qcom-spm.c               |  28 ++-
 drivers/firmware/qcom/qcom_qseecom.c             |   3 +-
 drivers/firmware/qcom/qcom_scm-smc.c             |   2 +-
 drivers/firmware/qcom/qcom_scm.c                 | 277 ++++++++++-------------
 drivers/firmware/qcom/qcom_scm.h                 |   2 +-
 drivers/firmware/qcom/qcom_tzmem.c               |   6 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c            |   6 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c          |   8 +-
 drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c             |   6 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c |   9 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c       |   8 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h       |   3 +
 drivers/iommu/arm/arm-smmu/qcom_iommu.c          |  18 +-
 drivers/irqchip/qcom-pdc.c                       |   6 +-
 drivers/media/platform/qcom/venus/firmware.c     |  10 +-
 drivers/misc/fastrpc.c                           |  31 ++-
 drivers/net/wireless/ath/ath10k/qmi.c            |  12 +-
 drivers/net/wireless/ath/ath10k/qmi.h            |   3 +
 drivers/nvmem/sec-qfprom.c                       |   6 +-
 drivers/pinctrl/qcom/pinctrl-msm.c               |  11 +-
 drivers/remoteproc/qcom_q6v5_mss.c               |   6 +-
 drivers/remoteproc/qcom_q6v5_pas.c               |  12 +-
 drivers/soc/qcom/ice.c                           |  23 +-
 drivers/soc/qcom/ocmem.c                         |  22 +-
 drivers/soc/qcom/rmtfs_mem.c                     |   8 +-
 drivers/tee/qcomtee/call.c                       |   7 +
 drivers/tee/qcomtee/core.c                       |   6 +-
 drivers/tee/qcomtee/qcomtee.h                    |   2 +
 drivers/thermal/qcom/lmh.c                       |  22 +-
 include/linux/firmware/qcom/qcom_qseecom.h       |   5 +-
 include/linux/firmware/qcom/qcom_scm.h           | 117 +++++-----
 32 files changed, 389 insertions(+), 299 deletions(-)

diff --git a/arch/arm/mach-qcom/platsmp.c b/arch/arm/mach-qcom/platsmp.c
index eca2fe0f4314..c4e7aab77bc9 100644
--- a/arch/arm/mach-qcom/platsmp.c
+++ b/arch/arm/mach-qcom/platsmp.c
@@ -355,9 +355,10 @@ static int kpssv2_boot_secondary(unsigned int cpu, struct task_struct *idle)
 
 static void __init qcom_smp_prepare_cpus(unsigned int max_cpus)
 {
+	struct qcom_scm *scm = qcom_scm_get();
 	int cpu;
 
-	if (qcom_scm_set_cold_boot_addr(secondary_startup_arm)) {
+	if (!scm || qcom_scm_set_cold_boot_addr(scm, secondary_startup_arm)) {
 		for_each_present_cpu(cpu) {
 			if (cpu == smp_processor_id())
 				continue;
diff --git a/drivers/cpuidle/cpuidle-qcom-spm.c b/drivers/cpuidle/cpuidle-qcom-spm.c
index 7ab6f68b96a8..450c5b348b12 100644
--- a/drivers/cpuidle/cpuidle-qcom-spm.c
+++ b/drivers/cpuidle/cpuidle-qcom-spm.c
@@ -27,11 +27,13 @@
 struct cpuidle_qcom_spm_data {
 	struct cpuidle_driver cpuidle_driver;
 	struct spm_driver_data *spm;
+	struct qcom_scm *scm;
 };
 
-static int qcom_pm_collapse(unsigned long int unused)
+static int qcom_pm_collapse(unsigned long arg)
 {
-	qcom_scm_cpu_power_down(QCOM_SCM_CPU_PWR_DOWN_L2_ON);
+	qcom_scm_cpu_power_down((struct qcom_scm *)arg,
+				    QCOM_SCM_CPU_PWR_DOWN_L2_ON);
 
 	/*
 	 * Returns here only if there was a pending interrupt and we did not
@@ -40,19 +42,19 @@ static int qcom_pm_collapse(unsigned long int unused)
 	return -1;
 }
 
-static int qcom_cpu_spc(struct spm_driver_data *drv)
+static int qcom_cpu_spc(struct cpuidle_qcom_spm_data *data)
 {
 	int ret;
 
-	spm_set_low_power_mode(drv, PM_SLEEP_MODE_SPC);
-	ret = cpu_suspend(0, qcom_pm_collapse);
+	spm_set_low_power_mode(data->spm, PM_SLEEP_MODE_SPC);
+	ret = cpu_suspend((unsigned long)data->scm, qcom_pm_collapse);
 	/*
 	 * ARM common code executes WFI without calling into our driver and
 	 * if the SPM mode is not reset, then we may accidentally power down the
 	 * cpu when we intended only to gate the cpu clock.
 	 * Ensure the state is set to standby before returning.
 	 */
-	spm_set_low_power_mode(drv, PM_SLEEP_MODE_STBY);
+	spm_set_low_power_mode(data->spm, PM_SLEEP_MODE_STBY);
 
 	return ret;
 }
@@ -63,7 +65,7 @@ static __cpuidle int spm_enter_idle_state(struct cpuidle_device *dev,
 	struct cpuidle_qcom_spm_data *data = container_of(drv, struct cpuidle_qcom_spm_data,
 							  cpuidle_driver);
 
-	return CPU_PM_CPU_IDLE_ENTER_PARAM(qcom_cpu_spc, idx, data->spm);
+	return CPU_PM_CPU_IDLE_ENTER_PARAM(qcom_cpu_spc, idx, data);
 }
 
 static struct cpuidle_driver qcom_spm_idle_driver = {
@@ -84,7 +86,8 @@ static const struct of_device_id qcom_idle_state_match[] = {
 	{ },
 };
 
-static int spm_cpuidle_register(struct device *cpuidle_dev, int cpu)
+static int spm_cpuidle_register(struct device *cpuidle_dev, struct qcom_scm *scm,
+				int cpu)
 {
 	struct platform_device *pdev;
 	struct device_node *cpu_node, *saw_node;
@@ -116,6 +119,8 @@ static int spm_cpuidle_register(struct device *cpuidle_dev, int cpu)
 	if (!data->spm)
 		return -EINVAL;
 
+	data->scm = scm;
+
 	data->cpuidle_driver = qcom_spm_idle_driver;
 	data->cpuidle_driver.cpumask = (struct cpumask *)cpumask_of(cpu);
 
@@ -129,17 +134,18 @@ static int spm_cpuidle_register(struct device *cpuidle_dev, int cpu)
 
 static int spm_cpuidle_drv_probe(struct platform_device *pdev)
 {
+	struct qcom_scm *scm = qcom_scm_get();
 	int cpu, ret;
 
-	if (!qcom_scm_is_available())
+	if (!scm)
 		return -EPROBE_DEFER;
 
-	ret = qcom_scm_set_warm_boot_addr(cpu_resume_arm);
+	ret = qcom_scm_set_warm_boot_addr(scm, cpu_resume_arm);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "set warm boot addr failed");
 
 	for_each_present_cpu(cpu) {
-		ret = spm_cpuidle_register(&pdev->dev, cpu);
+		ret = spm_cpuidle_register(&pdev->dev, scm, cpu);
 		if (ret && ret != -ENODEV) {
 			dev_err(&pdev->dev,
 				"Cannot register for CPU%d: %d\n", cpu, ret);
diff --git a/drivers/firmware/qcom/qcom_qseecom.c b/drivers/firmware/qcom/qcom_qseecom.c
index 320ec2a77524..55a9ff361ffc 100644
--- a/drivers/firmware/qcom/qcom_qseecom.c
+++ b/drivers/firmware/qcom/qcom_qseecom.c
@@ -38,12 +38,13 @@ static void qseecom_client_remove(void *data)
 static int qseecom_client_register(struct platform_device *qseecom_dev,
 				   const struct qseecom_app_desc *desc)
 {
+	struct qcom_scm *scm = dev_get_drvdata(qseecom_dev->dev.parent);
 	struct qseecom_client *client;
 	u32 app_id;
 	int ret;
 
 	/* Try to find the app ID, skip device if not found */
-	ret = qcom_scm_qseecom_app_get_id(desc->app_name, &app_id);
+	ret = qcom_scm_qseecom_app_get_id(scm, desc->app_name, &app_id);
 	if (ret)
 		return ret == -ENOENT ? 0 : ret;
 
diff --git a/drivers/firmware/qcom/qcom_scm-smc.c b/drivers/firmware/qcom/qcom_scm-smc.c
index 127365ab11fc..08baefb47164 100644
--- a/drivers/firmware/qcom/qcom_scm-smc.c
+++ b/drivers/firmware/qcom/qcom_scm-smc.c
@@ -179,7 +179,7 @@ int __scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
 		smc.args[i + SCM_SMC_FIRST_REG_IDX] = desc->args[i];
 
 	if (unlikely(arglen > SCM_SMC_N_REG_ARGS)) {
-		struct qcom_tzmem_pool *mempool = qcom_scm_get_tzmem_pool();
+		struct qcom_tzmem_pool *mempool = qcom_scm_get_tzmem_pool(dev);
 
 		if (!mempool)
 			return -EINVAL;
diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index eac779f4855d..73e9752e3cca 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -244,12 +244,14 @@ static void qcom_scm_bw_disable(struct qcom_scm *scm)
 enum qcom_scm_convention qcom_scm_convention = SMC_CONVENTION_UNKNOWN;
 static DEFINE_SPINLOCK(scm_query_lock);
 
-struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(void)
+struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(struct device *dev)
 {
-	if (!qcom_scm_is_available())
+	struct qcom_scm *scm = dev_get_drvdata(dev);
+
+	if (!scm)
 		return NULL;
 
-	return __scm->mempool;
+	return scm->mempool;
 }
 
 static enum qcom_scm_convention __get_convention(struct device *dev)
@@ -319,6 +321,35 @@ static enum qcom_scm_convention __get_convention(struct device *dev)
 	return qcom_scm_convention;
 }
 
+static struct platform_driver qcom_scm_driver;
+
+/**
+ * qcom_scm_get() - Return the bound SCM instance, if it is ready
+ *
+ * Finds the platform device bound to this driver and returns its drvdata.
+ * Does not walk the DT for "qcom,scm". Callers that get NULL should typically
+ * return -EPROBE_DEFER. The device reference is dropped here; the pointer is
+ * valid while the SCM driver remains bound.
+ */
+struct qcom_scm *qcom_scm_get(void)
+{
+	struct device *dev;
+	struct qcom_scm *scm;
+
+	dev = driver_find_next_device(&qcom_scm_driver.driver, NULL);
+	if (!dev)
+		return NULL;
+
+	scm = dev_get_drvdata(dev);
+	put_device(dev);
+
+	if (!qcom_scm_is_available(scm))
+		return NULL;
+
+	return scm;
+}
+EXPORT_SYMBOL_GPL(qcom_scm_get);
+
 /**
  * qcom_scm_call() - Invoke a syscall in the secure world
  * @dev:	device
@@ -447,15 +478,15 @@ static int qcom_scm_set_boot_addr_mc(struct qcom_scm *scm, void *entry, unsigned
 
 /**
  * qcom_scm_set_warm_boot_addr() - Set the warm boot address for all cpus
+ *
+ * @scm:   SCM handle
  * @entry: Entry point function for the cpus
  *
  * Set the Linux entry point for the SCM to transfer control to when coming
  * out of a power down. CPU power down may be executed on cpuidle or hotplug.
  */
-int qcom_scm_set_warm_boot_addr(void *entry)
+int qcom_scm_set_warm_boot_addr(struct qcom_scm *scm, void *entry)
 {
-	struct qcom_scm *scm = __scm;
-
 	if (qcom_scm_set_boot_addr_mc(scm, entry, QCOM_SCM_BOOT_MC_FLAG_WARMBOOT))
 		/* Fallback to old SCM call */
 		return qcom_scm_set_boot_addr(scm, entry, qcom_scm_cpu_warm_bits);
@@ -465,12 +496,12 @@ EXPORT_SYMBOL_GPL(qcom_scm_set_warm_boot_addr);
 
 /**
  * qcom_scm_set_cold_boot_addr() - Set the cold boot address for all cpus
+ *
+ * @scm:   SCM handle
  * @entry: Entry point function for the cpus
  */
-int qcom_scm_set_cold_boot_addr(void *entry)
+int qcom_scm_set_cold_boot_addr(struct qcom_scm *scm, void *entry)
 {
-	struct qcom_scm *scm = __scm;
-
 	if (qcom_scm_set_boot_addr_mc(scm, entry, QCOM_SCM_BOOT_MC_FLAG_COLDBOOT))
 		/* Fallback to old SCM call */
 		return qcom_scm_set_boot_addr(scm, entry, qcom_scm_cpu_cold_bits);
@@ -480,16 +511,16 @@ EXPORT_SYMBOL_GPL(qcom_scm_set_cold_boot_addr);
 
 /**
  * qcom_scm_cpu_power_down() - Power down the cpu
+ *
+ * @scm:    SCM handle
  * @flags:	Flags to flush cache
  *
  * This is an end point to power down cpu. If there was a pending interrupt,
  * the control would return from this function, otherwise, the cpu jumps to the
  * warm boot entry point set for this cpu upon reset.
  */
-void qcom_scm_cpu_power_down(u32 flags)
+void qcom_scm_cpu_power_down(struct qcom_scm *scm, u32 flags)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_BOOT,
 		.cmd = QCOM_SCM_BOOT_TERMINATE_PC,
@@ -547,13 +578,13 @@ static int qcom_scm_io_rmw(struct qcom_scm *scm, phys_addr_t addr,
 	unsigned int new;
 	int ret;
 
-	ret = qcom_scm_io_readl(addr, &old);
+	ret = qcom_scm_io_readl(scm, addr, &old);
 	if (ret)
 		return ret;
 
 	new = (old & ~mask) | (val & mask);
 
-	return qcom_scm_io_writel(addr, new);
+	return qcom_scm_io_writel(scm, addr, new);
 }
 
 static void qcom_scm_set_download_mode(struct qcom_scm *scm, u32 dload_mode)
@@ -704,11 +735,9 @@ static int __qcom_scm_pas_init_image2(struct device *dev, u32 pas_id,
 	return ret ? : res.result[0];
 }
 
-int qcom_scm_pas_init_image(u32 pas_id, const void *metadata, size_t size,
+int qcom_scm_pas_init_image(struct qcom_scm *scm, u32 pas_id, const void *metadata, size_t size,
 			    struct qcom_scm_pas_context *ctx)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_init_image2(scm->dev, pas_id, metadata, size,
 					  (struct qcom_pas_context *)ctx);
 }
@@ -725,10 +754,8 @@ static void __qcom_scm_pas_metadata_release(struct device *dev,
 	ctx->ptr = NULL;
 }
 
-void qcom_scm_pas_metadata_release(struct qcom_scm_pas_context *ctx)
+void qcom_scm_pas_metadata_release(struct qcom_scm *scm, struct qcom_scm_pas_context *ctx)
 {
-	struct qcom_scm *scm = __scm;
-
 	__qcom_scm_pas_metadata_release(scm->dev,
 					(struct qcom_pas_context *)ctx);
 }
@@ -767,10 +794,8 @@ static int __qcom_scm_pas_mem_setup(struct device *dev, u32 pas_id,
 	return ret ? : res.result[0];
 }
 
-int qcom_scm_pas_mem_setup(u32 pas_id, phys_addr_t addr, phys_addr_t size)
+int qcom_scm_pas_mem_setup(struct qcom_scm *scm, u32 pas_id, phys_addr_t addr, phys_addr_t size)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_mem_setup(scm->dev, pas_id, addr, size);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_mem_setup);
@@ -905,13 +930,12 @@ static void *__qcom_scm_pas_get_rsc_table2(struct device *dev,
 	return ret ? ERR_PTR(ret) : tbl_ptr;
 }
 
-struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm_pas_context *ctx,
+struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm *scm,
+						  struct qcom_scm_pas_context *ctx,
 						  void *input_rt,
 						  size_t input_rt_size,
 						  size_t *output_rt_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_get_rsc_table2(scm->dev,
 					     (struct qcom_pas_context *)ctx,
 					     input_rt, input_rt_size,
@@ -949,10 +973,8 @@ static int __qcom_scm_pas_auth_and_reset(struct device *dev, u32 pas_id)
 	return ret ? : res.result[0];
 }
 
-int qcom_scm_pas_auth_and_reset(u32 pas_id)
+int qcom_scm_pas_auth_and_reset(struct qcom_scm *scm, u32 pas_id)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_auth_and_reset(scm->dev, pas_id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_auth_and_reset);
@@ -985,10 +1007,9 @@ static int __qcom_scm_pas_prepare_and_auth_reset(struct device *dev,
 	return ret;
 }
 
-int qcom_scm_pas_prepare_and_auth_reset(struct qcom_scm_pas_context *ctx)
+int qcom_scm_pas_prepare_and_auth_reset(struct qcom_scm *scm,
+					struct qcom_scm_pas_context *ctx)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_prepare_and_auth_reset(scm->dev,
 						     (struct qcom_pas_context *)ctx);
 }
@@ -1013,10 +1034,8 @@ static int __qcom_scm_pas_set_remote_state(struct device *dev, u32 state,
 	return ret ? : res.result[0];
 }
 
-int qcom_scm_set_remote_state(u32 state, u32 id)
+int qcom_scm_set_remote_state(struct qcom_scm *scm, u32 state, u32 id)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_set_remote_state(scm->dev, state, id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_remote_state);
@@ -1051,10 +1070,8 @@ static int __qcom_scm_pas_shutdown(struct device *dev, u32 pas_id)
 	return ret ? : res.result[0];
 }
 
-int qcom_scm_pas_shutdown(u32 pas_id)
+int qcom_scm_pas_shutdown(struct qcom_scm *scm, u32 pas_id)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_shutdown(scm->dev, pas_id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_shutdown);
@@ -1080,10 +1097,8 @@ static bool __qcom_scm_pas_supported(struct device *dev, u32 pas_id)
 	return ret ? false : !!res.result[0];
 }
 
-bool qcom_scm_pas_supported(u32 pas_id)
+bool qcom_scm_pas_supported(struct qcom_scm *scm, u32 pas_id)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_pas_supported(scm->dev, pas_id);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_pas_supported);
@@ -1161,10 +1176,8 @@ static const struct reset_control_ops qcom_scm_pas_reset_ops = {
 	.deassert = qcom_scm_pas_reset_deassert,
 };
 
-int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val)
+int qcom_scm_io_readl(struct qcom_scm *scm, phys_addr_t addr, unsigned int *val)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_IO,
 		.cmd = QCOM_SCM_IO_READ,
@@ -1184,10 +1197,8 @@ int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_io_readl);
 
-int qcom_scm_io_writel(phys_addr_t addr, unsigned int val)
+int qcom_scm_io_writel(struct qcom_scm *scm, phys_addr_t addr, unsigned int val)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_IO,
 		.cmd = QCOM_SCM_IO_WRITE,
@@ -1207,19 +1218,15 @@ EXPORT_SYMBOL_GPL(qcom_scm_io_writel);
  *
  * Return true if restore-cfg interface is supported, false if not.
  */
-bool qcom_scm_restore_sec_cfg_available(void)
+bool qcom_scm_restore_sec_cfg_available(struct qcom_scm *scm)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_MP,
 					    QCOM_SCM_MP_RESTORE_SEC_CFG);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_restore_sec_cfg_available);
 
-int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare)
+int qcom_scm_restore_sec_cfg(struct qcom_scm *scm, u32 device_id, u32 spare)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_RESTORE_SEC_CFG,
@@ -1239,19 +1246,15 @@ EXPORT_SYMBOL_GPL(qcom_scm_restore_sec_cfg);
 
 #define QCOM_SCM_CP_APERTURE_CONTEXT_MASK	GENMASK(7, 0)
 
-bool qcom_scm_set_gpu_smmu_aperture_is_available(void)
+bool qcom_scm_set_gpu_smmu_aperture_is_available(struct qcom_scm *scm)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_MP,
 					    QCOM_SCM_MP_CP_SMMU_APERTURE_ID);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_gpu_smmu_aperture_is_available);
 
-int qcom_scm_set_gpu_smmu_aperture(unsigned int context_bank)
+int qcom_scm_set_gpu_smmu_aperture(struct qcom_scm *scm, unsigned int context_bank)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_CP_SMMU_APERTURE_ID,
@@ -1267,10 +1270,8 @@ int qcom_scm_set_gpu_smmu_aperture(unsigned int context_bank)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_set_gpu_smmu_aperture);
 
-int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size)
+int qcom_scm_iommu_secure_ptbl_size(struct qcom_scm *scm, u32 spare, size_t *size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_IOMMU_SECURE_PTBL_SIZE,
@@ -1290,10 +1291,8 @@ int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_iommu_secure_ptbl_size);
 
-int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare)
+int qcom_scm_iommu_secure_ptbl_init(struct qcom_scm *scm, u64 addr, u32 size, u32 spare)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_IOMMU_SECURE_PTBL_INIT,
@@ -1316,10 +1315,8 @@ int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_iommu_secure_ptbl_init);
 
-int qcom_scm_iommu_set_cp_pool_size(u32 spare, u32 size)
+int qcom_scm_iommu_set_cp_pool_size(struct qcom_scm *scm, u32 spare, u32 size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_IOMMU_SET_CP_POOL_SIZE,
@@ -1333,12 +1330,10 @@ int qcom_scm_iommu_set_cp_pool_size(u32 spare, u32 size)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_iommu_set_cp_pool_size);
 
-int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
+int qcom_scm_mem_protect_video_var(struct qcom_scm *scm, u32 cp_start, u32 cp_size,
 				   u32 cp_nonpixel_start,
 				   u32 cp_nonpixel_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	int ret;
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
@@ -1388,6 +1383,8 @@ static int __qcom_scm_assign_mem(struct device *dev, phys_addr_t mem_region,
 
 /**
  * qcom_scm_assign_mem() - Make a secure call to reassign memory ownership
+ *
+ * @scm:      SCM handle
  * @mem_addr: mem region whose ownership need to be reassigned
  * @mem_sz:   size of the region.
  * @srcvm:    vmid for current set of owners, each set bit in
@@ -1398,13 +1395,11 @@ static int __qcom_scm_assign_mem(struct device *dev, phys_addr_t mem_region,
  *
  * Return negative errno on failure or 0 on success with @srcvm updated.
  */
-int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
+int qcom_scm_assign_mem(struct qcom_scm *scm, phys_addr_t mem_addr, size_t mem_sz,
 			u64 *srcvm,
 			const struct qcom_scm_vmperm *newvm,
 			unsigned int dest_cnt)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_current_perm_info *destvm;
 	struct qcom_scm_mem_map_info *mem_to_map;
 	phys_addr_t mem_to_map_phys;
@@ -1474,10 +1469,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_assign_mem);
 /**
  * qcom_scm_ocmem_lock_available() - is OCMEM lock/unlock interface available
  */
-bool qcom_scm_ocmem_lock_available(void)
+bool qcom_scm_ocmem_lock_available(struct qcom_scm *scm)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_OCMEM,
 					    QCOM_SCM_OCMEM_LOCK_CMD);
 }
@@ -1487,16 +1480,15 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_lock_available);
  * qcom_scm_ocmem_lock() - call OCMEM lock interface to assign an OCMEM
  * region to the specified initiator
  *
+ * @scm:    SCM handle
  * @id:     tz initiator id
  * @offset: OCMEM offset
  * @size:   OCMEM size
  * @mode:   access mode (WIDE/NARROW)
  */
-int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset, u32 size,
+int qcom_scm_ocmem_lock(struct qcom_scm *scm, enum qcom_scm_ocmem_client id, u32 offset, u32 size,
 			u32 mode)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_OCMEM,
 		.cmd = QCOM_SCM_OCMEM_LOCK_CMD,
@@ -1515,14 +1507,13 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_lock);
  * qcom_scm_ocmem_unlock() - call OCMEM unlock interface to release an OCMEM
  * region from the specified initiator
  *
+ * @scm:    SCM handle
  * @id:     tz initiator id
  * @offset: OCMEM offset
  * @size:   OCMEM size
  */
-int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
+int qcom_scm_ocmem_unlock(struct qcom_scm *scm, enum qcom_scm_ocmem_client id, u32 offset, u32 size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_OCMEM,
 		.cmd = QCOM_SCM_OCMEM_UNLOCK_CMD,
@@ -1542,10 +1533,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
  * Return: true iff the SCM calls wrapped by qcom_scm_ice_invalidate_key() and
  *	   qcom_scm_ice_set_key() are available.
  */
-bool qcom_scm_ice_available(void)
+bool qcom_scm_ice_available(struct qcom_scm *scm)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
 		__qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
@@ -1555,6 +1544,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
 
 /**
  * qcom_scm_ice_invalidate_key() - Invalidate an inline encryption key
+ *
+ * @scm:   SCM handle
  * @index: the keyslot to invalidate
  *
  * The UFSHCI and eMMC standards define a standard way to do this, but it
@@ -1565,10 +1556,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_ice_invalidate_key(u32 index)
+int qcom_scm_ice_invalidate_key(struct qcom_scm *scm, u32 index)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd = QCOM_SCM_ES_INVALIDATE_ICE_KEY,
@@ -1583,6 +1572,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
 
 /**
  * qcom_scm_ice_set_key() - Set an inline encryption key
+ *
+ * @scm: SCM handle
  * @index: the keyslot into which to set the key
  * @key: the key to program
  * @key_size: the size of the key in bytes
@@ -1602,11 +1593,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
+int qcom_scm_ice_set_key(struct qcom_scm *scm, u32 index, const u8 *key, u32 key_size,
 			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd = QCOM_SCM_ES_CONFIG_SET_ICE_KEY,
@@ -1638,10 +1627,8 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
 
-bool qcom_scm_has_wrapped_key_support(void)
+bool qcom_scm_has_wrapped_key_support(struct qcom_scm *scm)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_DERIVE_SW_SECRET) &&
 	       __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_ES,
@@ -1655,6 +1642,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
 
 /**
  * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
+ *
+ * @scm: SCM handle
  * @eph_key: an ephemerally-wrapped key
  * @eph_key_size: size of @eph_key in bytes
  * @sw_secret: output buffer for the software secret
@@ -1669,11 +1658,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
+int qcom_scm_derive_sw_secret(struct qcom_scm *scm, const u8 *eph_key, size_t eph_key_size,
 			      u8 *sw_secret, size_t sw_secret_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd = QCOM_SCM_ES_DERIVE_SW_SECRET,
@@ -1713,6 +1700,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
 
 /**
  * qcom_scm_generate_ice_key() - Generate a wrapped key for storage encryption
+ *
+ * @scm: SCM handle
  * @lt_key: output buffer for the long-term wrapped key
  * @lt_key_size: size of @lt_key in bytes.  Must be the exact wrapped key size
  *		 used by the SoC.
@@ -1722,10 +1711,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
+int qcom_scm_generate_ice_key(struct qcom_scm *scm, u8 *lt_key, size_t lt_key_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_GENERATE_ICE_KEY,
@@ -1754,6 +1741,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
 
 /**
  * qcom_scm_prepare_ice_key() - Re-wrap a key with the per-boot ephemeral key
+ *
+ * @scm: SCM handle
  * @lt_key: a long-term wrapped key
  * @lt_key_size: size of @lt_key in bytes
  * @eph_key: output buffer for the ephemerally-wrapped key
@@ -1765,11 +1754,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
+int qcom_scm_prepare_ice_key(struct qcom_scm *scm, const u8 *lt_key, size_t lt_key_size,
 			     u8 *eph_key, size_t eph_key_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
@@ -1809,6 +1796,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
 
 /**
  * qcom_scm_import_ice_key() - Import key for storage encryption
+ *
+ * @scm: SCM handle
  * @raw_key: the raw key to import
  * @raw_key_size: size of @raw_key in bytes
  * @lt_key: output buffer for the long-term wrapped key
@@ -1820,11 +1809,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
+int qcom_scm_import_ice_key(struct qcom_scm *scm, const u8 *raw_key, size_t raw_key_size,
 			    u8 *lt_key, size_t lt_key_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
 		.cmd =  QCOM_SCM_ES_IMPORT_ICE_KEY,
@@ -1867,10 +1854,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_import_ice_key);
  *
  * Return true if HDCP is supported, false if not.
  */
-bool qcom_scm_hdcp_available(void)
+bool qcom_scm_hdcp_available(struct qcom_scm *scm)
 {
-	struct qcom_scm *scm = __scm;
-
 	bool avail;
 	int ret = qcom_scm_clk_enable(scm);
 
@@ -1888,16 +1873,16 @@ EXPORT_SYMBOL_GPL(qcom_scm_hdcp_available);
 
 /**
  * qcom_scm_hdcp_req() - Send HDCP request.
+ *
+ * @scm: SCM handle
  * @req: HDCP request array
  * @req_cnt: HDCP request array count
  * @resp: response buffer passed to SCM
  *
  * Write HDCP register(s) through SCM.
  */
-int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp)
+int qcom_scm_hdcp_req(struct qcom_scm *scm, struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp)
 {
-	struct qcom_scm *scm = __scm;
-
 	int ret;
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_HDCP,
@@ -1935,10 +1920,8 @@ int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_hdcp_req);
 
-int qcom_scm_iommu_set_pt_format(u32 sec_id, u32 ctx_num, u32 pt_fmt)
+int qcom_scm_iommu_set_pt_format(struct qcom_scm *scm, u32 sec_id, u32 ctx_num, u32 pt_fmt)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMMU_PROGRAM,
 		.cmd = QCOM_SCM_SMMU_PT_FORMAT,
@@ -1953,10 +1936,8 @@ int qcom_scm_iommu_set_pt_format(u32 sec_id, u32 ctx_num, u32 pt_fmt)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_iommu_set_pt_format);
 
-int qcom_scm_qsmmu500_wait_safe_toggle(bool en)
+int qcom_scm_qsmmu500_wait_safe_toggle(struct qcom_scm *scm, bool en)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMMU_PROGRAM,
 		.cmd = QCOM_SCM_SMMU_CONFIG_ERRATA1,
@@ -1971,10 +1952,8 @@ int qcom_scm_qsmmu500_wait_safe_toggle(bool en)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_qsmmu500_wait_safe_toggle);
 
-bool qcom_scm_lmh_dcvsh_available(void)
+bool qcom_scm_lmh_dcvsh_available(struct qcom_scm *scm)
 {
-	struct qcom_scm *scm = __scm;
-
 	return __qcom_scm_is_call_available(scm->dev, QCOM_SCM_SVC_LMH, QCOM_SCM_LMH_LIMIT_DCVSH);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_lmh_dcvsh_available);
@@ -2013,12 +1992,10 @@ int qcom_scm_shm_bridge_enable(struct device *scm_dev)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_enable);
 
-int qcom_scm_shm_bridge_create(u64 pfn_and_ns_perm_flags,
+int qcom_scm_shm_bridge_create(struct qcom_scm *scm, u64 pfn_and_ns_perm_flags,
 			       u64 ipfn_and_s_perm_flags, u64 size_and_flags,
 			       u64 ns_vmids, u64 *handle)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_SHM_BRIDGE_CREATE,
@@ -2043,10 +2020,8 @@ int qcom_scm_shm_bridge_create(u64 pfn_and_ns_perm_flags,
 }
 EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_create);
 
-int qcom_scm_shm_bridge_delete(u64 handle)
+int qcom_scm_shm_bridge_delete(struct qcom_scm *scm, u64 handle)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
 		.cmd = QCOM_SCM_MP_SHM_BRIDGE_DELETE,
@@ -2059,10 +2034,8 @@ int qcom_scm_shm_bridge_delete(u64 handle)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_delete);
 
-int qcom_scm_lmh_profile_change(u32 profile_id)
+int qcom_scm_lmh_profile_change(struct qcom_scm *scm, u32 profile_id)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_LMH,
 		.cmd = QCOM_SCM_LMH_LIMIT_PROFILE_CHANGE,
@@ -2075,11 +2048,9 @@ int qcom_scm_lmh_profile_change(u32 profile_id)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_lmh_profile_change);
 
-int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
+int qcom_scm_lmh_dcvsh(struct qcom_scm *scm, u32 payload_fn, u32 payload_reg, u32 payload_val,
 		       u64 limit_node, u32 node_id, u64 version)
 {
-	struct qcom_scm *scm = __scm;
-
 	int ret, payload_size = 5 * sizeof(u32);
 
 	struct qcom_scm_desc desc = {
@@ -2114,10 +2085,8 @@ int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
 }
 EXPORT_SYMBOL_GPL(qcom_scm_lmh_dcvsh);
 
-int qcom_scm_gpu_init_regs(u32 gpu_req)
+int qcom_scm_gpu_init_regs(struct qcom_scm *scm, u32 gpu_req)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_GPU,
 		.cmd = QCOM_SCM_SVC_GPU_INIT_REGS,
@@ -2211,6 +2180,8 @@ static int __qcom_scm_qseecom_call(struct qcom_scm *scm,
 
 /**
  * qcom_scm_qseecom_call() - Perform a QSEECOM SCM call.
+ *
+ * @scm:  SCM handle
  * @desc: SCM call descriptor.
  * @res:  SCM call response (output).
  *
@@ -2260,6 +2231,8 @@ static int qcom_scm_qseecom_call(struct qcom_scm *scm,
 
 /**
  * qcom_scm_qseecom_get_version() - Query the QSEECOM version.
+ *
+ * @scm:     SCM handle
  * @version: Pointer where the QSEECOM version will be stored.
  *
  * Performs the QSEECOM SCM querying the QSEECOM version currently running in
@@ -2290,6 +2263,8 @@ static int qcom_scm_qseecom_get_version(struct qcom_scm *scm, u32 *version)
 
 /**
  * qcom_scm_qseecom_app_get_id() - Query the app ID for a given QSEE app name.
+ *
+ * @scm:      SCM handle
  * @app_name: The name of the app.
  * @app_id:   The returned app ID.
  *
@@ -2300,10 +2275,8 @@ static int qcom_scm_qseecom_get_version(struct qcom_scm *scm, u32 *version)
  * Return: Zero on success, nonzero on failure, -ENOENT if the app has not been
  * loaded or could not be found.
  */
-int qcom_scm_qseecom_app_get_id(const char *app_name, u32 *app_id)
+int qcom_scm_qseecom_app_get_id(struct qcom_scm *scm, const char *app_name, u32 *app_id)
 {
-	struct qcom_scm *scm = __scm;
-
 	unsigned long name_buf_size = QSEECOM_MAX_APP_NAME_SIZE;
 	unsigned long app_name_len = strlen(app_name);
 	struct qcom_scm_desc desc = {};
@@ -2349,6 +2322,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_qseecom_app_get_id);
 
 /**
  * qcom_scm_qseecom_app_send() - Send to and receive data from a given QSEE app.
+ *
+ * @scm:      SCM handle
  * @app_id:   The ID of the target app.
  * @req:      Request buffer sent to the app (must be TZ memory)
  * @req_size: Size of the request buffer.
@@ -2363,11 +2338,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_qseecom_app_get_id);
  *
  * Return: Zero on success, nonzero on failure.
  */
-int qcom_scm_qseecom_app_send(u32 app_id, void *req, size_t req_size,
+int qcom_scm_qseecom_app_send(struct qcom_scm *scm, u32 app_id, void *req, size_t req_size,
 			      void *rsp, size_t rsp_size)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_qseecom_resp res = {};
 	struct qcom_scm_desc desc = {};
 	phys_addr_t req_phys;
@@ -2510,6 +2483,8 @@ static int qcom_scm_qseecom_init(struct qcom_scm *scm)
 
 /**
  * qcom_scm_qtee_invoke_smc() - Invoke a QTEE object.
+ *
+ * @scm:     SCM handle
  * @inbuf: start address of memory area used for inbound buffer.
  * @inbuf_size: size of the memory area used for inbound buffer.
  * @outbuf: start address of memory area used for outbound buffer.
@@ -2522,12 +2497,10 @@ static int qcom_scm_qseecom_init(struct qcom_scm *scm)
  *
  * Return: On success, return 0 or <0 on failure.
  */
-int qcom_scm_qtee_invoke_smc(phys_addr_t inbuf, size_t inbuf_size,
+int qcom_scm_qtee_invoke_smc(struct qcom_scm *scm, phys_addr_t inbuf, size_t inbuf_size,
 			     phys_addr_t outbuf, size_t outbuf_size,
 			     u64 *result, u64 *response_type)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMCINVOKE,
 		.cmd = QCOM_SCM_SMCINVOKE_INVOKE,
@@ -2558,6 +2531,8 @@ EXPORT_SYMBOL(qcom_scm_qtee_invoke_smc);
 
 /**
  * qcom_scm_qtee_callback_response() - Submit response for callback request.
+ *
+ * @scm:     SCM handle
  * @buf: start address of memory area used for outbound buffer.
  * @buf_size: size of the memory area used for outbound buffer.
  * @result: Result of QTEE object invocation.
@@ -2567,11 +2542,9 @@ EXPORT_SYMBOL(qcom_scm_qtee_invoke_smc);
  *
  * Return: On success, return 0 or <0 on failure.
  */
-int qcom_scm_qtee_callback_response(phys_addr_t buf, size_t buf_size,
+int qcom_scm_qtee_callback_response(struct qcom_scm *scm, phys_addr_t buf, size_t buf_size,
 				    u64 *result, u64 *response_type)
 {
-	struct qcom_scm *scm = __scm;
-
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_SMCINVOKE,
 		.cmd = QCOM_SCM_SMCINVOKE_CB_RSP,
@@ -2665,7 +2638,7 @@ static void qcom_scm_qtee_init(struct qcom_scm *scm)
 	 * but first, it checks whether the call is supported in QTEE syscall
 	 * handler. If it is not supported, -EIO is returned.
 	 */
-	ret = qcom_scm_qtee_invoke_smc(0, 0, 0, 0, &result, &response_type);
+	ret = qcom_scm_qtee_invoke_smc(scm, 0, 0, 0, 0, &result, &response_type);
 	if (ret == -EIO)
 		return;
 
@@ -2681,10 +2654,10 @@ static void qcom_scm_qtee_init(struct qcom_scm *scm)
 /**
  * qcom_scm_is_available() - Checks if SCM is available
  */
-bool qcom_scm_is_available(void)
+bool qcom_scm_is_available(struct qcom_scm *scm)
 {
 	/* Paired with smp_store_release() in qcom_scm_probe */
-	return !!smp_load_acquire(&__scm);
+	return scm && scm == smp_load_acquire(&__scm);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_is_available);
 
diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
index cf90a565fdfb..cf2451edde14 100644
--- a/drivers/firmware/qcom/qcom_scm.h
+++ b/drivers/firmware/qcom/qcom_scm.h
@@ -82,7 +82,7 @@ int scm_legacy_call_atomic(struct device *dev, const struct qcom_scm_desc *desc,
 int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
 		    struct qcom_scm_res *res);
 
-struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(void);
+struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(struct device *dev);
 int qcom_scm_shm_bridge_enable(struct device *scm_dev);
 
 #define QCOM_SCM_SVC_BOOT		0x01
diff --git a/drivers/firmware/qcom/qcom_tzmem.c b/drivers/firmware/qcom/qcom_tzmem.c
index 0fd9581275f1..3e0147eda54c 100644
--- a/drivers/firmware/qcom/qcom_tzmem.c
+++ b/drivers/firmware/qcom/qcom_tzmem.c
@@ -125,6 +125,7 @@ static int qcom_tzmem_init(void)
  */
 int qcom_tzmem_shm_bridge_create(phys_addr_t paddr, size_t size, u64 *handle)
 {
+	struct qcom_scm *scm = dev_get_drvdata(qcom_tzmem_dev);
 	u64 pfn_and_ns_perm, ipfn_and_s_perm, size_and_flags;
 	int ret;
 
@@ -135,7 +136,7 @@ int qcom_tzmem_shm_bridge_create(phys_addr_t paddr, size_t size, u64 *handle)
 	ipfn_and_s_perm = paddr | QCOM_SCM_PERM_RW;
 	size_and_flags = size | (1 << QCOM_SHM_BRIDGE_NUM_VM_SHIFT);
 
-	ret = qcom_scm_shm_bridge_create(pfn_and_ns_perm, ipfn_and_s_perm,
+	ret = qcom_scm_shm_bridge_create(scm, pfn_and_ns_perm, ipfn_and_s_perm,
 					 size_and_flags, QCOM_SCM_VMID_HLOS,
 					 handle);
 	if (ret) {
@@ -160,8 +161,9 @@ EXPORT_SYMBOL_GPL(qcom_tzmem_shm_bridge_create);
  */
 void qcom_tzmem_shm_bridge_delete(u64 handle)
 {
+	struct qcom_scm *scm = dev_get_drvdata(qcom_tzmem_dev);
 	if (qcom_tzmem_using_shm_bridge)
-		qcom_scm_shm_bridge_delete(handle);
+		qcom_scm_shm_bridge_delete(scm, handle);
 }
 EXPORT_SYMBOL_GPL(qcom_tzmem_shm_bridge_delete);
 
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 27cac853975f..f7809e2d3cc0 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1202,6 +1202,7 @@ static int a6xx_gmu_secure_init(struct a6xx_gpu *a6xx_gpu)
 	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
 	struct msm_gpu *gpu = &adreno_gpu->base;
 	struct a6xx_gmu *gmu = &a6xx_gpu->gmu;
+	struct qcom_scm *scm;
 	u32 fuse_val;
 	int ret;
 
@@ -1217,7 +1218,8 @@ static int a6xx_gmu_secure_init(struct a6xx_gpu *a6xx_gpu)
 		 * Print a warning because if you mess this up you're about to
 		 * crash horribly.
 		 */
-		if (!qcom_scm_is_available()) {
+		scm = qcom_scm_get();
+		if (!scm) {
 			dev_warn_once(gpu->dev->dev,
 				"SCM is not available, poking fuse register\n");
 			a6xx_cx_misc_write(a6xx_gpu, REG_A7XX_CX_MISC_SW_FUSE_VALUE,
@@ -1228,7 +1230,7 @@ static int a6xx_gmu_secure_init(struct a6xx_gpu *a6xx_gpu)
 			goto done;
 		}
 
-		ret = qcom_scm_gpu_init_regs(QCOM_SCM_GPU_ALWAYS_EN_REQ |
+		ret = qcom_scm_gpu_init_regs(scm, QCOM_SCM_GPU_ALWAYS_EN_REQ |
 					     QCOM_SCM_GPU_TSENSE_EN_REQ);
 		if (ret) {
 			dev_warn_once(gpu->dev->dev,
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 8cd2020d4b7e..bdbd2d4fbd07 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -664,14 +664,16 @@ struct drm_gem_object *adreno_fw_create_bo(struct msm_gpu *gpu,
 int adreno_hw_init(struct msm_gpu *gpu)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	struct qcom_scm *scm;
 	int ret;
 
 	VERB("%s", gpu->name);
 
-	if (adreno_gpu->info->family >= ADRENO_6XX_GEN1 &&
-	    qcom_scm_set_gpu_smmu_aperture_is_available()) {
+	scm = qcom_scm_get();
+	if (scm && adreno_gpu->info->family >= ADRENO_6XX_GEN1 &&
+	    qcom_scm_set_gpu_smmu_aperture_is_available(scm)) {
 		/* We currently always use context bank 0, so hard code this */
-		ret = qcom_scm_set_gpu_smmu_aperture(0);
+		ret = qcom_scm_set_gpu_smmu_aperture(scm, 0);
 		if (ret)
 			DRM_DEV_ERROR(gpu->dev->dev, "unable to set SMMU aperture: %d\n", ret);
 	}
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c b/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c
index 7862bd67d154..426193e5ecfe 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c
@@ -47,6 +47,7 @@ struct hdmi_hdcp_reg_data {
 
 struct hdmi_hdcp_ctrl {
 	struct hdmi *hdmi;
+	struct qcom_scm *scm;
 	u32 auth_retries;
 	bool tz_hdcp;
 	enum hdmi_hdcp_state hdcp_state;
@@ -174,7 +175,7 @@ static int msm_hdmi_hdcp_scm_wr(struct hdmi_hdcp_ctrl *hdcp_ctrl, u32 *preg,
 				scm_buf[i].val  = pdata[idx];
 				idx++;
 			}
-			ret = qcom_scm_hdcp_req(scm_buf, i, &resp);
+			ret = qcom_scm_hdcp_req(hdcp_ctrl->scm, scm_buf, i, &resp);
 
 			if (ret || resp) {
 				pr_err("%s: error: scm_call ret=%d resp=%u\n",
@@ -1379,10 +1380,11 @@ struct hdmi_hdcp_ctrl *msm_hdmi_hdcp_init(struct hdmi *hdmi)
 	INIT_WORK(&hdcp_ctrl->hdcp_reauth_work, msm_hdmi_hdcp_reauth_work);
 	init_waitqueue_head(&hdcp_ctrl->auth_event_queue);
 	hdcp_ctrl->hdmi = hdmi;
+	hdcp_ctrl->scm = qcom_scm_get();
 	hdcp_ctrl->hdcp_state = HDCP_STATE_INACTIVE;
 	hdcp_ctrl->aksv_valid = false;
 
-	if (qcom_scm_hdcp_available())
+	if (hdcp_ctrl->scm && qcom_scm_hdcp_available(hdcp_ctrl->scm))
 		hdcp_ctrl->tz_hdcp = true;
 	else
 		hdcp_ctrl->tz_hdcp = false;
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
index 531b29fbf492..8d1c7aa596a7 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
@@ -76,19 +76,22 @@ void qcom_smmu_tlb_sync_debug(struct arm_smmu_device *smmu)
 		if (!cfg)
 			return;
 
-		ret = qcom_scm_io_readl(smmu->ioaddr + cfg->reg_offset[QCOM_SMMU_TBU_PWR_STATUS],
+		ret = qcom_scm_io_readl(qsmmu->scm, smmu->ioaddr +
+					cfg->reg_offset[QCOM_SMMU_TBU_PWR_STATUS],
 					&tbu_pwr_status);
 		if (ret)
 			dev_err(smmu->dev,
 				"Failed to read TBU power status: %d\n", ret);
 
-		ret = qcom_scm_io_readl(smmu->ioaddr + cfg->reg_offset[QCOM_SMMU_STATS_SYNC_INV_TBU_ACK],
+		ret = qcom_scm_io_readl(qsmmu->scm, smmu->ioaddr +
+					cfg->reg_offset[QCOM_SMMU_STATS_SYNC_INV_TBU_ACK],
 					&sync_inv_ack);
 		if (ret)
 			dev_err(smmu->dev,
 				"Failed to read TBU sync/inv ack status: %d\n", ret);
 
-		ret = qcom_scm_io_readl(smmu->ioaddr + cfg->reg_offset[QCOM_SMMU_MMU2QSS_AND_SAFE_WAIT_CNTR],
+		ret = qcom_scm_io_readl(qsmmu->scm, smmu->ioaddr +
+					cfg->reg_offset[QCOM_SMMU_MMU2QSS_AND_SAFE_WAIT_CNTR],
 					&sync_inv_progress);
 		if (ret)
 			dev_err(smmu->dev,
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 795e8ec7e8fa..32a266e7ac7f 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -591,6 +591,7 @@ static int qcom_smmu_def_domain_type(struct device *dev)
 
 static int qcom_sdm845_smmu500_reset(struct arm_smmu_device *smmu)
 {
+	struct qcom_smmu *qsmmu = to_qcom_smmu(smmu);
 	int ret;
 
 	arm_mmu500_reset(smmu);
@@ -601,7 +602,7 @@ static int qcom_sdm845_smmu500_reset(struct arm_smmu_device *smmu)
 	 * such as MTP and db845, whose firmwares implement secure monitor
 	 * call handlers to turn on/off the wait-for-safe logic.
 	 */
-	ret = qcom_scm_qsmmu500_wait_safe_toggle(0);
+	ret = qcom_scm_qsmmu500_wait_safe_toggle(qsmmu->scm, 0);
 	if (ret)
 		dev_warn(smmu->dev, "Failed to turn off SAFE logic\n");
 
@@ -668,6 +669,7 @@ static struct arm_smmu_device *qcom_smmu_create(struct arm_smmu_device *smmu,
 	const struct device_node *np = smmu->dev->of_node;
 	const struct arm_smmu_impl *impl;
 	struct qcom_smmu *qsmmu;
+	struct qcom_scm *scm;
 
 	if (!data)
 		return ERR_PTR(-EINVAL);
@@ -681,7 +683,8 @@ static struct arm_smmu_device *qcom_smmu_create(struct arm_smmu_device *smmu,
 		return smmu;
 
 	/* Check to make sure qcom_scm has finished probing */
-	if (!qcom_scm_is_available())
+	scm = qcom_scm_get();
+	if (!scm)
 		return ERR_PTR(dev_err_probe(smmu->dev, -EPROBE_DEFER,
 			"qcom_scm not ready\n"));
 
@@ -689,6 +692,7 @@ static struct arm_smmu_device *qcom_smmu_create(struct arm_smmu_device *smmu,
 	if (!qsmmu)
 		return ERR_PTR(-ENOMEM);
 
+	qsmmu->scm = scm;
 	qsmmu->smmu.impl = impl;
 	qsmmu->data = data;
 
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h
index 8addd453f5f1..852f41993416 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.h
@@ -6,8 +6,11 @@
 #ifndef _ARM_SMMU_QCOM_H
 #define _ARM_SMMU_QCOM_H
 
+struct qcom_scm;
+
 struct qcom_smmu {
 	struct arm_smmu_device smmu;
+	struct qcom_scm *scm;
 	const struct qcom_smmu_match_data *data;
 	bool bypass_quirk;
 	u8 bypass_cbndx;
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 21d18ce67b98..a98c8a3046ef 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -47,6 +47,7 @@ struct qcom_iommu_dev {
 	/* IOMMU core code handle */
 	struct iommu_device	 iommu;
 	struct device		*dev;
+	struct qcom_scm		*scm;
 	struct clk_bulk_data clks[CLK_NUM];
 	void __iomem		*local_base;
 	u32			 sec_id;
@@ -253,7 +254,8 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
 		struct qcom_iommu_ctx *ctx = to_ctx(qcom_domain, fwspec->ids[i]);
 
 		if (!ctx->secure_init) {
-			ret = qcom_scm_restore_sec_cfg(qcom_iommu->sec_id, ctx->asid);
+			ret = qcom_scm_restore_sec_cfg(qcom_iommu->scm,
+						       qcom_iommu->sec_id, ctx->asid);
 			if (ret) {
 				dev_err(qcom_iommu->dev, "secure init failed: %d\n", ret);
 				goto out_clear_iommu;
@@ -607,7 +609,7 @@ static const struct iommu_ops qcom_iommu_ops = {
 	}
 };
 
-static int qcom_iommu_sec_ptbl_init(struct device *dev)
+static int qcom_iommu_sec_ptbl_init(struct device *dev, struct qcom_scm *scm)
 {
 	size_t psize = 0;
 	unsigned int spare = 0;
@@ -620,7 +622,7 @@ static int qcom_iommu_sec_ptbl_init(struct device *dev)
 	if (allocated)
 		return 0;
 
-	ret = qcom_scm_iommu_secure_ptbl_size(spare, &psize);
+	ret = qcom_scm_iommu_secure_ptbl_size(scm, spare, &psize);
 	if (ret) {
 		dev_err(dev, "failed to get iommu secure pgtable size (%d)\n",
 			ret);
@@ -638,7 +640,7 @@ static int qcom_iommu_sec_ptbl_init(struct device *dev)
 		return -ENOMEM;
 	}
 
-	ret = qcom_scm_iommu_secure_ptbl_init(paddr, psize, spare);
+	ret = qcom_scm_iommu_secure_ptbl_init(scm, paddr, psize, spare);
 	if (ret) {
 		dev_err(dev, "failed to init iommu pgtable (%d)\n", ret);
 		goto free_mem;
@@ -794,6 +796,9 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	qcom_iommu->max_asid = max_asid;
 	qcom_iommu->dev = dev;
+	qcom_iommu->scm = qcom_scm_get();
+	if (!qcom_iommu->scm)
+		return -EPROBE_DEFER;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res) {
@@ -830,7 +835,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	}
 
 	if (qcom_iommu_has_secure_context(qcom_iommu)) {
-		ret = qcom_iommu_sec_ptbl_init(dev);
+		ret = qcom_iommu_sec_ptbl_init(dev, qcom_iommu->scm);
 		if (ret) {
 			dev_err(dev, "cannot init secure pg table(%d)\n", ret);
 			return ret;
@@ -900,7 +905,8 @@ static int __maybe_unused qcom_iommu_resume(struct device *dev)
 		return ret;
 
 	if (dev->pm_domain)
-		return qcom_scm_restore_sec_cfg(qcom_iommu->sec_id, 0);
+		return qcom_scm_restore_sec_cfg(qcom_iommu->scm,
+					qcom_iommu->sec_id, 0);
 
 	return ret;
 }
diff --git a/drivers/irqchip/qcom-pdc.c b/drivers/irqchip/qcom-pdc.c
index ce6d80c7f17a..23075a1b1fc8 100644
--- a/drivers/irqchip/qcom-pdc.c
+++ b/drivers/irqchip/qcom-pdc.c
@@ -657,6 +657,7 @@ static int qcom_pdc_probe(struct platform_device *pdev, struct device_node *pare
 	struct irq_domain *parent_domain, *pdc_domain;
 	struct device_node *node = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
+	struct qcom_scm *scm;
 	resource_size_t res_size;
 	struct resource res;
 	u32 irq_param;
@@ -716,10 +717,11 @@ static int qcom_pdc_probe(struct platform_device *pdev, struct device_node *pare
 
 		pdc->x1e_quirk = true;
 
-		if (!qcom_scm_is_available())
+		scm = qcom_scm_get();
+		if (!scm)
 			return -EPROBE_DEFER;
 
-		ret = qcom_scm_io_writel(PDC_GPIO_INT_CTL_ENABLE, PDC_PASS_THROUGH_MODE);
+		ret = qcom_scm_io_writel(scm, PDC_GPIO_INT_CTL_ENABLE, PDC_PASS_THROUGH_MODE);
 		if (ret) {
 			pdc->mode = PDC_SECONDARY_MODE;
 			pdc->unmask_gpio = pdc_unmask_gpio_cfg;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 3a38ff985822..5005e1078b03 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -214,6 +214,7 @@ int venus_boot(struct venus_core *core)
 	struct device *dev = core->dev;
 	const struct venus_resources *res = core->res;
 	const char *fwpath = NULL;
+	struct qcom_scm *scm = NULL;
 	phys_addr_t mem_phys;
 	size_t mem_size;
 	int ret;
@@ -222,6 +223,12 @@ int venus_boot(struct venus_core *core)
 	    (core->use_tz && !qcom_pas_is_available()))
 		return -EPROBE_DEFER;
 
+	if (core->use_tz && res->cp_size) {
+		scm = qcom_scm_get();
+		if (!scm)
+			return -EPROBE_DEFER;
+	}
+
 	ret = of_property_read_string_index(dev->of_node, "firmware-name", 0,
 					    &fwpath);
 	if (ret)
@@ -255,7 +262,8 @@ int venus_boot(struct venus_core *core)
 		 * cp_nonpixel_start = venus_sec_non_pixel/virtual-addr-pool[0]
 		 * cp_nonpixel_size = venus_sec_non_pixel/virtual-addr-pool[1]
 		 */
-		ret = qcom_scm_mem_protect_video_var(res->cp_start,
+		ret = qcom_scm_mem_protect_video_var(scm,
+							 res->cp_start,
 						     res->cp_size,
 						     res->cp_nonpixel_start,
 						     res->cp_nonpixel_size);
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 90fd669636ec..e8ff9d4b0395 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -302,6 +302,7 @@ struct fastrpc_soc_data {
 };
 
 struct fastrpc_channel_ctx {
+	struct qcom_scm *scm;
 	int domain_id;
 	int sesscount;
 	int vmcount;
@@ -382,7 +383,7 @@ static void fastrpc_free_map(struct kref *ref)
 	map = container_of(ref, struct fastrpc_map, refcount);
 
 	if (map->table) {
-		if (map->attr & FASTRPC_ATTR_SECUREMAP) {
+		if (map->fl->cctx->scm && map->attr & FASTRPC_ATTR_SECUREMAP) {
 			struct qcom_scm_vmperm perm;
 			int vmid = map->fl->cctx->vmperms[0].vmid;
 			u64 src_perms = BIT(QCOM_SCM_VMID_HLOS) | BIT(vmid);
@@ -390,8 +391,8 @@ static void fastrpc_free_map(struct kref *ref)
 
 			perm.vmid = QCOM_SCM_VMID_HLOS;
 			perm.perm = QCOM_SCM_PERM_RWX;
-			err = qcom_scm_assign_mem(map->dma_addr, map->len,
-				&src_perms, &perm, 1);
+			err = qcom_scm_assign_mem(map->fl->cctx->scm, map->dma_addr,
+				map->len, &src_perms, &perm, 1);
 			if (err) {
 				dev_err(map->fl->sctx->dev,
 					"Failed to assign memory dma_addr %pad size 0x%llx err %d\n",
@@ -932,7 +933,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 	map->va = sg_virt(map->table->sgl);
 	map->len = len;
 
-	if (attr & FASTRPC_ATTR_SECUREMAP) {
+	if (fl->cctx->scm && attr & FASTRPC_ATTR_SECUREMAP) {
 		/*
 		 * If subsystem VMIDs are defined in DTSI, then do
 		 * hyp_assign from HLOS to those VM(s)
@@ -945,7 +946,8 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 		dst_perms[1].vmid = fl->cctx->vmperms[0].vmid;
 		dst_perms[1].perm = QCOM_SCM_PERM_RWX;
 		map->attr = attr;
-		err = qcom_scm_assign_mem(map->dma_addr, (u64)map->len, &src_perms, dst_perms, 2);
+		err = qcom_scm_assign_mem(fl->cctx->scm, map->dma_addr, (u64)map->len,
+				&src_perms, dst_perms, 2);
 		if (err) {
 			dev_err(sess->dev,
 				"Failed to assign memory with dma_addr %pad size 0x%llx err %d\n",
@@ -1496,7 +1498,8 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
 		if (fl->cctx->vmcount) {
 			u64 src_perms = BIT(QCOM_SCM_VMID_HLOS);
 
-			err = qcom_scm_assign_mem(fl->cctx->remote_heap->dma_addr,
+			err = qcom_scm_assign_mem(fl->cctx->scm,
+							fl->cctx->remote_heap->dma_addr,
 							(u64)fl->cctx->remote_heap->size,
 							&src_perms,
 							fl->cctx->vmperms, fl->cctx->vmcount);
@@ -1551,7 +1554,8 @@ static int fastrpc_init_create_static_process(struct fastrpc_user *fl,
 
 		dst_perms.vmid = QCOM_SCM_VMID_HLOS;
 		dst_perms.perm = QCOM_SCM_PERM_RWX;
-		err = qcom_scm_assign_mem(fl->cctx->remote_heap->dma_addr,
+		err = qcom_scm_assign_mem(fl->cctx->scm,
+						fl->cctx->remote_heap->dma_addr,
 						(u64)fl->cctx->remote_heap->size,
 						&src_perms, &dst_perms, 1);
 		if (err)
@@ -2147,7 +2151,7 @@ static int fastrpc_req_mmap(struct fastrpc_user *fl, char __user *argp)
 	if (req.flags == ADSP_MMAP_REMOTE_HEAP_ADDR && fl->cctx->vmcount) {
 		u64 src_perms = BIT(QCOM_SCM_VMID_HLOS);
 
-		err = qcom_scm_assign_mem(buf->dma_addr, (u64)buf->size,
+		err = qcom_scm_assign_mem(fl->cctx->scm, buf->dma_addr, (u64)buf->size,
 			&src_perms, fl->cctx->vmperms, fl->cctx->vmcount);
 		if (err) {
 			dev_err(fl->sctx->dev,
@@ -2540,6 +2544,7 @@ static const struct of_device_id fastrpc_poll_supported_machines[] __maybe_unuse
 static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 {
 	struct device *rdev = &rpdev->dev;
+	struct qcom_scm *scm = NULL;
 	struct fastrpc_channel_ctx *data;
 	int i, err, domain_id = -1, vmcount;
 	const char *domain;
@@ -2569,13 +2574,17 @@ static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 				"qcom,vmids", &vmids[0], 0, FASTRPC_MAX_VMIDS);
 	if (vmcount < 0)
 		vmcount = 0;
-	else if (!qcom_scm_is_available())
-		return -EPROBE_DEFER;
+	else {
+		scm = qcom_scm_get();
+		if (!scm)
+			return -EPROBE_DEFER;
+	}
 
 	data = kzalloc_obj(*data);
 	if (!data)
 		return -ENOMEM;
 
+	data->scm = scm;
 	if (vmcount) {
 		data->vmcount = vmcount;
 		for (i = 0; i < data->vmcount; i++) {
@@ -2592,7 +2601,7 @@ static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 		if (!err) {
 			src_perms = BIT(QCOM_SCM_VMID_HLOS);
 
-			err = qcom_scm_assign_mem(res.start, resource_size(&res), &src_perms,
+			err = qcom_scm_assign_mem(scm, res.start, resource_size(&res), &src_perms,
 				    data->vmperms, data->vmcount);
 			if (err)
 				goto err_free_data;
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 0d74548a5f34..d95f9fed6830 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -53,7 +53,7 @@ static int ath10k_qmi_map_msa_permission(struct ath10k_qmi *qmi,
 		perm_count = 3;
 	}
 
-	ret = qcom_scm_assign_mem(mem_info->addr, mem_info->size,
+	ret = qcom_scm_assign_mem(qmi->scm, mem_info->addr, mem_info->size,
 				  &src_perms, dst_perms, perm_count);
 	if (ret < 0)
 		ath10k_err(ar, "failed to assign msa map permissions: %d\n", ret);
@@ -77,7 +77,7 @@ static int ath10k_qmi_unmap_msa_permission(struct ath10k_qmi *qmi,
 	dst_perms.vmid = QCOM_SCM_VMID_HLOS;
 	dst_perms.perm = QCOM_SCM_PERM_RW;
 
-	ret = qcom_scm_assign_mem(mem_info->addr, mem_info->size,
+	ret = qcom_scm_assign_mem(qmi->scm, mem_info->addr, mem_info->size,
 				  &src_perms, &dst_perms, 1);
 	if (ret < 0)
 		ath10k_err(ar, "failed to unmap msa permissions: %d\n", ret);
@@ -1092,6 +1092,14 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
 	if (of_property_read_bool(dev->of_node, "qcom,msa-fixed-perm"))
 		qmi->msa_fixed_perm = true;
 
+	if (!qmi->msa_fixed_perm) {
+		qmi->scm = qcom_scm_get();
+		if (!qmi->scm) {
+			ret = -EPROBE_DEFER;
+			goto err;
+		}
+	}
+
 	if (of_property_read_bool(dev->of_node, "qcom,no-msa-ready-indicator"))
 		qmi->no_msa_ready_indicator = true;
 
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index 0816eb4e4a18..fbffd6329ea4 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -14,6 +14,8 @@
 #define MAX_BUILD_ID_LEN			128
 #define MAX_NUM_CAL_V01			5
 
+struct qcom_scm;
+
 enum ath10k_qmi_driver_event_type {
 	ATH10K_QMI_EVENT_SERVER_ARRIVE,
 	ATH10K_QMI_EVENT_SERVER_EXIT,
@@ -90,6 +92,7 @@ enum ath10k_qmi_state {
 
 struct ath10k_qmi {
 	struct ath10k *ar;
+	struct qcom_scm *scm;
 	struct qmi_handle qmi_hdl;
 	struct sockaddr_qrtr sq;
 	struct work_struct event_work;
diff --git a/drivers/nvmem/sec-qfprom.c b/drivers/nvmem/sec-qfprom.c
index 51d21e65a543..abe8956b9768 100644
--- a/drivers/nvmem/sec-qfprom.c
+++ b/drivers/nvmem/sec-qfprom.c
@@ -17,6 +17,7 @@
 struct sec_qfprom {
 	phys_addr_t base;
 	struct device *dev;
+	struct qcom_scm *scm;
 };
 
 static int sec_qfprom_reg_read(void *context, unsigned int reg, void *_val, size_t bytes)
@@ -29,7 +30,7 @@ static int sec_qfprom_reg_read(void *context, unsigned int reg, void *_val, size
 
 	for (i = 0; i < bytes; i++, reg++) {
 		if (i == 0 || reg % 4 == 0) {
-			if (qcom_scm_io_readl(priv->base + (reg & ~3), &read_val)) {
+			if (qcom_scm_io_readl(priv->scm, priv->base + (reg & ~3), &read_val)) {
 				dev_err(priv->dev, "Couldn't access fuse register\n");
 				return -EINVAL;
 			}
@@ -72,6 +73,9 @@ static int sec_qfprom_probe(struct platform_device *pdev)
 	econfig.priv = priv;
 
 	priv->dev = dev;
+	priv->scm = qcom_scm_get();
+	if (!priv->scm)
+		return -EPROBE_DEFER;
 
 	nvmem = devm_nvmem_register(dev, &econfig);
 
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 27f06bbc113c..aa6c0162fbbd 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -62,6 +62,7 @@
 struct msm_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctrl;
+	struct qcom_scm *scm;
 	struct gpio_chip chip;
 	struct pinctrl_desc desc;
 
@@ -1105,11 +1106,11 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 		u32 addr = pctrl->phys_base[0] + reg;
 		int ret;
 
-		qcom_scm_io_readl(addr, &val);
+		qcom_scm_io_readl(pctrl->scm, addr, &val);
 		val &= ~(intr_target_mask << g->intr_target_bit);
 		val |= g->intr_target_kpss_val << g->intr_target_bit;
 
-		ret = qcom_scm_io_writel(addr, val);
+		ret = qcom_scm_io_writel(pctrl->scm, addr, val);
 		if (ret)
 			dev_err(pctrl->dev,
 				"Failed routing %lu interrupt to Apps proc",
@@ -1640,6 +1641,12 @@ int msm_pinctrl_probe(struct platform_device *pdev,
 	pctrl->desc.pins = pctrl->soc->pins;
 	pctrl->desc.npins = pctrl->soc->npins;
 
+	if (pctrl->intr_target_use_scm) {
+		pctrl->scm = qcom_scm_get();
+		if (!pctrl->scm)
+			return -EPROBE_DEFER;
+	}
+
 	ret = devm_pinctrl_register_and_init(&pdev->dev, &pctrl->desc,
 					     pctrl, &pctrl->pctrl);
 	if (ret)
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index bef198b9ee63..6a225569817e 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -178,6 +178,7 @@ struct rproc_hexagon_res {
 struct q6v5 {
 	struct device *dev;
 	struct rproc *rproc;
+	struct qcom_scm *scm;
 
 	void __iomem *reg_base;
 	void __iomem *rmb_base;
@@ -488,7 +489,7 @@ static int q6v5_xfer_mem_ownership(struct q6v5 *qproc, u64 *current_perm,
 		perms++;
 	}
 
-	return qcom_scm_assign_mem(addr, ALIGN(size, SZ_4K),
+	return qcom_scm_assign_mem(qproc->scm, addr, ALIGN(size, SZ_4K),
 				   current_perm, next, perms);
 }
 
@@ -2103,6 +2104,9 @@ static int q6v5_probe(struct platform_device *pdev)
 	qproc = rproc->priv;
 	qproc->dev = &pdev->dev;
 	qproc->rproc = rproc;
+	qproc->scm = qcom_scm_get();
+	if (desc->need_mem_protection && !qproc->scm)
+		return -EPROBE_DEFER;
 	qproc->hexagon_mdt_image = "modem.mdt";
 	ret = of_property_read_string_index(pdev->dev.of_node, "firmware-name",
 					    1, &qproc->hexagon_mdt_image);
diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index ca8e61254c44..3551a8f1b0dc 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -69,6 +69,7 @@ struct qcom_pas_data {
 struct qcom_pas {
 	struct device *dev;
 	struct rproc *rproc;
+	struct qcom_scm *scm;
 
 	struct qcom_q6v5 q6v5;
 
@@ -781,7 +782,8 @@ static int qcom_pas_assign_memory_region(struct qcom_pas *pas)
 		pas->region_assign_size[offset] = resource_size(&res);
 		pas->region_assign_owners[offset] = BIT(QCOM_SCM_VMID_HLOS);
 
-		ret = qcom_scm_assign_mem(pas->region_assign_phys[offset],
+		ret = qcom_scm_assign_mem(pas->scm,
+					  pas->region_assign_phys[offset],
 					  pas->region_assign_size[offset],
 					  &pas->region_assign_owners[offset],
 					  perm, perm_size);
@@ -807,7 +809,8 @@ static void qcom_pas_unassign_memory_region(struct qcom_pas *pas)
 		perm.vmid = QCOM_SCM_VMID_HLOS;
 		perm.perm = QCOM_SCM_PERM_RW;
 
-		ret = qcom_scm_assign_mem(pas->region_assign_phys[offset],
+		ret = qcom_scm_assign_mem(pas->scm,
+					  pas->region_assign_phys[offset],
 					  pas->region_assign_size[offset],
 					  &pas->region_assign_owners[offset],
 					  &perm, 1);
@@ -875,6 +878,11 @@ static int qcom_pas_probe(struct platform_device *pdev)
 	pas->region_assign_count = min_t(int, MAX_ASSIGN_COUNT, desc->region_assign_count);
 	pas->region_assign_vmid = desc->region_assign_vmid;
 	pas->region_assign_shared = desc->region_assign_shared;
+	if (pas->region_assign_idx) {
+		pas->scm = qcom_scm_get();
+		if (!pas->scm)
+			return -EPROBE_DEFER;
+	}
 	if (dtb_fw_name) {
 		pas->dtb_firmware_name = dtb_fw_name;
 		pas->dtb_pas_id = desc->dtb_pas_id;
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index e256595b9826..b28c56adb788 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -107,6 +107,7 @@ MODULE_PARM_DESC(use_wrapped_keys,
 struct qcom_ice {
 	struct device *dev;
 	void __iomem *base;
+	struct qcom_scm *scm;
 
 	struct clk *core_clk;
 	struct clk *iface_clk;
@@ -176,7 +177,7 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
 	 * advertise support for raw keys or wrapped keys, HWKM cannot be used
 	 * unconditionally.  A module parameter is used to opt into using it.
 	 */
-	if (ice->hwkm_version && qcom_scm_has_wrapped_key_support()) {
+	if (ice->hwkm_version && qcom_scm_has_wrapped_key_support(ice->scm)) {
 		if (qcom_ice_use_wrapped_keys) {
 			dev_info(dev, "Using HWKM. Supporting wrapped keys only.\n");
 			ice->use_hwkm = true;
@@ -370,7 +371,7 @@ static int qcom_ice_program_wrapped_key(struct qcom_ice *ice, unsigned int slot,
 	qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));
 
 	/* Call into TrustZone to program the wrapped key using HWKM. */
-	err = qcom_scm_ice_set_key(translate_hwkm_slot(ice, slot), bkey->bytes,
+	err = qcom_scm_ice_set_key(ice->scm, translate_hwkm_slot(ice, slot), bkey->bytes,
 				   bkey->size, cfg.capidx, cfg.dusize);
 	if (err) {
 		dev_err_ratelimited(dev,
@@ -422,7 +423,7 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 	for (i = 0; i < ARRAY_SIZE(key.words); i++)
 		__cpu_to_be32s(&key.words[i]);
 
-	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
+	err = qcom_scm_ice_set_key(ice->scm, slot, key.bytes, AES_256_XTS_KEY_SIZE,
 				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
 				   blk_key->crypto_cfg.data_unit_size / 512);
 
@@ -436,7 +437,7 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
 {
 	if (ice->hwkm_init_complete)
 		slot = translate_hwkm_slot(ice, slot);
-	return qcom_scm_ice_invalidate_key(slot);
+	return qcom_scm_ice_invalidate_key(ice->scm, slot);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
 
@@ -473,7 +474,7 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice,
 			      const u8 *eph_key, size_t eph_key_size,
 			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
 {
-	int err = qcom_scm_derive_sw_secret(eph_key, eph_key_size,
+	int err = qcom_scm_derive_sw_secret(ice->scm, eph_key, eph_key_size,
 					    sw_secret,
 					    BLK_CRYPTO_SW_SECRET_SIZE);
 	if (err == -EIO || err == -EINVAL)
@@ -496,7 +497,7 @@ int qcom_ice_generate_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_generate_ice_key(lt_key,
+	err = qcom_scm_generate_ice_key(ice->scm, lt_key,
 					QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err)
 		return err;
@@ -523,7 +524,7 @@ int qcom_ice_prepare_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_prepare_ice_key(lt_key, lt_key_size,
+	err = qcom_scm_prepare_ice_key(ice->scm, lt_key, lt_key_size,
 				       eph_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err == -EIO || err == -EINVAL)
 		err = -EBADMSG; /* probably invalid key */
@@ -551,7 +552,7 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_import_ice_key(raw_key, raw_key_size,
+	err = qcom_scm_import_ice_key(ice->scm, raw_key, raw_key_size,
 				      lt_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err)
 		return err;
@@ -563,12 +564,13 @@ EXPORT_SYMBOL_GPL(qcom_ice_import_key);
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
+	struct qcom_scm *scm = qcom_scm_get();
 	struct qcom_ice *engine;
 
-	if (!qcom_scm_is_available())
+	if (!scm)
 		return ERR_PTR(-EPROBE_DEFER);
 
-	if (!qcom_scm_ice_available()) {
+	if (!qcom_scm_ice_available(scm)) {
 		dev_warn(dev, "ICE SCM interface not found\n");
 		return ERR_PTR(-EOPNOTSUPP);
 	}
@@ -579,6 +581,7 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 
 	engine->dev = dev;
 	engine->base = base;
+	engine->scm = scm;
 
 	/*
 	 * Legacy DT binding uses different clk names for each consumer,
diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 96ca0b87bfc4..bab26eb77547 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -54,6 +54,7 @@ struct ocmem_config {
 struct ocmem {
 	struct device *dev;
 	const struct ocmem_config *config;
+	struct qcom_scm *scm;
 	struct resource *memory;
 	void __iomem *mmio;
 	struct clk *core_clk;
@@ -114,7 +115,7 @@ static void update_ocmem(struct ocmem *ocmem)
 	uint32_t region_mode_ctrl = 0x0;
 	int i;
 
-	if (!qcom_scm_ocmem_lock_available()) {
+	if (!qcom_scm_ocmem_lock_available(ocmem->scm)) {
 		for (i = 0; i < ocmem->config->num_regions; i++) {
 			struct ocmem_region *region = &ocmem->regions[i];
 
@@ -237,8 +238,8 @@ struct ocmem_buf *ocmem_allocate(struct ocmem *ocmem, enum ocmem_client client,
 
 	update_range(ocmem, buf, CORE_ON, WIDE_MODE);
 
-	if (qcom_scm_ocmem_lock_available()) {
-		ret = qcom_scm_ocmem_lock(QCOM_SCM_OCMEM_GRAPHICS_ID,
+	if (qcom_scm_ocmem_lock_available(ocmem->scm)) {
+		ret = qcom_scm_ocmem_lock(ocmem->scm, QCOM_SCM_OCMEM_GRAPHICS_ID,
 					  buf->offset, buf->len, WIDE_MODE);
 		if (ret) {
 			dev_err(ocmem->dev, "could not lock: %d\n", ret);
@@ -272,10 +273,10 @@ void ocmem_free(struct ocmem *ocmem, enum ocmem_client client,
 
 	update_range(ocmem, buf, CLK_OFF, MODE_DEFAULT);
 
-	if (qcom_scm_ocmem_lock_available()) {
+	if (qcom_scm_ocmem_lock_available(ocmem->scm)) {
 		int ret;
 
-		ret = qcom_scm_ocmem_unlock(QCOM_SCM_OCMEM_GRAPHICS_ID,
+		ret = qcom_scm_ocmem_unlock(ocmem->scm, QCOM_SCM_OCMEM_GRAPHICS_ID,
 					    buf->offset, buf->len);
 		if (ret)
 			dev_err(ocmem->dev, "could not unlock: %d\n", ret);
@@ -297,9 +298,6 @@ static int ocmem_dev_probe(struct platform_device *pdev)
 	int i, j, ret, num_banks;
 	struct ocmem *ocmem;
 
-	if (!qcom_scm_is_available())
-		return -EPROBE_DEFER;
-
 	ocmem = devm_kzalloc(dev, sizeof(*ocmem), GFP_KERNEL);
 	if (!ocmem)
 		return -ENOMEM;
@@ -307,6 +305,10 @@ static int ocmem_dev_probe(struct platform_device *pdev)
 	ocmem->dev = dev;
 	ocmem->config = device_get_match_data(dev);
 
+	ocmem->scm = qcom_scm_get();
+	if (!ocmem->scm)
+		return -EPROBE_DEFER;
+
 	ocmem->core_clk = devm_clk_get_optional(dev, "core");
 	if (IS_ERR(ocmem->core_clk))
 		return dev_err_probe(dev, PTR_ERR(ocmem->core_clk),
@@ -342,9 +344,9 @@ static int ocmem_dev_probe(struct platform_device *pdev)
 		return dev_err_probe(ocmem->dev, ret, "Failed to enable iface clock\n");
 	}
 
-	if (qcom_scm_restore_sec_cfg_available()) {
+	if (qcom_scm_restore_sec_cfg_available(ocmem->scm)) {
 		dev_dbg(dev, "configuring scm\n");
-		ret = qcom_scm_restore_sec_cfg(QCOM_SCM_OCMEM_DEV_ID, 0);
+		ret = qcom_scm_restore_sec_cfg(ocmem->scm, QCOM_SCM_OCMEM_DEV_ID, 0);
 		if (ret) {
 			dev_err_probe(dev, ret, "Could not enable secure configuration\n");
 			goto err_clk_disable;
diff --git a/drivers/soc/qcom/rmtfs_mem.c b/drivers/soc/qcom/rmtfs_mem.c
index 342c0845134e..10c15dd4d513 100644
--- a/drivers/soc/qcom/rmtfs_mem.c
+++ b/drivers/soc/qcom/rmtfs_mem.c
@@ -24,6 +24,7 @@ static dev_t qcom_rmtfs_mem_major;
 struct qcom_rmtfs_mem {
 	struct device dev;
 	struct cdev cdev;
+	struct qcom_scm *scm;
 
 	void *base;
 	phys_addr_t addr;
@@ -256,7 +257,8 @@ static int qcom_rmtfs_mem_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to parse qcom,vmid\n");
 		goto remove_cdev;
 	} else if (!ret) {
-		if (!qcom_scm_is_available()) {
+		rmtfs_mem->scm = qcom_scm_get();
+		if (!rmtfs_mem->scm) {
 			ret = -EPROBE_DEFER;
 			goto remove_cdev;
 		}
@@ -270,7 +272,7 @@ static int qcom_rmtfs_mem_probe(struct platform_device *pdev)
 		}
 
 		rmtfs_mem->perms = BIT(QCOM_SCM_VMID_HLOS);
-		ret = qcom_scm_assign_mem(rmtfs_mem->addr, rmtfs_mem->size,
+		ret = qcom_scm_assign_mem(rmtfs_mem->scm, rmtfs_mem->addr, rmtfs_mem->size,
 					  &rmtfs_mem->perms, perms, num_vmids + 1);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "assign memory failed\n");
@@ -299,7 +301,7 @@ static void qcom_rmtfs_mem_remove(struct platform_device *pdev)
 		perm.vmid = QCOM_SCM_VMID_HLOS;
 		perm.perm = QCOM_SCM_PERM_RW;
 
-		qcom_scm_assign_mem(rmtfs_mem->addr, rmtfs_mem->size,
+		qcom_scm_assign_mem(rmtfs_mem->scm, rmtfs_mem->addr, rmtfs_mem->size,
 				    &rmtfs_mem->perms, &perm, 1);
 	}
 
diff --git a/drivers/tee/qcomtee/call.c b/drivers/tee/qcomtee/call.c
index 4a597eeaf174..11e414cc7e6a 100644
--- a/drivers/tee/qcomtee/call.c
+++ b/drivers/tee/qcomtee/call.c
@@ -725,6 +725,13 @@ static int qcomtee_probe(struct platform_device *pdev)
 
 	qcomtee->teedev = teedev;
 	qcomtee->pool = pool;
+	qcomtee->scm = dev_get_drvdata(pdev->dev.parent);
+	if (!qcomtee->scm) {
+		err = -ENODEV;
+
+		goto err_unreg_teedev;
+	}
+
 	err = tee_device_register(qcomtee->teedev);
 	if (err)
 		goto err_unreg_teedev;
diff --git a/drivers/tee/qcomtee/core.c b/drivers/tee/qcomtee/core.c
index 60fe3b5776e3..1d4fa79b4a8b 100644
--- a/drivers/tee/qcomtee/core.c
+++ b/drivers/tee/qcomtee/core.c
@@ -683,6 +683,7 @@ static int
 qcomtee_object_invoke_ctx_invoke(struct qcomtee_object_invoke_ctx *oic,
 				 int *result, u64 *res_type)
 {
+	struct qcomtee *qcomtee = tee_get_drvdata(oic->ctx->teedev);
 	phys_addr_t out_msg_paddr;
 	phys_addr_t in_msg_paddr;
 	int ret;
@@ -691,11 +692,12 @@ qcomtee_object_invoke_ctx_invoke(struct qcomtee_object_invoke_ctx *oic,
 	tee_shm_get_pa(oic->out_shm, 0, &out_msg_paddr);
 	tee_shm_get_pa(oic->in_shm, 0, &in_msg_paddr);
 	if (!(oic->flags & QCOMTEE_OIC_FLAG_BUSY))
-		ret = qcom_scm_qtee_invoke_smc(in_msg_paddr, oic->in_msg.size,
+		ret = qcom_scm_qtee_invoke_smc(qcomtee->scm, in_msg_paddr,
+						   oic->in_msg.size,
 					       out_msg_paddr, oic->out_msg.size,
 					       &res, res_type);
 	else
-		ret = qcom_scm_qtee_callback_response(out_msg_paddr,
+		ret = qcom_scm_qtee_callback_response(qcomtee->scm, out_msg_paddr,
 						      oic->out_msg.size,
 						      &res, res_type);
 
diff --git a/drivers/tee/qcomtee/qcomtee.h b/drivers/tee/qcomtee/qcomtee.h
index f39bf63fd1c2..da1bcc2773d8 100644
--- a/drivers/tee/qcomtee/qcomtee.h
+++ b/drivers/tee/qcomtee/qcomtee.h
@@ -22,6 +22,7 @@
  * @teedev: client device.
  * @pool: shared memory pool.
  * @ctx: driver private context.
+ * @scm: SCM handle.
  * @oic: context to use for the current driver invocation.
  * @wq: workqueue for QTEE async operations.
  * @xa_local_objects: array of objects exported to QTEE.
@@ -32,6 +33,7 @@ struct qcomtee {
 	struct tee_device *teedev;
 	struct tee_shm_pool *pool;
 	struct tee_context *ctx;
+	struct qcom_scm *scm;
 	struct qcomtee_object_invoke_ctx oic;
 	struct workqueue_struct *wq;
 	struct xarray xa_local_objects;
diff --git a/drivers/thermal/qcom/lmh.c b/drivers/thermal/qcom/lmh.c
index 99396b93eff5..7181d44725e5 100644
--- a/drivers/thermal/qcom/lmh.c
+++ b/drivers/thermal/qcom/lmh.c
@@ -98,13 +98,15 @@ static int lmh_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
+	struct qcom_scm *scm;
 	struct device_node *cpu_node;
 	struct lmh_hw_data *lmh_data;
 	int temp_low, temp_high, temp_arm, cpu_id, ret;
 	unsigned int enable_alg;
 	u32 node_id;
 
-	if (!qcom_scm_is_available())
+	scm = qcom_scm_get();
+	if (!scm)
 		return -EPROBE_DEFER;
 
 	lmh_data = devm_kzalloc(dev, sizeof(*lmh_data), GFP_KERNEL);
@@ -153,35 +155,35 @@ static int lmh_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!qcom_scm_lmh_dcvsh_available())
+	if (!qcom_scm_lmh_dcvsh_available(scm))
 		return -EINVAL;
 
 	enable_alg = (uintptr_t)of_device_get_match_data(dev);
 
 	if (enable_alg) {
-		ret = qcom_scm_lmh_dcvsh(LMH_SUB_FN_CRNT, LMH_ALGO_MODE_ENABLE, 1,
+		ret = qcom_scm_lmh_dcvsh(scm, LMH_SUB_FN_CRNT, LMH_ALGO_MODE_ENABLE, 1,
 					 LMH_NODE_DCVS, node_id, 0);
 		if (ret)
 			dev_err(dev, "Error %d enabling current subfunction\n", ret);
 
-		ret = qcom_scm_lmh_dcvsh(LMH_SUB_FN_REL, LMH_ALGO_MODE_ENABLE, 1,
+		ret = qcom_scm_lmh_dcvsh(scm, LMH_SUB_FN_REL, LMH_ALGO_MODE_ENABLE, 1,
 					 LMH_NODE_DCVS, node_id, 0);
 		if (ret)
 			dev_err(dev, "Error %d enabling reliability subfunction\n", ret);
 
-		ret = qcom_scm_lmh_dcvsh(LMH_SUB_FN_BCL, LMH_ALGO_MODE_ENABLE, 1,
+		ret = qcom_scm_lmh_dcvsh(scm, LMH_SUB_FN_BCL, LMH_ALGO_MODE_ENABLE, 1,
 					 LMH_NODE_DCVS, node_id, 0);
 		if (ret)
 			dev_err(dev, "Error %d enabling BCL subfunction\n", ret);
 
-		ret = qcom_scm_lmh_dcvsh(LMH_SUB_FN_THERMAL, LMH_ALGO_MODE_ENABLE, 1,
+		ret = qcom_scm_lmh_dcvsh(scm, LMH_SUB_FN_THERMAL, LMH_ALGO_MODE_ENABLE, 1,
 					 LMH_NODE_DCVS, node_id, 0);
 		if (ret) {
 			dev_err(dev, "Error %d enabling thermal subfunction\n", ret);
 			return ret;
 		}
 
-		ret = qcom_scm_lmh_profile_change(0x1);
+		ret = qcom_scm_lmh_profile_change(scm, 0x1);
 		if (ret) {
 			dev_err(dev, "Error %d changing profile\n", ret);
 			return ret;
@@ -189,21 +191,21 @@ static int lmh_probe(struct platform_device *pdev)
 	}
 
 	/* Set default thermal trips */
-	ret = qcom_scm_lmh_dcvsh(LMH_SUB_FN_THERMAL, LMH_TH_ARM_THRESHOLD, temp_arm,
+	ret = qcom_scm_lmh_dcvsh(scm, LMH_SUB_FN_THERMAL, LMH_TH_ARM_THRESHOLD, temp_arm,
 				 LMH_NODE_DCVS, node_id, 0);
 	if (ret) {
 		dev_err(dev, "Error setting thermal ARM threshold%d\n", ret);
 		return ret;
 	}
 
-	ret = qcom_scm_lmh_dcvsh(LMH_SUB_FN_THERMAL, LMH_TH_HI_THRESHOLD, temp_high,
+	ret = qcom_scm_lmh_dcvsh(scm, LMH_SUB_FN_THERMAL, LMH_TH_HI_THRESHOLD, temp_high,
 				 LMH_NODE_DCVS, node_id, 0);
 	if (ret) {
 		dev_err(dev, "Error setting thermal HI threshold%d\n", ret);
 		return ret;
 	}
 
-	ret = qcom_scm_lmh_dcvsh(LMH_SUB_FN_THERMAL, LMH_TH_LOW_THRESHOLD, temp_low,
+	ret = qcom_scm_lmh_dcvsh(scm, LMH_SUB_FN_THERMAL, LMH_TH_LOW_THRESHOLD, temp_low,
 				 LMH_NODE_DCVS, node_id, 0);
 	if (ret) {
 		dev_err(dev, "Error setting thermal LOW threshold%d\n", ret);
diff --git a/include/linux/firmware/qcom/qcom_qseecom.h b/include/linux/firmware/qcom/qcom_qseecom.h
index 3387897bf368..272602d80366 100644
--- a/include/linux/firmware/qcom/qcom_qseecom.h
+++ b/include/linux/firmware/qcom/qcom_qseecom.h
@@ -10,6 +10,7 @@
 #define __QCOM_QSEECOM_H
 
 #include <linux/auxiliary_bus.h>
+#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/types.h>
 
@@ -48,7 +49,9 @@ static inline int qcom_qseecom_app_send(struct qseecom_client *client,
 					void *req, size_t req_size,
 					void *rsp, size_t rsp_size)
 {
-	return qcom_scm_qseecom_app_send(client->app_id, req, req_size, rsp, rsp_size);
+	struct qcom_scm *scm = dev_get_drvdata(client->aux_dev.dev.parent->parent);
+
+	return qcom_scm_qseecom_app_send(scm, client->app_id, req, req_size, rsp, rsp_size);
 }
 
 #endif /* __QCOM_QSEECOM_H */
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index 5747bd191bf1..9c513fe6f0ea 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -59,12 +59,15 @@ enum qcom_scm_ice_cipher {
 #define QCOM_SCM_PERM_RW (QCOM_SCM_PERM_READ | QCOM_SCM_PERM_WRITE)
 #define QCOM_SCM_PERM_RWX (QCOM_SCM_PERM_RW | QCOM_SCM_PERM_EXEC)
 
-bool qcom_scm_is_available(void);
+struct qcom_scm;
 
-int qcom_scm_set_cold_boot_addr(void *entry);
-int qcom_scm_set_warm_boot_addr(void *entry);
-void qcom_scm_cpu_power_down(u32 flags);
-int qcom_scm_set_remote_state(u32 state, u32 id);
+struct qcom_scm *qcom_scm_get(void);
+bool qcom_scm_is_available(struct qcom_scm *scm);
+
+int qcom_scm_set_cold_boot_addr(struct qcom_scm *scm, void *entry);
+int qcom_scm_set_warm_boot_addr(struct qcom_scm *scm, void *entry);
+void qcom_scm_cpu_power_down(struct qcom_scm *scm, u32 flags);
+int qcom_scm_set_remote_state(struct qcom_scm *scm, u32 state, u32 id);
 
 struct qcom_scm_pas_context {
 	struct device *dev;
@@ -81,63 +84,68 @@ struct qcom_scm_pas_context *devm_qcom_scm_pas_context_alloc(struct device *dev,
 							     u32 pas_id,
 							     phys_addr_t mem_phys,
 							     size_t mem_size);
-int qcom_scm_pas_init_image(u32 pas_id, const void *metadata, size_t size,
-			    struct qcom_scm_pas_context *ctx);
-void qcom_scm_pas_metadata_release(struct qcom_scm_pas_context *ctx);
-int qcom_scm_pas_mem_setup(u32 pas_id, phys_addr_t addr, phys_addr_t size);
-int qcom_scm_pas_auth_and_reset(u32 pas_id);
-int qcom_scm_pas_shutdown(u32 pas_id);
-bool qcom_scm_pas_supported(u32 pas_id);
-struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm_pas_context *ctx,
+int qcom_scm_pas_init_image(struct qcom_scm *scm, u32 pas_id, const void *metadata,
+			    size_t size, struct qcom_scm_pas_context *ctx);
+void qcom_scm_pas_metadata_release(struct qcom_scm *scm, struct qcom_scm_pas_context *ctx);
+int qcom_scm_pas_mem_setup(struct qcom_scm *scm, u32 pas_id, phys_addr_t addr,
+			   phys_addr_t size);
+int qcom_scm_pas_auth_and_reset(struct qcom_scm *scm, u32 pas_id);
+int qcom_scm_pas_shutdown(struct qcom_scm *scm, u32 pas_id);
+bool qcom_scm_pas_supported(struct qcom_scm *scm, u32 pas_id);
+struct resource_table *qcom_scm_pas_get_rsc_table(struct qcom_scm *scm,
+						  struct qcom_scm_pas_context *ctx,
 						  void *input_rt, size_t input_rt_size,
 						  size_t *output_rt_size);
 
-int qcom_scm_pas_prepare_and_auth_reset(struct qcom_scm_pas_context *ctx);
+int qcom_scm_pas_prepare_and_auth_reset(struct qcom_scm *scm,
+					struct qcom_scm_pas_context *ctx);
 
-int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val);
-int qcom_scm_io_writel(phys_addr_t addr, unsigned int val);
+int qcom_scm_io_readl(struct qcom_scm *scm, phys_addr_t addr, unsigned int *val);
+int qcom_scm_io_writel(struct qcom_scm *scm, phys_addr_t addr, unsigned int val);
 
-bool qcom_scm_restore_sec_cfg_available(void);
-int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare);
-int qcom_scm_set_gpu_smmu_aperture(unsigned int context_bank);
-bool qcom_scm_set_gpu_smmu_aperture_is_available(void);
-int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size);
-int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare);
-int qcom_scm_iommu_set_cp_pool_size(u32 spare, u32 size);
-int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
+bool qcom_scm_restore_sec_cfg_available(struct qcom_scm *scm);
+int qcom_scm_restore_sec_cfg(struct qcom_scm *scm, u32 device_id, u32 spare);
+int qcom_scm_set_gpu_smmu_aperture(struct qcom_scm *scm, unsigned int context_bank);
+bool qcom_scm_set_gpu_smmu_aperture_is_available(struct qcom_scm *scm);
+int qcom_scm_iommu_secure_ptbl_size(struct qcom_scm *scm, u32 spare, size_t *size);
+int qcom_scm_iommu_secure_ptbl_init(struct qcom_scm *scm, u64 addr, u32 size, u32 spare);
+int qcom_scm_iommu_set_cp_pool_size(struct qcom_scm *scm, u32 spare, u32 size);
+int qcom_scm_mem_protect_video_var(struct qcom_scm *scm, u32 cp_start, u32 cp_size,
 				   u32 cp_nonpixel_start, u32 cp_nonpixel_size);
-int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz, u64 *src,
-			const struct qcom_scm_vmperm *newvm,
+int qcom_scm_assign_mem(struct qcom_scm *scm, phys_addr_t mem_addr, size_t mem_sz,
+			u64 *src, const struct qcom_scm_vmperm *newvm,
 			unsigned int dest_cnt);
 
-bool qcom_scm_ocmem_lock_available(void);
-int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset, u32 size,
-			u32 mode);
-int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size);
+bool qcom_scm_ocmem_lock_available(struct qcom_scm *scm);
+int qcom_scm_ocmem_lock(struct qcom_scm *scm, enum qcom_scm_ocmem_client id, u32 offset,
+			u32 size, u32 mode);
+int qcom_scm_ocmem_unlock(struct qcom_scm *scm, enum qcom_scm_ocmem_client id, u32 offset,
+			  u32 size);
 
-bool qcom_scm_ice_available(void);
-int qcom_scm_ice_invalidate_key(u32 index);
-int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
+bool qcom_scm_ice_available(struct qcom_scm *scm);
+int qcom_scm_ice_invalidate_key(struct qcom_scm *scm, u32 index);
+int qcom_scm_ice_set_key(struct qcom_scm *scm, u32 index, const u8 *key, u32 key_size,
 			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size);
-bool qcom_scm_has_wrapped_key_support(void);
-int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
+bool qcom_scm_has_wrapped_key_support(struct qcom_scm *scm);
+int qcom_scm_derive_sw_secret(struct qcom_scm *scm, const u8 *eph_key, size_t eph_key_size,
 			      u8 *sw_secret, size_t sw_secret_size);
-int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size);
-int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
+int qcom_scm_generate_ice_key(struct qcom_scm *scm, u8 *lt_key, size_t lt_key_size);
+int qcom_scm_prepare_ice_key(struct qcom_scm *scm, const u8 *lt_key, size_t lt_key_size,
 			     u8 *eph_key, size_t eph_key_size);
-int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
+int qcom_scm_import_ice_key(struct qcom_scm *scm, const u8 *raw_key, size_t raw_key_size,
 			    u8 *lt_key, size_t lt_key_size);
 
-bool qcom_scm_hdcp_available(void);
-int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);
+bool qcom_scm_hdcp_available(struct qcom_scm *scm);
+int qcom_scm_hdcp_req(struct qcom_scm *scm, struct qcom_scm_hdcp_req *req, u32 req_cnt,
+		      u32 *resp);
 
-int qcom_scm_iommu_set_pt_format(u32 sec_id, u32 ctx_num, u32 pt_fmt);
-int qcom_scm_qsmmu500_wait_safe_toggle(bool en);
+int qcom_scm_iommu_set_pt_format(struct qcom_scm *scm, u32 sec_id, u32 ctx_num, u32 pt_fmt);
+int qcom_scm_qsmmu500_wait_safe_toggle(struct qcom_scm *scm, bool en);
 
-int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
+int qcom_scm_lmh_dcvsh(struct qcom_scm *scm, u32 payload_fn, u32 payload_reg, u32 payload_val,
 		       u64 limit_node, u32 node_id, u64 version);
-int qcom_scm_lmh_profile_change(u32 profile_id);
-bool qcom_scm_lmh_dcvsh_available(void);
+int qcom_scm_lmh_profile_change(struct qcom_scm *scm, u32 profile_id);
+bool qcom_scm_lmh_dcvsh_available(struct qcom_scm *scm);
 
 /*
  * Request TZ to program set of access controlled registers necessary
@@ -160,27 +168,28 @@ bool qcom_scm_lmh_dcvsh_available(void);
  */
 #define QCOM_SCM_GPU_TSENSE_EN_REQ BIT(3)
 
-int qcom_scm_gpu_init_regs(u32 gpu_req);
+int qcom_scm_gpu_init_regs(struct qcom_scm *scm, u32 gpu_req);
 
-int qcom_scm_shm_bridge_create(u64 pfn_and_ns_perm_flags,
+int qcom_scm_shm_bridge_create(struct qcom_scm *scm, u64 pfn_and_ns_perm_flags,
 			       u64 ipfn_and_s_perm_flags, u64 size_and_flags,
 			       u64 ns_vmids, u64 *handle);
-int qcom_scm_shm_bridge_delete(u64 handle);
+int qcom_scm_shm_bridge_delete(struct qcom_scm *scm, u64 handle);
 
 #ifdef CONFIG_QCOM_QSEECOM
 
-int qcom_scm_qseecom_app_get_id(const char *app_name, u32 *app_id);
-int qcom_scm_qseecom_app_send(u32 app_id, void *req, size_t req_size,
+int qcom_scm_qseecom_app_get_id(struct qcom_scm *scm, const char *app_name, u32 *app_id);
+int qcom_scm_qseecom_app_send(struct qcom_scm *scm, u32 app_id, void *req, size_t req_size,
 			      void *rsp, size_t rsp_size);
 
 #else /* CONFIG_QCOM_QSEECOM */
 
-static inline int qcom_scm_qseecom_app_get_id(const char *app_name, u32 *app_id)
+static inline int qcom_scm_qseecom_app_get_id(struct qcom_scm *scm, const char *app_name,
+					      u32 *app_id)
 {
 	return -EINVAL;
 }
 
-static inline int qcom_scm_qseecom_app_send(u32 app_id,
+static inline int qcom_scm_qseecom_app_send(struct qcom_scm *scm, u32 app_id,
 					    void *req, size_t req_size,
 					    void *rsp, size_t rsp_size)
 {
@@ -189,10 +198,10 @@ static inline int qcom_scm_qseecom_app_send(u32 app_id,
 
 #endif /* CONFIG_QCOM_QSEECOM */
 
-int qcom_scm_qtee_invoke_smc(phys_addr_t inbuf, size_t inbuf_size,
+int qcom_scm_qtee_invoke_smc(struct qcom_scm *scm, phys_addr_t inbuf, size_t inbuf_size,
 			     phys_addr_t outbuf, size_t outbuf_size,
 			     u64 *result, u64 *response_type);
-int qcom_scm_qtee_callback_response(phys_addr_t buf, size_t buf_size,
+int qcom_scm_qtee_callback_response(struct qcom_scm *scm, phys_addr_t buf, size_t buf_size,
 				    u64 *result, u64 *response_type);
 
 #endif

-- 
2.55.0

