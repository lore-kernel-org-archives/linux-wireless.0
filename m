Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f52.google.com ([209.85.215.52]:44771 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1INJoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:44:24 -0400
Received: by ewy28 with SMTP id 28so880765ewy.11
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:44:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871uw9olg7.fsf@purkki.adurom.net>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
 <1314265397-19873-2-git-send-email-arik@wizery.com> <871uw9olg7.fsf@purkki.adurom.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 14 Sep 2011 12:44:08 +0300
Message-ID: <CA+XVXff93Qhj6URUMzE99j30NVB+4_M_NwsxHKYOxbHwpwE1yg@mail.gmail.com> (sfid-20110914_114427_434799_EDDAA140)
Subject: Re: [PATCH 2/6] wl12xx: AP mode - don't regulate FW blocks for
 non-active STAs
To: Kalle Valo <kvalo@adurom.com>, Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 13:05, Kalle Valo <kvalo@adurom.com> wrote:
> Arik Nemtsov <arik@wizery.com> writes:
>
>> +     if (!wl1271_is_active_sta(wl, hlid)) {
>> +             WARN_ON(1);
>> +             return;
>> +     }
>
> I think this is neater:
>
> if (WARN_ON(!wl1271_is_active_sta(wl, hlid))
>        return;

(Sorry for the late response)

It does look nicer. Luca - do you mind changing it before merging?

Arik
