Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp29.msg.oleane.net ([62.161.4.29]:50279 "EHLO
	smtp29.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3D2JlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:41:16 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Thomas Pedersen'" <thomas@cozybit.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A3190152C98B@sbs2003.acksys.local> <CAG6hwVN5LRVgchuX7QQWKEioBxTz3WXO5JUVv7fE3_X5LKXayg@mail.gmail.com> <00ad01ce3f30$7ba5da10$72f18e30$@acksys.fr> <CAG6hwVNrPdCtfdA3xDHAAqz=i_GegVReba9HOxYrw0VOgdcP+g@mail.gmail.com>
In-Reply-To: <CAG6hwVNrPdCtfdA3xDHAAqz=i_GegVReba9HOxYrw0VOgdcP+g@mail.gmail.com>
Subject: RE: Mutli vif in mesh mode
Date: Mon, 29 Apr 2013 11:41:13 +0200
Message-ID: <015101ce44bd$b0026de0$100749a0$@acksys.fr> (sfid-20130429_114120_188227_38210760)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi Thomas, 

	I do not know if I will have a time this week to test it. 

	I come back to you when I have tested this modification.

	Thanks for your help.

Cedric Voncken | R&d Engineer
----------------------------------------------------------------------------
------------------------------
T : +33 1 30 56 46 52 
cedric.voncken@acksys.fr | www.acksys.fr
----------------------------------------------------------------------------
------------------------------

           
ZA Val Joyeux - 10 rue des Entrepreneurs - 78450 VILLEPREUX - France
----------------------------------------------------------------------------
----------


-----Message d'origine-----
De : linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] De la part de Thomas Pedersen
Envoyé : vendredi 26 avril 2013 18:07
À : voncken
Cc : linux-wireless
Objet : Re: Mutli vif in mesh mode

Hi Cedric,

On Mon, Apr 22, 2013 at 1:07 AM, voncken <cedric.voncken@acksys.fr> wrote:
>         Thanks Thomas for your answer,
>
>         In ath9k_hw_beaconinit() the mesh mode use the hadhoc beacon 
> mode. I try to change it, and  ath9k_set_beacon in 
> driver/net/Wireless/ath/ath9k/beacon.c, but after these modifications, 
> no beacon are sent (I think my change are wrong).
>
>         Could you give me the old patch, I can try to update it with 
> the latest compat, and I will send to you an updated patch.

Sorry for the late response.

You need to change the hardware operating mode in
ath9k_hw_set_operating_mode() to AP as well. See [1] and please let me know
if that helps.

[1]
https://github.com/cozybit/open80211s/commit/380bf3ad4c2ccd92658943e978f8d94
2611a3d6d

--
Thomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

