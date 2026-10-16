Received: from mail.systemli.org (mail1.systemli.org [93.190.126.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4028E3431E3;
	Fri, 16 Oct 2026 19:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179810; cv=none; b=sZWio5Nqk0oZOiKGf4K9pv9mfk7InwdZreUPk0TnhlYr4TFTUkiLXwPHE75svMJCt3jNfbDrL8oYiqb/LdKaInBq3dBkcv1HWqoYdqWL6NA3lA6gihfz5hpsGCW7eBXkSpvVzg1Kjl6SpZ6vvBexhLHplKXmuo1kk+IsGc89aLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179810; c=relaxed/simple;
	bh=PSY8/6Ht3695dETAQ+IJZfbjd4ZsJrNu+wFt2aorenY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M15YKuKm/6G2zm2p9Bw4oJoBbTkB/KTQWXwmcy4tOZa3pIxVq9960z8HQ7OgoB2XmRKVstCIj/eMbfXJbYlrbE5S2NAhOWPuvhWI/8qUOMuEwlY8lFO1ZiPNKC5uAB4/Hd0WmQoMXrblhQZXftxPwMWpZH3bRU+HcmGES/DeX9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=systemli.org; spf=pass smtp.mailfrom=systemli.org; dkim=pass (2048-bit key) header.d=systemli.org header.i=@systemli.org header.b=Yu90jTZL; arc=none smtp.client-ip=93.190.126.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=systemli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=systemli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=systemli.org header.i=@systemli.org header.b="Yu90jTZL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
	s=default; t=1792179794;
	bh=/q+EF9ABPKDwT5qrXuQd3pJ9+FUswKX0Hp6vlgaMKOQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Yu90jTZL1z7/LwXNZipSwv8Nz+Up3V8rwWbNDr+pi50LxT8BjUiaAHFTU5gPsPiGp
	 URyR/bPN3FlKIg7iXI7eAJ9rCf2J6Iw9KqMiAMSvw0hlGO6gjZbXc5rW+VCJBJB0/y
	 deiBi0I60ve6oyaCeIpORJt67n83tGjcpDu1m4o98GU6xtBnI/v+wnWbVt3ZwNVGS8
	 Eu4jznfvdtPfCoa4QTjFAS3wknUF9zuI3DVwN4TgLNatNS8MGoF9AQ7aWX0t+yZuDw
	 gh5UXd9eRUrTnph4gOG8V1HG9wvH3VxNfEt8Hs0Des1f2xnXQBXfHVatBjHZr9ZNIB
	 Mg1aow0YXuptw==
From: Nick Hainke <vincent@systemli.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Cc: Nick Hainke <vincent@systemli.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next] wifi: cfg80211: map LE DSCP to UP 1
Date: Fri, 16 Oct 2026 21:42:48 +0200
Message-ID: <20261016194248.3508952-1-vincent@systemli.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Report: 
	*  0.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 DKIM_VALID Message has at least one valid DKIM or DK signature
	*  0.0 DKIM_VALID_EF Message has a valid DKIM or DK signature from
	*      envelope-from domain
	*  0.0 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	*  0.0 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]

RFC 8622 [1] updates RFC 8325 [2] and recommends to map Low-Priority
Data marked with the Lower Effort DSCP (LE, 000001, 1) to User
Priority 1 and AC_BK (Background), the same as the legacy CS1 marking.

cfg80211_classify8021d() takes the three most significant bits of the
DSCP as User Priority and corrects some DSCP values in a switch
statement afterwards. LE is not handled there. For LE the DS field
without the ECN bits is 0x04, so:

  ret = dscp >> 5;     /* 0x04 >> 5 = 0 */
  switch (dscp >> 2)   /* 0x04 >> 2 = 1, no case for 1 */

As a result, LE ends up in User Priority 0 and AC_BE (Best Effort)
instead of User Priority 1 and AC_BK. Add a case for LE to the switch
statement.

OpenWrt already sets a QoS Map by default that maps LE to User
Priority 1 [3].

[1] https://www.rfc-editor.org/rfc/rfc8622#section-11
[2] https://www.rfc-editor.org/rfc/rfc8325#section-4.2.10
[3] https://github.com/openwrt/openwrt/commit/a5e3def18224

Fixes: 6fdb8b8781d5 ("wifi: cfg80211: Update the default DSCP-to-UP mapping")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 net/wireless/util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 59912f4a93c8..3f8648b94179 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1154,13 +1154,17 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 	 * value. See section 4 in RFC8325. Specifically, for the following
 	 * Diffserv Service Classes no update is needed:
 	 * - Standard: DF
-	 * - Low Priority Data: CS1
+	 * - Low Priority Data: CS1 (legacy)
 	 * - Multimedia Conferencing: AF41, AF42, AF43
 	 * - Network Control Traffic: CS7
 	 * - Real-Time Interactive: CS4
 	 * - Signaling: CS5
 	 */
 	switch (dscp >> 2) {
+	case 1:
+		/* Low Priority Data: LE, see section 11 in RFC8622 */
+		ret = 1;
+		break;
 	case 10:
 	case 12:
 	case 14:
-- 
2.56.0

