Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E0F40BCB2
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318193; cv=none; b=gIQuob83rf3EYNZVP1aqNcAa/j6YfZdFWqczxzUYqMJFQoxsHdwenR75Jnm6TEKZHpjeSXOF299CE8T3DSIh8Tg+KWEN2eMSuiY2knrSXfR68E9MEIP65A77XPuOGGJCgx7WjAjEkvPkVFqwU76XvU+FBZNXh+b8VQbRJ9Ci24U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318193; c=relaxed/simple;
	bh=hkcrbB9ShktWX1H9AZ/hhXP4eZ26Ve/kCzpgfCdUT2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oum4GlI2UDG3DvbGqsgRUlUR3Nel+Oz9QTzylj0i8URxMYJGsDtTZ5gb7DDp7CkwQ+vau/k1xn7X1Ydv9eChTef4tdY8GJwRCYfUxCxBRg6RSYmVy78zhJgDp9LFk/iZt8Qe4LPI6bMTJ3eNRVw4VygkdjlS4ukzK9iRQM6HTtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtUO37h4; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtUO37h4"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca12086c06eso553331a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785318192; x=1785922992; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t83ZAl+HTEOhK7yZi3aE9T2wGWPdb8+DClmlDdgQvpA=;
        b=JtUO37h4LqYcWNJl8gtSWbDpQOCbH27M9saeYKYhx2HxuUhIGjMTDgjIfQxIkJtpiT
         TQor7HFnFcBbXCgiiHx0M1sy4ilrfHkRzNtZf6EG73NE4/JBr1dh5iM5UpUK5ZX2hpsQ
         YS79mcBmlpwJg1aqS34RLdrlzo9QfA2NJdgpjonhFKESChtdRib2gAtQQOund8w683qn
         xgXbPcz4ot4pz3Ksy/YO4UOTuOK44e7YoTFoeIxzzascRl4avZJkx1hOVK/ZoDc4F8kt
         RyC6z/Bcoh/RPFo3A1UlfPmwsmmOXSuSV9XF8YlAKIusNvnJ/j3pBs9ufQaCn+SWAvkH
         pXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785318192; x=1785922992;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t83ZAl+HTEOhK7yZi3aE9T2wGWPdb8+DClmlDdgQvpA=;
        b=mbU5kk0J2TviZqlQ+b6Ypz5eRtnhNyOgRwp2sZ1uRynAdYivUkrC5nCPLSm7gn7ICr
         4ezDYcOlMgQ0ik+NOiMQfzjoPKfrCDGIJy3YKTXmzFhTuMMkljp1QjBCNeWIhdg87LHg
         MAx9/wRbo4YvdSs7XMZMJhwAl8OUv1KezpVa2VzTgFqZga7ri7jCSs5OxS6dHYY5mHGd
         CLEGfz02DPmkJYZO4Utlzu7srcfNvalwDN9pDa5ch4f1oNMYLFKnHAXwGD0iO5Z+jsWU
         NwuTVKSVisL3ShuuSSJk9gMPlcbjSzBuAD9JKPbRC2sJxfRxCA4obY9FQ2rQfV/Mffvq
         KARw==
X-Gm-Message-State: AOJu0YxTITQ6Xjr0Y7k517bKUqpLTjXRIkVne3X88olo1TinqxFqUPuQ
	RCY3rkkV0Cis/AsMum/GTz3KXAGB6wcaHZy666Lp2K2hO9dL3Q+ujSE0
X-Gm-Gg: AR+sD10XjiVFUI4XqL3FfW9no0iMtf6AQR9vHXKi11aQuLeMH1lOFNkvYM9kts0eM1r
	I/6WOtiKCPaYqNsQl4QesJuyR3NRRm7p+2H8Ju7nh/Iq+cQlYu18bio9O8RZ8G6gDShEzsDK3u1
	GFWGVOp9ChW2sJgHzrhkHr+bNfL3bw3eqj+mImj/GzBSfClIrm2ai2jjRv8X030AWGyrRnMazmE
	LO+ZIhMbtdN2zcn6vSV7N8E4qtNs60AzqrpnjxDjpUAHEU8WV8BRBoLWHIDyPkgCODAeh01m0QT
	pr5mSJ3swKa81BbgGTAjWVZ3iobiB9IdD6iGZl3OStfQfhupqSP3FkMhuFoYQEUvGKuttcFK8bt
	O1dlyrDpDPOdBrH+2pIpYZx8EYJxfSa9uRR7sjGcXi1pv8XWxvKAEC0TYPn9JHRNAobcWU3dhGc
	qL2KEZaSLa4JRDnB8kLDFBWfjpYxEu+rA2yHJ8wkX8//HKkJc4CKsX1FBwIZvOtCb3SfKk6bBcp
	Yz0+9eRtl6sVorqmXaCuLy1oIuiOr2qoHWm+/g=
X-Received: by 2002:a05:6a21:2291:b0:3c3:83e6:c705 with SMTP id adf61e73a8af0-3c8ba5beec0mr7303606637.35.1785318191749;
        Wed, 29 Jul 2026 02:43:11 -0700 (PDT)
Received: from localhost ([2409:40c4:138:9281:7d6f:2f3:b5b5:ed1c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504d37368sm14174469eec.22.2026.07.29.02.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 02:43:11 -0700 (PDT)
Date: Wed, 29 Jul 2026 15:13:07 +0530
From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
To: Snake Pilot <snakepilot10@gmail.com>
Cc: linux-wireless@vger.kernel.org, pkshih@realtek.com, 
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] rtw88_8723de: Wi-Fi and Bluetooth fail after warm reboot
Message-ID: <amnGXPlG6nKUdEl7@eggarch>
References: <CA+fxq6gPCQOYr6mh+_1ReOGzaiTULzMazXhs5q0PXc8PsjRJEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fxq6gPCQOYr6mh+_1ReOGzaiTULzMazXhs5q0PXc8PsjRJEQ@mail.gmail.com>

Hi,

Could you provide the following:
1) Full dmesg after warm and cold boot
2) 'journalctl -k -b -1' after warm boot

Also please run a few tests,
1) Unload rtw88_8723de only or btusb only and perform warm reboot
and see if both of them are broken while unloading only one driver
2) Repeat the above with a delay like sleep 0, 1, 3, 5
3) Try 'echo 1 | sudo tee /sys/bus/pci/devices/0000:02:00.0/reset' 
after warm reboot see if it pci function reset recovers wifi

Also provide output of 'lspci -vv -s 02:00.0' and 'lsusb -t'
after warm reboot.

That would be helpful.

Thanks, 
Lovekesh
