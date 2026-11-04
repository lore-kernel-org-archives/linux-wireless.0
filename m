Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793810772;
	b=29eCK7R8y0zwcbHrA8rnk31NZzRzJds43tPRI0Qh5N+PVvF0sNMVThuQCPviHdLX2CnZ
	 kZ1cIJeES+udOxRzXZ8xTEUK7zg+VoUs/vdOzg8wNVGM65lm0rZYaztJQX0mB/DPI2vtY
	 xqWP+j+oL/F0FdLayiT6agUK2a8fcLZ/5PYJRJcSKqnwldPQVXcJt4TiC2sANYyGTkhWP
	 OjOmTvY3ULqHuBfcxZt09A+AWxWTvtM1TqZToEZvbhLzSiXYZNNyUrtrv7YjuIYqyIKhS
	 uYydJlASDEOPdw/BZ5O9NZOQ268307/r7YqAC7xTQdwvK6OkDJ9TL3uJ1Syxl0CBtAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810772;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=SFrbJ3RqQqeBPd4Xoqyu8DGpsu+3gFnNtvd1aPsr9A0=;
	b=I/aYpuC5DOKGfW7w1W69gyn4SeJYG0rYviT0fcIg2Pge/gOpwZwFbA9KHR+yysZvwv6/
	 1TeC+Tt0w4bWGzefqU8nmGKmdy0mBLPpgQvJQ5I0D9PzIUsiHov5KBK/A0lhm/hWFoPTf
	 j4wZH0cROD/56yIoh+PTjzWgxjIUsy8pZabWnBkWOhWIKyune+oZK4K3TGrNuLi+Xd58S
	 TeSGsGKD3VJ1VTgWrxAsOMId+pxZQl3vj8IwCMLUHF7w14A6qnSBYMwdFIF4MU1KXZgb+
	 6m4ZPw5w+eUyu1TqfFqiX6VZ1TEwNAPcWMc+Z1Vgz59sJ9evkCvx6ZEPwF6EeLTZl4w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHBHB2O7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42AD606A33B;
	Wed,  4 Nov 2026 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHBHB2O7
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793810771;
	b=aye4J6vqIjsBYGUtFDQfNI6sy19x61oFHqlpSFtPBGerl22ZkyuDd5/U6QJDB3fmZDRh
	 pcHTJfzfuq1M7GgIUffx28LAuKHRV3yeyHM7R8GBp7lUzTMBe42/xk7uughFUnJsRdyiL
	 MKUob1mw4dCSe97d2YmYsFYfDKfF4faavlQK6ca/3aGJtxSolM1sohpIIRdry8zRSMIjp
	 yqGf1Vz5gCVL+4yz7vh+1TqSm00kwRM2OwXw6Mn7t4GH3avA2YJh1mD+0ruU4l4Iv73ZN
	 VOOaIrFbTIpXqKfefFVqII/Qy2gwuikYvgIe6YHJ+xSLJXStNP4sN6pcAhG74U+MqiQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793810771;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=SFrbJ3RqQqeBPd4Xoqyu8DGpsu+3gFnNtvd1aPsr9A0=;
	b=JzgN+LJ7QEYGiPCrydqXI6lPbT8UNaqlMAuOlK8+N5Iu+EWGuaVGcKVjZfxD4xLmDIdp
	 lZUL2eNBSqsfKyCZUkdo10rO3GLE/4u17bjJeiSiWAAP7N0aGyf+Ly26zQVxVfz+EIL0s
	 i0LX3bt3+aHiPNRgpdWUILdVWRAqXQabjF+0S9AV1ylcPWOFaZwLj686LuYPeEhcETBw5
	 tAz/+E3xNzSxWRLhLfJJ0eEoiAGVjm+JiUkKDYHTVTi3Xb6fqmYjhk8y1FQR/KgNXpLNh
	 b2a+y6juhIqEyBaHL1ZFveiEp23x9D7sM8UEZfmLZ0C5/3WHp3SA2BgPY2bQH8do5zA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E95321F00A20;
	Wed,  4 Nov 2026 16:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810771;
	bh=SFrbJ3RqQqeBPd4Xoqyu8DGpsu+3gFnNtvd1aPsr9A0=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=QHBHB2O7NLBrqPktJtj2c2SfoXe1u7ne56qagtKa4zOYS/97sveEsKQ6+0rIA2F9T
	 5c12R99axvLZr6sGTndyNncKVViiyFXDuwEMJqd6VyBuRAdfEC5JVxK3GXrrqcSxHA
	 DzpPohLvUaE+0ZuKchCGbnBTYEYlhGiK8cqCs273Qr3kFlHXA10LRaG02qYUz8Iakl
	 l0izdRLg6TKVfXPGHkN3z1GhiOG7Yzl0xTILMdBqswzrSfMBAWJOYzISkrp6axKoWx
	 jhupe6tsKDSJl+THHgKdqW76tuNCCl9o7z/+A7Gb8DFBqKDNoxGUYSH03e/WPrAFlA
	 3mL7CGsCa1Z0A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 488D946ECA;
	Wed,  4 Nov 2026 16:46:09 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Subject: [PATCH net-next v5 0/4] net: qrtr: Add support for using identical
 MHI endpoint devices
