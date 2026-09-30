Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D76B4F4036
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786974; cv=pass; b=lguzqAdc5pqGghd8jtKI6YbalDS4ibYKvsS6B1b+s2YN3dVQ318aH9qOzfP91EKhAN359tLtzHkqWgu6P30Zg/JoikFcYHIM+2fLDI1zW2xLLcJijBiLoPkaUD7of8Dd3g3nES6Kd1ZuzSap9u4NzInOaBLTLH5nHrdzruT7Y/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786974; c=relaxed/simple;
	bh=m/oaydNeB7KKez2Jzp2jljrx95qkFNgazQFseegu3Nw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qs8UhBodkD0chXvR+B8+jgXLrJJeVWgTEGUi3nrM+wTG2O4OMk1kwx2x+l7NTiAqYg7Lr5uWbbMVHXt80o1c9CHj+s3yr+Eno5yaAI8gJd6Mb7cO+b2IukwuceGYqnDb0oqMTjDNGqh5FQy9vlnOlKeR1YY6UPDlbc4jUokzdMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tCcTd+DL; arc=pass smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tCcTd+DL"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910704e63a9so9175776d6.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:49:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790786971; cv=none;
        d=google.com; s=arc-20260327;
        b=Dweyd4kdv1S48YzId3UM2VdvwK4+oDMsTd6KU7F4V5APC7gcylmJm2M5X7i936jwi+
         KYvPoL7JWNnf94waeZycXaF8/XmjkQmVYDW5Fw7622wtUqGcPYJVMBNkipHTPDWfp58e
         ssqBs3ijCFqu7aOmTJpaQi1vG4TvLCiXVJrBcFLUCB01wk0ZrHibRxOuaYkkZ+Y/lzSh
         o3QbOZADlb3vK4GE6OxQPQkSg8WsRE1t4Vh8sK3xV/dtXbfD0M6eU5xcEgoI/I/l/idc
         /caeVhkaHmLnSqtcLCPzR+Zuxav1bBm+vZKAqTE7KoNyiHJnARaCsH5uqhNcTWkju7wo
         otaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=m/oaydNeB7KKez2Jzp2jljrx95qkFNgazQFseegu3Nw=;
        fh=/SvzJGxJVq68NlDMZmOEhfggtxQkpLraiUIYNwL3bwQ=;
        b=C8sGH1hLHkqXxgMnQ4MeMWrpchpD0gAxLy8tYBpd29FlJIiBeORi2UtxTHD0sO8qoQ
         tngi0vM9lao/lgiJ+I2kdaRqYnyzbYsVGywxnvvOsphMAJSvclQVk7ikzeqrwxH7LkCg
         amIKKbte1LRLRghhlZxl+vzeVCdlEl5Qhs5mlQnB2FBM5ukpBl/bBWpxu7sx9w0YtgJ+
         G+ymzoAO9K1zdl42CkEqpe9oWQqp0aPUQyJXS0IKECkf4Gwu9d1SR7lyLcvPpolcfayc
         m/dI48qXS3pQCyZmXam6CPe0z/a4E78PCsjjE+9GL5rOqUkpihc/d8LcbHaInRvXuaDC
         Z1Dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790786971; x=1791391771; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m/oaydNeB7KKez2Jzp2jljrx95qkFNgazQFseegu3Nw=;
        b=tCcTd+DLGs9sBdlnQcXaucopfITBrPe8XKjYki/asPhXRYRLkfn235gBE0TPPTgYZd
         Kqh27H9NiszDnZVQFl3NvUeTlJfFSoaw7a1DA9Hmyrp5b/Qr0LTBYDNzOjMXjaRvIab3
         afU6ljijFKYgKAXyOyOvz9MNq08Aq9dxgFCbZVeM3yIw+ZALhtIavcPtMo4dFXI8MMaw
         zf4LkB3YbZ75tpeb1WpjFiqx8lvm9vTF3LdIM/o2FSQGa76srPKMG62qeBJR6dAohaUP
         XoA0tj3H4+lHp4+0FSjloYcCbdW4qr2Qaax6XEeHezQSFuXxoUHLY5/4udcVtKIZDUW2
         sEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790786971; x=1791391771;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m/oaydNeB7KKez2Jzp2jljrx95qkFNgazQFseegu3Nw=;
        b=p3yW7jWVC27PD3Pnu8mwGeRDdTINC7Jb2+L29psdenj6+zeSevBlVy1OAwx5ExW4oZ
         x/sJYvYftwsPDxIqoy4OPD+XuAYpQ9Xg37Z9pzHllovDmSpDsIQeOWriGgpzMFSZJS4x
         Gq5PUF2KtwWYw+DDpV5S0BzvOCGK/xFvuiAIwyoKPL4RxMFMvYgoXcK9qPSyz/QY3UcX
         dTTUC6GvPm0IAnC1qSyuhdYd36vkfszYBlTzkaamamgqVV37SNV02WLFP10dT8mDqA+g
         m3FiBwRfxYodtN1YU8jeHofOmJz+jpgBHfk9YUzoIrmB1sSGufCecIQyYj9iqRp4/EDV
         VvSQ==
X-Gm-Message-State: AFq9FYKjpkP6/3hsB9IJOxiQf8UI8YW3fehhzrZvDmjoqNnB7TYRX6wg
	SkAXB+UmvmoRJ5mr18Jhd3I0OJWs+smLtxoPkhC0oNx5syvDi02QKWNqE9AsHSnGhTC+SPn8/Du
	4G9p8LK4+Gb1wpsEatdHyMY1lMt4KFRzlM0cSJRBCiw==
