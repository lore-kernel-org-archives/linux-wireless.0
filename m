Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F484BF941;
	Wed, 23 Sep 2026 12:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165123; cv=none; b=a/INbdj7ivs02ojIwA+jgNFN4EGigV94kcibP27wycSRjOXqUzakmm2wfU9WZ17+mELtUC4mvt0i2a6o3YHId/ZVkOBCfvNGc8RdJtZplbVbHhlLNUnxLnqE0+kQg5AAC5E4Xoh+EfNZw0hr+o74cqe5jjr+4bA+4sGnhHxLBlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165123; c=relaxed/simple;
	bh=DP7ZakM0RfG18wmgJmMLdmBWCDvPQiNf/lyndgVxw7o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NRKIbctsYf7lESivbd70Be6VtnebQ1EEY4uZiUJI5u/5eb1uBws7aR/7x1abm4TjEwWrg/aEjA89u7o1ln1Ay0IjOg2vZ1jplWIQa2WgA3XKRuNe6TaVMDX4+DAQpXByg8Ek+qoUjMfNcm0Uu1WblcQC2JWOHhZE3CvVxuGJhGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/niJeLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/niJeLT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B142FC2BCC7;
	Wed, 23 Sep 2026 12:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790165120;
	bh=DP7ZakM0RfG18wmgJmMLdmBWCDvPQiNf/lyndgVxw7o=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=b/niJeLT2ZU2trAA4Kk1o+BVKX/W+XHzz+VsVKfVInoMY2kmNWK8OpFZI3QNkZVzS
	 SKkaVbGFUX6qjwMDycKcR9GDKRNYMj3DhSJsFa/Ywhu5oF2lPEiI3zaGdbYRrMAH60
	 m0u6E6nek5v0qWt+YHuSCBRVQ1xTGNIzNLmrFXRlApjaSyCZ76OfMe6Oo2cFFCuNWL
	 9uHYl1LvpohKz9V3iRYLNtQAKxStPFyIrLONPQwiYZwUbA8wSb28uXlHIYvCg7GuBC
	 AoRBhvtlwWUnHG6CZ6FT/4YnZXOph4Y58o0aV8yn05ml6L/tijysn4H4KcGRf6juyE
	 nOj46akfNDljw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D35C98309;
	Wed, 23 Sep 2026 12:05:20 +0000 (UTC)
From: George Moussalem via B4 Relay <devnull+george.moussalem.outlook.com@kernel.org>
Subject: [PATCH ath-next 00/16] wifi: ath11k: add MultiPD support for AHB
 platforms
Date: Wed, 23 Sep 2026 16:05:06 +0400
Message-Id: <20260923-ipq5018-qcn6122-mpd-v1-0-86729521a75c@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MMQ6DMAxA0asgz1iK3RI1vQpigGDAQ9OQRBUS4
 u5EHd/w/wlZkkqGd3NCkp9m/YYKahvw2xhWQZ2rgQ1b48igxr0z9MLdB0vM+IkzPi131j9ock6
 gljHJosf/2sNYNgxyFBiu6wZ5C1dabwAAAA==
X-Change-ID: 20260910-ipq5018-qcn6122-mpd-46256c31b99e
To: Johannes Berg <johannes@sipsolutions.net>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com>, 
 Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>, 
 linux-arm-msm@vger.kernel.org, 
 George Moussalem <george.moussalem@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790165117; l=4766;
 i=george.moussalem@outlook.com; s=20250321; h=from:subject:message-id;
 bh=DP7ZakM0RfG18wmgJmMLdmBWCDvPQiNf/lyndgVxw7o=;
 b=6n/qkdAoTe9c56sFXBkMQiIhMPZANlM6ClgA6cmMYrO+R24jrQ8EGwTec/yEhk+Bxot49e/bC
 h7Yu4a8MouHAdM5V5e2nmXjk7/IEiUYt82kbAHCiVCl1gIRvz+JDaly
X-Developer-Key: i=george.moussalem@outlook.com; a=ed25519;
 pk=/PuRTSI9iYiHwcc6Nrde8qF4ZDhJBlUgpHdhsIjnqIk=
X-Endpoint-Received: by B4 Relay for george.moussalem@outlook.com/20250321
 with auth_id=364
X-Original-From: George Moussalem <george.moussalem@outlook.com>
Reply-To: george.moussalem@outlook.com

Add multiPD support for AHB platforms following the approach for ath12k:
link: https://lore.kernel.org/linux-wireless/20250321-ath12k-ahb-v12-0-bb389ed76ae5@quicinc.com/
link: https://lore.kernel.org/linux-wireless/20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com/

