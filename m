Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB53BC660;
	Thu, 19 Mar 2026 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773959067; cv=none; b=j02Qx7Gh1SX6FRDrmFm4ibLo74E1sUHj2aY8la1STOuy3w32WMrVAqF/Q2HoRTLgQoYHWu4BPWpS5skx1zAYSpW1NE+5etKBI4624r3ggMFsfz7J8UbqCRSglNviaa/Y3cufRbZxS9+rb5xn0ncrTpky6bOsVUPI90EzZtNjtII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773959067; c=relaxed/simple;
	bh=DizT/ddlZFD7KX9YeoKrBVdFFWkgs3dXjw0pBgdRG1k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc:
	 In-Reply-To:References; b=kvZrywjnR8TAx4vGZpKYMCGFhk/Hdyf7b/sT+5N9B3MZRVHOf+WfTZ6WseRprbyjhhJnYPkTZ/Wu5naz0EpBjq0NHcXvNm28rsbw55J9Qg3w8Rji131K+v6vSEI0hrBViqdJS+F/1qmG1TWUyChDgHN9wu1VF5SjyGwo0RepIXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jetm.me; spf=pass smtp.mailfrom=jetm.me; dkim=pass (2048-bit key) header.d=jetm.me header.i=@jetm.me header.b=R8Mv7Cx5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=H5hw9ndQ; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jetm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jetm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jetm.me header.i=@jetm.me header.b="R8Mv7Cx5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="H5hw9ndQ"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 8B0221300092;
	Thu, 19 Mar 2026 18:24:21 -0400 (EDT)
Received: from phl-imap-07 ([10.202.2.97])
  by phl-compute-02.internal (MEProxy); Thu, 19 Mar 2026 18:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jetm.me; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773959061;
	 x=1773966261; bh=cvt3lJ9bUn/nS9x0h5+rL6WI6mE1I309IFcyKJoRia4=; b=
	R8Mv7Cx5F4KphjYg5Te06q3GICfi1OVK0mA6wu+CWFeZihur3s9HMXXJbyj+4/OU
	S8obxUz4xPrnTTL376SDOwyl+zqHmnu+eA3p0hHLPi1S8VnLx19xGTXAdT910Vu8
	Tf8B9cCzIuDezYjjkIKhwTfbKpSszn3HS7Uc0cJcIj5UJHwYLoKJfffywv3lUIz1
	UBKGMIgDbTEWmQ64k6jTjwkezW5PI2KM0sc4krVr2vcKISOfJmmm0kzcWS6XEdA1
	zjSRxjtrNNyL7k/WAKXCfq5jgZhTTGA4yBfZGzX9hdwH4gHRwDNoVrrtzWa8504/
	4etlxOI+enFMOcnT7xTeBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773959061; x=
	1773966261; bh=cvt3lJ9bUn/nS9x0h5+rL6WI6mE1I309IFcyKJoRia4=; b=H
	5hw9ndQf3J0zoni9OhrC8aICkuhLQj+lEH553Pca5iGA6rGyxxW+2YkwEJ1OUSwB
	B5ye0M6bOO72D9Oj7A2PfranAbJhEdP3npU8wydqQkdgIjTgbCmzrqPkvOOBowYf
	uI0b4bmpLKSm16/Xlrbnn3Fik+1+WOpxz+3rc132feRT/t4SqNKrPc7CDFjLmEHP
	ZPipPyaca+sfRJ3q4JwGk8sNDPAxlWt+/+hSwSowsoyWMTFKyuMbPhcz5/NqQMO0
	1IffJHV+6y9sD1dQgDDq/UvAyLCAaBxizhhT/hHrcDQ8+Ad2LTZnjHXdd89Y3RgD
	9r0RZ+WZTUPjHKmV3LZYw==
X-ME-Sender: <xms:lXe8aRq7XXfH62QHG1Eo6iVXYvp7W3MbWSJzPwoGig-Ti9paUopnCQ>
    <xme:lXe8aefZiOzCc19OsoPrapH62OLeItba1m5Gs3fPFxL1Yk2SSzNQGqBiS4Bv_MUDk
    GyZbWbwht8JvuIR2xUOd4Kk62HvGaKgiv1owF1pkJG4qAg_7NoC9iI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepoffhfffugggtgffkvfevofgjfhesthekredtredtjeenucfhrhhomheplfgrvhhi
    vghrucfvihgruceofhhlohhsshesjhgvthhmrdhmvgeqnecuggftrfgrthhtvghrnhepve
    ektdfhffevuddtgfetieevtddvheduhfeggfekveejlefhleefieevueefiefhnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhlohhsshesjh
    gvthhmrdhmvgdpnhgspghrtghpthhtohepvddvpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopegrnhhgvghlohhgihhorggttghhihhnohdruggvlhhrvghgnhhosegtohhllh
    grsghorhgrrdgtohhmpdhrtghpthhtohepfeduleefieefudesghhmrghilhdrtghomhdp
    rhgtphhtthhopehlohhonhhgrddtgidttdesghhmrghilhdrtghomhdprhgtphhtthhope
    grrhhivghlrdhrohhsvghnfhgvlhgurdejhedtsehgmhgrihhlrdgtohhmpdhrtghpthht
    oheptghhrghpuhhishgurghrihhogeesghhmrghilhdrtghomhdprhgtphhtthhopehgih
    hoshgrlheltdesghhmrghilhdrtghomhdprhgtphhtthhopehmrghtthhhihgrshdrsghg
    ghesghhmrghilhdrtghomhdprhgtphhtthhopehrrgguohhirdgthhhrihhssehgmhgrih
    hlrdgtohhmpdhrtghpthhtohepshgrmhhurdhtohhljhgrmhhosehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:lXe8afbhmW4q_w2VNssGoXD64Fu-Rje7qStDCBkVK2ovPU0b8t5h5A>
    <xmx:lXe8abmQiBF7Ca2e0IrSkFtBDDilqxZpTuzK6k0apiJZ_T_5dP8ycg>
    <xmx:lXe8aWdNb_n4ZPD5J-Yb1jX0Me0DgRjWNFGvLmg168FqZ6wCl3qQKw>
    <xmx:lXe8aR2Gq_ZlhS02e-GuN64H8kykrSdLhfjBjOmkIturyVUpheCFQw>
    <xmx:lXe8adR1q8Aduma-lGb37yWLie2Zne4817MU72grsMo6idwHm94gcYvH>
