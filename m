Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5254F3E63B2;
	Tue, 25 Aug 2026 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649860; cv=none; b=hb487Xlhht4PicsoahtfSGZBpmtrFQtC3l7MrPMOegKuO/Tuo4ydymYlYTDkIxeMU2IzsJgbbKYZZWaPSleBdCsrK4XPFM1gxEd24shhCUyWZtzJzQzf+Vf+4iXXACkvNPyIzgw1SE7ns4FWibsbohqbn/X6hkI7Fl/1Tt2via4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649860; c=relaxed/simple;
	bh=v+tiWKC3eZynwQYTPf7w9d5BBN1wPqEzi5eZx+MT26I=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=mvu4qIviUC2DDdrOy0XWXQMYKcwRoxO/w+YJhKtX5Mh9YM+Qddq7wQAfobBrTmngWRazQwm+a+LHI+hoLJwJQlGdw7LbBjhiaMlThqrJUA2b76A/IejXNIMVv7jett2HWHgFJfZ4vGAf16GNy4RtEO9b4Q48ywxmTZwDY1pAwR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=PJAQmICm; arc=none smtp.client-ip=203.205.221.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="PJAQmICm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787649850; bh=v+tiWKC3eZynwQYTPf7w9d5BBN1wPqEzi5eZx+MT26I=;
	h=Date:To:Cc:From:Subject;
	b=PJAQmICmdLibA8/HphF0XRtKXietOVaKOAn8SEOIlJCkCVE15wXtX4WG96CAayIYR
	 spkn0Z66v5QIh9gV5ih0r8+NW0GHiIsqvNw0Aphie3gZajHQnlqd+qZCufusl8AeGi
	 9zRh4N847z4xmAClalIhWJ8Y6Oq4mwxIvsYRWYKU=
Received: from [192.168.255.10] ([111.206.96.146])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 60806E69; Tue, 25 Aug 2026 17:24:08 +0800
X-QQ-mid: xmsmtpt1787649848twofho2wq
Message-ID: <tencent_E7F524BBDD4B458C2FD4C1DBE86C7C062105@qq.com>
X-QQ-XMAILINFO: Npb+f4q7yCDRX+7ILtyrvJ0B6wlkQiFtpvjCYsWw2aoV85P7GDkmb1FcFieVOj
	 K78pYwSynDBgbvTpIfcF3zBHfu41DQmEq0YkukeAvNEmyFKQrXP/qVSZTQ51bNxoFwuBk6a/shl1
	 AmX2Qaacpr5Wm0Z7Wm+iUexzaTBv/JFNloatGScJvW+A+2kNKdyMCVtZQbSvqhSJ75+/V4qpJqNZ
	 YPxWat61lA+BlxdPUK4lVYK0072q2YLY3wxyPa9g9px2zA9Kuq1B1Re/hMoNwzrOoiwWqwvhXK9I
	 C3KqHYtkmkJllBCzKrScZwXjbvYCB22TWtGwp0kMhrdo6+EIvG9gzLZ31Ud3HqoyWLqyDGQjlRQC
	 /dVw1VO3AjZyoyUFIehKENs/JakUrRJ/YicnKv2vHuU4JHS5x3THr1THE76vOsAjKin4vXQCboh+
	 sh4VO3/4w8rzwIujcpYb8n7+jvz8Wh/NbQ6EHiHJQ2nMitftZhCOpQeqlBANiOGuUBPham3aIhMF
	 KYapWTs5OuxORaX6cvD+Es+4BkhReGrnk3uq2u62VZsoe/8jZlK8Ds6kg2g6nGPeSYQS/TZhteJN
	 dFZahYAVBWTAFmSR//PW85weFx+t89TVwjR2QQhNZqisgNIHFSKP6PA5srmoS8e2ILG7vuXZC7HM
	 sL5n22sNE3hzDv3WgGzJVOawl49ZB+J8CtmjR8P63jotSmO990GHhtsq0pJVi3+YfYdZsgkKISrm
	 Se4pcUyiZITsUSl0OsUfM8iCMXLKfsbZRFoxbo0QlHvXMdWRcsVwff83G2XzB2laS6bTvGuu1W0N
	 thE0Jkdh4aau2xIgUsttqC5IHdWRpMxKOQ5c66icnYfRn3OhymLGbJkgzFLwmyWW/smx1opUngpm
	 RfwgfgmYVNe7W5PYMS6MZoLWZ2/sliLy4en3PEUtVb4EMlkHTNSf7uMMLBzpoNZ0EllNuRkG4gxO
	 hDnP/5dsPgPaTvWeYNJ0HYqMJeVddc1g6h30ROjmGRckGt0Pi1n+AxPv0JOylzo/BhBh0DiBl50v
	 Imo5e8QzKYzapekRB8bbUqeyIJrthfhnOHTLjpPtr0V4MqbCOUsxyfiJLLaQ6fGwXIoxdE/vRYEb
	 BMQP4UCsR5FgdK/Ak=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-OQ-MSGID: <de40efe7-bd93-4308-9605-f8b8976b35ff@qq.com>
