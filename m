Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60291 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2C0OkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:40:25 -0400
Received: by yhmm54 with SMTP id m54so4653306yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2012 07:40:23 -0700 (PDT)
Message-ID: <4F71D154.3060103@lwfinger.net> (sfid-20120327_164032_470458_483DDEE2)
Date: Tue, 27 Mar 2012 09:40:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] rtlwifi: Convert drivers away from global copies
 of structures
References: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2012 01:49 PM, Larry Finger wrote:
> All the rtlwifi-family of drivers contain 1 or 2 tables that are defined
> on a "per-driver" basis. For systems that contain more than one interface,
> each instance will not have its own copy.
>
> This series of patches is to be applied to kernel 3.5.
>
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>

John,

Please drop this series of patches. I think I messed something up and will 
resubmit later.

Sorry for the noise,

Larry

>
> Larry Finger (6):
>    rtlwifi: Move dig_t and ps_t structs
>    rtlwifi: Add dm structs to private structure
>    rtlwifi: rtl8192c: Convert driver to use private dm structs
>    rtlwifi: rtl8192c: Convert driver to use private ps_t struct
>    rtlwifi: rtl8192de: Convert driver to use private dm structs
>    rtlwifi: rtl8192se: Convert driver to use private dm structs
>
>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |   22 ++++++-
>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |   35 -----------
>   drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    1 +
>   drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |   35 -----------
>   drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |   11 +++-
>   drivers/net/wireless/rtlwifi/rtl8192de/dm.h        |   51 ----------------
>   drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    1 +
>   drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |    6 ++-
>   drivers/net/wireless/rtlwifi/rtl8192se/dm.h        |   44 --------------
>   drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |    1 +
>   drivers/net/wireless/rtlwifi/wifi.h                |   63 ++++++++++++++++++++
>   11 files changed, 99 insertions(+), 171 deletions(-)
>

