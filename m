Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48617 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1HATTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 15:19:14 -0400
Received: by fxh19 with SMTP id 19so4844450fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 12:19:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108012213.13032.anarsoul@gmail.com>
References: <20110801154313.8C9389D401F@zog.reactivated.net>
	<201108012038.40155.anarsoul@gmail.com>
	<CAGq3pz50EamvOmsshmZaPp5-ToW8eVi78r-BdDG-rX2154sH2A@mail.gmail.com>
	<201108012213.13032.anarsoul@gmail.com>
Date: Mon, 1 Aug 2011 20:19:12 +0100
Message-ID: <CAGq3pz5xAZqofOJSanDfayabNd-i434QpAZFrKatui8WxMtBvQ@mail.gmail.com> (sfid-20110801_211918_521394_41056C6A)
Subject: Re: [PATCH 1/2] libertas: disable functionality when interface is down
From: Daniel Drake <dsd@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 August 2011 20:13, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> Cool, I hope I'll get some time tomorrow to test your changes with
> libertas_spi.

Just to clarify, you won't see any power saving effects until you
implement power_save and power_restore on the SPI level. See patch 2/2
for how I did it for SDIO (it builds upon quite a bit of hard work
implementing runtime power management in the MMC layer).

Testing is appreciated anyway, because the driver shape changed in
general with this patch: e.g. it used to let you scan while the
interface is down, and now it doesn't. Would be good to have
additional confirmation that nothing has broken :)

Thanks,
Daniel