Date: Tue, 25 Aug 2026 17:24:06 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: johannes.berg@intel.com, johan@kernel.org, kees@kernel.org
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
 linux-kernel@vger.kernel.org
From: Yang Zi <2959243019@qq.com>
Subject: [PATCH] wifi: libertas_tf: Fix slab-out-of-bounds write in
 if_usb_send_fw_pkt()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

if_usb_send_fw_pkt() copies a firmware block into the driver's
ep_out_buf using the length taken directly from the firmware header
(fwdata->hdr.datalength) without any validation.  That same untrusted
value is also used as the USB transfer length and to advance
cardp->totalbytes.

A crafted or truncated firmware image can set datalength to a huge value,
which makes the memcpy() into fwdata->data write far past the end of the
1574-byte ep_out_buf (KASAN reports a ~3.5 GiB slab-out-of-bounds write)
and, once totalbytes has run away, makes the subsequent header memcpy()
read past the end of the firmware image.

check_fwfile_format() only checks the cumulative length and never bounds
an individual block, and FW_MAX_DATA_BLK_SIZE (600) is never used.

Validate the block length in if_usb_send_fw_pkt(): reject any block whose
datalength exceeds FW_MAX_DATA_BLK_SIZE or the number of bytes remaining
in the firmware image, and return -EINVAL before the memcpy().  Also
enforce the per-block upper bound in check_fwfile_format() so that
invalid images are rejected up front.

Signed-off-by: Yang Zi <2959243019@qq.com>
---
diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index b85c6d783bf7..f82860b77da2 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -268,6 +268,7 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 {
     struct fwdata *fwdata = cardp->ep_out_buf;
     u8 *firmware = (u8 *) cardp->fw->data;
+    u32 datalength;
 
     lbtf_deb_enter(LBTF_DEB_FW);
 
@@ -291,17 +292,24 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
     cardp->fwlastblksent = cardp->totalbytes;
     cardp->totalbytes += sizeof(struct fwheader);
 
-    memcpy(fwdata->data, &firmware[cardp->totalbytes],
-           le32_to_cpu(fwdata->hdr.datalength));
+    datalength = le32_to_cpu(fwdata->hdr.datalength);
+    if (datalength > FW_MAX_DATA_BLK_SIZE ||
+        cardp->totalbytes > cardp->fw->size ||
+        datalength > cardp->fw->size - cardp->totalbytes) {
+        lbtf_deb_usb2(&cardp->udev->dev,
+                  "invalid firmware block length %u\n", datalength);
+        return -EINVAL;
+    }
 
-    lbtf_deb_usb2(&cardp->udev->dev, "Data length = %d\n",
-             le32_to_cpu(fwdata->hdr.datalength));
+    memcpy(fwdata->data, &firmware[cardp->totalbytes], datalength);
+
+    lbtf_deb_usb2(&cardp->udev->dev, "Data length = %u\n", datalength);
 
     fwdata->seqnum = cpu_to_le32(++cardp->fwseqnum);
-    cardp->totalbytes += le32_to_cpu(fwdata->hdr.datalength);
+    cardp->totalbytes += datalength;
 
     usb_tx_block(cardp, cardp->ep_out_buf, sizeof(struct fwdata) +
-             le32_to_cpu(fwdata->hdr.datalength), 0);
+             datalength, 0);
 
     if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_DATA_TO_RECV)) {
         lbtf_deb_usb2(&cardp->udev->dev, "There are data to follow\n");
@@ -775,6 +783,10 @@ static int check_fwfile_format(const u8 *data, u32 totlen)
         blksize = le32_to_cpu(fwh->datalength);
         switch (bincmd) {
         case FW_HAS_DATA_TO_RECV:
+            if (blksize > FW_MAX_DATA_BLK_SIZE) {
+                exit = 1;
+                break;
+            }
             offset = sizeof(struct fwheader) + blksize;
             data += offset;
             len += offset;
@@ -782,6 +794,10 @@ static int check_fwfile_format(const u8 *data, u32 totlen)
                 exit = 1;
             break;
         case FW_HAS_LAST_BLOCK:
+            if (blksize > FW_MAX_DATA_BLK_SIZE) {
+                exit = 1;
+                break;
+            }
             exit = 1;
             ret = 0;
             break;

