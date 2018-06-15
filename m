Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965641AbeFOL1G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:27:06 -0400
Date: Fri, 15 Jun 2018 13:26:42 +0200
From: Greg KH <greg@kroah.com>
To: Omer Efrat <omer.efrat@tandemg.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 5/5] staging: use BIT_ULL for NL80211_STA_INFO_*
 attribute types
Message-ID: <20180615112642.GA1011@kroah.com> (sfid-20180615_132709_389291_2EBAA8E5)
References: <1528971217-566-1-git-send-email-omer.efrat@tandemg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1528971217-566-1-git-send-email-omer.efrat@tandemg.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2018 at 01:13:37PM +0300, Omer Efrat wrote:
> Since 'filled' member in station_info changed to u64, BIT_ULL macro
> should be used with NL80211_STA_INFO_* attribute types instead of BIT.
> 
> The BIT macro uses unsigned long type which some architectures handle as 32bit
> and this results in compilation warnings such as:
> 
> net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
>   sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
>   ^
> 
> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>

Looks like this doesn't apply to the staging tree, so if this has to go
through the wireless tree, that's fine with me:

	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
