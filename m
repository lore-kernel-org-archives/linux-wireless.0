Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53325 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3BKV6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:58:55 -0500
Received: by mail-oa0-f52.google.com with SMTP id k14so6651454oag.39
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 13:58:55 -0800 (PST)
Message-ID: <5119699D.8010703@lwfinger.net> (sfid-20130211_225900_593018_9D99FA42)
Date: Mon, 11 Feb 2013 15:58:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Catalin Iacob <iacobcatalin@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Initialize rate_init member of struct rate_control_ops
References: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com>
In-Reply-To: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 03:18 PM, Catalin Iacob wrote:
> This partially reverts commit 44ba973699b831414c3f8eef68ee5a7fe1208a05.
>
> rate_control_rate_init assumes the rate_init member of
> struct rate_control_ops is not NULL therefore not initializing it leads to
> an oops as soon the driver succesfully associates to an AP.
>
> The removal of rate_update from 44ba973699b831414c3f8eef68ee5a7fe1208a05
> is ok because rate_update is checked for NULL before being
> called.
>
> Signed-off-by: Catalin Iacob <iacobcatalin@gmail.com>

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

John,

This patch should be applied. Obviously, I missed the oops in my testing.

The real fix will be to not supply any rate-control operations as suggested by 
Johannes, but that will take some time.

Larry

