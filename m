Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6B8314D1F;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084524; cv=none; b=QXIg5JsD3EXZKS2R8czL0vx+9ueqK1hOEwWAMDRJ3nKzM5DcrxHbHsgtqyqXaX7bMb2PBKMkgm+sqkFnN/AJMQlCVsXxfefb5AIAJmOiAvfN+50lMVM7WAIm7SzQnyajAP9T4nHS3d7CEeTqS7hXTsVX/8a77H9mCXRmy9pshB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084524; c=relaxed/simple;
	bh=+7hgMzH+bUETBpciyveHW9m+55rtTRhGRMMDzVczHHs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=dU3J1hJqtWQK0f/+Q9dANoX+kP6sgxtEfhvhsf7Fl1M+hJ4aoAS6mjFm+NzLL0z1Z8aMZrYLtK8zrfsFvPk585dmArlcVIWWxRqFHj0mtgt8XrcARzHj+d+lS9Dgm4r6f3s6MQaP9R4uCVARwJfxR7yxfLBHleJu3qjPx0Hmmuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTJp68GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTJp68GI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B120C2BCB8;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790084524;
	bh=+7hgMzH+bUETBpciyveHW9m+55rtTRhGRMMDzVczHHs=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=gTJp68GIBHw7Hj1+3ocx2rgbB6/o1d5+XU9iBp5CuVNMSnfFbMtpYl4qZ5IiPVhXW
	 DbdzY52WY/yZmuhcH6+4WB7CoTomgQoiY/UxmBWnemGTBonl0zMj5kD+kNSnX4I9BL
	 0EXYDcBLaeCtPprQ7O3cCL+yabXShrS7PwCyu3HhfxC/wmjykleHCddAqbvgj2hgmN
	 xjfgm4APbiHRWmWlPYSDcvrgYJ6vyT/BGpYNGjEsNOgg9wLOVuWWvsQUPiC8pWtwEQ
	 bXMBLluKRY9J9YW8x7h3G1MxMn8xh605Me0WcOVmguwIF7rXJd99lgInEJFvGlhJj3
	 UcJWyi5+yB4zg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B70FC98307;
	Tue, 22 Sep 2026 13:42:04 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Subject: [PATCH v3 0/4] net: qrtr: Add support for using identical MHI
 endpoint devices
Date: Tue, 22 Sep 2026 15:41:44 +0200
Message-Id: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAJiFsmoC/3XN0Q6CIBQG4FdxXIcDNKWueo/WBcIpaSoKyGrOd
 w/sprW6Odu//ef7F+TAanDomC3IQtBOmyGGYpch2YrhBlirmBEjrCIHyvFkvcX93HmNYcSS1ZI
 1cl8CUBR/RgtX/di88+Wd3dzcQfqEpEarnTf2uQ0Gmnr/7EAxwVyQSgpRVFwVJ+NcPs2ik6bv8
 3hQmgjsA2H0G2ERYbVSnCheUkF+IOu6vgBOaOD4CAEAAA==
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
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>, 
 Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3240;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=+7hgMzH+bUETBpciyveHW9m+55rtTRhGRMMDzVczHHs=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqsoWhJbkRU/X1+Ad7kGtYbrJVhlsIhCOo64Xp8
 6JUHKH95qSJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCarKFoQAKCRBVnxHm/pHO
 9ZFHB/sHbFtYkUxenvI3tCEX7PFWivliqXjghO3lpuXBSqbZOY+ZVTdQ1LiS1Q7auKj/53jTl5f
 7FXtPZ6Q7UPs2KRSPizAV2uJL3txPrqvnKmvhFhntiTk8KUYOpDvqCVXXGrlIZYSkShGaOW/Aqa
 a7boMPoCYttyFnTwMbWWPHojaKAp5Jj7LddPpsnGpMAWqiiWLLV9KDFILZcklHNwEvf1RBPNLmm
 dlqOsBeLHJUXnXuqwKiYvHHLGWRD7IfQ+g8L4ReQHG18JjTcKFRXLF5sb03SVrhgf8Z5+ywieGt
 kk2B25NOZwR0C+m6jCBuFQl3QGKL35KE0BS8mpSsmpw/P8le
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

Juha tested this series on multi ath11k/12k setup by backporting this series to
6.6 kernel. 

Merge Strategy
==============

Since both QRTR and ath drivers are falling under the networking tree, the whole
series can be merged through netdev tree.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
Changes in v3:
- Added missing qrtr_node_rewrite_ctrl() for QRTR_TYPE_RESUME_TX
- Fixed the types of ath{11k/12k}_pci_get_qrtr_node_id() and helpers to use
  'unsigned int' to match qrtr_host_node_id()
- Collected tags
- Link to v2: https://patch.msgid.link/20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com

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
 drivers/net/wireless/ath/ath11k/hif.h |  9 +++++
 drivers/net/wireless/ath/ath11k/pci.c |  9 +++++
 drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++
 drivers/net/wireless/ath/ath12k/hif.h |  9 +++++
 drivers/net/wireless/ath/ath12k/pci.c |  9 +++++
 drivers/net/wireless/ath/ath12k/qmi.c | 11 +++++++
 include/net/qrtr.h                    | 21 ++++++++++++
 net/qrtr/af_qrtr.c                    | 62 +++++++++++++++++++++++++++++++----
 net/qrtr/mhi.c                        |  4 ++-
 10 files changed, 137 insertions(+), 8 deletions(-)
---
base-commit: 8830e65ed46de41f849eefb8ba227d4852c460f6
change-id: 20260918-qrtr-multi-ep-c27c2bc54ee1

Best regards,
--  
மணிவண்ணன் சதாசிவம்


