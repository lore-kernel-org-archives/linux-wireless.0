Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44116 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbeBIUEu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 15:04:50 -0500
Received: by mail-pg0-f65.google.com with SMTP id j9so3749497pgp.11
        for <linux-wireless@vger.kernel.org>; Fri, 09 Feb 2018 12:04:50 -0800 (PST)
Date: Fri, 9 Feb 2018 12:04:47 -0800
From: Kees Cook <keescook@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thierry Escande <thierry.escande@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: llcp: Limit size of SDP URI
Message-ID: <20180209200447.GA33465@beast> (sfid-20180209_210507_781448_26C5716B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tlv_len is u8, so we need to limit the size of the SDP URI. Enforce
this both in the NLA policy and in the code that performs the allocation
and copy.

Fixes: d9b8d8e19b073 ("NFC: llcp: Service Name Lookup netlink interface")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
Alternatively, tlv_len switch to size_t, but we'd still have to do the "-4"
calculation.
---
 net/nfc/llcp_commands.c | 4 ++++
 net/nfc/netlink.c       | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 367d8c027101..2ceefa183cee 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -149,6 +149,10 @@ struct nfc_llcp_sdp_tlv *nfc_llcp_build_sdreq_tlv(u8 tid, char *uri,
 
 	pr_debug("uri: %s, len: %zu\n", uri, uri_len);
 
+	/* sdreq->tlv_len is u8, takes uri_len, + 3 for header, + 1 for NULL */
+	if (WARN_ON_ONCE(uri_len > U8_MAX - 4))
+		return NULL;
+
 	sdreq = kzalloc(sizeof(struct nfc_llcp_sdp_tlv), GFP_KERNEL);
 	if (sdreq == NULL)
 		return NULL;
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index c0b83dc9d993..f018eafc2a0d 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -61,7 +61,8 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 };
 
 static const struct nla_policy nfc_sdp_genl_policy[NFC_SDP_ATTR_MAX + 1] = {
-	[NFC_SDP_ATTR_URI] = { .type = NLA_STRING },
+	[NFC_SDP_ATTR_URI] = { .type = NLA_STRING,
+			       .len = U8_MAX - 4 },
 	[NFC_SDP_ATTR_SAP] = { .type = NLA_U8 },
 };
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
