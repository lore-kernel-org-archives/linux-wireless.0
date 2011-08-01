Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36636 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab1HARuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 13:50:04 -0400
Received: by fxh19 with SMTP id 19so4773528fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 10:50:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108012038.40155.anarsoul@gmail.com>
References: <20110801154313.8C9389D401F@zog.reactivated.net>
	<201108012038.40155.anarsoul@gmail.com>
Date: Mon, 1 Aug 2011 18:50:03 +0100
Message-ID: <CAGq3pz50EamvOmsshmZaPp5-ToW8eVi78r-BdDG-rX2154sH2A@mail.gmail.com> (sfid-20110801_195008_452233_794545CC)
Subject: Re: [PATCH 1/2] libertas: disable functionality when interface is down
From: Daniel Drake <dsd@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 August 2011 18:38, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>> power_save and power_restore hooks are added meaning that card drivers
>> can take steps to turn the device off when the interface is down.
>
> You mean completely off? And firmware needs to be reloaded after power up?

Yep, exactly like that. Same as various mac80211-based drivers.

The 2nd patch in this series implements it for libertas_sdio, the
other libertas interfaces have their behaviour as before.

Daniel
