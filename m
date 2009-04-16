Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:32826 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZDPMv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 08:51:56 -0400
Received: by fxm2 with SMTP id 2so399001fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 05:51:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090416115830.305980@gmx.net>
References: <20090416003818.GF4138@makis> <20090416115830.305980@gmx.net>
Date: Thu, 16 Apr 2009 15:51:54 +0300
Message-ID: <40f31dec0904160551p64694b85m7948d667376249b4@mail.gmail.com> (sfid-20090416_145200_647289_D2DD7711)
Subject: Re: [PATCH 6/7] ath5k: Implement antenna control
From: Nick Kossifidis <mickflemm@gmail.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: Nick Kossifidis <mick@madwifi-project.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	nbd@openwrt.org, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/16 Alina Friedrichsen <x-alina@gmx.net>:
> Hello Nick!
>
>> =C2=A0* Add code to support the various antenna scenarios supported =
by hw
>>
>> =C2=A0* For now hardcode the default scenario (single or dual omnis =
with
>> =C2=A0tx/rx diversity working and tx antenna handled by session -hw =
keeps
>> =C2=A0track on which antenna it got ack from each ap/station and map=
s each
>> =C2=A0ap/station to one of the antennas-).
>
> We should add or update an existing nl80211 call, to allow set the us=
ed antenna (multiple antennas in Draft-N?) manually, like madwifi does.=
 This is e.g. needed for long distance links.
>
> Regards
> Alina
>

Well it's more complicated than that, we can only set tx antenna when
using a sectored ap/sta scenario (else it's possible to miss rts and
self generated frames), and we can only set default antenna on
scenarios that don't update the default antenna dynamicaly. Here is a
more detailed explanation of antenna scenarios...

http://kerneltrap.org/mailarchive/linux-ath5k-devel/2008/11/26/4241174

I agree that one should be able to set rx/tx antenna from nl80211
(after all mac80211 has tx antenna information) but we also need a way
to handle antenna scenarios. Setting antennas without setting the
proper antenna scenarios will break things (as it did for mesh on the
above mail).

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
