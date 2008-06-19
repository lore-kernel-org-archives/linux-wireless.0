Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:25385 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYFSRUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:20:23 -0400
Received: by yx-out-2324.google.com with SMTP id 31so169209yxl.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 10:20:19 -0700 (PDT)
Subject: Re: [RFC 3/2] get rid of rx handler function pointers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213879121.8967.9.camel@johannes.berg>
References: <1213879121.8967.9.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Thu, 19 Jun 2008 10:20:16 -0700
Message-Id: <1213896016.2125.51.camel@brick> (sfid-20080619_192027_228765_5F518971)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-19 at 14:38 +0200, Johannes Berg wrote:
> Even better :)
>=20
> add/remove: 0/12 grow/shrink: 1/0 up/down: 5532/-6296 (-764)
> function                                     old     new   delta
> ieee80211_invoke_rx_handlers                 724    6256   +5532
> ieee80211_rx_handlers                         52       -     -52
> ieee80211_rx_h_mgmt                          116       -    -116
> ieee80211_rx_h_remove_qos_control            148       -    -148
> ieee80211_rx_h_passive_scan                  168       -    -168
> ieee80211_rx_h_data                          192       -    -192
> ieee80211_rx_h_ctrl                          288       -    -288
> ieee80211_rx_h_ps_poll                       440       -    -440
> ieee80211_rx_h_decrypt                       508       -    -508
> ieee80211_rx_h_check                         588       -    -588
> ieee80211_rx_h_amsdu                         872       -    -872
> ieee80211_rx_h_sta_process                   920       -    -920
> ieee80211_rx_h_defragment                   2004       -   -2004
>=20
>=20
> All three patches together give:
>=20
> add/remove: 1/23 grow/shrink: 1/2 up/down: 8924/-10404 (-1480)
> function                                     old     new   delta
> ieee80211_invoke_rx_handlers                 724    6256   +5532
> invoke_tx_handlers                             -    3392   +3392
> ieee80211_tx_handlers                         48       -     -48
> ieee80211_rx_handlers                         52       -     -52
> ieee80211_tx_h_sequence                      116       -    -116
> ieee80211_rx_h_mgmt                          116       -    -116
> ieee80211_get_buffered_bc                    620     484    -136
> ieee80211_master_start_xmit                 1152    1008    -144
> ieee80211_rx_h_remove_qos_control            148       -    -148
> ieee80211_tx_h_stats                         168       -    -168
> ieee80211_tx_h_encrypt                       168       -    -168
> ieee80211_rx_h_passive_scan                  168       -    -168
> ieee80211_rx_h_data                          192       -    -192
> ieee80211_tx_h_select_key                    256       -    -256
> ieee80211_tx_h_calculate_duration            276       -    -276
> ieee80211_rx_h_ctrl                          288       -    -288
> ieee80211_tx_h_rate_ctrl                     344       -    -344
> ieee80211_tx_h_check_assoc                   344       -    -344
> ieee80211_rx_h_ps_poll                       440       -    -440
> ieee80211_rx_h_decrypt                       508       -    -508
> ieee80211_rx_h_check                         588       -    -588
> ieee80211_tx_h_fragment                      640       -    -640
> ieee80211_tx_h_misc                          724       -    -724
> ieee80211_tx_h_ps_buf                        744       -    -744
> ieee80211_rx_h_amsdu                         872       -    -872
> ieee80211_rx_h_sta_process                   920       -    -920
> ieee80211_rx_h_defragment                   2004       -   -2004
>=20
>=20
> ---
>  net/mac80211/rx.c |   71 +++++++++++++++++++++++--------------------=
-----------
>  1 file changed, 31 insertions(+), 40 deletions(-)
>=20
> --- everything.orig/net/mac80211/rx.c	2008-06-19 14:30:13.000000000 +=
0200
> +++ everything/net/mac80211/rx.c	2008-06-19 14:36:38.000000000 +0200
> @@ -1732,66 +1732,57 @@ static void ieee80211_rx_cooked_monitor(
>  	dev_kfree_skb(skb);
>  }
> =20
> -typedef ieee80211_rx_result (*ieee80211_rx_handler)(struct ieee80211=
_rx_data *);
> -static ieee80211_rx_handler ieee80211_rx_handlers[] =3D
> -{
> -	ieee80211_rx_h_passive_scan,
> -	ieee80211_rx_h_check,
> -	ieee80211_rx_h_decrypt,
> -	ieee80211_rx_h_sta_process,
> -	ieee80211_rx_h_defragment,
> -	ieee80211_rx_h_ps_poll,
> -	ieee80211_rx_h_michael_mic_verify,
> -	/* this must be after decryption - so header is counted in MPDU mic
> -	 * must be before pae and data, so QOS_DATA format frames
> -	 * are not passed to user space by these functions
> -	 */
> -	ieee80211_rx_h_remove_qos_control,
> -	ieee80211_rx_h_amsdu,
> -	ieee80211_rx_h_data,
> -	ieee80211_rx_h_ctrl,
> -	ieee80211_rx_h_mgmt,
> -	NULL
> -};
> =20
>  static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_dat=
a *sdata,
>  					 struct ieee80211_rx_data *rx,
>  					 struct sk_buff *skb)
>  {
> -	ieee80211_rx_handler *handler;
>  	ieee80211_rx_result res =3D RX_DROP_MONITOR;
> =20
>  	rx->skb =3D skb;
>  	rx->sdata =3D sdata;
>  	rx->dev =3D sdata->dev;
> =20
> -	for (handler =3D ieee80211_rx_handlers; *handler !=3D NULL; handler=
++) {
> -		res =3D (*handler)(rx);

> =EF=BB=BF#define CALL_RXH(rxh) if ((res =3D rxh(rx)) !=3D RX_CONTINUE=
) goto rxh_done;

Would it really be so bad to just open-code them rather than the macro =
approach?

	res =3D =EF=BB=BFieee80211_rx_h_passive_scan(rx);
	if (res !=3D RX_CONTINUE) goto rxh_done;

	res =3D =EF=BB=BFieee80211_rx_h_check(rx);
	if (res !=3D RX_CONTINUE) goto rxh_done;

	...


Similar comment for the transmit handler patch.  Either way, the approa=
ch looks good,
and the size reduction is nice.

Cheers,

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
