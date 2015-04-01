Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36323 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbDAGGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 02:06:06 -0400
Received: by iedm5 with SMTP id m5so35028829ied.3
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 23:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426143210-25635-7-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
	<1426143210-25635-7-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 1 Apr 2015 08:06:05 +0200
Message-ID: <CALhHN=qkEmUPEL2XBuuudmq6Rg-6s7jm0TOdRuQCetgSiKyrpg@mail.gmail.com> (sfid-20150401_080610_585543_9C59BF64)
Subject: Re: [PATCH 7/7] mac80211: Count correctly interface types
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 March 2015 at 07:53, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
>
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>
> Previously, interface combination check in mac80211 considered only
> interfaces that have channel context. This wouldn't take P2P device interfaces
> into account at all. Also for managed interfaces the channel context is bound
> upon association and the combination check is performed when the iface is
> brought up.
> Fix this by counting the numbers of running interfaces instead of number of
> interfaces that have channel context.
>
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index e664b28..36d8cb2 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -3245,7 +3245,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
>                 wdev_iter = &sdata_iter->wdev;
>
>                 if (sdata_iter == sdata ||
> -                   rcu_access_pointer(sdata_iter->vif.chanctx_conf) == NULL ||
> +                   !ieee80211_sdata_running(sdata_iter) ||
>                     local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
>                         continue;
>
Hello,

Seems this one break IBSS case when started from wpa_supplicant at
least for Intel7260 and ath10k where dedicated p2p_device is used.

This is wpa_supplicant log:
1427867673.149187: nl80211: Set mode ifindex 8 iftype 1 (ADHOC)
1427867673.149225: nl80211: Mode change succeeded while interface is down
1427867673.149234: Could not set interface wlan3 flags (UP): Device or
resource busy
1427867673.149237: nl80211: Failed to set interface up after switching mode
1427867673.149238: nl80211: Interface mode change to 1 from 1 failed
1427867673.149240: nl80211: Failed to set interface into IBSS mode
1427867673.149251: wlan3: Association request to the driver failed

BR
Janusz
