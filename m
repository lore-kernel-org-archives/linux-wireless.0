Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40664 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab2FTNWh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 09:22:37 -0400
Received: by eekd17 with SMTP id d17so2967370eek.22
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 06:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340180149.4655.23.camel@jlt3.sipsolutions.net>
References: <1340173975-13609-1-git-send-email-victorg@ti.com>
	<1340180149.4655.23.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 16:22:35 +0300
Message-ID: <CAK80WHYa566m+K8TtRo6nvDQHd4J-1A5MD5y_N6_OJMVVnVMgA@mail.gmail.com> (sfid-20120620_152241_034353_F19066CF)
Subject: Re: [PATCH v4] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 11:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-20 at 09:32 +0300, Victor Goldenshtein wrote:
>
>> +     trace_drv_get_rssi(local, sdata);
>> +     ret = local->ops->get_rssi(&local->hw, &sdata->vif, sta, rssi_dbm);
>> +     trace_drv_return_int(local, ret);
>
> Where are you tracing the sta?
>

We talked about print sta address with "local_sdata_addr_evt" event
macro, the output looks like this:

#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |                     ||||       |         |
              iw-1394  [000]        ...1  1083.713867: drv_get_rssi:
phy0 vif:wlan0(2) addr:08:00:28:cc:65:43
              iw-1394  [000]        ...1  1083.729736: drv_return_int: phy0 - 0

> And why not trace the value returned in *rssi_dbm?
>

Is it really required ? there are various driver-ops which are "get
stuff" without printing them in the tracer.

-- 
Thanks,
Victor.
