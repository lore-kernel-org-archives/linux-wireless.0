Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55523 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbHMMcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:32:19 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [NEXT,1/6] rtlwifi: rtl8192ce: rtl8192cu: Fix endian issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438635376-28114-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20150813123218.71B80140614@smtp.codeaurora.org> (sfid-20150813_143221_615454_1BD6173A)
Date: Thu, 13 Aug 2015 12:32:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Commit e996db69833a (rtlwifi: rtl8192c: Add init codes for "fw_version"
> and "fw_subversion") added initialization for fw_version, but failed to
> note that the variable in the firmware header is little-endian. The
> following Sparse warning results:
> 
>   CHECK   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    expected unsigned short [unsigned] [usertype] fw_version
> drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    got restricted __le16 [usertype] version
> 
> When fixing this problem, I noticed that several of the drivers contain
> nearly identical copies of the firmware header struct, and that only the one
> used in rtl8192c{e,u} had correct endian notation. The struct has been
> moved into a common header, and the other drivers will be fixed in
> subsequant patches.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 6 patches applied to wireless-drivers-next.git:

e41c51359918 rtlwifi: rtl8192ce: rtl8192cu: Fix endian issue
7c24d086ef9c rtlwifi: rtl8723ae: rtl8723be: rtl8723com: Fix firmware header endian issues
253f10abb7c2 rtlwifi: rtl8821ae: Fix firmware endian issues
b290b57d18aa rtlwifi: rtl8192de: Fix firmware header endian issues
201b63c7c907 rtlwifi: rtl888ee: Fix firmware header endian issues
8d882bcf8274 rtlwifi: rtl8192ee: Fix firmware header endian issues

Kalle Valo
