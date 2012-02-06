Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65249 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2BFPst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 10:48:49 -0500
Received: by daed14 with SMTP id d14so542234dae.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 07:48:49 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 6 Feb 2012 16:48:49 +0100
Message-ID: <CAGXE3d-ydmV8qrtihSHCNBtkTxT8M=JCACBZFuP+Ne3cQ1WVow@mail.gmail.com> (sfid-20120206_164853_205520_EC6E0AD1)
Subject: DELBA processed in workqueue too slow?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

since all action frames are handled in the iface workqueue the following
situation can cause problems on slow devices in AP mode:

- data stream AP -> STA with established TX BA session
- peer sends a DELBA to tear the APs TX BA session down
- new frames are still send as AMPDU but the receiver doesn't BlockAck
  them anymore since it assumes the BA session is already teared down.
- DELBA gets processed

Hence, most frames between receiving the DELBA and actually processing
it are basically lost. This can easily make TCP streams getting stuck for a
few seconds :(

Any ideas?

Thanks,
Helmut