Feedback-ID: i9dde48b3:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3B15C1EA006C; Thu, 19 Mar 2026 18:24:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
From: Javier Tia <floss@jetm.me>
Date: Thu, 19 Mar 2026 16:24:17 -0600
Subject: [PATCH v2 01/13] wifi: mt76: mt7925: fix stale pointer comparisons
 in change_vif_links
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260319-mt7927-wifi-support-v2-v2-1-d627a7fad70d@jetm.me>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>,
 Sean Wang <sean.wang@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Deren Wu <deren.wu@mediatek.com>,
 Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 Marcin FM <marcin@lgic.pl>, Cristian-Florin Radoi <radoi.chris@gmail.com>,
 George Salukvadze <giosal90@gmail.com>, Evgeny Kapusta <3193631@gmail.com>,
 Samu Toljamo <samu.toljamo@gmail.com>,
 Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
 Chapuis Dario <chapuisdario4@gmail.com>,
 =?utf-8?q?Thibaut_Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
 =?utf-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810; i=floss@jetm.me;
 h=from:subject:message-id; bh=DizT/ddlZFD7KX9YeoKrBVdFFWkgs3dXjw0pBgdRG1k=;
 b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBpvHeQLAEYKacw2gZHHInwwSGuqAs3PNfX4ugdx
 LEsTNqv5OKJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCabx3kAAKCRC17sMLqGd3
 H1fBC/9KPA6rElLV7oP7qIWoscZFIglo65pC1Yw08WqMN2abP1gEhVtoJbclzmn8uI6zNhWugmU
 hNyWMAOiZUWPUzPqOTSwIQA81ELfLR9OTDsvl+eRHLajkpCEG1ZtuMO7NSVCyQHmkTs6PpV3ssj
 GOBGfmpa3mvh0AO2zigkyJdBAH1fqqfF1/83LIFyOHaYuwISvO590gIpEy6fdiwbc+RiRX2VsVP
 21lben5hTemr/aw7RaNi+GfLxAk4tW4137GJ1ntChEZNly/Er11cmPAFU+kss3dA7aA2BfYIDqw
 qmx0u/oLIPm354fc0cwywEA7d/31VOTQfGmGPw+gYnsHJBSq7wrYpt69U3ZlLlkaKETCirvdEA2
 pANymSKkjudeTsABKSwKypSjAck/35IJUieqA2tDOvlsraWsByxwnM38lan6q4CjJb8YFzxhL2S
 AK5Z7tl0sCKRmanvjr6mWMdXZ4jlFrv/Wol0iuiDS//QTsLFiZOsnnhUfRXqj+TmpJzu0=
X-Developer-Key: i=floss@jetm.me; a=openpgp;
 fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
In-Reply-To: <20260319-mt7927-wifi-support-v2-v2-0-d627a7fad70d@jetm.me>
References: <20260319-mt7927-wifi-support-v2-v2-0-d627a7fad70d@jetm.me>

In the error path of mt7925_change_vif_links(), the free: label iterates
over link_ids to clean up, but compares against `mconf` and `mlink`
which hold stale values from the last loop iteration rather than the
current link_id being freed.

Use array-indexed access (mconfs[link_id] / mlinks[link_id]) to compare
against the correct per-link pointers.

Fixes: 69acd6d910b0 ("wifi: mt76: mt7925: add mt7925_change_vif_links")
Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Signed-off-by: Javier Tia <floss@jetm.me>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 2d358a96640c..f128a198f81d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2047,9 +2047,9 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		rcu_assign_pointer(mvif->link_conf[link_id], NULL);
 		rcu_assign_pointer(mvif->sta.link[link_id], NULL);
 
-		if (mconf != &mvif->bss_conf)
+		if (mconfs[link_id] != &mvif->bss_conf)
 			devm_kfree(dev->mt76.dev, mconfs[link_id]);
-		if (mlink != &mvif->sta.deflink)
+		if (mlinks[link_id] != &mvif->sta.deflink)
 			devm_kfree(dev->mt76.dev, mlinks[link_id]);
 	}
 

-- 
2.53.0

