Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52084 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752308AbdLBUXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 15:23:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: j@w1.fi, David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
Date: Sat,  2 Dec 2017 21:23:31 +0100
Message-Id: <20171202202332.10205-1-johannes@sipsolutions.net> (sfid-20171202_212358_779029_838D8F16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This netlink type is used only for backwards compatibility
with broken userspace that used the wrong size for a given
u8 attribute, which is now rejected. It would've been wrong
before already, since on big endian the wrong value (always
zero) would be used by the kernel, but we can't break the
existing deployed userspace - hostapd for example now fails
to initialize entirely.

We could try to fix up the big endian problem here, but we
don't know *how* userspace misbehaved - if using nla_put_u32
then we could, but we also found a debug tool (which we'll
ignore for the purposes of this regression) that was putting
the padding into the length.

Fixes: 28033ae4e0f5 ("net: netlink: Update attr validation to require exact length for some types")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 1 +
 lib/nlattr.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 0c154f98e987..448a9b86c959 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -180,6 +180,7 @@ enum {
 	NLA_S32,
 	NLA_S64,
 	NLA_BITFIELD32,
+	NLA_U8_BUGGY, /* don't use this - only for bug-ward compatibility */
 	__NLA_TYPE_MAX,
 };
 
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 8bf78b4b78f0..2b89d25d4745 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -28,6 +28,7 @@ static const u8 nla_attr_len[NLA_TYPE_MAX+1] = {
 };
 
 static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
+	[NLA_U8_BUGGY]	= sizeof(u8),
 	[NLA_MSECS]	= sizeof(u64),
 	[NLA_NESTED]	= NLA_HDRLEN,
 };
-- 
2.14.2
