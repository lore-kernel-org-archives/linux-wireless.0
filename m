Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47459 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcF2RKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 13:10:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jonas Gorski <jonas.gorski@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel\@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
	<CAOiHx=n6itfmvwYQh+jUSDNguQFkos=MzjkDWP=GsupdgvF6KQ@mail.gmail.com>
	<b49a9e4b-d591-d978-8005-413f39ebf2bd@redhat.com>
Date: Wed, 29 Jun 2016 20:00:14 +0300
In-Reply-To: <b49a9e4b-d591-d978-8005-413f39ebf2bd@redhat.com> (Hans de
	Goede's message of "Wed, 29 Jun 2016 17:16:32 +0200")
Message-ID: <871t3gdj6p.fsf@purkki.adurom.net> (sfid-20160629_191044_016623_B66E90B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> writes:

> Hi,
>
> On 29-06-16 16:42, Jonas Gorski wrote:
>> Hi,
>>
>> On 29 June 2016 at 16:04, Hans de Goede <hdegoede@redhat.com> wrote:
>>> Add a brcm,nvram_file_name dt property to allow overruling the default
>>> nvram filename for sdio devices. The idea is that we can specify a
>>> board specific nvram file, e.g. brcmfmac43362-ap6210.txt for boards
>>> with an ap6210 wifi sdio module and ship this in linux-firmware, so
>>> that wifi will work out of the box, without requiring users to find
>>> and then manually install the right nvram file for their board.
>>
>> Directly defining a filename doesn't seem like a good OS-agnostic
>> approach. Maybe an alternative would be to add a model-property to the
>> nodes (this is allowed) and make brcmfmac to request
>> "FWFILENAME-<model>" as firmware if set? That would leave it to the OS
>> on how the filename is set.
>
> It only defines the base-filename, not the entire path, how / where
> this file is searched for / loaded-from is then left up to the os

It's still a bad idea. The filename, including the path, should be
created in the driver. Can't you provide chipname (or similar) via
device tree and then the driver can choose what image to use?

Can you tell more about the naming the firmware image, how does it work
exactly?

-- 
Kalle Valo
