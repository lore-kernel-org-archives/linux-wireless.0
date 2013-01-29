Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36586 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3A2X4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:56:25 -0500
Received: by mail-wg0-f41.google.com with SMTP id ds1so2449273wgb.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 15:56:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359503255-18270-8-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com> <1359503255-18270-8-git-send-email-seth.forshee@canonical.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 30 Jan 2013 10:56:03 +1100
Message-ID: <CAGRGNgUTSL105OQvF7=W_2CZHWsS-NohJ-tKWfNwVZNuBEJP9A@mail.gmail.com> (sfid-20130130_005628_121567_FB8365B2)
Subject: Re: [PATCH 7/7] brcmsmac: Add support for off-channel powersave
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth,

On Wed, Jan 30, 2013 at 10:47 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> Broadcom hardware sets the value of the PM flag in frame control based
> on the value of MCTL_HPS, which seems to include actively clearing PM
> if MCTL_HPS is not set. brcmsmac needs to suppor the off-channel
> powersave state in order to enable powersave at the AP at all.
>
> Add limited support for powersave to brcmsmac to prevent frame loss
> during background scans. Full powersave supoprt remains unimplemented,
> but switching between the off-channel and disabled states is possible.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   15 +++++++++++----
>  drivers/net/wireless/brcm80211/brcmsmac/main.c     |    9 +++++++++
>  drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    1 +
>  3 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index c26992a..3fb71c9 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -7545,6 +7549,11 @@ void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
>                 brcms_c_bcn_li_upd(wlc);
>  }
>
> +void brcms_c_set_ps(struct brcms_c_info *wlc)
> +{
> +       brcms_c_set_ps_ctrl(wlc);
> +}
> +

Why not just use brcms_c_set_ps_ctrl() directly?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
