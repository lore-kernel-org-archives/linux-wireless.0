Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alcalazamora.dti2.net ([81.24.162.8]:1912 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab1ANNzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 08:55:52 -0500
Received: from [172.16.16.6] ([81.24.161.20])
	(authenticated user jorge@dti2.net)
	by alcalazamora.dti2.net (alcalazamora.dti2.net [81.24.162.8])
	(MDaemon PRO v11.0.2)
	with ESMTP id md50013082267.msg
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 14:49:08 +0100
Message-ID: <4D305453.6070307@dti2.net>
Date: Fri, 14 Jan 2011 14:49:07 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No beacons generated when you bring ath9k AP interface down and
 up.
References: <4D2FF7A4.3070106@candelatech.com> <20110114091226.GA32344@jm.kir.nu>
In-Reply-To: <20110114091226.GA32344@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Reply-To: jorge@dti2.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 14/01/2011 10:12, Jouni Malinen escribió:
> On Thu, Jan 13, 2011 at 11:13:40PM -0800, Ben Greear wrote:
>> If you have an ath9k AP interface running with hostapd, and you
>> run:  ip link set vap0 down; ip link set vap0 up;
>> then it will disable beaconing.
> 
> Yes. So what?
> 
>> I'm not sure where the problem actually lies:  Should ath9k
>> start beaconing automatically on VAP interface add?  Is
>> it up to hostapd to detect the ifdown/ifup and re-set everything
>> up properly?  Or maybe it's just a very bad idea to bounce
>> a VAP interface with 'ip link set'?
> 
> I would say it is up to whoever decided to set the interface down to
> restart hostapd.. There is a proposed patch for hostapd to do this
> automatically, but I'm yet to fully understand why one would set the
> interface down in the first place.

	I usually do it to influence routing from within quagga. Quagga have no
provisions to restart another daemons on interface state change. This is just an
example, I'm sure there are others valid use cases, so I really think that
hostapd should restart beaconing/whatever in this case.

	Regards,
		Jorge
-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- There is only so much duct tape you can put on something
  before it just becomes a giant ball of duct tape.
==============================================================

