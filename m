Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A582A34EF04
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 12:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389758; cv=none; b=E3kXgvb9KJpzObpfyAByifJDRqWtuO/q14VvuVl8VULVr1Ro2pSBhmqKQ8XmnqS9sQUx0I4QY5SEZ7Rex9ypT/e/K93t6Q244ygOkn1W6BMocOJ2Ijr/jZ8bY1TpwbmCmfeJVHVNEBMfPhFkxJWttpOLn1Ept0dZqhYHWOBXlv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389758; c=relaxed/simple;
	bh=kKUjFxTDzaIvfCLVxP1OmjKiQRgwNhTIUBFn6PNx22w=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ANOozgSzc84FBatF9SExsWQr3oEWgMSEPFjDbP9XewykgTvQKHGLZD7Q1p8Qm2/mO0nGzVKWiqMaOya3/VJOtbdEDEP7dZBkU+cd/PvAUudoLMt7gHbVGrybcjlN59nkt+k0cy3azGFZs/njKgNtDai5Eqx2J4M+whOQySuh78A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JVZHfr9/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JVZHfr9/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789389754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gS0PasUdCVmtQZHlDSGBeMxyLgFshGbkXoV5dyvEzpg=;
	b=JVZHfr9/DAMXL3UNHs/s6wZYd2BKi0xVke5TD3rNkCTYiEYTmAU4u10EUS3tmfTad51vpy
	gF8j6E6fQWHpUCm/58aIM9P6Dee8CLxUGTgwmVc6Njtsm5PvrMJGWdA+56NpSbeRJ396h2
	8HHhZxm+/uGnGarMv8HaIu+lNlgdCwM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-ud337pCmNmmsQShMmbfDjA-1; Mon,
 14 Sep 2026 08:42:31 -0400
X-MC-Unique: ud337pCmNmmsQShMmbfDjA-1
X-Mimecast-MFC-AGG-ID: ud337pCmNmmsQShMmbfDjA_1789389749
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01899180ABEA;
	Mon, 14 Sep 2026 12:42:28 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B83C341D;
	Mon, 14 Sep 2026 12:42:13 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Subject: [PATCH 0/3] firmware: qcom: scm: pass struct qcom_scm through the
 API
Date: Mon, 14 Sep 2026 14:41:53 +0200
Message-Id: <20260914-scm-device-api-v1-0-3573e2596c51@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvyJ7bsE0tPpKdBBdaw+VKEQQ/j3pO
 DAzLxTKTAVm8UKmmwtfZ4O+E+B3d26EHBqDksrISY5Y/IGhiZ7QJUajB+ets1FbCy1KmSI//3B
 Za/0AntZYi2AAAAA=
X-Change-ID: 20260908-scm-device-api-634ac7a7f377
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789389733; l=4126;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=kKUjFxTDzaIvfCLVxP1OmjKiQRgwNhTIUBFn6PNx22w=;
 b=ptN78nZt4fGWWnpdDZyVENIgI04y8a4PWpV9Q7ESU1lJXI6I5/2224GMHxqfT8NR3RqXorNth
 jHJX4SMRZ0tCfmG8DtbgRZpcTf2pE4dns304nz4VWJerDfTGzhcT+6A
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

The SCM driver still funnels every call through a process-wide
__scm singleton.

This series threads struct qcom_scm through the driver and the
exported API, then drops the global.

Series summary
--------------
Patch 1: Internal helpers take the instance. Callbacks that only
have a struct device or reset_controller_dev recover it
with drvdata / container_of. Exported signatures stay
unchanged so this patch is bisectable on its own.

Patch 2: Exported calls take struct qcom_scm * as the first
argument. The type stays opaque in qcom_scm.h.

    Children of the SCM device (qseecom, tzmem, qcomtee)
    use dev_get_drvdata() on the parent. Other consumers
    call qcom_scm_get(), which finds the bound platform
    device and returns NULL until probe has marked the
    instance ready. Callers that need SCM return
    -EPROBE_DEFER; callers that only use it for an optional
    path (rmtfs VMIDs, fastrpc vmids, PAS region assign,
    Venus CP, HDMI HDCP, Adreno fuse poke) skip the lookup
    or tolerate NULL. qcom_pas_* is unchanged: PAS has a
    TEE backend, so those ops keep struct device * and the
    SCM backend uses drvdata.

Patch 3: Drop __scm. Readiness is scm->available with the same
release/acquire pairing as today. Module-parameter
stores reuse qcom_scm_get(); shutdown uses
platform_get_drvdata().

No intended change in SCM calling convention or wait-queue
behaviour.

Testing
-------

Booted to a shell on Qualcomm SA8775P Ride4 with current series.
qcom_scm bound as firmware:qcom_scm; probe logged SMC ARM 64 and
the tz-ffi reserved-memory assignment. Consumers were not exercised.

Suggested-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
Albert Esteve (3):
      firmware: qcom: scm: pass qcom_scm to internal helpers
      firmware: qcom: scm: pass qcom_scm through the exported API
      firmware: qcom: scm: drop the __scm global

 arch/arm/mach-qcom/platsmp.c                     |   3 +-
 drivers/cpuidle/cpuidle-qcom-spm.c               |  28 +-
 drivers/firmware/qcom/qcom_qseecom.c             |   3 +-
 drivers/firmware/qcom/qcom_scm-smc.c             |   2 +-
 drivers/firmware/qcom/qcom_scm.c                 | 518 +++++++++++++----------
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
 drivers/misc/fastrpc.c                           |  31 +-
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
 include/linux/firmware/qcom/qcom_scm.h           | 117 ++---
 32 files changed, 566 insertions(+), 363 deletions(-)
---
base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d
change-id: 20260908-scm-device-api-634ac7a7f377

Best regards,
-- 
Albert Esteve <aesteve@redhat.com>

