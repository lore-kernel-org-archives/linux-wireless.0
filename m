Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47797 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab1CRVxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 17:53:00 -0400
Received: by qwk3 with SMTP id 3so3122827qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 14:52:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300478510.15393.45.camel@dev.znau.edu.ua>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
	<AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	<AANLkTi=EeMKNsi9bxNg4RJre-pP=jqcGpbLPNtggSK0N@mail.gmail.com>
	<1300463392.13499.110.camel@dev.znau.edu.ua>
	<AANLkTi=GggwyGkDB+cBG-G3O2c5WdfjCpb5pk8=3yDKz@mail.gmail.com>
	<1300471917.14872.28.camel@dev.znau.edu.ua>
	<AANLkTikQ7W4GdY=USphz3FphyS-yEwN+X+jUPwq9x_6z@mail.gmail.com>
	<1300478510.15393.45.camel@dev.znau.edu.ua>
Date: Fri, 18 Mar 2011 22:52:59 +0100
Message-ID: <AANLkTi=1XOxwS4tMc6eMcNGeHf_ZGaAH5MC97JsP7oWP@mail.gmail.com>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/18 George Kashperko <george@znau.edu.ua>:
>  - read pci revision id/vendor id (pci_read_config_word), if required
> to decide if second window is sliding or sprom (actually rev_id should
> be sufficient for that) read offset 0x0000 from bar0 offset to get
> chipid register value

Could you say something about WIN1 and WIN2? What are they for, can we
use them somehow separately? What do you mean by second window being
SPROM? We read sprom without any special window magic:
sprom[i] = ioread16(bus->mmio + bus->sprom_offset + (i * 2));

My understanding is limited to that:
If we want to use device with CORE_ADDR and WRAP_ADDR we have to write
CORE_ADDR to BAR0_WIN and WRAP_ADDR to BAR0_WIN2. Then we can use
readl/writel.

-- 
Rafał
