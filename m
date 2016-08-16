Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34461 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbcHPPn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 11:43:57 -0400
Received: by mail-pa0-f68.google.com with SMTP id hh10so5476584pac.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 08:42:54 -0700 (PDT)
Subject: Re: [PATCH v3] nl80211: Allow GET_INTERFACE dumps to be filtered
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1471332335-9251-1-git-send-email-johannes@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <57B330B6.9090105@gmail.com> (sfid-20160816_174401_639259_E9B0D105)
Date: Tue, 16 Aug 2016 10:26:46 -0500
MIME-Version: 1.0
In-Reply-To: <1471332335-9251-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 08/16/2016 02:25 AM, Johannes Berg wrote:
> From: Denis Kenzior <denkenz@gmail.com>
>
> This patch allows GET_INTERFACE dumps to be filtered based on
> NL80211_ATTR_WIPHY or NL80211_ATTR_WDEV.  The documentation for
> GET_INTERFACE mentions that this is possible:
> "Request an interface's configuration; either a dump request on
> a %NL80211_ATTR_WIPHY or ..."
>
> However, this behavior has not been implemented until now.
>
> Johannes: rewrite most of the patch:
>   * use nl80211_dump_wiphy_parse() to also allow passing an interface
>     to be able to dump its siblings
>   * fix locking (must hold rtnl around using nl80211_fam.attrbuf)
>   * make init self-contained instead of relying on other cb->args
>
> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   net/wireless/nl80211.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
>

Looks good to me.

Regards,
-Denis
