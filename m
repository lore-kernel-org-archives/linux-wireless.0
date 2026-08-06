Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B433115AF
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786013306; cv=none; b=A/CFxACO6VXYOTj2/ArFAenH93CuOEdH/jF9LpBxCczBXYTpNrIFTuPV0SLouIkV403fC0sSd5yn+SSGRxCWUNvPmdidh6jm9ncC4BDgi1qwHip11uZ7ug13vki0jkyXWZVJpE8AQD9pvTxTY3sQzCpET8B6fZyOj8IoPiJLJGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786013306; c=relaxed/simple;
	bh=g+JIjgCGD8pYHgloXfxcgCIBDE+57bytIqMKJ4nsoDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rh5WYQXRmwrftVaK/JRHUZkZjXkuNVTJwTI31QzQocPvhjMS8ECv/5xlLeTaARN9VksdsuN56Nr+t6GI6WeQwukIFcvV1OQbkuyNLxa6JCOs6Sry2QJExzq52zbStlngWSWoheQ4mDjB2VgzTNrIWTfYuvOsE+9tfnQRzS7AXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PosoEICd; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PosoEICd"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38e3617ba36so2081555a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786013305; x=1786618105; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=flSv7xBdlCbrg4AJcw6jzs2xlfv6qS2mtAaegxjbgz0=;
        b=PosoEICdy2NY0B7DHi5ZMlgduIptpI4BbYFf/v0nMMB1oOR0z7VOVlU/pEDaTgZ93D
         UuPrBVZIx5Z49lEfvsYXrhgi/TT7d3MfJekyHlfrU3wGXdezB10cmsiKM7TJRKeTnMby
         p5nuOoSAEvE4LtH1gPo7CrzCPhgy5RhjpGLo+TPN48I1HthJ9wZq5JfY5ugmdMwCprlt
         e7O+qIy6bh6jMUV8/KvZDH8FaN2spFLYjiNRg3gyLnYmhl2rnr4SWWdou322hks+lDkQ
         vD2NBHmVKpKYoH99LQkUuun3m6UIE57cxLTT1bQwYet4+QqtW5rvyEI/dT2J8M+UX2hI
         BqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786013305; x=1786618105;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=flSv7xBdlCbrg4AJcw6jzs2xlfv6qS2mtAaegxjbgz0=;
        b=DdULOD26iiYQoU1jJv+51jt/9Nd04GJgFmt2GshBOATPANvb+Y+Xs8eGgzpOpqkthK
         iQVtnDMvj1ktfL+Li2C/e4DeCsRnR5khUCASGWMYJiHEymdHN5TUD2/siUusjw8DBme8
         t8iznZruWrOyYciBt0GY1TPyufixTAJlkDk+pOrWIcXiOoj0mGnTB4ppn5xxN8QA1Mkh
         e1kskBll2PLTzVZl+64K9xBF/YcYLnWLmxkd19M/VJhvwrqeWjhCX6tN2VB/VRvIViC8
         /IXizi1uhQE/GA9s4XNHhqFgIBWDBAjWEiw2+DzISY8KrroDHsQUl3YwCmGbNUtAcfsP
         c0BQ==
X-Gm-Message-State: AOJu0Yzvad6GFUfwMgGWEw/J3Up7aj33R/dHv6ep+5q+pR9Z65kVrlzE
	y8MwYtqAcT6buT9+gYsizCJVkeX93t5NAZJLLi/626o+V8J0c/BP7lYN
X-Gm-Gg: AR+sD13uOtyHrMCUEvYskzfI9u/24RVdlYlDSc9A21Gd7d9PHn41zGHJxZKMEIKs31f
	bc1GifzFz+02AqOUiQG+Qmf6iAc8vTeus595JVm2QXSsZKi83tInuhjYfULqurU63apKWp3EsBj
	gUkAct4561j9wJhUBNvn71n11PL3cNNsDtexFK1Y3cHY2I7se932ZHQiwjzbi9haD6ki7LdARVQ
	HYfz5mtApkb5KvwgtRAySGa8Y3l1KckPa5fEAEkXYTpIRRfmYtQ5iYmbPysmPhTwnb8E1x/osks
	6gexWvpZHGmFy0So4fAMuyv2A/geeI3bmZG8cwIwsR8DIUOSQrvqkmm9JofpTsG/jN4g6nT9tBB
	4XHHsur0TzgN/Np8D8+XChun0vcKZjPAjz6qBrT4TyvcWX85OaEFnKKfNPqNL/d087xZO2B4Q7e
	vMwnsNsuc4lcXYXbdwNCSmjqtXjxHymFDisEQfcGn4Zgjg5vF7azpR5pD5H7SHraP92RcWoPDYz
	uQGdiAZnkzHkFa6B+/vEpRZBms=
