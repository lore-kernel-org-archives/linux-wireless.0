Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from torlux.gbt.tfo.upm.es ([138.4.10.78]:4801 "EHLO
	torlux.gbt.tfo.upm.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbXKSRTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 12:19:18 -0500
Message-ID: <4741C200.20500@ehas.org> (sfid-20071119_171920_982535_4F6E6B30)
Date: Mon, 19 Nov 2007 18:04:00 +0100
From: sandra <makevuy@ehas.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	madwifi-devel@lists.sourceforge.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [Madwifi-devel] How to modify acktimeout, ctstimeout and TXOP
 limits in MadWifi driver?
References: <473C1F48.5040800@ehas.org> <43e72e890711171233x735ad06t31bbdd8b7b454579@mail.gmail.com>
In-Reply-To: <43e72e890711171233x735ad06t31bbdd8b7b454579@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luis,

I'm sorry but I can understand you very well. Some questions:


>What's txop?
>
> =20
>

Is the txoplimit. Is possible to change this parameter in Wmm mode with=
=20
driver madwifi. but the maximum value of this is 8160 us.
You have been talking about registers, but I don't understand about thi=
s=20
question very well. The general idea is: acktimeout registers are=20
limiting the acktimeout value. aren't it?. The limitation then is in th=
e=20
SW and not in the HW.

Other question is the next. is 52.8 in milisecons?. How you can obtain=20
this value?.
I have tested that for AR5212 you have the next limitations for acktime=
out:

802.11ag: 370
802.11b: 740 (just 370 x 2)

Thanks for all.

>We currently do not set these values other than what is set by default
>through the initvals per mode for each baseband MAC and per mode. For
>ar5211 we set this to:
>
>        /*        a/XR        aTurbo      b           g(OFDM?)
>gTurbo (N/A) */
>        { AR5K_TIME_OUT,
>                { 0x04000400, 0x08000800, 0x20003000, 0x04000400,
>0x04000400 } },
>
>For ar5212 we set this to:
>
>        /*        a/XR        aTurbo      b           g (DYN)     gTur=
bo */
>        { AR5K_TIME_OUT,
>                { 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840,
>0x06e006e0 } },
>
>The value set seems to have to match the PLL clock. You do this by
>using ath5k_hw_htoclock() and to read from it ath5k_hw_clocktoh().
>
>Using this for 802.11g this seems to be set to 0x840 =3D 2112 (base 10=
).
>
>2112 / 40 =3D 52.8
>
>So perhaps this is an upper limit on the ACK timeout. If so what does
>this do and what is the difference in behavior between reaching a
>timeout with this value than with the specific value in the rate
>duration? I am not sure yet. I think one of them must trigger a
>retransmit. We do at least match what the HAL current does except
>remember we are currently setting the ACK bit rates to lower bit
>rates.
>
>These registers are sharply split. ACK and CTS can only use a 0x1fff
>mask of the 32 bits, which is 13 bits. For each value it leaves us
>with with the 3 Most Significant BIts as either unused or for some
>purpose we are not yet sure how to use.
>
>Hope this helps. Also if you end up testing and getting more
>information please do let us know.
>
>  Luis
>
>
> =20
>

--=20
Sandra Salmer=C3=B3n Ntutumu    <makevuy@ehas.org>
Tlf. Analog: +34 91 488 8703 / M=C3=B3vil: + 34 653 574 298
Tlf. IP desde FWD: 656212. Ext: 10 / Tel. IP desde EHAS: 010010
=46undaci=C3=B3n EHAS: Enlace Hispanoamericano de Salud - www.ehas.org
Telemedicina rural para zonas aisladas de pa=C3=ADses en desarrollo


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
