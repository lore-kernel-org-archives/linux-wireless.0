Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44719 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3HWPEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 11:04:50 -0400
Received: by mail-ie0-f172.google.com with SMTP id c10so1003327ieb.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 08:04:50 -0700 (PDT)
Date: Fri, 23 Aug 2013 10:04:47 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3.11] mac80211: ignore (E)CSA in probe response frames
Message-ID: <20130823150447.GB9274@thinkpad-t410> (sfid-20130823_170453_418966_3170C1FF)
References: <1377265924-19012-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377265924-19012-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 23, 2013 at 03:52:04PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Seth reports that some APs, notably the Netgear WNDAP360, send
> invalid ECSA IEs in probe response frames with the operating
> class and channel number both set to zero, even when no channel
> switch is being done. As a result, any scan while connected to
> such an AP results in the connection being dropped.
> 
> Fix this by ignoring any channel switch announcment in probe
> response frames entirely, since we're connected to the AP we
> will be receiving a beacon (and maybe even an action frame) if
> a channel switch is done, which is sufficient.
> 
> Cc: stable@vger.kernel.org # 3.10
> Reported-by: Seth Forshee <seth.forshee@canonical.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

This fixes the problem. Thanks Johannes!

Tested-by: Seth Forshee <seth.forshee@canonical.com>

