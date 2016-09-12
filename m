Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:44764 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754119AbcILH1f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 03:27:35 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH] rtlbt: Add RTL8822BE Bluetooth device
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1473433325-25311-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Mon, 12 Sep 2016 09:27:38 +0200
Cc: Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        =?utf-8?B?6ZmG5pyx5Lyf?= <alex_lu@realsil.com.cn>
Message-Id: <0B750089-0CEE-4D43-A889-F65F0FF62115@holtmann.org> (sfid-20160912_092739_654182_EFC2566F)
References: <1473433325-25311-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> The RTL8822BE is a new Realtek wifi and BT device. Support for the BT
> part is hereby added.
> 
> As this device is similar to most of the other Realtek BT devices, the
> changes are minimal. The main difference is that the 8822BE needs a
> configuration file for enabling and disabling features. Thus code is
> added to select and load this configuration file. Although not needed
> at the moment, hooks are added for the other devices that might need
> such configuration files.
> 
> One additional change is to the routine that tests that the project
> ID contained in the firmware matches the hardware. As the project IDs
> are not sequential, continuing to use the position in the array as the
> expected value of the ID would require adding extra unused entries in
> the table, and any subsequant rearrangment of the array would break the
> code. To fix these problems, the array elements now contain both the
> hardware ID and the expected value for the project ID.
> 
> Signed-off-by: 陆朱伟 <alex_lu@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> drivers/bluetooth/btrtl.c | 104 ++++++++++++++++++++++++++++++++++++++++------
> drivers/bluetooth/btrtl.h |   5 +++
> 2 files changed, 97 insertions(+), 12 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel
