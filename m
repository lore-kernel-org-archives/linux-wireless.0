Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52166 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab2DQIJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 04:09:00 -0400
Received: by yenl12 with SMTP id l12so2904774yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 01:09:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201204162225.q3GMPTrS006633@mail.maya.org>
References: <201204162225.q3GMPTrS006633@mail.maya.org>
Date: Tue, 17 Apr 2012 10:09:00 +0200
Message-ID: <CAGXE3d8Vdg3VHKVJQ4KLK_Tje1ZCEzjESBFYDTWNAsAMTHsTVg@mail.gmail.com> (sfid-20120417_100907_713298_4C95C643)
Subject: Re: [PATCH] rt2x00: Don't let mac80211 send a BAR when an AMPDU
 subframe fails
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2012 at 12:25 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> There are connection stalls or very poor throughputs with rt2800
> hardware using 802.11n in AP mode since patch "mac80211: retry sending
> failed BAR frames later instead of tearing down aggr"[1][2].
>
> Since rt2800 hardware is not able to correctly report the tx status of
> BAR frames, this patch removes as workaround the existing error handling
> on AP side, which lets mac80211 send a BAR when an AMPDU subframe fails.
>
> As a result, most wifi clients (aside from Intel STAs on Windows)
> instead will timeout now the reorder buffer and request the lost frame
> again.
>
> The correct solution would be, to tear down BA session on AP side.
>
> This patch was born on the basis of "[RFT] rt2x00: Tear down BA
> session on QoS frame failure"[3].
>
> Thanks to Helmut Schaa for his support!
>
> [1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=83304
> [2] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=f0425beda4d404a6e751439b562100b902ba9c98
> [3] http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/569
>
> Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>

Thanks for the patch Andreas! Let's use this as a workaround for now.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
> Index: a/drivers/net/wireless/rt2x00/rt2x00dev.c
> ===================================================================================
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c   2012-02-02 22:12:56.000000000 +0100
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c   2012-04-16 23:26:46.100458775 +0200
> @@ -387,9 +387,10 @@
>                tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
>                tx_info->status.ampdu_len = 1;
>                tx_info->status.ampdu_ack_len = success ? 1 : 0;
> -
> -               if (!success)
> -                       tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
> +               /*
> +                * TODO: Need to tear down BA session here
> +                * if not successful.
> +                */
>        }
>
>        if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
