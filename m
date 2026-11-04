Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793793379;
	b=V8O5OpCqfGJ+SyuA3j02SPnRVM7qJGv9FsCiBnkS42Gyp+F53IiUD3DG/JRBWaojl0Ra
	 7AhGv4iCxZZpvPGdP1NijYnxwPgrCfuQ0DRttn9SssBl7P6Sx6oTBRIxtDTaz0RlbMiRx
	 pnD1ogqFWoprM4ZDHtoe8Tkvnc2hNgHeb+oY8pqf2hUF7b7OOqQKDEAOm7rTUYldevAzA
	 Y8jpfIrbP10hovveAce74ijphFS+Tp1bDWfd57P1Mh4RyslGeIF5S7uiZSH2O+EWi0SY0
	 Kyg8L7iZYgU9AbfT1jJ5SRPNdBONiZngMRHDu/eD1puJI6uiCY0/9mxVTIdznUi/jCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793793379;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0FNRQ8vzx8hO9gsNhb2gW3msqRx6v5HSfbK6Brxek5U=;
	b=BAl6kQ273MxllNvS6qtTX7VNhjIKUyYBePmEcLtZAwHUiNTV+ewmjOaJU9THuFKGMnKz
	 Xa2IF2gIgZHzLabVhqANYNLVrg/paStMIbbvM/fNDHVOsJUDGEiUzwDhug7U843elKTPU
	 3WxEfIpKPM2S/q7oEKmwBJpTqljwKlees3/H4Ew+MOlaNGHVmYFKJ534d2U6nzKFvjQEt
	 LAjgidCq1ONXf8nGYzLUU29Q83Zv3Rhsyi7s36hTQImp/H//OvsiGNvYqul7swson0ny/
	 4S51s+v5HFIy/0O1nt/34JVerqOFjuhFXPP62+JobidD5PDXctdFRmTM/Rnl7uCWMxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YdxjwQs6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A10606A329;
	Wed,  4 Nov 2026 11:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YdxjwQs6
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793793378;
	b=cYDnC23woql2haPUenU7SfNmQiNVQQdBWRGf0OYs9/o99TQMoRmQsE/84OSv+IR6XRBr
	 uJKDDnXa7CSMUbW73GXl2VC0YImzYJSeArBCUgzrGQO03wE1ZUzxzE65lOu9Lp554PmAh
	 69izqt3hGClovjK91PFlEfp5kXH0k2AZzlFvEOn/lWZAiZkLX86GklHlu8+sQmUIp9WvL
	 3lNw6mmB0ZQ8/RUrT7NfQmDZm2KKRDBq85nFs+3smRaZlXKdtpHFPXn5MdilLTDL1gS/S
	 AkfEZRcdlAImi3VNUNSEAvpa86s4cFkvFXQfDVyjnkwNiFACU4PnaDokP9C19WQ6uIw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793793378;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0FNRQ8vzx8hO9gsNhb2gW3msqRx6v5HSfbK6Brxek5U=;
	b=lo48z4epPf8pEgTBSiUkZ2qP37JDnsMCCKK5PYKcXs8nXiCAjVOHF40nISbgfUm4l1pJ
	 Cp0pFKMcUo29iUtqZ+MBQOB/lDsIoAcK5qr27nStPcfW5sYDMnpxMWyW1XW6HXjoVTDJn
	 slWGoInYt53YeH7pQYiCP8mhtUpN+k29mqiRuZJuhoYa9396G8HWEPin7LLd9PUs4UAAC
	 FCaFQOj/XUOlWPrgDx6/Sc5ePOlNiIdlpOoyGrUdBJsjPZMPvtwVosPcFbRf9C8cH8GqO
	 Cg03S+5RWJRWA6dfFDyU4dNjeFCKqN/Och+rcIJj50IHjwJCrsJePEyhtgR3xh6kywA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1CF361F00A15;
	Wed,  4 Nov 2026 11:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793793378;
	bh=0FNRQ8vzx8hO9gsNhb2gW3msqRx6v5HSfbK6Brxek5U=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=YdxjwQs6tXcNB20gkMoc2BZ18FWvwc+tqNy6W2bN2JDkYBJsPy6hQ7y3n/7Wa0BHA
	 FtrlVzWl/3AkT1b4mlOeplIp6Wpy6IwPPpogtylK6jmy3mRoUdzt7CthunvGpli+wg
	 9049KvTVQ9/geCAYDL4Aawu3A+6aZYD5Gjmh15z9/n5j/NVAnxWexVSDuMtrcA1jJg
	 iq2JEgfly0E7hgXCGljXtwDUAQ4cWcgjLGhr7MBz5q7q9faZMqKwxYk8ZSPY20su41
	 38ZgtvujC9+UzUZh6BKa+PJbAU0AASIwK1um5cJnl/7+TYrDR26MfG34FWRnEsWM9Y
	 FmI9wgx72q01A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A03E946DFB;
	Wed,  4 Nov 2026 11:56:17 +0000 (UTC)
