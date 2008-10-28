Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:11127 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYJ1TIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 15:08:43 -0400
Received: by yw-out-2324.google.com with SMTP id 9so677935ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 12:08:41 -0700 (PDT)
Message-ID: <43e72e890810281201n6e119153k959283ced1abb757@mail.gmail.com> (sfid-20081028_200848_342141_46BFA8A7)
Date: Tue, 28 Oct 2008 12:01:25 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>, stable@kernel.org
Subject: Re: [PATCH] ath9k: remove useless NULL initialisers
Cc: "John Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1225209597.3598.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_39362_3856445.1225220485750"
References: <1225209597.3598.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_39362_3856445.1225220485750
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Seems you forgot to cc linux-wireless so I'll leave the entire patch
in my reply. Seems right for stable too, so sending a reduced version
which applies to it (using gmail right now, will send shortly inline).

On Tue, Oct 28, 2008 at 8:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> When I added .set_frag_threshold I didn't realise it was already
> there which now generated a sparse warning. Therefore, remove
> the .set_frag_threshold NULL initialiser, and while at it all the
> other useless ones.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ACKed-by: lrodriguez@atheros.com

  Luis

> ---
>  drivers/net/wireless/ath9k/main.c |    8 --------
>  1 file changed, 8 deletions(-)
>
> --- everything.orig/drivers/net/wireless/ath9k/main.c   2008-10-28 16:57:36.000000000 +0100
> +++ everything/drivers/net/wireless/ath9k/main.c        2008-10-28 16:57:45.000000000 +0100
> @@ -1651,20 +1651,12 @@ static struct ieee80211_ops ath9k_ops =
>        .config             = ath9k_config,
>        .config_interface   = ath9k_config_interface,
>        .configure_filter   = ath9k_configure_filter,
> -       .get_stats          = NULL,
>        .sta_notify         = ath9k_sta_notify,
>        .conf_tx            = ath9k_conf_tx,
> -       .get_tx_stats       = NULL,
>        .bss_info_changed   = ath9k_bss_info_changed,
> -       .set_tim            = NULL,
>        .set_key            = ath9k_set_key,
> -       .hw_scan            = NULL,
> -       .get_tkip_seq       = NULL,
> -       .set_rts_threshold  = NULL,
> -       .set_frag_threshold = NULL,
>        .get_tsf            = ath9k_get_tsf,
>        .reset_tsf          = ath9k_reset_tsf,
> -       .tx_last_beacon     = NULL,
>        .ampdu_action       = ath9k_ampdu_action,
>        .set_frag_threshold = ath9k_no_fragmentation,
>  };
>
>
>

------=_Part_39362_3856445.1225220485750
Content-Type: text/x-patch; name=remove-dupe-frag.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmuwlmyh0
Content-Disposition: attachment; filename=remove-dupe-frag.patch

LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoOWsvbWFpbi5jLm9yaWcJMjAwOC0xMC0yOCAx
MTo1NTo0OS4wMDAwMDAwMDAgLTA3MDAKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoOWsv
bWFpbi5jCTIwMDgtMTAtMjggMTE6NTY6MDAuMDAwMDAwMDAwIC0wNzAwCkBAIC0xMDMxLDcgKzEw
MzEsNiBAQAogCS5od19zY2FuICAgICAgICAgICAgPSBOVUxMLAogCS5nZXRfdGtpcF9zZXEgICAg
ICAgPSBOVUxMLAogCS5zZXRfcnRzX3RocmVzaG9sZCAgPSBOVUxMLAotCS5zZXRfZnJhZ190aHJl
c2hvbGQgPSBOVUxMLAogCS5zZXRfcmV0cnlfbGltaXQgICAgPSBOVUxMLAogCS5nZXRfdHNmIAkg
ICAgPSBhdGg5a19nZXRfdHNmLAogCS5yZXNldF90c2YgCSAgICA9IGF0aDlrX3Jlc2V0X3RzZiwK

------=_Part_39362_3856445.1225220485750--
