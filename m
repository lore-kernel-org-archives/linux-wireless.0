Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44093 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcF3JAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 05:00:42 -0400
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
	<fa0bf74d-cba3-0853-753c-64fe049105aa@broadcom.com>
Date: Thu, 30 Jun 2016 11:50:41 +0300
In-Reply-To: <fa0bf74d-cba3-0853-753c-64fe049105aa@broadcom.com> (Arend Van
	Spriel's message of "Wed, 29 Jun 2016 20:57:35 +0200")
Message-ID: <87inwr6owu.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_110103_551721_DF4D9FC2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

>>> Typical wifi devices will have some sort of non volatile storage
>>> on board to not only store the ethernet(mac) address, but also
>>> to contain e.g. info about the antenna gain so that the firmware
>>> and/or the driver can take the antenna gain into account and ensure
>>> that they never exceed the maximum allowed broadcast strength.
>>>
>>> However on some embedded devices there is no non-volatile storage
>>> for the wifi (for cost reasons) and instead this configuration info
>>> (which is board / pcb specific) is loaded in the form of a
>>> file which contains the contents which would normally be in the
>>> non-volatile storage.
>>>
>>> Since we are dealing with a per-board config-file here, which is
>>> loaded from the os filesystem we really need to specify a basename
>>> here as the list of possible boards is endless, so we cannot
>>> have a lookup table in the driver.
>
> As a note: For BT Marcel was playing with the idea of having a lookup
> table on the file system which would be loaded by the driver.

In ath10k we have a similar problem but in our case we can use the
subsystem id to detect what board file to use, so it's not exactly same
as yours. In our board-2.bin we have identifiers like this from which
ath10k selects the correct board file:

bus=pci,vendor=168c,device=003e,subsystem-vendor=168c,subsystem-device=334e
bus=pci,vendor=168c,device=003e,subsystem-vendor=168c,subsystem-device=3360
bus=pci,vendor=168c,device=003e,subsystem-vendor=168c,subsystem-device=3361

-- 
Kalle Valo
