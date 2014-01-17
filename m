Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23112 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaAQJX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 04:23:27 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jonas Gorski <jogo@openwrt.org>
CC: <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: enable firmware STA quick kickout
References: <20140116123336.24551.2629.stgit@potku.adurom.net>
	<CAOiHx=n77=CiFYfB3Y=jxOjVtmr06zvFhUe5R96Kq0HUgSLv5Q@mail.gmail.com>
Date: Fri, 17 Jan 2014 11:23:22 +0200
In-Reply-To: <CAOiHx=n77=CiFYfB3Y=jxOjVtmr06zvFhUe5R96Kq0HUgSLv5Q@mail.gmail.com>
	(Jonas Gorski's message of "Fri, 17 Jan 2014 10:01:06 +0100")
Message-ID: <871u07rmgl.fsf@kamboji.qca.qualcomm.com> (sfid-20140117_102519_647308_0A156AD9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonas Gorski <jogo@openwrt.org> writes:

> On Thu, Jan 16, 2014 at 1:33 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Firmware has a feature to track if the associated STA is not acking the frames.
>> When that happens, the firmware sends WMI_PEER_STA_KICKOUT_EVENTID event to the
>> host. Enable that to faster detect when a STA has left BSS without sending a
>> deauth frame.
>>
>> Also set huge keepalive timeouts to avoid using the keepalive functionality in
>> the firmware.
>>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

>> +       param = ar->wmi.pdev_param->sta_kickout_th;
>> +       ret = ath10k_wmi_pdev_set_param(ar, param,
>> +                                       ATH10K_KICKOUT_THRESHOLD);
>> +       if (ret) {
>> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       param = ar->wmi.vdev_param->ap_keepalive_min_idle_inactive_time_secs;
>> +       ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
>> +                                       ATH10K_KEEPALIVE_MIN_IDLE);
>> +       if (ret) {
>> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       param = ar->wmi.vdev_param->ap_keepalive_max_idle_inactive_time_secs;
>> +       ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
>> +                                       ATH10K_KEEPALIVE_MAX_IDLE);
>> +       if (ret) {
>> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       param = ar->wmi.vdev_param->ap_keepalive_max_unresponsive_time_secs;
>> +       ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param,
>> +                                       ATH10K_KEEPALIVE_MAX_UNRESPONSIVE);
>> +       if (ret) {
>> +               ath10k_warn("Failed to enable sta kickout: %d\n", ret);
>> +               return ret;
>> +       }
>
> Did you intend to have differing warnings here? Currently it will be
> hard to tell which of these calls have failed based on the warning
> (assuming ath10k_warn does not print the source code line it was
> invoked from).

You are right, all warning/error messages in ath10k should be unique so
that the location can be easily found. I was actually supposed to fix
this before I send it for review, but apparently I forgot. I'll send v2.

Thanks!

-- 
Kalle Valo