Date: Wed, 04 Nov 2026 08:46:00 -0800
Message-Id: <20261104-qrtr-multi-ep-v5-0-4cdb2b4f1920@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAEhh62oC/3XN3WrDMAwF4Fcpvp6LLOfH7dXeY+zCkZXVo0la2
 wkdJe8+J4NRuuVGcJD0nbuIHDxHcdzdReDJRz/0OZQvO0En23+w9C5ngYAVHJSR15CC7MZz8pI
 vkrAmbKgsmJXIP5fArb+t3pvoOcmeb0m8/2zi2HwypYVbbk8+piF8rdWTWj82WiYlQRoLFVmrK
 +P06xDj/jraMw1dt89jrZjwAUH1jGBGsHbOgDOFsrCB6EcEnxGdEQIwWrExh7LeQIpfRMFfpFi
 QqnVNXbbkNP+DzPP8DU1QPxKcAQAA
X-Change-ID: 20260918-qrtr-multi-ep-c27c2bc54ee1
To: Manivannan Sadhasivam <mani@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Jeff Johnson <jjohnson@kernel.org>, Eric Dumazet <edumazet@kernel.org>, 
 Eric Dumazet <edumazet@kernel.org>
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
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
 Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4612;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=y2J9xaz0uLoyFrScT4xkB8c2QveIyP+efStfQ3ylWUE=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq62FO+oXYYLu7YdB5LRuFC36REfIvTqUPmpa67
 tN4fsbPzXSJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCauthTgAKCRBVnxHm/pHO
 9RDyCACmwwMCggdJFkWxixS65FSH8KOFaNcvNc9SDm9DBEwVuguMWSvgCe30SoP2dhJpy3Z1Wla
 N0eXxchVMHXKWIyJGLTEha1O3XrM/w6KwazZ/SYDB9qnqm4HbwOH3MmyEZAfqV1FZhupGf0my20
 KfB1bisuX/XFx1ElPWUorH5MuZXxNR3gpm/tavZl3pNsxZVzHdBGogKA2gnLe2oIMvhWyEr6Mev
 zNgypS8iMzKy4GqXCRfsfx+q0ySvIh258KDCTKH/spEObRwxTWqlmKMK8Pb3nO2KpuFA/pjUXTm
 3A6em7ks+HNgtFlDssqDhW94f2qJecthJ4A6s2yS8CwEW5Md
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

Merge Strategy
==============

Since both QRTR and ath drivers are falling under the networking tree, the whole
series can be merged through netdev tree.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
Changes in v5:
- Rebased on top of net-next/main
- Collected tags
- Link to v4: https://patch.msgid.link/20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com

Changes in v4:
- Moved the 'ep_nid' and the node id assignment into a single
  'qrtr_nodes_lock' critical section and used READ_ONCE() elsewhere
- Propagated the radix tree insert error out of qrtr_node_assign() and
  rejected the packet or failed the endpoint registration
- Fixed the assign condition that stopped adding bridged node ids as
  lookup keys
- Moved the control packet length check to qrtr_endpoint_post() and
  extended it to DEL_SERVER and DEL_CLIENT
- Rejected endpoint node ids at and above QRTR_NODE_HOST_BASE
- Returned error for the QMI message received from an unknown server in
  ath{11k,12k} so that the QMI core drops the service
- Dropped Juha's Tested-by and Vasanth's Reviewed-bt as the code changed since v3
- Link to v3: https://patch.msgid.link/20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com

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

Cc: linux-arm-msm@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: ath11k@lists.infradead.org
Cc: ath12k@lists.infradead.org
To: Manivannan Sadhasivam <mani@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
To: Jeff Johnson <jjohnson@kernel.org>

---
Manivannan Sadhasivam (4):
      net: qrtr: Allow the host QRTR to assign a unique node id
      net: qrtr: Assign unique node id for MHI endpoints
      wifi: ath11k: Connect to the QMI server belonging to the device owned by this driver
      wifi: ath12k: Connect to the QMI server belonging to the device owned by this driver

 MAINTAINERS                           |   1 +
 drivers/net/wireless/ath/ath11k/hif.h |   9 +++
 drivers/net/wireless/ath/ath11k/pci.c |   9 +++
 drivers/net/wireless/ath/ath11k/qmi.c |  11 +++
 drivers/net/wireless/ath/ath12k/hif.h |   9 +++
 drivers/net/wireless/ath/ath12k/pci.c |   9 +++
 drivers/net/wireless/ath/ath12k/qmi.c |  12 +++
 include/net/qrtr.h                    |  22 ++++++
 net/qrtr/af_qrtr.c                    | 141 ++++++++++++++++++++++++++++++----
 net/qrtr/mhi.c                        |   4 +-
 10 files changed, 210 insertions(+), 17 deletions(-)
---
base-commit: 7b6ab4dbc156e2f96419715130b3d5738a306c93
change-id: 20260918-qrtr-multi-ep-c27c2bc54ee1

Best regards,
--  
மணிவண்ணன் சதாசிவம்


