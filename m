Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:36892 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab2AZNga convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 08:36:30 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi8so423873wib.40
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 05:36:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2150B2.3030004@openwrt.org>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
	<1327581689-22090-5-git-send-email-victorg@ti.com>
	<4F2150B2.3030004@openwrt.org>
Date: Thu, 26 Jan 2012 15:36:28 +0200
Message-ID: <CAK80WHaE5u22nA3acCKXAdd_WZkwS+iLjJ5PcDqCwyb6UWUQzg@mail.gmail.com> (sfid-20120126_143634_099286_B257E827)
Subject: Re: [RFC 4/7] hostapd: add dfs support into interface init flow
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	kgiori@qca.qualcomm.com, mcgrof@frijolero.org,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	johannes@sipsolutions.net, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 3:10 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> +
>> +             eloop_enable();
>> +             wpa_printf(MSG_DEBUG, "Continuing with init flow");
>>       }
>>
>>       if (iface->current_mode) {
> This seems like a bit of a hack to me. Wouldn't it be better to prevent
> eloop_terminate() from being called instead of adding another function
> to override the eloop termination?

Couldn't find a cleaner way to do it, I mean without the usage of the
eloop_run() + eloop_terminate().
We need to check a DFS channel prior starting the tx, i.e. - listen
for radar event during the initialization flow, prior the
hostapd_global_run(), I would gladly hear other ideas for this
implementation.


-- 
Thanks,
Victor.