The IPQ5018 platform is a multiPD platform and the current ath11k driver
supports standalone IPQ5018 WiFi only. However, IPQ5018 boards come with
up to two optional SoC-specific QCN6122 WiFi companion chips for 5G/6G
WiFi.

IPQ5018 implements the multi-PD architecture as follows:

                     +-----------------------------+
                     |     Q6 Remote Processor     |
                     |            RootPD           |
                     +--------------+--------------+
                                    |
                                    |
                                    |
              +---------------------+---------------------+
              |                     |                     |
        +-----v-----+         +-----v-----+         +-----v-----+
        |  UserPD1  |         |  UserPD2  |         |  UserPD3  |
        |  IPQ5018  |         | QCN6122 #1|         | QCN6122 #2|
        |  (Radio)  |         |  (Radio)  |         |  (Radio)  |
        +-----------+         +-----------+         +-----------+

The rootPD is responsible for managing the lifecycle of the UserPD and
shared resources and providing SSR notifiers. There are different
firmware blobs that include either the rootPD and userPD binaries for
IPQ5018-only which auto-spawns the userPD for IPQ5018 WiFi, or for
IPQ5018 and QCN6122 for which the userPDs for each radio must be spawned
by the ath11k driver.

It's worth noting that QCN6122 does not have its own Q6 firmware blobs.
Instead, the firmware segments for QCN6122 are included in the MPD
version of the IPQ5018 firmware blob(s). The QCN6122 M3 firmware does
come separately and is loaded into the Q6 memory carveout of IPQ5018.

In high-level, the path series covers:
- Addition of multiPD IPQ5018 binding definition
- Updates to the ath11k driver to register handle standalone vs multiPD
  remoteproc boot sequence with required notifiers.
- Support for loading M3 firmware files during remoteproc boot sequence
- Ability to set required memory carveouts for Q6, BDF, and M3 firmware
  segments.
- Addition of SCM call to manage power state of the internal IPQ5018
  WiFi radio
- Driver support for resource acquisition and power up/down of userPDs
- Binding definition and AHB driver support for QCN6122

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
---
George Moussalem (16):
      dt-bindings: net: wireless: ath11k: Sort compatible names alphabetically
      dt-bindings: net: wireless: ath11k: Add bindings for IPQ5018
      wifi: ath11k: Register root PD rproc notifier
      wifi: ath11k: Add support for loading m3 mbn firmware
      wifi: ath11k: Add ability to set BDF and M3 dump memory addresses
      firmware: qcom: scm: Add support for setting internal WiFi power mode
      wifi: ath11k: Register userPD interrupts and SMEM entries
      wifi: ath11k: Power up userPD
      wifi: ath11k: Power down userPD
      dt-bindings: net: wireless: ath11k: Add bindings for QCN6122
      wifi: ath11k: add hw params for QCN6122
      wifi: ath11k: add hal regs for QCN6122
      wifi: ath11k: add hw ring mask for QCN6122
      wifi: ath11k: update hif and pci ops for QCN6122
      wifi: ath11k: define userPDs for QCN6122
      wifi: ath11k: add QCN6122 device support

 .../bindings/net/wireless/qcom,ath11k.yaml         | 569 ++++++++++++++++++++-
 drivers/firmware/qcom/qcom_scm.c                   |  43 ++
 drivers/firmware/qcom/qcom_scm.h                   |   2 +
 drivers/net/wireless/ath/ath11k/ahb.c              | 555 +++++++++++++++++++-
 drivers/net/wireless/ath/ath11k/ahb.h              |  54 +-
 drivers/net/wireless/ath/ath11k/core.c             |  99 +++-
 drivers/net/wireless/ath/ath11k/core.h             |   1 +
 drivers/net/wireless/ath/ath11k/hif.h              |   9 +
 drivers/net/wireless/ath/ath11k/hw.c               | 112 ++++
 drivers/net/wireless/ath/ath11k/hw.h               |  10 +
 drivers/net/wireless/ath/ath11k/pcic.c             |   9 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  70 ++-
 drivers/net/wireless/ath/ath11k/qmi.h              |   3 +-
 include/linux/firmware/qcom/qcom_scm.h             |   1 +
 14 files changed, 1501 insertions(+), 36 deletions(-)
---
base-commit: 10cfa109c880092df32e396647b4afdca9be8350
change-id: 20260910-ipq5018-qcn6122-mpd-46256c31b99e

Best regards,
-- 
George Moussalem <george.moussalem@outlook.com>


