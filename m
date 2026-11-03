Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704007;
	b=FRQnIln8jOWk1nxHFoe8qr5Hw7W6OUIjp2PWRE6JmQV9DVoEn7Ac1DrnLG/nqc7wtHX5
	 jkM0bwnydq8Al/aT9VQM+Ro6V7IjrojMwyUoasZPwYNMmyofH4St/A+l76SrWkz6LpJd+
	 ylr9A1+ryAOSlBy2g5uZklgmI+kqDQSw9uU+SvRxihi88agjQushAolZwMMP75KNIlEeu
	 5hWqpuTPZ3i+id7gOBT7aZxjdarAtkAqk92TeRiY/n1YxrdicnIiErHmjSMlAI95LFBHq
	 V9E5WyKVVcQ+2vgzik6fX1TjBVIpi6khi/J4DAbKJ+Yr+M+A64dixfxlDpkEPZhx6XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mZPBVMh0wm4VVrgnscvN4jhfaDsZC9TnytJpUKysC/g=;
	b=C68mhan34BUGGLIPKZbFsPDedUkj3zPWAeFkjWJGrHm62GeugLeEg2WPZmqjblffuK4i
	 Rz+TFLWwsS4EsKAL/dbFzSK9bUQuazJfm9AwgmlgZ4405uzOh+j3LGFivxI4vXHqksiQV
	 KrMLU63y6A+YBxGzWqY80CQQLyVfwREWCOOY5nLlc1A5uEIR7SMiqmX1BSmILMWM6zoRS
	 Vm0dWl2jkvQ4F5mE2+1VrS3ROk1TmVOiEeFdmJL8vpwMIJPp3iGgzV2nmRTByNPq5diMg
	 s5nvb7UbjStAafZEQ9SvC/LGQzBLp2gFOukid8TjefZAFHoIRlUYRdJekbh/V6jf8jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EpfRtPw9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F6B606F7F8;
	Tue,  3 Nov 2026 11:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EpfRtPw9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454781F000C1;
	Tue,  3 Nov 2026 11:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793704007;
	bh=mZPBVMh0wm4VVrgnscvN4jhfaDsZC9TnytJpUKysC/g=;
	h=From:To:Cc:Subject:Date;
	b=EpfRtPw961KFpmK/YEegv/LCr7KNh1N/EZJeiq3XuTQ12/NmdXOWGHJSssT/K4ecn
	 FLpQPY9sC+zFnd5dCFevAH537FaQOMB6PGVrKeM6GPM8Cql4KEkmAZRfg/xVwxTbEy
	 BGMABj9rZKghBajBj62aKv5FEtddETv9wXHVLhTRJdT7n+uZ+5Oh1MW8aM4FMgzLRP
	 NMx3LDMraOqhzZr85EsahU5+GjilRtjN7jgFHTq3fG3ogPsxwW1rqVj8vI2B6TRlKp
	 RFykGLItbqDtVWPMoFiD71MuIinbeUaXjU8BVIglHwLih3p+RtOg1RG+QnYRjjCE1/
	 DyYA+WAmzHOGg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Jiri Benc <jbenc@suse.cz>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	Luca Coelho <luciano.coelho@intel.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] wifi: mac80211: Power-save state and TIM handling fixes
Date: Tue,  3 Nov 2026 11:06:31 +0000
Message-ID: <20261103110642.260244-1-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Following up on the v1 discussion [0], this two-patch series:

 1. Makes AP-side Power Management (PM) bit handling in
    ieee80211_rx_h_sta_process() symmetric across both wake-to-doze and
    doze-to-wake transitions, ignoring the reserved PM bit in
    non-bufferable management frames while still waking sleeping
    stations on Authentication and (Re)Association Request frames per
    commit 9fef65443388 ("mac80211: always update the PM state of a peer
    on MGMT / DATA frames").

 2. Ensures an awake client station sends a wake nullfunc frame in
    ieee80211_rx_mgmt_beacon() when the Beacon TIM element indicates
    buffered unicast traffic for its AID, even when dynamic power-save
    is disabled (dynamic_ps_timeout == 0) and IEEE80211_CONF_PS is not
    set.

v1 => v2:
 - Make non-bufferable MMPDU PM-bit handling symmetric in both
   directions and expand the commit description.
 - Add client-side wake nullfunc transmission in
   ieee80211_rx_mgmt_beacon() when the TIM bit is set while awake.

[0] https://lore.kernel.org/r/20260928100508.3487525-1-lee@kernel.org

Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org

Lee Jones (2):
  wifi: mac80211: ignore PM bit in non-bufferable MMPDUs
  wifi: mac80211: send wake nullfunc when TIM bit is set while awake

 net/mac80211/mlme.c |  3 ++-
 net/mac80211/rx.c   | 22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

-- 
2.56.0.313.g2479322e68-goog

