Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZEMKFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 06:05:02 -0400
Subject: [PATCH] wext: verify buffer size for SIOCSIWENCODEEXT
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 May 2009 12:04:30 +0200
Message-Id: <1242209070.29288.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another design flaw in wireless extensions (is anybody
surprised?) in the way it handles the iw_encode_ext
structure: The structure is part of the 'extra' memory
but contains the key length explicitly, instead of it
just being the length of the extra buffer - size of
the struct and using the explicit key length only for
the get operation (which only writes it).

Therefore, we have this layout:

extra: +-------------------------+
       | struct iw_encode_ext  { |
       |     ...                 |
       |     u16 key_len;        |
       |     u8 key[0];          |
       | };                      |
       +-------------------------+
       | key material            |
       +-------------------------+

Now, all drivers I checked use ext->key_len without
checking that both key_len and the struct fit into the
extra buffer that has been copied from userspace. This
leads to a buffer overrun while reading that buffer,
depending on the driver it may be possible to specify
arbitrary key_len or it may need to be a proper length
for the key algorithm specified.

Thankfully, this is only exploitable by root, but root
can actually cause a segfault or use kernel memory as
a key (which you can even get back with siocgiwencode
or siocgiwencodeext from the key buffer).

Fix this by verifying that key_len fits into the buffer
along with struct iw_encode_ext.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-testing.orig/net/wireless/wext.c	2009-05-13 11:47:04.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-05-13 11:47:25.000000000 +0200
@@ -798,6 +798,13 @@ static int ioctl_standard_iw_point(struc
 			err = -EFAULT;
 			goto out;
 		}
+
+		if (cmd == SIOCSIWENCODEEXT) {
+			struct iw_encode_ext *ee = extra;
+
+			if (iwp->length < sizeof(*ee) + ee->key_len)
+				return -EFAULT;
+		}
 	}
 
 	err = handler(dev, info, (union iwreq_data *) iwp, extra);


