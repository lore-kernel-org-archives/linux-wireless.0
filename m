Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:65089 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KHMne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 07:43:34 -0500
Received: by mail-wg0-f42.google.com with SMTP id fm10so3631718wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 04:43:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352378602.11421.4.camel@jlt4.sipsolutions.net>
References: <1352378241-31906-1-git-send-email-arik@wizery.com> <1352378602.11421.4.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 8 Nov 2012 14:43:17 +0200
Message-ID: <CA+XVXfcrnt18pxVq+uvgV2B6HKiNsq0f-SWkV=OtphJJp7UEhw@mail.gmail.com> (sfid-20121108_134347_073641_4CAB111B)
Subject: Re: [PATCH] mac80211: clear lower drv private data on iface removal
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 8, 2012 at 2:43 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2012-11-08 at 14:37 +0200, Arik Nemtsov wrote:
>> The lower driver might rely on getting zeroed per-vif private memory
>> when an interface is added. Resetting the memory on removal avoids
>> adverse affects during recovery, where the interface is added without
>> being removed.
>
> However, it means that data isn't stable across suspend/resume, which
> could be desirable to the driver as it may want to have the same
> configuration after resuming.
>
> I think we should therefore leave this to the driver, it's obviously
> easily implemented as the last step of the driver's ->remove_interface()
>

Agreed.
