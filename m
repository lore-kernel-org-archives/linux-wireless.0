Return-Path: <SRS0=WqAe=ZU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFE5C432C0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 09:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F1721787
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 09:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DsYH/3IY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfK1JLo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Nov 2019 04:11:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21967 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725789AbfK1JLo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Nov 2019 04:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574932302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XmycgMIOGvZRyrgTDh7MEI7MOmGVCy/bdT6ckpAgvsA=;
        b=DsYH/3IY/UeTyVhW6WorpR/Jzkcr2wM/LI7SOr97YDOwaQHwwYKagFRczV5LIKS5msNCro
        IXxyVweGXK5h23cJ/ccBdCWTBU3saZghzpKyxwrpIqKwQrZuxe5wxbrQkbMPT4GpkfHZ6Q
        ptPJnzbjx+HinFWwdLy+CKAZZVHp/CM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-HayJX1xNMoG7hn_YbjGJYg-1; Thu, 28 Nov 2019 04:11:37 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 406C78017CC;
        Thu, 28 Nov 2019 09:11:36 +0000 (UTC)
Received: from localhost (ovpn-205-99.brq.redhat.com [10.40.205.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08659600CA;
        Thu, 28 Nov 2019 09:11:32 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH 2/2] rt2x00: use RESET state bit to prevent IV changes on restart
Date:   Thu, 28 Nov 2019 10:11:24 +0100
Message-Id: <20191128091124.15806-2-sgruszka@redhat.com>
In-Reply-To: <20191128091124.15806-1-sgruszka@redhat.com>
References: <20191128091124.15806-1-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: HayJX1xNMoG7hn_YbjGJYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We can not set IV when we are under reset. Previously we read previous
IV value from registers and zeroed IV registers when key was deleted,
but this could possibly not work if DEL_KEY command was not performed.

Now when we have ->reconfig_complete ops and we fully mark mac80211
reset state via DEVICE_STATE_RESET flag, we can just skip setting IV
when keys are set during reset.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/w=
ireless/ralink/rt2x00/rt2800lib.c
index f1cdcd61c54a..590e4fa9e5e4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1652,20 +1652,17 @@ static void rt2800_config_wcid_attr_cipher(struct r=
t2x00_dev *rt2x00dev,
 =09=09rt2800_register_write(rt2x00dev, offset, reg);
 =09}
=20
-=09offset =3D MAC_IVEIV_ENTRY(key->hw_key_idx);
+=09if (test_bit(DEVICE_STATE_RESET, &rt2x00dev->flags))
+=09=09return;
=20
-=09if (crypto->cmd =3D=3D SET_KEY) {
-=09=09rt2800_register_multiread(rt2x00dev, offset,
-=09=09=09=09=09  &iveiv_entry, sizeof(iveiv_entry));
-=09=09if ((crypto->cipher =3D=3D CIPHER_TKIP) ||
-=09=09    (crypto->cipher =3D=3D CIPHER_TKIP_NO_MIC) ||
-=09=09    (crypto->cipher =3D=3D CIPHER_AES))
-=09=09=09iveiv_entry.iv[3] |=3D 0x20;
-=09=09iveiv_entry.iv[3] |=3D key->keyidx << 6;
-=09} else {
-=09=09memset(&iveiv_entry, 0, sizeof(iveiv_entry));
-=09}
+=09offset =3D MAC_IVEIV_ENTRY(key->hw_key_idx);
=20
+=09memset(&iveiv_entry, 0, sizeof(iveiv_entry));
+=09if ((crypto->cipher =3D=3D CIPHER_TKIP) ||
+=09    (crypto->cipher =3D=3D CIPHER_TKIP_NO_MIC) ||
+=09    (crypto->cipher =3D=3D CIPHER_AES))
+=09=09iveiv_entry.iv[3] |=3D 0x20;
+=09iveiv_entry.iv[3] |=3D key->keyidx << 6;
 =09rt2800_register_multiwrite(rt2x00dev, offset,
 =09=09=09=09   &iveiv_entry, sizeof(iveiv_entry));
 }
--=20
2.13.5

