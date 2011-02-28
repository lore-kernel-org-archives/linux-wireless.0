Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:53387 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1B1Jlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 04:41:46 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 3A05B3835F
	for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 10:34:37 +0100 (CET)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xYqJ8pM05eT0 for <linux-wireless@vger.kernel.org>;
	Mon, 28 Feb 2011 10:34:36 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 1EDAF3835C
	for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 10:32:34 +0100 (CET)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QI2uEJMczE2E for <linux-wireless@vger.kernel.org>;
	Mon, 28 Feb 2011 10:32:33 +0100 (CET)
Received: from [192.168.9.184] (unknown [192.168.9.184])
	by aurora.create-net.org (Postfix) with ESMTPSA id 31BB73832E
	for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 10:32:33 +0100 (CET)
Message-ID: <4D6B6BB0.3070500@create-net.org>
Date: Mon, 28 Feb 2011 10:32:32 +0100
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Extended presence mask ignored in injected frame
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm injecting some traffic using the Click modular router. The radiotap
header that I'm building contains four presence masks. In the first three
mask the bit 31 is set to 1 while the last masj sets the bit 31 to 0.

The problem is that only the first block is parsed by the kernel while 
the other
are ignored more precisely -ENOENT is returned when the last bit of the 
first
presence mask is found. Basically since in the second to forth blocks I'm
specifying RATE and DATA_RETRIES fields I was expecting this fields to be
processed multiple times in the tx.c file. However this is not happening and
only the first occurrences of RATE and DATA_RETRIES fields are processed.

Is anybody using frame injection with multiple presence masks and has faced
the same issue? The driver I'm using is ath5k.

R.

-- 
--------------------------------------------------------
Roberto Riggio, Ph.D.
CREATE-NET
Network&  Security Solutions for Pervasive Computing Systems (iNSPIRE)
Senior Researcher
Via alla Cascata 56/D - 38123 Povo Trento (Italy)
e-mail: roberto.riggio@create-net.org
Tel: (+39) 0461 408400 - interno/extension 708
Fax: (+39) 0461 421157
www.create-net.org/~rriggio
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

