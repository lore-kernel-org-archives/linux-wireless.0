Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55680 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1LTTBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 14:01:40 -0500
Received: by ghbz12 with SMTP id z12so4370854ghb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 11:01:40 -0800 (PST)
Message-ID: <4EF0DB90.50100@lwfinger.net> (sfid-20111220_200153_589771_DF55535D)
Date: Tue, 20 Dec 2011 13:01:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] atheros-wireless: fix sparse warnings ho ho ho
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
In-Reply-To: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2011 12:46 PM, Luis R. Rodriguez wrote:
> From: Luis R. Rodriguez<mcgrof@qca.qualcomm.com>
>
> Here's a slew of sparse warning fixes for all Atheros wireless drivers.
> These have been itching me for a while now. I ask all patch submitters
> and driver maintainers to please run their patches with these two tests:
>
> make C=1 M=drivers/net/wireless/ath/
>
> And then if all is happy try:
>
> make C=2 CF="-D__CHECK_ENDIAN__" M=drivers/net/wireless/ath/

Why not follow a suggestion that Johannes made to me? Add the line

ccflags-y += -D__CHECK_ENDIAN__

To the bottom of the make file(s). That way they only need one run. Then enforce 
the rule by not ACKing any patches with too many of the endian warnings, and do 
not allow any of the others.

Larry
