Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43116 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbcF3IqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 04:46:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel\@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
	<CAOiHx=n6itfmvwYQh+jUSDNguQFkos=MzjkDWP=GsupdgvF6KQ@mail.gmail.com>
	<b49a9e4b-d591-d978-8005-413f39ebf2bd@redhat.com>
	<871t3gdj6p.fsf@purkki.adurom.net>
	<ea10ff70-26e6-e151-5cea-c54bd12a054c@redhat.com>
	<f8995599-115d-87e5-7928-c029b48584f1@broadcom.com>
Date: Thu, 30 Jun 2016 11:46:10 +0300
In-Reply-To: <f8995599-115d-87e5-7928-c029b48584f1@broadcom.com> (Arend Van
	Spriel's message of "Wed, 29 Jun 2016 20:51:44 +0200")
Message-ID: <87mvm36p4d.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_104629_770263_4A0CB6C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

>> Since we are dealing with a per-board config-file here, which is
>> loaded from the os filesystem we really need to specify a basename
>> here as the list of possible boards is endless, so we cannot
>> have a lookup table in the driver.
>
> As Jonas mentioned the general principle of device tree is to be
> agnostic with regards to OS and/or driver as you undoubtedly know. His
> proposal seems like a usable solution for your problem while complying
> to the device tree principle. So instead of overriding the default
> brcmfmac should modify it when dt specifies the "module" property, ie:
>
> no "module" in DT:	nvram filename = brcm/brcmfmac43362-sdio.txt
> "module=ap6210" in DT:	nvram filename = brcm/brcmfmac43362-ap6210.txt

Just out of curiosity, what does "ap6210" exactly mean? I get that 43362
is the chip id, but not ap6210. Is it just an arbitrary name?

-- 
Kalle Valo