X-Received: by 2002:a17:90b:3985:b0:37c:18e0:90dc with SMTP id 98e67ed59e1d1-3903c5f41ccmr10892238a91.16.1786013304585;
        Thu, 06 Aug 2026 03:48:24 -0700 (PDT)
Received: from localhost ([2409:40c4:9:327d:da04:751e:1623:ed1b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158644a195sm24887835eec.13.2026.08.06.03.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:48:23 -0700 (PDT)
Date: Thu, 6 Aug 2026 16:18:20 +0530
From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
To: Snake Pilot <snakepilot10@gmail.com>
Cc: linux-wireless@vger.kernel.org, pkshih@realtek.com, 
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] rtw88_8723de: Wi-Fi and Bluetooth fail after warm reboot
Message-ID: <anRcsdWWWX7zyfj5@eggarch>
References: <CA+fxq6gPCQOYr6mh+_1ReOGzaiTULzMazXhs5q0PXc8PsjRJEQ@mail.gmail.com>
 <amnGXPlG6nKUdEl7@eggarch>
 <CA+fxq6i05RW5G289EL9V_uUgidQhDOpUhiy_J++pDDwqLwJp0Q@mail.gmail.com>
 <am0AOC9ZmP81kGcT@eggarch>
 <CA+fxq6hD-duO3g1gEEQL5o+_S-y8dfFDerD58=scNsd9WfdU5Q@mail.gmail.com>
 <am4JYI-tXa-rK7Hq@eggarch>
 <CA+fxq6gBYA=qDrOQ+LmPHPdVGagtR0Vdnm_KeAC=nM7c-GSu5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tp5bmuxrjjlhbjdh"
Content-Disposition: inline
In-Reply-To: <CA+fxq6gBYA=qDrOQ+LmPHPdVGagtR0Vdnm_KeAC=nM7c-GSu5g@mail.gmail.com>


--tp5bmuxrjjlhbjdh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 02, 2026 at 11:40:51PM -0600, Snake Pilot wrote:
> Bluetooth: hci0: diag: hci_dev_shtudown: HCI_UP=1 HCI_UNREGISTER=0
> Bluetooth: hci0: diag: calling vendor shutdown callback
> Bluetooth: hci0: diag: btrtl_shutdown_realtek: sending HCI_OP_RESET
> Bluetooth: hci0: diag: btrtl_shutdown_realtek: HCI_OP_RESET completed OK
> Bluetooth: hci0: diag: vendor shutdown returned 0
I'm thinking if reset itself is the problem, since it does not run on
unloading manually but it does on shutdown.

> I did not find the btusb shutdown or rtw_pci_shutdown/D3hot diagnostic
> messages in the persisted previous-boot journal. The journal appears to end
> before the final device shutdown stage, so their absence from the journal
> does not necessarily mean that the callbacks were not invoked.
Yeah it seems it runs after journal is gone.

I suppose we should test by skipping HCI_OP_RESET if that improves the
issue.

Could you apply the attached patch only and start with a cold boot then
do a warm reboot and send the previous and current journal just like you
did before?

Thanks,
Lovekesh

--tp5bmuxrjjlhbjdh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="skip-hci-reset.patch"

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 184e95c1625e..e7dd19b20cc8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3889,6 +3889,12 @@ static int btusb_shutdown_qca(struct hci_dev *hdev)
 	return 0;
 }

+static int btusb_shutdown_rtl8723de(struct hci_dev *hdev)
+{
+	bt_dev_info(hdev, "skipping HCI_OP_RESET......");
+	return 0;
+}
+
 static ssize_t force_poll_sync_read(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
@@ -4338,6 +4344,9 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags);
 	}

+	if (id->idVendor == 0x0bda && id->idProduct == 0xb009)
+		hdev->shutdown = btusb_shutdown_rtl8723de;
+
 	if (id->driver_info & BTUSB_ACTIONS_SEMI) {
 		/* Support is advertised, but not implemented */
 		hci_set_quirk(hdev, HCI_QUIRK_BROKEN_ERR_DATA_REPORTING);

--tp5bmuxrjjlhbjdh--
