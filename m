Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35034 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbbKMJtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 04:49:10 -0500
Received: by igl9 with SMTP id 9so12297727igl.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 01:49:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net> <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 13 Nov 2015 20:48:50 +1100
Message-ID: <CAGRGNgUr=ygLh-B1ZZ5ojPeRJVXCEbY3dniAtXZq_29DZzqjCw@mail.gmail.com> (sfid-20151113_104917_989701_911D22D2)
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide unnecessary code
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, Nov 13, 2015 at 9:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There are many drivers with different behaviour, but in a lot of
> systems only a single driver will ever be built. In that case we
> can get rid of code paths that this driver doesn't need and also
> optimize the ones that it always takes to not have a check.
>
> To make that possible, make use Kconfig counters to
>  (a) the number of times each feature flag was desired
>  (b) the number of mac80211 drivers built
> and use Kconfig selects to select those flags that any drivers
> need to be dynamic (e.g. if they can only determine this flag's
> setting at runtime.)
>
> If the dynamic request isn't set then
>
>  if (a) > 0 then it was requested ON by at least one driver
>  if (a) < (b) then it was requested OFF by at least one driver
>
> This allows determining whether or not it's safe to elide some
> code entirely.
>
> For added safety, add a HW registration time check for it.
>
> With our iwlwifi/mvm driver, this reduces mac80211's code size
> by just over 6KB (on x86/64), or about 1%. It's not that much,
> but a fair amount of it (just under 1KB) is in the TX/RX/status
> paths which are the hottest code in mac80211.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/Kconfig                  |  20 ++++
>  drivers/net/wireless/ath/ar5523/Kconfig       |   2 +
>  drivers/net/wireless/ath/ath10k/Kconfig       |   2 +
>  drivers/net/wireless/ath/ath9k/Kconfig        |   2 +
>  drivers/net/wireless/ath/wcn36xx/Kconfig      |   2 +
>  drivers/net/wireless/b43/Kconfig              |   2 +
>  drivers/net/wireless/b43legacy/Kconfig        |   2 +
>  drivers/net/wireless/brcm80211/Kconfig        |   2 +
>  drivers/net/wireless/cw1200/Kconfig           |   2 +
>  drivers/net/wireless/iwlegacy/Kconfig         |   4 +
>  drivers/net/wireless/iwlwifi/Kconfig          |   4 +
>  drivers/net/wireless/mediatek/mt7601u/Kconfig |   2 +
>  drivers/net/wireless/p54/Kconfig              |   2 +
>  drivers/net/wireless/realtek/rtl818x/Kconfig  |   4 +
>  drivers/net/wireless/realtek/rtl8xxxu/Kconfig |   2 +
>  drivers/net/wireless/realtek/rtlwifi/Kconfig  |   2 +
>  drivers/net/wireless/rsi/Kconfig              |   2 +
>  drivers/net/wireless/rt2x00/Kconfig           |   2 +
>  drivers/net/wireless/ti/wl1251/Kconfig        |   2 +
>  drivers/net/wireless/ti/wl12xx/Kconfig        |   2 +
>  drivers/net/wireless/ti/wl18xx/Kconfig        |   2 +
>  drivers/staging/vt6655/Kconfig                |   2 +
>  drivers/staging/vt6656/Kconfig                |   2 +
>  include/net/mac80211.h                        |  36 +++++-
>  net/mac80211/Kconfig                          |   9 ++
>  net/mac80211/Kconfig.hwflags                  | 160 ++++++++++++++++++++++++++
>  net/mac80211/Makefile                         |   3 +-
>  net/mac80211/main.c                           |  25 ++++
>  28 files changed, 296 insertions(+), 7 deletions(-)
>  create mode 100644 net/mac80211/Kconfig.hwflags
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index f9f94229bf1b..873b6c7b18b8 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -35,6 +35,8 @@ config PCMCIA_RAYCS
>  config LIBERTAS_THINFIRM
>         tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
>         depends on MAC80211
> +       count MAC80211_NUM_DRIVERS
> +       select MAC80211_DRIVER_NO_HWFLAGS

Am I missing something or are you not actually doing anything with
MAC80211_DRIVER_NO_HWFLAGS?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
