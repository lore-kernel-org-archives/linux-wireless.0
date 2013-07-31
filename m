Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63886 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3GaRVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 13:21:48 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so1915450obb.15
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 10:21:47 -0700 (PDT)
Message-ID: <51F947A9.3050802@lwfinger.net> (sfid-20130731_192151_760092_A84995D8)
Date: Wed, 31 Jul 2013 12:21:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Schulte <schultetwin@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rtlwifi: sparse warnings: cast to restricted type
References: <1375254507-26154-1-git-send-email-schultetwin@gmail.com> <1375254507-26154-2-git-send-email-schultetwin@gmail.com>
In-Reply-To: <1375254507-26154-2-git-send-email-schultetwin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 02:08 AM, Mark Schulte wrote:
> Adding type casts to suppress sparse warnings:
>   * warning: cast to restricted __le32/__le16
>
> Signed-off-by: Mark Schulte <schultetwin@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/ps.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)

I think this patch is OK, but until I get a chance to test it on a big-endian 
machine (PowerBook G4 Titanium), please do not apply it.

When I tried the patch, I discovered some kind of regression that causes a 
kernel oops with an RTL8192CU device installed. This patch is not the problem, 
but I will need to bisect the oops before I can test. The machine takes a long 
time to build each kernel, thus it will probably be a while.

Larry