X-Gm-Gg: AYBFou1pFCJwBxD0YBrgE+L4hzdSjTPc0uDIcgTV5HTjcEQ6mGedBARL3J/3JGGs57/
	Nm0RBWobyhD6qi/0Xl2rnLNPsGqCTKqQkHS8m0zpNCfzz3o+B6idrMh7sYEkZk7SgKwqMaTx/M7
	qWDl+8ECKNZwrs9iY9/50a78eMOVGPbC9GkvM36FHqv3Csh4keKBK08RK58MSzaKkaXh3ZisTkc
	p7TMuW59cEYanOd2ePJS3r9T+Mg+vtRT2v7onl6E1ai7a9HuR8ls+HUn4d739M2atQIsWyVEhf5
	x4SwAiEu2s0iNe1YLfXiwEsYPSZ6TlVSkQyG/plwrjNW7CBN4w+YtzLE/864t8NPMUvBwu9cYBx
	lGDfQLKz3/0cANXtJEE4k3zbSxHjQUScrEbmO6vLu7ed0
X-Received: by 2002:a05:6214:54c5:b0:90c:a989:a68a with SMTP id
 6a1803df08f44-917aa2f093bmr3499616d6.11.1790786971288; Wed, 30 Sep 2026
 09:49:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Claudio Gratton <cla20gra@gmail.com>
Date: Wed, 30 Sep 2026 18:49:19 +0200
X-Gm-Features: AclHuK8KG73Rdozl3C21tUCJ3Qj_vy52lU6tUV5dAYIHAggwiXb0lvze3F5m_BU
Message-ID: <CAGohoTay793z6HftCY-1m+DP0yCJ1eeB+q4p5-z7+bOnrOWOCQ@mail.gmail.com>
Subject: mt7925e: endpoint keeps a stale zero-latency LTR after s2idle resume,
 blocks package C6/C10 (Panther Lake laptop)
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com, 
	linux-mediatek@lists.infradead.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I may have found a resume issue with the MT7925 PCIe Wi-Fi card
(mt7925e) on a Panther Lake laptop. I am not sure whether the driver,
the firmware or the platform is at fault, so I'm asking here first.
Everything below is marked either "measured" or "guess".

Hardware / software
- HP OmniBook 7 14-hg0xxx, Core Ultra X7 358H (Panther Lake), Wi-Fi/BT
MT7925, mt7925e at 0000:2c:00.0, root port 0000:00:1c.0
- Reproduced on Arch linux 7.2.3.arch1-3 and on linux-omarchy 7.2.5-3
(Arch config plus patches). Not tested on a vanilla mainline kernel.

Symptom (measured)
- Fresh boot: the PMC LTR table (/sys/kernel/debug/pmc_core/ltr_show)
shows SOUTHPORT_B = 0x0 and the package reaches PC10 at idle.
- After the first s2idle resume in a boot, SOUTHPORT_B reads
0x80008000 (valid, zero latency) and stays there. The package then
stays in PC2 (PC6/PC10 residency 0%) although everything else is idle.
- Idle power on battery is roughly 0.5 W higher while it is stuck
(about 3.1-3.6 W vs 2.0-3.1 W, screen on). I also changed other things
in the same period (a Bluetooth autosuspend workaround), so treat the
0.5 W as approximate. With "echo 1 > ltr_ignore" the package reaches
PC10 again.

Why I think it is this Wi-Fi card (measured)
- Unloading mt7925e changes SOUTHPORT_B to a constant 0x88418841.
- Toggling the Wi-Fi radio (rfkill), NVMe I/O bursts and an empty USB4
port do not change it.

State across the resume (measured, one suspend cycle, "systemctl suspend")
- Before suspend: SOUTHPORT_B = 0x0.
- Immediately after resume, before any userspace hook: SOUTHPORT_B = 0x80008000.
- Endpoint 2c:00.0 stays in D0; DevCtl2 = 0x0409 (LTR Mechanism Enable
set) and the LTR capability max snoop/no-snoop latency 0x100f/0x100f
are identical before and after.
- Root port 00:1c.0: DevCtl2 = 0x0400 and LnkCtl = 0x0c43, unchanged.
- No kernel messages from mt7925e or PCI during the resume.

Workaround that fixes it (measured)
- About 6 s after resume, clear and re-set DevCtl2 bit 10 (LTR
Mechanism Enable) on the endpoint, 0.3 s apart:
setpci -s 2c:00.0 CAP_EXP+0x28.w=<old & ~0x0400>; sleep 0.3; setpci -s
2c:00.0 CAP_EXP+0x28.w=<old>
The endpoint then sends a fresh LTR message, SOUTHPORT_B returns to
0x0 and PC10 residency comes back (about 28% of samples in my run,
idle 1.99 W with the screen on).
- I run it from a systemd-sleep hook as a stop-gap. It has fixed the
state after every resume I have tried, including a repeat this
afternoon.

What I do not know (guess)
- My guess is that the chip or its firmware re-sends a "0 latency" LTR
message at resume and never sends the update. I cannot rule out that
the driver or the platform leaves something unprogrammed; the
unchanged config space only shows that it is not a PCI-level
difference I can see.
- I have not checked whether other MT7925/MT7922 platforms, or
Intel/AMD systems, show the same.

Questions
1. Has anyone seen the same behaviour, and is it known on the firmware side?
2. If it is a driver issue, would re-triggering the LTR message at
resume (as above) be acceptable in mt7925e, or is there a cleaner way?

I can provide full logs, run patches or test firmware versions.

Thanks,
Claudio Gratton
