Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA4F481D7
	for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2024 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712854520; cv=none; b=ZZlzHaMjLg7TtFeOhbVUeZFkgjfdlgFWcpGtyfkJOycTe8eqYT8BnKhLU9jyISkMJ0r3/OoSLuZVSGlIPSiqm9gCkEqqCxF3hWGqqT+QsrOM0jKt1ZwTIwBpwQwgwLVtAcNPpbk6qVG+nxeU2mm9hNg7zF2/aGEV8EK0UQEXqEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712854520; c=relaxed/simple;
	bh=gk1IHjYzbP2eNwqxUsPH6sgseRZXBtkXRndssS6uIqk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RsHcXx5ZA/7WJR/rgocYrCDgMiEQ7rPgrAiw3TwKO3sq7gRdgRZiEFX8yJK4I0Xynqs6bI9cPJs1QazVvsmCB4BzoP2BPnbMNXrGrH6K0KpWn6bvygb/oq5jpI8QGR3IkciC9J9WtIlL4L8XTPWIoHU6IofIEEpT/zenvLQt7RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1LYvVHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1LYvVHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13260C072AA;
	Thu, 11 Apr 2024 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712854519;
	bh=gk1IHjYzbP2eNwqxUsPH6sgseRZXBtkXRndssS6uIqk=;
	h=From:To:Cc:Subject:Date:From;
	b=Y1LYvVHFKdZcSasMzkquHW0BkDkWwx/N/iHI2puNzVlrzV+pp3YHgR7vOabsgmJo7
	 K7qz2oFrKSMazBzIJpwnaSozUYN0k9VQUzJfix81WLS+OMJJii24SxkVF4x1yubYmp
	 mm0H79mAKCyimSbMrFqIN4S1jU6GnnqiFuK6xwMEn8quSme/m/MO+mq3KfkldCjXXY
	 tFkvBiouLTfOy9/7EFRM7SwHEWzPZspltfSTWiEQhYieh/HjLuEE623eGlxJrjh/lq
	 SKLg0iduk3VP+E4NkfOhe4P0Qexs8JT+7AATMRZ8TUgVoxuumN7VF6w8jBIWOcgrKR
	 4GbVXhaCoJ+VA==
From: Kalle Valo <kvalo@kernel.org>
To: ath11k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] wifi: ath11k: use RCU when accessing struct inet6_dev::ac_list
Date: Thu, 11 Apr 2024 19:55:14 +0300
Message-Id: <20240411165516.4070649-1-kvalo@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kalle Valo <quic_kvalo@quicinc.com>

Fix a recently introduced sparse warning in ath11k_mac_op_ipv6_changed() and
switch to use list_for_each_entry() in the same function. My plan is to get
first patch to wireless tree and the second patch ath-next (once the first
patch is there).

Please review.

Kalle Valo (2):
  wifi: ath11k: use RCU when accessing struct inet6_dev::ac_list
  wifi: ath11k: ath11k_mac_op_ipv6_changed(): use list_for_each_entry()

 drivers/net/wireless/ath/ath11k/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


base-commit: 363e7193eaf258fe7f04e8db560bd8a282a12cd9
-- 
2.39.2

