Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:41857 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaH1Oxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 10:53:31 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 5C0B51880006
	for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 16:53:29 +0200 (CEST)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PmhQXluA1NKZ for <linux-wireless@vger.kernel.org>;
	Thu, 28 Aug 2014 16:53:11 +0200 (CEST)
Received: from [192.168.9.80] (unknown [192.168.9.80])
	by aurora.create-net.org (Postfix) with ESMTPSA id A256E1880004
	for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 16:53:11 +0200 (CEST)
Message-ID: <53FF4257.3070407@create-net.org> (sfid-20140828_165334_977410_8E8F8C5B)
Date: Thu, 28 Aug 2014 16:53:11 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Question about ieee80211_tx_info
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I noticed that if, using an interface operating in monitor
mode, I try to get the band on which the interface is configured:

struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
	
then info-> band is always 0 (IEEE80211_BAND_2GHZ) even
when the interface itself is set to channel 48 (5GHz).

Could somebody give me some pointers about where this
info should be set? The driver I;m using is ath9k.

R.

-- 
--------------------------------------------------------
Roberto Riggio, Ph.D.
CREATE-NET
Future Networks (FuN)
Senior Researcher
Via alla Cascata 56/D - 38123 Povo Trento (Italy)
e-mail: roberto.riggio@create-net.org
Tel: (+39) 0461 408400 - interno/extension 1708
Fax: (+39) 0461 421157
http://www.create-net.org/~rriggio/
--------------------------------------------------------

The information transmitted is intended only for the person or entity to
which it is addressed and may contain confidential and/or privileged
material. Any review, retransmission, dissemination or other use of, or
taking of any action in reliance upon, this information by persons or
entities other than the intended recipient is prohibited according to
the Italian Law 196/2003 of the Legislature. If you received this in
error, please contact the sender and delete the material from any
computer.

Le informazioni contenute in questo messaggio di posta elettronica e nei
file allegati sono da considerarsi strettamente riservate. Il loro
utilizzo e' consentito esclusivamente al destinatario del messaggio, per
le finalita' indicate nel messaggio stesso. Qualora riceveste questo
messaggio senza esserne il destinatario, Vi preghiamo cortesemente di
darcene notizia via e-mail e di procedere alla cancellazione del
messaggio stesso dal Vostro sistema. Trattenere il messaggio stesso,
divulgarlo anche in parte, distribuirlo ad altri soggetti, copiarlo,
od utilizzarlo per finalita' diverse, costituisce comportamento
contrario ai principi dettati dal D. Lgs. 196/2003.
