Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:11781 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbXKQSEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2007 13:04:12 -0500
Received: by an-out-0708.google.com with SMTP id d31so312520and
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2007 10:04:12 -0800 (PST)
Message-ID: <40f31dec0711171004g328f1e6ai47d6a02aeb1d6c5c@mail.gmail.com> (sfid-20071117_180418_908422_52F55A29)
Date: Sat, 17 Nov 2007 20:04:11 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org,
	madwifi-devel <madwifi-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath5k: Per queue interrupt handling
In-Reply-To: <40f31dec0711170906u53a4dd09p251a54a1ed53c16e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <40f31dec0711170906u53a4dd09p251a54a1ed53c16e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> c) Enabling tx interrupts on primary interrupt mask register overrides
> secondary mask registers. I set 0 on secondary mask register for all
> queues (flags = 0) and i got tx interrupts if i set INT_TX on primary
> imr.
>

Wrong, i did the test again, setting all simrs to 0, pimr does not
override simrs (i don't get any tx interrupts on pisr if i set simrs
to 0).

Also i noticed that we handle TXURN interupt but we don't enable it...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
