Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbcF2PRC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:17:02 -0400
Subject: Re: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
To: Jonas Gorski <jonas.gorski@gmail.com>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <CAOiHx=n6itfmvwYQh+jUSDNguQFkos=MzjkDWP=GsupdgvF6KQ@mail.gmail.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <b49a9e4b-d591-d978-8005-413f39ebf2bd@redhat.com> (sfid-20160629_171707_083952_A5D0BB8A)
Date: Wed, 29 Jun 2016 17:16:32 +0200
MIME-Version: 1.0
In-Reply-To: <CAOiHx=n6itfmvwYQh+jUSDNguQFkos=MzjkDWP=GsupdgvF6KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 29-06-16 16:42, Jonas Gorski wrote:
> Hi,
>
> On 29 June 2016 at 16:04, Hans de Goede <hdegoede@redhat.com> wrote:
>> Add a brcm,nvram_file_name dt property to allow overruling the default
>> nvram filename for sdio devices. The idea is that we can specify a
>> board specific nvram file, e.g. brcmfmac43362-ap6210.txt for boards
>> with an ap6210 wifi sdio module and ship this in linux-firmware, so
>> that wifi will work out of the box, without requiring users to find
>> and then manually install the right nvram file for their board.
>
> Directly defining a filename doesn't seem like a good OS-agnostic
> approach. Maybe an alternative would be to add a model-property to the
> nodes (this is allowed) and make brcmfmac to request
> "FWFILENAME-<model>" as firmware if set? That would leave it to the OS
> on how the filename is set.

It only defines the base-filename, not the entire path, how / where
this file is searched for / loaded-from is then left up to the os

Regards,

Hans