From: orkunsari via B4 Relay <devnull+sariorkunemin.gmail.com@kernel.org>
Date: Wed, 04 Nov 2026 14:56:18 +0300
Subject: [PATCH wireless] wifi: mac80211: check for a NULL link in the MLD
 data RX station loop
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
Message-Id: <20261104-mac80211-mld-null-link-v1-1-4cc9a00bbbaa@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQrCMBAAv1L27EI2FAl+RTw0yUZX0yjZVgulf
 2/U4zDMrKBchRVO3QqV36LyLA3o0EG4DeXKKLExWGOPRKbHcQjOWCIcc8Qy54xZygOdTaH3zqe
 YCFr8qpxk+Y3P8JHKmVXh8jc6+zuH6fuFbdsBMF0ghYQAAAA=
X-Change-ID: 20261104-mac80211-mld-null-link-82fc4b8bfdf1
To: Johannes Berg <johannes@sipsolutions.net>, 
 Benjamin Berg <benjamin.berg@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 orkunsari <sariorkunemin@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793793377; l=1765;
 i=sariorkunemin@gmail.com; s=20261103; h=from:subject:message-id;
 bh=R4DVcGmhbdWe+b3QFvbYRb9TQYVI7s9L2sx1d5WG1rQ=;
 b=dMPK1NSn0yZQ9+t4JrJyygrZyb2mRH6moFkv3IhuRP687NJWXba5gz7PtDT1+IIUyfARFQnn2
 TAbL+MUJ0s/ARqo6oNYR5UlPFVn/Y0OlX98CpLyUHeDeP4KWAsmj+qv
X-Developer-Key: i=sariorkunemin@gmail.com; a=ed25519;
 pk=MJ3Y3somkGDQVAXOSR189QAqWOcfzYCRkL1cSQgJXnE=
X-Endpoint-Received: by B4 Relay for sariorkunemin@gmail.com/20261103 with
 auth_id=1408
X-Original-From: orkunsari <sariorkunemin@gmail.com>
Reply-To: sariorkunemin@gmail.com
Content-Transfer-Encoding: 7bit

From: orkunsari <sariorkunemin@gmail.com>

Since commit 6d531b9af16e ("wifi: mac80211: rework RX packet
handling"), the loop over MLD link stations in
__ieee80211_rx_handle_packet() passes the result of
rcu_dereference(sdata->link[link_sta->link_id]) straight to
ieee80211_rx_valid_freq(), which dereferences link->sdata.

ieee80211_vif_update_links() clears sdata->link[] for a removed link
before ieee80211_sta_remove_link() and sta_info_flush() take the
corresponding link stations out of the hash table, so a frame received
from that link's address in between finds a link station whose link
pointer is NULL.  The management frame path already checks for this.

Skip link stations without a link, as the management path does.

This was found by AI-assisted code review (Claude Code).  The fix has
been build-tested with W=1 only; no reproducer was run.

Fixes: 6d531b9af16e ("wifi: mac80211: rework RX packet handling")
Signed-off-by: orkunsari <sariorkunemin@gmail.com>
---
Regression in v7.4-rc1 only; released kernels are not affected.
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ecee9348c7..038bca60a7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5469,7 +5469,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			sdata =	sta->sdata;
 			link = rcu_dereference(sdata->link[link_sta->link_id]);
 
-			if (!ieee80211_rx_valid_freq(status->freq, link))
+			if (!link || !ieee80211_rx_valid_freq(status->freq, link))
 				continue;
 
 			if (rx_data_pending) {

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261104-mac80211-mld-null-link-82fc4b8bfdf1

Best regards,
--  
orkunsari <sariorkunemin@gmail.com>


