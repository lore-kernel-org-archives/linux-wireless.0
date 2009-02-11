Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:29720 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbZBKVEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 16:04:11 -0500
Received: by rv-out-0506.google.com with SMTP id g37so73249rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 13:04:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49931D52.90904@smash-net.org>
References: <49931D52.90904@smash-net.org>
Date: Wed, 11 Feb 2009 16:04:10 -0500
Message-ID: <b6c5339f0902111304u430bce4dl3304f171ae8fbd45@mail.gmail.com> (sfid-20090211_220415_897561_6899253B)
Subject: Re: ath5k master (AP) mode
From: Bob Copeland <bcopeland@gmail.com>
To: =?ISO-8859-1?Q?Norman_Rie=DF?= <norman@smash-net.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 1:47 PM, Norman Rie=DF <norman@smash-net.org> w=
rote:
> Hello,
>
> i pulled wireless-testing kernel today and installed hostapd-0.6.7,  =
but
> it still does not work.
>
>
> iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wlan0 ; Invalid argument.

Did you apply this patch from upthread?

--- wireless-testing/drivers/net/wireless/ath5k/base.c      2009-02-10
06:11:43.186470883 +0100
+++ wireless-testing/drivers/net/wireless/ath5k/base.c.old
2008-11-14 09:36:40.000000000 +0100
@@ -522,6 +501,7 @@
       hw->wiphy->interface_modes =3D
               BIT(NL80211_IFTYPE_STATION) |
               BIT(NL80211_IFTYPE_ADHOC) |
+               BIT(NL80211_IFTYPE_AP) |
               BIT(NL80211_IFTYPE_MESH_POINT);

       hw->extra_tx_headroom =3D 2;

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
