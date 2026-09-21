Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B873BC664;
	Mon, 21 Sep 2026 11:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789989813; cv=none; b=VFahtXWKPnCcdL2nz4ZTZ+/ZKv7Rh6uVtBH/4VWtB+SoiXoznsIsXtv/kpNcVdO7DXnnsH65dxIU+zF/BrmVaZJ79XvXYCaoqinsPD/RV7dsz95mZzsf/PflLg12wmgCq3xhzMOy96jIkGnGe+0tngiOg3IiKlupcNVQ/gmPCdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789989813; c=relaxed/simple;
	bh=zbfIARE/0F5vsVHko59MjRV3EbTh6ByKy9mPflxIfb8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=QCUaWw1kN2PpjI/Q1rF0HrEFD2CVSblY6FlF+RdfKV2oyHRGs1VsJW0MK8axXc5AMtgMKiiACB+2VQlGVKddQG08mVUoouBQDGV40rAzCWyE/+owhXnYAWTeZcPW4brjYBIPBNw1TjsLRVWAd9I2Dz92kRw3+TUMWv0WCblgauc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0L8P++i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0L8P++i"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD23CC2BCB3;
	Mon, 21 Sep 2026 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789989812;
	bh=zbfIARE/0F5vsVHko59MjRV3EbTh6ByKy9mPflxIfb8=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=T0L8P++i5Xu0C1oZodj+jm1Ba2rFjENdqDqcyDradbj3n/WpOB0GLOkZ6woVFcbop
	 yw1fb0YLiWZy+8a5QnBH1A7jzbVg9DYvW+Del9Lb0UBj8ZyxjJ+Tr1Yuiy0JtVDT8L
	 b7cuIDZuz3KTOU94zJ/VPeSdLqcrrKcaPJG3EDz+KcYqk3Vl4qG+zTVKMlb3rGFXC6
	 Fady9ZsirBL538ToCfTBujLhBCu3FhHue+6vToDFXz7pEMZTG6RsL6jah1wY9Zok9c
	 4awzS525NbVQ9yawkwm9QlfyUn1zsDRPoo6e8AmuqGzGiGO27zOFhWeMFVjtM57LwE
	 BtyYYebcgM74Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3893C982EE;
	Mon, 21 Sep 2026 11:23:32 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Subject: [PATCH v2 0/4] net: qrtr: Add support for using identical MHI
 endpoint devices
Date: Mon, 21 Sep 2026 13:23:26 +0200
Message-Id: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAK4TsWoC/3WNwQ6CMBBEf4X0bElbFNGT/2E4lGWVNUChW4iG8
 O8WPHuZ5CUzbxbB6AlZXJNFeJyJyfURzCER0Nj+iZLqyMIok6uLLuTog5fd1AaSOEgwZzAVnI6
 IWsTN4PFB7913L3/MU/VCCJtkazTEwfnPfjjrrffPPWupZGFVDtZmeVFnN8ecjpNtwXVdGkOU6
 7p+AclqACnDAAAA
X-Change-ID: 20260918-qrtr-multi-ep-c27c2bc54ee1
To: Manivannan Sadhasivam <mani@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
 Bjorn Andersson <andersson@kernel.org>, 
 Chris Lew <christopher.lew@oss.qualcomm.com>, 
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
 Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, 
 Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3005;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=zbfIARE/0F5vsVHko59MjRV3EbTh6ByKy9mPflxIfb8=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqsROx46KQNzfqnlBNIgv5L/g7bgKhMB1swq5zm
 1leCwZ1N0OJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCarETsQAKCRBVnxHm/pHO
 9aYBB/9p3RKn1hbFArnz1cbC3pqkRV0A9LLEZmR5i1farX/9cVPaQsptgEFoZ6S9OSy+lKw3EOV
 2GX4e28zmHgM55NGIGUA6YfVTSzdTeNNSck/RiX3somRHwinsGVrQrXV3JE3OQti7/upf9A6LDH
 /1JIbon8V0jrKJMQNwSuRmtU4Ef4gQTz3b3DduUfxK1xnoDEkMMuYtYo5w366Y0rg4hnnaxUEgI
 JZBc+QbYRGU6KhHVyZJT8N9mfr67arCocxTtC9/vrRh7+NeFusx2sGXHPYXAdhgA/4uhsu7auFm
 nOCqVh9JwlfnkfZOpwa0IzXhDlqgRtU9tDorjWSC1XDy0zaj
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

Hi,

This series reworks the QRTR driver to add support for using identical MHI
endpoint devices at the same time. Currently, QRTR driver has a limitation on
using more than one identical MHI endpoint devices like QCS6490 or any Qcom
Endpoint device making use of QRTR at the same time. Because of the fact that
these devices will have the identical QRTR node id, they cannot be used at the
same time, on the same host machine.

This limitation is a blocker for running upstream kernel on devices like Qcom
based routers as they often have multiple identical WLAN Endpoint devices
connected to the Router SoC.

This series supersedes the following 2 series from Juha:
https://lore.kernel.org/all/20260915054207.2513877-1-juha-matti.tilli@iki.fi
https://lore.kernel.org/all/20260915074135.2567411-1-juha-matti.tilli@iki.fi

Compared to the series from Juha, this series simplifies the multi-endpoint
support by computing a unique node id for each MHI endpoint and uses it for the
internal QRTR book keeping. This ensures that even if the MHI endpoint devices
have same node ids, the host QRTR will always use a unique node id for each one
of them.

More details can be found in the individual patches.

Testing
=======

Juha tested this series on multi ath11k setup by backporting this series to
6.6.156 kernel. I'd appreciate a formal tested-by tag from Juha and other folks
CCed to this series.

Merge Strategy
==============

Since both QRTR and ath drivers are falling under the networking tree, the whole
series can be merged through netdev tree.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
Changes in v2:
- Rebased on top of net-next/main
- Used READ/WRITE_ONCE for reading/writing ep_nid
- Link to v1: https://patch.msgid.link/20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com

---
Manivannan Sadhasivam (4):
      net: qrtr: Allow the host QRTR to assign a unique node id
      net: qrtr: Assign unique node id for MHI endpoints
      wifi: ath11k: Connect to the QMI server belonging to the device owned by this driver
      wifi: ath12k: Connect to the QMI server belonging to the device owned by this driver

 MAINTAINERS                           |  1 +
 drivers/net/wireless/ath/ath11k/hif.h |  9 ++++++
 drivers/net/wireless/ath/ath11k/pci.c |  9 ++++++
 drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++
 drivers/net/wireless/ath/ath12k/hif.h |  9 ++++++
 drivers/net/wireless/ath/ath12k/pci.c |  9 ++++++
 drivers/net/wireless/ath/ath12k/qmi.c | 11 +++++++
 include/net/qrtr.h                    | 21 ++++++++++++
 net/qrtr/af_qrtr.c                    | 61 +++++++++++++++++++++++++++++++----
 net/qrtr/mhi.c                        |  4 ++-
 10 files changed, 136 insertions(+), 8 deletions(-)
---
base-commit: 8830e65ed46de41f849eefb8ba227d4852c460f6
change-id: 20260918-qrtr-multi-ep-c27c2bc54ee1

Best regards,
--  
மணிவண்ணன் சதாசிவம்


