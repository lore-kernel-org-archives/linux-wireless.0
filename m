Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB7E515988;
	Fri, 18 Sep 2026 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789748898; cv=none; b=m9rBierl1pXGwI3HffRwwpJ+A1870K02t/k43KNt0VSETPpSlYQapumQaqS1REs1+ZBba/0A8c8YxAZXPT3XRZ8sGdMJLFbSELDAZS2LOuYjcXFwYhxGSNYv5VVQnZ/ysr476sY/egCWt2oyO80rqP1gY3yFskeNyV8OZcPpqKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789748898; c=relaxed/simple;
	bh=6Z8qKohBjG+nYdXMxSIz7GwXcSnl7h3FDD5QcnwlKuY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=BZ+b62RjjpKMjLfIYdu5C7CDMQFQ/71cvjFZ5sFXFC46AtOq3B7PIv2/vw47VoUenH9WfjOjos80Ocagsd1vgiPFHY3N/W+GZ7WoDylM6peYB7VpSVI9PSKCYacNZU28wvmfMIqd1rImRkOhc+5YWxktKo/JKKOyxZoXhn5FdlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UB+YS1Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UB+YS1Us"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCFC9C2BCF5;
	Fri, 18 Sep 2026 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789748897;
	bh=6Z8qKohBjG+nYdXMxSIz7GwXcSnl7h3FDD5QcnwlKuY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=UB+YS1UsxCALsNwNH0jSBd7fW29V3RBvgybAQ4h/xGNdUH/X3IfqjYN8WdmgjfUB3
	 A//A3CjxLTkRhlJA5ehoK03Lii1bxtQend0rG8TZ16NIEvS5JoRZkaQFsZWNbp18A/
	 7CKgtAFNV9FjigLPhMQnQr6UxSr68hIbLTgUhVX27qM4AEjcFSW2oTLG6PKXhBXyTP
	 JyHcm6IOKNzCKAEH7kO6H8xzm6C+jNRqRj8qXEarbrhIhghjCrZiloEq0phxz2yRD1
	 pHtBIAa8t1f59BWhVVUSxWxh7EHNDVgHodvfTapYuVHhfF0hjKQaKDUzCbLFzX5y0Q
	 Ly2l/SGGIUbBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C0CC982D7;
	Fri, 18 Sep 2026 16:28:17 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Subject: [PATCH 0/4] net: qrtr: Add support for using identical MHI
 endpoint devices
Date: Fri, 18 Sep 2026 18:28:12 +0200
Message-Id: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAJxmrWoC/yXMQQ6CQAxG4auQrm3CTECFqxgXUH61BhA7AyEh3
 N1Rl9/ivY0CTBGozjYyLBr0NSa4Q0byaMY7WLtk8rk/5pU789ui8TD3URkTiz+Jb6UsAEepmQw
 3XX+/y/XvMLdPSPxOaN8/x3mQHnEAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2798;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=6Z8qKohBjG+nYdXMxSIz7GwXcSnl7h3FDD5QcnwlKuY=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqrWad4ZoZAEk0cQeZgtJ6b+1eEpkYMcmutGWLA
 bVHEQdUHwSJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaq1mnQAKCRBVnxHm/pHO
 9ajuB/9glk15Vu0tJD0QCmDRJJUz3pwSef4SYXyEyq4KwQWyU8SLii0UBPrZAO8Qc0i91NTNI6o
 U43q/76VuAhZFJW60hvtqrjwOgMelpnds+dpqZER0h26ie9F9MKmgRJLfNhW7Mp8JYMzYSsMBE7
 zSydfaCl33EE+Paw/sQMO1ktG35sGcQSi6pIvTaWBL4pLDRfG2oQHqPkwIrNGXZZ3xNB82jh6aX
 9xv42TRFy9qRwDQ0/7M/1BpSV4WZ32GfSxzXFKAZoH4BITmySewHu92P1NeI0dsRitKiXZlk016
 Z+Fbq1Hr4crb5FBljkXN4jfcjzVhgEmR4VWmIWBenBt0UcZP
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
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260918-qrtr-multi-ep-c27c2bc54ee1

Best regards,
--  
மணிவண்ணன் சதாசிவம்


