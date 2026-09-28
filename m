Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121C93CFF49;
	Mon, 28 Sep 2026 10:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589916; cv=none; b=D/Ow3mF/6rkrogVqVIsert2F6slkZYSi5QhFQj1fqKLHfA9GlKR5wKSqEgw1PViEPkVnvaZR1TQmce1SoZbeDQxtToKBkiwYa3wq6PjwKq7kx1vtum6McfzAkOat8duqm5TvxHQSM0W9kaUYD+4wwNEp4XSsZWLPhRV/7kKJ6C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589916; c=relaxed/simple;
	bh=Uiq6GDkIqV0pxy+R6na23ovt97S48lC81W9ZPe6kX90=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KuSModwXCB9PAU+MHYjtiBiBLj2uucsYWld9LkS/upVvu+15idQx3hdycBje39MBxK304qhhhQc74jLX6D/es2Vx9utDl+nksuyQuUPsN8Gxikk0Hqtwgdyskt+VKG/oxIDduffmsF7HdcuK2wVan8Z+zSSng98flUNBdtnXZh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ajg6V9xt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ajg6V9xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBE81F00893;
	Mon, 28 Sep 2026 10:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790589914;
	bh=8yqolfm0mcVW7FfJtbKsxfRG9k5xJgZATQnAiLH96N8=;
	h=From:To:Subject:Date;
	b=Ajg6V9xtlYMyhM5Wg8xtlZTcf5JHCAJL/UPBX/O9QTTHYVUQYSCyFUDJsi1EzVzyQ
	 5dKdSV1XUjmXFqn6ILfH8iKftf4mpvqRWJRWPguqrg3HOfmppeHl19ta9KHnLFvMOD
	 KfBw2Lcuk6uIFA/f7kTpUdjRvyR7jCe7oRk4EUqdpU1HYPAmuu+2eObHrfB1/0dYob
	 09ER3yy7rmAbwov4d7Gfw+gz+tA5dpYLJR7yMsbJ3Ti4zjzOdpliDBe/oDqcmZLjAr
	 ReLQxCJQbHrVAyn5kud3TJTWBLfJI9OVAT8fpDXL0hd3T01UVEbNuOpQO7yt/HyXMP
	 mF8pRez9sO8QQ==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable MMPDUs for PS start
Date: Mon, 28 Sep 2026 10:05:07 +0000
Message-ID: <20260928100508.3487525-1-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per IEEE 802.11, the Power Management subfield in the Frame Control
field is reserved in non-bufferable management frames (such as
Authentication, Association Request, and Reassociation Request) and a
station remains in Active mode during authentication and association.

When commit 9fef65443388 ("mac80211: always update the PM state of a
peer on MGMT / DATA frames") allowed non-bufferable management frames
to update peer power-save state so that re-authenticating stations
could transition from doze to awake (sta_ps_end()), it also allowed
non-bufferable management frames with the Power Management bit set to
transition an awake station into power-save mode (sta_ps_start()).

Restrict wake-to-doze transitions (sta_ps_start()) in
ieee80211_rx_h_sta_process() to data, action, disassociation, and
deauthentication frames using hdr->frame_control (avoiding inspecting
encrypted action frame payloads prior to ieee80211_rx_h_decrypt()) while
preserving doze-to-wake transitions (sta_ps_end()).

Fixes: 9fef65443388 ("mac80211: always update the PM state of a peer on MGMT / DATA frames")
Signed-off-by: Lee Jones <lee@kernel.org>
---
 net/mac80211/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f5893f9c07c6..8e90d0d7b87f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1924,7 +1924,11 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			if (!ieee80211_has_pm(hdr->frame_control))
 				sta_ps_end(sta);
 		} else {
-			if (ieee80211_has_pm(hdr->frame_control))
+			if (ieee80211_has_pm(hdr->frame_control) &&
+			    (ieee80211_is_data(hdr->frame_control) ||
+			     ieee80211_is_action(hdr->frame_control) ||
+			     ieee80211_is_disassoc(hdr->frame_control) ||
+			     ieee80211_is_deauth(hdr->frame_control)))
 				sta_ps_start(sta);
 		}
 	}
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

