Received: from mail-wm2-f7.google.com (mail-wm2-f7.google.com [74.125.225.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C994499AC
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 10:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785838786; cv=none; b=kNWgsm3rYu72LQvYf/4uGaPzrI/F0YwbPOWTWj7z1NnXq0vgdDQmt1dOhdd/oAHtmfjNWHqX7w5oZDIHEzIeiyPGgBEQIXGpcCUeU/julFGKn5I4ZYFn3rCuijwddAjOjyMiymtdYTWdFPdyb761wx4rKtwg1G4oXnCwEk9Pres=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785838786; c=relaxed/simple;
	bh=APWdkGJ3pm2yvPGvqtsV9fGSgWJ7tQktskv703x9Hmg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JUij9LG8ebzjCOIwBfdP4rbmFXo+BcwfSTB+R9z4qpP+NOFHb77eE8yrInX0nLa8GfZB0OBdN0ntpWk2bSDq9QtmJ9J8CwY70/Yr1NUAoWs8CvVVJYhyvw9Rw/QDfu/b0t2EwuPqYv3v6/1vSBUPZGrbGhwp6iezDADCOyxdHpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QnGqeOEF; arc=none smtp.client-ip=74.125.225.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QnGqeOEF"
Received: by mail-wm2-f7.google.com with SMTP id 5b1f17b1804b1-49557073245so11348755e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 03:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785838783; x=1786443583; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=13TTvH1EeGqMs0mz6hnT5sV4Dz8BUjbRnK70xfNiQaM=;
        b=QnGqeOEFcTjbktREdkDyF8VEep3lQAw5kZy4YHrsdeb8Y/j92RhLhWD+hoeJiL334i
         56hpXu4/RBpNL6pReLu6wff6oUocq2BUNH5/kIAqMTI9oiQjbaU+jcTmcpP7yIN/soGo
         7/Mc2STX2Pm65HCQqQd9TbBUizN+0m/KH0AI7IXMt76rESOmEaqewS9WyxCMB+xYvceK
         HSIplZCqHLdLm7vh8/faQV5YjDHTYTEuxeEyDn/GfJ7weqaiyMyjxD60KuSLK99eczIY
         Fu8iDDXvLWoIHOwykeWv6/pnS+uzGHVQkSlzXNXcNaaKC5+679eOwCcHnu+bqa9OX119
         2hYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785838783; x=1786443583;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=13TTvH1EeGqMs0mz6hnT5sV4Dz8BUjbRnK70xfNiQaM=;
        b=mW8uw+K/0XHsaXz1NaIfugyTCfIN1BUFAbJYUn5Vc9LNa3K1LmYBxHwohBm/58Ikk9
         uYvJzIjst3XouS/67LxtssDAGyDjqwIr4WX+cY2HwPqQiIyfliRgtePxxzFTRNWDzSCF
         RHCToE6ndRy8hRqL28hWMFVB5t6vFPxiT3jKwOSGj84x6HppdckQAZlEEYruZWVKiD8Y
         ZEso5jhqwVvSmdFHpgLp5uEfLfuA6BC1CsQVu77pBDRnkFdoO9hkwUMIjrAyAZntKHTF
         AdgrzwuPoRqm/dXcdml8soJg6n5AXLmAU9X2KNyJyyKmLg3Q4SL1SqVL/qYc+sLOXsJw
         lqmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp4kzTsSuYrNR29PiZzj+pLorfvqVxIUd999iZLuRzHtqN4OFfV2VLHymKl1CLtSG3zqXoMF7qfOT40rLDXrw==@vger.kernel.org
X-Gm-Message-State: AOJu0YySvinZFqLj+zc1Fg61RKtJPvGhE5fm8Zp2+Gkshu7h79EYepua
	1vNnpM70clN2KP3qQUKvdJIXRY5Gf+ZKXbil7bs66zxp8hMNmS5efskH
X-Gm-Gg: AR+sD11VUQtsnZ06IJKIWMHcqdWZ0VZOQUxhkyEPdwP6s32vNtCLfKpwqb3msgmojKb
	ujVWS5wgAFjof6jM2XtsXbH2nljYA2yONGmXfmhmi5qxQZMaoXZDsJkgAJPHpuI72QVlLqnVA63
	mneuMnyAJrQTY3+GlYvQVRP70zw6nSkTqjwIqLyK5DY0jeSvWSslxGrAxj9p1U7T/kvcTILhai+
	Phpz5U65d/69B8Cc8qokldXNmFS9epc0WOq+0vJdiq189ZtRuV704AYAjybxbuZfxh9iB72HCZK
	jvL+ju0iiBpJ13r6EWRpwdVPSqRVPeV3aCMB3SHVLJSXLqZz5ZLLP7rduj+efJcQ1X7OZmPrpMy
	0jAaWvOwWSLLzin4CJF9zZnYNcP/wDFBC5SM3jm80CibLNLVFbVMQocfXqAYZwq4FOQYeQDr9MY
	nfbb1D9xvrqsvwEjlZ35DEJ2MXfP7ykb//HmVH2CbJNrk4ThkuctYaUqvwDkBQN6B7LMrOY51Et
	a9hOs7BlMsdpjX1Kx0xLZxmPEGuc2wlJfoYl9zNI7taDcE=
X-Received: by 2002:a05:600c:840f:b0:496:c379:b2a1 with SMTP id 5b1f17b1804b1-4980c66d7bbmr269011845e9.2.1785838783093;
        Tue, 04 Aug 2026 03:19:43 -0700 (PDT)
Received: from fedora.fritz.box (dynamic-adsl-84-220-246-20.clienti.tiscali.it. [84.220.246.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b5b4a2sm381950585e9.1.2026.08.04.03.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 03:19:42 -0700 (PDT)
Date: Tue, 4 Aug 2026 12:19:31 +0200
From: moosager <moosager90@gmail.com>
To: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com, matthias.bgg@gmail.com, 
	angelogioacchino.delregno@collabora.com
Cc: linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: mt7921e: failure to reset causes network drop
Message-ID: <anG46qbvCqCHGF-f@fedora.fritz.box>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,
there is an issue with the mt7291e that causes the network to drop at random, 
with dmesg outputting repeatedly:
kernel: mt7921e 0000:62:00.0: Timeout for driver own
kernel: mt7921e 0000:62:00.0: driver own failed

Other effects are the system becoming generally unresponsive, kernel panics 
(reporting "Fatal exception in interrupt"), and the system instantly rebooting. 
It also has a tendency to happen again on every subsequent reboot.
More reports of users' experiences are available at [1].

This script lets you reproduce the issue:
#!/bin/sh
echo 0x7c060010 > /sys/kernel/debug/ieee80211/phy0/mt76/regidx
while true; do echo 0xffffffff > /sys/kernel/debug/ieee80211/phy0/mt76/regval ; done

I had previously investigated the code and have some potential insight: during 
normal usage, the function __mt792xe_mcu_drv_pmctrl writes to a register 
like this:
mt76_wr(dev, MT_CONN_ON_LPCTL, PCIE_LPCR_HOST_CLR_OWN);

and it expects to find 0x00000004 (which is PCIE_LPCR_HOST_OWN_SYNC). Instead, 
when the issue happens, it finds 0xffffffff, which does not change even after 
the driver attempts to write to it.

In addition, the failure of __mt792xe_mcu_drv_pmctrl returns -5 as an error 
code; this is not checked by the caller, mt7921e_mac_reset, which calls 
mt792xe_mcu_drv_pmctrl without checking its return value.
 
I have also found some potentially helpful patches at [2]; however, applying 
them did not fix it, and my best attempts at adapting the proposed code paths to 
be triggered in mt7921e_mac_reset have not fixed it either.

Here is my firmware version reported in dmesg:

[   15.848101] mt7921e 0000:62:00.0: enabling device (0000 -> 0002)
[   15.849369] mt7921e 0000:62:00.0: disabling ASPM  L1
[   15.865381] mt7921e 0000:62:00.0: ASIC revision: 79220010
[   15.958433] mt7921e 0000:62:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260605203307a
[   16.352504] mt7921e 0000:62:00.0: WM Firmware Version: ____000000, Build Time: 20260605203411

It has also been happening at least since the firmware with HW/SW build time 
20251118163143a and WM firmware build time 20251118163234, which is when I got 
my laptop with this Wi-Fi chip.

Note: the issue happens whether ASPM is on or off.
The issue happens on my build of the vanilla 7.2.0-rc4 kernel, as it has 
been happening on every past kernel version.

I would like some guidance as to how I could debug the issue further, though 
ultimately the problem is likely in the firmware. It would be very helpful to 
have this fixed, as it currently makes my laptop almost unusable, and I know I'm 
not the only user having this issue.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=220353
[2] https://lore.kernel.org/linux-mediatek/20260506070458.3096180-1-jb.tsai@mediatek.com/
