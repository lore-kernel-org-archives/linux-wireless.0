Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:43535 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbdLNTvU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 14:51:20 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] nl80211: Introduce scan flags to emphasize requested scan
 behavior
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1513187523-24054-1-git-send-email-jouni@qca.qualcomm.com>
Date: Thu, 14 Dec 2017 20:51:18 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Sunil Dutt <usdutt@qti.qualcomm.com>
Message-Id: <6060D091-874B-4ACF-9667-4827A1EDCF34@holtmann.org> (sfid-20171214_205124_174622_B8FE1AA7)
References: <1513187523-24054-1-git-send-email-jouni@qca.qualcomm.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> This commit defines new scan flags (LOW_SPAN, LOW_POWER, HIGH_LATENCY)
> to emphasize the requested scan behavior for the driver. These flags are
> optional and are mutually exclusive. Driver shall resort to default
> behavior if a respective flag is not supported. The implementation of
> the respective functionality can be driver/hardware specific.

I really dislike falling back to some unspecified default behavior in case something is not supported. That is a really bad API towards userspace. Let the driver just fail and reject that operation. Userspace can define the policy and behavior if certain low power or high accuracy functionality is not available. Asking the kernel to do one thing and then the driver does whatever it wants anyway is Wireless Extensions behavior. We complained about it back then and falling back into the same pattern is bad.

And as Dan mentioned, just indicate the capabilities to userspace and then it knows what it can use. That means a good userspace will not use unsupported flags and a bad one gets hit with an error (which is a good thing).

Regards

Marcel
