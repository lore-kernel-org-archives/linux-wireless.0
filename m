Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:38084 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbbBSV27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 16:28:59 -0500
Received: by wesw55 with SMTP id w55so2240001wes.5
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 13:28:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 20 Feb 2015 02:58:38 +0530
Message-ID: <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com> (sfid-20150219_222907_540544_14913882)
Subject: Re: Connection issues with BW Tracking in mac80211
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2015 at 1:00 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> Hi Johannes,
>
> The BW tracking feature in mac80211 is causing connection problems and
> operating mode/bw problems when switching b/w modes and bw's in AP.
>
> For Eg. Initially if AP is operating in VHT-80MHz, and then we changed
> in to HT-40MHz, mac80211 cannot handle it because the VHT capability
> is mismatched b/w stored info (ifmgd->flags).
>
> I have tried your DISABLE_BW_TRACK patch, that helps making the
> connection but it doesn't update the chipset causing issues.
>
> Ideally we should be able to handle all the config changes right?

Before that i have a basic question? Should we reset our tracking after
the connection is lost, in my case above the connection was lost (Config
change in A triggers a reboot), still mac80211 is tracking the BW changes?
